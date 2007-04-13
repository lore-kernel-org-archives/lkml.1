Return-Path: <linux-kernel-owner+w=401wt.eu-S1753015AbXDMCas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbXDMCas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 22:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbXDMCas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 22:30:48 -0400
Received: from 3e44a16d.adsl.index.hu ([217.20.130.176]:50805 "EHLO
	dh.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753015AbXDMCar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 22:30:47 -0400
X-Greylist: delayed 2539 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Apr 2007 22:30:46 EDT
From: Pallai Roland <dap@mail.index.hu>
Organization: magex
To: linux-kernel@vger.kernel.org
Subject: D-Link DFE-580TX 4 port Server Adapter problem: only 2 of 4 ports
Date: Fri, 13 Apr 2007 03:48:22 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704130348.22852.dap@mail.index.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


 I've got a problem with my DFE-580TX cards when I installed thoose into
a new server box. One card has been worked before in a test box,
it's sure, here is a dmesg snippet when everything was OK:

Apr  3 22:10:38 cyrax kernel: sundance.c:v1.2 11-Sep-2006  Written by Donald Becker
Apr  3 22:10:38 cyrax kernel:   http://www.scyld.com/network/sundance.html
Apr  3 22:10:38 cyrax kernel: ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 21 (level, low) -> IRQ 23
Apr  3 22:10:38 cyrax kernel: eth2: D-Link DFE-580TX 4 port Server Adapter at 0001a800, 00:0d:88:cc:da:dc, IRQ 23.
Apr  3 22:10:38 cyrax kernel: eth2: MII PHY found at address 1, status 0x7809 advertising 01e1.
Apr  3 22:10:38 cyrax kernel: ACPI: PCI Interrupt 0000:02:05.0[A] -> GSI 22 (level, low) -> IRQ 18
Apr  3 22:10:39 cyrax kernel: eth3: D-Link DFE-580TX 4 port Server Adapter at 0001b000, 00:0d:88:cc:da:dd, IRQ 18.
Apr  3 22:10:39 cyrax kernel: eth3: MII PHY found at address 1, status 0x7809 advertising 01e1.
Apr  3 22:10:39 cyrax kernel: ACPI: PCI Interrupt 0000:02:06.0[A] -> GSI 23 (level, low) -> IRQ 19
Apr  3 22:10:39 cyrax kernel: eth4: D-Link DFE-580TX 4 port Server Adapter at 0001b400, 00:0d:88:cc:da:de, IRQ 19.
Apr  3 22:10:39 cyrax kernel: eth4: MII PHY found at address 1, status 0x7809 advertising 01e1.
Apr  3 22:10:39 cyrax kernel: ACPI: PCI Interrupt 0000:02:07.0[A] -> GSI 20 (level, low) -> IRQ 20
Apr  3 22:10:39 cyrax kernel: eth5: D-Link DFE-580TX 4 port Server Adapter at 0001b800, 00:0d:88:cc:da:df, IRQ 20.
Apr  3 22:10:39 cyrax kernel: eth5: MII PHY found at address 1, status 0x7809 advertising 01e1.

 And the current dmesg from the new box, when I've only 2 of 4 ports on each card:

sundance.c:v1.2 11-Sep-2006  Written by Donald Becker
  http://www.scyld.com/network/sundance.html
ACPI: PCI Interrupt 0000:05:04.0[A] -> GSI 21 (level, low) -> IRQ 22
eth2: D-Link DFE-580TX 4 port Server Adapter at 00012180, 00:00:00:00:00:00, IRQ 22.
eth2: No MII transceiver found, aborting.  ASIC status ffffffff
ACPI: PCI Interrupt 0000:05:05.0[A] -> GSI 22 (level, low) -> IRQ 23
eth2: D-Link DFE-580TX 4 port Server Adapter at 00012100, 00:00:00:00:00:00, IRQ 23.
eth2: No MII transceiver found, aborting.  ASIC status ffffffff
ACPI: PCI Interrupt 0000:05:06.0[A] -> GSI 23 (level, low) -> IRQ 19
eth2: D-Link DFE-580TX 4 port Server Adapter at 00012080, 00:0d:88:cc:da:ee, IRQ 19.
eth2: MII PHY found at address 1, status 0x7809 advertising 01e1.
ACPI: PCI Interrupt 0000:05:07.0[A] -> GSI 20 (level, low) -> IRQ 21
eth3: D-Link DFE-580TX 4 port Server Adapter at 00012000, 00:0d:88:cc:da:ef, IRQ 21.
eth3: MII PHY found at address 1, status 0x7809 advertising 01e1.
ACPI: PCI Interrupt 0000:06:04.0[A] -> GSI 22 (level, low) -> IRQ 23
eth4: D-Link DFE-580TX 4 port Server Adapter at 00011180, 00:00:00:00:00:00, IRQ 23.
eth4: No MII transceiver found, aborting.  ASIC status ffffffff
ACPI: PCI Interrupt 0000:06:05.0[A] -> GSI 21 (level, low) -> IRQ 22
eth4: D-Link DFE-580TX 4 port Server Adapter at 00011100, 00:00:00:00:00:00, IRQ 22.
eth4: No MII transceiver found, aborting.  ASIC status ffffffff
ACPI: PCI Interrupt 0000:06:06.0[A] -> GSI 20 (level, low) -> IRQ 21
eth4: D-Link DFE-580TX 4 port Server Adapter at 00011080, 00:0d:88:cc:da:de, IRQ 21.
eth4: MII PHY found at address 1, status 0x7809 advertising 01e1.
ACPI: PCI Interrupt 0000:06:07.0[A] -> GSI 23 (level, low) -> IRQ 19
eth5: D-Link DFE-580TX 4 port Server Adapter at 00011000, 00:0d:88:cc:da:df, IRQ 19.
eth5: MII PHY found at address 1, status 0x7809 advertising 01e1.


 Kernel version is vanilla 2.6.20.3, Sundance MMIO disabled in the config. I
can send lspci, full dmesg, .config if anyone interested in. Maybe it's a BIOS problem?
What should I try?


thanks,
--
 d

