Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723AbXLGNcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbXLGNcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 08:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbXLGNcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 08:32:14 -0500
Received: from hades.rz.tu-clausthal.de ([139.174.2.20]:56732 "EHLO
	hades.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbXLGNcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 08:32:14 -0500
From: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: question about sata-error on boot.
Date: Fri, 7 Dec 2007 14:32:08 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <200711021934.21123.volker.armin.hemmann@tu-clausthal.de> <20071106221556.55c3cd0b.akpm@linux-foundation.org>
In-Reply-To: <20071106221556.55c3cd0b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712071432.08699.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mittwoch, 7. November 2007, Andrew Morton wrote:
> > On Fri, 2 Nov 2007 19:34:20 +0100 "Hemmann, Volker Armin"
> > <volker.armin.hemmann@tu-clausthal.de> wrote: Hi,
>
> (cc linux-ide)
>
> > for some time (and I can't say for how long, but the board is less than a
> > month old) I get this error on boot:
> >
> > [   42.116273] ahci 0000:00:0a.0: version 2.2
> > [   42.116482] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
> > [   42.116653] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI
> > 23 (level, low) -> IRQ 23
> > [   43.119478] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps
> > 0xf impl IDE mode
> > [   43.119778] ahci 0000:00:0a.0: flags: 64bit led clo pmp pio
> > [   43.119943] PCI: Setting latency timer of device 0000:00:0a.0 to 64
> > [   43.120149] scsi0 : ahci
> > [   43.120365] scsi1 : ahci
> > [   43.120556] scsi2 : ahci
> > [   43.120741] scsi3 : ahci
> > [   43.120927] ata1: SATA max UDMA/133 cmd 0xffffc20000014100 ctl
> > 0x0000000000000000 bmdma 0x0000000000000000 irq 315
> > [   43.121227] ata2: SATA max UDMA/133 cmd 0xffffc20000014180 ctl
> > 0x0000000000000000 bmdma 0x0000000000000000 irq 315
> > [   43.121526] ata3: SATA max UDMA/133 cmd 0xffffc20000014200 ctl
> > 0x0000000000000000 bmdma 0x0000000000000000 irq 315
> > [   43.121826] ata4: SATA max UDMA/133 cmd 0xffffc20000014280 ctl
> > 0x0000000000000000 bmdma 0x0000000000000000 irq 315
> > [   43.934296] ata1: softreset failed (1st FIS failed)
> > [   43.934461] ata1: reset failed (errno=-5), retrying in 10 secs
> > [   53.885194] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > [   53.885890] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max
> > UDMA/133 [   53.886056] ata1.00: 312581808 sectors, multi 16: LBA48
> > [   53.886804] ata1.00: configured for UDMA/133
> > [   54.201147] ata2: SATA link down (SStatus 0 SControl 300)
> > [   54.517101] ata3: SATA link down (SStatus 0 SControl 300)
> > [   54.833055] ata4: SATA link down (SStatus 0 SControl 300)

this is gone with 2.6.22.13 an 2.6.23.9:

[   33.277039] scsi0 : ahci
[   33.277262] scsi1 : ahci
[   33.277454] scsi2 : ahci
[   33.277645] scsi3 : ahci
[   33.277826] ata1: SATA max UDMA/133 cmd 0xffffc20000020100 ctl 
0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   33.278120] ata2: SATA max UDMA/133 cmd 0xffffc20000020180 ctl 
0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   33.278414] ata3: SATA max UDMA/133 cmd 0xffffc20000020200 ctl 
0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   33.278708] ata4: SATA max UDMA/133 cmd 0xffffc20000020280 ctl 
0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   33.751855] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   33.752659] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   33.752821] ata1.00: 312581808 sectors, multi 16: LBA48
[   33.753574] ata1.00: configured for UDMA/133
[   34.067809] ata2: SATA link down (SStatus 0 SControl 300)
[   34.383762] ata3: SATA link down (SStatus 0 SControl 300)
[   34.699717] ata4: SATA link down (SStatus 0 SControl 300)
[   34.700029] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 
PQ: 0 ANSI: 5
[   34.700377] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[   34.700544] sd 0:0:0:0: [sda] Write Protect is off
[   34.700703] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   34.700712] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   34.701026] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[   34.701191] sd 0:0:0:0: [sda] Write Protect is off
[   34.701350] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   34.701358] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   34.701651]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
