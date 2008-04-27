Return-Path: <linux-kernel-owner+w=401wt.eu-S1762663AbYD0RBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762663AbYD0RBG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 13:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761586AbYD0RAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 13:00:52 -0400
Received: from ns.store20.com ([212.7.7.16]:36765 "EHLO store20.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756799AbYD0RAb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 13:00:31 -0400
Subject: Re: [REGRESSION] Trouble seeing some wireless networks in latest
	git
From: Priit Laes <plaes@plaes.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200804271748.49377.mb@bu3sch.de>
References: <1209288298.3851.12.camel@localhost>
	 <48149F2B.4000503@lwfinger.net>  <200804271748.49377.mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Date: Sun, 27 Apr 2008 20:00:25 +0300
Message-Id: <1209315625.4095.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ühel kenal päeval, P, 2008-04-27 kell 17:48, kirjutas Michael Buesch:
> > > Any hints how to debug this further?
> Nah, it's a regulatory setting issue.
> The default regdomain is US, which only allows chans 1-11.
> There's some module parameter to switch the regdomain.
> This is not a regression, but a feature.
> 
Regdomain setting seems to be OK (and missing for b43):
﻿iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels

Where can I set the regdomain? I couldn't find any information under
Documentation and with modinfo?

Dmesg output for iwl3945 is:
...
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for
Linux, 1.2.26ks
iwl3945: Copyright(c) 2003-2008 Intel Corporation
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:03:00.0 to 64
iwl3945: Detected Intel Wireless WiFi Link 3945ABG
iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
phy0: Selected rate control algorithm 'iwl-3945-rs'
...

And b43:
...
b43-pci-bridge 0000:16:00.0: enabling device (0000 -> 0002)
ACPI: PCI Interrupt 0000:16:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:16:00.0 to 64
ssb: Sonics Silicon Backplane found on PCI device 0000:16:00.0
b43-phy1: Broadcom 4306 WLAN found
phy1: Selected rate control algorithm 'pid'
Broadcom 43xx driver loaded [ Features: PMLR, Firmware-ID: FW13 ]
input: b43-phy1 as /devices/virtual/input/input9
b43-phy1: Loading firmware version 410.2160 (2007-05-26 15:32:10)
Registered led device: b43-phy1::tx
Registered led device: b43-phy1::rx
Registered led device: b43-phy1::radio
...
