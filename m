Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbYFPSWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbYFPSWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 14:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbYFPSVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 14:21:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:35448 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbYFPSVp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 14:21:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=organization:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id:from;
        b=V/cbmJo29P3AArRTSpyotU4WNSwZ2ffH2qxn0HIyiOgoLnAJi9ZbGJVtotKpJYElIq
         oSdA07hGFrR9vt/whET501cZ1tDMR+0sJq4apAOE0Ylo2xhZLSGGUZonatLDHvoegYaI
         Fiy7tbCwMwUubibbZG5X2rhtYAdx2gQCFClc0=
Organization: M1K0
To: Zhu Yi <yi.zhu@intel.com>
Subject: Re: [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23
Date: Mon, 16 Jun 2008 20:21:36 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
References: <200806060039.48488.m1k0@wp.pl> <200806131937.03680.Michal.Kudla@gmail.com> <1213581088.7814.882.camel@debian.sh.intel.com>
In-Reply-To: <1213581088.7814.882.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806162021.37105.Michal.Kudla@gmail.com>
From: =?utf-8?q?Micha=C5=82_Kud=C5=82a?= <michal.kudla@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After

laptok ~ # echo 0 > /sys/bus/pci/drivers/iwl4965/0000\:04\:00.0/rf_kill
laptok ~ # iwconfig wlan0 txpower on
laptok ~ # /etc/init.d/net.wlan0 restart
 * Service net.wlan0 starting
 * Service net.wlan0 started
laptok ~ # dmesg >dmesg-`uname -r`_`date +%F`.txt


I get in dmesg

...
iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
ACPI: PCI interrupt for device 0000:04:00.0 disabled
HW CONFIG: channel=10 freq=2457 phymode=2
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PM: Writing back config space on device 0000:04:00.0 at offset 1 (was 100102, 
writing 100106)
HW CONFIG: channel=10 freq=2457 phymode=2
ADDRCONF(NETDEV_UP): wlan0: link is not ready
HW CONFIG: channel=10 freq=2457 phymode=2
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:01:e3:06:00:35
phy0: TX to low-level driver (len=30) FC=0x00b0 DUR=0x013a 
A1=00:01:e3:06:00:35 A2=00:13:e8:42:88:f9 A3=00:01:e3:06:00:35
HW CONFIG: channel=10 freq=2457 phymode=2
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:01:e3:06:00:35
phy0: TX to low-level driver (len=30) FC=0x00b0 DUR=0x013a 
A1=00:01:e3:06:00:35 A2=00:13:e8:42:88:f9 A3=00:01:e3:06:00:35
wlan0: RX authentication from 00:01:e3:06:00:35 (alg=0 transaction=2 status=0)
wlan0: authenticated
wlan0: associate with AP 00:01:e3:06:00:35
phy0: TX to low-level driver (len=50) FC=0x0000 DUR=0x013a 
A1=00:01:e3:06:00:35 A2=00:13:e8:42:88:f9 A3=00:01:e3:06:00:35
wlan0: authentication frame received from 00:01:e3:06:00:35, but not in 
authenticate state - ignored
wlan0: authentication frame received from 00:01:e3:06:00:35, but not in 
authenticate state - ignored
wlan0: RX AssocResp from 00:01:e3:06:00:35 (capab=0x11 status=0 aid=1)
wlan0: associated
phy0: Added STA 00:01:e3:06:00:35
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
phy0: TX to low-level driver (len=116) FC=0x4108 DUR=0x0102 
A1=00:01:e3:06:00:35 A2=00:13:e8:42:88:f9 A3=33:33:00:00:00:16
HW CONFIG: channel=10 freq=2457 phymode=2
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:01:e3:06:00:35
phy0: TX to low-level driver (len=30) FC=0x00b0 DUR=0x013a 
A1=00:01:e3:06:00:35 A2=00:13:e8:42:88:f9 A3=00:01:e3:06:00:35
wlan0: RX authentication from 00:01:e3:06:00:35 (alg=0 transaction=2 status=0)
wlan0: authenticated
wlan0: associate with AP 00:01:e3:06:00:35
phy0: TX to low-level driver (len=56) FC=0x0020 DUR=0x013a 
A1=00:01:e3:06:00:35 A2=00:13:e8:42:88:f9 A3=00:01:e3:06:00:35
wlan0: RX ReassocResp from 00:01:e3:06:00:35 (capab=0x11 status=0 aid=1)
wlan0: associated
wlan0: association frame received from 00:01:e3:06:00:35, but not in associate 
state - ignored
phy0: TX to low-level driver (len=104) FC=0x4108 DUR=0x0102 
A1=00:01:e3:06:00:35 A2=00:13:e8:42:88:f9 A3=33:33:ff:42:88:f9
phy0: TX to low-level driver (len=96) FC=0x4108 DUR=0x0102 
A1=00:01:e3:06:00:35 A2=00:13:e8:42:88:f9 A3=33:33:00:00:00:02
phy0: TX to low-level driver (len=68) FC=0x4108 DUR=0x0102 
A1=00:01:e3:06:00:35 A2=00:13:e8:42:88:f9 A3=ff:ff:ff:ff:ff:ff
phy0: TX to low-level driver (len=116) FC=0x4108 DUR=0x0102 
A1=00:01:e3:06:00:35 A2=00:13:e8:42:88:f9 A3=33:33:00:00:00:16
phy0: TX to low-level driver (len=68) FC=0x4108 DUR=0x0102 
A1=00:01:e3:06:00:35 A2=00:13:e8:42:88:f9 A3=ff:ff:ff:ff:ff:ff
phy0: TX to low-level driver (len=96) FC=0x4108 DUR=0x0102 
A1=00:01:e3:06:00:35 A2=00:13:e8:42:88:f9 A3=33:33:00:00:00:02
phy0: TX to low-level driver (len=96) FC=0x4108 DUR=0x0102 
A1=00:01:e3:06:00:35 A2=00:13:e8:42:88:f9 A3=33:33:00:00:00:02
wlan0: no IPv6 routers present
phy0: TX to low-level driver (len=46) FC=0x0040 DUR=0x013a 
A1=00:01:e3:06:00:35 A2=00:13:e8:42:88:f9 A3=00:01:e3:06:00:35
phy0: TX to low-level driver (len=46) FC=0x0040 DUR=0x013a 
A1=00:01:e3:06:00:35 A2=00:13:e8:42:88:f9 A3=00:01:e3:06:00:35
phy0: TX to low-level driver (len=46) FC=0x0040 DUR=0x013a 
A1=00:01:e3:06:00:35 A2=00:13:e8:42:88:f9 A3=00:01:e3:06:00:35
phy0: TX to low-level driver (len=46) FC=0x0040 DUR=0x013a 
A1=00:01:e3:06:00:35 A2=00:13:e8:42:88:f9 A3=00:01:e3:06:00:35

And my wifi working!

Bt, I don't know why my wifi working under 2.6.23 and 2.6.24?


W liście datowanym na poniedziałek, 16 czerwca 2008, Zhu Yi pisze:
>ZY On Fri, 2008-06-13 at 19:37 +0200, Michał Kudła wrote:
>ZY > dmesg-2.6.26-rc5_2008-06-13.txt
>ZY
>ZY >From this log:
>ZY
>ZY iwl4965: U iwl4965_radio_kill_sw Manual SW RF KILL set to: RADIO OFF
>ZY iwl4965: I iwl4965_rx_card_state_notif Card state received: HW:On
>ZY SW:Kill
>ZY iwl4965: U iwl4965_mac_config leave - radio disabled
>ZY iwl4965: Error sending REPLY_TX_PWR_TABLE_CMD: enqueue_hcmd failed: -5
>ZY iwl4965: U iwl4965_bg_rf_kill Can not turn radio back on - disabled by
>ZY SW switch
>ZY iwl4965: Error sending REPLY_WEPKEY: enqueue_hcmd failed: -5
>ZY
>ZY Your radio is disabled by the software rf_kill switch. Please do a
>ZY
>ZY $ echo 0 > /sys/bus/pci/drivers/iwl4965/<dev id>/rfkill\:rfkill0/state
>ZY
>ZY I wonder if you (or some application) did something like a `iwconfig
>ZY wlan0 txpower off` so that the radio is disabled. Maybe you can try
>ZY `iwconfig wlan0 txpower on`?
>ZY
>ZY Thanks,
>ZY -yi
>ZY
>ZY


