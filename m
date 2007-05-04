Return-Path: <linux-kernel-owner+w=401wt.eu-S1031483AbXEDSIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031483AbXEDSIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031482AbXEDSIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:08:46 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:16462 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031476AbXEDSIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:08:45 -0400
Message-ID: <463B770C.7060407@ru.mvista.com>
Date: Fri, 04 May 2007 22:10:20 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       michal.kepien@poczta.onet.pl, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Fw: HPT366: 2.6.21 breaks HPT366 detection on boot
References: <20070504110204.f3d42ed9.akpm@linux-foundation.org>
In-Reply-To: <20070504110204.f3d42ed9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Andrew Morton wrote:
> fyi..  (followup on-list if so inclined, please)

> Begin forwarded message:

> Date: Fri, 4 May 2007 18:44:18 +0200
> From: Michal Kepien <michal.kepien@poczta.onet.pl>
> To: The Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> Subject: HPT366: 2.6.21 breaks HPT366 detection on boot

> Hi there all kernel hackers,

> I own an Abit BE-6 v1 mainboard with an on-board HPT366 controller. Until kernel
> version 2.6.20.7 it worked perfectly, however 2.6.21 broke it. My system is
> Slackware 11.0 + current. Relevant log fragments:

> 2.6.20.7:
> =========

> -------------------------------------------------------------------------------
> Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
> ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> PIIX4: IDE controller at PCI slot 0000:00:07.1
> PIIX4: chipset revision 1
> PIIX4: not 100% native mode: will probe irqs later
>     ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:pio
>     ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:pio, hdd:pio
> Probing IDE interface ide0...
> hda: SAMSUNG CD-R/RW SW-252B, ATAPI CD/DVD-ROM drive
> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> Probing IDE interface ide1...
> HPT366: onboard version of chipset, pin1=1 pin2=2
> HPT366: IDE controller at PCI slot 0000:00:13.0
> PCI: setting IRQ 11 as level-triggered
> PCI: Found IRQ 11 for device 0000:00:13.0
> PCI: Sharing IRQ 11 with 0000:00:0b.0
> PCI: Sharing IRQ 11 with 0000:00:13.1
> HPT366: chipset revision 1
> HPT366: 100% native mode on irq 11
>     ide2: BM-DMA at 0xd800-0xd807, BIOS settings: hde:DMA, hdf:pio
> PCI: Found IRQ 11 for device 0000:00:13.1
> PCI: Sharing IRQ 11 with 0000:00:0b.0
> PCI: Sharing IRQ 11 with 0000:00:13.0
>     ide3: BM-DMA at 0xe400-0xe407, BIOS settings: hdg:pio, hdh:pio
> Probing IDE interface ide2...
> hde: IBM-DJNA-371350, ATA DISK drive
> hde: hw_config=2000
> hde: hw_config=2000
> ide2 at 0xd000-0xd007,0xd402 on irq 11
> Probing IDE interface ide3...
> hde: max request size: 128KiB
> hde: 26520480 sectors (13578 MB) w/1966KiB Cache, CHS=26310/16/63, UDMA(33)
> hde: cache flushes not supported
>  hde: hde1 hde2 < hde5 >
> hda: ATAPI 52X CD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)
> -------------------------------------------------------------------------------

> 2.6.21(.1):
> ===========

> -------------------------------------------------------------------------------
> Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
> ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> PIIX4: IDE controller at PCI slot 0000:00:07.1
> PIIX4: chipset revision 1
> PIIX4: not 100% native mode: will probe irqs later
>     ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:pio
>     ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:pio, hdd:pio
> hda: SAMSUNG CD-R/RW SW-252B, ATAPI CD/DVD-ROM drive
> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> HPT366: onboard version of chipset, pin1=1 pin2=2
> HPT366: IDE controller at PCI slot 0000:00:13.0
> PCI: setting IRQ 11 as level-triggered
> PCI: Found IRQ 11 for device 0000:00:13.0
> PCI: Sharing IRQ 11 with 0000:00:0b.0
> PCI: Sharing IRQ 11 with 0000:00:13.1
> HPT366: chipset revision 1
> HPT366: using 33 MHz PCI clock
> HPT366: 100% native mode on irq 11
> HPT366: neither IDE port enabled (BIOS)
> PCI: Found IRQ 11 for device 0000:00:13.1
> PCI: Sharing IRQ 11 with 0000:00:0b.0
> PCI: Sharing IRQ 11 with 0000:00:13.0
> HPT366: using 33 MHz PCI clock
> HPT366: neither IDE port enabled (BIOS)

    Looks I was too bold with my 'enablebits' assumption and HPT366 didn't yet 
have them. I'll send a patch to try soon.

> hda: ATAPI 52X CD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)
> -------------------------------------------------------------------------------
> 
> Booting the system with 2.6.21 results in a kernel panic:
> 
> -------------------------------------------------------------------------------
> VFS: Cannot open root device "2101" or unknown-block(31,1)
> Please append a correct "root=" boot option
> Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(31,1) 
> -------------------------------------------------------------------------------

> I'd happily try out any patches and/or supply you with more details on demand.

MBR, Sergei
