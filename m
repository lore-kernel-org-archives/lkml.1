Return-Path: <linux-kernel-owner+w=401wt.eu-S1759815AbYHOR0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759815AbYHOR0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 13:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbYHOR0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 13:26:14 -0400
Received: from ctb-mesg7.saix.net ([196.25.240.77]:55854 "EHLO
	ctb-mesg7.saix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbYHOR0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 13:26:14 -0400
X-Greylist: delayed 2724 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Aug 2008 13:26:13 EDT
Message-ID: <48A5B093.5060102@kroon.co.za>
Date: Fri, 15 Aug 2008 18:36:35 +0200
From: Jaco Kroon <jaco@kroon.co.za>
User-Agent: Thunderbird 2.0.0.14 (X11/20080714)
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: =?ISO-8859-1?Q?=22J=2EA=2E_Magall=F3n=22?= <jamagallon@ono.com>,
       "ath5k-devel@lists.ath5k.org" <ath5k-devel@venema.h4ckr.net>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
References: <20080815015131.39bb20ef@werewolf.home>	<200808150228.50473.elendil@planet.nl>	<20080815102151.4859f1ea@werewolf.home> <b6c5339f0808150639h204234e0pbffcc09bbb43203@mail.gmail.com>
In-Reply-To: <b6c5339f0808150639h204234e0pbffcc09bbb43203@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-report: Relay access (xacatecas.lan).
Subject: Re: [ath5k-devel] ath5k on the Acer Aspire One
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Copeland wrote:
> On Fri, Aug 15, 2008 at 4:21 AM, J.A. Magallón <jamagallon@ono.com> wrote:
>> I'm using 2.6.26.2 from Mandriva cooker.
>>
>> I'm also thinking its a soft/encryption problem:
> 
> The encryption fixes I know about for WPA should already be in 2.6.26.  But
> ath5k uses mac80211 for encryption so if it is encryption related, then it's
> in the interface code between them, or else more wireless cards would have
> the problem.

Is this using WPA-PSK or WPA-EAP?  I know my card works with PSK but I'm 
seeing similar results with EAP.  Haven't had time to properly analyze 
the problem yet and my AP is in the office for the weekend.

Regards,
Jaco Kroon

> 
>> one:~# wpa_supplicant -iwlan0 -c/etc/wpa_supplicant.conf -Dwext -d
>> Initializing interface 'wlan0' conf '/etc/wpa_supplicant.conf' driver 'wext' ctrl_interface 'N/A' bridge 'N/A'
>> Configuration file '/etc/wpa_supplicant.conf' -> '/etc/wpa_supplicant.conf'
>> Reading configuration file '/etc/wpa_supplicant.conf'
>> ctrl_interface='/var/run/wpa_supplicant'
>> eapol_version=1
>> ap_scan=1
>> fast_reauth=1
>> Line 771: removed CCMP from group cipher list since it was not allowed for pairwise cipher
>> Priority group 0
>>   id=0 ssid='werewolf'
>> Initializing interface (2) 'wlan0'
>> SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
>>  capabilities: key_mgmt 0xf enc 0xf
>> WEXT: Operstate: linkmode=1, operstate=5
>> Own MAC address: 00:1f:e2:bc:8c:01
>> wpa_driver_wext_set_wpa
>> wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
>> wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
>> wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
>> wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
>> wpa_driver_wext_set_countermeasures
>> ioctl[SIOCSIWAUTH]: Operation not supported
>> WEXT auth param 4 value 0x0 - wpa_driver_wext_set_drop_unencrypted
>> RSN: flushing PMKID list in the driver
>> Setting scan request: 0 sec 100000 usec
>> EAPOL: SUPP_PAE entering state DISCONNECTED
>> EAPOL: KEY_RX entering state NO_KEY_RECEIVE
>> EAPOL: SUPP_BE entering state INITIALIZE
>> EAP: EAP entering state DISABLED
>> Added interface wlan0
>> RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
>> Wireless event: cmd=0x8b06 len=8
>> State: DISCONNECTED -> SCANNING
>> Starting AP scan (broadcast SSID)
>> Trying to get current scan results first without requesting a new scan to speed up initial association
>> Received 0 bytes of scan results (0 BSSes)
>> CTRL-EVENT-SCAN-RESULTS
>> Selecting BSS from priority group 0
>> Try to find WPA-enabled AP
>> Try to find non-WPA AP
>> No suitable AP found.
>> Setting scan request: 0 sec 0 usec
>> Starting AP scan (broadcast SSID)
>> Scan requested (ret=0) - scan timeout 5 seconds
>> EAPOL: disable timer tick
>> RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
>> Wireless event: cmd=0x8b19 len=8
>> Received 0 bytes of scan results (0 BSSes)
>> CTRL-EVENT-SCAN-RESULTS
>> Selecting BSS from priority group 0
>> Try to find WPA-enabled AP
>> Try to find non-WPA AP
>> No suitable AP found.
>> ...
> 
> It looks like you didn't get any scan results.  Does 'iwlist wlan0 scan'
> work?
> 
> CCing ath5k-devel, you'll probably get more help there.
> 

