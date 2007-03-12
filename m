Return-Path: <linux-kernel-owner+w=401wt.eu-S1751570AbXCLWfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbXCLWfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 18:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbXCLWfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 18:35:16 -0400
Received: from rtr.ca ([64.26.128.89]:2662 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbXCLWfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 18:35:13 -0400
Message-ID: <45F5D59E.10304@rtr.ca>
Date: Mon, 12 Mar 2007 18:35:10 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Phil Kaslo <phil@cs.arizona.edu>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Asus P5B-VM motherboard:  cd drive malfunctions if internal nic
 in use.
References: <200703122212.l2CMCaxm032601@osprey.cs.arizona.edu>
In-Reply-To: <200703122212.l2CMCaxm032601@osprey.cs.arizona.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Phil Kaslo wrote:
> Hello,
> 
> I have a new machine, Asus motherboard, in which the cd drive malfunctions 
> if the internal nic on the mb (RealTek RTL8168b/8111b) is actively in use.   
> The cd drive, on ide2, is, as per dmesg, a Sony:
>  ide2: BM-DMA at 0xa400-0xa407, BIOS settings: hde:pio, hdf:pio
>  hde: SONY DVD RW AW-Q170A, ATAPI CD/DVD-ROM drive
>  hde: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(66)
> 
> I've seen this on 3 of these new machines so far.  One has a LITE-ON cdrom: 
>  hde: LITE-ON DVDRW LH-20A1H, ATAPI CD/DVD-ROM drive
> so this is not unique to the Sony.
> 
> Motherboard:  Asus P5B-VM  G965 775  BIOS Revision : 613
> CPU: Intel Core 2 CPU 6300 1.86GHz

Is that a PATA cd-drive?  If so, then you must have hooked it up
to the JMicron IDE controller.  That driver is just plain buggy.

I gave up on it for my own P5B-VM.  The libata version works better
than the drivers/ide, but I gave up on it and got a SATA DVD/RW drive.

Off topic:  do your USB ports power off when the system shuts down?
Mine don't -- the +5V continues on them.. I'd love a tip on how to
turn them off completely at shutdown.

Cheers
