Return-Path: <linux-kernel-owner+w=401wt.eu-S1755424AbYFZHST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbYFZHST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 03:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbYFZHSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 03:18:10 -0400
Received: from mxsec.euro-web.fr ([81.93.243.199]:42853 "EHLO
	mxsec.euro-web.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbYFZHSG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 03:18:06 -0400
From: David CHANIAL <david.ml@euro-web.fr>
Organization: Euro Web
To: Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: weird bug on r8169 with usb
Date: Thu, 26 Jun 2008 09:18:02 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200806250018.37617.david.ml@euro-web.fr> <20080625185234.GA30834@electric-eye.fr.zoreil.com>
In-Reply-To: <20080625185234.GA30834@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806260918.03073.david.ml@euro-web.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Wednesday 25 June 2008 20:52:34 Francois Romieu, vous avez écrit :
> Yes, please send the unabbreviated output of 'lspci -vx' and 'dmesg'.

Hi Francois,

thanks for your time,
Both are below.
(After a boot without usb devices plugger, devices was plugger after the end 
of boot)

# lspci -vx
00:00.0 Host bridge: Intel Corporation DRAM Controller (rev 02)
        Subsystem: Hewlett-Packard Company Unknown device 2a6f
        Flags: bus master, fast devsel, latency 0
        Capabilities: [e0] Vendor Specific Information <?>
00: 86 80 c0 29 06 00 90 20 02 00 00 06 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 6f 2a
30: 00 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00

00:01.0 PCI bridge: Intel Corporation PCI Express Root Port (rev 02) (prog-if 
00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
        I/O behind bridge: 0000d000-0000dfff
        Memory behind bridge: fa000000-feafffff
        Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
        Capabilities: [88] Subsystem: Intel Corporation Unknown device 0000
        Capabilities: [80] Power Management version 3
        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable-
        Capabilities: [a0] Express Root Port (Slot+), MSI 00
        Kernel driver in use: pcieport-driver
00: 86 80 c1 29 07 01 10 00 02 00 04 06 08 00 01 00
10: 00 00 00 00 00 00 00 00 00 04 04 00 d0 d0 00 00
20: 00 fa a0 fe 01 d0 f1 df 00 00 00 00 00 00 00 00
30: 00 00 00 00 88 00 00 00 00 00 00 00 05 01 1a 00

00:1a.0 USB Controller: Intel Corporation USB UHCI Controller #4 (rev 02) 
(prog-if 00 [UHCI])
        Subsystem: Hewlett-Packard Company Unknown device 2a6f
        Flags: bus master, medium devsel, latency 0, IRQ 16
        I/O ports at b400 [size=32]
        Capabilities: [50] PCIe advanced features <?>
        Kernel driver in use: uhci_hcd
00: 86 80 37 29 05 00 90 02 02 00 03 0c 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 b4 00 00 00 00 00 00 00 00 00 00 3c 10 6f 2a
30: 00 00 00 00 50 00 00 00 00 00 00 00 05 01 00 00

00:1a.1 USB Controller: Intel Corporation USB UHCI Controller #5 (rev 02) 
(prog-if 00 [UHCI])
        Subsystem: Hewlett-Packard Company Unknown device 2a6f
        Flags: bus master, medium devsel, latency 0, IRQ 21
        I/O ports at b480 [size=32]
        Capabilities: [50] PCIe advanced features <?>
        Kernel driver in use: uhci_hcd
00: 86 80 38 29 05 00 90 02 02 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 81 b4 00 00 00 00 00 00 00 00 00 00 3c 10 6f 2a
30: 00 00 00 00 50 00 00 00 00 00 00 00 07 02 00 00

00:1a.7 USB Controller: Intel Corporation USB2 EHCI Controller #2 (rev 02) 
(prog-if 20 [EHCI])
        Subsystem: Hewlett-Packard Company Unknown device 2a6f
        Flags: bus master, medium devsel, latency 0, IRQ 18
        Memory at f9efec00 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
        Capabilities: [58] Debug port: BAR=1 offset=00a0
        Capabilities: [98] PCIe advanced features <?>
        Kernel driver in use: ehci_hcd
00: 86 80 3c 29 06 00 90 02 02 20 03 0c 00 00 00 00
10: 00 ec ef f9 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 6f 2a
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 03 00 00

00:1b.0 Audio device: Intel Corporation HD Audio Controller (rev 02)
        Subsystem: Hewlett-Packard Company Unknown device 2a6f
        Flags: bus master, fast devsel, latency 0, IRQ 22
        Memory at f9ef4000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
        Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
        Capabilities: [70] Express Root Complex Integrated Endpoint, MSI 00
        Kernel driver in use: HDA Intel
00: 86 80 3e 29 06 00 10 00 02 00 03 04 08 00 00 00
10: 04 40 ef f9 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 6f 2a
30: 00 00 00 00 50 00 00 00 00 00 00 00 03 01 00 00

00:1c.0 PCI bridge: Intel Corporation PCI Express Port 1 (rev 02) (prog-if 00 
[Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
        Capabilities: [40] Express Root Port (Slot+), MSI 00
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable-
        Capabilities: [90] Subsystem: Hewlett-Packard Company Unknown device 
2a6f
        Capabilities: [a0] Power Management version 2
        Kernel driver in use: pcieport-driver
00: 86 80 40 29 04 01 10 00 02 00 04 06 08 00 81 00
10: 00 00 00 00 00 00 00 00 00 03 03 00 f0 00 00 20
20: f0 ff 00 00 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 02 00

00:1c.2 PCI bridge: Intel Corporation PCI Express Port 3 (rev 02) (prog-if 00 
[Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 0000e000-0000efff
        Memory behind bridge: feb00000-febfffff
        Prefetchable memory behind bridge: 00000000f8f00000-00000000f8ffffff
        Capabilities: [40] Express Root Port (Slot+), MSI 00
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable-
        Capabilities: [90] Subsystem: Hewlett-Packard Company Unknown device 
2a6f
        Capabilities: [a0] Power Management version 2
        Kernel driver in use: pcieport-driver
00: 86 80 44 29 07 01 10 00 02 00 04 06 08 00 81 00
10: 00 00 00 00 00 00 00 00 00 02 02 00 e0 e0 00 00
20: b0 fe b0 fe f1 f8 f1 f8 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 03 02 00

00:1d.0 USB Controller: Intel Corporation USB UHCI Controller #1 (rev 02) 
(prog-if 00 [UHCI])
        Subsystem: Hewlett-Packard Company Unknown device 2a6f
        Flags: bus master, medium devsel, latency 0, IRQ 23
        I/O ports at b800 [size=32]
        Capabilities: [50] PCIe advanced features <?>
        Kernel driver in use: uhci_hcd
00: 86 80 34 29 05 00 90 02 02 00 03 0c 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 b8 00 00 00 00 00 00 00 00 00 00 3c 10 6f 2a
30: 00 00 00 00 50 00 00 00 00 00 00 00 0e 01 00 00

00:1d.1 USB Controller: Intel Corporation USB UHCI Controller #2 (rev 02) 
(prog-if 00 [UHCI])
        Subsystem: Hewlett-Packard Company Unknown device 2a6f
        Flags: bus master, medium devsel, latency 0, IRQ 19
        I/O ports at b880 [size=32]
        Capabilities: [50] PCIe advanced features <?>
        Kernel driver in use: uhci_hcd
00: 86 80 35 29 05 00 90 02 02 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 81 b8 00 00 00 00 00 00 00 00 00 00 3c 10 6f 2a
30: 00 00 00 00 50 00 00 00 00 00 00 00 0f 02 00 00

00:1d.2 USB Controller: Intel Corporation USB UHCI Controller #3 (rev 02) 
(prog-if 00 [UHCI])
        Subsystem: Hewlett-Packard Company Unknown device 2a6f
        Flags: bus master, medium devsel, latency 0, IRQ 18
        I/O ports at bc00 [size=32]
        Capabilities: [50] PCIe advanced features <?>
        Kernel driver in use: uhci_hcd
00: 86 80 36 29 05 00 90 02 02 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 bc 00 00 00 00 00 00 00 00 00 00 3c 10 6f 2a
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 03 00 00

00:1d.3 USB Controller: Intel Corporation USB UHCI Controller #6 (rev 02) 
(prog-if 00 [UHCI])
        Subsystem: Hewlett-Packard Company Unknown device 2a6f
        Flags: bus master, medium devsel, latency 0, IRQ 16
        I/O ports at c000 [size=32]
        Capabilities: [50] PCIe advanced features <?>
        Kernel driver in use: uhci_hcd
00: 86 80 39 29 05 00 90 02 02 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 c0 00 00 00 00 00 00 00 00 00 00 3c 10 6f 2a
30: 00 00 00 00 50 00 00 00 00 00 00 00 05 04 00 00

00:1d.7 USB Controller: Intel Corporation USB2 EHCI Controller #1 (rev 02) 
(prog-if 20 [EHCI])
        Subsystem: Hewlett-Packard Company Unknown device 2a6f
        Flags: bus master, medium devsel, latency 0, IRQ 23
        Memory at f9eff800 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
        Capabilities: [58] Debug port: BAR=1 offset=00a0
        Capabilities: [98] PCIe advanced features <?>
        Kernel driver in use: ehci_hcd
00: 86 80 3a 29 06 00 90 02 02 20 03 0c 00 00 00 00
10: 00 f8 ef f9 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 6f 2a
30: 00 00 00 00 50 00 00 00 00 00 00 00 0e 01 00 00

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92) (prog-if 01 
[Subtractive decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
        Memory behind bridge: f9f00000-f9ffffff
        Capabilities: [50] Subsystem: Hewlett-Packard Company Unknown device 
2a6f
00: 86 80 4e 24 06 01 10 00 92 01 04 06 00 00 01 00
10: 00 00 00 00 00 00 00 00 00 01 01 40 f0 00 80 22
20: f0 f9 f0 f9 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 50 00 00 00 00 00 00 00 00 00 02 00

00:1f.0 ISA bridge: Intel Corporation LPC Interface Controller (rev 02)
        Subsystem: Hewlett-Packard Company Unknown device 2a6f
        Flags: bus master, medium devsel, latency 0
        Capabilities: [e0] Vendor Specific Information <?>
00: 86 80 16 29 07 00 10 02 02 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 6f 2a
30: 00 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00

00:1f.2 RAID bus controller: Intel Corporation 82801 SATA RAID Controller (rev 
02)
        Subsystem: Hewlett-Packard Company Unknown device 2a6f
        Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 19
        I/O ports at c880 [size=8]
        I/O ports at c800 [size=4]
        I/O ports at c480 [size=8]
        I/O ports at c400 [size=4]
        I/O ports at c080 [size=32]
        Memory at f9eff000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/4 Enable-
        Capabilities: [70] Power Management version 3
        Capabilities: [a8] SATA HBA <?>
        Capabilities: [b0] PCIe advanced features <?>
        Kernel driver in use: ahci
00: 86 80 22 28 07 00 b0 02 02 00 04 01 00 00 00 00
10: 81 c8 00 00 01 c8 00 00 81 c4 00 00 01 c4 00 00
20: 81 c0 00 00 00 f0 ef f9 00 00 00 00 3c 10 6f 2a
30: 00 00 00 00 80 00 00 00 00 00 00 00 0f 02 00 00

00:1f.3 SMBus: Intel Corporation SMBus Controller (rev 02)
        Subsystem: Hewlett-Packard Company Unknown device 2a6f
        Flags: medium devsel, IRQ 10
        Memory at f9effc00 (64-bit, non-prefetchable) [size=256]
        I/O ports at 0400 [size=32]
00: 86 80 30 29 03 00 80 02 02 00 05 0c 00 00 00 00
10: 04 fc ef f9 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 04 00 00 00 00 00 00 00 00 00 00 3c 10 6f 2a
30: 00 00 00 00 00 00 00 00 00 00 00 00 0a 03 00 00

01:05.0 FireWire (IEEE 1394): Agere Systems FW323 (rev 70) (prog-if 10 [OHCI])
        Subsystem: Hewlett-Packard Company Unknown device 2a6f
        Flags: bus master, medium devsel, latency 64, IRQ 20
        Memory at f9fff000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [44] Power Management version 2
        Kernel driver in use: ohci1394
00: c1 11 11 58 16 00 90 02 70 10 00 0c 08 40 00 00
10: 00 f0 ff f9 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 6f 2a
30: 00 00 00 00 44 00 00 00 00 00 00 00 04 01 0c 18

02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI 
Express Gigabit Ethernet controller (rev 02)
        Subsystem: Hewlett-Packard Company Unknown device 2a6f
        Flags: bus master, fast devsel, latency 0, IRQ 18
        I/O ports at e800 [size=256]
        Memory at febff000 (64-bit, non-prefetchable) [size=4K]
        Memory at f8ff0000 (64-bit, prefetchable) [size=64K]
        Expansion ROM at febc0000 [disabled] [size=128K]
        Capabilities: [40] Power Management version 3
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
        Capabilities: [70] Express Endpoint, MSI 01
        Capabilities: [b0] MSI-X: Enable- Mask- TabSize=2
        Capabilities: [d0] Vital Product Data <?>
        Kernel driver in use: r8169
00: ec 10 68 81 07 00 10 00 02 00 00 02 08 00 00 00
10: 01 e8 00 00 00 00 00 00 04 f0 bf fe 00 00 00 00
20: 0c 00 ff f8 00 00 00 00 00 00 00 00 3c 10 6f 2a
30: 00 00 bc fe 40 00 00 00 00 00 00 00 0a 01 00 00

04:00.0 VGA compatible controller: nVidia Corporation Unknown device 0402 (rev 
a1) (prog-if 00 [VGA controller])
        Subsystem: ASUSTeK Computer Inc. Unknown device 034e
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
        Memory at d0000000 (64-bit, prefetchable) [size=256M]
        Memory at fa000000 (64-bit, non-prefetchable) [size=32M]
        I/O ports at dc00 [size=128]
        Expansion ROM at feae0000 [disabled] [size=128K]
        Capabilities: [60] Power Management version 2
        Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
        Capabilities: [78] Express Endpoint, MSI 00
        Kernel driver in use: nvidia
        Kernel modules: nvidia
00: de 10 02 04 07 00 10 00 a1 00 00 03 00 00 00 00
10: 00 00 00 fd 0c 00 00 d0 00 00 00 00 04 00 00 fa
20: 00 00 00 00 01 dc 00 00 00 00 00 00 43 10 4e 03
30: 00 00 ae fe 60 00 00 00 00 00 00 00 05 01 00 00

# dmesg
PI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
Processor #2 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
Processor #3 6:15 APIC version 20
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at d4000000 (gap: d0000000:2ee00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 227584
Kernel command line: root=/dev/sda3
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2400.082 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 903184k/917504k available (3795k kernel code, 13828k reserved, 1361k 
data, 284k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb5000 - 0xfffff000   ( 296 kB)
    vmalloc : 0xf8800000 - 0xfffb3000   ( 119 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0611000 - 0xc0658000   ( 284 kB)
      .data : 0xc04b4eaa - 0xc060937c   (1361 kB)
      .text : 0xc0100000 - 0xc04b4eaa   (3795 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
Calibrating delay using timer specific routine.. 4804.11 BogoMIPS 
(lpj=9608236)
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
using mwait in idle threads.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
CPU0: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
Booting processor 1/1 ip 4000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4800.21 BogoMIPS 
(lpj=9600435)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
Booting processor 2/2 ip 4000
Initializing CPU#2
Calibrating delay using timer specific routine.. 4800.16 BogoMIPS 
(lpj=9600335)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#2.
CPU2: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
Booting processor 3/3 ip 4000
Initializing CPU#3
Calibrating delay using timer specific routine.. 4800.40 BogoMIPS 
(lpj=9600808)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#3.
CPU3: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
Total of 4 processors activated (19204.90 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Brought up 4 CPUs
net_namespace: 544 bytes
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=4
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: Error attaching device data
ACPI: Error attaching device data
ACPI: Error attaching device data
ACPI: Error attaching device data
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 *4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 *7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 *14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
system 00:06: ioport range 0x4d0-0x4d1 has been reserved
system 00:06: ioport range 0x800-0x87f has been reserved
system 00:06: ioport range 0x480-0x4bf has been reserved
system 00:06: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:06: iomem range 0xfed20000-0xfed8ffff has been reserved
system 00:08: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:08: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:09: ioport range 0xa00-0xadf has been reserved
system 00:0b: iomem range 0xffc00000-0xffefffff has been reserved
system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
system 00:0d: iomem range 0x0-0x9ffff could not be reserved
system 00:0d: iomem range 0xc0000-0xcffff could not be reserved
system 00:0d: iomem range 0xe0000-0xfffff could not be reserved
system 00:0d: iomem range 0x100000-0xcfffffff could not be reserved
system 00:0d: iomem range 0x0-0x0 could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: d000-dfff
  MEM window: 0xfa000000-0xfeafffff
  PREFETCH window: 0x00000000d0000000-0x00000000dfffffff
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.2
  IO window: e000-efff
  MEM window: 0xfeb00000-0xfebfffff
  PREFETCH window: 0x00000000f8f00000-0x00000000f8ffffff
PCI: Bridge: 0000:00:1e.0
  IO window: disabled.
  MEM window: 0xf9f00000-0xf9ffffff
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.2 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Machine check exception polling timer started.
audit: initializing netlink socket (disabled)
type=2000 audit(1214343094.560:1): initialized
NTFS driver 2.1.29 [Flags: R/W].
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
pci 0000:04:00.0: Boot video device
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
PCI: Setting latency timer of device 0000:00:1c.2 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.2:pcie00]
Allocate Port Service[0000:00:1c.2:pcie02]
lp: driver loaded but no devices found
Linux agpgart interface v0.103
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: SSDT CFFC0270, 0277 (r1 HPQOEM SLIC-CPC       11 INTL 20051117)
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: SSDT CFFC0700, 0277 (r1 HPQOEM SLIC-CPC       12 INTL 20051117)
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: SSDT CFFC0B90, 0277 (r1 HPQOEM SLIC-CPC       12 INTL 20051117)
ACPI: ACPI0007:02 is registered as cooling_device2
ACPI: SSDT CFFC1020, 0277 (r1 HPQOEM SLIC-CPC       12 INTL 20051117)
ACPI: ACPI0007:03 is registered as cooling_device3
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
brd: module loaded
loop: module loaded
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
r8169 Gigabit Ethernet driver 2.2LK loaded
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:02:00.0 to 64
r8169 0000:02:00.0: no MSI. Back to INTx.
eth0: RTL8168c/8111c at 0xf8828000, 00:1e:8c:c4:66:7d, XID 3c2000c0 IRQ 18
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Probing IDE interface ide0...
Probing IDE interface ide1...
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ahci 0000:00:1f.2: version 3.0
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl RAID mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m2048@0xf9eff000 port 0xf9eff100 irq 19
ata2: SATA max UDMA/133 abar m2048@0xf9eff000 port 0xf9eff180 irq 19
ata3: SATA max UDMA/133 abar m2048@0xf9eff000 port 0xf9eff200 irq 19
ata4: SATA max UDMA/133 abar m2048@0xf9eff000 port 0xf9eff280 irq 19
ata5: SATA max UDMA/133 abar m2048@0xf9eff000 port 0xf9eff300 irq 19
ata6: SATA max UDMA/133 abar m2048@0xf9eff000 port 0xf9eff380 irq 19
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-8: ST3500320AS, SD15, max UDMA/133
ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATAPI: HL-DT-ST DVD-RW GSA-H60L, DC08, max UDMA/100
ata2.00: configured for UDMA/100
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-7: Hitachi HDS721075KLA330, GK8OA87A, max UDMA/133
ata3.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata3.00: configured for UDMA/133
ata4: SATA link down (SStatus 0 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      ST3500320AS      SD15 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD-RW GSA-H60L  DC08 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sr 1:0:0:0: Attached scsi generic sg1 type 5
scsi 2:0:0:0: Direct-Access     ATA      Hitachi HDS72107 GK8O PQ: 0 ANSI: 5
sd 2:0:0:0: [sdb] 1465149168 512-byte hardware sectors (750156 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
sd 2:0:0:0: [sdb] 1465149168 512-byte hardware sectors (750156 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
 sdb: sdb1 sdb2
sd 2:0:0:0: [sdb] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg2 type 0
ACPI: PCI Interrupt 0000:01:05.0[A] -> GSI 20 (level, low) -> IRQ 20
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[20]  MMIO=[f9fff000-f9fff7ff]  
Max Packet=[1024]  IR/IT contexts=[8/8]
ieee1394: raw1394: /dev/raw1394 device initialized
usbmon: debugfs is not available
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf9efec00
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf9eff800
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 8 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000b400
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000b480
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 1-1: new high speed USB device using ehci_hcd and address 2
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000b800
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000b880
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
usb 1-1: configuration #1 chosen from 1 choice
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000bc00
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000c000
usb usb8: configuration #1 chosen from 1 choice
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
usb 2-5: new high speed USB device using ehci_hcd and address 2
usb 2-5: configuration #1 chosen from 1 choice
hub 2-5:1.0: USB hub found
hub 2-5:1.0: 4 ports detected
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[001e8c000106b1f9]
hub 2-0:1.0: unable to enumerate USB device on port 8
usb 8-2: new low speed USB device using uhci_hcd and address 2
usb 8-2: configuration #1 chosen from 1 choice
usb 2-5.1: new low speed USB device using ehci_hcd and address 4
usb 2-5.1: configuration #1 chosen from 1 choice
usb 2-5.2: new high speed USB device using ehci_hcd and address 5
usb 2-5.2: configuration #1 chosen from 1 choice
usb 2-5.4: new full speed USB device using ehci_hcd and address 6
usb 2-5.4: configuration #1 chosen from 1 choice
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
scsi6 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 5
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: Microsft Microsoft Wireless Desktop Receiver 3.1 as /class/input/input2
input: USB HID v1.11 Keyboard [Microsft Microsoft Wireless Desktop Receiver 
3.1] on usb-0000:00:1d.3-2
input: Microsft Microsoft Wireless Desktop Receiver 3.1 as /class/input/input3
input: USB HID v1.11 Mouse [Microsft Microsoft Wireless Desktop Receiver 3.1] 
on usb-0000:00:1d.3-2
HID device claimed by neither input, hiddev nor hidraw
input: Logitech USB Receiver as /class/input/input4
input: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1d.7-5.4
input: Logitech USB Receiver as /class/input/input5
input: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1d.7-5.4
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.16rc2 (Thu Jan 31 
16:40:16 2008 UTC).
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1b.0 to 64
hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
ALSA device list:
  #0: HDA Intel at 0xf9ef4000 irq 22
oprofile: using NMI interrupt.
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Starting balanced_irq
Using IPI No-Shortcut mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 284k freed
nvidia: module license 'NVIDIA' taints kernel.
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:04:00.0 to 64
NVRM: loading NVIDIA UNIX x86 Kernel Module  173.14.09  Wed Jun  4 23:43:17 
PDT 2008
EXT3 FS on sda3, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 506036k swap on /dev/sda2.  Priority:-1 extents:1 across:506036k
scsi 6:0:0:0: Direct-Access     Generic- Compact Flash    1.00 PQ: 0 ANSI: 0 
CCS
sd 6:0:0:0: [sdc] Attached SCSI removable disk
sd 6:0:0:0: Attached scsi generic sg3 type 0
usb-storage: device scan complete
r8169: eth0: link up
r8169: eth0: link up
eth0: no IPv6 routers present


-- 
David CHANIAL - Euro Web SARL
 http://www.euro-web.fr/
 Conseil & Infogérance
 Location de serveurs
