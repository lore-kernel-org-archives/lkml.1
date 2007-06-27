Return-Path: <linux-kernel-owner+w=401wt.eu-S1762290AbXF0ThZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762290AbXF0ThZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 15:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbXF0ThO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 15:37:14 -0400
Received: from mailbackup.inode.at ([213.229.60.24]:57740 "EHLO
	mailbackup.inode.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbXF0ThN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 15:37:13 -0400
Message-ID: <4682BC12.2090209@wm1.at>
Date: Wed, 27 Jun 2007 21:35:46 +0200
From: Willi Mann <willi@wm1.at>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PCI: Bus #03 (-#06) is hidden behind transparent bridge ...
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

the kernel output said I should report, so I report it:

I get the following lines at boot:

ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 1180-11bf claimed by ICH4 GPIO
PCI: Transparent bridge - 0000:00:1e.0
PCI: Bus #03 (-#06) is hidden behind transparent bridge #02 (-#02) (try
'pci=assign-busses')
Please report the result to linux-kernel to fix this permanently
PCI: Bus #07 (-#0a) is hidden behind transparent bridge #02 (-#02) (try
'pci=assign-busses')
Please report the result to linux-kernel to fix this permanently
PCI: Bus #0b (-#0e) is hidden behind transparent bridge #02 (-#02) (try
'pci=assign-busses')
Please report the result to linux-kernel to fix this permanently

With pci=assign-busses, I get

ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 1180-11bf claimed by ICH4 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs *6)
ACPI: PCI Interrupt Link [LNKB] (IRQs *10)
ACPI: PCI Interrupt Link [LNKC] (IRQs *6)
ACPI: PCI Interrupt Link [LNKD] (IRQs *6)
ACPI: PCI Interrupt Link [LNKE] (IRQs *10)
ACPI: PCI Interrupt Link [LNKF] (IRQs 10) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 6) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs *10)
ACPI: Power Resource [PFN0] (off)
ACPI: Power Resource [PFN1] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered

The kernel version I'm using is:

Linux version 2.6.22-rc6-686 (Debian
2.6.22~rc6-1~experimental.1~snapshot.9027) (waldi@debian.org) (gcc
version 4.1.3 20070601 (prerelease) (Debian 4.1.2-12)) #1 SMP Wed Jun 27
00:31:19 UTC 2007

Willi

Please CC: me on replies.
