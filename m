Return-Path: <linux-kernel-owner+w=401wt.eu-S1760897AbXK1MgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760897AbXK1MgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 07:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbXK1Mfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 07:35:55 -0500
Received: from osl1smout1.broadpark.no ([80.202.4.58]:58622 "EHLO
	osl1smout1.broadpark.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbXK1Mfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 07:35:54 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain
Subject: Re: laptop reboots right after hibernation
From: Kjartan Maraas <kmaraas@broadpark.no>
To: Tejun Heo <htejun@gmail.com>
Cc: Tomas Carnecky <tom@dbservice.com>, Pavel Machek <pavel@ucw.cz>,
       linux-ide@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
In-reply-to: <474CBFB6.4020105@gmail.com>
References: <473730F6.2010900@dbservice.com> <20071118105214.GB7299@ucw.cz>
 <4740692E.7010801@dbservice.com> <47409DA3.7070909@dbservice.com>
 <1195551141.2792.3.camel@localhost.localdomain> <474CBFB6.4020105@gmail.com>
Date: Wed, 28 Nov 2007 13:35:40 +0100
Message-id: <1196253340.2884.1.camel@localhost.localdomain>
X-Mailer: Evolution 2.21.2 (2.21.2-2.fc9)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


on., 28.11.2007 kl. 10.09 +0900, skrev Tejun Heo:
> Kjartan Maraas wrote:
> > I get this exact error message on a normal first time boot here. I'm
> > using the latest fedora development kernel which is 2.6.24-rc2-git6
> > based. And I have the latest BIOS from HP IIRC.
> > 
> > This is an HP nc6400 intel based laptop:
> 
> Care to post boot dmesg?  Or does harddisk detection fail because of this?
> 
Here you go. It shows the error two times and then it gets it right and
continues to boot. No other problems arise from this that I can see.

libata version 3.00 loaded.
ahci 0000:00:1f.2: version 3.0
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 21 (level, low) -> IRQ 22
ahci 0000:00:1f.2: nr_ports (4) and implemented port map (0x1) don't match, using nr_ports
ahci 0000:00:1f.2: forcing PORTS_IMPL to 0xf
usb 2-1: new full speed USB device using uhci_hcd and address 2
usb 2-1: configuration #1 chosen from 1 choice
usb 3-1: new full speed USB device using uhci_hcd and address 2
usb 3-1: configuration #1 chosen from 1 choice
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0xf impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo pmp pio slum part 
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m1024@0xf4785000 port 0xf4785100 irq 220
ata2: SATA max UDMA/133 abar m1024@0xf4785000 port 0xf4785180 irq 220
ata3: SATA max UDMA/133 abar m1024@0xf4785000 port 0xf4785200 irq 220
ata4: SATA max UDMA/133 abar m1024@0xf4785000 port 0xf4785280 irq 220
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 failed (Emask=0x1 Stat=0x51 Err=0x04)
ata1: failed to recover some devices, retrying in 5 secs
input: PS/2 Generic Mouse as /class/input/input3
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 failed (Emask=0x1 Stat=0x51 Err=0x04)
ata1.00: ACPI on devcfg failed the second time, disabling (errno=-5)
ata1.00: revalidation failed (errno=1)
ata1: failed to recover some devices, retrying in 5 secs
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 0)
ata3: SATA link down (SStatus 0 SControl 0)
ata4: SATA link down (SStatus 0 SControl 0)
scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHV2080B 892C PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
insmod used greatest stack depth: 596 bytes left
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds

Cheers
Kjartan


