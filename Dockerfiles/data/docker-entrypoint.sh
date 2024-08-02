#!/usr/bin/env bash

set -e
set -u
set -o pipefail

###
### Globals
###

# Set via Dockerfile
# MY_USER
# MY_GROUP
# HTTPD_START
# HTTPD_RELOAD

# OpenSSL Certificate Authority file to generate
CA_KEY=/ca/_blnsoftware_com.key
CA_CRT=/ca/_blnsoftware_com.crt
CA_CA=/ca/_blnsoftware_com_ca.crt


# Path to scripts to source
CONFIG_DIR="/docker-entrypoint.d"


###
### Source libs
###
init="$( find "${CONFIG_DIR}" -name '*.sh' -type f | sort -u )"
for f in ${init}; do
	# shellcheck disable=SC1090
	. "${f}"
done



#############################################################
## Basic Settings
#############################################################

###
### Set Debug level
###
DEBUG_LEVEL="$( env_get "DEBUG_ENTRYPOINT" "0" )"
log "info" "Debug level: ${DEBUG_LEVEL}" "${DEBUG_LEVEL}"

DEBUG_RUNTIME="$( env_get "DEBUG_RUNTIME" "0" )"
log "info" "Runtime debug: ${DEBUG_RUNTIME}" "${DEBUG_LEVEL}"


###
### Change uid/gid
###
#set_uid "NEW_UID" "${MY_USER}"  "${DEBUG_LEVEL}"
#set_gid "NEW_GID" "${MY_GROUP}" "${DEBUG_LEVEL}"


###
### Set timezone
###
set_timezone "TIMEZONE" "${DEBUG_LEVEL}"



#############################################################
## Variable exports
#############################################################

###
### Ensure Docker_LOGS is exported
###
export_docker_logs "DOCKER_LOGS" "${DEBUG_LEVEL}"


###
### Ensure PHP-FPM variables are exported
###
export_php_fpm_compat "COMPAT" "${DEBUG_LEVEL}"
export_php_fpm_enable "PHP_FPM_ENABLE" "${DEBUG_LEVEL}"
export_php_fpm_server_addr "PHP_FPM_SERVER_ADDR" "${DEBUG_LEVEL}"
export_php_fpm_server_port "PHP_FPM_SERVER_PORT" "${DEBUG_LEVEL}"
export_php_fpm_timeout "PHP_FPM_TIMEOUT" "${DEBUG_LEVEL}"

###
### Ensure global main/mass variables are eported
###
export_http2_enable "HTTP2_ENABLE" "${DEBUG_LEVEL}"

################################################################################
# RUN
################################################################################

###
### Start
###
log "info" "Starting webserver" "${DEBUG_LEVEL}"
exec ${HTTPD_START}
