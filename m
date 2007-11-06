Return-Path: <linux-kernel-owner+w=401wt.eu-S1757442AbXKFVtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbXKFVtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 16:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754573AbXKFVtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 16:49:13 -0500
Received: from warlock.qualcomm.com ([129.46.50.49]:48233 "EHLO
	warlock.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbXKFVtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 16:49:12 -0500
Message-ID: <4730DE5C.5010205@qualcomm.com>
Date: Tue, 06 Nov 2007 13:36:28 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070926)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: Strange freezes (seems like SATA related)
References: <fa.geuG6UTKiSgc409K9/yA9HzMTUs@ifi.uio.no> <472674CB.10807@shaw.ca>
In-Reply-To: <472674CB.10807@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Can you post the full dmesg output? What kind of drive is this?

Sorry for the delay. I'm on vacation and have sporadic email access.
Full dmesg is pretty long. Here SATA related section.

sata_nv 0000:00:07.0: version 3.4
ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [LSA0] -> GSI 23 (level, high) -> IRQ 23
sata_nv 0000:00:07.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:07.0 to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0xffffc20000a16480 ctl 0xffffc20000a164a0 bmdma 0x00000000000158b0 irq 23
ata2: SATA max UDMA/133 cmd 0xffffc20000a16580 ctl 0xffffc20000a165a0 bmdma 0x00000000000158b8 irq 23
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: SAMSUNG HD080HJ, WT100-33, max UDMA/100
ata1.00: 156301488 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD080HJ  WT10 PQ: 0 ANSI: 5
ata1: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LSA1] -> GSI 22 (level, high) -> IRQ 22
sata_nv 0000:00:08.0: Using ADMA mode

Max



