Return-Path: <linux-kernel-owner+w=401wt.eu-S964813AbXCRLGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964813AbXCRLGx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 07:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964800AbXCRLGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 07:06:53 -0400
Received: from tag.witbe.net ([81.88.96.48]:36406 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964788AbXCRLGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 07:06:52 -0400
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: <rol@as2917.net>, "'Tejun Heo'" <htejun@gmail.com>
Cc: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Jeff Garzik'" <jeff@garzik.org>, "'Alan Cox'" <alan@redhat.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       <linux-ide@vger.kernel.org>, "'LKML'" <linux-kernel@vger.kernel.org>,
       "'Eric D. Mudama'" <edmudama@gmail.com>
Subject: RE: [git patches] libata fixes
Date: Sun, 18 Mar 2007 12:06:40 +0100
Organization: AS2917.net
Message-ID: <00f401c7694d$81a80920$2101a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <00ee01c7694b$382b6460$2101a8c0@donald>
Thread-Index: AcdpSbmOVLxRdgqUQZiO4C+v/kDnmwAAPRKAAABge/A=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Doh ! Got that :

....
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 23 (level, low) -> IRQ 23
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part 
ata1: SATA max UDMA/133 cmd 0xffffc2000008e900 ctl 0x0000000000000000 bmdma
0x0000000000000000 irq 504
ata2: SATA max UDMA/133 cmd 0xffffc2000008e980 ctl 0x0000000000000000 bmdma
0x0000000000000000 irq 504
ata3: SATA max UDMA/133 cmd 0xffffc2000008ea00 ctl 0x0000000000000000 bmdma
0x0000000000000000 irq 504
ata4: SATA max UDMA/133 cmd 0xffffc2000008ea80 ctl 0x0000000000000000 bmdma
0x0000000000000000 irq 504
scsi0 : ahci
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: Maxtor 6L250S0, BANC1G10, max UDMA/133
ata1.00: 490234752 sectors, multi 0: LBA48 NCQ (not used)
ata1.00: configured for UDMA/133
scsi1 : ahci
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ATA-6: External Disk 0, RGL10364, max UDMA/133
ata2.00: 1 sectors, multi 1: LBA48 
ata2.00: configured for UDMA/133
scsi2 : ahci
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATA-7: Maxtor 6L250S0, BANC1G10, max UDMA/133
ata3.00: 490234752 sectors, multi 0: LBA48 NCQ (not used)
ata3.00: configured for UDMA/133
scsi3 : ahci
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ATA-7: ST3500641AS, 3.AAB, max UDMA/133
ata4.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata4.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6L250S0   BANC PQ: 0 ANSI: 5
SCSI device sda: 490234752 512-byte hdwr sectors (251000 MB)
sda: Write Protect is off
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
SCSI device sda: 490234752 512-byte hdwr sectors (251000 MB)
sda: Write Protect is off
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: Attached scsi disk sda
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Direct-Access     ATA      External Disk 0  RGL1 PQ: 0 ANSI: 5
SCSI device sdb: 1 512-byte hdwr sectors (0 MB)
sdb: Write Protect is off
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
SCSI device sdb: 1 512-byte hdwr sectors (0 MB)
sdb: Write Protect is off
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
 sdb:<3>irq 504: nobody cared (try booting with the "irqpoll" option)

Call Trace:
 <IRQ>  [<ffffffff802b0245>] __report_bad_irq+0x35/0x90
 [<ffffffff802b04ba>] note_interrupt+0x21a/0x270
 [<ffffffff802b128f>] handle_edge_irq+0x10f/0x150
 [<ffffffff8026f3eb>] do_IRQ+0x7b/0xf0
 [<ffffffff80259e70>] mwait_idle+0x0/0x50
 [<ffffffff802612d1>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8042bff0>] vgacon_cursor+0x0/0x1d0
 [<ffffffff80259eb6>] mwait_idle+0x46/0x50
 [<ffffffff8024aebc>] cpu_idle+0x5c/0xa0
 [<ffffffff808b984a>] start_kernel+0x2aa/0x2c0
 [<ffffffff808b9176>] _sinittext+0x176/0x180

handlers:
[<ffffffff804e1c90>] (ahci_interrupt+0x0/0x590)
Disabling IRQ #504
 unknown partition table
sd 1:0:0:0: Attached scsi disk sdb
sd 1:0:0:0: Attached scsi generic sg1 type 0
scsi 2:0:0:0: Direct-Access     ATA      Maxtor 6L250S0   BANC PQ: 0 ANSI: 5
SCSI device sdc: 490234752 512-byte hdwr sectors (251000 MB)
sdc: Write Protect is off


and though it said :
 sdb:<3>irq 504: nobody cared (try booting with the "irqpoll" option)
I _am_ booting with the irqpoll option !

Paul

