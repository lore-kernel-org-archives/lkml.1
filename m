Return-Path: <linux-kernel-owner+w=401wt.eu-S1757979AbYHONjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbYHONjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 09:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbYHONjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 09:39:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:41178 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbYHONjq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 09:39:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=k+TszmXaypL04t7NeT8FNBTqog7F/xUKbd3rv+MSFD96qMoB14lwRY+xd5/MiA+XeA
         djfWw+6nTQoXPvxr3ElNBU5lXUYDhxo1cLDUoa9l1bj96bnxv+kpfxrEFSU3dd75xCoO
         b/kWFD8oW7j4gSmlvqHmpLEjCHHxc6b/mV+0s=
Message-ID: <b6c5339f0808150639h204234e0pbffcc09bbb43203@mail.gmail.com>
Date: Fri, 15 Aug 2008 09:39:45 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "=?ISO-8859-1?Q?J.A._Magall=F3n?=" <jamagallon@ono.com>
Subject: Re: ath5k on the Acer Aspire One
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       "ath5k-devel@lists.ath5k.org" <ath5k-devel@venema.h4ckr.net>
In-Reply-To: <20080815102151.4859f1ea@werewolf.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080815015131.39bb20ef@werewolf.home>
	 <200808150228.50473.elendil@planet.nl>
	 <20080815102151.4859f1ea@werewolf.home>
X-Google-Sender-Auth: 4d3247e6880617c5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 4:21 AM, J.A. Magallón <jamagallon@ono.com> wrote:
> I'm using 2.6.26.2 from Mandriva cooker.
>
> I'm also thinking its a soft/encryption problem:

The encryption fixes I know about for WPA should already be in 2.6.26.  But
ath5k uses mac80211 for encryption so if it is encryption related, then it's
in the interface code between them, or else more wireless cards would have
the problem.

> one:~# wpa_supplicant -iwlan0 -c/etc/wpa_supplicant.conf -Dwext -d
> Initializing interface 'wlan0' conf '/etc/wpa_supplicant.conf' driver 'wext' ctrl_interface 'N/A' bridge 'N/A'
> Configuration file '/etc/wpa_supplicant.conf' -> '/etc/wpa_supplicant.conf'
> Reading configuration file '/etc/wpa_supplicant.conf'
> ctrl_interface='/var/run/wpa_supplicant'
> eapol_version=1
> ap_scan=1
> fast_reauth=1
> Line 771: removed CCMP from group cipher list since it was not allowed for pairwise cipher
> Priority group 0
>   id=0 ssid='werewolf'
> Initializing interface (2) 'wlan0'
> SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
>  capabilities: key_mgmt 0xf enc 0xf
> WEXT: Operstate: linkmode=1, operstate=5
> Own MAC address: 00:1f:e2:bc:8c:01
> wpa_driver_wext_set_wpa
> wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
> wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
> wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
> wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
> wpa_driver_wext_set_countermeasures
> ioctl[SIOCSIWAUTH]: Operation not supported
> WEXT auth param 4 value 0x0 - wpa_driver_wext_set_drop_unencrypted
> RSN: flushing PMKID list in the driver
> Setting scan request: 0 sec 100000 usec
> EAPOL: SUPP_PAE entering state DISCONNECTED
> EAPOL: KEY_RX entering state NO_KEY_RECEIVE
> EAPOL: SUPP_BE entering state INITIALIZE
> EAP: EAP entering state DISABLED
> Added interface wlan0
> RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
> Wireless event: cmd=0x8b06 len=8
> State: DISCONNECTED -> SCANNING
> Starting AP scan (broadcast SSID)
> Trying to get current scan results first without requesting a new scan to speed up initial association
> Received 0 bytes of scan results (0 BSSes)
> CTRL-EVENT-SCAN-RESULTS
> Selecting BSS from priority group 0
> Try to find WPA-enabled AP
> Try to find non-WPA AP
> No suitable AP found.
> Setting scan request: 0 sec 0 usec
> Starting AP scan (broadcast SSID)
> Scan requested (ret=0) - scan timeout 5 seconds
> EAPOL: disable timer tick
> RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
> Wireless event: cmd=0x8b19 len=8
> Received 0 bytes of scan results (0 BSSes)
> CTRL-EVENT-SCAN-RESULTS
> Selecting BSS from priority group 0
> Try to find WPA-enabled AP
> Try to find non-WPA AP
> No suitable AP found.
> ...

It looks like you didn't get any scan results.  Does 'iwlist wlan0 scan'
work?

CCing ath5k-devel, you'll probably get more help there.

-- 
Bob Copeland %% www.bobcopeland.com
