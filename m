Return-Path: <linux-kernel-owner+w=401wt.eu-S1756988AbYBRA22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbYBRA22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 19:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbYBRA2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 19:28:18 -0500
Received: from eazy.amigager.de ([213.239.192.238]:42392 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbYBRA2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 19:28:17 -0500
Date: Mon, 18 Feb 2008 01:28:15 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.25-rc2 hangs after "Suspending console(s)"
Message-ID: <20080218002815.GA4612@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

with 2.6.25-rc2, my Mac mini Core Duo hangs at suspend. The last
message on the console is "Suspending console(s)". I also tried some
other versions after 2.6.24, all of them fail with this hang.

I attached the lspci output for the case that it matters.

Regards,
Tino

--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=lspci

00:00.0 Host bridge [0600]: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express Memory Controller Hub [8086:27a0] (rev 03)
	Subsystem: Intel Corporation Unknown device [8086:7270]
	Flags: bus master, fast devsel, latency 0
	Capabilities: <access denied>
	Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller [8086:27a2] (rev 03) (prog-if 00 [VGA controller])
	Subsystem: Intel Corporation Unknown device [8086:7270]
	Flags: bus master, fast devsel, latency 0, IRQ 17
	Memory at 90380000 (32-bit, non-prefetchable) [size=512K]
	I/O ports at 20f0 [size=8]
	Memory at 80000000 (32-bit, prefetchable) [size=256M]
	Memory at 90400000 (32-bit, non-prefetchable) [size=256K]
	Capabilities: <access denied>

00:07.0 Performance counters [1101]: Intel Corporation Unknown device [8086:27a3] (rev 03)
	Flags: 66MHz, fast devsel, IRQ 10
	Memory at 90444000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>

00:1b.0 Audio device [0403]: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller [8086:27d8] (rev 02)
	Subsystem: Sigmatel Unknown device [8384:7680]
	Flags: bus master, fast devsel, latency 0, IRQ 21
	Memory at 90440000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge [0604]: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 [8086:27d0] (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: 90200000-902fffff
	Prefetchable memory behind bridge: 0000000050000000-00000000500fffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport-driver

00:1c.1 PCI bridge [0604]: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 [8086:27d2] (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	Memory behind bridge: 90100000-901fffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport-driver

00:1d.0 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 [8086:27c8] (rev 02) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Unknown device [8086:7270]
	Flags: bus master, medium devsel, latency 0, IRQ 20
	I/O ports at 20a0 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.1 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 [8086:27c9] (rev 02) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Unknown device [8086:7270]
	Flags: bus master, medium devsel, latency 0, IRQ 19
	I/O ports at 2080 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.2 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 [8086:27ca] (rev 02) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Unknown device [8086:7270]
	Flags: bus master, medium devsel, latency 0, IRQ 18
	I/O ports at 2060 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.3 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 [8086:27cb] (rev 02) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Unknown device [8086:7270]
	Flags: bus master, medium devsel, latency 0, IRQ 17
	I/O ports at 2040 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.7 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller [8086:27cc] (rev 02) (prog-if 20 [EHCI])
	Subsystem: Intel Corporation Unknown device [8086:7270]
	Flags: bus master, medium devsel, latency 0, IRQ 20
	Memory at 90445400 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [8086:2448] (rev e2) (prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=32
	Memory behind bridge: 90000000-900fffff
	Capabilities: <access denied>

00:1f.0 ISA bridge [0601]: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge [8086:27b9] (rev 02)
	Subsystem: Intel Corporation Unknown device [8086:7270]
	Flags: bus master, medium devsel, latency 0
	Capabilities: <access denied>

00:1f.1 IDE interface [0101]: Intel Corporation 82801G (ICH7 Family) IDE Controller [8086:27df] (rev 02) (prog-if 8a [Master SecP PriP])
	Subsystem: Intel Corporation Unknown device [8086:7270]
	Flags: bus master, medium devsel, latency 0, IRQ 18
	I/O ports at 01f0 [size=8]
	I/O ports at 03f4 [size=1]
	I/O ports at 0170 [size=8]
	I/O ports at 0374 [size=1]
	I/O ports at 20c0 [size=16]
	Kernel driver in use: ata_piix

00:1f.2 IDE interface [0101]: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller [8086:27c4] (rev 02) (prog-if 8f [Master SecP SecO PriP PriO])
	Subsystem: Intel Corporation Unknown device [8086:7270]
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 19
	I/O ports at 20d8 [size=8]
	I/O ports at 20fc [size=4]
	I/O ports at 20d0 [size=8]
	I/O ports at 20f8 [size=4]
	I/O ports at 2020 [size=16]
	Memory at 90445000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ata_piix

00:1f.3 SMBus [0c05]: Intel Corporation 82801G (ICH7 Family) SMBus Controller [8086:27da] (rev 02)
	Subsystem: Intel Corporation Unknown device [8086:7270]
	Flags: medium devsel, IRQ 11
	I/O ports at efa0 [size=32]

01:00.0 Ethernet controller [0200]: Marvell Technology Group Ltd. 88E8053 PCI-E Gigabit Ethernet Controller [11ab:4362] (rev 22)
	Subsystem: Marvell Technology Group Ltd. Marvell RDK-8053 [11ab:5321]
	Flags: bus master, fast devsel, latency 0, IRQ 17
	Memory at 90200000 (64-bit, non-prefetchable) [size=16K]
	I/O ports at 1000 [size=256]
	Expansion ROM at 50000000 [disabled] [size=128K]
	Capabilities: <access denied>
	Kernel driver in use: sky2
	Kernel modules: sky2

02:00.0 Ethernet controller [0200]: Atheros Communications, Inc. AR5006EG 802.11 b/g Wireless PCI Express Adapter [168c:001c] (rev 01)
	Subsystem: Apple Computer Inc. Unknown device [106b:0086]
	Flags: bus master, fast devsel, latency 0, IRQ 11
	Memory at 90100000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: <access denied>
	Kernel modules: ath_pci

03:03.0 FireWire (IEEE 1394) [0c00]: Agere Systems FW323 [11c1:5811] (rev 61) (prog-if 10 [OHCI])
	Subsystem: Agere Systems FW323 [11c1:5811]
	Flags: bus master, fast Back2Back, medium devsel, latency 248, IRQ 19
	Memory at 90000000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: ohci1394
	Kernel modules: ohci1394


--8t9RHnE3ZwKMSgU+--
