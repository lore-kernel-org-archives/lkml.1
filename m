Return-Path: <linux-kernel-owner+w=401wt.eu-S1751585AbYJRSQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbYJRSQa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 14:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbYJRSQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 14:16:22 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:43243 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbYJRSQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 14:16:21 -0400
Date: Sat, 18 Oct 2008 18:46:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: [PATCH] Re: pata_it821x in 2.6.27 - works but no LBA48 and
 "hdparm -t" is slower
Message-ID: <20081018184621.16ed1d0b@the-village.bc.nu>
In-Reply-To: <200810181830.39023.linux@rainbow-software.org>
References: <200810181342.50615.linux@rainbow-software.org>
	<200810181830.39023.linux@rainbow-software.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Oct 2008 18:30:37 +0200
Ondrej Zary <linux@rainbow-software.org> wrote:


> This patch fixes LBA48 on pata_it821x RAID volumes - and to my surprise, also
> increases the "hdparm -t" speed back. Haven't tested access to >128GB area.
> 
> ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
> pata_it821x 0000:00:12.0: PCI INT A -> Link[LNKC] -> GSI 11 (level, low) -> IRQ 11
> pata_it821x: controller in smart mode.
> pata_it821x 0000:00:12.0: setting latency timer to 64
> pata_it821x: Firmware 02/09/3030
> 0: MWDMA2 RAID1RAID 0+1 Volume: 0 SAMSUNG HD400LD
> 1: MWDMA2 RAID1RAID 0+1 Volume: 0 SAMSUNG HD400LD
> scsi2 : pata_it821x
> scsi3 : pata_it821x
> ata3: PATA max UDMA/133 cmd 0x6800 ctl 0x6c00 bmdma 0x7800 irq 11
> ata4: PATA max UDMA/133 cmd 0x7000 ctl 0x7400 bmdma 0x7808 irq 11
> ata3.00: ATA-4: Integrated Technology Express Inc, , max MWDMA2
> ata3.00: 781422766 sectors, multi 0: LBA48
> ata3.00: RAID1 volume.
> ata3.00: configured for DMA
> scsi 2:0:0:0: Direct-Access     ATA      Integrated Techn n/a  PQ: 0 ANSI: 5
> sd 2:0:0:0: [sdb] 781422766 512-byte hardware sectors (400088 MB)
> sd 2:0:0:0: [sdb] Write Protect is off
> sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> sd 2:0:0:0: [sdb] 781422766 512-byte hardware sectors (400088 MB)
> sd 2:0:0:0: [sdb] Write Protect is off
> sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
>  sdb: sdb1 sdb2 sdb3 sdb4
> sd 2:0:0:0: [sdb] Attached SCSI disk
> sd 2:0:0:0: Attached scsi generic sg2 type 0
> 
> 
> /dev/sdb:
>  Timing buffered disk reads:   60 MB in  3.01 seconds =  19.91 MB/sec
> 
> 
> 
> Fix LBA48 on pata_it821x RAID volumes.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Acked-by: Alan Cox <alan@redhat.com>
