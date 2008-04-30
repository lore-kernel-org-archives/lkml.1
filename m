Return-Path: <linux-kernel-owner+w=401wt.eu-S1762101AbYD3Ous@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762101AbYD3Ous (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 10:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760550AbYD3Oui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 10:50:38 -0400
Received: from mail0.lsil.com ([147.145.40.20]:49126 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757098AbYD3Ouh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 10:50:37 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: HP server and atto driver from hell
Date: Wed, 30 Apr 2008 08:50:02 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229010475E9@NAMAIL2.ad.lsil.com>
In-Reply-To: <20080430134248.GD15819@charite.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: HP server and atto driver from hell
thread-index: AciqyBfA4Zhk3qkFQH+1wkLbLJR54wACLsiQ
From: "Moore, Eric" <Eric.Moore@lsi.com>
To: "Ralf Hildebrandt" <Ralf.Hildebrandt@charite.de>,
       "Linux Kernel Maillist" <linux-kernel@vger.kernel.org>
Cc: <Sven_Rudolph@drewag.de>
X-OriginalArrivalTime: 30 Apr 2008 14:50:03.0027 (UTC) FILETIME=[78B7FE30:01C8AAD1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 30, 2008 7:43 AM, Ralf Hildebrandt wrote:  
> * Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>:
> 
> > Well, something seems to work:
> > 
> > [    3.571216] Fusion MPT base driver 3.04.06
> > [    3.571274] Copyright (c) 1999-2007 LSI Corporation
> > [    3.577292] Fusion MPT SPI Host driver 3.04.06
> > [    3.577389] ACPI: PCI Interrupt 0000:14:04.0[A] -> GSI 
> 17 (level, low) -> IRQ 17
> > [    3.577512] mptbase: ioc0: Initiating bringup
> > [    3.836271] ioc0: LSI53C1030 C0: Capabilities={Initiator,Target}
> > [    3.992277] scsi0 : ioc0: LSI53C1030 C0, 
> FwRev=01032700h, Ports=1, MaxQ=255, IRQ=17
> > [    3.992277] ACPI: PCI Interrupt 0000:14:04.1[B] -> GSI 
> 18 (level, low) -> IRQ 18
> > [    3.992277] mptbase: ioc1: Initiating bringup
> > [    4.244297] ioc1: LSI53C1030 C0: Capabilities={Initiator,Target}
> > [    4.408304] scsi1 : ioc1: LSI53C1030 C0, 
> FwRev=01032700h, Ports=1, MaxQ=255, IRQ=18
> > 
> > # lspci -v -s 14:04.0
> > 14:04.0 SCSI storage controller: Atto Technology Ultra320 
> SCSI Host Adapter (rev 08)
> >         Subsystem: Atto Technology Unknown device 802f
> >         Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 17
> >         I/O ports at 5000 [size=256]
> >         Memory at fdfc0000 (64-bit, non-prefetchable) [size=256K]
> >         Memory at fdf80000 (64-bit, non-prefetchable) [size=256K]
> >         Capabilities: [50] Power Management version 2
> >         Capabilities: [58] Message Signalled Interrupts: 
> Mask- 64bit+ Queue=0/0 Enable-
> > 	Capabilities: [68] PCI-X non-bridge device
> > 	Kernel driver in use: mptspi
> > 	Kernel modules: mptspi
> 
> According to http://lwn.net/Articles/254394, Eric Moore added the ATTO
> 4LD support:
> 
> mpt fusion: Add support for ATTO 4LD: Rebranded LSI
> 
> And the HP U320e SCSI Bus Adapter seesm to be a rebranded ATTO 4LD.
> But I cannot be sure.
> 

Yeah, ATTO support was added about a year ago, thanks to Sven Rudolph.
However I doubt HP card is *not* a rebranded ATTO card.  They both have
the same scsi controller, but the bios and firmware on the HP card are
directly from LSI, however I'm pretty sure that ATTO did everything them
selves.

Eric

