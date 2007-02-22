Return-Path: <linux-kernel-owner+w=401wt.eu-S932129AbXBVNyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbXBVNyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 08:54:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933068AbXBVNyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 08:54:33 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:58821 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129AbXBVNyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 08:54:32 -0500
X-Greylist: delayed 1485 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Feb 2007 08:54:31 EST
Date: Thu, 22 Feb 2007 15:29:42 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: ata-piix ACPI errors
Message-ID: <Pine.SOC.4.64.0702221525480.20840@math>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Testbooted 2.6.21-rc1+todays git on a PC with Intel 845 chipset and PATA 
HDD. Works fine but I now have these ACPI errors in dmesg, maybe someone 
is interested:

ata_piix 0000:00:1f.1: version 2.00ac7
PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1f.1 to 64
ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001ffa0 irq 14
ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001ffa8 irq 15
scsi0 : ata_piix
ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA] (Node c18edbf8), AE_AML_OPERAND_VALUE
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN0.DRV0._GTF] (Node c18ed608), AE_AML_OPERAND_VALUE
ata1.00: ATA-5: ST380021A, 3.19, max UDMA/100
ata1.00: 156301488 sectors, multi 16: LBA
ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA] (Node c18edbf8), AE_AML_OPERAND_VALUE
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN0.DRV0._GTF] (Node c18ed608), AE_AML_OPERAND_VALUE
ata1.00: configured for UDMA/100
scsi1 : ata_piix
ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA] (Node c18edbf8), AE_AML_OPERAND_VALUE
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN1.DRV0._GTF] (Node c18ed464), AE_AML_OPERAND_VALUE
ata2.00: ATAPI, max UDMA/33
ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA] (Node c18edbf8), AE_AML_OPERAND_VALUE
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN1.DRV0._GTF] (Node c18ed464), AE_AML_OPERAND_VALUE
ata2.00: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      ST380021A        3.19 PQ: 0 ANSI: 5
scsi 1:0:0:0: CD-ROM            _NEC     DV-5800B         G9H3 PQ: 0 ANSI: 5

-- 
Meelis Roos (mroos@linux.ee)
