Return-Path: <linux-kernel-owner+w=401wt.eu-S2992587AbXDROlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992587AbXDROlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 10:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992674AbXDROlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 10:41:47 -0400
Received: from mailout11.sul.t-online.com ([194.25.134.85]:60711 "EHLO
	mailout11.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992587AbXDROlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 10:41:46 -0400
X-Greylist: delayed 1117 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Apr 2007 10:41:46 EDT
Message-Id: <6.1.1.1.2.20070418161428.02bbb348@192.168.6.12>
X-Mailer: QUALCOMM Windows Eudora Version 6.1.1.1
Date: Wed, 18 Apr 2007 16:22:28 +0200
To: linux-kernel@vger.kernel.org
From: Roger While <simrw@sim-basis.de>
Subject: libata/SATA noprobe
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
X-SIMBasis-MailScanner-Information: Please contact the ISP for more information
X-SIMBasis-MailScanner: Found to be clean
X-SIMBasis-MailScanner-From: simrw@sim-basis.de
X-ID: GcLAjEZfoerMx4-EXFixzsc9SwdLfga8wZo+a6woFZLTANlVZ8D1Eq@t-dialin.net
X-TOI-MSGID: 731355a2-efad-435e-8c38-599fd98a17f9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any knob/option to prevent libata
probing non-existent channels ?
Specifically how can I stop the kernel probing
the second SATA? -

<4>ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
<7>libata version 2.00 loaded.
<7>ata_piix 0000:00:1f.2: version 2.00ac7
<6>ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
<6>GSI 18 sharing vector 0xD9 and IRQ 18
<6>ACPI: PCI Interrupt 0000:00:1f.2[C] -> GSI 20 (level, low) -> IRQ 217
<7>PCI: Setting latency timer of device 0000:00:1f.2 to 64
<6>ata1: SATA max UDMA/133 cmd 0xFE00 ctl 0xFE12 bmdma 0xFEA0 irq 217
<6>ata2: SATA max UDMA/133 cmd 0xFE20 ctl 0xFE32 bmdma 0xFEA8 irq 217
<6>scsi0 : ata_piix
<6>ata1.00: ATA-7, max UDMA/133, 490234752 sectors: LBA48 NCQ (depth 0/1)
<6>ata1.00: ata1: dev 0 multi count 8
<6>ata1.00: configured for UDMA/133
<6>scsi1 : ata_piix
<4>ata2: port is slow to respond, please be patient (Status 0xff)
<3>ata2: port failed to respond (30 secs, Status 0xff)
<3>ata2: SRST failed (status 0xFF)
<3>ata2: SRST failed (err_mask=0x100)
<4>ata2: softreset failed, retrying in 5 secs
<3>ata2: SRST failed (status 0xFF)
<3>ata2: SRST failed (err_mask=0x100)
<4>ata2: softreset failed, retrying in 5 secs
<3>ata2: SRST failed (status 0xFF)
<3>ata2: SRST failed (err_mask=0x100)
<3>ata2: reset failed, giving up

There is physically no second SATA connection.
This is a Dell small desktop form factor.
BIOS is latest, 2nd SATA and 2nd IDE are NOT selectable
in BIOS (marked as off)

lspci :
00:00.0 Host bridge: Intel Corporation 82915G/P/GV/GL/PL/910GL Memory 
Controller Hub (rev 04)
00:01.0 PCI bridge: Intel Corporation 82915G/P/GV/GL/PL/910GL PCI Express 
Root Port (rev 04)
00:02.0 VGA compatible controller: Intel Corporation 82915G/GV/910GL 
Integrated Graphics Controller (rev 04)
00:02.1 Display controller: Intel Corporation 82915G Integrated Graphics 
Controller (rev 04)
00:1c.0 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) 
PCI Express Port 1 (rev 03)
00:1c.1 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) 
PCI Express Port 2 (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 
Family) USB UHCI #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 
Family) USB UHCI #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 
Family) USB UHCI #3 (rev 03)
00:1d.3 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 
Family) USB UHCI #4 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 
Family) USB2 EHCI Controller (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d3)
00:1e.2 Multimedia audio controller: Intel Corporation 
82801FB/FBM/FR/FW/FRW (ICH6 Family) AC'97 Audio Controller (rev 03)
00:1f.0 ISA bridge: Intel Corporation 82801FB/FR (ICH6/ICH6R) LPC Interface 
Bridge (rev 03)
00:1f.1 IDE interface: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 
Family) IDE Controller (rev 03)
00:1f.2 IDE interface: Intel Corporation 82801FB/FW (ICH6/ICH6W) SATA 
Controller (rev 03)
00:1f.3 SMBus: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) SMBus 
Controller (rev 03)
02:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5751 Gigabit 
Ethernet PCI Express (rev 01)

Full dmesg and other info can be supplied

Roger While

