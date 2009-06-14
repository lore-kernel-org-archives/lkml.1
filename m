Return-Path: <linux-kernel-owner+w=401wt.eu-S1761683AbZFNTHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761683AbZFNTHW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 15:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758549AbZFNTHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 15:07:10 -0400
Received: from www17.your-server.de ([213.133.104.17]:45466 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757770AbZFNTHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 15:07:09 -0400
Subject: Re: 2.6.30: suspend-to-ram, second s2r wakes up immediately
From: Thomas Meyer <thomas@m3y3r.de>
To: Frans Pop <elendil@planet.nl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, stern@rowland.harvard.edu
In-Reply-To: <200906142031.38358.elendil@planet.nl>
References: <1244996001.8440.10.camel@localhost>
	 <200906141828.11970.rjw@sisk.pl> <1244997882.8440.13.camel@localhost>
	 <1244997882.8440.13.camel@localhost> <200906141901.46687.rjw@sisk.pl>
	 <200906142031.38358.elendil@planet.nl>
Content-Type: text/plain
Date: Sun, 14 Jun 2009 21:07:09 +0200
Message-Id: <1245006429.23043.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 14.06.2009, 20:31 +0200 schrieb Frans Pop:
> Rafael J. Wysocki wrote:
> 
> >> 00:02.1 USB Controller: nVidia Corporation MCP55 USB Controller (rev a2) (prog-if 20 [EHCI])
> >>       Subsystem: Micro-Star International Co., Ltd. Device 7250
> >>       Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> >>       Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> >>       Latency: 0 (750ns min, 250ns max)
> >>       Interrupt: pin B routed to IRQ 23
> >>       Region 0: Memory at fe9fac00 (32-bit, non-prefetchable) [size=256]
> >>       Capabilities: [44] Debug port: BAR=1 offset=0098
> >>       Capabilities: [80] Power Management version 2
> >>               Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
> >>               Status: D0 PME-Enable- DSel=0 DScale=0 PME+
> >>       Kernel driver in use: ehci_hcd
> > 
> > PME+ means that the USB EHCI controller will signal a PME as soon as it is
> > enabled, so if PME is enabled on the controller before suspend, it will
> > wake up the system.
> > 
> > Please send a boot log.
> 
> Was already included in the initial message...
> 
> I wonder if this device could be the cause:
> [   40.232873] wlan0: register 'rndis_wlan' at usb-0000:00:02.1-6.1,
>                Wireless RNDIS device, BCM4320b based, 00:16:01:cf:56:29
> [   40.232907] usbcore: registered new interface driver rndis_wlan
> [...]
> [   41.705516] rndis_wlan 1-6.1:1.0: rndis media disconnect

Good idea. I should have thought of this myself. No, it's not above
device. I just tested several constellations and it's seems to be my usb
mouse. when the mouse is unplug suspend to ram works reliably.

how to fix the mouse's behaviour?

mfg
thomas


