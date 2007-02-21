Return-Path: <linux-kernel-owner+w=401wt.eu-S1751144AbXBUGX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751144AbXBUGX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 01:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751140AbXBUGX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 01:23:57 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40250 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbXBUGXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 01:23:55 -0500
Message-ID: <45DBE559.8080903@osdl.org>
Date: Tue, 20 Feb 2007 22:23:21 -0800
From: Stephen Hemminger <shemminger@osdl.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: James Ketrenos <jketreno@linux.intel.com>, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net
Subject: iwlwifi warnings
References: <45CCE3CA.4050904@linux.intel.com> <20070213181313.GA5350@ucw.cz> <45D254C6.7050401@linux.intel.com> <20070219224432.GD21199@elf.ucw.cz>
In-Reply-To: <20070219224432.GD21199@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

BUilding with sparse shows lots of warnings.


$ make C=1
Checking kernel compatibility in:
    /lib/modules/2.6.20.1/source
 * Kernel supports required features for 'tip' version.
Building compatibility version in 'compatible/' directory:
Copying compatible/ from origin/...done
make -C /lib/modules/2.6.20.1/build M=/home/shemminger/src/iwlwifi-0.0.8 
modules
make[1]: Entering directory `/home/shemminger/kernel/linux-2.6.20.1'
  CHECK   /home/shemminger/src/iwlwifi-0.0.8/compatible/base.c
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:11115:12: warning: 
function 'ipw_rate_scale_clear_window' with external linkage has definition
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:11352:12: warning: 
function 'ipw_collect_tx_data' with external linkage has definition
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:11480:12: warning: 
function 'ipw_convert_to_rate_index' with external linkage has definition
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:11665:12: warning: 
function 'ipw_convert_to_phy_index' with external linkage has definition
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:11677:30: warning: 
function 'ipw_get_lowest_rate' with external linkage has definition
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:11692:12: warning: 
function 'ipw_get_adjacent_rate' with external linkage has definition
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:1522:11: warning: 
Using plain integer as NULL pointer
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:10004:16: warning: 
Using plain integer as NULL pointer
  CC [M]  /home/shemminger/src/iwlwifi-0.0.8/compatible/base.o
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c: In function 
$-1òøipw_rx_handleòù:
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:8175: warning: 
unused variable $-1òøsleepòù
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:8195: warning: 
unused variable $-1òøbeaconòù
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:8227: warning: 
unused variable $-1òønotifòù
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:8259: warning: 
unused variable $-1òønotifòù
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c: At top level:
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:3889: warning: 
$-1òøipw_set_rxon_confòù defined but not used
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:2523: warning: 
$-1òøipw_rate_ieee2indexòù defined but not used
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:2577: warning: 
$-1òøipw_check_rx_config_cmdòù defined but not used
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:3628: warning: 
$-1òøipw_setup_rxon_timingòù defined but not used
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:6931: warning: 
$-1òøipw_send_qos_params_commandòù defined but not used
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:7964: warning: 
$-1òøget_tx_fail_reasonòù defined but not used
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:8637: warning: 
$-1òøipw_get_rate_by_rssiòù defined but not used
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:10371: warning: 
$-1òød_hw_scanòù defined but not used
  LD [M]  /home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.o
  Building modules, stage 2.
  MODPOST 1 modules
WARNING: "ieee80211_rx_irqsafe" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "ieee80211_register_hwmode" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "ieee80211_unregister_hw" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "ieee80211_scan_completed" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "ieee80211_get_hdrlen" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "ieee80211_tx_status" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "sta_info_get" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "ieee80211_rate_control_register" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "ieee80211_netif_oper" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "ieee80211_tx_status_irqsafe" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "ieee80211_get_hdrlen_from_skb" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "ieee80211_rate_control_unregister" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "ieee80211_register_hw" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "ieee80211_alloc_hw" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "ieee80211_free_hw" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "sta_info_put" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
  CC      /home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.mod.o8$ 
make C=1
Checking kernel compatibility in:
    /lib/modules/2.6.20.1/source
 * Kernel supports required features for 'tip' version.
Building compatibility version in 'compatible/' directory:
Copying compatible/ from origin/...done
make -C /lib/modules/2.6.20.1/build M=/home/shemminger/src/iwlwifi-0.0.8 
modules
make[1]: Entering directory `/home/shemminger/kernel/linux-2.6.20.1'
  CHECK   /home/shemminger/src/iwlwifi-0.0.8/compatible/base.c
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:11115:12: warning: 
function 'ipw_rate_scale_clear_window' with external linkage has definition
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:11352:12: warning: 
function 'ipw_collect_tx_data' with external linkage has definition
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:11480:12: warning: 
function 'ipw_convert_to_rate_index' with external linkage has definition
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:11665:12: warning: 
function 'ipw_convert_to_phy_index' with external linkage has definition
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:11677:30: warning: 
function 'ipw_get_lowest_rate' with external linkage has definition
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:11692:12: warning: 
function 'ipw_get_adjacent_rate' with external linkage has definition
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:1522:11: warning: 
Using plain integer as NULL pointer
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:10004:16: warning: 
Using plain integer as NULL pointer
  CC [M]  /home/shemminger/src/iwlwifi-0.0.8/compatible/base.o
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c: In function 
$-1òøipw_rx_handleòù:
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:8175: warning: 
unused variable $-1òøsleepòù
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:8195: warning: 
unused variable $-1òøbeaconòù
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:8227: warning: 
unused variable $-1òønotifòù
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:8259: warning: 
unused variable $-1òønotifòù
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c: At top level:
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:3889: warning: 
$-1òøipw_set_rxon_confòù defined but not used
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:2523: warning: 
$-1òøipw_rate_ieee2indexòù defined but not used
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:2577: warning: 
$-1òøipw_check_rx_config_cmdòù defined but not used
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:3628: warning: 
$-1òøipw_setup_rxon_timingòù defined but not used
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:6931: warning: 
$-1òøipw_send_qos_params_commandòù defined but not used
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:7964: warning: 
$-1òøget_tx_fail_reasonòù defined but not used
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:8637: warning: 
$-1òøipw_get_rate_by_rssiòù defined but not used
/home/shemminger/src/iwlwifi-0.0.8/compatible/base.c:10371: warning: 
$-1òød_hw_scanòù defined but not used
  LD [M]  /home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.o
  Building modules, stage 2.
  MODPOST 1 modules
WARNING: "ieee80211_rx_irqsafe" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "ieee80211_register_hwmode" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "ieee80211_unregister_hw" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "ieee80211_scan_completed" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "ieee80211_get_hdrlen" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "ieee80211_tx_status" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "sta_info_get" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "ieee80211_rate_control_register" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "ieee80211_netif_oper" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "ieee80211_tx_status_irqsafe" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "ieee80211_get_hdrlen_from_skb" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "ieee80211_rate_control_unregister" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "ieee80211_register_hw" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "ieee80211_alloc_hw" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "ieee80211_free_hw" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
WARNING: "sta_info_put" 
[/home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko] undefined!
  CC      /home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.mod.o
  LD [M]  /home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko
make[1]: Leaving directory `/home/shemminger/kernel/linux-2.6.20.1'

  LD [M]  /home/shemminger/src/iwlwifi-0.0.8/compatible/iwlwifi.ko
make[1]: Leaving directory `/home/shemminger/kernel/linux-2.6.20.1'

