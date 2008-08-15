Return-Path: <linux-kernel-owner+w=401wt.eu-S1756625AbYHOIWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbYHOIWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 04:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbYHOIV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 04:21:57 -0400
Received: from smtp.ono.com ([62.42.230.12]:46685 "EHLO resmaa01.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752530AbYHOIV4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 04:21:56 -0400
Date: Fri, 15 Aug 2008 10:21:51 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ath5k on the Acer Aspire One
Message-ID: <20080815102151.4859f1ea@werewolf.home>
In-Reply-To: <200808150228.50473.elendil@planet.nl>
References: <20080815015131.39bb20ef@werewolf.home>
 <200808150228.50473.elendil@planet.nl>
X-Mailer: Claws Mail 3.5.0cvs31 (GTK+ 2.13.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2008 02:28:49 +0200, Frans Pop <elendil@planet.nl> wrote:

> J.A. Magallón wrote:
> > I have just got a One, and have installed a standard distro (not
> > Linpus),  Mandriva in my case. 
> > 
> > Everything works pretty nicely but WiFi. Hardware is:
> 
> The ath5k driver has been improved a lot in recent kernel releases and for 
> me it only started working properly with WEP and WPA with kernel version 
> 2.6.26. So please retry with that kernel version.
> 
> Cheers,
> FJP

I'm using 2.6.26.2 from Mandriva cooker.

I'm also thinking its a soft/encryption problem:

one:~# wpa_supplicant -iwlan0 -c/etc/wpa_supplicant.conf -Dwext -d
Initializing interface 'wlan0' conf '/etc/wpa_supplicant.conf' driver 'wext' ctrl_interface 'N/A' bridge 'N/A'
Configuration file '/etc/wpa_supplicant.conf' -> '/etc/wpa_supplicant.conf'
Reading configuration file '/etc/wpa_supplicant.conf'
ctrl_interface='/var/run/wpa_supplicant'
eapol_version=1
ap_scan=1
fast_reauth=1
Line 771: removed CCMP from group cipher list since it was not allowed for pairwise cipher
Priority group 0
   id=0 ssid='werewolf'
Initializing interface (2) 'wlan0'
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
  capabilities: key_mgmt 0xf enc 0xf
WEXT: Operstate: linkmode=1, operstate=5
Own MAC address: 00:1f:e2:bc:8c:01
wpa_driver_wext_set_wpa
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_countermeasures
ioctl[SIOCSIWAUTH]: Operation not supported
WEXT auth param 4 value 0x0 - wpa_driver_wext_set_drop_unencrypted
RSN: flushing PMKID list in the driver
Setting scan request: 0 sec 100000 usec
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
Added interface wlan0
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
Wireless event: cmd=0x8b06 len=8
State: DISCONNECTED -> SCANNING
Starting AP scan (broadcast SSID)
Trying to get current scan results first without requesting a new scan to speed up initial association
Received 0 bytes of scan results (0 BSSes)
CTRL-EVENT-SCAN-RESULTS
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No suitable AP found.
Setting scan request: 0 sec 0 usec
Starting AP scan (broadcast SSID)
Scan requested (ret=0) - scan timeout 5 seconds
EAPOL: disable timer tick
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
Wireless event: cmd=0x8b19 len=8
Received 0 bytes of scan results (0 BSSes)
CTRL-EVENT-SCAN-RESULTS
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No suitable AP found.
...


-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam18 (gcc 4.3.1 20080626 (GCC) #1 SMP
