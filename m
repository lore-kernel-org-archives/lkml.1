Return-Path: <linux-kernel-owner+w=401wt.eu-S939145AbXG3HIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939145AbXG3HIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 03:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938701AbXG3HIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 03:08:43 -0400
Received: from rrzmta1.rz.uni-regensburg.de ([194.94.155.51]:5573 "EHLO
	rrzmta1.rz.uni-regensburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S938725AbXG3HIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 03:08:41 -0400
From: "Ulrich Windl" <ulrich.windl@rz.uni-regensburg.de>
Organization: Universitaet Regensburg, Klinikum
To: Andrew Patterson <andrew.patterson@hp.com>
Date: Mon, 30 Jul 2007 08:40:56 +0200
MIME-Version: 1.0
Subject: Re: Q: PCI-X @ 266MHz on HP rx6600 (Qlogic 4Gb FC HBA)
CC: Ulrich Windl <ulrich.windl@rz.uni-regensburg.de>,
       linux-kernel@vger.kernel.org
Message-ID: <46ADA41B.31663.337E40@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
In-reply-to: <1185551189.7134.501.camel@bluto.andrew>
References: <20070727062343.GC15408@plap.qlogic.org>
X-mailer: Pegasus Mail for Windows (4.31)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Content-Conformance: HerringScan-0.25/Sophos-P=4.16.0+V=4.16+U=2.07.165+R=02 April 2007+T=237343@20070730.063022Z
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 Jul 2007 at 9:46, Andrew Patterson wrote:

> On Thu, 2007-07-26 at 23:23 -0700, Andrew Vasquez wrote:
> > On Thu, 26 Jul 2007, Andrew Patterson wrote:
> > 
> > > On Thu, 2007-07-26 at 15:36 +0200, Ulrich Windl wrote:
> > > > Hi,
> > > > 
> > > > I have a question: The Qlogic ISP2422 chip is said to handle PCI-X 266MHz. So does 
> > > > the HP Itanium2 server rx6600. Basically that was the reason to select that 
> > > > server. The FC-HBA is in a 266 MHz capable slot. However when booting SLES10 SP1 
> > > > for IA64, the logs say:
> > 
> > There's a mixup here in terminology...  The QLA2460 card which you
> > have does in fact support 'PCI-X 266'...
> > 
> > > > <6>QLogic Fibre Channel HBA Driver
> > > > <6>GSI 49 (level, low) -> CPU 3 (0x0300) vector 51
> > > > <6>ACPI: PCI Interrupt 0000:0f:01.0[A] -> GSI 49 (level, low) -> IRQ 51
> > > > <6>qla2xxx 0000:0f:01.0: Found an ISP2422, irq 51, iobase 0xc0000000b0040000
> > > > [...]
> > > > <6>qla2xxx 0000:0f:01.0: LOOP UP detected (4 Gbps).
> > > > <6>qla2xxx 0000:0f:01.0: Topology - (F_Port), Host Loop address 0x0
> > > > <6>scsi0 : qla2xxx
> > > > <6>qla2xxx 0000:0f:01.0:
> > > > <4> QLogic Fibre Channel HBA Driver: 8.01.07-k3
> > > > <4>  QLogic HP AB378-60001 -
> > > > <4>  ISP2422: PCI-X Mode 2 (133 MH4.00.26 [IP]  @ 0000:0f:01.0 hdma+, host#=0, 
> > > > fw=4.00.26 [IP]
> > 
> > The 33/66/100/133 values refer to the bus-clock speed at which the
> > card is operating.  As is seen here (although a bit truncated --
> > separate issue, I'll try to see if I can reproduce this on one of my
> > HPQ rigs), the card is inserted into a PCI-X Mode-2 capable 133MHz
> > (bus clock) slot.  When operating under this mode, each data-phase
> > between two devices is divided into 2 sub-phases, effectively doubling
> > the transfer-data-rate to 266Mhz.
> 
> I guess the proper terminology would be 266 MT/s (Mega
> Transfers/second). Looking through the PSI_SIG PCI-X 2.0 marketing
> blurbs, they use MHz a lot when referring to MT/S. So I would still
> consider this to be a minor bug.  The user wants to know the transfer
> rate, not the actual frequency of the bus.  Maybe just print out the
> mode used instead, e.g., "PCI-X 266"?
[...]

To be concrete: In the Installation Manual for the rx6600 (P/N AB464-9001A), 
figure 1-1 ("I/O Subsystem Block Diagram") the names being used are "PCIx-66", 
"PCIx-133", and "PCIx267". However in the text following the text refers to "66 
MHz PCI/PCI-X slots" ("PCI/PCI-X 133 MHz", "PCI/PCI-X 266 MHz").

The Qlogic data sheet for the "ISP2422" also calls the bus interface "64-bit, PCI-
X 2.0 266-MHz DDR", and the document's subtitle is "Dual Port 4-Gbps Fibre Channel 
(FC) to PCI-X 2.0 266-MHz Controller".

Confusing?

Regards,
Ulrich

