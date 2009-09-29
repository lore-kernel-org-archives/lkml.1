Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbZI2SXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbZI2SXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 14:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbZI2SXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 14:23:09 -0400
Received: from www84.your-server.de ([213.133.104.84]:35266 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbZI2SXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 14:23:08 -0400
Subject: PCI Express-to-PCI Bridge: yenta_cardbus  no bus associated!
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 29 Sep 2009 20:23:25 +0200
Message-Id: <1254248605.8881.1.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi PCI Hackers,

i have trouble with an ExpressCard PCI Express-to-PCI Bridge
manufactured by DUEL System under X86/32 Linux kernel 2.6.31.

The kernel will recognized the Texas Instruments XIO2000(A)/XIO2200(A)
PCI Express-to-PCI Bridge and the attached Texas Instruments PCIxx12
Cardbus Controller, but the yenta socket driver will fail with the
message:

yenta_cardbus 0000:0f:00.0: no bus associated! (try 'pci=assign-busses')

The output of dmesg looks like:

pci 0000:0e:00.0: supports D1 D2
pci 0000:0f:00.0: reg 10 32bit mmio: [0x000000-0x000fff]
pci 0000:0f:00.0: supports D1 D2
pci 0000:0f:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:0f:00.0: PME# disabled
pci 0000:0e:00.0: bridge io port: [0x00-0xfff]
pci 0000:0e:00.0: bridge 32bit mmio: [0x000000-0x0fffff]
pci 0000:0e:00.0: bridge 64bit mmio pref: [0x000000-0x0fffff]
pci 0000:0e:00.0: PCI bridge, secondary bus 0000:0f
pci 0000:0e:00.0:   IO window: disabled
pci 0000:0e:00.0:   MEM window: 0xf1c00000-0xf1cfffff
pci 0000:0e:00.0:   PREFETCH window: disabled
decode_hpp: Could not get hotplug parameters. Use defaults
pci 0000:0e:00.0: enabling device (0000 -> 0002)
pci 0000:0e:00.0: setting latency timer to 64
yenta_cardbus 0000:0f:00.0: no bus associated! (try 'pci=assign-busses')

lspci -v shows:

0e:00.0 PCI bridge: Texas Instruments XIO2000(A)/XIO2200(A) PCI Express-to-PCI Bridge (rev 03) (prog-if 00 [Normal decode])
	Physical Slot: 1
	Flags: bus master, fast devsel, latency 0
	Bus: primary=0e, secondary=0f, subordinate=0f, sec-latency=64
	Memory behind bridge: f1c00000-f1cfffff
	Capabilities: [50] Power Management version 2
	Capabilities: [60] MSI: Enable- Count=1/16 Maskable- 64bit+
	Capabilities: [80] Subsystem: Device 5678:1234
	Capabilities: [90] Express PCI/PCI-X Bridge, MSI 00
	Capabilities: [100] Advanced Error Reporting

0f:00.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
	Subsystem: Texas Instruments Device ac48
	Flags: medium devsel, IRQ 255
	Memory at f1c00000 (32-bit, non-prefetchable) [disabled] [size=4K]
	Bus: primary=00, secondary=00, subordinate=00, sec-latency=0
	I/O window 0: 00000000-00000003 [disabled]
	I/O window 1: 00000000-00000003 [disabled]
	16-bit legacy interface ports at 0001


Any idea where the problem is located or how can i fix it?

If you need further information or dumps please contact me.

Stefani


