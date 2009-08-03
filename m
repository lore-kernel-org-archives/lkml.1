Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbZHCItO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbZHCItO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 04:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbZHCItN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 04:49:13 -0400
Received: from mx4.mail.ru ([94.100.176.18]:33736 "EHLO mx4.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354AbZHCItH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 04:49:07 -0400
Date: Mon, 3 Aug 2009 12:44:26 +0400
From: =?utf-8?B?0J7RgdC40L/QvtCyINCh0YLQsNC90LjRgdC70LDQsg==?= 
	<demofly@mail.ru>
Reply-To: =?utf-8?B?0J7RgdC40L/QvtCyINCh0YLQsNC90LjRgdC70LDQsg==?= 
	  <demofly@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <569920565.20090803124426@mail.ru>
To: linux-kernel@vger.kernel.org
Subject: 2.6.30.1-4 kernels freezes dual pentium-3 system
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="----------261781911372B433"
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------------261781911372B433
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

I  have  a  dual  Pentium-3 system. It based on Asus CUR-DLS mainboard
with  2  Pentium-3EB  1000MHz (133 MHz FSB) installed. Also, i'm using
hardware  RAID  controller  3ware  Escalade 7506-4LP, installed in the
PCI-X  expansion  slot.  This  RAID is only one disk system in the box
(RAID-5 on 4 IDE HDD 120GB from Seagate).

Box  works  works fine and very stable under 2.6.29.5 kernel, although
it is angry of buggy MP table (see app. #2 below). But sometimes, this
kernel  correctly  reboots  the  system  at all, but this happens very
rarely.  In  most cases, nobody detects the box was rebooted. And this
is satisfactory for me.

But  under 2.6.30.x kernels box freezes without any alerts. TTL before
freezing  is  about 5-30 mins. I don't know why that shit happens. I'm
ready to send any debug informations about this custom trouble, but if
the specialists will request it with instructions for me.

Appendix #1: lspci

======================================================================

00:00.0 Host bridge: Broadcom CNB20LE Host Bridge (rev 05)
00:00.1 Host bridge: Broadcom CNB20LE Host Bridge (rev 05)
00:02.0 Ethernet controller: Intel Corporation 82557/8/9/0/1 Ethernet Pro 100 (rev 08)
00:04.0 Ethernet controller: 3Com Corporation 3c905B 100BaseTX [Cyclone]
00:07.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27)
00:0f.0 ISA bridge: Broadcom OSB4 South Bridge (rev 50)
00:0f.1 IDE interface: Broadcom OSB4 IDE Controller
01:02.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5701 Gigabit Ethernet (rev 15)
01:03.0 RAID bus controller: 3ware Inc 7xxx/8xxx-series PATA/SATA-RAID (rev 01)
01:05.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1010 Ultra3 SCSI Adapter (rev 01)
01:05.1 SCSI storage controller: LSI Logic / Symbios Logic 53c1010 Ultra3 SCSI Adapter (rev 01)

======================================================================

Appendix #2: dmesg from 2.6.29.5 kernel

======================================================================

Jul  1 19:40:34 frya kernel: [    0.000000] Linux version 2.6.29-gentoo-r5 (root@frya) (gcc version 4.3.3 (Gentoo 4.3.3-r2 p1.1, pie-10.1.5) ) #1 SMP Sun Jun 7 01:45:26 MSD 2009
Jul  1 19:40:34 frya kernel: [    0.000000] KERNEL supported cpus:
Jul  1 19:40:34 frya kernel: [    0.000000]   Intel GenuineIntel
Jul  1 19:40:34 frya kernel: [    0.000000]   AMD AuthenticAMD
Jul  1 19:40:34 frya kernel: [    0.000000]   NSC Geode by NSC
Jul  1 19:40:34 frya kernel: [    0.000000]   Cyrix CyrixInstead
Jul  1 19:40:34 frya kernel: [    0.000000]   Centaur CentaurHauls
Jul  1 19:40:34 frya kernel: [    0.000000]   Transmeta GenuineTMx86
Jul  1 19:40:34 frya kernel: [    0.000000]   Transmeta TransmetaCPU
Jul  1 19:40:34 frya kernel: [    0.000000]   UMC UMC UMC UMC
Jul  1 19:40:34 frya kernel: [    0.000000] PAT WC disabled due to known CPU erratum.
Jul  1 19:40:34 frya kernel: [    0.000000] BIOS-provided physical RAM map:
Jul  1 19:40:34 frya kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
Jul  1 19:40:34 frya kernel: [    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
Jul  1 19:40:34 frya kernel: [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
Jul  1 19:40:34 frya kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 000000001fffb000 (usable)
Jul  1 19:40:34 frya kernel: [    0.000000]  BIOS-e820: 000000001fffb000 - 000000001ffff000 (ACPI data)
Jul  1 19:40:34 frya kernel: [    0.000000]  BIOS-e820: 000000001ffff000 - 0000000020000000 (ACPI NVS)
Jul  1 19:40:34 frya kernel: [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
Jul  1 19:40:34 frya kernel: [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Jul  1 19:40:34 frya kernel: [    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
Jul  1 19:40:34 frya kernel: [    0.000000] DMI 2.3 present.
Jul  1 19:40:34 frya kernel: [    0.000000] last_pfn = 0x1fffb max_arch_pfn = 0x1000000
Jul  1 19:40:34 frya kernel: [    0.000000] Scanning 2 areas for low memory corruption
Jul  1 19:40:34 frya kernel: [    0.000000] modified physical RAM map:
Jul  1 19:40:34 frya kernel: [    0.000000]  modified: 0000000000000000 - 0000000000002000 (usable)
Jul  1 19:40:34 frya kernel: [    0.000000]  modified: 0000000000002000 - 0000000000006000 (reserved)
Jul  1 19:40:34 frya kernel: [    0.000000]  modified: 0000000000006000 - 0000000000007000 (usable)
Jul  1 19:40:34 frya kernel: [    0.000000]  modified: 0000000000007000 - 0000000000010000 (reserved)
Jul  1 19:40:34 frya kernel: [    0.000000]  modified: 0000000000010000 - 0000000000092400 (usable)
Jul  1 19:40:34 frya kernel: [    0.000000]  modified: 000000000009f400 - 00000000000a0000 (reserved)
Jul  1 19:40:34 frya kernel: [    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
Jul  1 19:40:34 frya kernel: [    0.000000]  modified: 0000000000100000 - 000000001fffb000 (usable)
Jul  1 19:40:34 frya kernel: [    0.000000]  modified: 000000001fffb000 - 000000001ffff000 (ACPI data)
Jul  1 19:40:34 frya kernel: [    0.000000]  modified: 000000001ffff000 - 0000000020000000 (ACPI NVS)
Jul  1 19:40:34 frya kernel: [    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
Jul  1 19:40:34 frya kernel: [    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
Jul  1 19:40:34 frya kernel: [    0.000000]  modified: 00000000fff80000 - 0000000100000000 (reserved)
Jul  1 19:40:34 frya kernel: [    0.000000] ASUS CUR-DLS detected: force use of acpi=ht
Jul  1 19:40:34 frya kernel: [    0.000000] ACPI: RSDP 000F6200, 0014 (r0 ASUS  )
Jul  1 19:40:34 frya kernel: [    0.000000] ACPI: RSDT 1FFFB000, 0030 (r1 ASUS   CUR-DLS  30303031 MSFT 31313031)
Jul  1 19:40:34 frya kernel: [    0.000000] ACPI: FACP 1FFFB100, 0074 (r1 ASUS   CUR-DLS  30303031 MSFT 31313031)
Jul  1 19:40:34 frya kernel: [    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
Jul  1 19:40:34 frya kernel: [    0.000000] FADT: X_PM1b_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
Jul  1 19:40:34 frya kernel: [    0.000000] ACPI: DSDT 1FFFB180, 32A0 (r1   ASUS CUR-DLS      1000 MSFT  100000B)
Jul  1 19:40:34 frya kernel: [    0.000000] ACPI: FACS 1FFFF000, 0040
Jul  1 19:40:34 frya kernel: [    0.000000] ACPI: BOOT 1FFFB040, 0028 (r1 ASUS   CUR-DLS  30303031 MSFT 31313031)
Jul  1 19:40:34 frya kernel: [    0.000000] ACPI: APIC 1FFFB080, 0068 (r1 ASUS   CUR-DLS  30303031 MSFT 31313031)
Jul  1 19:40:34 frya kernel: [    0.000000] 511MB LOWMEM available.
Jul  1 19:40:34 frya kernel: [    0.000000]   mapped low ram: 0 - 1fffb000
Jul  1 19:40:34 frya kernel: [    0.000000]   low ram: 00000000 - 1fffb000
Jul  1 19:40:34 frya kernel: [    0.000000]   bootmap 00012000 - 00016000
Jul  1 19:40:34 frya kernel: [    0.000000] (8 early reservations) ==> bootmem [0000000000 - 001fffb000]
Jul  1 19:40:34 frya kernel: [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
Jul  1 19:40:34 frya kernel: [    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
Jul  1 19:40:34 frya kernel: [    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
Jul  1 19:40:34 frya kernel: [    0.000000]   #3 [0000100000 - 0000838334]    TEXT DATA BSS ==> [0000100000 - 0000838334]
Jul  1 19:40:34 frya kernel: [    0.000000]   #4 [0000839000 - 0000842000]    INIT_PG_TABLE ==> [0000839000 - 0000842000]
Jul  1 19:40:34 frya kernel: [    0.000000]   #5 [000009f400 - 0000100000]    BIOS reserved ==> [000009f400 - 0000100000]
Jul  1 19:40:34 frya kernel: [    0.000000]   #6 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
Jul  1 19:40:34 frya kernel: [    0.000000]   #7 [0000012000 - 0000016000]          BOOTMAP ==> [0000012000 - 0000016000]
Jul  1 19:40:34 frya kernel: [    0.000000] found SMP MP-table at [c00f5270] 000f5270
Jul  1 19:40:34 frya kernel: [    0.000000] Zone PFN ranges:
Jul  1 19:40:34 frya kernel: [    0.000000]   DMA      0x00000000 -> 0x00001000
Jul  1 19:40:34 frya kernel: [    0.000000]   Normal   0x00001000 -> 0x0001fffb
Jul  1 19:40:34 frya kernel: [    0.000000] Movable zone start PFN for each node
Jul  1 19:40:34 frya kernel: [    0.000000] early_node_map[4] active PFN ranges
Jul  1 19:40:34 frya kernel: [    0.000000]     0: 0x00000000 -> 0x00000002
Jul  1 19:40:34 frya kernel: [    0.000000]     0: 0x00000006 -> 0x00000007
Jul  1 19:40:34 frya kernel: [    0.000000]     0: 0x00000010 -> 0x00000092
Jul  1 19:40:34 frya kernel: [    0.000000]     0: 0x00000100 -> 0x0001fffb
Jul  1 19:40:34 frya kernel: [    0.000000] ACPI: PM-Timer IO Port: 0xe408
Jul  1 19:40:34 frya kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x03] enabled)
Jul  1 19:40:34 frya kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Jul  1 19:40:34 frya kernel: [    0.000000] Using ACPI for processor (LAPIC) configuration information
Jul  1 19:40:34 frya kernel: [    0.000000] Intel MultiProcessor Specification v1.4
Jul  1 19:40:34 frya kernel: [    0.000000]     Virtual Wire compatibility mode.
Jul  1 19:40:34 frya kernel: [    0.000000] MPTABLE: OEM ID: OEM00000
Jul  1 19:40:34 frya kernel: [    0.000000] MPTABLE: Product ID: PROD00000000
Jul  1 19:40:34 frya kernel: [    0.000000] MPTABLE: APIC at: 0xFEE00000
Jul  1 19:40:34 frya kernel: [    0.000000] I/O APIC #2 Version 17 at 0xFEC00000.
Jul  1 19:40:34 frya kernel: [    0.000000] I/O APIC #3 Version 17 at 0xFEC01000.
Jul  1 19:40:34 frya kernel: [    0.000000] Enabling APIC mode:  Flat.  Using 2 I/O APICs
Jul  1 19:40:34 frya kernel: [    0.000000] Processors: 2
Jul  1 19:40:34 frya kernel: [    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
Jul  1 19:40:34 frya kernel: [    0.000000] Allocating PCI resources starting at 30000000 (gap: 20000000:dec00000)
Jul  1 19:40:34 frya kernel: [    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
Jul  1 19:40:34 frya kernel: [    0.000000] PERCPU: Allocating 24576 bytes of per cpu data
Jul  1 19:40:34 frya kernel: [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129920
Jul  1 19:40:34 frya kernel: [    0.000000] Kernel command line: auto BOOT_IMAGE=2.6.29r5-0 ro root=803
Jul  1 19:40:34 frya kernel: [    0.000000] Enabling fast FPU save and restore... done.
Jul  1 19:40:34 frya kernel: [    0.000000] Enabling unmasked SIMD FPU exception support... done.
Jul  1 19:40:34 frya kernel: [    0.000000] Initializing CPU#0
Jul  1 19:40:34 frya kernel: [    0.000000] Experimental hierarchical RCU implementation.
Jul  1 19:40:34 frya kernel: [    0.000000] RCU-based detection of stalled CPUs is enabled.
Jul  1 19:40:34 frya kernel: [    0.000000] Experimental hierarchical RCU init done.
Jul  1 19:40:34 frya kernel: [    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
Jul  1 19:40:34 frya kernel: [    0.000000] Fast TSC calibration using PIT
Jul  1 19:40:34 frya kernel: [    0.000000] Detected 999.863 MHz processor.
Jul  1 19:40:34 frya kernel: [    0.004000] Console: colour VGA+ 80x25
Jul  1 19:40:34 frya kernel: [    0.004000] console [tty0] enabled
Jul  1 19:40:34 frya kernel: [    0.004000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Jul  1 19:40:34 frya kernel: [    0.004000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Jul  1 19:40:34 frya kernel: [    0.004000] Memory: 511480k/524268k available (4659k kernel code, 12064k reserved, 1828k data, 420k init, 0k highmem)
Jul  1 19:40:34 frya kernel: [    0.004000] virtual kernel memory layout:
Jul  1 19:40:34 frya kernel: [    0.004000]     fixmap  : 0xfff9f000 - 0xfffff000   ( 384 kB)
Jul  1 19:40:34 frya kernel: [    0.004000]     vmalloc : 0xe07fb000 - 0xfff9d000   ( 503 MB)
Jul  1 19:40:34 frya kernel: [    0.004000]     lowmem  : 0xc0000000 - 0xdfffb000   ( 511 MB)
Jul  1 19:40:34 frya kernel: [    0.004000]       .init : 0xc075d000 - 0xc07c6000   ( 420 kB)
Jul  1 19:40:34 frya kernel: [    0.004000]       .data : 0xc058ce68 - 0xc0755fe8   (1828 kB)
Jul  1 19:40:34 frya kernel: [    0.004000]       .text : 0xc0100000 - 0xc058ce68   (4659 kB)
Jul  1 19:40:34 frya kernel: [    0.004000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
Jul  1 19:40:34 frya kernel: [    0.004000] SLUB: Genslabs=12, HWalign=32, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Jul  1 19:40:34 frya kernel: [    0.004016] Calibrating delay loop (skipped), value calculated using timer frequency.. 1999.72 BogoMIPS (lpj=3999452)
Jul  1 19:40:34 frya kernel: [    0.004289] Security Framework initialized
Jul  1 19:40:34 frya kernel: [    0.004444] Mount-cache hash table entries: 512
Jul  1 19:40:34 frya kernel: [    0.004852] CPU: L1 I cache: 16K, L1 D cache: 16K
Jul  1 19:40:34 frya kernel: [    0.004994] CPU: L2 cache: 256K
Jul  1 19:40:34 frya kernel: [    0.005104] Intel machine check architecture supported.
Jul  1 19:40:34 frya kernel: [    0.005224] Intel machine check reporting enabled on CPU#0.
Jul  1 19:40:34 frya kernel: [    0.005362] Checking 'hlt' instruction... OK.
Jul  1 19:40:34 frya kernel: [    0.020876] Freeing SMP alternatives: 18k freed
Jul  1 19:40:34 frya kernel: [    0.021241] ExtINT not setup in hardware but reported by MP table
Jul  1 19:40:34 frya kernel: [    0.022144] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
Jul  1 19:40:34 frya kernel: [    0.024001] ...trying to set up timer (IRQ0) through the 8259A ...
Jul  1 19:40:34 frya kernel: [    0.024001] ..... (found apic 0 pin 0) ...
Jul  1 19:40:34 frya kernel: [    0.065981] ....... works.
Jul  1 19:40:34 frya kernel: [    0.066086] CPU0: Intel Pentium III (Coppermine) stepping 06
Jul  1 19:40:34 frya kernel: [    0.068001] Booting processor 1 APIC 0x0 ip 0x6000
Jul  1 19:40:34 frya kernel: [    0.004000] Initializing CPU#1
Jul  1 19:40:34 frya kernel: [    0.004000] Calibrating delay using timer specific routine.. 2000.21 BogoMIPS (lpj=4000422)
Jul  1 19:40:34 frya kernel: [    0.004000] CPU: L1 I cache: 16K, L1 D cache: 16K
Jul  1 19:40:34 frya kernel: [    0.004000] CPU: L2 cache: 256K
Jul  1 19:40:34 frya kernel: [    0.004000] Intel machine check architecture supported.
Jul  1 19:40:34 frya kernel: [    0.004000] Intel machine check reporting enabled on CPU#1.
Jul  1 19:40:34 frya kernel: [    0.152278] CPU1: Intel Pentium III (Coppermine) stepping 06
Jul  1 19:40:34 frya kernel: [    0.153219] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Jul  1 19:40:34 frya kernel: [    0.156081] Brought up 2 CPUs
Jul  1 19:40:34 frya kernel: [    0.156196] Total of 2 processors activated (3999.93 BogoMIPS).
Jul  1 19:40:34 frya kernel: [    0.156611] net_namespace: 512 bytes
Jul  1 19:40:34 frya kernel: [    0.156844] NET: Registered protocol family 16
Jul  1 19:40:34 frya kernel: [    0.161113] PCI: PCI BIOS revision 2.10 entry at 0xf0a80, last bus=1
Jul  1 19:40:34 frya kernel: [    0.161238] PCI: Using configuration type 1 for base access
Jul  1 19:40:34 frya kernel: [    0.176349] bio: create slab <bio-0> at 0
Jul  1 19:40:34 frya kernel: [    0.176447] ACPI: Interpreter disabled.
Jul  1 19:40:34 frya kernel: [    0.176447] SCSI subsystem initialized
Jul  1 19:40:34 frya kernel: [    0.180227] usbcore: registered new interface driver usbfs
Jul  1 19:40:34 frya kernel: [    0.180227] usbcore: registered new interface driver hub
Jul  1 19:40:34 frya kernel: [    0.180259] usbcore: registered new device driver usb
Jul  1 19:40:34 frya kernel: [    0.180259] PCI: Probing PCI hardware
Jul  1 19:40:34 frya kernel: [    0.180259] * The chipset may have PM-Timer Bug. Due to workarounds for a bug,
Jul  1 19:40:34 frya kernel: [    0.180259] * this clock source is slow. If you are sure your timer does not have
Jul  1 19:40:34 frya kernel: [    0.180259] * this bug, please use "acpi_pm_good" to disable the workaround
Jul  1 19:40:34 frya kernel: [    0.184101] * The chipset may have PM-Timer Bug. Due to workarounds for a bug,
Jul  1 19:40:34 frya kernel: [    0.184105] * this clock source is slow. If you are sure your timer does not have
Jul  1 19:40:34 frya kernel: [    0.184108] * this bug, please use "acpi_pm_good" to disable the workaround
Jul  1 19:40:34 frya kernel: [    0.184712] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot
Jul  1 19:40:34 frya kernel: [    0.184835] pci 0000:00:02.0: PME# disabled
Jul  1 19:40:34 frya kernel: [    0.185026] pci 0000:00:04.0: PME# supported from D1 D2 D3hot
Jul  1 19:40:34 frya kernel: [    0.185149] pci 0000:00:04.0: PME# disabled
Jul  1 19:40:34 frya kernel: [    0.185811] PCI: Discovered peer bus 01
Jul  1 19:40:34 frya kernel: [    0.185811] pci 0000:01:02.0: PME# supported from D3hot D3cold
Jul  1 19:40:34 frya kernel: [    0.185811] pci 0000:01:02.0: PME# disabled
Jul  1 19:40:34 frya kernel: [    0.188110] pci 0000:00:0f.0: ServerWorks IRQ router [1166:0200]
Jul  1 19:40:34 frya kernel: [    0.188260] pci 0000:00:02.0: PCI->APIC IRQ transform: INT A -> IRQ 20
Jul  1 19:40:34 frya kernel: [    0.188387] pci 0000:00:04.0: PCI->APIC IRQ transform: INT A -> IRQ 17
Jul  1 19:40:34 frya kernel: [    0.188520] pci 0000:01:02.0: PCI->APIC IRQ transform: INT A -> IRQ 21
Jul  1 19:40:34 frya kernel: [    0.188646] pci 0000:01:03.0: PCI->APIC IRQ transform: INT A -> IRQ 22
Jul  1 19:40:34 frya kernel: [    0.188772] pci 0000:01:05.0: PCI->APIC IRQ transform: INT A -> IRQ 24
Jul  1 19:40:34 frya kernel: [    0.188899] pci 0000:01:05.1: PCI->APIC IRQ transform: INT B -> IRQ 25
Jul  1 19:40:34 frya kernel: [    0.200170] pnp: PnP ACPI: disabled
Jul  1 19:40:34 frya kernel: [    0.236329] NET: Registered protocol family 2
Jul  1 19:40:34 frya kernel: [    0.276178] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
Jul  1 19:40:34 frya kernel: [    0.276933] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
Jul  1 19:40:34 frya kernel: [    0.277396] TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
Jul  1 19:40:34 frya kernel: [    0.277941] TCP: Hash tables configured (established 16384 bind 16384)
Jul  1 19:40:34 frya kernel: [    0.278074] TCP reno registered
Jul  1 19:40:34 frya kernel: [    0.288320] NET: Registered protocol family 1
Jul  1 19:40:34 frya kernel: [    0.288917] Simple Boot Flag at 0x3a set to 0x80
Jul  1 19:40:34 frya kernel: [    0.289411] platform rtc_cmos: registered platform RTC device (no PNP device found)
Jul  1 19:40:34 frya kernel: [    0.291001] scx200: NatSemi SCx200 Driver
Jul  1 19:40:34 frya kernel: [    0.291579] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Jul  1 19:40:34 frya kernel: [    0.291789] Scanning for low memory corruption every 60 seconds
Jul  1 19:40:34 frya kernel: [    0.293497] HugeTLB registered 2 MB page size, pre-allocated 0 pages
Jul  1 19:40:34 frya kernel: [    0.301346] VFS: Disk quotas dquot_6.5.2
Jul  1 19:40:34 frya kernel: [    0.301826] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Jul  1 19:40:34 frya kernel: [    0.304414] squashfs: version 4.0 (2009/01/31) Phillip Lougher
Jul  1 19:40:34 frya kernel: [    0.306379] NTFS driver 2.1.29 [Flags: R/W].
Jul  1 19:40:34 frya kernel: [    0.307214] fuse init (API version 7.11)
Jul  1 19:40:34 frya kernel: [    0.308004] msgmni has been set to 999
Jul  1 19:40:34 frya kernel: [    0.308376] alg: No test for cipher_null (cipher_null-generic)
Jul  1 19:40:34 frya kernel: [    0.308682] alg: No test for digest_null (digest_null-generic)
Jul  1 19:40:34 frya kernel: [    0.308884] alg: No test for compress_null (compress_null-generic)
Jul  1 19:40:34 frya kernel: [    0.311862] alg: No test for fcrypt (fcrypt-generic)
Jul  1 19:40:34 frya kernel: [    0.317396] alg: No test for stdrng (krng)
Jul  1 19:40:34 frya kernel: [    0.317613] alg: No test for stdrng (ansi_cprng)
Jul  1 19:40:34 frya kernel: [    0.317781] io scheduler noop registered
Jul  1 19:40:34 frya kernel: [    0.317891] io scheduler anticipatory registered (default)
Jul  1 19:40:34 frya kernel: [    0.318010] io scheduler deadline registered
Jul  1 19:40:34 frya kernel: [    0.318239] io scheduler cfq registered
Jul  1 19:40:34 frya kernel: [    0.321024] pci 0000:00:02.0: Firmware left e100 interrupts enabled; disabling
Jul  1 19:40:34 frya kernel: [    0.450588] Non-volatile memory driver v1.3
Jul  1 19:40:34 frya kernel: [    0.450815] Linux agpgart interface v0.103
Jul  1 19:40:34 frya kernel: [    0.451097] agpgart-serverworks 0000:00:00.0: agp_backend_initialize() failed
Jul  1 19:40:34 frya kernel: [    0.451230] agpgart-serverworks: probe of 0000:00:00.0 failed with error -22
Jul  1 19:40:34 frya kernel: [    0.451498] agpgart-serverworks 0000:00:00.1: agp_backend_initialize() failed
Jul  1 19:40:34 frya kernel: [    0.451628] agpgart-serverworks: probe of 0000:00:00.1 failed with error -22
Jul  1 19:40:34 frya kernel: [    0.451965] ipmi message handler version 39.2
Jul  1 19:40:34 frya kernel: [    0.452097] ipmi device interface
Jul  1 19:40:34 frya kernel: [    0.452422] IPMI System Interface driver.
Jul  1 19:40:34 frya kernel: [    0.481714] ipmi_si: Unable to find any System Interface(s)
Jul  1 19:40:34 frya kernel: [    0.481842] IPMI Watchdog: driver initialized
Jul  1 19:40:34 frya kernel: [    0.481956] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
Jul  1 19:40:34 frya kernel: [    0.482178] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Jul  1 19:40:34 frya kernel: [    0.482375] Hangcheck: Using get_cycles().
Jul  1 19:40:34 frya kernel: [    0.483722] uvesafb: probe of uvesafb.0 failed with error -22
Jul  1 19:40:34 frya kernel: [    0.483915] Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
Jul  1 19:40:34 frya kernel: [    0.484301] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Jul  1 19:40:34 frya kernel: [    0.485045] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Jul  1 19:40:34 frya kernel: [    0.490114] brd: module loaded
Jul  1 19:40:34 frya kernel: [    0.492565] loop: module loaded
Jul  1 19:40:34 frya kernel: [    0.492784] 3c59x: Donald Becker and others.
Jul  1 19:40:34 frya kernel: [    0.492909] 0000:00:04.0: 3Com PCI 3c905B Cyclone 100baseTx at e0816000.
Jul  1 19:40:34 frya kernel: [    0.514196] eth0 (3c59x): not using net_device_ops yet
Jul  1 19:40:34 frya kernel: [    0.515139] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k6-NAPI
Jul  1 19:40:34 frya kernel: [    0.515264] e100: Copyright(c) 1999-2006 Intel Corporation
Jul  1 19:40:34 frya kernel: [    0.538257] e100 0000:00:02.0: PME# disabled
Jul  1 19:40:34 frya kernel: [    0.539039] e100: eth1: e100_probe: addr 0xfe000000, irq 20, MAC addr 00:e0:18:29:b7:b5
Jul  1 19:40:34 frya kernel: [    0.539379] tg3.c:v3.97 (December 10, 2008)
Jul  1 19:40:34 frya kernel: [    0.545556] tg3 0000:01:02.0: PME# disabled
Jul  1 19:40:34 frya kernel: [    1.897196] eth2: Tigon3 [partno(3C996B-T) rev 0105] (PCI:33MHz:64-bit) MAC address 00:0a:5e:1d:43:be
Jul  1 19:40:34 frya kernel: [    1.897406] eth2: attached PHY is 5701 (10/100/1000Base-T Ethernet) (WireSpeed[1])
Jul  1 19:40:34 frya kernel: [    1.897598] eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[0]
Jul  1 19:40:34 frya kernel: [    1.897721] eth2: dma_rwctrl[76ff000f] dma_mask[64-bit]
Jul  1 19:40:34 frya kernel: [    1.899322] Fixed MDIO Bus: probed
Jul  1 19:40:34 frya kernel: [    1.899449] PPP generic driver version 2.4.2
Jul  1 19:40:34 frya kernel: [    1.900073] PPP Deflate Compression module registered
Jul  1 19:40:34 frya kernel: [    1.900195] PPP BSD Compression module registered
Jul  1 19:40:34 frya kernel: [    1.902648] tun: Universal TUN/TAP device driver, 1.6
Jul  1 19:40:34 frya kernel: [    1.902771] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Jul  1 19:40:34 frya kernel: [    1.904205] 3ware Storage Controller device driver for Linux v1.26.02.002.
Jul  1 19:40:34 frya kernel: [    3.360025] scsi0 : 3ware Storage Controller
Jul  1 19:40:34 frya kernel: [    3.360724] 3w-xxxx: scsi0: Found a 3ware Storage Controller at 0xb400, IRQ: 22.
Jul  1 19:40:34 frya kernel: [    3.361472] scsi 0:0:0:0: Direct-Access     3ware    Logical Disk 0   1.2  PQ: 0 ANSI: 0
Jul  1 19:40:34 frya kernel: [    3.361774] Driver 'sd' needs updating - please use bus_type methods
Jul  1 19:40:34 frya kernel: [    3.362876] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Jul  1 19:40:34 frya kernel: [    3.363308] 116x: driver isp116x-hcd, 03 Nov 2005
Jul  1 19:40:34 frya kernel: [    3.363538] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
Jul  1 19:40:34 frya kernel: [    3.363807] uhci_hcd: USB Universal Host Controller Interface driver
Jul  1 19:40:34 frya kernel: [    3.364244] sl811: driver sl811-hcd, 19 May 2005
Jul  1 19:40:34 frya kernel: [    3.364501] r8a66597_hcd: driver r8a66597_hcd, 10 Apr 2008
Jul  1 19:40:34 frya kernel: [    3.365041] usbcore: registered new interface driver usblp
Jul  1 19:40:34 frya kernel: [    3.365405] usbcore: registered new interface driver cdc_wdm
Jul  1 19:40:34 frya kernel: [    3.365538] Initializing USB Mass Storage driver...
Jul  1 19:40:34 frya kernel: [    3.365761] usbcore: registered new interface driver usb-storage
Jul  1 19:40:34 frya kernel: [    3.365887] USB Mass Storage support registered.
Jul  1 19:40:34 frya kernel: [    3.366172] usbcore: registered new interface driver libusual
Jul  1 19:40:34 frya kernel: [    3.366492] sd 0:0:0:0: [sda] 703318656 512-byte hardware sectors: (360 GB/335 GiB)
Jul  1 19:40:34 frya kernel: [    3.366715] PNP: No PS/2 controller found. Probing ports directly.
Jul  1 19:40:34 frya kernel: [    3.366750] sd 0:0:0:0: [sda] Write Protect is off
Jul  1 19:40:34 frya kernel: [    3.367099] sd 0:0:0:0: [sda] Write cache: enabled, read cache: disabled, supports DPO and FUA
Jul  1 19:40:34 frya kernel: [    3.369201] sd 0:0:0:0: [sda] 703318656 512-byte hardware sectors: (360 GB/335 GiB)
Jul  1 19:40:34 frya kernel: [    3.369466] sd 0:0:0:0: [sda] Write Protect is off
Jul  1 19:40:34 frya kernel: [    3.369926] sd 0:0:0:0: [sda] Write cache: enabled, read cache: disabled, supports DPO and FUA
Jul  1 19:40:34 frya kernel: [    3.370129]  sda: sda1 sda2 sda3 sda4 < sda5 >
Jul  1 19:40:34 frya kernel: [    3.386765] sd 0:0:0:0: [sda] Attached SCSI disk
Jul  1 19:40:34 frya kernel: [    3.387409] sd 0:0:0:0: Attached scsi generic sg0 type 0
Jul  1 19:40:34 frya kernel: [    3.620388] serio: i8042 KBD port at 0x60,0x64 irq 1
Jul  1 19:40:34 frya kernel: [    3.621192] mice: PS/2 mouse device common for all mice
Jul  1 19:40:34 frya kernel: [    3.621836] I2O subsystem v1.325
Jul  1 19:40:34 frya kernel: [    3.621952] i2o: max drivers = 8
Jul  1 19:40:34 frya kernel: [    3.622531] I2O Configuration OSM v1.323
Jul  1 19:40:34 frya kernel: [    3.622743] I2O Bus Adapter OSM v1.317
Jul  1 19:40:34 frya kernel: [    3.622954] I2O Block Device OSM v1.325
Jul  1 19:40:34 frya kernel: [    3.623564] I2O SCSI Peripheral OSM v1.316
Jul  1 19:40:34 frya kernel: [    3.623790] I2O ProcFS OSM v1.316
Jul  1 19:40:34 frya kernel: [    3.624537] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
Jul  1 19:40:34 frya kernel: [    3.624715] rtc0: alarms up to one day, 114 bytes nvram
Jul  1 19:40:34 frya kernel: [    3.627326] i2c /dev entries driver
Jul  1 19:40:34 frya kernel: [    3.627834] piix4_smbus 0000:00:0f.0: SMBus Host Controller at 0xe800, revision 0
Jul  1 19:40:34 frya kernel: [    3.808071] cpuidle: using governor ladder
Jul  1 19:40:34 frya kernel: [    3.808191] cpuidle: using governor menu
Jul  1 19:40:34 frya kernel: [    3.810853] usbcore: registered new interface driver usbhid
Jul  1 19:40:34 frya kernel: [    3.810986] usbhid: v2.6:USB HID core driver
Jul  1 19:40:34 frya kernel: [    3.811100] GACT probability on
Jul  1 19:40:34 frya kernel: [    3.811208] Mirror/redirect action on
Jul  1 19:40:34 frya kernel: [    3.812235] u32 classifier
Jul  1 19:40:34 frya kernel: [    3.812345]     Performance counters on
Jul  1 19:40:34 frya kernel: [    3.812454]     input device check on
Jul  1 19:40:34 frya kernel: [    3.812561]     Actions configured
Jul  1 19:40:34 frya kernel: [    3.812676] Netfilter messages via NETLINK v0.30.
Jul  1 19:40:34 frya kernel: [    3.812856] nf_conntrack version 0.5.0 (8191 buckets, 32764 max)
Jul  1 19:40:34 frya kernel: [    3.813467] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
Jul  1 19:40:34 frya kernel: [    3.813668] nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
Jul  1 19:40:34 frya kernel: [    3.813861] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
Jul  1 19:40:34 frya kernel: [    3.814214] ctnetlink v0.93: registering with nfnetlink.
Jul  1 19:40:34 frya kernel: [    3.814433] xt_time: kernel timezone is -0000
Jul  1 19:40:34 frya kernel: [    3.815742] IPv4 over IPv4 tunneling driver
Jul  1 19:40:34 frya kernel: [    3.816908] GRE over IPv4 tunneling driver
Jul  1 19:40:34 frya kernel: [    3.818537] ip_tables: (C) 2000-2006 Netfilter Core Team
Jul  1 19:40:34 frya kernel: [    3.818748] TCP cubic registered
Jul  1 19:40:34 frya kernel: [    3.818859] NET: Registered protocol family 17
Jul  1 19:40:34 frya kernel: [    3.819013] Using IPI Shortcut mode
Jul  1 19:40:34 frya kernel: [    3.820261] drivers/rtc/hctosys.c: unable to open rtc device (y)
Jul  1 19:40:34 frya kernel: [    3.821636] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
Jul  1 19:40:34 frya kernel: [    3.821756] EDD information not available.
Jul  1 19:40:34 frya kernel: [    3.841260] ReiserFS: sda3: found reiserfs format "3.6" with standard journal
Jul  1 19:40:34 frya kernel: [    3.841407] ReiserFS: sda3: using ordered data mode
Jul  1 19:40:34 frya kernel: [    3.845738] ReiserFS: sda3: journal params: device sda3, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Jul  1 19:40:34 frya kernel: [    3.850064] ReiserFS: sda3: checking transaction log (sda3)
Jul  1 19:40:34 frya kernel: [    4.101549] ReiserFS: sda3: Using r5 hash to sort names
Jul  1 19:40:34 frya kernel: [    4.101742] VFS: Mounted root (reiserfs filesystem) readonly on device 8:3.
Jul  1 19:40:34 frya kernel: [    4.102732] Freeing unused kernel memory: 420k freed
Jul  1 19:40:34 frya kernel: [    8.585398] udev: starting version 141
Jul  1 19:40:34 frya kernel: [   11.871013] ReiserFS: sda5: found reiserfs format "3.6" with standard journal
Jul  1 19:40:34 frya kernel: [   11.871048] ReiserFS: sda5: using ordered data mode
Jul  1 19:40:34 frya kernel: [   11.871773] ReiserFS: sda5: journal params: device sda5, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Jul  1 19:40:34 frya kernel: [   11.875749] ReiserFS: sda5: checking transaction log (sda5)
Jul  1 19:40:34 frya kernel: [   11.968095] ReiserFS: sda5: Using r5 hash to sort names
Jul  1 19:40:34 frya kernel: [   12.226030] Adding 136512k swap on /dev/sda1.  Priority:-1 extents:1 across:136512k
Jul  1 19:40:35 frya kernel: [   16.313699] eth0:  setting full-duplex.
Jul  1 19:40:35 frya kernel: [   16.314479] tg3 0000:01:02.0: PME# disabled
Jul  1 19:40:38 frya kernel: [   18.414870] tg3: eth2: Link is up at 100 Mbps, full duplex.
Jul  1 19:40:38 frya kernel: [   18.414880] tg3: eth2: Flow control is on for TX and on for RX.

======================================================================

Appendix #3: tw_cli status

======================================================================

Unit  UnitType  Status         %RCmpl  %V/I/M  Stripe  Size(GB)  Cache  AVrfy
------------------------------------------------------------------------------
u0    RAID-5    OK             -       -       64K     335.368   W      -

Port   Status           Unit   Size        Blocks        Serial
---------------------------------------------------------------
p0     OK               u0     111.79 GB   234441648     3JT3MC21
p1     OK               u0     111.79 GB   234441648     3JT1R02J
p2     OK               u0     111.79 GB   234441648     3JT02ZWS
p3     OK               u0     111.79 GB   234441648     5LS1A47C

======================================================================

Appendix #4: dmesg of 2.6.30.4 kernel

======================================================================

Aug  1 19:42:57 frya kernel: [    0.000000] Linux version 2.6.30-gentoo-r4 (root@frya) (gcc version 4.3.3 (Gentoo 4.3.3-r2 p1.2, pie-10.1.5) ) #1 SMP Sat Aug
 1 16:55:18 MSD 2009
Aug  1 19:42:57 frya kernel: [    0.000000] KERNEL supported cpus:
Aug  1 19:42:57 frya kernel: [    0.000000]   Intel GenuineIntel
Aug  1 19:42:57 frya kernel: [    0.000000]   AMD AuthenticAMD
Aug  1 19:42:57 frya kernel: [    0.000000]   NSC Geode by NSC
Aug  1 19:42:57 frya kernel: [    0.000000]   Cyrix CyrixInstead
Aug  1 19:42:57 frya kernel: [    0.000000]   Centaur CentaurHauls
Aug  1 19:42:57 frya kernel: [    0.000000]   Transmeta GenuineTMx86
Aug  1 19:42:57 frya kernel: [    0.000000]   Transmeta TransmetaCPU
Aug  1 19:42:57 frya kernel: [    0.000000]   UMC UMC UMC UMC
Aug  1 19:42:57 frya kernel: [    0.000000] BIOS-provided physical RAM map:
Aug  1 19:42:57 frya kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
Aug  1 19:42:57 frya kernel: [    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
Aug  1 19:42:57 frya kernel: [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
Aug  1 19:42:57 frya kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 000000001fffb000 (usable)
Aug  1 19:42:57 frya kernel: [    0.000000]  BIOS-e820: 000000001fffb000 - 000000001ffff000 (ACPI data)
Aug  1 19:42:57 frya kernel: [    0.000000]  BIOS-e820: 000000001ffff000 - 0000000020000000 (ACPI NVS)
Aug  1 19:42:57 frya kernel: [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
Aug  1 19:42:57 frya kernel: [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Aug  1 19:42:57 frya kernel: [    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
Aug  1 19:42:57 frya kernel: [    0.000000] DMI 2.3 present.
Aug  1 19:42:57 frya kernel: [    0.000000] last_pfn = 0x1fffb max_arch_pfn = 0x100000
Aug  1 19:42:57 frya kernel: [    0.000000] Scanning 1 areas for low memory corruption
Aug  1 19:42:57 frya kernel: [    0.000000] modified physical RAM map:
Aug  1 19:42:57 frya kernel: [    0.000000]  modified: 0000000000000000 - 0000000000002000 (usable)
Aug  1 19:42:57 frya kernel: [    0.000000]  modified: 0000000000002000 - 0000000000006000 (reserved)
Aug  1 19:42:57 frya kernel: [    0.000000]  modified: 0000000000006000 - 000000000009f400 (usable)
Aug  1 19:42:57 frya kernel: [    0.000000]  modified: 000000000009f400 - 00000000000a0000 (reserved)
Aug  1 19:42:57 frya kernel: [    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
Aug  1 19:42:57 frya kernel: [    0.000000]  modified: 0000000000100000 - 000000001fffb000 (usable)
Aug  1 19:42:57 frya kernel: [    0.000000]  modified: 000000001fffb000 - 000000001ffff000 (ACPI data)
Aug  1 19:42:57 frya kernel: [    0.000000]  modified: 000000001ffff000 - 0000000020000000 (ACPI NVS)
Aug  1 19:42:57 frya kernel: [    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
Aug  1 19:42:57 frya kernel: [    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
Aug  1 19:42:57 frya kernel: [    0.000000]  modified: 00000000fff80000 - 0000000100000000 (reserved)
Aug  1 19:42:57 frya kernel: [    0.000000] init_memory_mapping: 0000000000000000-000000001fffb000
Aug  1 19:42:57 frya kernel: [    0.000000] ASUS CUR-DLS detected: force use of acpi=ht
Aug  1 19:42:57 frya kernel: [    0.000000] ACPI: RSDP 000f6200 00014 (v00 ASUS  )
Aug  1 19:42:57 frya kernel: [    0.000000] ACPI: RSDT 1fffb000 00030 (v01 ASUS   CUR-DLS  30303031 MSFT 31313031)
Aug  1 19:42:57 frya kernel: [    0.000000] ACPI: FACP 1fffb100 00074 (v01 ASUS   CUR-DLS  30303031 MSFT 31313031)
Aug  1 19:42:57 frya kernel: [    0.000000] ACPI: DSDT 1fffb180 032A0 (v01   ASUS CUR-DLS  00001000 MSFT 0100000B)
Aug  1 19:42:57 frya kernel: [    0.000000] ACPI: FACS 1ffff000 00040
Aug  1 19:42:57 frya kernel: [    0.000000] ACPI: BOOT 1fffb040 00028 (v01 ASUS   CUR-DLS  30303031 MSFT 31313031)
Aug  1 19:42:57 frya kernel: [    0.000000] ACPI: APIC 1fffb080 00068 (v01 ASUS   CUR-DLS  30303031 MSFT 31313031)
Aug  1 19:42:57 frya kernel: [    0.000000] 511MB LOWMEM available.
Aug  1 19:42:57 frya kernel: [    0.000000]   mapped low ram: 0 - 1fffb000
Aug  1 19:42:57 frya kernel: [    0.000000]   low ram: 0 - 1fffb000
Aug  1 19:42:57 frya kernel: [    0.000000]   node 0 low ram: 00000000 - 1fffb000
Aug  1 19:42:57 frya kernel: [    0.000000]   node 0 bootmap 00008000 - 0000c000
Aug  1 19:42:57 frya kernel: [    0.000000] (8 early reservations) ==> bootmem [0000000000 - 001fffb000]
Aug  1 19:42:57 frya kernel: [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
Aug  1 19:42:57 frya kernel: [    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
Aug  1 19:42:57 frya kernel: [    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
Aug  1 19:42:57 frya kernel: [    0.000000]   #3 [0000100000 - 00008c1fc4]    TEXT DATA BSS ==> [0000100000 - 00008c1fc4]
Aug  1 19:42:57 frya kernel: [    0.000000]   #4 [000009f400 - 0000100000]    BIOS reserved ==> [000009f400 - 0000100000]
Aug  1 19:42:57 frya kernel: [    0.000000]   #5 [00008c2000 - 00008c5150]              BRK ==> [00008c2000 - 00008c5150]
Aug  1 19:42:57 frya kernel: [    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
Aug  1 19:42:57 frya kernel: [    0.000000]   #7 [0000008000 - 000000c000]          BOOTMAP ==> [0000008000 - 000000c000]
Aug  1 19:42:57 frya kernel: [    0.000000] found SMP MP-table at [c00f5270] f5270
Aug  1 19:42:57 frya kernel: [    0.000000]   DMA      0x00000000 -> 0x00001000
Aug  1 19:42:57 frya kernel: [    0.000000]   Normal   0x00001000 -> 0x0001fffb
Aug  1 19:42:57 frya kernel: [    0.000000] Movable zone start PFN for each node
Aug  1 19:42:57 frya kernel: [    0.000000] early_node_map[3] active PFN ranges
Aug  1 19:42:57 frya kernel: [    0.000000]     0: 0x00000000 -> 0x00000002
Aug  1 19:42:57 frya kernel: [    0.000000]     0: 0x00000006 -> 0x0000009f
Aug  1 19:42:57 frya kernel: [    0.000000]     0: 0x00000100 -> 0x0001fffb
Aug  1 19:42:57 frya kernel: [    0.000000] Using APIC driver default
Aug  1 19:42:57 frya kernel: [    0.000000] ACPI: PM-Timer IO Port: 0xe408
Aug  1 19:42:57 frya kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x03] enabled)
Aug  1 19:42:57 frya kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Aug  1 19:42:57 frya kernel: [    0.000000] Using ACPI for processor (LAPIC) configuration information
Aug  1 19:42:57 frya kernel: [    0.000000] Intel MultiProcessor Specification v1.4
Aug  1 19:42:57 frya kernel: [    0.000000]     Virtual Wire compatibility mode.
Aug  1 19:42:57 frya kernel: [    0.000000] MPTABLE: OEM ID: OEM00000
Aug  1 19:42:57 frya kernel: [    0.000000] MPTABLE: Product ID: PROD00000000
Aug  1 19:42:57 frya kernel: [    0.000000] MPTABLE: APIC at: 0xFEE00000
Aug  1 19:42:57 frya kernel: [    0.000000] I/O APIC #2 Version 17 at 0xFEC00000.
Aug  1 19:42:57 frya kernel: [    0.000000] I/O APIC #3 Version 17 at 0xFEC01000.
Aug  1 19:42:57 frya kernel: [    0.000000] Enabling APIC mode:  Flat.  Using 2 I/O APICs
Aug  1 19:42:57 frya kernel: [    0.000000] Processors: 2
Aug  1 19:42:57 frya kernel: [    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
Aug  1 19:42:57 frya kernel: [    0.000000] Allocating PCI resources starting at 30000000 (gap: 20000000:dec00000)
Aug  1 19:42:57 frya kernel: [    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
Aug  1 19:42:57 frya kernel: [    0.000000] PERCPU: Embedded 9 pages at c1402000, static data 23196 bytes
Aug  1 19:42:57 frya kernel: [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129942
Aug  1 19:42:57 frya kernel: [    0.000000] Kernel command line: auto BOOT_IMAGE=2.6.30r4-0 ro root=803
Aug  1 19:42:57 frya kernel: [    0.000000] Enabling fast FPU save and restore... done.
Aug  1 19:42:57 frya kernel: [    0.000000] Enabling unmasked SIMD FPU exception support... done.
Aug  1 19:42:57 frya kernel: [    0.000000] Initializing CPU#0
Aug  1 19:42:57 frya kernel: [    0.000000] RCU-based detection of stalled CPUs is enabled.
Aug  1 19:42:57 frya kernel: [    0.000000] NR_IRQS:2304 nr_irqs:512
Aug  1 19:42:57 frya kernel: [    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
Aug  1 19:42:57 frya kernel: [    0.000000] Fast TSC calibration using PIT
Aug  1 19:42:57 frya kernel: [    0.000000] Detected 999.863 MHz processor.
Aug  1 19:42:57 frya kernel: [    0.000999] Console: colour VGA+ 80x25
Aug  1 19:42:57 frya kernel: [    0.000999] console [tty0] enabled
Aug  1 19:42:57 frya kernel: [    0.000999] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Aug  1 19:42:57 frya kernel: [    0.000999] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Aug  1 19:42:57 frya kernel: [    0.000999] Memory: 510916k/524268k available (4925k kernel code, 12808k reserved, 1927k data, 468k init, 0k highmem)
Aug  1 19:42:57 frya kernel: [    0.000999] virtual kernel memory layout:
Aug  1 19:42:57 frya kernel: [    0.000999]     fixmap  : 0xfff9d000 - 0xfffff000   ( 392 kB)
Aug  1 19:42:57 frya kernel: [    0.000999]     vmalloc : 0xe07fb000 - 0xfff9b000   ( 503 MB)
Aug  1 19:42:57 frya kernel: [    0.000999]     lowmem  : 0xc0000000 - 0xdfffb000   ( 511 MB)
Aug  1 19:42:57 frya kernel: [    0.000999]       .init : 0xc07b9000 - 0xc082e000   ( 468 kB)
Aug  1 19:42:57 frya kernel: [    0.000999]       .data : 0xc05cf7fa - 0xc07b1700   (1927 kB)
Aug  1 19:42:57 frya kernel: [    0.000999]       .text : 0xc0100000 - 0xc05cf7fa   (4925 kB)
Aug  1 19:42:57 frya kernel: [    0.000999] Checking if this processor honours the WP bit even in supervisor mode...Ok.
Aug  1 19:42:57 frya kernel: [    0.000999] SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Aug  1 19:42:57 frya kernel: [    0.001015] Calibrating delay loop (skipped), value calculated using timer frequency.. 1999.72 BogoMIPS (lpj=999863)
Aug  1 19:42:57 frya kernel: [    0.001292] Security Framework initialized
Aug  1 19:42:57 frya kernel: [    0.001433] Mount-cache hash table entries: 512
Aug  1 19:42:57 frya kernel: [    0.001872] CPU: L1 I cache: 16K, L1 D cache: 16K
Aug  1 19:42:57 frya kernel: [    0.002008] CPU: L2 cache: 256K
Aug  1 19:42:57 frya kernel: [    0.002120] Intel machine check architecture supported.
Aug  1 19:42:57 frya kernel: [    0.002238] Intel machine check reporting enabled on CPU#0.
Aug  1 19:42:57 frya kernel: [    0.002375] Checking 'hlt' instruction... OK.
Aug  1 19:42:57 frya kernel: [    0.006929] Freeing SMP alternatives: 18k freed
Aug  1 19:42:57 frya kernel: [    0.007276] ExtINT not setup in hardware but reported by MP table
Aug  1 19:42:57 frya kernel: [    0.007998] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
Aug  1 19:42:57 frya kernel: [    0.007998] ...trying to set up timer (IRQ0) through the 8259A ...
Aug  1 19:42:57 frya kernel: [    0.007998] ..... (found apic 0 pin 0) ...
Aug  1 19:42:57 frya kernel: [    0.018703] ....... works.
Aug  1 19:42:57 frya kernel: [    0.018809] CPU0: Intel Pentium III (Coppermine) stepping 06
Aug  1 19:42:57 frya kernel: [    0.019996] Booting processor 1 APIC 0x0 ip 0x6000
Aug  1 19:42:57 frya kernel: [    0.000999] Initializing CPU#1
Aug  1 19:42:57 frya kernel: [    0.000999] Calibrating delay using timer specific routine.. 1999.73 BogoMIPS (lpj=999865)
Aug  1 19:42:57 frya kernel: [    0.000999] CPU: L1 I cache: 16K, L1 D cache: 16K
Aug  1 19:42:57 frya kernel: [    0.000999] CPU: L2 cache: 256K
Aug  1 19:42:57 frya kernel: [    0.000999] Intel machine check architecture supported.
Aug  1 19:42:57 frya kernel: [    0.000999] Intel machine check reporting enabled on CPU#1.
Aug  1 19:42:57 frya kernel: [    0.090284] CPU1: Intel Pentium III (Coppermine) stepping 06
Aug  1 19:42:57 frya kernel: [    0.091172] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Aug  1 19:42:57 frya kernel: [    0.092045] Brought up 2 CPUs
Aug  1 19:42:57 frya kernel: [    0.092158] Total of 2 processors activated (3999.45 BogoMIPS).
Aug  1 19:42:57 frya kernel: [    0.093186] net_namespace: 772 bytes
Aug  1 19:42:57 frya kernel: [    0.095057] NET: Registered protocol family 16
Aug  1 19:42:57 frya kernel: [    0.096075] EISA bus registered
Aug  1 19:42:57 frya kernel: [    0.098549] PCI: PCI BIOS revision 2.10 entry at 0xf0a80, last bus=1
Aug  1 19:42:57 frya kernel: [    0.098675] PCI: Using configuration type 1 for base access
Aug  1 19:42:57 frya kernel: [    0.116107] bio: create slab <bio-0> at 0
Aug  1 19:42:57 frya kernel: [    0.117158] ACPI: Interpreter disabled.
Aug  1 19:42:57 frya kernel: [    0.118043] SCSI subsystem initialized
Aug  1 19:42:57 frya kernel: [    0.119048] usbcore: registered new interface driver usbfs
Aug  1 19:42:57 frya kernel: [    0.119208] usbcore: registered new interface driver hub
Aug  1 19:42:57 frya kernel: [    0.119247] usbcore: registered new device driver usb
Aug  1 19:42:57 frya kernel: [    0.120113] PCI: Probing PCI hardware
Aug  1 19:42:57 frya kernel: [    0.121015] * The chipset may have PM-Timer Bug. Due to workarounds for a bug,
Aug  1 19:42:57 frya kernel: [    0.121020] * this clock source is slow. If you are sure your timer does not have
Aug  1 19:42:57 frya kernel: [    0.121024] * this bug, please use "acpi_pm_good" to disable the workaround
Aug  1 19:42:57 frya kernel: [    0.121563] * The chipset may have PM-Timer Bug. Due to workarounds for a bug,
Aug  1 19:42:57 frya kernel: [    0.121568] * this clock source is slow. If you are sure your timer does not have
Aug  1 19:42:57 frya kernel: [    0.121572] * this bug, please use "acpi_pm_good" to disable the workaround
Aug  1 19:42:57 frya kernel: [    0.122165] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot
Aug  1 19:42:57 frya kernel: [    0.122290] pci 0000:00:02.0: PME# disabled
Aug  1 19:42:57 frya kernel: [    0.123082] pci 0000:00:04.0: PME# supported from D1 D2 D3hot
Aug  1 19:42:57 frya kernel: [    0.123205] pci 0000:00:04.0: PME# disabled
Aug  1 19:42:57 frya kernel: [    0.125105] PCI: Discovered peer bus 01
Aug  1 19:42:57 frya kernel: [    0.125231] pci 0000:01:02.0: PME# supported from D3hot D3cold
Aug  1 19:42:57 frya kernel: [    0.125231] pci 0000:01:02.0: PME# disabled
Aug  1 19:42:57 frya kernel: [    0.127021] pci 0000:00:0f.0: ServerWorks IRQ router [1166:0200]
Aug  1 19:42:57 frya kernel: [    0.127174] pci 0000:00:02.0: PCI->APIC IRQ transform: INT A -> IRQ 20
Aug  1 19:42:57 frya kernel: [    0.127301] pci 0000:00:04.0: PCI->APIC IRQ transform: INT A -> IRQ 17
Aug  1 19:42:57 frya kernel: [    0.127436] pci 0000:01:02.0: PCI->APIC IRQ transform: INT A -> IRQ 21
Aug  1 19:42:57 frya kernel: [    0.127563] pci 0000:01:03.0: PCI->APIC IRQ transform: INT A -> IRQ 22
Aug  1 19:42:57 frya kernel: [    0.127689] pci 0000:01:05.0: PCI->APIC IRQ transform: INT A -> IRQ 24
Aug  1 19:42:57 frya kernel: [    0.127816] pci 0000:01:05.1: PCI->APIC IRQ transform: INT B -> IRQ 25
Aug  1 19:42:57 frya kernel: [    0.133586] pnp: PnP ACPI: disabled
Aug  1 19:42:57 frya kernel: [    0.168688] NET: Registered protocol family 2
Aug  1 19:42:57 frya kernel: [    0.179171] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
Aug  1 19:42:57 frya kernel: [    0.180115] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
Aug  1 19:42:57 frya kernel: [    0.180590] TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
Aug  1 19:42:57 frya kernel: [    0.181150] TCP: Hash tables configured (established 16384 bind 16384)
Aug  1 19:42:57 frya kernel: [    0.181288] TCP reno registered
Aug  1 19:42:57 frya kernel: [    0.184310] NET: Registered protocol family 1
Aug  1 19:42:57 frya kernel: [    0.184892] Simple Boot Flag at 0x3a set to 0x1
Aug  1 19:42:57 frya kernel: [    0.185379] platform rtc_cmos: registered platform RTC device (no PNP device found)
Aug  1 19:42:57 frya kernel: [    0.187359] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Aug  1 19:42:57 frya kernel: [    0.187567] Scanning for low memory corruption every 60 seconds
Aug  1 19:42:57 frya kernel: [    0.189184] HugeTLB registered 4 MB page size, pre-allocated 0 pages
Aug  1 19:42:57 frya kernel: [    0.199152] VFS: Disk quotas dquot_6.5.2
Aug  1 19:42:57 frya kernel: [    0.199571] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Aug  1 19:42:57 frya kernel: [    0.202444] squashfs: version 4.0 (2009/01/31) Phillip Lougher
Aug  1 19:42:57 frya kernel: [    0.204076] NTFS driver 2.1.29 [Flags: R/W].
Aug  1 19:42:57 frya kernel: [    0.204620] ROMFS MTD (C) 2007 Red Hat, Inc.
Aug  1 19:42:57 frya kernel: [    0.205139] fuse init (API version 7.11)
Aug  1 19:42:57 frya kernel: [    0.206068] msgmni has been set to 998
Aug  1 19:42:57 frya kernel: [    0.206552] alg: No test for cipher_null (cipher_null-generic)
Aug  1 19:42:57 frya kernel: [    0.206776] alg: No test for ecb(cipher_null) (ecb-cipher_null)
Aug  1 19:42:57 frya kernel: [    0.207034] alg: No test for digest_null (digest_null-generic)
Aug  1 19:42:57 frya kernel: [    0.207244] alg: No test for compress_null (compress_null-generic)
Aug  1 19:42:57 frya kernel: [    0.210079] alg: No test for fcrypt (fcrypt-generic)
Aug  1 19:42:57 frya kernel: [    0.217331] alg: No test for stdrng (krng)
Aug  1 19:42:57 frya kernel: [    0.217581] alg: No test for stdrng (ansi_cprng)
Aug  1 19:42:57 frya kernel: [    0.217804] io scheduler noop registered
Aug  1 19:42:57 frya kernel: [    0.217919] io scheduler deadline registered (default)
Aug  1 19:42:57 frya kernel: [    0.218124] pci 0000:00:02.0: Firmware left e100 interrupts enabled; disabling
Aug  1 19:42:57 frya kernel: [    0.342517] Non-volatile memory driver v1.3
Aug  1 19:42:57 frya kernel: [    0.342852] Linux agpgart interface v0.103
Aug  1 19:42:57 frya kernel: [    0.343173] agpgart-serverworks 0000:00:00.0: agp_backend_initialize() failed
Aug  1 19:42:57 frya kernel: [    0.343310] agpgart-serverworks: probe of 0000:00:00.0 failed with error -22
Aug  1 19:42:57 frya kernel: [    0.343586] agpgart-serverworks 0000:00:00.1: agp_backend_initialize() failed
Aug  1 19:42:57 frya kernel: [    0.343718] agpgart-serverworks: probe of 0000:00:00.1 failed with error -22
Aug  1 19:42:57 frya kernel: [    0.344055] ipmi message handler version 39.2
Aug  1 19:42:57 frya kernel: [    0.344181] ipmi device interface
Aug  1 19:42:57 frya kernel: [    0.344515] IPMI System Interface driver.
Aug  1 19:42:57 frya kernel: [    0.356249] ipmi_si: Unable to find any System Interface(s)
Aug  1 19:42:57 frya kernel: [    0.356376] IPMI Watchdog: driver initialized
Aug  1 19:42:57 frya kernel: [    0.356488] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
Aug  1 19:42:57 frya kernel: [    0.356713] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Aug  1 19:42:57 frya kernel: [    0.356908] Hangcheck: Using get_cycles().
Aug  1 19:42:57 frya kernel: [    0.357210] atyfb: using auxiliary register aperture
Aug  1 19:42:57 frya kernel: [    0.357754] atyfb: 3D RAGE XL (Mach64 GR, PCI-33) [0x4752 rev 0x27]
Aug  1 19:42:57 frya kernel: [    0.357879] atyfb: Mach64 BIOS is located at c0000, mapped at c00c0000.
Aug  1 19:42:57 frya kernel: [    0.358012] atyfb: BIOS frequency table:
Aug  1 19:42:57 frya kernel: [    0.358127] atyfb: PCLK_min_freq 984, PCLK_max_freq 23500, ref_freq 1432, ref_divider 31
Aug  1 19:42:57 frya kernel: [    0.358322] atyfb: MCLK_pwd 4200, MCLK_max_freq 8000, XCLK_max_freq 6000, SCLK_freq 5000
Aug  1 19:42:57 frya kernel: [    0.358542] atyfb: 4M SDRAM (2:1) (32-bit), 14.31818 MHz XTAL, 235 MHz PLL, 80 Mhz MCLK, 60 MHz XCLK
Aug  1 19:42:57 frya kernel: [    0.363765] mtrr: Serverworks LE rev < 6 detected. Write-combining disabled.
Aug  1 19:42:57 frya kernel: [    0.363893] mtrr: your processor doesn't support write-combining
Aug  1 19:42:57 frya kernel: [    0.364371] fbcon: ATY Mach64 (fb0) is primary device
Aug  1 19:42:57 frya kernel: [    0.419686] Console: switching to colour frame buffer device 80x30
Aug  1 19:42:57 frya kernel: [    0.431314] atyfb: fb0: ATY Mach64 frame buffer device on PCI
Aug  1 19:42:57 frya kernel: [    0.436662] uvesafb: probe of uvesafb.0 failed with error -22
Aug  1 19:42:57 frya kernel: [    0.439248] isapnp: Scanning for PnP cards...
Aug  1 19:42:57 frya kernel: [    0.797886] isapnp: No Plug & Play device found
Aug  1 19:42:57 frya kernel: [    0.800445] Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
Aug  1 19:42:57 frya kernel: [    0.803566] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Aug  1 19:42:57 frya kernel: [    0.807245] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Aug  1 19:42:57 frya kernel: [    0.816232] brd: module loaded
Aug  1 19:42:57 frya kernel: [    0.822206] loop: module loaded
Aug  1 19:42:57 frya kernel: [    0.825914] 3ware Storage Controller device driver for Linux v1.26.02.002.
Aug  1 19:42:57 frya kernel: [    2.258030] scsi0 : 3ware Storage Controller
Aug  1 19:42:57 frya kernel: [    2.262541] 3w-xxxx: scsi0: Found a 3ware Storage Controller at 0xb400, IRQ: 22.
Aug  1 19:42:57 frya kernel: [    2.271840] scsi 0:0:0:0: Direct-Access     3ware    Logical Disk 0   1.2  PQ: 0 ANSI: 0
Aug  1 19:42:57 frya kernel: [    2.282249] Driver 'sd' needs updating - please use bus_type methods
Aug  1 19:42:57 frya kernel: [    2.287989] Driver 'sr' needs updating - please use bus_type methods
Aug  1 19:42:57 frya kernel: [    2.294446] sd 0:0:0:0: Attached scsi generic sg0 type 0
Aug  1 19:42:57 frya kernel: [    2.300290] 3c59x: Donald Becker and others.
Aug  1 19:42:57 frya kernel: [    2.305920] 0000:00:04.0: 3Com PCI 3c905B Cyclone 100baseTx at e08fc000.
Aug  1 19:42:57 frya kernel: [    2.333223] sd 0:0:0:0: [sda] 703318656 512-byte hardware sectors: (360 GB/335 GiB)
Aug  1 19:42:57 frya kernel: [    2.344861] sd 0:0:0:0: [sda] Write Protect is off
Aug  1 19:42:57 frya kernel: [    2.350947] sd 0:0:0:0: [sda] Write cache: enabled, read cache: disabled, supports DPO and FUA
Aug  1 19:42:57 frya kernel: [    2.362912] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
Aug  1 19:42:57 frya kernel: [    2.368800] e100: Copyright(c) 1999-2006 Intel Corporation
Aug  1 19:42:57 frya kernel: [    2.397736] e100 0000:00:02.0: PME# disabled
Aug  1 19:42:57 frya kernel: [    2.404387] e100: eth1: e100_probe: addr 0xfe000000, irq 20, MAC addr 00:e0:18:29:b7:b5
Aug  1 19:42:57 frya kernel: [    2.416482] tg3.c:v3.98 (February 25, 2009)
Aug  1 19:42:57 frya kernel: [    2.422685]  sda:<6>tg3 0000:01:02.0: PME# disabled
Aug  1 19:42:57 frya kernel: [    2.430410]  sda1 sda2 sda3 sda4 < sda5 >
Aug  1 19:42:57 frya kernel: [    2.449072] sd 0:0:0:0: [sda] Attached SCSI disk
Aug  1 19:42:57 frya kernel: [    3.456413] eth2: Tigon3 [partno(3C996B-T) rev 0105] (PCI:33MHz:64-bit) MAC address 00:0a:5e:1d:43:be
Aug  1 19:42:57 frya kernel: [    3.468527] eth2: attached PHY is 5701 (10/100/1000Base-T Ethernet) (WireSpeed[1])
Aug  1 19:42:57 frya kernel: [    3.480590] eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[0]
Aug  1 19:42:57 frya kernel: [    3.486639] eth2: dma_rwctrl[76ff000f] dma_mask[64-bit]
Aug  1 19:42:57 frya kernel: [    3.493890] PPP generic driver version 2.4.2
Aug  1 19:42:57 frya kernel: [    3.500502] PPP Deflate Compression module registered
Aug  1 19:42:57 frya kernel: [    3.506526] PPP BSD Compression module registered
Aug  1 19:42:57 frya kernel: [    3.515214] tun: Universal TUN/TAP device driver, 1.6
Aug  1 19:42:57 frya kernel: [    3.521124] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Aug  1 19:42:57 frya kernel: [    3.527782] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Aug  1 19:42:57 frya kernel: [    3.533864] 116x: driver isp116x-hcd, 03 Nov 2005
Aug  1 19:42:57 frya kernel: [    3.539741] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
Aug  1 19:42:57 frya kernel: [    3.545719] uhci_hcd: USB Universal Host Controller Interface driver
Aug  1 19:42:57 frya kernel: [    3.551687] sl811: driver sl811-hcd, 19 May 2005
Aug  1 19:42:57 frya kernel: [    3.557453] r8a66597_hcd: driver r8a66597_hcd, 10 Apr 2008
Aug  1 19:42:57 frya kernel: [    3.563489] usbcore: registered new interface driver cdc_acm
Aug  1 19:42:57 frya kernel: [    3.569211] cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
Aug  1 19:42:57 frya kernel: [    3.580821] usbcore: registered new interface driver usblp
Aug  1 19:42:57 frya kernel: [    3.586707] usbcore: registered new interface driver cdc_wdm
Aug  1 19:42:57 frya kernel: [    3.592365] Initializing USB Mass Storage driver...
Aug  1 19:42:57 frya kernel: [    3.598147] usbcore: registered new interface driver usb-storage
Aug  1 19:42:57 frya kernel: [    3.603931] USB Mass Storage support registered.
Aug  1 19:42:57 frya kernel: [    3.609708] usbcore: registered new interface driver libusual
Aug  1 19:42:57 frya kernel: [    3.615442] usbcore: registered new interface driver ums-alauda
Aug  1 19:42:57 frya kernel: [    3.620963] usbcore: registered new interface driver ums-cypress
Aug  1 19:42:57 frya kernel: [    3.626215] usbcore: registered new interface driver ums-datafab
Aug  1 19:42:57 frya kernel: [    3.631246] usbcore: registered new interface driver ums-freecom
Aug  1 19:42:57 frya kernel: [    3.636133] usbcore: registered new interface driver ums-isd200
Aug  1 19:42:57 frya kernel: [    3.640885] usbcore: registered new interface driver ums-jumpshot
Aug  1 19:42:57 frya kernel: [    3.645535] usbcore: registered new interface driver ums-karma
Aug  1 19:42:57 frya kernel: [    3.650070] usbcore: registered new interface driver ums-onetouch
Aug  1 19:42:57 frya kernel: [    3.654487] usbcore: registered new interface driver ums-sddr09
Aug  1 19:42:57 frya kernel: [    3.658749] usbcore: registered new interface driver ums-sddr55
Aug  1 19:42:57 frya kernel: [    3.662807] usbcore: registered new interface driver ums-usbat
Aug  1 19:42:57 frya kernel: [    3.667016] PNP: No PS/2 controller found. Probing ports directly.
Aug  1 19:42:57 frya kernel: [    3.922383] serio: i8042 KBD port at 0x60,0x64 irq 1
Aug  1 19:42:57 frya kernel: [    3.926764] mice: PS/2 mouse device common for all mice
Aug  1 19:42:57 frya kernel: [    3.931126] I2O subsystem v1.325
Aug  1 19:42:57 frya kernel: [    3.934771] i2o: max drivers = 8
Aug  1 19:42:57 frya kernel: [    3.938790] I2O Configuration OSM v1.323
Aug  1 19:42:57 frya kernel: [    3.942339] I2O Bus Adapter OSM v1.317
Aug  1 19:42:57 frya kernel: [    3.945646] I2O Block Device OSM v1.325
Aug  1 19:42:57 frya kernel: [    3.949246] I2O SCSI Peripheral OSM v1.316
Aug  1 19:42:57 frya kernel: [    3.952514] I2O ProcFS OSM v1.316
Aug  1 19:42:57 frya kernel: [    3.956216] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
Aug  1 19:42:57 frya kernel: [    3.959462] rtc0: alarms up to one day, 114 bytes nvram
Aug  1 19:42:57 frya kernel: [    3.965202] i2c /dev entries driver
Aug  1 19:42:57 frya kernel: [    3.968833] piix4_smbus 0000:00:0f.0: SMBus Host Controller at 0xe800, revision 0
Aug  1 19:42:57 frya kernel: [    4.115067] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
Aug  1 19:42:57 frya kernel: [    4.119227] iTCO_wdt: No card detected
Aug  1 19:42:57 frya kernel: [    4.123078] iTCO_vendor_support: vendor-support=0
Aug  1 19:42:57 frya kernel: [    4.127055] SMsC 37B787 watchdog component driver 1.1 initialising...
Aug  1 19:42:57 frya kernel: [    4.132669] smsc37b787_wdt: Timeout set to 60 second(s).
Aug  1 19:42:57 frya kernel: [    4.137036] smsc37b787_wdt: Watchdog initialized and sleeping (nowayout=0)...
Aug  1 19:42:57 frya kernel: [    4.141798] WDT driver for the Winbond(TM) W83627HF/THF/HG Super I/O chip initialising.
Aug  1 19:42:57 frya kernel: [    4.151584] w83627hf/thf/hg WDT: Watchdog already running. Resetting timeout to 60 sec
Aug  1 19:42:57 frya kernel: [    4.173014] w83697hf/hg WDT: WDT driver for W83697HF/HG initializing
Aug  1 19:42:57 frya kernel: [    4.178682] w83697hf/hg WDT: watchdog not found at address 0x2e
Aug  1 19:42:57 frya kernel: [    4.190055] WDT driver for the Winbond(TM) W83697UG/UF Super I/O chip initialising.
Aug  1 19:42:57 frya kernel: [    4.214445] W83977F WDT: W83977F WDT driver, v1.00
Aug  1 19:42:57 frya kernel: [    4.227045] EISA: Probing bus 0 at eisa.0
Aug  1 19:42:57 frya kernel: [    4.233171] EISA: Detected 0 cards.
Aug  1 19:42:57 frya kernel: [    4.239051] cpuidle: using governor ladder
Aug  1 19:42:57 frya kernel: [    4.244772] cpuidle: using governor menu
Aug  1 19:42:57 frya kernel: [    4.253046] usbcore: registered new interface driver usbhid
Aug  1 19:42:57 frya kernel: [    4.258719] usbhid: v2.6:USB HID core driver
Aug  1 19:42:57 frya kernel: [    4.264653] GACT probability on
Aug  1 19:42:57 frya kernel: [    4.270141] Mirror/redirect action on
Aug  1 19:42:57 frya kernel: [    4.276643] u32 classifier
Aug  1 19:42:57 frya kernel: [    4.281928]     Performance counters on
Aug  1 19:42:57 frya kernel: [    4.287117]     input device check on
Aug  1 19:42:57 frya kernel: [    4.292090]     Actions configured
Aug  1 19:42:57 frya kernel: [    4.296864] Netfilter messages via NETLINK v0.30.
Aug  1 19:42:57 frya kernel: [    4.301587] nf_conntrack version 0.5.0 (8191 buckets, 32764 max)
Aug  1 19:42:57 frya kernel: [    4.306653] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
Aug  1 19:42:57 frya kernel: [    4.315689] nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
Aug  1 19:42:57 frya kernel: [    4.325185] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
Aug  1 19:42:57 frya kernel: [    4.330372] ctnetlink v0.93: registering with nfnetlink.
Aug  1 19:42:57 frya kernel: [    4.335289] xt_time: kernel timezone is -0000
Aug  1 19:42:57 frya kernel: [    4.341427] IPv4 over IPv4 tunneling driver
Aug  1 19:42:57 frya kernel: [    4.347336] GRE over IPv4 tunneling driver
Aug  1 19:42:57 frya kernel: [    4.353685] ip_tables: (C) 2000-2006 Netfilter Core Team
Aug  1 19:42:57 frya kernel: [    4.358486] TCP bic registered
Aug  1 19:42:57 frya kernel: [    4.363083] TCP cubic registered
Aug  1 19:42:57 frya kernel: [    4.367670] TCP westwood registered
Aug  1 19:42:57 frya kernel: [    4.372219] TCP htcp registered
Aug  1 19:42:57 frya kernel: [    4.376799] Initializing XFRM netlink socket
Aug  1 19:42:57 frya kernel: [    4.381372] NET: Registered protocol family 17
Aug  1 19:42:57 frya kernel: [    4.385916] NET: Registered protocol family 15
Aug  1 19:42:57 frya kernel: [    4.390344] Using IPI Shortcut mode
Aug  1 19:42:57 frya kernel: [    4.394755] ------------[ cut here ]------------
Aug  1 19:42:57 frya kernel: [    4.399247] WARNING: at arch/x86/mm/ioremap.c:603 check_early_ioremap_leak+0x53/0x73()
Aug  1 19:42:57 frya kernel: [    4.408763] Hardware name: System Name
Aug  1 19:42:57 frya kernel: [    4.413574] Debug warning: early ioremap leak of 1 areas detected.
Aug  1 19:42:57 frya kernel: [    4.418561] Pid: 1, comm: swapper Not tainted 2.6.30-gentoo-r4 #1
Aug  1 19:42:57 frya kernel: [    4.423552] Call Trace:
Aug  1 19:42:57 frya kernel: [    4.428379]  [<c07c90b2>] ? check_early_ioremap_leak+0x53/0x73
Aug  1 19:42:57 frya kernel: [    4.433238]  [<c07c90b2>] ? check_early_ioremap_leak+0x53/0x73
Aug  1 19:42:57 frya kernel: [    4.437821]  [<c01316ac>] warn_slowpath_common+0x6c/0xc0
Aug  1 19:42:57 frya kernel: [    4.442266]  [<c07c90b2>] ? check_early_ioremap_leak+0x53/0x73
Aug  1 19:42:57 frya kernel: [    4.446658]  [<c07c905f>] ? check_early_ioremap_leak+0x0/0x73
Aug  1 19:42:57 frya kernel: [    4.450880]  [<c013174b>] warn_slowpath_fmt+0x2b/0x30
Aug  1 19:42:57 frya kernel: [    4.455062]  [<c07c90b2>] check_early_ioremap_leak+0x53/0x73
Aug  1 19:42:57 frya kernel: [    4.459288]  [<c010103f>] do_one_initcall+0x2f/0x160
Aug  1 19:42:57 frya kernel: [    4.463528]  [<c01e3d3a>] ? create_proc_entry+0x5a/0xb0
Aug  1 19:42:57 frya kernel: [    4.467751]  [<c015cfe5>] ? register_irq_proc+0xa5/0xc0
Aug  1 19:42:57 frya kernel: [    4.471924]  [<c015a1a8>] ? irq_to_desc+0x8/0x40
Aug  1 19:42:57 frya kernel: [    4.476110]  [<c015d075>] ? init_irq_proc+0x75/0x90
Aug  1 19:42:57 frya kernel: [    4.480343]  [<c07b95b5>] kernel_init+0x122/0x179
Aug  1 19:42:57 frya kernel: [    4.484616]  [<c07b9493>] ? kernel_init+0x0/0x179
Aug  1 19:42:57 frya kernel: [    4.488860]  [<c010397f>] kernel_thread_helper+0x7/0x10
Aug  1 19:42:57 frya kernel: [    4.493137] ---[ end trace d2a1e0f2aa8609d9 ]---
Aug  1 19:42:57 frya kernel: [    4.497524] please boot with early_ioremap_debug and report the dmesg.
Aug  1 19:42:57 frya kernel: [    4.503249] drivers/rtc/hctosys.c: unable to open rtc device (y)
Aug  1 19:42:57 frya kernel: [    4.526377] REISERFS (device sda3): found reiserfs format "3.6" with standard journal
Aug  1 19:42:57 frya kernel: [    4.535695] REISERFS (device sda3): using ordered data mode
Aug  1 19:42:57 frya kernel: [    4.546720] REISERFS (device sda3): journal params: device sda3, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Aug  1 19:42:57 frya kernel: [    4.565193] REISERFS (device sda3): checking transaction log (sda3)
Aug  1 19:42:57 frya kernel: [   61.950144] REISERFS (device sda3): replayed 195 transactions in 57 seconds
Aug  1 19:42:57 frya kernel: [   61.955726] REISERFS (device sda3): Using r5 hash to sort names
Aug  1 19:42:57 frya kernel: [   61.976102] VFS: Mounted root (reiserfs filesystem) readonly on device 8:3.
Aug  1 19:42:57 frya kernel: [   61.981412] Freeing unused kernel memory: 468k freed
Aug  1 19:42:57 frya kernel: [   73.101356] udev: starting version 141
Aug  1 19:42:57 frya kernel: [   78.332128] REISERFS (device sda3): Removing [3 24171599 0x0 SD]..done
Aug  1 19:42:57 frya kernel: [   78.332336] REISERFS (device sda3): Removing [3 24171529 0x0 SD]..done
Aug  1 19:42:57 frya kernel: [   78.332417] REISERFS (device sda3): Removing [3 24171512 0x0 SD]..done
Aug  1 19:42:57 frya kernel: [   78.332492] REISERFS (device sda3): Removing [3 24153663 0x0 SD]..done
Aug  1 19:42:57 frya kernel: [   78.332567] REISERFS (device sda3): Removing [3 24073847 0x0 SD]..done
Aug  1 19:42:57 frya kernel: [   78.332634] REISERFS (device sda3): There were 5 uncompleted unlinks/truncates. Completed
Aug  1 19:42:57 frya kernel: [   78.519769] REISERFS (device sda5): found reiserfs format "3.6" with standard journal
Aug  1 19:42:57 frya kernel: [   78.519808] REISERFS (device sda5): using ordered data mode
Aug  1 19:42:57 frya kernel: [   78.536287] REISERFS (device sda5): journal params: device sda5, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Aug  1 19:42:57 frya kernel: [   78.540304] REISERFS (device sda5): checking transaction log (sda5)
Aug  1 19:42:57 frya kernel: [   78.631246] REISERFS (device sda5): Using r5 hash to sort names
Aug  1 19:42:57 frya kernel: [   81.336374] Adding 136512k swap on /dev/sda1.  Priority:-1 extents:1 across:136512k
Aug  1 19:42:57 frya kernel: [   84.013334] eth0:  setting full-duplex.
Aug  1 19:42:58 frya kernel: [   84.443612] tg3 0000:01:02.0: PME# disabled
Aug  1 19:43:00 frya kernel: [   86.313272] tg3: eth2: Link is up at 100 Mbps, full duplex.
Aug  1 19:43:00 frya kernel: [   86.313282] tg3: eth2: Flow control is on for TX and on for RX.
Aug  1 19:57:47 frya syslogd 1.5.0: restart.
Aug  1 19:57:48 frya kernel: klogd 1.5.0, log source = /proc/kmsg started.
Aug  1 19:57:48 frya kernel: Inspecting /usr/src/linux/System.map
Aug  1 19:57:48 frya kernel: Cannot find map file.
Aug  1 19:57:48 frya kernel: Loaded 32195 symbols from 1 module.
Aug  1 19:57:48 frya kernel: [    0.000000] Linux version 2.6.30-gentoo-r4 (root@frya) (gcc version 4.3.3 (Gentoo 4.3.3-r2 p1.2, pie-10.1.5) ) #1 SMP Sat Aug 1 16:55:18 MSD 2009

You  can  see  here  system  have  no  warnings  before it freezes and
manually resetted.

Appendix  #5  and  #6  (.config  file  for  every kernel, 2.6.29.5 and
2.6.30.4)- see attachments.

Thanks in advance,

Osipov Stanislav
Linux System Administrator.
------------261781911372B433
Content-Type: application/octet-stream;
 name=".config-2.6.29.5"
Content-transfer-encoding: base64
Content-Disposition: attachment;
 filename=".config-2.6.29.5"

IwojIEF1dG9tYXRpY2FsbHkgZ2VuZXJhdGVkIG1ha2UgY29uZmlnOiBkb24ndCBlZGl0CiMg
TGludXgga2VybmVsIHZlcnNpb246IDIuNi4yOS1nZW50b28tcjUKIyBTdW4gSnVuICA3IDAx
OjExOjE1IDIwMDkKIwojIENPTkZJR182NEJJVCBpcyBub3Qgc2V0CkNPTkZJR19YODZfMzI9
eQojIENPTkZJR19YODZfNjQgaXMgbm90IHNldApDT05GSUdfWDg2PXkKQ09ORklHX0FSQ0hf
REVGQ09ORklHPSJhcmNoL3g4Ni9jb25maWdzL2kzODZfZGVmY29uZmlnIgpDT05GSUdfR0VO
RVJJQ19USU1FPXkKQ09ORklHX0dFTkVSSUNfQ01PU19VUERBVEU9eQpDT05GSUdfQ0xPQ0tT
T1VSQ0VfV0FUQ0hET0c9eQpDT05GSUdfR0VORVJJQ19DTE9DS0VWRU5UUz15CkNPTkZJR19H
RU5FUklDX0NMT0NLRVZFTlRTX0JST0FEQ0FTVD15CkNPTkZJR19MT0NLREVQX1NVUFBPUlQ9
eQpDT05GSUdfU1RBQ0tUUkFDRV9TVVBQT1JUPXkKQ09ORklHX0hBVkVfTEFURU5DWVRPUF9T
VVBQT1JUPXkKQ09ORklHX0ZBU1RfQ01QWENIR19MT0NBTD15CkNPTkZJR19NTVU9eQpDT05G
SUdfWk9ORV9ETUE9eQpDT05GSUdfR0VORVJJQ19JU0FfRE1BPXkKQ09ORklHX0dFTkVSSUNf
SU9NQVA9eQpDT05GSUdfR0VORVJJQ19CVUc9eQpDT05GSUdfR0VORVJJQ19IV0VJR0hUPXkK
Q09ORklHX0FSQ0hfTUFZX0hBVkVfUENfRkRDPXkKIyBDT05GSUdfUldTRU1fR0VORVJJQ19T
UElOTE9DSyBpcyBub3Qgc2V0CkNPTkZJR19SV1NFTV9YQ0hHQUREX0FMR09SSVRITT15CkNP
TkZJR19BUkNIX0hBU19DUFVfSURMRV9XQUlUPXkKQ09ORklHX0dFTkVSSUNfQ0FMSUJSQVRF
X0RFTEFZPXkKIyBDT05GSUdfR0VORVJJQ19USU1FX1ZTWVNDQUxMIGlzIG5vdCBzZXQKQ09O
RklHX0FSQ0hfSEFTX0NQVV9SRUxBWD15CkNPTkZJR19BUkNIX0hBU19ERUZBVUxUX0lETEU9
eQpDT05GSUdfQVJDSF9IQVNfQ0FDSEVfTElORV9TSVpFPXkKQ09ORklHX0hBVkVfU0VUVVBf
UEVSX0NQVV9BUkVBPXkKIyBDT05GSUdfSEFWRV9DUFVNQVNLX09GX0NQVV9NQVAgaXMgbm90
IHNldApDT05GSUdfQVJDSF9ISUJFUk5BVElPTl9QT1NTSUJMRT15CkNPTkZJR19BUkNIX1NV
U1BFTkRfUE9TU0lCTEU9eQojIENPTkZJR19aT05FX0RNQTMyIGlzIG5vdCBzZXQKQ09ORklH
X0FSQ0hfUE9QVUxBVEVTX05PREVfTUFQPXkKIyBDT05GSUdfQVVESVRfQVJDSCBpcyBub3Qg
c2V0CkNPTkZJR19BUkNIX1NVUFBPUlRTX09QVElNSVpFRF9JTkxJTklORz15CkNPTkZJR19H
RU5FUklDX0hBUkRJUlFTPXkKQ09ORklHX0dFTkVSSUNfSVJRX1BST0JFPXkKQ09ORklHX0dF
TkVSSUNfUEVORElOR19JUlE9eQpDT05GSUdfWDg2X1NNUD15CkNPTkZJR19VU0VfR0VORVJJ
Q19TTVBfSEVMUEVSUz15CkNPTkZJR19YODZfMzJfU01QPXkKQ09ORklHX1g4Nl9IVD15CkNP
TkZJR19YODZfQklPU19SRUJPT1Q9eQpDT05GSUdfWDg2X1RSQU1QT0xJTkU9eQpDT05GSUdf
S1RJTUVfU0NBTEFSPXkKQ09ORklHX0RFRkNPTkZJR19MSVNUPSIvbGliL21vZHVsZXMvJFVO
QU1FX1JFTEVBU0UvLmNvbmZpZyIKCiMKIyBHZW5lcmFsIHNldHVwCiMKIyBDT05GSUdfRVhQ
RVJJTUVOVEFMIGlzIG5vdCBzZXQKQ09ORklHX0xPQ0tfS0VSTkVMPXkKQ09ORklHX0lOSVRf
RU5WX0FSR19MSU1JVD0zMgpDT05GSUdfTE9DQUxWRVJTSU9OPSIiCiMgQ09ORklHX0xPQ0FM
VkVSU0lPTl9BVVRPIGlzIG5vdCBzZXQKQ09ORklHX1NXQVA9eQpDT05GSUdfU1lTVklQQz15
CkNPTkZJR19TWVNWSVBDX1NZU0NUTD15CkNPTkZJR19CU0RfUFJPQ0VTU19BQ0NUPXkKQ09O
RklHX0JTRF9QUk9DRVNTX0FDQ1RfVjM9eQojIENPTkZJR19UQVNLU1RBVFMgaXMgbm90IHNl
dAojIENPTkZJR19BVURJVCBpcyBub3Qgc2V0CgojCiMgUkNVIFN1YnN5c3RlbQojCiMgQ09O
RklHX0NMQVNTSUNfUkNVIGlzIG5vdCBzZXQKQ09ORklHX1RSRUVfUkNVPXkKIyBDT05GSUdf
UFJFRU1QVF9SQ1UgaXMgbm90IHNldAojIENPTkZJR19SQ1VfVFJBQ0UgaXMgbm90IHNldApD
T05GSUdfUkNVX0ZBTk9VVD0zMgojIENPTkZJR19SQ1VfRkFOT1VUX0VYQUNUIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVFJFRV9SQ1VfVFJBQ0UgaXMgbm90IHNldAojIENPTkZJR19QUkVFTVBU
X1JDVV9UUkFDRSBpcyBub3Qgc2V0CkNPTkZJR19JS0NPTkZJRz15CkNPTkZJR19JS0NPTkZJ
R19QUk9DPXkKQ09ORklHX0xPR19CVUZfU0hJRlQ9MTgKQ09ORklHX0hBVkVfVU5TVEFCTEVf
U0NIRURfQ0xPQ0s9eQojIENPTkZJR19DR1JPVVBTIGlzIG5vdCBzZXQKIyBDT05GSUdfU1lT
RlNfREVQUkVDQVRFRF9WMiBpcyBub3Qgc2V0CkNPTkZJR19SRUxBWT15CkNPTkZJR19OQU1F
U1BBQ0VTPXkKQ09ORklHX1VUU19OUz15CkNPTkZJR19JUENfTlM9eQojIENPTkZJR19CTEtf
REVWX0lOSVRSRCBpcyBub3Qgc2V0CiMgQ09ORklHX0NDX09QVElNSVpFX0ZPUl9TSVpFIGlz
IG5vdCBzZXQKQ09ORklHX1NZU0NUTD15CkNPTkZJR19BTk9OX0lOT0RFUz15CiMgQ09ORklH
X0VNQkVEREVEIGlzIG5vdCBzZXQKQ09ORklHX1VJRDE2PXkKQ09ORklHX1NZU0NUTF9TWVND
QUxMPXkKQ09ORklHX0tBTExTWU1TPXkKQ09ORklHX0tBTExTWU1TX0FMTD15CiMgQ09ORklH
X0tBTExTWU1TX0VYVFJBX1BBU1MgaXMgbm90IHNldApDT05GSUdfSE9UUExVRz15CkNPTkZJ
R19QUklOVEs9eQpDT05GSUdfQlVHPXkKQ09ORklHX0VMRl9DT1JFPXkKQ09ORklHX1BDU1BL
Ul9QTEFURk9STT15CkNPTkZJR19CQVNFX0ZVTEw9eQpDT05GSUdfRlVURVg9eQpDT05GSUdf
RVBPTEw9eQpDT05GSUdfU0lHTkFMRkQ9eQpDT05GSUdfVElNRVJGRD15CkNPTkZJR19FVkVO
VEZEPXkKQ09ORklHX1NITUVNPXkKQ09ORklHX0FJTz15CkNPTkZJR19WTV9FVkVOVF9DT1VO
VEVSUz15CkNPTkZJR19QQ0lfUVVJUktTPXkKQ09ORklHX1NMVUJfREVCVUc9eQojIENPTkZJ
R19DT01QQVRfQlJLIGlzIG5vdCBzZXQKIyBDT05GSUdfU0xBQiBpcyBub3Qgc2V0CkNPTkZJ
R19TTFVCPXkKIyBDT05GSUdfU0xPQiBpcyBub3Qgc2V0CiMgQ09ORklHX1BST0ZJTElORyBp
cyBub3Qgc2V0CkNPTkZJR19UUkFDRVBPSU5UUz15CiMgQ09ORklHX01BUktFUlMgaXMgbm90
IHNldApDT05GSUdfSEFWRV9PUFJPRklMRT15CkNPTkZJR19IQVZFX0VGRklDSUVOVF9VTkFM
SUdORURfQUNDRVNTPXkKQ09ORklHX0hBVkVfSU9SRU1BUF9QUk9UPXkKQ09ORklHX0hBVkVf
S1BST0JFUz15CkNPTkZJR19IQVZFX0tSRVRQUk9CRVM9eQpDT05GSUdfSEFWRV9BUkNIX1RS
QUNFSE9PSz15CkNPTkZJR19IQVZFX0dFTkVSSUNfRE1BX0NPSEVSRU5UPXkKQ09ORklHX1NM
QUJJTkZPPXkKQ09ORklHX1JUX01VVEVYRVM9eQpDT05GSUdfQkFTRV9TTUFMTD0wCiMgQ09O
RklHX01PRFVMRVMgaXMgbm90IHNldApDT05GSUdfQkxPQ0s9eQpDT05GSUdfTEJEPXkKQ09O
RklHX0JMS19ERVZfSU9fVFJBQ0U9eQpDT05GSUdfQkxLX0RFVl9JTlRFR1JJVFk9eQoKIwoj
IElPIFNjaGVkdWxlcnMKIwpDT05GSUdfSU9TQ0hFRF9OT09QPXkKQ09ORklHX0lPU0NIRURf
QVM9eQpDT05GSUdfSU9TQ0hFRF9ERUFETElORT15CkNPTkZJR19JT1NDSEVEX0NGUT15CkNP
TkZJR19ERUZBVUxUX0FTPXkKIyBDT05GSUdfREVGQVVMVF9ERUFETElORSBpcyBub3Qgc2V0
CiMgQ09ORklHX0RFRkFVTFRfQ0ZRIGlzIG5vdCBzZXQKIyBDT05GSUdfREVGQVVMVF9OT09Q
IGlzIG5vdCBzZXQKQ09ORklHX0RFRkFVTFRfSU9TQ0hFRD0iYW50aWNpcGF0b3J5IgojIENP
TkZJR19GUkVFWkVSIGlzIG5vdCBzZXQKCiMKIyBQcm9jZXNzb3IgdHlwZSBhbmQgZmVhdHVy
ZXMKIwpDT05GSUdfVElDS19PTkVTSE9UPXkKQ09ORklHX05PX0haPXkKQ09ORklHX0hJR0hf
UkVTX1RJTUVSUz15CkNPTkZJR19HRU5FUklDX0NMT0NLRVZFTlRTX0JVSUxEPXkKQ09ORklH
X1NNUD15CkNPTkZJR19TUEFSU0VfSVJRPXkKQ09ORklHX1g4Nl9GSU5EX1NNUF9DT05GSUc9
eQpDT05GSUdfWDg2X01QUEFSU0U9eQpDT05GSUdfWDg2X1BDPXkKIyBDT05GSUdfWDg2X0VM
QU4gaXMgbm90IHNldAojIENPTkZJR19YODZfVk9ZQUdFUiBpcyBub3Qgc2V0CiMgQ09ORklH
X1g4Nl9HRU5FUklDQVJDSCBpcyBub3Qgc2V0CiMgQ09ORklHX1g4Nl9WU01QIGlzIG5vdCBz
ZXQKIyBDT05GSUdfWDg2X1JEQzMyMVggaXMgbm90IHNldApDT05GSUdfU0NIRURfT01JVF9G
UkFNRV9QT0lOVEVSPXkKIyBDT05GSUdfUEFSQVZJUlRfR1VFU1QgaXMgbm90IHNldApDT05G
SUdfTUVNVEVTVD15CiMgQ09ORklHX00zODYgaXMgbm90IHNldAojIENPTkZJR19NNDg2IGlz
IG5vdCBzZXQKIyBDT05GSUdfTTU4NiBpcyBub3Qgc2V0CiMgQ09ORklHX001ODZUU0MgaXMg
bm90IHNldAojIENPTkZJR19NNTg2TU1YIGlzIG5vdCBzZXQKIyBDT05GSUdfTTY4NiBpcyBu
b3Qgc2V0CiMgQ09ORklHX01QRU5USVVNSUkgaXMgbm90IHNldApDT05GSUdfTVBFTlRJVU1J
SUk9eQojIENPTkZJR19NUEVOVElVTU0gaXMgbm90IHNldAojIENPTkZJR19NUEVOVElVTTQg
aXMgbm90IHNldAojIENPTkZJR19NSzYgaXMgbm90IHNldAojIENPTkZJR19NSzcgaXMgbm90
IHNldAojIENPTkZJR19NSzggaXMgbm90IHNldAojIENPTkZJR19NQ1JVU09FIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTUVGRklDRU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfTVdJTkNISVBDNiBp
cyBub3Qgc2V0CiMgQ09ORklHX01XSU5DSElQM0QgaXMgbm90IHNldAojIENPTkZJR19NR0VP
REVHWDEgaXMgbm90IHNldAojIENPTkZJR19NR0VPREVfTFggaXMgbm90IHNldAojIENPTkZJ
R19NQ1lSSVhJSUkgaXMgbm90IHNldAojIENPTkZJR19NVklBQzNfMiBpcyBub3Qgc2V0CiMg
Q09ORklHX01WSUFDNyBpcyBub3Qgc2V0CiMgQ09ORklHX01QU0MgaXMgbm90IHNldAojIENP
TkZJR19NQ09SRTIgaXMgbm90IHNldAojIENPTkZJR19HRU5FUklDX0NQVSBpcyBub3Qgc2V0
CiMgQ09ORklHX1g4Nl9HRU5FUklDIGlzIG5vdCBzZXQKQ09ORklHX1g4Nl9DUFU9eQpDT05G
SUdfWDg2X0NNUFhDSEc9eQpDT05GSUdfWDg2X0wxX0NBQ0hFX1NISUZUPTUKQ09ORklHX1g4
Nl9YQUREPXkKQ09ORklHX1g4Nl9XUF9XT1JLU19PSz15CkNPTkZJR19YODZfSU5WTFBHPXkK
Q09ORklHX1g4Nl9CU1dBUD15CkNPTkZJR19YODZfUE9QQURfT0s9eQpDT05GSUdfWDg2X0lO
VEVMX1VTRVJDT1BZPXkKQ09ORklHX1g4Nl9VU0VfUFBST19DSEVDS1NVTT15CkNPTkZJR19Y
ODZfVFNDPXkKQ09ORklHX1g4Nl9DTVBYQ0hHNjQ9eQpDT05GSUdfWDg2X0NNT1Y9eQpDT05G
SUdfWDg2X01JTklNVU1fQ1BVX0ZBTUlMWT00CkNPTkZJR19YODZfREVCVUdDVExNU1I9eQpD
T05GSUdfQ1BVX1NVUF9JTlRFTD15CkNPTkZJR19DUFVfU1VQX0NZUklYXzMyPXkKQ09ORklH
X0NQVV9TVVBfQU1EPXkKQ09ORklHX0NQVV9TVVBfQ0VOVEFVUl8zMj15CkNPTkZJR19DUFVf
U1VQX1RSQU5TTUVUQV8zMj15CkNPTkZJR19DUFVfU1VQX1VNQ18zMj15CiMgQ09ORklHX1g4
Nl9EUyBpcyBub3Qgc2V0CkNPTkZJR19IUEVUX1RJTUVSPXkKQ09ORklHX0hQRVRfRU1VTEFU
RV9SVEM9eQpDT05GSUdfRE1JPXkKIyBDT05GSUdfSU9NTVVfSEVMUEVSIGlzIG5vdCBzZXQK
IyBDT05GSUdfSU9NTVVfQVBJIGlzIG5vdCBzZXQKQ09ORklHX05SX0NQVVM9MgpDT05GSUdf
U0NIRURfU01UPXkKQ09ORklHX1NDSEVEX01DPXkKIyBDT05GSUdfUFJFRU1QVF9OT05FIGlz
IG5vdCBzZXQKQ09ORklHX1BSRUVNUFRfVk9MVU5UQVJZPXkKIyBDT05GSUdfUFJFRU1QVCBp
cyBub3Qgc2V0CkNPTkZJR19YODZfTE9DQUxfQVBJQz15CkNPTkZJR19YODZfSU9fQVBJQz15
CkNPTkZJR19YODZfUkVST1VURV9GT1JfQlJPS0VOX0JPT1RfSVJRUz15CkNPTkZJR19YODZf
TUNFPXkKIyBDT05GSUdfWDg2X01DRV9OT05GQVRBTCBpcyBub3Qgc2V0CiMgQ09ORklHX1g4
Nl9NQ0VfUDRUSEVSTUFMIGlzIG5vdCBzZXQKQ09ORklHX1ZNODY9eQojIENPTkZJR19UT1NI
SUJBIGlzIG5vdCBzZXQKIyBDT05GSUdfSThLIGlzIG5vdCBzZXQKIyBDT05GSUdfWDg2X1JF
Qk9PVEZJWFVQUyBpcyBub3Qgc2V0CkNPTkZJR19NSUNST0NPREU9eQpDT05GSUdfTUlDUk9D
T0RFX0lOVEVMPXkKIyBDT05GSUdfTUlDUk9DT0RFX0FNRCBpcyBub3Qgc2V0CkNPTkZJR19N
SUNST0NPREVfT0xEX0lOVEVSRkFDRT15CkNPTkZJR19YODZfTVNSPXkKQ09ORklHX1g4Nl9D
UFVJRD15CkNPTkZJR19OT0hJR0hNRU09eQojIENPTkZJR19ISUdITUVNNEcgaXMgbm90IHNl
dAojIENPTkZJR19ISUdITUVNNjRHIGlzIG5vdCBzZXQKQ09ORklHX1BBR0VfT0ZGU0VUPTB4
QzAwMDAwMDAKQ09ORklHX1g4Nl9QQUU9eQpDT05GSUdfQVJDSF9QSFlTX0FERFJfVF82NEJJ
VD15CkNPTkZJR19GTEFUTUVNPXkKQ09ORklHX0ZMQVRfTk9ERV9NRU1fTUFQPXkKQ09ORklH
X1BBR0VGTEFHU19FWFRFTkRFRD15CkNPTkZJR19TUExJVF9QVExPQ0tfQ1BVUz00CkNPTkZJ
R19QSFlTX0FERFJfVF82NEJJVD15CkNPTkZJR19aT05FX0RNQV9GTEFHPTEKQ09ORklHX0JP
VU5DRT15CkNPTkZJR19WSVJUX1RPX0JVUz15CkNPTkZJR19VTkVWSUNUQUJMRV9MUlU9eQpD
T05GSUdfWDg2X0NIRUNLX0JJT1NfQ09SUlVQVElPTj15CkNPTkZJR19YODZfQk9PVFBBUkFN
X01FTU9SWV9DT1JSVVBUSU9OX0NIRUNLPXkKQ09ORklHX1g4Nl9SRVNFUlZFX0xPV182NEs9
eQojIENPTkZJR19NQVRIX0VNVUxBVElPTiBpcyBub3Qgc2V0CkNPTkZJR19NVFJSPXkKQ09O
RklHX01UUlJfU0FOSVRJWkVSPXkKQ09ORklHX01UUlJfU0FOSVRJWkVSX0VOQUJMRV9ERUZB
VUxUPTAKQ09ORklHX01UUlJfU0FOSVRJWkVSX1NQQVJFX1JFR19OUl9ERUZBVUxUPTEKQ09O
RklHX1g4Nl9QQVQ9eQojIENPTkZJR19FRkkgaXMgbm90IHNldApDT05GSUdfU0VDQ09NUD15
CiMgQ09ORklHX0haXzEwMCBpcyBub3Qgc2V0CkNPTkZJR19IWl8yNTA9eQojIENPTkZJR19I
Wl8zMDAgaXMgbm90IHNldAojIENPTkZJR19IWl8xMDAwIGlzIG5vdCBzZXQKQ09ORklHX0ha
PTI1MApDT05GSUdfU0NIRURfSFJUSUNLPXkKQ09ORklHX0tFWEVDPXkKQ09ORklHX1BIWVNJ
Q0FMX1NUQVJUPTB4MTAwMDAwCkNPTkZJR19QSFlTSUNBTF9BTElHTj0weDEwMDAwMAojIENP
TkZJR19IT1RQTFVHX0NQVSBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTVBBVF9WRFNPIGlzIG5v
dCBzZXQKIyBDT05GSUdfQ01ETElORV9CT09MIGlzIG5vdCBzZXQKCiMKIyBQb3dlciBtYW5h
Z2VtZW50IGFuZCBBQ1BJIG9wdGlvbnMKIwpDT05GSUdfUE09eQojIENPTkZJR19QTV9ERUJV
RyBpcyBub3Qgc2V0CiMgQ09ORklHX1NVU1BFTkQgaXMgbm90IHNldAojIENPTkZJR19ISUJF
Uk5BVElPTiBpcyBub3Qgc2V0CkNPTkZJR19BQ1BJPXkKIyBDT05GSUdfQUNQSV9QUk9DRlMg
aXMgbm90IHNldAojIENPTkZJR19BQ1BJX1BST0NGU19QT1dFUiBpcyBub3Qgc2V0CkNPTkZJ
R19BQ1BJX1NZU0ZTX1BPV0VSPXkKIyBDT05GSUdfQUNQSV9QUk9DX0VWRU5UIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQUNQSV9BQyBpcyBub3Qgc2V0CiMgQ09ORklHX0FDUElfQkFUVEVSWSBp
cyBub3Qgc2V0CiMgQ09ORklHX0FDUElfQlVUVE9OIGlzIG5vdCBzZXQKQ09ORklHX0FDUElf
VklERU89eQojIENPTkZJR19BQ1BJX0ZBTiBpcyBub3Qgc2V0CkNPTkZJR19BQ1BJX1BST0NF
U1NPUj15CkNPTkZJR19BQ1BJX1RIRVJNQUw9eQojIENPTkZJR19BQ1BJX0NVU1RPTV9EU0RU
IGlzIG5vdCBzZXQKQ09ORklHX0FDUElfQkxBQ0tMSVNUX1lFQVI9MAojIENPTkZJR19BQ1BJ
X0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0FDUElfUENJX1NMT1Q9eQpDT05GSUdfWDg2X1BN
X1RJTUVSPXkKIyBDT05GSUdfQUNQSV9TQlMgaXMgbm90IHNldAoKIwojIENQVSBGcmVxdWVu
Y3kgc2NhbGluZwojCiMgQ09ORklHX0NQVV9GUkVRIGlzIG5vdCBzZXQKQ09ORklHX0NQVV9J
RExFPXkKQ09ORklHX0NQVV9JRExFX0dPVl9MQURERVI9eQpDT05GSUdfQ1BVX0lETEVfR09W
X01FTlU9eQoKIwojIEJ1cyBvcHRpb25zIChQQ0kgZXRjLikKIwpDT05GSUdfUENJPXkKIyBD
T05GSUdfUENJX0dPQklPUyBpcyBub3Qgc2V0CiMgQ09ORklHX1BDSV9HT01NQ09ORklHIGlz
IG5vdCBzZXQKIyBDT05GSUdfUENJX0dPRElSRUNUIGlzIG5vdCBzZXQKIyBDT05GSUdfUENJ
X0dPT0xQQyBpcyBub3Qgc2V0CkNPTkZJR19QQ0lfR09BTlk9eQpDT05GSUdfUENJX0JJT1M9
eQpDT05GSUdfUENJX0RJUkVDVD15CkNPTkZJR19QQ0lfTU1DT05GSUc9eQpDT05GSUdfUENJ
X0RPTUFJTlM9eQojIENPTkZJR19QQ0lFUE9SVEJVUyBpcyBub3Qgc2V0CkNPTkZJR19BUkNI
X1NVUFBPUlRTX01TST15CkNPTkZJR19QQ0lfTVNJPXkKIyBDT05GSUdfUENJX0xFR0FDWSBp
cyBub3Qgc2V0CiMgQ09ORklHX1BDSV9TVFVCIGlzIG5vdCBzZXQKIyBDT05GSUdfSFRfSVJR
IGlzIG5vdCBzZXQKQ09ORklHX0lTQV9ETUFfQVBJPXkKIyBDT05GSUdfSVNBIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTUNBIGlzIG5vdCBzZXQKQ09ORklHX1NDeDIwMD15CkNPTkZJR19TQ3gy
MDBIUl9USU1FUj15CiMgQ09ORklHX09MUEMgaXMgbm90IHNldAojIENPTkZJR19QQ0NBUkQg
aXMgbm90IHNldAojIENPTkZJR19IT1RQTFVHX1BDSSBpcyBub3Qgc2V0CgojCiMgRXhlY3V0
YWJsZSBmaWxlIGZvcm1hdHMgLyBFbXVsYXRpb25zCiMKQ09ORklHX0JJTkZNVF9FTEY9eQoj
IENPTkZJR19DT1JFX0RVTVBfREVGQVVMVF9FTEZfSEVBREVSUyBpcyBub3Qgc2V0CkNPTkZJ
R19IQVZFX0FPVVQ9eQpDT05GSUdfQklORk1UX0FPVVQ9eQpDT05GSUdfQklORk1UX01JU0M9
eQpDT05GSUdfSEFWRV9BVE9NSUNfSU9NQVA9eQpDT05GSUdfTkVUPXkKCiMKIyBOZXR3b3Jr
aW5nIG9wdGlvbnMKIwpDT05GSUdfQ09NUEFUX05FVF9ERVZfT1BTPXkKQ09ORklHX1BBQ0tF
VD15CkNPTkZJR19QQUNLRVRfTU1BUD15CkNPTkZJR19VTklYPXkKIyBDT05GSUdfTkVUX0tF
WSBpcyBub3Qgc2V0CkNPTkZJR19JTkVUPXkKQ09ORklHX0lQX01VTFRJQ0FTVD15CkNPTkZJ
R19JUF9BRFZBTkNFRF9ST1VURVI9eQpDT05GSUdfQVNLX0lQX0ZJQl9IQVNIPXkKIyBDT05G
SUdfSVBfRklCX1RSSUUgaXMgbm90IHNldApDT05GSUdfSVBfRklCX0hBU0g9eQpDT05GSUdf
SVBfTVVMVElQTEVfVEFCTEVTPXkKIyBDT05GSUdfSVBfUk9VVEVfTVVMVElQQVRIIGlzIG5v
dCBzZXQKIyBDT05GSUdfSVBfUk9VVEVfVkVSQk9TRSBpcyBub3Qgc2V0CiMgQ09ORklHX0lQ
X1BOUCBpcyBub3Qgc2V0CkNPTkZJR19ORVRfSVBJUD15CkNPTkZJR19ORVRfSVBHUkU9eQpD
T05GSUdfTkVUX0lQR1JFX0JST0FEQ0FTVD15CkNPTkZJR19JUF9NUk9VVEU9eQpDT05GSUdf
SVBfUElNU01fVjE9eQpDT05GSUdfSVBfUElNU01fVjI9eQojIENPTkZJR19TWU5fQ09PS0lF
UyBpcyBub3Qgc2V0CiMgQ09ORklHX0lORVRfQUggaXMgbm90IHNldAojIENPTkZJR19JTkVU
X0VTUCBpcyBub3Qgc2V0CiMgQ09ORklHX0lORVRfSVBDT01QIGlzIG5vdCBzZXQKIyBDT05G
SUdfSU5FVF9YRlJNX1RVTk5FTCBpcyBub3Qgc2V0CkNPTkZJR19JTkVUX1RVTk5FTD15CiMg
Q09ORklHX0lORVRfWEZSTV9NT0RFX1RSQU5TUE9SVCBpcyBub3Qgc2V0CiMgQ09ORklHX0lO
RVRfWEZSTV9NT0RFX1RVTk5FTCBpcyBub3Qgc2V0CiMgQ09ORklHX0lORVRfWEZSTV9NT0RF
X0JFRVQgaXMgbm90IHNldApDT05GSUdfSU5FVF9MUk89eQpDT05GSUdfSU5FVF9ESUFHPXkK
Q09ORklHX0lORVRfVENQX0RJQUc9eQojIENPTkZJR19UQ1BfQ09OR19BRFZBTkNFRCBpcyBu
b3Qgc2V0CkNPTkZJR19UQ1BfQ09OR19DVUJJQz15CkNPTkZJR19ERUZBVUxUX1RDUF9DT05H
PSJjdWJpYyIKIyBDT05GSUdfSVBWNiBpcyBub3Qgc2V0CiMgQ09ORklHX05FVExBQkVMIGlz
IG5vdCBzZXQKQ09ORklHX05FVFdPUktfU0VDTUFSSz15CkNPTkZJR19ORVRGSUxURVI9eQoj
IENPTkZJR19ORVRGSUxURVJfREVCVUcgaXMgbm90IHNldApDT05GSUdfTkVURklMVEVSX0FE
VkFOQ0VEPXkKCiMKIyBDb3JlIE5ldGZpbHRlciBDb25maWd1cmF0aW9uCiMKQ09ORklHX05F
VEZJTFRFUl9ORVRMSU5LPXkKQ09ORklHX05FVEZJTFRFUl9ORVRMSU5LX1FVRVVFPXkKQ09O
RklHX05FVEZJTFRFUl9ORVRMSU5LX0xPRz15CkNPTkZJR19ORl9DT05OVFJBQ0s9eQpDT05G
SUdfTkZfQ1RfQUNDVD15CkNPTkZJR19ORl9DT05OVFJBQ0tfTUFSSz15CkNPTkZJR19ORl9D
T05OVFJBQ0tfU0VDTUFSSz15CkNPTkZJR19ORl9DT05OVFJBQ0tfRVZFTlRTPXkKQ09ORklH
X05GX0NUX1BST1RPX0dSRT15CkNPTkZJR19ORl9DVF9QUk9UT19VRFBMSVRFPXkKQ09ORklH
X05GX0NPTk5UUkFDS19BTUFOREE9eQpDT05GSUdfTkZfQ09OTlRSQUNLX0ZUUD15CkNPTkZJ
R19ORl9DT05OVFJBQ0tfSDMyMz15CkNPTkZJR19ORl9DT05OVFJBQ0tfSVJDPXkKQ09ORklH
X05GX0NPTk5UUkFDS19ORVRCSU9TX05TPXkKQ09ORklHX05GX0NPTk5UUkFDS19QUFRQPXkK
Q09ORklHX05GX0NPTk5UUkFDS19TSVA9eQpDT05GSUdfTkZfQ09OTlRSQUNLX1RGVFA9eQpD
T05GSUdfTkZfQ1RfTkVUTElOSz15CkNPTkZJR19ORVRGSUxURVJfWFRBQkxFUz15CkNPTkZJ
R19ORVRGSUxURVJfWFRfVEFSR0VUX0NMQVNTSUZZPXkKQ09ORklHX05FVEZJTFRFUl9YVF9U
QVJHRVRfQ09OTk1BUks9eQpDT05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9DT05OU0VDTUFS
Sz15CkNPTkZJR19ORVRGSUxURVJfWFRfVEFSR0VUX0RTQ1A9eQpDT05GSUdfTkVURklMVEVS
X1hUX1RBUkdFVF9NQVJLPXkKQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfTkZMT0c9eQpD
T05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9ORlFVRVVFPXkKQ09ORklHX05FVEZJTFRFUl9Y
VF9UQVJHRVRfUkFURUVTVD15CkNPTkZJR19ORVRGSUxURVJfWFRfVEFSR0VUX1NFQ01BUks9
eQpDT05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9UQ1BNU1M9eQpDT05GSUdfTkVURklMVEVS
X1hUX01BVENIX0NPTU1FTlQ9eQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0NPTk5CWVRF
Uz15CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfQ09OTkxJTUlUPXkKQ09ORklHX05FVEZJ
TFRFUl9YVF9NQVRDSF9DT05OTUFSSz15CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfQ09O
TlRSQUNLPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9EQ0NQPXkKQ09ORklHX05FVEZJ
TFRFUl9YVF9NQVRDSF9EU0NQPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9FU1A9eQpD
T05GSUdfTkVURklMVEVSX1hUX01BVENIX0hBU0hMSU1JVD15CkNPTkZJR19ORVRGSUxURVJf
WFRfTUFUQ0hfSEVMUEVSPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9JUFJBTkdFPXkK
Q09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9MRU5HVEg9eQpDT05GSUdfTkVURklMVEVSX1hU
X01BVENIX0xJTUlUPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9NQUM9eQpDT05GSUdf
TkVURklMVEVSX1hUX01BVENIX01BUks9eQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX01V
TFRJUE9SVD15CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfT1dORVI9eQpDT05GSUdfTkVU
RklMVEVSX1hUX01BVENIX1BLVFRZUEU9eQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1FV
T1RBPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9SQVRFRVNUPXkKQ09ORklHX05FVEZJ
TFRFUl9YVF9NQVRDSF9SRUFMTT15CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfUkVDRU5U
PXkKIyBDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1JFQ0VOVF9QUk9DX0NPTVBBVCBpcyBu
b3Qgc2V0CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfU1RBVEU9eQpDT05GSUdfTkVURklM
VEVSX1hUX01BVENIX1NUQVRJU1RJQz15CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfU1RS
SU5HPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9UQ1BNU1M9eQpDT05GSUdfTkVURklM
VEVSX1hUX01BVENIX1RJTUU9eQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1UzMj15CiMg
Q09ORklHX0lQX1ZTIGlzIG5vdCBzZXQKCiMKIyBJUDogTmV0ZmlsdGVyIENvbmZpZ3VyYXRp
b24KIwpDT05GSUdfTkZfREVGUkFHX0lQVjQ9eQpDT05GSUdfTkZfQ09OTlRSQUNLX0lQVjQ9
eQojIENPTkZJR19ORl9DT05OVFJBQ0tfUFJPQ19DT01QQVQgaXMgbm90IHNldAojIENPTkZJ
R19JUF9ORl9RVUVVRSBpcyBub3Qgc2V0CkNPTkZJR19JUF9ORl9JUFRBQkxFUz15CkNPTkZJ
R19JUF9ORl9NQVRDSF9BRERSVFlQRT15CkNPTkZJR19JUF9ORl9NQVRDSF9BSD15CkNPTkZJ
R19JUF9ORl9NQVRDSF9FQ049eQpDT05GSUdfSVBfTkZfTUFUQ0hfVFRMPXkKQ09ORklHX0lQ
X05GX0ZJTFRFUj15CkNPTkZJR19JUF9ORl9UQVJHRVRfUkVKRUNUPXkKQ09ORklHX0lQX05G
X1RBUkdFVF9MT0c9eQpDT05GSUdfSVBfTkZfVEFSR0VUX1VMT0c9eQpDT05GSUdfTkZfTkFU
PXkKQ09ORklHX05GX05BVF9ORUVERUQ9eQpDT05GSUdfSVBfTkZfVEFSR0VUX01BU1FVRVJB
REU9eQpDT05GSUdfSVBfTkZfVEFSR0VUX05FVE1BUD15CkNPTkZJR19JUF9ORl9UQVJHRVRf
UkVESVJFQ1Q9eQpDT05GSUdfTkZfTkFUX1NOTVBfQkFTSUM9eQpDT05GSUdfTkZfTkFUX1BS
T1RPX0dSRT15CkNPTkZJR19ORl9OQVRfUFJPVE9fVURQTElURT15CkNPTkZJR19ORl9OQVRf
RlRQPXkKQ09ORklHX05GX05BVF9JUkM9eQpDT05GSUdfTkZfTkFUX1RGVFA9eQpDT05GSUdf
TkZfTkFUX0FNQU5EQT15CkNPTkZJR19ORl9OQVRfUFBUUD15CkNPTkZJR19ORl9OQVRfSDMy
Mz15CkNPTkZJR19ORl9OQVRfU0lQPXkKQ09ORklHX0lQX05GX01BTkdMRT15CkNPTkZJR19J
UF9ORl9UQVJHRVRfRUNOPXkKQ09ORklHX0lQX05GX1RBUkdFVF9UVEw9eQojIENPTkZJR19J
UF9ORl9SQVcgaXMgbm90IHNldAojIENPTkZJR19JUF9ORl9TRUNVUklUWSBpcyBub3Qgc2V0
CiMgQ09ORklHX0lQX05GX0FSUFRBQkxFUyBpcyBub3Qgc2V0CiMgQ09ORklHX0FUTSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0JSSURHRSBpcyBub3Qgc2V0CiMgQ09ORklHX1ZMQU5fODAyMVEg
aXMgbm90IHNldAojIENPTkZJR19ERUNORVQgaXMgbm90IHNldAojIENPTkZJR19MTEMyIGlz
IG5vdCBzZXQKIyBDT05GSUdfSVBYIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRBTEsgaXMgbm90
IHNldApDT05GSUdfTkVUX1NDSEVEPXkKCiMKIyBRdWV1ZWluZy9TY2hlZHVsaW5nCiMKQ09O
RklHX05FVF9TQ0hfQ0JRPXkKQ09ORklHX05FVF9TQ0hfSFRCPXkKQ09ORklHX05FVF9TQ0hf
SEZTQz15CkNPTkZJR19ORVRfU0NIX1BSSU89eQpDT05GSUdfTkVUX1NDSF9NVUxUSVE9eQpD
T05GSUdfTkVUX1NDSF9SRUQ9eQpDT05GSUdfTkVUX1NDSF9TRlE9eQpDT05GSUdfTkVUX1ND
SF9URVFMPXkKQ09ORklHX05FVF9TQ0hfVEJGPXkKQ09ORklHX05FVF9TQ0hfR1JFRD15CkNP
TkZJR19ORVRfU0NIX0RTTUFSSz15CiMgQ09ORklHX05FVF9TQ0hfTkVURU0gaXMgbm90IHNl
dApDT05GSUdfTkVUX1NDSF9EUlI9eQpDT05GSUdfTkVUX1NDSF9JTkdSRVNTPXkKCiMKIyBD
bGFzc2lmaWNhdGlvbgojCkNPTkZJR19ORVRfQ0xTPXkKQ09ORklHX05FVF9DTFNfQkFTSUM9
eQpDT05GSUdfTkVUX0NMU19UQ0lOREVYPXkKQ09ORklHX05FVF9DTFNfUk9VVEU0PXkKQ09O
RklHX05FVF9DTFNfUk9VVEU9eQpDT05GSUdfTkVUX0NMU19GVz15CkNPTkZJR19ORVRfQ0xT
X1UzMj15CkNPTkZJR19DTFNfVTMyX1BFUkY9eQpDT05GSUdfQ0xTX1UzMl9NQVJLPXkKQ09O
RklHX05FVF9DTFNfUlNWUD15CkNPTkZJR19ORVRfQ0xTX1JTVlA2PXkKQ09ORklHX05FVF9D
TFNfRkxPVz15CkNPTkZJR19ORVRfRU1BVENIPXkKQ09ORklHX05FVF9FTUFUQ0hfU1RBQ0s9
MzIKQ09ORklHX05FVF9FTUFUQ0hfQ01QPXkKQ09ORklHX05FVF9FTUFUQ0hfTkJZVEU9eQpD
T05GSUdfTkVUX0VNQVRDSF9VMzI9eQpDT05GSUdfTkVUX0VNQVRDSF9NRVRBPXkKQ09ORklH
X05FVF9FTUFUQ0hfVEVYVD15CkNPTkZJR19ORVRfQ0xTX0FDVD15CkNPTkZJR19ORVRfQUNU
X1BPTElDRT15CkNPTkZJR19ORVRfQUNUX0dBQ1Q9eQpDT05GSUdfR0FDVF9QUk9CPXkKQ09O
RklHX05FVF9BQ1RfTUlSUkVEPXkKQ09ORklHX05FVF9BQ1RfSVBUPXkKQ09ORklHX05FVF9B
Q1RfTkFUPXkKQ09ORklHX05FVF9BQ1RfUEVESVQ9eQojIENPTkZJR19ORVRfQUNUX1NJTVAg
aXMgbm90IHNldApDT05GSUdfTkVUX0FDVF9TS0JFRElUPXkKQ09ORklHX05FVF9DTFNfSU5E
PXkKQ09ORklHX05FVF9TQ0hfRklGTz15CiMgQ09ORklHX0RDQiBpcyBub3Qgc2V0CgojCiMg
TmV0d29yayB0ZXN0aW5nCiMKIyBDT05GSUdfTkVUX1BLVEdFTiBpcyBub3Qgc2V0CiMgQ09O
RklHX0hBTVJBRElPIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0FOIGlzIG5vdCBzZXQKIyBDT05G
SUdfSVJEQSBpcyBub3Qgc2V0CiMgQ09ORklHX0JUIGlzIG5vdCBzZXQKIyBDT05GSUdfUEhP
TkVUIGlzIG5vdCBzZXQKQ09ORklHX0ZJQl9SVUxFUz15CiMgQ09ORklHX1dJUkVMRVNTIGlz
IG5vdCBzZXQKIyBDT05GSUdfV0lNQVggaXMgbm90IHNldAojIENPTkZJR19SRktJTEwgaXMg
bm90IHNldAoKIwojIERldmljZSBEcml2ZXJzCiMKCiMKIyBHZW5lcmljIERyaXZlciBPcHRp
b25zCiMKQ09ORklHX1VFVkVOVF9IRUxQRVJfUEFUSD0iL3NiaW4vaG90cGx1ZyIKQ09ORklH
X1NUQU5EQUxPTkU9eQojIENPTkZJR19QUkVWRU5UX0ZJUk1XQVJFX0JVSUxEIGlzIG5vdCBz
ZXQKQ09ORklHX0ZXX0xPQURFUj15CkNPTkZJR19GSVJNV0FSRV9JTl9LRVJORUw9eQpDT05G
SUdfRVhUUkFfRklSTVdBUkU9IiIKIyBDT05GSUdfU1lTX0hZUEVSVklTT1IgaXMgbm90IHNl
dApDT05GSUdfQ09OTkVDVE9SPXkKQ09ORklHX1BST0NfRVZFTlRTPXkKIyBDT05GSUdfTVRE
IGlzIG5vdCBzZXQKIyBDT05GSUdfUEFSUE9SVCBpcyBub3Qgc2V0CkNPTkZJR19QTlA9eQoj
IENPTkZJR19QTlBfREVCVUdfTUVTU0FHRVMgaXMgbm90IHNldAoKIwojIFByb3RvY29scwoj
CkNPTkZJR19QTlBBQ1BJPXkKQ09ORklHX0JMS19ERVY9eQojIENPTkZJR19CTEtfREVWX0ZE
IGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0NQUV9EQSBpcyBub3Qgc2V0CiMgQ09ORklHX0JM
S19DUFFfQ0lTU19EQSBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfREFDOTYwIGlzIG5v
dCBzZXQKIyBDT05GSUdfQkxLX0RFVl9DT1dfQ09NTU9OIGlzIG5vdCBzZXQKQ09ORklHX0JM
S19ERVZfTE9PUD15CkNPTkZJR19CTEtfREVWX0NSWVBUT0xPT1A9eQojIENPTkZJR19CTEtf
REVWX05CRCBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfU1g4IGlzIG5vdCBzZXQKIyBD
T05GSUdfQkxLX0RFVl9VQiBpcyBub3Qgc2V0CkNPTkZJR19CTEtfREVWX1JBTT15CkNPTkZJ
R19CTEtfREVWX1JBTV9DT1VOVD0xNgpDT05GSUdfQkxLX0RFVl9SQU1fU0laRT00MDk2CkNP
TkZJR19CTEtfREVWX1hJUD15CiMgQ09ORklHX0NEUk9NX1BLVENEVkQgaXMgbm90IHNldAoj
IENPTkZJR19BVEFfT1ZFUl9FVEggaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX0hEIGlz
IG5vdCBzZXQKIyBDT05GSUdfTUlTQ19ERVZJQ0VTIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVf
SURFPXkKIyBDT05GSUdfSURFIGlzIG5vdCBzZXQKCiMKIyBTQ1NJIGRldmljZSBzdXBwb3J0
CiMKQ09ORklHX1JBSURfQVRUUlM9eQpDT05GSUdfU0NTST15CkNPTkZJR19TQ1NJX0RNQT15
CkNPTkZJR19TQ1NJX1RHVD15CiMgQ09ORklHX1NDU0lfTkVUTElOSyBpcyBub3Qgc2V0CiMg
Q09ORklHX1NDU0lfUFJPQ19GUyBpcyBub3Qgc2V0CgojCiMgU0NTSSBzdXBwb3J0IHR5cGUg
KGRpc2ssIHRhcGUsIENELVJPTSkKIwpDT05GSUdfQkxLX0RFVl9TRD15CiMgQ09ORklHX0NI
Ul9ERVZfU1QgaXMgbm90IHNldAojIENPTkZJR19DSFJfREVWX09TU1QgaXMgbm90IHNldAoj
IENPTkZJR19CTEtfREVWX1NSIGlzIG5vdCBzZXQKQ09ORklHX0NIUl9ERVZfU0c9eQojIENP
TkZJR19DSFJfREVWX1NDSCBpcyBub3Qgc2V0CgojCiMgU29tZSBTQ1NJIGRldmljZXMgKGUu
Zy4gQ0QganVrZWJveCkgc3VwcG9ydCBtdWx0aXBsZSBMVU5zCiMKQ09ORklHX1NDU0lfTVVM
VElfTFVOPXkKIyBDT05GSUdfU0NTSV9DT05TVEFOVFMgaXMgbm90IHNldApDT05GSUdfU0NT
SV9MT0dHSU5HPXkKQ09ORklHX1NDU0lfU0NBTl9BU1lOQz15CgojCiMgU0NTSSBUcmFuc3Bv
cnRzCiMKIyBDT05GSUdfU0NTSV9TUElfQVRUUlMgaXMgbm90IHNldAojIENPTkZJR19TQ1NJ
X0ZDX0FUVFJTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9JU0NTSV9BVFRSUyBpcyBub3Qg
c2V0CiMgQ09ORklHX1NDU0lfU0FTX0xJQlNBUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lf
U1JQX0FUVFJTIGlzIG5vdCBzZXQKQ09ORklHX1NDU0lfTE9XTEVWRUw9eQojIENPTkZJR19J
U0NTSV9UQ1AgaXMgbm90IHNldApDT05GSUdfQkxLX0RFVl8zV19YWFhYX1JBSUQ9eQojIENP
TkZJR19TQ1NJXzNXXzlYWFggaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0FDQVJEIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0NTSV9BQUNSQUlEIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9B
SUM3WFhYIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9BSUM3WFhYX09MRCBpcyBub3Qgc2V0
CiMgQ09ORklHX1NDU0lfQUlDNzlYWCBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfQUlDOTRY
WCBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfRFBUX0kyTyBpcyBub3Qgc2V0CiMgQ09ORklH
X1NDU0lfQURWQU5TWVMgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0FSQ01TUiBpcyBub3Qg
c2V0CiMgQ09ORklHX01FR0FSQUlEX05FV0dFTiBpcyBub3Qgc2V0CiMgQ09ORklHX01FR0FS
QUlEX0xFR0FDWSBpcyBub3Qgc2V0CiMgQ09ORklHX01FR0FSQUlEX1NBUyBpcyBub3Qgc2V0
CiMgQ09ORklHX1NDU0lfSFBUSU9QIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9CVVNMT0dJ
QyBpcyBub3Qgc2V0CiMgQ09ORklHX0xJQkZDIGlzIG5vdCBzZXQKIyBDT05GSUdfRkNPRSBp
cyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfRE1YMzE5MUQgaXMgbm90IHNldAojIENPTkZJR19T
Q1NJX0VBVEEgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0ZVVFVSRV9ET01BSU4gaXMgbm90
IHNldAojIENPTkZJR19TQ1NJX0dEVEggaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0lQUyBp
cyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfSU5JVElPIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NT
SV9JTklBMTAwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9NVlNBUyBpcyBub3Qgc2V0CiMg
Q09ORklHX1NDU0lfU1RFWCBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfU1lNNTNDOFhYXzIg
aXMgbm90IHNldAojIENPTkZJR19TQ1NJX1FMT0dJQ18xMjgwIGlzIG5vdCBzZXQKIyBDT05G
SUdfU0NTSV9RTEFfRkMgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX1FMQV9JU0NTSSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NDU0lfTFBGQyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfREMz
OTBUIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9OU1AzMiBpcyBub3Qgc2V0CiMgQ09ORklH
X1NDU0lfREVCVUcgaXMgbm90IHNldApDT05GSUdfU0NTSV9TUlA9eQojIENPTkZJR19TQ1NJ
X0RIIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRBIGlzIG5vdCBzZXQKIyBDT05GSUdfTUQgaXMg
bm90IHNldAojIENPTkZJR19GVVNJT04gaXMgbm90IHNldAoKIwojIElFRUUgMTM5NCAoRmly
ZVdpcmUpIHN1cHBvcnQKIwoKIwojIEEgbmV3IGFsdGVybmF0aXZlIEZpcmVXaXJlIHN0YWNr
IGlzIGF2YWlsYWJsZSB3aXRoIEVYUEVSSU1FTlRBTD15CiMKIyBDT05GSUdfSUVFRTEzOTQg
aXMgbm90IHNldApDT05GSUdfSTJPPXkKQ09ORklHX0kyT19MQ1RfTk9USUZZX09OX0NIQU5H
RVM9eQpDT05GSUdfSTJPX0VYVF9BREFQVEVDPXkKQ09ORklHX0kyT19DT05GSUc9eQojIENP
TkZJR19JMk9fQ09ORklHX09MRF9JT0NUTCBpcyBub3Qgc2V0CkNPTkZJR19JMk9fQlVTPXkK
Q09ORklHX0kyT19CTE9DSz15CkNPTkZJR19JMk9fU0NTST15CkNPTkZJR19JMk9fUFJPQz15
CiMgQ09ORklHX01BQ0lOVE9TSF9EUklWRVJTIGlzIG5vdCBzZXQKQ09ORklHX05FVERFVklD
RVM9eQpDT05GSUdfSUZCPXkKQ09ORklHX0RVTU1ZPXkKIyBDT05GSUdfQk9ORElORyBpcyBu
b3Qgc2V0CiMgQ09ORklHX0VRVUFMSVpFUiBpcyBub3Qgc2V0CkNPTkZJR19UVU49eQojIENP
TkZJR19WRVRIIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1NCMTAwMCBpcyBub3Qgc2V0CiMg
Q09ORklHX0FSQ05FVCBpcyBub3Qgc2V0CkNPTkZJR19QSFlMSUI9eQoKIwojIE1JSSBQSFkg
ZGV2aWNlIGRyaXZlcnMKIwojIENPTkZJR19NQVJWRUxMX1BIWSBpcyBub3Qgc2V0CiMgQ09O
RklHX0RBVklDT01fUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfUVNFTUlfUEhZIGlzIG5vdCBz
ZXQKQ09ORklHX0xYVF9QSFk9eQojIENPTkZJR19DSUNBREFfUEhZIGlzIG5vdCBzZXQKIyBD
T05GSUdfVklURVNTRV9QSFkgaXMgbm90IHNldAojIENPTkZJR19TTVNDX1BIWSBpcyBub3Qg
c2V0CkNPTkZJR19CUk9BRENPTV9QSFk9eQojIENPTkZJR19JQ1BMVVNfUEhZIGlzIG5vdCBz
ZXQKIyBDT05GSUdfUkVBTFRFS19QSFkgaXMgbm90IHNldAojIENPTkZJR19OQVRJT05BTF9Q
SFkgaXMgbm90IHNldAojIENPTkZJR19TVEUxMFhQIGlzIG5vdCBzZXQKIyBDT05GSUdfTFNJ
X0VUMTAxMUNfUEhZIGlzIG5vdCBzZXQKQ09ORklHX0ZJWEVEX1BIWT15CkNPTkZJR19NRElP
X0JJVEJBTkc9eQpDT05GSUdfTkVUX0VUSEVSTkVUPXkKQ09ORklHX01JST15CiMgQ09ORklH
X0hBUFBZTUVBTCBpcyBub3Qgc2V0CiMgQ09ORklHX1NVTkdFTSBpcyBub3Qgc2V0CiMgQ09O
RklHX0NBU1NJTkkgaXMgbm90IHNldApDT05GSUdfTkVUX1ZFTkRPUl8zQ09NPXkKQ09ORklH
X1ZPUlRFWD15CiMgQ09ORklHX1RZUEhPT04gaXMgbm90IHNldAojIENPTkZJR19ETkVUIGlz
IG5vdCBzZXQKIyBDT05GSUdfTkVUX1RVTElQIGlzIG5vdCBzZXQKIyBDT05GSUdfSFAxMDAg
aXMgbm90IHNldAojIENPTkZJR19JQk1fTkVXX0VNQUNfWk1JSSBpcyBub3Qgc2V0CiMgQ09O
RklHX0lCTV9ORVdfRU1BQ19SR01JSSBpcyBub3Qgc2V0CiMgQ09ORklHX0lCTV9ORVdfRU1B
Q19UQUggaXMgbm90IHNldAojIENPTkZJR19JQk1fTkVXX0VNQUNfRU1BQzQgaXMgbm90IHNl
dAojIENPTkZJR19JQk1fTkVXX0VNQUNfTk9fRkxPV19DVFJMIGlzIG5vdCBzZXQKIyBDT05G
SUdfSUJNX05FV19FTUFDX01BTF9DTFJfSUNJTlRTVEFUIGlzIG5vdCBzZXQKIyBDT05GSUdf
SUJNX05FV19FTUFDX01BTF9DT01NT05fRVJSIGlzIG5vdCBzZXQKQ09ORklHX05FVF9QQ0k9
eQojIENPTkZJR19QQ05FVDMyIGlzIG5vdCBzZXQKIyBDT05GSUdfQU1EODExMV9FVEggaXMg
bm90IHNldAojIENPTkZJR19BREFQVEVDX1NUQVJGSVJFIGlzIG5vdCBzZXQKIyBDT05GSUdf
QjQ0IGlzIG5vdCBzZXQKIyBDT05GSUdfRk9SQ0VERVRIIGlzIG5vdCBzZXQKQ09ORklHX0Ux
MDA9eQojIENPTkZJR19GRUFMTlggaXMgbm90IHNldAojIENPTkZJR19OQVRTRU1JIGlzIG5v
dCBzZXQKIyBDT05GSUdfTkUyS19QQ0kgaXMgbm90IHNldAojIENPTkZJR184MTM5VE9PIGlz
IG5vdCBzZXQKIyBDT05GSUdfUjYwNDAgaXMgbm90IHNldAojIENPTkZJR19TSVM5MDAgaXMg
bm90IHNldAojIENPTkZJR19FUElDMTAwIGlzIG5vdCBzZXQKIyBDT05GSUdfU01TQzk0MjAg
aXMgbm90IHNldAojIENPTkZJR19TVU5EQU5DRSBpcyBub3Qgc2V0CiMgQ09ORklHX1RMQU4g
aXMgbm90IHNldAojIENPTkZJR19WSUFfUkhJTkUgaXMgbm90IHNldAojIENPTkZJR19BVEwy
IGlzIG5vdCBzZXQKQ09ORklHX05FVERFVl8xMDAwPXkKIyBDT05GSUdfQUNFTklDIGlzIG5v
dCBzZXQKIyBDT05GSUdfREwySyBpcyBub3Qgc2V0CiMgQ09ORklHX0UxMDAwIGlzIG5vdCBz
ZXQKIyBDT05GSUdfRTEwMDBFIGlzIG5vdCBzZXQKIyBDT05GSUdfSUdCIGlzIG5vdCBzZXQK
IyBDT05GSUdfTlM4MzgyMCBpcyBub3Qgc2V0CiMgQ09ORklHX0hBTUFDSEkgaXMgbm90IHNl
dAojIENPTkZJR19SODE2OSBpcyBub3Qgc2V0CiMgQ09ORklHX1NJUzE5MCBpcyBub3Qgc2V0
CiMgQ09ORklHX1NLR0UgaXMgbm90IHNldAojIENPTkZJR19TS1kyIGlzIG5vdCBzZXQKIyBD
T05GSUdfVklBX1ZFTE9DSVRZIGlzIG5vdCBzZXQKQ09ORklHX1RJR09OMz15CkNPTkZJR19C
TlgyPXkKIyBDT05GSUdfUUxBM1hYWCBpcyBub3Qgc2V0CiMgQ09ORklHX0FUTDEgaXMgbm90
IHNldAojIENPTkZJR19KTUUgaXMgbm90IHNldAojIENPTkZJR19ORVRERVZfMTAwMDAgaXMg
bm90IHNldAojIENPTkZJR19UUiBpcyBub3Qgc2V0CgojCiMgV2lyZWxlc3MgTEFOCiMKIyBD
T05GSUdfV0xBTl9QUkU4MDIxMSBpcyBub3Qgc2V0CiMgQ09ORklHX1dMQU5fODAyMTEgaXMg
bm90IHNldAojIENPTkZJR19JV0xXSUZJX0xFRFMgaXMgbm90IHNldAoKIwojIEVuYWJsZSBX
aU1BWCAoTmV0d29ya2luZyBvcHRpb25zKSB0byBzZWUgdGhlIFdpTUFYIGRyaXZlcnMKIwoK
IwojIFVTQiBOZXR3b3JrIEFkYXB0ZXJzCiMKIyBDT05GSUdfVVNCX0tBV0VUSCBpcyBub3Qg
c2V0CiMgQ09ORklHX1VTQl9QRUdBU1VTIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1VTQk5F
VCBpcyBub3Qgc2V0CiMgQ09ORklHX1dBTiBpcyBub3Qgc2V0CiMgQ09ORklHX0ZEREkgaXMg
bm90IHNldApDT05GSUdfUFBQPXkKQ09ORklHX1BQUF9GSUxURVI9eQpDT05GSUdfUFBQX0FT
WU5DPXkKQ09ORklHX1BQUF9TWU5DX1RUWT15CkNPTkZJR19QUFBfREVGTEFURT15CkNPTkZJ
R19QUFBfQlNEQ09NUD15CiMgQ09ORklHX1NMSVAgaXMgbm90IHNldApDT05GSUdfU0xIQz15
CiMgQ09ORklHX05FVF9GQyBpcyBub3Qgc2V0CiMgQ09ORklHX05FVFBPTEwgaXMgbm90IHNl
dAojIENPTkZJR19ORVRfUE9MTF9DT05UUk9MTEVSIGlzIG5vdCBzZXQKIyBDT05GSUdfSVNE
TiBpcyBub3Qgc2V0CiMgQ09ORklHX1BIT05FIGlzIG5vdCBzZXQKCiMKIyBJbnB1dCBkZXZp
Y2Ugc3VwcG9ydAojCkNPTkZJR19JTlBVVD15CkNPTkZJR19JTlBVVF9GRl9NRU1MRVNTPXkK
Q09ORklHX0lOUFVUX1BPTExERVY9eQoKIwojIFVzZXJsYW5kIGludGVyZmFjZXMKIwpDT05G
SUdfSU5QVVRfTU9VU0VERVY9eQpDT05GSUdfSU5QVVRfTU9VU0VERVZfUFNBVVg9eQpDT05G
SUdfSU5QVVRfTU9VU0VERVZfU0NSRUVOX1g9MTAyNApDT05GSUdfSU5QVVRfTU9VU0VERVZf
U0NSRUVOX1k9NzY4CiMgQ09ORklHX0lOUFVUX0pPWURFViBpcyBub3Qgc2V0CkNPTkZJR19J
TlBVVF9FVkRFVj15CiMgQ09ORklHX0lOUFVUX0VWQlVHIGlzIG5vdCBzZXQKCiMKIyBJbnB1
dCBEZXZpY2UgRHJpdmVycwojCkNPTkZJR19JTlBVVF9LRVlCT0FSRD15CkNPTkZJR19LRVlC
T0FSRF9BVEtCRD15CiMgQ09ORklHX0tFWUJPQVJEX1NVTktCRCBpcyBub3Qgc2V0CiMgQ09O
RklHX0tFWUJPQVJEX0xLS0JEIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfWFRLQkQg
aXMgbm90IHNldAojIENPTkZJR19LRVlCT0FSRF9ORVdUT04gaXMgbm90IHNldAojIENPTkZJ
R19LRVlCT0FSRF9TVE9XQVdBWSBpcyBub3Qgc2V0CkNPTkZJR19JTlBVVF9NT1VTRT15CkNP
TkZJR19NT1VTRV9QUzI9eQpDT05GSUdfTU9VU0VfUFMyX0FMUFM9eQpDT05GSUdfTU9VU0Vf
UFMyX0xPR0lQUzJQUD15CkNPTkZJR19NT1VTRV9QUzJfU1lOQVBUSUNTPXkKQ09ORklHX01P
VVNFX1BTMl9MSUZFQk9PSz15CkNPTkZJR19NT1VTRV9QUzJfVFJBQ0tQT0lOVD15CiMgQ09O
RklHX01PVVNFX1BTMl9FTEFOVEVDSCBpcyBub3Qgc2V0CiMgQ09ORklHX01PVVNFX1BTMl9U
T1VDSEtJVCBpcyBub3Qgc2V0CiMgQ09ORklHX01PVVNFX1NFUklBTCBpcyBub3Qgc2V0CiMg
Q09ORklHX01PVVNFX0FQUExFVE9VQ0ggaXMgbm90IHNldAojIENPTkZJR19NT1VTRV9CQ001
OTc0IGlzIG5vdCBzZXQKIyBDT05GSUdfTU9VU0VfVlNYWFhBQSBpcyBub3Qgc2V0CiMgQ09O
RklHX0lOUFVUX0pPWVNUSUNLIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfVEFCTEVUIGlz
IG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfVE9VQ0hTQ1JFRU4gaXMgbm90IHNldApDT05GSUdf
SU5QVVRfTUlTQz15CiMgQ09ORklHX0lOUFVUX1BDU1BLUiBpcyBub3Qgc2V0CiMgQ09ORklH
X0lOUFVUX1dJU1RST05fQlROUyBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0FUTEFTX0JU
TlMgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9BVElfUkVNT1RFIGlzIG5vdCBzZXQKIyBD
T05GSUdfSU5QVVRfQVRJX1JFTU9URTIgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9QT1dF
Uk1BVEUgaXMgbm90IHNldApDT05GSUdfSU5QVVRfVUlOUFVUPXkKCiMKIyBIYXJkd2FyZSBJ
L08gcG9ydHMKIwpDT05GSUdfU0VSSU89eQpDT05GSUdfU0VSSU9fSTgwNDI9eQpDT05GSUdf
U0VSSU9fU0VSUE9SVD15CiMgQ09ORklHX1NFUklPX0NUODJDNzEwIGlzIG5vdCBzZXQKIyBD
T05GSUdfU0VSSU9fUENJUFMyIGlzIG5vdCBzZXQKQ09ORklHX1NFUklPX0xJQlBTMj15CiMg
Q09ORklHX1NFUklPX1JBVyBpcyBub3Qgc2V0CiMgQ09ORklHX0dBTUVQT1JUIGlzIG5vdCBz
ZXQKCiMKIyBDaGFyYWN0ZXIgZGV2aWNlcwojCkNPTkZJR19WVD15CkNPTkZJR19DT05TT0xF
X1RSQU5TTEFUSU9OUz15CkNPTkZJR19WVF9DT05TT0xFPXkKQ09ORklHX0hXX0NPTlNPTEU9
eQpDT05GSUdfVlRfSFdfQ09OU09MRV9CSU5ESU5HPXkKQ09ORklHX0RFVktNRU09eQojIENP
TkZJR19TRVJJQUxfTk9OU1RBTkRBUkQgaXMgbm90IHNldAoKIwojIFNlcmlhbCBkcml2ZXJz
CiMKQ09ORklHX1NFUklBTF84MjUwPXkKIyBDT05GSUdfU0VSSUFMXzgyNTBfQ09OU09MRSBp
cyBub3Qgc2V0CkNPTkZJR19GSVhfRUFSTFlDT05fTUVNPXkKQ09ORklHX1NFUklBTF84MjUw
X1BDST15CkNPTkZJR19TRVJJQUxfODI1MF9QTlA9eQpDT05GSUdfU0VSSUFMXzgyNTBfTlJf
VUFSVFM9MgpDT05GSUdfU0VSSUFMXzgyNTBfUlVOVElNRV9VQVJUUz0yCiMgQ09ORklHX1NF
UklBTF84MjUwX0VYVEVOREVEIGlzIG5vdCBzZXQKCiMKIyBOb24tODI1MCBzZXJpYWwgcG9y
dCBzdXBwb3J0CiMKQ09ORklHX1NFUklBTF9DT1JFPXkKIyBDT05GSUdfU0VSSUFMX0pTTSBp
cyBub3Qgc2V0CkNPTkZJR19VTklYOThfUFRZUz15CiMgQ09ORklHX0RFVlBUU19NVUxUSVBM
RV9JTlNUQU5DRVMgaXMgbm90IHNldApDT05GSUdfTEVHQUNZX1BUWVM9eQpDT05GSUdfTEVH
QUNZX1BUWV9DT1VOVD0yNTYKQ09ORklHX0lQTUlfSEFORExFUj15CiMgQ09ORklHX0lQTUlf
UEFOSUNfRVZFTlQgaXMgbm90IHNldApDT05GSUdfSVBNSV9ERVZJQ0VfSU5URVJGQUNFPXkK
Q09ORklHX0lQTUlfU0k9eQpDT05GSUdfSVBNSV9XQVRDSERPRz15CkNPTkZJR19JUE1JX1BP
V0VST0ZGPXkKQ09ORklHX0hXX1JBTkRPTT15CkNPTkZJR19IV19SQU5ET01fSU5URUw9eQoj
IENPTkZJR19IV19SQU5ET01fQU1EIGlzIG5vdCBzZXQKIyBDT05GSUdfSFdfUkFORE9NX0dF
T0RFIGlzIG5vdCBzZXQKIyBDT05GSUdfSFdfUkFORE9NX1ZJQSBpcyBub3Qgc2V0CkNPTkZJ
R19OVlJBTT15CiMgQ09ORklHX1IzOTY0IGlzIG5vdCBzZXQKIyBDT05GSUdfQVBQTElDT00g
aXMgbm90IHNldAojIENPTkZJR19NV0FWRSBpcyBub3Qgc2V0CiMgQ09ORklHX1NDeDIwMF9H
UElPIGlzIG5vdCBzZXQKIyBDT05GSUdfUEM4NzM2eF9HUElPIGlzIG5vdCBzZXQKQ09ORklH
X05TQ19HUElPPXkKIyBDT05GSUdfQ1M1NTM1X0dQSU8gaXMgbm90IHNldAojIENPTkZJR19S
QVdfRFJJVkVSIGlzIG5vdCBzZXQKQ09ORklHX0hQRVQ9eQpDT05GSUdfSFBFVF9NTUFQPXkK
Q09ORklHX0hBTkdDSEVDS19USU1FUj15CkNPTkZJR19ERVZQT1JUPXkKQ09ORklHX0kyQz15
CkNPTkZJR19JMkNfQk9BUkRJTkZPPXkKQ09ORklHX0kyQ19DSEFSREVWPXkKQ09ORklHX0ky
Q19IRUxQRVJfQVVUTz15CgojCiMgSTJDIEhhcmR3YXJlIEJ1cyBzdXBwb3J0CiMKCiMKIyBQ
QyBTTUJ1cyBob3N0IGNvbnRyb2xsZXIgZHJpdmVycwojCiMgQ09ORklHX0kyQ19BTEkxNTM1
IGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX0FMSTE1WDMgaXMgbm90IHNldAojIENPTkZJR19J
MkNfQU1ENzU2IGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX0FNRDgxMTEgaXMgbm90IHNldAoj
IENPTkZJR19JMkNfSTgwMSBpcyBub3Qgc2V0CkNPTkZJR19JMkNfSVNDSD15CkNPTkZJR19J
MkNfUElJWDQ9eQojIENPTkZJR19JMkNfTkZPUkNFMiBpcyBub3Qgc2V0CiMgQ09ORklHX0ky
Q19TSVM1NTk1IGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX1NJUzYzMCBpcyBub3Qgc2V0CiMg
Q09ORklHX0kyQ19TSVM5NlggaXMgbm90IHNldAojIENPTkZJR19JMkNfVklBUFJPIGlzIG5v
dCBzZXQKCiMKIyBJMkMgc3lzdGVtIGJ1cyBkcml2ZXJzIChtb3N0bHkgZW1iZWRkZWQgLyBz
eXN0ZW0tb24tY2hpcCkKIwojIENPTkZJR19JMkNfU0lNVEVDIGlzIG5vdCBzZXQKCiMKIyBF
eHRlcm5hbCBJMkMvU01CdXMgYWRhcHRlciBkcml2ZXJzCiMKIyBDT05GSUdfSTJDX1BBUlBP
UlRfTElHSFQgaXMgbm90IHNldAojIENPTkZJR19JMkNfVElOWV9VU0IgaXMgbm90IHNldAoK
IwojIEdyYXBoaWNzIGFkYXB0ZXIgSTJDL0REQyBjaGFubmVsIGRyaXZlcnMKIwojIENPTkZJ
R19JMkNfVk9PRE9PMyBpcyBub3Qgc2V0CgojCiMgT3RoZXIgSTJDL1NNQnVzIGJ1cyBkcml2
ZXJzCiMKIyBDT05GSUdfSTJDX1BDQV9QTEFURk9STSBpcyBub3Qgc2V0CiMgQ09ORklHX1ND
eDIwMF9BQ0IgaXMgbm90IHNldAoKIwojIE1pc2NlbGxhbmVvdXMgSTJDIENoaXAgc3VwcG9y
dAojCiMgQ09ORklHX1BDRjg1NzUgaXMgbm90IHNldAojIENPTkZJR19JMkNfREVCVUdfQ09S
RSBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19ERUJVR19BTEdPIGlzIG5vdCBzZXQKIyBDT05G
SUdfSTJDX0RFQlVHX0JVUyBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19ERUJVR19DSElQIGlz
IG5vdCBzZXQKIyBDT05GSUdfU1BJIGlzIG5vdCBzZXQKQ09ORklHX0FSQ0hfV0FOVF9PUFRJ
T05BTF9HUElPTElCPXkKIyBDT05GSUdfR1BJT0xJQiBpcyBub3Qgc2V0CiMgQ09ORklHX1cx
IGlzIG5vdCBzZXQKQ09ORklHX1BPV0VSX1NVUFBMWT15CiMgQ09ORklHX1BPV0VSX1NVUFBM
WV9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1BEQV9QT1dFUiBpcyBub3Qgc2V0CiMgQ09O
RklHX0JBVFRFUllfRFMyNzYwIGlzIG5vdCBzZXQKIyBDT05GSUdfQkFUVEVSWV9CUTI3eDAw
IGlzIG5vdCBzZXQKQ09ORklHX0hXTU9OPXkKQ09ORklHX0hXTU9OX1ZJRD15CiMgQ09ORklH
X1NFTlNPUlNfQURNMTAyMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQURNMTAyNSBp
cyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQURNOTI0MCBpcyBub3Qgc2V0CiMgQ09ORklH
X1NFTlNPUlNfRFMxNjIxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19GU0NIRVIgaXMg
bm90IHNldAojIENPTkZJR19TRU5TT1JTX0ZTQ1BPUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NF
TlNPUlNfRlNDSE1EIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19HTDUxOFNNIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0VOU09SU19HTDUyMFNNIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VO
U09SU19JQk1BRU0gaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0lCTVBFWCBpcyBub3Qg
c2V0CiMgQ09ORklHX1NFTlNPUlNfSVQ4NyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNf
TE02MyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE03NSBpcyBub3Qgc2V0CiMgQ09O
RklHX1NFTlNPUlNfTE03NyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE03OCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE04MyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNP
UlNfTE04NyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE05MCBpcyBub3Qgc2V0CiMg
Q09ORklHX1NFTlNPUlNfTE05MiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE05MyBp
cyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTUFYMTYxOSBpcyBub3Qgc2V0CiMgQ09ORklH
X1NFTlNPUlNfUEM4NzM2MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfU0lTNTU5NSBp
cyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfU01TQzQ3TTEgaXMgbm90IHNldAojIENPTkZJ
R19TRU5TT1JTX0FEUzc4MjggaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1ZJQTY4NkEg
aXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1ZUODIzMSBpcyBub3Qgc2V0CkNPTkZJR19T
RU5TT1JTX1c4Mzc4MUQ9eQojIENPTkZJR19TRU5TT1JTX1c4MzYyN0hGIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VOU09SU19XODM2MjdFSEYgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JT
X0hEQVBTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MSVMzTFYwMkQgaXMgbm90IHNl
dAojIENPTkZJR19TRU5TT1JTX0FQUExFU01DIGlzIG5vdCBzZXQKIyBDT05GSUdfSFdNT05f
REVCVUdfQ0hJUCBpcyBub3Qgc2V0CkNPTkZJR19USEVSTUFMPXkKQ09ORklHX1RIRVJNQUxf
SFdNT049eQpDT05GSUdfV0FUQ0hET0c9eQojIENPTkZJR19XQVRDSERPR19OT1dBWU9VVCBp
cyBub3Qgc2V0CgojCiMgV2F0Y2hkb2cgRGV2aWNlIERyaXZlcnMKIwojIENPTkZJR19TT0ZU
X1dBVENIRE9HIGlzIG5vdCBzZXQKIyBDT05GSUdfQUNRVUlSRV9XRFQgaXMgbm90IHNldAoj
IENPTkZJR19BRFZBTlRFQ0hfV0RUIGlzIG5vdCBzZXQKQ09ORklHX0FMSU0xNTM1X1dEVD15
CiMgQ09ORklHX0FMSU03MTAxX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NDNTIwX1dEVCBp
cyBub3Qgc2V0CiMgQ09ORklHX0VVUk9URUNIX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX0lC
NzAwX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX0lCTUFTUiBpcyBub3Qgc2V0CiMgQ09ORklH
X1dBRkVSX1dEVCBpcyBub3Qgc2V0CkNPTkZJR19JNjMwMEVTQl9XRFQ9eQojIENPTkZJR19J
VENPX1dEVCBpcyBub3Qgc2V0CkNPTkZJR19JVDg3MTJGX1dEVD15CiMgQ09ORklHX0hQX1dB
VENIRE9HIGlzIG5vdCBzZXQKIyBDT05GSUdfU0MxMjAwX1dEVCBpcyBub3Qgc2V0CkNPTkZJ
R19TQ3gyMDBfV0RUPXkKIyBDT05GSUdfUEM4NzQxM19XRFQgaXMgbm90IHNldAojIENPTkZJ
R182MFhYX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NCQzgzNjBfV0RUIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0JDNzI0MF9XRFQgaXMgbm90IHNldAojIENPTkZJR19DUFU1X1dEVCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NNU0NfU0NIMzExWF9XRFQgaXMgbm90IHNldAojIENPTkZJR19T
TVNDMzdCNzg3X1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX1c4MzYyN0hGX1dEVCBpcyBub3Qg
c2V0CiMgQ09ORklHX1c4MzY5N0hGX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX1c4MzY5N1VH
X1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX1c4Mzg3N0ZfV0RUIGlzIG5vdCBzZXQKIyBDT05G
SUdfVzgzOTc3Rl9XRFQgaXMgbm90IHNldAojIENPTkZJR19NQUNIWl9XRFQgaXMgbm90IHNl
dAojIENPTkZJR19TQkNfRVBYX0MzX1dBVENIRE9HIGlzIG5vdCBzZXQKCiMKIyBQQ0ktYmFz
ZWQgV2F0Y2hkb2cgQ2FyZHMKIwojIENPTkZJR19QQ0lQQ1dBVENIRE9HIGlzIG5vdCBzZXQK
IyBDT05GSUdfV0RUUENJIGlzIG5vdCBzZXQKCiMKIyBVU0ItYmFzZWQgV2F0Y2hkb2cgQ2Fy
ZHMKIwojIENPTkZJR19VU0JQQ1dBVENIRE9HIGlzIG5vdCBzZXQKQ09ORklHX1NTQl9QT1NT
SUJMRT15CgojCiMgU29uaWNzIFNpbGljb24gQmFja3BsYW5lCiMKIyBDT05GSUdfU1NCIGlz
IG5vdCBzZXQKCiMKIyBNdWx0aWZ1bmN0aW9uIGRldmljZSBkcml2ZXJzCiMKIyBDT05GSUdf
TUZEX0NPUkUgaXMgbm90IHNldAojIENPTkZJR19NRkRfU001MDEgaXMgbm90IHNldAojIENP
TkZJR19IVENfUEFTSUMzIGlzIG5vdCBzZXQKIyBDT05GSUdfVFdMNDAzMF9DT1JFIGlzIG5v
dCBzZXQKIyBDT05GSUdfTUZEX1RNSU8gaXMgbm90IHNldAojIENPTkZJR19QTUlDX0RBOTAz
WCBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9XTTg0MDAgaXMgbm90IHNldAojIENPTkZJR19N
RkRfV004MzUwX0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9QQ0Y1MDYzMyBpcyBub3Qg
c2V0CiMgQ09ORklHX1JFR1VMQVRPUiBpcyBub3Qgc2V0CgojCiMgTXVsdGltZWRpYSBkZXZp
Y2VzCiMKCiMKIyBNdWx0aW1lZGlhIGNvcmUgc3VwcG9ydAojCiMgQ09ORklHX1ZJREVPX0RF
ViBpcyBub3Qgc2V0CiMgQ09ORklHX0RWQl9DT1JFIGlzIG5vdCBzZXQKIyBDT05GSUdfVklE
RU9fTUVESUEgaXMgbm90IHNldAoKIwojIE11bHRpbWVkaWEgZHJpdmVycwojCiMgQ09ORklH
X0RBQiBpcyBub3Qgc2V0CgojCiMgR3JhcGhpY3Mgc3VwcG9ydAojCkNPTkZJR19BR1A9eQoj
IENPTkZJR19BR1BfQUxJIGlzIG5vdCBzZXQKIyBDT05GSUdfQUdQX0FUSSBpcyBub3Qgc2V0
CiMgQ09ORklHX0FHUF9BTUQgaXMgbm90IHNldAojIENPTkZJR19BR1BfQU1ENjQgaXMgbm90
IHNldAojIENPTkZJR19BR1BfSU5URUwgaXMgbm90IHNldAojIENPTkZJR19BR1BfTlZJRElB
IGlzIG5vdCBzZXQKIyBDT05GSUdfQUdQX1NJUyBpcyBub3Qgc2V0CkNPTkZJR19BR1BfU1dP
UktTPXkKIyBDT05GSUdfQUdQX1ZJQSBpcyBub3Qgc2V0CiMgQ09ORklHX0FHUF9FRkZJQ0VP
TiBpcyBub3Qgc2V0CiMgQ09ORklHX0RSTSBpcyBub3Qgc2V0CiMgQ09ORklHX1ZHQVNUQVRF
IGlzIG5vdCBzZXQKQ09ORklHX1ZJREVPX09VVFBVVF9DT05UUk9MPXkKQ09ORklHX0ZCPXkK
Q09ORklHX0ZJUk1XQVJFX0VESUQ9eQojIENPTkZJR19GQl9EREMgaXMgbm90IHNldAojIENP
TkZJR19GQl9CT09UX1ZFU0FfU1VQUE9SVCBpcyBub3Qgc2V0CkNPTkZJR19GQl9DRkJfRklM
TFJFQ1Q9eQpDT05GSUdfRkJfQ0ZCX0NPUFlBUkVBPXkKQ09ORklHX0ZCX0NGQl9JTUFHRUJM
SVQ9eQojIENPTkZJR19GQl9DRkJfUkVWX1BJWEVMU19JTl9CWVRFIGlzIG5vdCBzZXQKIyBD
T05GSUdfRkJfU1lTX0ZJTExSRUNUIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfU1lTX0NPUFlB
UkVBIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfU1lTX0lNQUdFQkxJVCBpcyBub3Qgc2V0CiMg
Q09ORklHX0ZCX0ZPUkVJR05fRU5ESUFOIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfU1lTX0ZP
UFMgaXMgbm90IHNldAojIENPTkZJR19GQl9TVkdBTElCIGlzIG5vdCBzZXQKIyBDT05GSUdf
RkJfTUFDTU9ERVMgaXMgbm90IHNldAojIENPTkZJR19GQl9CQUNLTElHSFQgaXMgbm90IHNl
dApDT05GSUdfRkJfTU9ERV9IRUxQRVJTPXkKIyBDT05GSUdfRkJfVElMRUJMSVRUSU5HIGlz
IG5vdCBzZXQKCiMKIyBGcmFtZSBidWZmZXIgaGFyZHdhcmUgZHJpdmVycwojCiMgQ09ORklH
X0ZCX0NJUlJVUyBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1BNMiBpcyBub3Qgc2V0CiMgQ09O
RklHX0ZCX0NZQkVSMjAwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX0FSQyBpcyBub3Qgc2V0
CiMgQ09ORklHX0ZCX0FTSUxJQU5UIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfSU1TVFQgaXMg
bm90IHNldAojIENPTkZJR19GQl9WR0ExNiBpcyBub3Qgc2V0CkNPTkZJR19GQl9VVkVTQT15
CiMgQ09ORklHX0ZCX1ZFU0EgaXMgbm90IHNldAojIENPTkZJR19GQl9ONDExIGlzIG5vdCBz
ZXQKIyBDT05GSUdfRkJfSEdBIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfUzFEMTNYWFggaXMg
bm90IHNldAojIENPTkZJR19GQl9OVklESUEgaXMgbm90IHNldAojIENPTkZJR19GQl9SSVZB
IGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfTEU4MDU3OCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZC
X01BVFJPWCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1JBREVPTiBpcyBub3Qgc2V0CiMgQ09O
RklHX0ZCX0FUWTEyOCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX0FUWSBpcyBub3Qgc2V0CiMg
Q09ORklHX0ZCX1MzIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfU0lTIGlzIG5vdCBzZXQKIyBD
T05GSUdfRkJfVklBIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfTkVPTUFHSUMgaXMgbm90IHNl
dAojIENPTkZJR19GQl9LWVJPIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfM0RGWCBpcyBub3Qg
c2V0CiMgQ09ORklHX0ZCX1ZPT0RPTzEgaXMgbm90IHNldAojIENPTkZJR19GQl9WVDg2MjMg
aXMgbm90IHNldAojIENPTkZJR19GQl9DWUJMQSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1RS
SURFTlQgaXMgbm90IHNldAojIENPTkZJR19GQl9BUksgaXMgbm90IHNldAojIENPTkZJR19G
Ql9DQVJNSU5FIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfVklSVFVBTCBpcyBub3Qgc2V0CiMg
Q09ORklHX0ZCX01FVFJPTk9NRSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX01CODYyWFggaXMg
bm90IHNldApDT05GSUdfQkFDS0xJR0hUX0xDRF9TVVBQT1JUPXkKQ09ORklHX0xDRF9DTEFT
U19ERVZJQ0U9eQojIENPTkZJR19MQ0RfSUxJOTMyMCBpcyBub3Qgc2V0CiMgQ09ORklHX0xD
RF9QTEFURk9STSBpcyBub3Qgc2V0CkNPTkZJR19CQUNLTElHSFRfQ0xBU1NfREVWSUNFPXkK
Q09ORklHX0JBQ0tMSUdIVF9HRU5FUklDPXkKIyBDT05GSUdfQkFDS0xJR0hUX1BST0dFQVIg
aXMgbm90IHNldAojIENPTkZJR19CQUNLTElHSFRfTUJQX05WSURJQSBpcyBub3Qgc2V0CiMg
Q09ORklHX0JBQ0tMSUdIVF9TQUhBUkEgaXMgbm90IHNldAoKIwojIERpc3BsYXkgZGV2aWNl
IHN1cHBvcnQKIwojIENPTkZJR19ESVNQTEFZX1NVUFBPUlQgaXMgbm90IHNldAoKIwojIENv
bnNvbGUgZGlzcGxheSBkcml2ZXIgc3VwcG9ydAojCkNPTkZJR19WR0FfQ09OU09MRT15CkNP
TkZJR19WR0FDT05fU09GVF9TQ1JPTExCQUNLPXkKQ09ORklHX1ZHQUNPTl9TT0ZUX1NDUk9M
TEJBQ0tfU0laRT02NApDT05GSUdfRFVNTVlfQ09OU09MRT15CkNPTkZJR19GUkFNRUJVRkZF
Ul9DT05TT0xFPXkKQ09ORklHX0ZSQU1FQlVGRkVSX0NPTlNPTEVfREVURUNUX1BSSU1BUlk9
eQojIENPTkZJR19GUkFNRUJVRkZFUl9DT05TT0xFX1JPVEFUSU9OIGlzIG5vdCBzZXQKQ09O
RklHX0ZCX0NPTl9ERUNPUj15CkNPTkZJR19GT05UUz15CkNPTkZJR19GT05UXzh4OD15CkNP
TkZJR19GT05UXzh4MTY9eQpDT05GSUdfRk9OVF82eDExPXkKQ09ORklHX0ZPTlRfN3gxND15
CiMgQ09ORklHX0ZPTlRfUEVBUkxfOHg4IGlzIG5vdCBzZXQKIyBDT05GSUdfRk9OVF9BQ09S
Tl84eDggaXMgbm90IHNldAojIENPTkZJR19GT05UX01JTklfNHg2IGlzIG5vdCBzZXQKIyBD
T05GSUdfRk9OVF9TVU44eDE2IGlzIG5vdCBzZXQKIyBDT05GSUdfRk9OVF9TVU4xMngyMiBp
cyBub3Qgc2V0CiMgQ09ORklHX0ZPTlRfMTB4MTggaXMgbm90IHNldApDT05GSUdfTE9HTz15
CkNPTkZJR19MT0dPX0xJTlVYX01PTk89eQpDT05GSUdfTE9HT19MSU5VWF9WR0ExNj15CkNP
TkZJR19MT0dPX0xJTlVYX0NMVVQyMjQ9eQojIENPTkZJR19TT1VORCBpcyBub3Qgc2V0CkNP
TkZJR19ISURfU1VQUE9SVD15CkNPTkZJR19ISUQ9eQpDT05GSUdfSElEX0RFQlVHPXkKQ09O
RklHX0hJRFJBVz15CgojCiMgVVNCIElucHV0IERldmljZXMKIwpDT05GSUdfVVNCX0hJRD15
CkNPTkZJR19ISURfUElEPXkKIyBDT05GSUdfVVNCX0hJRERFViBpcyBub3Qgc2V0CgojCiMg
U3BlY2lhbCBISUQgZHJpdmVycwojCkNPTkZJR19ISURfQ09NUEFUPXkKQ09ORklHX0hJRF9B
NFRFQ0g9eQpDT05GSUdfSElEX0FQUExFPXkKQ09ORklHX0hJRF9CRUxLSU49eQpDT05GSUdf
SElEX0NIRVJSWT15CkNPTkZJR19ISURfQ0hJQ09OWT15CkNPTkZJR19ISURfQ1lQUkVTUz15
CkNPTkZJR19ISURfRVpLRVk9eQpDT05GSUdfSElEX0dZUkFUSU9OPXkKQ09ORklHX0hJRF9M
T0dJVEVDSD15CiMgQ09ORklHX0xPR0lURUNIX0ZGIGlzIG5vdCBzZXQKIyBDT05GSUdfTE9H
SVJVTUJMRVBBRDJfRkYgaXMgbm90IHNldApDT05GSUdfSElEX01JQ1JPU09GVD15CkNPTkZJ
R19ISURfTU9OVEVSRVk9eQpDT05GSUdfSElEX05UUklHPXkKQ09ORklHX0hJRF9QQU5USEVS
TE9SRD15CiMgQ09ORklHX1BBTlRIRVJMT1JEX0ZGIGlzIG5vdCBzZXQKQ09ORklHX0hJRF9Q
RVRBTFlOWD15CkNPTkZJR19ISURfU0FNU1VORz15CkNPTkZJR19ISURfU09OWT15CkNPTkZJ
R19ISURfU1VOUExVUz15CiMgQ09ORklHX0dSRUVOQVNJQV9GRiBpcyBub3Qgc2V0CkNPTkZJ
R19ISURfVE9QU0VFRD15CiMgQ09ORklHX1RIUlVTVE1BU1RFUl9GRiBpcyBub3Qgc2V0CiMg
Q09ORklHX1pFUk9QTFVTX0ZGIGlzIG5vdCBzZXQKQ09ORklHX1VTQl9TVVBQT1JUPXkKQ09O
RklHX1VTQl9BUkNIX0hBU19IQ0Q9eQpDT05GSUdfVVNCX0FSQ0hfSEFTX09IQ0k9eQpDT05G
SUdfVVNCX0FSQ0hfSEFTX0VIQ0k9eQpDT05GSUdfVVNCPXkKIyBDT05GSUdfVVNCX0RFQlVH
IGlzIG5vdCBzZXQKQ09ORklHX1VTQl9BTk5PVU5DRV9ORVdfREVWSUNFUz15CgojCiMgTWlz
Y2VsbGFuZW91cyBVU0Igb3B0aW9ucwojCkNPTkZJR19VU0JfREVWSUNFRlM9eQpDT05GSUdf
VVNCX0RFVklDRV9DTEFTUz15CkNPTkZJR19VU0JfRFlOQU1JQ19NSU5PUlM9eQpDT05GSUdf
VVNCX1NVU1BFTkQ9eQpDT05GSUdfVVNCX01PTj15CkNPTkZJR19VU0JfV1VTQl9DQkFGPXkK
IyBDT05GSUdfVVNCX1dVU0JfQ0JBRl9ERUJVRyBpcyBub3Qgc2V0CgojCiMgVVNCIEhvc3Qg
Q29udHJvbGxlciBEcml2ZXJzCiMKQ09ORklHX1VTQl9DNjdYMDBfSENEPXkKQ09ORklHX1VT
Ql9FSENJX0hDRD15CkNPTkZJR19VU0JfRUhDSV9ST09UX0hVQl9UVD15CkNPTkZJR19VU0Jf
T1hVMjEwSFBfSENEPXkKQ09ORklHX1VTQl9JU1AxMTZYX0hDRD15CkNPTkZJR19VU0JfT0hD
SV9IQ0Q9eQojIENPTkZJR19VU0JfT0hDSV9CSUdfRU5ESUFOX0RFU0MgaXMgbm90IHNldAoj
IENPTkZJR19VU0JfT0hDSV9CSUdfRU5ESUFOX01NSU8gaXMgbm90IHNldApDT05GSUdfVVNC
X09IQ0lfTElUVExFX0VORElBTj15CkNPTkZJR19VU0JfVUhDSV9IQ0Q9eQpDT05GSUdfVVNC
X1NMODExX0hDRD15CkNPTkZJR19VU0JfUjhBNjY1OTdfSENEPXkKCiMKIyBVU0IgRGV2aWNl
IENsYXNzIGRyaXZlcnMKIwojIENPTkZJR19VU0JfQUNNIGlzIG5vdCBzZXQKQ09ORklHX1VT
Ql9QUklOVEVSPXkKQ09ORklHX1VTQl9XRE09eQojIENPTkZJR19VU0JfVE1DIGlzIG5vdCBz
ZXQKCiMKIyBOT1RFOiBVU0JfU1RPUkFHRSBkZXBlbmRzIG9uIFNDU0kgYnV0IEJMS19ERVZf
U0QgbWF5IGFsc28gYmUgbmVlZGVkOwojCgojCiMgc2VlIFVTQl9TVE9SQUdFIEhlbHAgZm9y
IG1vcmUgaW5mb3JtYXRpb24KIwpDT05GSUdfVVNCX1NUT1JBR0U9eQpDT05GSUdfVVNCX1NU
T1JBR0VfREVCVUc9eQpDT05GSUdfVVNCX1NUT1JBR0VfREFUQUZBQj15CkNPTkZJR19VU0Jf
U1RPUkFHRV9GUkVFQ09NPXkKQ09ORklHX1VTQl9TVE9SQUdFX0lTRDIwMD15CkNPTkZJR19V
U0JfU1RPUkFHRV9VU0JBVD15CkNPTkZJR19VU0JfU1RPUkFHRV9TRERSMDk9eQpDT05GSUdf
VVNCX1NUT1JBR0VfU0REUjU1PXkKQ09ORklHX1VTQl9TVE9SQUdFX0pVTVBTSE9UPXkKQ09O
RklHX1VTQl9TVE9SQUdFX0FMQVVEQT15CkNPTkZJR19VU0JfU1RPUkFHRV9PTkVUT1VDSD15
CkNPTkZJR19VU0JfU1RPUkFHRV9LQVJNQT15CkNPTkZJR19VU0JfU1RPUkFHRV9DWVBSRVNT
X0FUQUNCPXkKQ09ORklHX1VTQl9MSUJVU1VBTD15CgojCiMgVVNCIEltYWdpbmcgZGV2aWNl
cwojCiMgQ09ORklHX1VTQl9NREM4MDAgaXMgbm90IHNldAojIENPTkZJR19VU0JfTUlDUk9U
RUsgaXMgbm90IHNldAoKIwojIFVTQiBwb3J0IGRyaXZlcnMKIwojIENPTkZJR19VU0JfU0VS
SUFMIGlzIG5vdCBzZXQKCiMKIyBVU0IgTWlzY2VsbGFuZW91cyBkcml2ZXJzCiMKIyBDT05G
SUdfVVNCX0VNSTYyIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0VNSTI2IGlzIG5vdCBzZXQK
IyBDT05GSUdfVVNCX0FEVVRVWCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TRVZTRUcgaXMg
bm90IHNldAojIENPTkZJR19VU0JfUklPNTAwIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0xF
R09UT1dFUiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9MQ0QgaXMgbm90IHNldAojIENPTkZJ
R19VU0JfQkVSUllfQ0hBUkdFIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0xFRCBpcyBub3Qg
c2V0CiMgQ09ORklHX1VTQl9DWVBSRVNTX0NZN0M2MyBpcyBub3Qgc2V0CiMgQ09ORklHX1VT
Ql9DWVRIRVJNIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1BISURHRVQgaXMgbm90IHNldAoj
IENPTkZJR19VU0JfSURNT1VTRSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9GVERJX0VMQU4g
aXMgbm90IHNldAojIENPTkZJR19VU0JfQVBQTEVESVNQTEFZIGlzIG5vdCBzZXQKIyBDT05G
SUdfVVNCX1NJU1VTQlZHQSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9MRCBpcyBub3Qgc2V0
CiMgQ09ORklHX1VTQl9UUkFOQ0VWSUJSQVRPUiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9J
T1dBUlJJT1IgaXMgbm90IHNldAojIENPTkZJR19VU0JfVEVTVCBpcyBub3Qgc2V0CiMgQ09O
RklHX1VTQl9JU0lHSFRGVyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9WU1QgaXMgbm90IHNl
dAojIENPTkZJR19VU0JfR0FER0VUIGlzIG5vdCBzZXQKCiMKIyBPVEcgYW5kIHJlbGF0ZWQg
aW5mcmFzdHJ1Y3R1cmUKIwojIENPTkZJR19NTUMgaXMgbm90IHNldAojIENPTkZJR19NRU1T
VElDSyBpcyBub3Qgc2V0CiMgQ09ORklHX05FV19MRURTIGlzIG5vdCBzZXQKIyBDT05GSUdf
QUNDRVNTSUJJTElUWSBpcyBub3Qgc2V0CiMgQ09ORklHX0lORklOSUJBTkQgaXMgbm90IHNl
dApDT05GSUdfUlRDX0xJQj15CkNPTkZJR19SVENfQ0xBU1M9eQpDT05GSUdfUlRDX0hDVE9T
WVM9eQpDT05GSUdfUlRDX0hDVE9TWVNfREVWSUNFPSJ5IgpDT05GSUdfUlRDX0RFQlVHPXkK
CiMKIyBSVEMgaW50ZXJmYWNlcwojCkNPTkZJR19SVENfSU5URl9TWVNGUz15CkNPTkZJR19S
VENfSU5URl9QUk9DPXkKQ09ORklHX1JUQ19JTlRGX0RFVj15CkNPTkZJR19SVENfSU5URl9E
RVZfVUlFX0VNVUw9eQojIENPTkZJR19SVENfRFJWX1RFU1QgaXMgbm90IHNldAoKIwojIEky
QyBSVEMgZHJpdmVycwojCkNPTkZJR19SVENfRFJWX0RTMTMwNz15CkNPTkZJR19SVENfRFJW
X0RTMTM3ND15CkNPTkZJR19SVENfRFJWX0RTMTY3Mj15CkNPTkZJR19SVENfRFJWX01BWDY5
MDA9eQpDT05GSUdfUlRDX0RSVl9SUzVDMzcyPXkKQ09ORklHX1JUQ19EUlZfSVNMMTIwOD15
CkNPTkZJR19SVENfRFJWX1gxMjA1PXkKQ09ORklHX1JUQ19EUlZfUENGODU2Mz15CkNPTkZJ
R19SVENfRFJWX1BDRjg1ODM9eQpDT05GSUdfUlRDX0RSVl9NNDFUODA9eQpDT05GSUdfUlRD
X0RSVl9NNDFUODBfV0RUPXkKQ09ORklHX1JUQ19EUlZfUzM1MzkwQT15CkNPTkZJR19SVENf
RFJWX0ZNMzEzMD15CkNPTkZJR19SVENfRFJWX1JYODU4MT15CgojCiMgU1BJIFJUQyBkcml2
ZXJzCiMKCiMKIyBQbGF0Zm9ybSBSVEMgZHJpdmVycwojCkNPTkZJR19SVENfRFJWX0NNT1M9
eQpDT05GSUdfUlRDX0RSVl9EUzEyODY9eQpDT05GSUdfUlRDX0RSVl9EUzE1MTE9eQpDT05G
SUdfUlRDX0RSVl9EUzE1NTM9eQpDT05GSUdfUlRDX0RSVl9EUzE3NDI9eQpDT05GSUdfUlRD
X0RSVl9TVEsxN1RBOD15CkNPTkZJR19SVENfRFJWX000OFQ4Nj15CkNPTkZJR19SVENfRFJW
X000OFQzNT15CkNPTkZJR19SVENfRFJWX000OFQ1OT15CkNPTkZJR19SVENfRFJWX0JRNDgw
Mj15CkNPTkZJR19SVENfRFJWX1YzMDIwPXkKCiMKIyBvbi1DUFUgUlRDIGRyaXZlcnMKIwpD
T05GSUdfRE1BREVWSUNFUz15CgojCiMgRE1BIERldmljZXMKIwpDT05GSUdfSU5URUxfSU9B
VERNQT15CkNPTkZJR19ETUFfRU5HSU5FPXkKCiMKIyBETUEgQ2xpZW50cwojCkNPTkZJR19O
RVRfRE1BPXkKIyBDT05GSUdfRE1BVEVTVCBpcyBub3Qgc2V0CkNPTkZJR19EQ0E9eQojIENP
TkZJR19VSU8gaXMgbm90IHNldAojIENPTkZJR19TVEFHSU5HIGlzIG5vdCBzZXQKIyBDT05G
SUdfWDg2X1BMQVRGT1JNX0RFVklDRVMgaXMgbm90IHNldAoKIwojIEZpcm13YXJlIERyaXZl
cnMKIwpDT05GSUdfRUREPXkKQ09ORklHX0VERF9PRkY9eQpDT05GSUdfRklSTVdBUkVfTUVN
TUFQPXkKIyBDT05GSUdfREVMTF9SQlUgaXMgbm90IHNldAojIENPTkZJR19EQ0RCQVMgaXMg
bm90IHNldApDT05GSUdfRE1JSUQ9eQojIENPTkZJR19JU0NTSV9JQkZUX0ZJTkQgaXMgbm90
IHNldAoKIwojIEZpbGUgc3lzdGVtcwojCkNPTkZJR19FWFQyX0ZTPXkKQ09ORklHX0VYVDJf
RlNfWEFUVFI9eQpDT05GSUdfRVhUMl9GU19QT1NJWF9BQ0w9eQpDT05GSUdfRVhUMl9GU19T
RUNVUklUWT15CiMgQ09ORklHX0VYVDJfRlNfWElQIGlzIG5vdCBzZXQKQ09ORklHX0VYVDNf
RlM9eQpDT05GSUdfRVhUM19GU19YQVRUUj15CkNPTkZJR19FWFQzX0ZTX1BPU0lYX0FDTD15
CkNPTkZJR19FWFQzX0ZTX1NFQ1VSSVRZPXkKQ09ORklHX0VYVDRfRlM9eQpDT05GSUdfRVhU
NERFVl9DT01QQVQ9eQpDT05GSUdfRVhUNF9GU19YQVRUUj15CkNPTkZJR19FWFQ0X0ZTX1BP
U0lYX0FDTD15CkNPTkZJR19FWFQ0X0ZTX1NFQ1VSSVRZPXkKQ09ORklHX0pCRD15CiMgQ09O
RklHX0pCRF9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19KQkQyPXkKIyBDT05GSUdfSkJEMl9E
RUJVRyBpcyBub3Qgc2V0CkNPTkZJR19GU19NQkNBQ0hFPXkKQ09ORklHX1JFSVNFUkZTX0ZT
PXkKIyBDT05GSUdfUkVJU0VSRlNfQ0hFQ0sgaXMgbm90IHNldApDT05GSUdfUkVJU0VSRlNf
UFJPQ19JTkZPPXkKIyBDT05GSUdfUkVJU0VSRlNfRlNfWEFUVFIgaXMgbm90IHNldAojIENP
TkZJR19KRlNfRlMgaXMgbm90IHNldApDT05GSUdfRlNfUE9TSVhfQUNMPXkKQ09ORklHX0ZJ
TEVfTE9DS0lORz15CiMgQ09ORklHX1hGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX09DRlMy
X0ZTIGlzIG5vdCBzZXQKQ09ORklHX0ROT1RJRlk9eQpDT05GSUdfSU5PVElGWT15CkNPTkZJ
R19JTk9USUZZX1VTRVI9eQpDT05GSUdfUVVPVEE9eQpDT05GSUdfUVVPVEFfTkVUTElOS19J
TlRFUkZBQ0U9eQojIENPTkZJR19QUklOVF9RVU9UQV9XQVJOSU5HIGlzIG5vdCBzZXQKQ09O
RklHX1FVT1RBX1RSRUU9eQojIENPTkZJR19RRk1UX1YxIGlzIG5vdCBzZXQKQ09ORklHX1FG
TVRfVjI9eQpDT05GSUdfUVVPVEFDVEw9eQojIENPTkZJR19BVVRPRlNfRlMgaXMgbm90IHNl
dApDT05GSUdfQVVUT0ZTNF9GUz15CkNPTkZJR19GVVNFX0ZTPXkKQ09ORklHX0dFTkVSSUNf
QUNMPXkKCiMKIyBDRC1ST00vRFZEIEZpbGVzeXN0ZW1zCiMKQ09ORklHX0lTTzk2NjBfRlM9
eQpDT05GSUdfSk9MSUVUPXkKQ09ORklHX1pJU09GUz15CkNPTkZJR19VREZfRlM9eQpDT05G
SUdfVURGX05MUz15CgojCiMgRE9TL0ZBVC9OVCBGaWxlc3lzdGVtcwojCkNPTkZJR19GQVRf
RlM9eQpDT05GSUdfTVNET1NfRlM9eQpDT05GSUdfVkZBVF9GUz15CkNPTkZJR19GQVRfREVG
QVVMVF9DT0RFUEFHRT04NjYKQ09ORklHX0ZBVF9ERUZBVUxUX0lPQ0hBUlNFVD0iY3AxMjUx
IgpDT05GSUdfTlRGU19GUz15CiMgQ09ORklHX05URlNfREVCVUcgaXMgbm90IHNldApDT05G
SUdfTlRGU19SVz15CgojCiMgUHNldWRvIGZpbGVzeXN0ZW1zCiMKQ09ORklHX1BST0NfRlM9
eQpDT05GSUdfUFJPQ19LQ09SRT15CkNPTkZJR19QUk9DX1NZU0NUTD15CkNPTkZJR19QUk9D
X1BBR0VfTU9OSVRPUj15CkNPTkZJR19TWVNGUz15CkNPTkZJR19UTVBGUz15CkNPTkZJR19U
TVBGU19QT1NJWF9BQ0w9eQpDT05GSUdfSFVHRVRMQkZTPXkKQ09ORklHX0hVR0VUTEJfUEFH
RT15CkNPTkZJR19DT05GSUdGU19GUz15CkNPTkZJR19NSVNDX0ZJTEVTWVNURU1TPXkKIyBD
T05GSUdfSEZTUExVU19GUyBpcyBub3Qgc2V0CkNPTkZJR19DUkFNRlM9eQpDT05GSUdfU1FV
QVNIRlM9eQojIENPTkZJR19TUVVBU0hGU19FTUJFRERFRCBpcyBub3Qgc2V0CkNPTkZJR19T
UVVBU0hGU19GUkFHTUVOVF9DQUNIRV9TSVpFPTMKIyBDT05GSUdfVlhGU19GUyBpcyBub3Qg
c2V0CiMgQ09ORklHX01JTklYX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfT01GU19GUyBpcyBu
b3Qgc2V0CiMgQ09ORklHX0hQRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19RTlg0RlNfRlMg
aXMgbm90IHNldApDT05GSUdfUk9NRlNfRlM9eQojIENPTkZJR19TWVNWX0ZTIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVUZTX0ZTIGlzIG5vdCBzZXQKQ09ORklHX05FVFdPUktfRklMRVNZU1RF
TVM9eQojIENPTkZJR19ORlNfRlMgaXMgbm90IHNldAojIENPTkZJR19ORlNEIGlzIG5vdCBz
ZXQKQ09ORklHX1NNQl9GUz15CkNPTkZJR19TTUJfTkxTX0RFRkFVTFQ9eQpDT05GSUdfU01C
X05MU19SRU1PVEU9ImNwMTI1MSIKQ09ORklHX0NJRlM9eQpDT05GSUdfQ0lGU19TVEFUUz15
CkNPTkZJR19DSUZTX1NUQVRTMj15CkNPTkZJR19DSUZTX1dFQUtfUFdfSEFTSD15CiMgQ09O
RklHX0NJRlNfVVBDQUxMIGlzIG5vdCBzZXQKQ09ORklHX0NJRlNfWEFUVFI9eQpDT05GSUdf
Q0lGU19QT1NJWD15CiMgQ09ORklHX0NJRlNfREVCVUcyIGlzIG5vdCBzZXQKIyBDT05GSUdf
TkNQX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfQ09EQV9GUyBpcyBub3Qgc2V0CgojCiMgUGFy
dGl0aW9uIFR5cGVzCiMKIyBDT05GSUdfUEFSVElUSU9OX0FEVkFOQ0VEIGlzIG5vdCBzZXQK
Q09ORklHX01TRE9TX1BBUlRJVElPTj15CkNPTkZJR19OTFM9eQpDT05GSUdfTkxTX0RFRkFV
TFQ9ImNwMTI1MSIKIyBDT05GSUdfTkxTX0NPREVQQUdFXzQzNyBpcyBub3Qgc2V0CiMgQ09O
RklHX05MU19DT0RFUEFHRV83MzcgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0Vf
Nzc1IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg1MCBpcyBub3Qgc2V0CiMg
Q09ORklHX05MU19DT0RFUEFHRV84NTIgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBB
R0VfODU1IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg1NyBpcyBub3Qgc2V0
CiMgQ09ORklHX05MU19DT0RFUEFHRV84NjAgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09E
RVBBR0VfODYxIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2MiBpcyBub3Qg
c2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV84NjMgaXMgbm90IHNldAojIENPTkZJR19OTFNf
Q09ERVBBR0VfODY0IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2NSBpcyBu
b3Qgc2V0CkNPTkZJR19OTFNfQ09ERVBBR0VfODY2PXkKIyBDT05GSUdfTkxTX0NPREVQQUdF
Xzg2OSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV85MzYgaXMgbm90IHNldAoj
IENPTkZJR19OTFNfQ09ERVBBR0VfOTUwIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQ
QUdFXzkzMiBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV85NDkgaXMgbm90IHNl
dAojIENPTkZJR19OTFNfQ09ERVBBR0VfODc0IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0lT
Tzg4NTlfOCBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV8xMjUwIGlzIG5vdCBz
ZXQKQ09ORklHX05MU19DT0RFUEFHRV8xMjUxPXkKIyBDT05GSUdfTkxTX0FTQ0lJIGlzIG5v
dCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfMSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19J
U084ODU5XzIgaXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV8zIGlzIG5vdCBzZXQK
IyBDT05GSUdfTkxTX0lTTzg4NTlfNCBpcyBub3Qgc2V0CkNPTkZJR19OTFNfSVNPODg1OV81
PXkKIyBDT05GSUdfTkxTX0lTTzg4NTlfNiBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084
ODU5XzcgaXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV85IGlzIG5vdCBzZXQKIyBD
T05GSUdfTkxTX0lTTzg4NTlfMTMgaXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV8x
NCBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084ODU5XzE1IGlzIG5vdCBzZXQKQ09ORklH
X05MU19LT0k4X1I9eQojIENPTkZJR19OTFNfS09JOF9VIGlzIG5vdCBzZXQKQ09ORklHX05M
U19VVEY4PXkKCiMKIyBLZXJuZWwgaGFja2luZwojCkNPTkZJR19UUkFDRV9JUlFGTEFHU19T
VVBQT1JUPXkKQ09ORklHX1BSSU5US19USU1FPXkKIyBDT05GSUdfRU5BQkxFX1dBUk5fREVQ
UkVDQVRFRCBpcyBub3Qgc2V0CiMgQ09ORklHX0VOQUJMRV9NVVNUX0NIRUNLIGlzIG5vdCBz
ZXQKQ09ORklHX0ZSQU1FX1dBUk49MTAyNApDT05GSUdfTUFHSUNfU1lTUlE9eQojIENPTkZJ
R19VTlVTRURfU1lNQk9MUyBpcyBub3Qgc2V0CkNPTkZJR19ERUJVR19GUz15CiMgQ09ORklH
X0hFQURFUlNfQ0hFQ0sgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19LRVJORUwgaXMgbm90
IHNldApDT05GSUdfU0NIRURfREVCVUc9eQpDT05GSUdfU0NIRURTVEFUUz15CiMgQ09ORklH
X1NMVUJfREVCVUdfT04gaXMgbm90IHNldAojIENPTkZJR19TTFVCX1NUQVRTIGlzIG5vdCBz
ZXQKQ09ORklHX1NUQUNLVFJBQ0U9eQpDT05GSUdfREVCVUdfQlVHVkVSQk9TRT15CkNPTkZJ
R19ERUJVR19NRU1PUllfSU5JVD15CkNPTkZJR19BUkNIX1dBTlRfRlJBTUVfUE9JTlRFUlM9
eQpDT05GSUdfRlJBTUVfUE9JTlRFUj15CkNPTkZJR19SQ1VfQ1BVX1NUQUxMX0RFVEVDVE9S
PXkKQ09ORklHX0xBVEVOQ1lUT1A9eQpDT05GSUdfU1lTQ1RMX1NZU0NBTExfQ0hFQ0s9eQpD
T05GSUdfVVNFUl9TVEFDS1RSQUNFX1NVUFBPUlQ9eQpDT05GSUdfSEFWRV9GVU5DVElPTl9U
UkFDRVI9eQpDT05GSUdfSEFWRV9GVU5DVElPTl9HUkFQSF9UUkFDRVI9eQpDT05GSUdfSEFW
RV9GVU5DVElPTl9UUkFDRV9NQ09VTlRfVEVTVD15CkNPTkZJR19IQVZFX0RZTkFNSUNfRlRS
QUNFPXkKQ09ORklHX0hBVkVfRlRSQUNFX01DT1VOVF9SRUNPUkQ9eQoKIwojIFRyYWNlcnMK
IwojIENPTkZJR19TWVNQUk9GX1RSQUNFUiBpcyBub3Qgc2V0CiMgQ09ORklHX1BST1ZJREVf
T0hDSTEzOTRfRE1BX0lOSVQgaXMgbm90IHNldApDT05GSUdfRFlOQU1JQ19QUklOVEtfREVC
VUc9eQojIENPTkZJR19TQU1QTEVTIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfQVJDSF9LR0RC
PXkKQ09ORklHX1NUUklDVF9ERVZNRU09eQpDT05GSUdfWDg2X1ZFUkJPU0VfQk9PVFVQPXkK
Q09ORklHX0VBUkxZX1BSSU5USz15CiMgQ09ORklHX0VBUkxZX1BSSU5US19EQkdQIGlzIG5v
dCBzZXQKIyBDT05GSUdfNEtTVEFDS1MgaXMgbm90IHNldApDT05GSUdfRE9VQkxFRkFVTFQ9
eQpDT05GSUdfSEFWRV9NTUlPVFJBQ0VfU1VQUE9SVD15CkNPTkZJR19JT19ERUxBWV9UWVBF
XzBYODA9MApDT05GSUdfSU9fREVMQVlfVFlQRV8wWEVEPTEKQ09ORklHX0lPX0RFTEFZX1RZ
UEVfVURFTEFZPTIKQ09ORklHX0lPX0RFTEFZX1RZUEVfTk9ORT0zCkNPTkZJR19JT19ERUxB
WV8wWDgwPXkKIyBDT05GSUdfSU9fREVMQVlfMFhFRCBpcyBub3Qgc2V0CiMgQ09ORklHX0lP
X0RFTEFZX1VERUxBWSBpcyBub3Qgc2V0CiMgQ09ORklHX0lPX0RFTEFZX05PTkUgaXMgbm90
IHNldApDT05GSUdfREVGQVVMVF9JT19ERUxBWV9UWVBFPTAKQ09ORklHX09QVElNSVpFX0lO
TElOSU5HPXkKCiMKIyBTZWN1cml0eSBvcHRpb25zCiMKQ09ORklHX0tFWVM9eQojIENPTkZJ
R19LRVlTX0RFQlVHX1BST0NfS0VZUyBpcyBub3Qgc2V0CkNPTkZJR19TRUNVUklUWT15CiMg
Q09ORklHX1NFQ1VSSVRZRlMgaXMgbm90IHNldApDT05GSUdfU0VDVVJJVFlfTkVUV09SSz15
CiMgQ09ORklHX1NFQ1VSSVRZX1BBVEggaXMgbm90IHNldAojIENPTkZJR19TRUNVUklUWV9G
SUxFX0NBUEFCSUxJVElFUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFQ1VSSVRZX1JPT1RQTFVH
IGlzIG5vdCBzZXQKQ09ORklHX1NFQ1VSSVRZX0RFRkFVTFRfTU1BUF9NSU5fQUREUj0wCkNP
TkZJR19DUllQVE89eQoKIwojIENyeXB0byBjb3JlIG9yIGhlbHBlcgojCkNPTkZJR19DUllQ
VE9fRklQUz15CkNPTkZJR19DUllQVE9fQUxHQVBJPXkKQ09ORklHX0NSWVBUT19BTEdBUEky
PXkKQ09ORklHX0NSWVBUT19BRUFEPXkKQ09ORklHX0NSWVBUT19BRUFEMj15CkNPTkZJR19D
UllQVE9fQkxLQ0lQSEVSPXkKQ09ORklHX0NSWVBUT19CTEtDSVBIRVIyPXkKQ09ORklHX0NS
WVBUT19IQVNIPXkKQ09ORklHX0NSWVBUT19IQVNIMj15CkNPTkZJR19DUllQVE9fUk5HPXkK
Q09ORklHX0NSWVBUT19STkcyPXkKQ09ORklHX0NSWVBUT19NQU5BR0VSPXkKQ09ORklHX0NS
WVBUT19NQU5BR0VSMj15CkNPTkZJR19DUllQVE9fR0YxMjhNVUw9eQpDT05GSUdfQ1JZUFRP
X05VTEw9eQpDT05GSUdfQ1JZUFRPX0NSWVBURD15CkNPTkZJR19DUllQVE9fQVVUSEVOQz15
CgojCiMgQXV0aGVudGljYXRlZCBFbmNyeXB0aW9uIHdpdGggQXNzb2NpYXRlZCBEYXRhCiMK
Q09ORklHX0NSWVBUT19DQ009eQpDT05GSUdfQ1JZUFRPX0dDTT15CkNPTkZJR19DUllQVE9f
U0VRSVY9eQoKIwojIEJsb2NrIG1vZGVzCiMKQ09ORklHX0NSWVBUT19DQkM9eQpDT05GSUdf
Q1JZUFRPX0NUUj15CkNPTkZJR19DUllQVE9fQ1RTPXkKQ09ORklHX0NSWVBUT19FQ0I9eQpD
T05GSUdfQ1JZUFRPX1BDQkM9eQoKIwojIEhhc2ggbW9kZXMKIwpDT05GSUdfQ1JZUFRPX0hN
QUM9eQoKIwojIERpZ2VzdAojCkNPTkZJR19DUllQVE9fQ1JDMzJDPXkKQ09ORklHX0NSWVBU
T19DUkMzMkNfSU5URUw9eQpDT05GSUdfQ1JZUFRPX01END15CkNPTkZJR19DUllQVE9fTUQ1
PXkKQ09ORklHX0NSWVBUT19NSUNIQUVMX01JQz15CkNPTkZJR19DUllQVE9fUk1EMTI4PXkK
Q09ORklHX0NSWVBUT19STUQxNjA9eQpDT05GSUdfQ1JZUFRPX1JNRDI1Nj15CkNPTkZJR19D
UllQVE9fUk1EMzIwPXkKQ09ORklHX0NSWVBUT19TSEExPXkKQ09ORklHX0NSWVBUT19TSEEy
NTY9eQpDT05GSUdfQ1JZUFRPX1NIQTUxMj15CkNPTkZJR19DUllQVE9fVEdSMTkyPXkKQ09O
RklHX0NSWVBUT19XUDUxMj15CgojCiMgQ2lwaGVycwojCkNPTkZJR19DUllQVE9fQUVTPXkK
Q09ORklHX0NSWVBUT19BRVNfNTg2PXkKQ09ORklHX0NSWVBUT19BTlVCSVM9eQpDT05GSUdf
Q1JZUFRPX0FSQzQ9eQpDT05GSUdfQ1JZUFRPX0JMT1dGSVNIPXkKQ09ORklHX0NSWVBUT19D
QU1FTExJQT15CkNPTkZJR19DUllQVE9fQ0FTVDU9eQpDT05GSUdfQ1JZUFRPX0NBU1Q2PXkK
Q09ORklHX0NSWVBUT19ERVM9eQpDT05GSUdfQ1JZUFRPX0ZDUllQVD15CkNPTkZJR19DUllQ
VE9fS0hBWkFEPXkKQ09ORklHX0NSWVBUT19TRUVEPXkKQ09ORklHX0NSWVBUT19TRVJQRU5U
PXkKQ09ORklHX0NSWVBUT19URUE9eQpDT05GSUdfQ1JZUFRPX1RXT0ZJU0g9eQpDT05GSUdf
Q1JZUFRPX1RXT0ZJU0hfQ09NTU9OPXkKQ09ORklHX0NSWVBUT19UV09GSVNIXzU4Nj15Cgoj
CiMgQ29tcHJlc3Npb24KIwpDT05GSUdfQ1JZUFRPX0RFRkxBVEU9eQpDT05GSUdfQ1JZUFRP
X0xaTz15CgojCiMgUmFuZG9tIE51bWJlciBHZW5lcmF0aW9uCiMKQ09ORklHX0NSWVBUT19B
TlNJX0NQUk5HPXkKIyBDT05GSUdfQ1JZUFRPX0hXIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVf
S1ZNPXkKQ09ORklHX0hBVkVfS1ZNX0lSUUNISVA9eQojIENPTkZJR19WSVJUVUFMSVpBVElP
TiBpcyBub3Qgc2V0CgojCiMgTGlicmFyeSByb3V0aW5lcwojCkNPTkZJR19CSVRSRVZFUlNF
PXkKQ09ORklHX0dFTkVSSUNfRklORF9GSVJTVF9CSVQ9eQpDT05GSUdfR0VORVJJQ19GSU5E
X05FWFRfQklUPXkKQ09ORklHX0dFTkVSSUNfRklORF9MQVNUX0JJVD15CkNPTkZJR19DUkNf
Q0NJVFQ9eQpDT05GSUdfQ1JDMTY9eQpDT05GSUdfQ1JDX1QxMERJRj15CkNPTkZJR19DUkNf
SVRVX1Q9eQpDT05GSUdfQ1JDMzI9eQpDT05GSUdfQ1JDNz15CkNPTkZJR19MSUJDUkMzMkM9
eQpDT05GSUdfWkxJQl9JTkZMQVRFPXkKQ09ORklHX1pMSUJfREVGTEFURT15CkNPTkZJR19M
Wk9fQ09NUFJFU1M9eQpDT05GSUdfTFpPX0RFQ09NUFJFU1M9eQpDT05GSUdfVEVYVFNFQVJD
SD15CkNPTkZJR19URVhUU0VBUkNIX0tNUD15CkNPTkZJR19URVhUU0VBUkNIX0JNPXkKQ09O
RklHX1RFWFRTRUFSQ0hfRlNNPXkKQ09ORklHX1BMSVNUPXkKQ09ORklHX0hBU19JT01FTT15
CkNPTkZJR19IQVNfSU9QT1JUPXkKQ09ORklHX0hBU19ETUE9eQo=
------------261781911372B433
Content-Type: application/octet-stream;
 name=".config-2.6.30.4"
Content-transfer-encoding: base64
Content-Disposition: attachment;
 filename=".config-2.6.30.4"

IwojIEF1dG9tYXRpY2FsbHkgZ2VuZXJhdGVkIG1ha2UgY29uZmlnOiBkb24ndCBlZGl0CiMg
TGludXgga2VybmVsIHZlcnNpb246IDIuNi4zMC1nZW50b28tcjQKIyBTYXQgQXVnICAxIDE2
OjA4OjM3IDIwMDkKIwojIENPTkZJR182NEJJVCBpcyBub3Qgc2V0CkNPTkZJR19YODZfMzI9
eQojIENPTkZJR19YODZfNjQgaXMgbm90IHNldApDT05GSUdfWDg2PXkKQ09ORklHX0FSQ0hf
REVGQ09ORklHPSJhcmNoL3g4Ni9jb25maWdzL2kzODZfZGVmY29uZmlnIgpDT05GSUdfR0VO
RVJJQ19USU1FPXkKQ09ORklHX0dFTkVSSUNfQ01PU19VUERBVEU9eQpDT05GSUdfQ0xPQ0tT
T1VSQ0VfV0FUQ0hET0c9eQpDT05GSUdfR0VORVJJQ19DTE9DS0VWRU5UUz15CkNPTkZJR19H
RU5FUklDX0NMT0NLRVZFTlRTX0JST0FEQ0FTVD15CkNPTkZJR19MT0NLREVQX1NVUFBPUlQ9
eQpDT05GSUdfU1RBQ0tUUkFDRV9TVVBQT1JUPXkKQ09ORklHX0hBVkVfTEFURU5DWVRPUF9T
VVBQT1JUPXkKQ09ORklHX0ZBU1RfQ01QWENIR19MT0NBTD15CkNPTkZJR19NTVU9eQpDT05G
SUdfWk9ORV9ETUE9eQpDT05GSUdfR0VORVJJQ19JU0FfRE1BPXkKQ09ORklHX0dFTkVSSUNf
SU9NQVA9eQpDT05GSUdfR0VORVJJQ19CVUc9eQpDT05GSUdfR0VORVJJQ19IV0VJR0hUPXkK
Q09ORklHX0FSQ0hfTUFZX0hBVkVfUENfRkRDPXkKIyBDT05GSUdfUldTRU1fR0VORVJJQ19T
UElOTE9DSyBpcyBub3Qgc2V0CkNPTkZJR19SV1NFTV9YQ0hHQUREX0FMR09SSVRITT15CkNP
TkZJR19BUkNIX0hBU19DUFVfSURMRV9XQUlUPXkKQ09ORklHX0dFTkVSSUNfQ0FMSUJSQVRF
X0RFTEFZPXkKIyBDT05GSUdfR0VORVJJQ19USU1FX1ZTWVNDQUxMIGlzIG5vdCBzZXQKQ09O
RklHX0FSQ0hfSEFTX0NQVV9SRUxBWD15CkNPTkZJR19BUkNIX0hBU19ERUZBVUxUX0lETEU9
eQpDT05GSUdfQVJDSF9IQVNfQ0FDSEVfTElORV9TSVpFPXkKQ09ORklHX0hBVkVfU0VUVVBf
UEVSX0NQVV9BUkVBPXkKQ09ORklHX0hBVkVfRFlOQU1JQ19QRVJfQ1BVX0FSRUE9eQojIENP
TkZJR19IQVZFX0NQVU1BU0tfT0ZfQ1BVX01BUCBpcyBub3Qgc2V0CkNPTkZJR19BUkNIX0hJ
QkVSTkFUSU9OX1BPU1NJQkxFPXkKQ09ORklHX0FSQ0hfU1VTUEVORF9QT1NTSUJMRT15CiMg
Q09ORklHX1pPTkVfRE1BMzIgaXMgbm90IHNldApDT05GSUdfQVJDSF9QT1BVTEFURVNfTk9E
RV9NQVA9eQojIENPTkZJR19BVURJVF9BUkNIIGlzIG5vdCBzZXQKQ09ORklHX0FSQ0hfU1VQ
UE9SVFNfT1BUSU1JWkVEX0lOTElOSU5HPXkKQ09ORklHX0FSQ0hfU1VQUE9SVFNfREVCVUdf
UEFHRUFMTE9DPXkKQ09ORklHX0dFTkVSSUNfSEFSRElSUVM9eQpDT05GSUdfR0VORVJJQ19I
QVJESVJRU19OT19fRE9fSVJRPXkKQ09ORklHX0dFTkVSSUNfSVJRX1BST0JFPXkKQ09ORklH
X0dFTkVSSUNfUEVORElOR19JUlE9eQpDT05GSUdfVVNFX0dFTkVSSUNfU01QX0hFTFBFUlM9
eQpDT05GSUdfWDg2XzMyX1NNUD15CkNPTkZJR19YODZfSFQ9eQpDT05GSUdfWDg2X1RSQU1Q
T0xJTkU9eQpDT05GSUdfWDg2XzMyX0xBWllfR1M9eQpDT05GSUdfS1RJTUVfU0NBTEFSPXkK
Q09ORklHX0RFRkNPTkZJR19MSVNUPSIvbGliL21vZHVsZXMvJFVOQU1FX1JFTEVBU0UvLmNv
bmZpZyIKCiMKIyBHZW5lcmFsIHNldHVwCiMKIyBDT05GSUdfRVhQRVJJTUVOVEFMIGlzIG5v
dCBzZXQKQ09ORklHX0xPQ0tfS0VSTkVMPXkKQ09ORklHX0lOSVRfRU5WX0FSR19MSU1JVD0z
MgpDT05GSUdfTE9DQUxWRVJTSU9OPSIiCiMgQ09ORklHX0xPQ0FMVkVSU0lPTl9BVVRPIGlz
IG5vdCBzZXQKQ09ORklHX0hBVkVfS0VSTkVMX0daSVA9eQpDT05GSUdfSEFWRV9LRVJORUxf
QlpJUDI9eQpDT05GSUdfSEFWRV9LRVJORUxfTFpNQT15CkNPTkZJR19LRVJORUxfR1pJUD15
CiMgQ09ORklHX0tFUk5FTF9CWklQMiBpcyBub3Qgc2V0CiMgQ09ORklHX0tFUk5FTF9MWk1B
IGlzIG5vdCBzZXQKQ09ORklHX1NXQVA9eQpDT05GSUdfU1lTVklQQz15CkNPTkZJR19TWVNW
SVBDX1NZU0NUTD15CkNPTkZJR19CU0RfUFJPQ0VTU19BQ0NUPXkKQ09ORklHX0JTRF9QUk9D
RVNTX0FDQ1RfVjM9eQojIENPTkZJR19UQVNLU1RBVFMgaXMgbm90IHNldAojIENPTkZJR19B
VURJVCBpcyBub3Qgc2V0CgojCiMgUkNVIFN1YnN5c3RlbQojCkNPTkZJR19DTEFTU0lDX1JD
VT15CiMgQ09ORklHX1RSRUVfUkNVIGlzIG5vdCBzZXQKIyBDT05GSUdfUFJFRU1QVF9SQ1Ug
aXMgbm90IHNldAojIENPTkZJR19UUkVFX1JDVV9UUkFDRSBpcyBub3Qgc2V0CiMgQ09ORklH
X1BSRUVNUFRfUkNVX1RSQUNFIGlzIG5vdCBzZXQKQ09ORklHX0lLQ09ORklHPXkKQ09ORklH
X0lLQ09ORklHX1BST0M9eQpDT05GSUdfTE9HX0JVRl9TSElGVD0xOApDT05GSUdfSEFWRV9V
TlNUQUJMRV9TQ0hFRF9DTE9DSz15CiMgQ09ORklHX0NHUk9VUFMgaXMgbm90IHNldAojIENP
TkZJR19TWVNGU19ERVBSRUNBVEVEX1YyIGlzIG5vdCBzZXQKQ09ORklHX1JFTEFZPXkKQ09O
RklHX05BTUVTUEFDRVM9eQpDT05GSUdfVVRTX05TPXkKQ09ORklHX0lQQ19OUz15CiMgQ09O
RklHX0JMS19ERVZfSU5JVFJEIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0NfT1BUSU1JWkVfRk9S
X1NJWkUgaXMgbm90IHNldApDT05GSUdfU1lTQ1RMPXkKQ09ORklHX0FOT05fSU5PREVTPXkK
IyBDT05GSUdfRU1CRURERUQgaXMgbm90IHNldApDT05GSUdfVUlEMTY9eQpDT05GSUdfU1lT
Q1RMX1NZU0NBTEw9eQpDT05GSUdfS0FMTFNZTVM9eQpDT05GSUdfS0FMTFNZTVNfQUxMPXkK
IyBDT05GSUdfS0FMTFNZTVNfRVhUUkFfUEFTUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NUUklQ
X0FTTV9TWU1TIGlzIG5vdCBzZXQKQ09ORklHX0hPVFBMVUc9eQpDT05GSUdfUFJJTlRLPXkK
Q09ORklHX0JVRz15CkNPTkZJR19FTEZfQ09SRT15CkNPTkZJR19QQ1NQS1JfUExBVEZPUk09
eQpDT05GSUdfQkFTRV9GVUxMPXkKQ09ORklHX0ZVVEVYPXkKQ09ORklHX0VQT0xMPXkKQ09O
RklHX1NJR05BTEZEPXkKQ09ORklHX1RJTUVSRkQ9eQpDT05GSUdfRVZFTlRGRD15CkNPTkZJ
R19TSE1FTT15CkNPTkZJR19BSU89eQpDT05GSUdfVk1fRVZFTlRfQ09VTlRFUlM9eQpDT05G
SUdfUENJX1FVSVJLUz15CkNPTkZJR19TTFVCX0RFQlVHPXkKIyBDT05GSUdfQ09NUEFUX0JS
SyBpcyBub3Qgc2V0CiMgQ09ORklHX1NMQUIgaXMgbm90IHNldApDT05GSUdfU0xVQj15CiMg
Q09ORklHX1NMT0IgaXMgbm90IHNldAojIENPTkZJR19QUk9GSUxJTkcgaXMgbm90IHNldApD
T05GSUdfVFJBQ0VQT0lOVFM9eQpDT05GSUdfTUFSS0VSUz15CkNPTkZJR19IQVZFX09QUk9G
SUxFPXkKQ09ORklHX0hBVkVfRUZGSUNJRU5UX1VOQUxJR05FRF9BQ0NFU1M9eQpDT05GSUdf
SEFWRV9JT1JFTUFQX1BST1Q9eQpDT05GSUdfSEFWRV9LUFJPQkVTPXkKQ09ORklHX0hBVkVf
S1JFVFBST0JFUz15CkNPTkZJR19IQVZFX0FSQ0hfVFJBQ0VIT09LPXkKQ09ORklHX0hBVkVf
RE1BX0FQSV9ERUJVRz15CiMgQ09ORklHX1NMT1dfV09SSyBpcyBub3Qgc2V0CkNPTkZJR19I
QVZFX0dFTkVSSUNfRE1BX0NPSEVSRU5UPXkKQ09ORklHX1NMQUJJTkZPPXkKQ09ORklHX1JU
X01VVEVYRVM9eQpDT05GSUdfQkFTRV9TTUFMTD0wCiMgQ09ORklHX01PRFVMRVMgaXMgbm90
IHNldApDT05GSUdfQkxPQ0s9eQpDT05GSUdfTEJEPXkKQ09ORklHX0JMS19ERVZfSU5URUdS
SVRZPXkKCiMKIyBJTyBTY2hlZHVsZXJzCiMKQ09ORklHX0lPU0NIRURfTk9PUD15CiMgQ09O
RklHX0lPU0NIRURfQVMgaXMgbm90IHNldApDT05GSUdfSU9TQ0hFRF9ERUFETElORT15CiMg
Q09ORklHX0lPU0NIRURfQ0ZRIGlzIG5vdCBzZXQKIyBDT05GSUdfREVGQVVMVF9BUyBpcyBu
b3Qgc2V0CkNPTkZJR19ERUZBVUxUX0RFQURMSU5FPXkKIyBDT05GSUdfREVGQVVMVF9DRlEg
aXMgbm90IHNldAojIENPTkZJR19ERUZBVUxUX05PT1AgaXMgbm90IHNldApDT05GSUdfREVG
QVVMVF9JT1NDSEVEPSJkZWFkbGluZSIKIyBDT05GSUdfRlJFRVpFUiBpcyBub3Qgc2V0Cgoj
CiMgUHJvY2Vzc29yIHR5cGUgYW5kIGZlYXR1cmVzCiMKQ09ORklHX1RJQ0tfT05FU0hPVD15
CkNPTkZJR19OT19IWj15CkNPTkZJR19ISUdIX1JFU19USU1FUlM9eQpDT05GSUdfR0VORVJJ
Q19DTE9DS0VWRU5UU19CVUlMRD15CkNPTkZJR19TTVA9eQpDT05GSUdfU1BBUlNFX0lSUT15
CkNPTkZJR19YODZfTVBQQVJTRT15CiMgQ09ORklHX1g4Nl9CSUdTTVAgaXMgbm90IHNldAoj
IENPTkZJR19YODZfRVhURU5ERURfUExBVEZPUk0gaXMgbm90IHNldApDT05GSUdfU0NIRURf
T01JVF9GUkFNRV9QT0lOVEVSPXkKIyBDT05GSUdfUEFSQVZJUlRfR1VFU1QgaXMgbm90IHNl
dApDT05GSUdfTUVNVEVTVD15CiMgQ09ORklHX00zODYgaXMgbm90IHNldAojIENPTkZJR19N
NDg2IGlzIG5vdCBzZXQKIyBDT05GSUdfTTU4NiBpcyBub3Qgc2V0CiMgQ09ORklHX001ODZU
U0MgaXMgbm90IHNldAojIENPTkZJR19NNTg2TU1YIGlzIG5vdCBzZXQKIyBDT05GSUdfTTY4
NiBpcyBub3Qgc2V0CiMgQ09ORklHX01QRU5USVVNSUkgaXMgbm90IHNldApDT05GSUdfTVBF
TlRJVU1JSUk9eQojIENPTkZJR19NUEVOVElVTU0gaXMgbm90IHNldAojIENPTkZJR19NUEVO
VElVTTQgaXMgbm90IHNldAojIENPTkZJR19NSzYgaXMgbm90IHNldAojIENPTkZJR19NSzcg
aXMgbm90IHNldAojIENPTkZJR19NSzggaXMgbm90IHNldAojIENPTkZJR19NQ1JVU09FIGlz
IG5vdCBzZXQKIyBDT05GSUdfTUVGRklDRU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfTVdJTkNI
SVBDNiBpcyBub3Qgc2V0CiMgQ09ORklHX01XSU5DSElQM0QgaXMgbm90IHNldAojIENPTkZJ
R19NR0VPREVHWDEgaXMgbm90IHNldAojIENPTkZJR19NR0VPREVfTFggaXMgbm90IHNldAoj
IENPTkZJR19NQ1lSSVhJSUkgaXMgbm90IHNldAojIENPTkZJR19NVklBQzNfMiBpcyBub3Qg
c2V0CiMgQ09ORklHX01WSUFDNyBpcyBub3Qgc2V0CiMgQ09ORklHX01QU0MgaXMgbm90IHNl
dAojIENPTkZJR19NQ09SRTIgaXMgbm90IHNldAojIENPTkZJR19HRU5FUklDX0NQVSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1g4Nl9HRU5FUklDIGlzIG5vdCBzZXQKQ09ORklHX1g4Nl9DUFU9
eQpDT05GSUdfWDg2X0wxX0NBQ0hFX0JZVEVTPTY0CkNPTkZJR19YODZfSU5URVJOT0RFX0NB
Q0hFX0JZVEVTPTY0CkNPTkZJR19YODZfQ01QWENIRz15CkNPTkZJR19YODZfTDFfQ0FDSEVf
U0hJRlQ9NQpDT05GSUdfWDg2X1hBREQ9eQpDT05GSUdfWDg2X1dQX1dPUktTX09LPXkKQ09O
RklHX1g4Nl9JTlZMUEc9eQpDT05GSUdfWDg2X0JTV0FQPXkKQ09ORklHX1g4Nl9QT1BBRF9P
Sz15CkNPTkZJR19YODZfSU5URUxfVVNFUkNPUFk9eQpDT05GSUdfWDg2X1VTRV9QUFJPX0NI
RUNLU1VNPXkKQ09ORklHX1g4Nl9UU0M9eQpDT05GSUdfWDg2X0NNT1Y9eQpDT05GSUdfWDg2
X01JTklNVU1fQ1BVX0ZBTUlMWT00CkNPTkZJR19YODZfREVCVUdDVExNU1I9eQpDT05GSUdf
Q1BVX1NVUF9JTlRFTD15CkNPTkZJR19DUFVfU1VQX0NZUklYXzMyPXkKQ09ORklHX0NQVV9T
VVBfQU1EPXkKQ09ORklHX0NQVV9TVVBfQ0VOVEFVUj15CkNPTkZJR19DUFVfU1VQX1RSQU5T
TUVUQV8zMj15CkNPTkZJR19DUFVfU1VQX1VNQ18zMj15CiMgQ09ORklHX1g4Nl9EUyBpcyBu
b3Qgc2V0CkNPTkZJR19IUEVUX1RJTUVSPXkKQ09ORklHX0hQRVRfRU1VTEFURV9SVEM9eQpD
T05GSUdfRE1JPXkKIyBDT05GSUdfSU9NTVVfSEVMUEVSIGlzIG5vdCBzZXQKIyBDT05GSUdf
SU9NTVVfQVBJIGlzIG5vdCBzZXQKQ09ORklHX05SX0NQVVM9MgojIENPTkZJR19TQ0hFRF9T
TVQgaXMgbm90IHNldAojIENPTkZJR19TQ0hFRF9NQyBpcyBub3Qgc2V0CiMgQ09ORklHX1BS
RUVNUFRfTk9ORSBpcyBub3Qgc2V0CkNPTkZJR19QUkVFTVBUX1ZPTFVOVEFSWT15CiMgQ09O
RklHX1BSRUVNUFQgaXMgbm90IHNldApDT05GSUdfWDg2X0xPQ0FMX0FQSUM9eQpDT05GSUdf
WDg2X0lPX0FQSUM9eQpDT05GSUdfWDg2X1JFUk9VVEVfRk9SX0JST0tFTl9CT09UX0lSUVM9
eQpDT05GSUdfWDg2X01DRT15CiMgQ09ORklHX1g4Nl9NQ0VfTk9ORkFUQUwgaXMgbm90IHNl
dAojIENPTkZJR19YODZfTUNFX1A0VEhFUk1BTCBpcyBub3Qgc2V0CkNPTkZJR19WTTg2PXkK
IyBDT05GSUdfVE9TSElCQSBpcyBub3Qgc2V0CiMgQ09ORklHX0k4SyBpcyBub3Qgc2V0CiMg
Q09ORklHX1g4Nl9SRUJPT1RGSVhVUFMgaXMgbm90IHNldApDT05GSUdfTUlDUk9DT0RFPXkK
Q09ORklHX01JQ1JPQ09ERV9JTlRFTD15CiMgQ09ORklHX01JQ1JPQ09ERV9BTUQgaXMgbm90
IHNldApDT05GSUdfTUlDUk9DT0RFX09MRF9JTlRFUkZBQ0U9eQpDT05GSUdfWDg2X01TUj15
CkNPTkZJR19YODZfQ1BVSUQ9eQojIENPTkZJR19YODZfQ1BVX0RFQlVHIGlzIG5vdCBzZXQK
Q09ORklHX05PSElHSE1FTT15CiMgQ09ORklHX0hJR0hNRU00RyBpcyBub3Qgc2V0CiMgQ09O
RklHX0hJR0hNRU02NEcgaXMgbm90IHNldApDT05GSUdfUEFHRV9PRkZTRVQ9MHhDMDAwMDAw
MAojIENPTkZJR19YODZfUEFFIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9QSFlTX0FERFJf
VF82NEJJVCBpcyBub3Qgc2V0CkNPTkZJR19GTEFUTUVNPXkKQ09ORklHX0ZMQVRfTk9ERV9N
RU1fTUFQPXkKQ09ORklHX1BBR0VGTEFHU19FWFRFTkRFRD15CkNPTkZJR19TUExJVF9QVExP
Q0tfQ1BVUz00CiMgQ09ORklHX1BIWVNfQUREUl9UXzY0QklUIGlzIG5vdCBzZXQKQ09ORklH
X1pPTkVfRE1BX0ZMQUc9MQpDT05GSUdfQk9VTkNFPXkKQ09ORklHX1ZJUlRfVE9fQlVTPXkK
Q09ORklHX1VORVZJQ1RBQkxFX0xSVT15CkNPTkZJR19IQVZFX01MT0NLPXkKQ09ORklHX0hB
VkVfTUxPQ0tFRF9QQUdFX0JJVD15CkNPTkZJR19ERUZBVUxUX01NQVBfTUlOX0FERFI9NDA5
NgpDT05GSUdfWDg2X0NIRUNLX0JJT1NfQ09SUlVQVElPTj15CkNPTkZJR19YODZfQk9PVFBB
UkFNX01FTU9SWV9DT1JSVVBUSU9OX0NIRUNLPXkKQ09ORklHX1g4Nl9SRVNFUlZFX0xPV182
NEs9eQojIENPTkZJR19NQVRIX0VNVUxBVElPTiBpcyBub3Qgc2V0CkNPTkZJR19NVFJSPXkK
Q09ORklHX01UUlJfU0FOSVRJWkVSPXkKQ09ORklHX01UUlJfU0FOSVRJWkVSX0VOQUJMRV9E
RUZBVUxUPTAKQ09ORklHX01UUlJfU0FOSVRJWkVSX1NQQVJFX1JFR19OUl9ERUZBVUxUPTEK
IyBDT05GSUdfWDg2X1BBVCBpcyBub3Qgc2V0CiMgQ09ORklHX0VGSSBpcyBub3Qgc2V0CkNP
TkZJR19TRUNDT01QPXkKIyBDT05GSUdfQ0NfU1RBQ0tQUk9URUNUT1IgaXMgbm90IHNldAoj
IENPTkZJR19IWl8xMDAgaXMgbm90IHNldAojIENPTkZJR19IWl8yNTAgaXMgbm90IHNldAoj
IENPTkZJR19IWl8zMDAgaXMgbm90IHNldApDT05GSUdfSFpfMTAwMD15CkNPTkZJR19IWj0x
MDAwCkNPTkZJR19TQ0hFRF9IUlRJQ0s9eQpDT05GSUdfS0VYRUM9eQpDT05GSUdfUEhZU0lD
QUxfU1RBUlQ9MHgxMDAwMDAKQ09ORklHX1BIWVNJQ0FMX0FMSUdOPTB4MTAwMDAwCiMgQ09O
RklHX0hPVFBMVUdfQ1BVIGlzIG5vdCBzZXQKIyBDT05GSUdfQ09NUEFUX1ZEU08gaXMgbm90
IHNldAojIENPTkZJR19DTURMSU5FX0JPT0wgaXMgbm90IHNldAoKIwojIFBvd2VyIG1hbmFn
ZW1lbnQgYW5kIEFDUEkgb3B0aW9ucwojCkNPTkZJR19QTT15CiMgQ09ORklHX1BNX0RFQlVH
IGlzIG5vdCBzZXQKIyBDT05GSUdfU1VTUEVORCBpcyBub3Qgc2V0CiMgQ09ORklHX0hJQkVS
TkFUSU9OIGlzIG5vdCBzZXQKQ09ORklHX0FDUEk9eQojIENPTkZJR19BQ1BJX1BST0NGUyBp
cyBub3Qgc2V0CiMgQ09ORklHX0FDUElfUFJPQ0ZTX1BPV0VSIGlzIG5vdCBzZXQKQ09ORklH
X0FDUElfU1lTRlNfUE9XRVI9eQojIENPTkZJR19BQ1BJX1BST0NfRVZFTlQgaXMgbm90IHNl
dAojIENPTkZJR19BQ1BJX0FDIGlzIG5vdCBzZXQKIyBDT05GSUdfQUNQSV9CQVRURVJZIGlz
IG5vdCBzZXQKIyBDT05GSUdfQUNQSV9CVVRUT04gaXMgbm90IHNldAojIENPTkZJR19BQ1BJ
X0ZBTiBpcyBub3Qgc2V0CkNPTkZJR19BQ1BJX1BST0NFU1NPUj15CkNPTkZJR19BQ1BJX1RI
RVJNQUw9eQojIENPTkZJR19BQ1BJX0NVU1RPTV9EU0RUIGlzIG5vdCBzZXQKQ09ORklHX0FD
UElfQkxBQ0tMSVNUX1lFQVI9MAojIENPTkZJR19BQ1BJX0RFQlVHIGlzIG5vdCBzZXQKIyBD
T05GSUdfQUNQSV9QQ0lfU0xPVCBpcyBub3Qgc2V0CkNPTkZJR19YODZfUE1fVElNRVI9eQoj
IENPTkZJR19BQ1BJX1NCUyBpcyBub3Qgc2V0CgojCiMgQ1BVIEZyZXF1ZW5jeSBzY2FsaW5n
CiMKIyBDT05GSUdfQ1BVX0ZSRVEgaXMgbm90IHNldApDT05GSUdfQ1BVX0lETEU9eQpDT05G
SUdfQ1BVX0lETEVfR09WX0xBRERFUj15CkNPTkZJR19DUFVfSURMRV9HT1ZfTUVOVT15Cgoj
CiMgQnVzIG9wdGlvbnMgKFBDSSBldGMuKQojCkNPTkZJR19QQ0k9eQojIENPTkZJR19QQ0lf
R09CSU9TIGlzIG5vdCBzZXQKIyBDT05GSUdfUENJX0dPTU1DT05GSUcgaXMgbm90IHNldAoj
IENPTkZJR19QQ0lfR09ESVJFQ1QgaXMgbm90IHNldAojIENPTkZJR19QQ0lfR09PTFBDIGlz
IG5vdCBzZXQKQ09ORklHX1BDSV9HT0FOWT15CkNPTkZJR19QQ0lfQklPUz15CkNPTkZJR19Q
Q0lfRElSRUNUPXkKQ09ORklHX1BDSV9NTUNPTkZJRz15CkNPTkZJR19QQ0lfRE9NQUlOUz15
CiMgQ09ORklHX1BDSUVQT1JUQlVTIGlzIG5vdCBzZXQKQ09ORklHX0FSQ0hfU1VQUE9SVFNf
TVNJPXkKQ09ORklHX1BDSV9NU0k9eQojIENPTkZJR19QQ0lfTEVHQUNZIGlzIG5vdCBzZXQK
IyBDT05GSUdfUENJX1NUVUIgaXMgbm90IHNldAojIENPTkZJR19IVF9JUlEgaXMgbm90IHNl
dApDT05GSUdfUENJX0lPVj15CkNPTkZJR19JU0FfRE1BX0FQST15CkNPTkZJR19JU0E9eQpD
T05GSUdfRUlTQT15CkNPTkZJR19FSVNBX1ZMQl9QUklNSU5HPXkKQ09ORklHX0VJU0FfUENJ
X0VJU0E9eQpDT05GSUdfRUlTQV9WSVJUVUFMX1JPT1Q9eQpDT05GSUdfRUlTQV9OQU1FUz15
CiMgQ09ORklHX01DQSBpcyBub3Qgc2V0CiMgQ09ORklHX1NDeDIwMCBpcyBub3Qgc2V0CiMg
Q09ORklHX09MUEMgaXMgbm90IHNldAojIENPTkZJR19QQ0NBUkQgaXMgbm90IHNldAojIENP
TkZJR19IT1RQTFVHX1BDSSBpcyBub3Qgc2V0CgojCiMgRXhlY3V0YWJsZSBmaWxlIGZvcm1h
dHMgLyBFbXVsYXRpb25zCiMKQ09ORklHX0JJTkZNVF9FTEY9eQojIENPTkZJR19DT1JFX0RV
TVBfREVGQVVMVF9FTEZfSEVBREVSUyBpcyBub3Qgc2V0CkNPTkZJR19IQVZFX0FPVVQ9eQpD
T05GSUdfQklORk1UX0FPVVQ9eQpDT05GSUdfQklORk1UX01JU0M9eQpDT05GSUdfSEFWRV9B
VE9NSUNfSU9NQVA9eQpDT05GSUdfTkVUPXkKCiMKIyBOZXR3b3JraW5nIG9wdGlvbnMKIwpD
T05GSUdfUEFDS0VUPXkKQ09ORklHX1BBQ0tFVF9NTUFQPXkKQ09ORklHX1VOSVg9eQpDT05G
SUdfWEZSTT15CkNPTkZJR19YRlJNX1VTRVI9eQpDT05GSUdfWEZSTV9JUENPTVA9eQpDT05G
SUdfTkVUX0tFWT15CkNPTkZJR19JTkVUPXkKQ09ORklHX0lQX01VTFRJQ0FTVD15CkNPTkZJ
R19JUF9BRFZBTkNFRF9ST1VURVI9eQpDT05GSUdfQVNLX0lQX0ZJQl9IQVNIPXkKIyBDT05G
SUdfSVBfRklCX1RSSUUgaXMgbm90IHNldApDT05GSUdfSVBfRklCX0hBU0g9eQpDT05GSUdf
SVBfTVVMVElQTEVfVEFCTEVTPXkKQ09ORklHX0lQX1JPVVRFX01VTFRJUEFUSD15CkNPTkZJ
R19JUF9ST1VURV9WRVJCT1NFPXkKIyBDT05GSUdfSVBfUE5QIGlzIG5vdCBzZXQKQ09ORklH
X05FVF9JUElQPXkKQ09ORklHX05FVF9JUEdSRT15CkNPTkZJR19ORVRfSVBHUkVfQlJPQURD
QVNUPXkKQ09ORklHX0lQX01ST1VURT15CkNPTkZJR19JUF9QSU1TTV9WMT15CkNPTkZJR19J
UF9QSU1TTV9WMj15CiMgQ09ORklHX1NZTl9DT09LSUVTIGlzIG5vdCBzZXQKQ09ORklHX0lO
RVRfQUg9eQpDT05GSUdfSU5FVF9FU1A9eQpDT05GSUdfSU5FVF9JUENPTVA9eQpDT05GSUdf
SU5FVF9YRlJNX1RVTk5FTD15CkNPTkZJR19JTkVUX1RVTk5FTD15CkNPTkZJR19JTkVUX1hG
Uk1fTU9ERV9UUkFOU1BPUlQ9eQpDT05GSUdfSU5FVF9YRlJNX01PREVfVFVOTkVMPXkKQ09O
RklHX0lORVRfWEZSTV9NT0RFX0JFRVQ9eQpDT05GSUdfSU5FVF9MUk89eQpDT05GSUdfSU5F
VF9ESUFHPXkKQ09ORklHX0lORVRfVENQX0RJQUc9eQpDT05GSUdfVENQX0NPTkdfQURWQU5D
RUQ9eQpDT05GSUdfVENQX0NPTkdfQklDPXkKQ09ORklHX1RDUF9DT05HX0NVQklDPXkKQ09O
RklHX1RDUF9DT05HX1dFU1RXT09EPXkKQ09ORklHX1RDUF9DT05HX0hUQ1A9eQojIENPTkZJ
R19ERUZBVUxUX0JJQyBpcyBub3Qgc2V0CkNPTkZJR19ERUZBVUxUX0NVQklDPXkKIyBDT05G
SUdfREVGQVVMVF9IVENQIGlzIG5vdCBzZXQKIyBDT05GSUdfREVGQVVMVF9WRUdBUyBpcyBu
b3Qgc2V0CiMgQ09ORklHX0RFRkFVTFRfV0VTVFdPT0QgaXMgbm90IHNldAojIENPTkZJR19E
RUZBVUxUX1JFTk8gaXMgbm90IHNldApDT05GSUdfREVGQVVMVF9UQ1BfQ09ORz0iY3ViaWMi
CiMgQ09ORklHX0lQVjYgaXMgbm90IHNldAojIENPTkZJR19ORVRMQUJFTCBpcyBub3Qgc2V0
CkNPTkZJR19ORVRXT1JLX1NFQ01BUks9eQpDT05GSUdfTkVURklMVEVSPXkKIyBDT05GSUdf
TkVURklMVEVSX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX05FVEZJTFRFUl9BRFZBTkNFRD15
CgojCiMgQ29yZSBOZXRmaWx0ZXIgQ29uZmlndXJhdGlvbgojCkNPTkZJR19ORVRGSUxURVJf
TkVUTElOSz15CkNPTkZJR19ORVRGSUxURVJfTkVUTElOS19RVUVVRT15CkNPTkZJR19ORVRG
SUxURVJfTkVUTElOS19MT0c9eQpDT05GSUdfTkZfQ09OTlRSQUNLPXkKQ09ORklHX05GX0NU
X0FDQ1Q9eQpDT05GSUdfTkZfQ09OTlRSQUNLX01BUks9eQpDT05GSUdfTkZfQ09OTlRSQUNL
X1NFQ01BUks9eQpDT05GSUdfTkZfQ09OTlRSQUNLX0VWRU5UUz15CkNPTkZJR19ORl9DVF9Q
Uk9UT19HUkU9eQpDT05GSUdfTkZfQ1RfUFJPVE9fVURQTElURT15CkNPTkZJR19ORl9DT05O
VFJBQ0tfQU1BTkRBPXkKQ09ORklHX05GX0NPTk5UUkFDS19GVFA9eQpDT05GSUdfTkZfQ09O
TlRSQUNLX0gzMjM9eQpDT05GSUdfTkZfQ09OTlRSQUNLX0lSQz15CkNPTkZJR19ORl9DT05O
VFJBQ0tfTkVUQklPU19OUz15CkNPTkZJR19ORl9DT05OVFJBQ0tfUFBUUD15CkNPTkZJR19O
Rl9DT05OVFJBQ0tfU0lQPXkKQ09ORklHX05GX0NPTk5UUkFDS19URlRQPXkKQ09ORklHX05G
X0NUX05FVExJTks9eQpDT05GSUdfTkVURklMVEVSX1hUQUJMRVM9eQpDT05GSUdfTkVURklM
VEVSX1hUX1RBUkdFVF9DTEFTU0lGWT15CkNPTkZJR19ORVRGSUxURVJfWFRfVEFSR0VUX0NP
Tk5NQVJLPXkKQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfQ09OTlNFQ01BUks9eQpDT05G
SUdfTkVURklMVEVSX1hUX1RBUkdFVF9EU0NQPXkKQ09ORklHX05FVEZJTFRFUl9YVF9UQVJH
RVRfSEw9eQpDT05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9NQVJLPXkKQ09ORklHX05FVEZJ
TFRFUl9YVF9UQVJHRVRfTkZMT0c9eQpDT05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9ORlFV
RVVFPXkKQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfUkFURUVTVD15CkNPTkZJR19ORVRG
SUxURVJfWFRfVEFSR0VUX1NFQ01BUks9eQpDT05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9U
Q1BNU1M9eQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0NMVVNURVI9eQpDT05GSUdfTkVU
RklMVEVSX1hUX01BVENIX0NPTU1FTlQ9eQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0NP
Tk5CWVRFUz15CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfQ09OTkxJTUlUPXkKQ09ORklH
X05FVEZJTFRFUl9YVF9NQVRDSF9DT05OTUFSSz15CkNPTkZJR19ORVRGSUxURVJfWFRfTUFU
Q0hfQ09OTlRSQUNLPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9EQ0NQPXkKQ09ORklH
X05FVEZJTFRFUl9YVF9NQVRDSF9EU0NQPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9F
U1A9eQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0hBU0hMSU1JVD15CkNPTkZJR19ORVRG
SUxURVJfWFRfTUFUQ0hfSEVMUEVSPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9ITD15
CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfSVBSQU5HRT15CkNPTkZJR19ORVRGSUxURVJf
WFRfTUFUQ0hfTEVOR1RIPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9MSU1JVD15CkNP
TkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfTUFDPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRD
SF9NQVJLPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9NVUxUSVBPUlQ9eQpDT05GSUdf
TkVURklMVEVSX1hUX01BVENIX09XTkVSPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9Q
T0xJQ1k9eQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1BLVFRZUEU9eQpDT05GSUdfTkVU
RklMVEVSX1hUX01BVENIX1FVT1RBPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9SQVRF
RVNUPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9SRUFMTT15CkNPTkZJR19ORVRGSUxU
RVJfWFRfTUFUQ0hfUkVDRU5UPXkKIyBDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1JFQ0VO
VF9QUk9DX0NPTVBBVCBpcyBub3Qgc2V0CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfU1RB
VEU9eQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1NUQVRJU1RJQz15CkNPTkZJR19ORVRG
SUxURVJfWFRfTUFUQ0hfU1RSSU5HPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9UQ1BN
U1M9eQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1RJTUU9eQpDT05GSUdfTkVURklMVEVS
X1hUX01BVENIX1UzMj15CiMgQ09ORklHX0lQX1ZTIGlzIG5vdCBzZXQKCiMKIyBJUDogTmV0
ZmlsdGVyIENvbmZpZ3VyYXRpb24KIwpDT05GSUdfTkZfREVGUkFHX0lQVjQ9eQpDT05GSUdf
TkZfQ09OTlRSQUNLX0lQVjQ9eQojIENPTkZJR19ORl9DT05OVFJBQ0tfUFJPQ19DT01QQVQg
aXMgbm90IHNldAojIENPTkZJR19JUF9ORl9RVUVVRSBpcyBub3Qgc2V0CkNPTkZJR19JUF9O
Rl9JUFRBQkxFUz15CkNPTkZJR19JUF9ORl9NQVRDSF9BRERSVFlQRT15CkNPTkZJR19JUF9O
Rl9NQVRDSF9BSD15CkNPTkZJR19JUF9ORl9NQVRDSF9FQ049eQpDT05GSUdfSVBfTkZfTUFU
Q0hfVFRMPXkKQ09ORklHX0lQX05GX0ZJTFRFUj15CkNPTkZJR19JUF9ORl9UQVJHRVRfUkVK
RUNUPXkKQ09ORklHX0lQX05GX1RBUkdFVF9MT0c9eQpDT05GSUdfSVBfTkZfVEFSR0VUX1VM
T0c9eQpDT05GSUdfTkZfTkFUPXkKQ09ORklHX05GX05BVF9ORUVERUQ9eQpDT05GSUdfSVBf
TkZfVEFSR0VUX01BU1FVRVJBREU9eQpDT05GSUdfSVBfTkZfVEFSR0VUX05FVE1BUD15CkNP
TkZJR19JUF9ORl9UQVJHRVRfUkVESVJFQ1Q9eQpDT05GSUdfTkZfTkFUX1NOTVBfQkFTSUM9
eQpDT05GSUdfTkZfTkFUX1BST1RPX0dSRT15CkNPTkZJR19ORl9OQVRfUFJPVE9fVURQTElU
RT15CkNPTkZJR19ORl9OQVRfRlRQPXkKQ09ORklHX05GX05BVF9JUkM9eQpDT05GSUdfTkZf
TkFUX1RGVFA9eQpDT05GSUdfTkZfTkFUX0FNQU5EQT15CkNPTkZJR19ORl9OQVRfUFBUUD15
CkNPTkZJR19ORl9OQVRfSDMyMz15CkNPTkZJR19ORl9OQVRfU0lQPXkKQ09ORklHX0lQX05G
X01BTkdMRT15CkNPTkZJR19JUF9ORl9UQVJHRVRfRUNOPXkKQ09ORklHX0lQX05GX1RBUkdF
VF9UVEw9eQojIENPTkZJR19JUF9ORl9SQVcgaXMgbm90IHNldAojIENPTkZJR19JUF9ORl9T
RUNVUklUWSBpcyBub3Qgc2V0CiMgQ09ORklHX0lQX05GX0FSUFRBQkxFUyBpcyBub3Qgc2V0
CiMgQ09ORklHX0FUTSBpcyBub3Qgc2V0CiMgQ09ORklHX0JSSURHRSBpcyBub3Qgc2V0CiMg
Q09ORklHX1ZMQU5fODAyMVEgaXMgbm90IHNldAojIENPTkZJR19ERUNORVQgaXMgbm90IHNl
dAojIENPTkZJR19MTEMyIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBYIGlzIG5vdCBzZXQKIyBD
T05GSUdfQVRBTEsgaXMgbm90IHNldAojIENPTkZJR19QSE9ORVQgaXMgbm90IHNldApDT05G
SUdfTkVUX1NDSEVEPXkKCiMKIyBRdWV1ZWluZy9TY2hlZHVsaW5nCiMKQ09ORklHX05FVF9T
Q0hfQ0JRPXkKQ09ORklHX05FVF9TQ0hfSFRCPXkKQ09ORklHX05FVF9TQ0hfSEZTQz15CkNP
TkZJR19ORVRfU0NIX1BSSU89eQpDT05GSUdfTkVUX1NDSF9NVUxUSVE9eQpDT05GSUdfTkVU
X1NDSF9SRUQ9eQpDT05GSUdfTkVUX1NDSF9TRlE9eQpDT05GSUdfTkVUX1NDSF9URVFMPXkK
Q09ORklHX05FVF9TQ0hfVEJGPXkKQ09ORklHX05FVF9TQ0hfR1JFRD15CkNPTkZJR19ORVRf
U0NIX0RTTUFSSz15CiMgQ09ORklHX05FVF9TQ0hfTkVURU0gaXMgbm90IHNldApDT05GSUdf
TkVUX1NDSF9EUlI9eQpDT05GSUdfTkVUX1NDSF9JTkdSRVNTPXkKCiMKIyBDbGFzc2lmaWNh
dGlvbgojCkNPTkZJR19ORVRfQ0xTPXkKQ09ORklHX05FVF9DTFNfQkFTSUM9eQpDT05GSUdf
TkVUX0NMU19UQ0lOREVYPXkKQ09ORklHX05FVF9DTFNfUk9VVEU0PXkKQ09ORklHX05FVF9D
TFNfUk9VVEU9eQpDT05GSUdfTkVUX0NMU19GVz15CkNPTkZJR19ORVRfQ0xTX1UzMj15CkNP
TkZJR19DTFNfVTMyX1BFUkY9eQpDT05GSUdfQ0xTX1UzMl9NQVJLPXkKQ09ORklHX05FVF9D
TFNfUlNWUD15CkNPTkZJR19ORVRfQ0xTX1JTVlA2PXkKQ09ORklHX05FVF9DTFNfRkxPVz15
CkNPTkZJR19ORVRfRU1BVENIPXkKQ09ORklHX05FVF9FTUFUQ0hfU1RBQ0s9MzIKQ09ORklH
X05FVF9FTUFUQ0hfQ01QPXkKQ09ORklHX05FVF9FTUFUQ0hfTkJZVEU9eQpDT05GSUdfTkVU
X0VNQVRDSF9VMzI9eQpDT05GSUdfTkVUX0VNQVRDSF9NRVRBPXkKQ09ORklHX05FVF9FTUFU
Q0hfVEVYVD15CkNPTkZJR19ORVRfQ0xTX0FDVD15CkNPTkZJR19ORVRfQUNUX1BPTElDRT15
CkNPTkZJR19ORVRfQUNUX0dBQ1Q9eQpDT05GSUdfR0FDVF9QUk9CPXkKQ09ORklHX05FVF9B
Q1RfTUlSUkVEPXkKQ09ORklHX05FVF9BQ1RfSVBUPXkKQ09ORklHX05FVF9BQ1RfTkFUPXkK
Q09ORklHX05FVF9BQ1RfUEVESVQ9eQojIENPTkZJR19ORVRfQUNUX1NJTVAgaXMgbm90IHNl
dApDT05GSUdfTkVUX0FDVF9TS0JFRElUPXkKQ09ORklHX05FVF9DTFNfSU5EPXkKQ09ORklH
X05FVF9TQ0hfRklGTz15CiMgQ09ORklHX0RDQiBpcyBub3Qgc2V0CgojCiMgTmV0d29yayB0
ZXN0aW5nCiMKIyBDT05GSUdfTkVUX1BLVEdFTiBpcyBub3Qgc2V0CiMgQ09ORklHX0hBTVJB
RElPIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0FOIGlzIG5vdCBzZXQKIyBDT05GSUdfSVJEQSBp
cyBub3Qgc2V0CiMgQ09ORklHX0JUIGlzIG5vdCBzZXQKQ09ORklHX0ZJQl9SVUxFUz15CiMg
Q09ORklHX1dJUkVMRVNTIGlzIG5vdCBzZXQKIyBDT05GSUdfV0lNQVggaXMgbm90IHNldAoj
IENPTkZJR19SRktJTEwgaXMgbm90IHNldAoKIwojIERldmljZSBEcml2ZXJzCiMKCiMKIyBH
ZW5lcmljIERyaXZlciBPcHRpb25zCiMKQ09ORklHX1VFVkVOVF9IRUxQRVJfUEFUSD0iL3Ni
aW4vaG90cGx1ZyIKQ09ORklHX1NUQU5EQUxPTkU9eQpDT05GSUdfUFJFVkVOVF9GSVJNV0FS
RV9CVUlMRD15CkNPTkZJR19GV19MT0FERVI9eQpDT05GSUdfRklSTVdBUkVfSU5fS0VSTkVM
PXkKQ09ORklHX0VYVFJBX0ZJUk1XQVJFPSIiCiMgQ09ORklHX1NZU19IWVBFUlZJU09SIGlz
IG5vdCBzZXQKQ09ORklHX0NPTk5FQ1RPUj15CkNPTkZJR19QUk9DX0VWRU5UUz15CiMgQ09O
RklHX01URCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBUlBPUlQgaXMgbm90IHNldApDT05GSUdf
UE5QPXkKIyBDT05GSUdfUE5QX0RFQlVHX01FU1NBR0VTIGlzIG5vdCBzZXQKCiMKIyBQcm90
b2NvbHMKIwpDT05GSUdfSVNBUE5QPXkKQ09ORklHX1BOUEFDUEk9eQpDT05GSUdfQkxLX0RF
Vj15CiMgQ09ORklHX0JMS19ERVZfRkQgaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX1hE
IGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0NQUV9EQSBpcyBub3Qgc2V0CiMgQ09ORklHX0JM
S19DUFFfQ0lTU19EQSBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfREFDOTYwIGlzIG5v
dCBzZXQKIyBDT05GSUdfQkxLX0RFVl9DT1dfQ09NTU9OIGlzIG5vdCBzZXQKQ09ORklHX0JM
S19ERVZfTE9PUD15CkNPTkZJR19CTEtfREVWX0NSWVBUT0xPT1A9eQojIENPTkZJR19CTEtf
REVWX05CRCBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfU1g4IGlzIG5vdCBzZXQKIyBD
T05GSUdfQkxLX0RFVl9VQiBpcyBub3Qgc2V0CkNPTkZJR19CTEtfREVWX1JBTT15CkNPTkZJ
R19CTEtfREVWX1JBTV9DT1VOVD0xNgpDT05GSUdfQkxLX0RFVl9SQU1fU0laRT00MDk2CkNP
TkZJR19CTEtfREVWX1hJUD15CiMgQ09ORklHX0NEUk9NX1BLVENEVkQgaXMgbm90IHNldAoj
IENPTkZJR19BVEFfT1ZFUl9FVEggaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX0hEIGlz
IG5vdCBzZXQKIyBDT05GSUdfTUlTQ19ERVZJQ0VTIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVf
SURFPXkKIyBDT05GSUdfSURFIGlzIG5vdCBzZXQKCiMKIyBTQ1NJIGRldmljZSBzdXBwb3J0
CiMKQ09ORklHX1JBSURfQVRUUlM9eQpDT05GSUdfU0NTST15CkNPTkZJR19TQ1NJX0RNQT15
CiMgQ09ORklHX1NDU0lfTkVUTElOSyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfUFJPQ19G
UyBpcyBub3Qgc2V0CgojCiMgU0NTSSBzdXBwb3J0IHR5cGUgKGRpc2ssIHRhcGUsIENELVJP
TSkKIwpDT05GSUdfQkxLX0RFVl9TRD15CiMgQ09ORklHX0NIUl9ERVZfU1QgaXMgbm90IHNl
dAojIENPTkZJR19DSFJfREVWX09TU1QgaXMgbm90IHNldApDT05GSUdfQkxLX0RFVl9TUj15
CkNPTkZJR19CTEtfREVWX1NSX1ZFTkRPUj15CkNPTkZJR19DSFJfREVWX1NHPXkKIyBDT05G
SUdfQ0hSX0RFVl9TQ0ggaXMgbm90IHNldAoKIwojIFNvbWUgU0NTSSBkZXZpY2VzIChlLmcu
IENEIGp1a2Vib3gpIHN1cHBvcnQgbXVsdGlwbGUgTFVOcwojCkNPTkZJR19TQ1NJX01VTFRJ
X0xVTj15CiMgQ09ORklHX1NDU0lfQ09OU1RBTlRTIGlzIG5vdCBzZXQKQ09ORklHX1NDU0lf
TE9HR0lORz15CkNPTkZJR19TQ1NJX1NDQU5fQVNZTkM9eQoKIwojIFNDU0kgVHJhbnNwb3J0
cwojCkNPTkZJR19TQ1NJX1NQSV9BVFRSUz15CiMgQ09ORklHX1NDU0lfRkNfQVRUUlMgaXMg
bm90IHNldAojIENPTkZJR19TQ1NJX0lTQ1NJX0FUVFJTIGlzIG5vdCBzZXQKIyBDT05GSUdf
U0NTSV9TQVNfTElCU0FTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9TUlBfQVRUUlMgaXMg
bm90IHNldApDT05GSUdfU0NTSV9MT1dMRVZFTD15CiMgQ09ORklHX0lTQ1NJX1RDUCBpcyBu
b3Qgc2V0CkNPTkZJR19CTEtfREVWXzNXX1hYWFhfUkFJRD15CiMgQ09ORklHX1NDU0lfM1df
OVhYWCBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfNzAwMEZBU1NUIGlzIG5vdCBzZXQKIyBD
T05GSUdfU0NTSV9BQ0FSRCBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfQUhBMTUyWCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NDU0lfQUhBMTU0MiBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lf
QUhBMTc0MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfQUFDUkFJRCBpcyBub3Qgc2V0CiMg
Q09ORklHX1NDU0lfQUlDN1hYWCBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfQUlDN1hYWF9P
TEQgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0FJQzc5WFggaXMgbm90IHNldAojIENPTkZJ
R19TQ1NJX0FJQzk0WFggaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0RQVF9JMk8gaXMgbm90
IHNldAojIENPTkZJR19TQ1NJX0FEVkFOU1lTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9J
TjIwMDAgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0FSQ01TUiBpcyBub3Qgc2V0CiMgQ09O
RklHX01FR0FSQUlEX05FV0dFTiBpcyBub3Qgc2V0CiMgQ09ORklHX01FR0FSQUlEX0xFR0FD
WSBpcyBub3Qgc2V0CiMgQ09ORklHX01FR0FSQUlEX1NBUyBpcyBub3Qgc2V0CiMgQ09ORklH
X1NDU0lfTVBUMlNBUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfSFBUSU9QIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0NTSV9CVVNMT0dJQyBpcyBub3Qgc2V0CiMgQ09ORklHX0xJQkZDIGlz
IG5vdCBzZXQKIyBDT05GSUdfTElCRkNPRSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZDT0UgaXMg
bm90IHNldAojIENPTkZJR19GQ09FX0ZOSUMgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0RN
WDMxOTFEIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9EVEMzMjgwIGlzIG5vdCBzZXQKIyBD
T05GSUdfU0NTSV9FQVRBIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9GVVRVUkVfRE9NQUlO
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9HRFRIIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NT
SV9HRU5FUklDX05DUjUzODAgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0dFTkVSSUNfTkNS
NTM4MF9NTUlPIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9JUFMgaXMgbm90IHNldAojIENP
TkZJR19TQ1NJX0lOSVRJTyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfSU5JQTEwMCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NDU0lfTVZTQVMgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX05D
UjUzQzQwNkEgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX1NURVggaXMgbm90IHNldAojIENP
TkZJR19TQ1NJX1NZTTUzQzhYWF8yIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9QQVMxNiBp
cyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfUUxPR0lDX0ZBUyBpcyBub3Qgc2V0CiMgQ09ORklH
X1NDU0lfUUxPR0lDXzEyODAgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX1FMQV9GQyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NDU0lfUUxBX0lTQ1NJIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NT
SV9MUEZDIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9TSU03MTAgaXMgbm90IHNldAojIENP
TkZJR19TQ1NJX1NZTTUzQzQxNiBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfREMzOTBUIGlz
IG5vdCBzZXQKIyBDT05GSUdfU0NTSV9UMTI4IGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9V
MTRfMzRGIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9VTFRSQVNUT1IgaXMgbm90IHNldAoj
IENPTkZJR19TQ1NJX05TUDMyIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9ERUJVRyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NDU0lfU1JQIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9ESCBp
cyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfT1NEX0lOSVRJQVRPUiBpcyBub3Qgc2V0CiMgQ09O
RklHX0FUQSBpcyBub3Qgc2V0CiMgQ09ORklHX01EIGlzIG5vdCBzZXQKIyBDT05GSUdfRlVT
SU9OIGlzIG5vdCBzZXQKCiMKIyBJRUVFIDEzOTQgKEZpcmVXaXJlKSBzdXBwb3J0CiMKCiMK
IyBBIG5ldyBhbHRlcm5hdGl2ZSBGaXJlV2lyZSBzdGFjayBpcyBhdmFpbGFibGUgd2l0aCBF
WFBFUklNRU5UQUw9eQojCiMgQ09ORklHX0lFRUUxMzk0IGlzIG5vdCBzZXQKQ09ORklHX0ky
Tz15CkNPTkZJR19JMk9fTENUX05PVElGWV9PTl9DSEFOR0VTPXkKQ09ORklHX0kyT19FWFRf
QURBUFRFQz15CkNPTkZJR19JMk9fQ09ORklHPXkKIyBDT05GSUdfSTJPX0NPTkZJR19PTERf
SU9DVEwgaXMgbm90IHNldApDT05GSUdfSTJPX0JVUz15CkNPTkZJR19JMk9fQkxPQ0s9eQpD
T05GSUdfSTJPX1NDU0k9eQpDT05GSUdfSTJPX1BST0M9eQojIENPTkZJR19NQUNJTlRPU0hf
RFJJVkVSUyBpcyBub3Qgc2V0CkNPTkZJR19ORVRERVZJQ0VTPXkKQ09ORklHX0NPTVBBVF9O
RVRfREVWX09QUz15CkNPTkZJR19JRkI9eQpDT05GSUdfRFVNTVk9eQojIENPTkZJR19CT05E
SU5HIGlzIG5vdCBzZXQKIyBDT05GSUdfRVFVQUxJWkVSIGlzIG5vdCBzZXQKQ09ORklHX1RV
Tj15CiMgQ09ORklHX1ZFVEggaXMgbm90IHNldAojIENPTkZJR19ORVRfU0IxMDAwIGlzIG5v
dCBzZXQKIyBDT05GSUdfQVJDTkVUIGlzIG5vdCBzZXQKQ09ORklHX1BIWUxJQj15CgojCiMg
TUlJIFBIWSBkZXZpY2UgZHJpdmVycwojCiMgQ09ORklHX01BUlZFTExfUEhZIGlzIG5vdCBz
ZXQKIyBDT05GSUdfREFWSUNPTV9QSFkgaXMgbm90IHNldAojIENPTkZJR19RU0VNSV9QSFkg
aXMgbm90IHNldApDT05GSUdfTFhUX1BIWT15CiMgQ09ORklHX0NJQ0FEQV9QSFkgaXMgbm90
IHNldAojIENPTkZJR19WSVRFU1NFX1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX1NNU0NfUEhZ
IGlzIG5vdCBzZXQKQ09ORklHX0JST0FEQ09NX1BIWT15CiMgQ09ORklHX0lDUExVU19QSFkg
aXMgbm90IHNldAojIENPTkZJR19SRUFMVEVLX1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX05B
VElPTkFMX1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX1NURTEwWFAgaXMgbm90IHNldAojIENP
TkZJR19MU0lfRVQxMDExQ19QSFkgaXMgbm90IHNldAojIENPTkZJR19GSVhFRF9QSFkgaXMg
bm90IHNldAojIENPTkZJR19NRElPX0JJVEJBTkcgaXMgbm90IHNldApDT05GSUdfTkVUX0VU
SEVSTkVUPXkKQ09ORklHX01JST15CiMgQ09ORklHX0hBUFBZTUVBTCBpcyBub3Qgc2V0CiMg
Q09ORklHX1NVTkdFTSBpcyBub3Qgc2V0CiMgQ09ORklHX0NBU1NJTkkgaXMgbm90IHNldApD
T05GSUdfTkVUX1ZFTkRPUl8zQ09NPXkKIyBDT05GSUdfRUwxIGlzIG5vdCBzZXQKIyBDT05G
SUdfRUwyIGlzIG5vdCBzZXQKIyBDT05GSUdfRUxQTFVTIGlzIG5vdCBzZXQKIyBDT05GSUdf
RUwzIGlzIG5vdCBzZXQKIyBDT05GSUdfM0M1MTUgaXMgbm90IHNldApDT05GSUdfVk9SVEVY
PXkKIyBDT05GSUdfVFlQSE9PTiBpcyBub3Qgc2V0CiMgQ09ORklHX0xBTkNFIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTkVUX1ZFTkRPUl9TTUMgaXMgbm90IHNldAojIENPTkZJR19FVEhPQyBp
cyBub3Qgc2V0CiMgQ09ORklHX05FVF9WRU5ET1JfUkFDQUwgaXMgbm90IHNldAojIENPTkZJ
R19ETkVUIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1RVTElQIGlzIG5vdCBzZXQKIyBDT05G
SUdfREVQQ0EgaXMgbm90IHNldAojIENPTkZJR19IUDEwMCBpcyBub3Qgc2V0CiMgQ09ORklH
X05FVF9JU0EgaXMgbm90IHNldAojIENPTkZJR19JQk1fTkVXX0VNQUNfWk1JSSBpcyBub3Qg
c2V0CiMgQ09ORklHX0lCTV9ORVdfRU1BQ19SR01JSSBpcyBub3Qgc2V0CiMgQ09ORklHX0lC
TV9ORVdfRU1BQ19UQUggaXMgbm90IHNldAojIENPTkZJR19JQk1fTkVXX0VNQUNfRU1BQzQg
aXMgbm90IHNldAojIENPTkZJR19JQk1fTkVXX0VNQUNfTk9fRkxPV19DVFJMIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSUJNX05FV19FTUFDX01BTF9DTFJfSUNJTlRTVEFUIGlzIG5vdCBzZXQK
IyBDT05GSUdfSUJNX05FV19FTUFDX01BTF9DT01NT05fRVJSIGlzIG5vdCBzZXQKQ09ORklH
X05FVF9QQ0k9eQojIENPTkZJR19QQ05FVDMyIGlzIG5vdCBzZXQKIyBDT05GSUdfQU1EODEx
MV9FVEggaXMgbm90IHNldAojIENPTkZJR19BREFQVEVDX1NUQVJGSVJFIGlzIG5vdCBzZXQK
IyBDT05GSUdfQVBSSUNPVCBpcyBub3Qgc2V0CiMgQ09ORklHX0I0NCBpcyBub3Qgc2V0CiMg
Q09ORklHX0ZPUkNFREVUSCBpcyBub3Qgc2V0CiMgQ09ORklHX0NTODl4MCBpcyBub3Qgc2V0
CkNPTkZJR19FMTAwPXkKIyBDT05GSUdfRkVBTE5YIGlzIG5vdCBzZXQKIyBDT05GSUdfTkFU
U0VNSSBpcyBub3Qgc2V0CiMgQ09ORklHX05FMktfUENJIGlzIG5vdCBzZXQKIyBDT05GSUdf
ODEzOVRPTyBpcyBub3Qgc2V0CiMgQ09ORklHX1I2MDQwIGlzIG5vdCBzZXQKIyBDT05GSUdf
U0lTOTAwIGlzIG5vdCBzZXQKIyBDT05GSUdfRVBJQzEwMCBpcyBub3Qgc2V0CiMgQ09ORklH
X1NNU0M5NDIwIGlzIG5vdCBzZXQKIyBDT05GSUdfU1VOREFOQ0UgaXMgbm90IHNldAojIENP
TkZJR19UTEFOIGlzIG5vdCBzZXQKIyBDT05GSUdfVklBX1JISU5FIGlzIG5vdCBzZXQKIyBD
T05GSUdfQVRMMiBpcyBub3Qgc2V0CkNPTkZJR19ORVRERVZfMTAwMD15CiMgQ09ORklHX0FD
RU5JQyBpcyBub3Qgc2V0CiMgQ09ORklHX0RMMksgaXMgbm90IHNldAojIENPTkZJR19FMTAw
MCBpcyBub3Qgc2V0CiMgQ09ORklHX0UxMDAwRSBpcyBub3Qgc2V0CiMgQ09ORklHX0lHQiBp
cyBub3Qgc2V0CiMgQ09ORklHX0lHQlZGIGlzIG5vdCBzZXQKIyBDT05GSUdfTlM4MzgyMCBp
cyBub3Qgc2V0CiMgQ09ORklHX0hBTUFDSEkgaXMgbm90IHNldAojIENPTkZJR19SODE2OSBp
cyBub3Qgc2V0CiMgQ09ORklHX1NJUzE5MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NLR0UgaXMg
bm90IHNldAojIENPTkZJR19TS1kyIGlzIG5vdCBzZXQKIyBDT05GSUdfVklBX1ZFTE9DSVRZ
IGlzIG5vdCBzZXQKQ09ORklHX1RJR09OMz15CkNPTkZJR19CTlgyPXkKIyBDT05GSUdfUUxB
M1hYWCBpcyBub3Qgc2V0CiMgQ09ORklHX0FUTDEgaXMgbm90IHNldAojIENPTkZJR19KTUUg
aXMgbm90IHNldAojIENPTkZJR19ORVRERVZfMTAwMDAgaXMgbm90IHNldAojIENPTkZJR19U
UiBpcyBub3Qgc2V0CgojCiMgV2lyZWxlc3MgTEFOCiMKIyBDT05GSUdfV0xBTl9QUkU4MDIx
MSBpcyBub3Qgc2V0CiMgQ09ORklHX1dMQU5fODAyMTEgaXMgbm90IHNldAoKIwojIEVuYWJs
ZSBXaU1BWCAoTmV0d29ya2luZyBvcHRpb25zKSB0byBzZWUgdGhlIFdpTUFYIGRyaXZlcnMK
IwoKIwojIFVTQiBOZXR3b3JrIEFkYXB0ZXJzCiMKIyBDT05GSUdfVVNCX0tBV0VUSCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1VTQl9QRUdBU1VTIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1VT
Qk5FVCBpcyBub3Qgc2V0CiMgQ09ORklHX1dBTiBpcyBub3Qgc2V0CiMgQ09ORklHX0ZEREkg
aXMgbm90IHNldApDT05GSUdfUFBQPXkKQ09ORklHX1BQUF9GSUxURVI9eQpDT05GSUdfUFBQ
X0FTWU5DPXkKQ09ORklHX1BQUF9TWU5DX1RUWT15CkNPTkZJR19QUFBfREVGTEFURT15CkNP
TkZJR19QUFBfQlNEQ09NUD15CiMgQ09ORklHX1NMSVAgaXMgbm90IHNldApDT05GSUdfU0xI
Qz15CiMgQ09ORklHX05FVF9GQyBpcyBub3Qgc2V0CiMgQ09ORklHX05FVFBPTEwgaXMgbm90
IHNldAojIENPTkZJR19ORVRfUE9MTF9DT05UUk9MTEVSIGlzIG5vdCBzZXQKIyBDT05GSUdf
SVNETiBpcyBub3Qgc2V0CiMgQ09ORklHX1BIT05FIGlzIG5vdCBzZXQKCiMKIyBJbnB1dCBk
ZXZpY2Ugc3VwcG9ydAojCkNPTkZJR19JTlBVVD15CkNPTkZJR19JTlBVVF9GRl9NRU1MRVNT
PXkKQ09ORklHX0lOUFVUX1BPTExERVY9eQoKIwojIFVzZXJsYW5kIGludGVyZmFjZXMKIwpD
T05GSUdfSU5QVVRfTU9VU0VERVY9eQpDT05GSUdfSU5QVVRfTU9VU0VERVZfUFNBVVg9eQpD
T05GSUdfSU5QVVRfTU9VU0VERVZfU0NSRUVOX1g9MTAyNApDT05GSUdfSU5QVVRfTU9VU0VE
RVZfU0NSRUVOX1k9NzY4CiMgQ09ORklHX0lOUFVUX0pPWURFViBpcyBub3Qgc2V0CkNPTkZJ
R19JTlBVVF9FVkRFVj15CiMgQ09ORklHX0lOUFVUX0VWQlVHIGlzIG5vdCBzZXQKCiMKIyBJ
bnB1dCBEZXZpY2UgRHJpdmVycwojCkNPTkZJR19JTlBVVF9LRVlCT0FSRD15CkNPTkZJR19L
RVlCT0FSRF9BVEtCRD15CiMgQ09ORklHX0tFWUJPQVJEX1NVTktCRCBpcyBub3Qgc2V0CiMg
Q09ORklHX0tFWUJPQVJEX0xLS0JEIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfWFRL
QkQgaXMgbm90IHNldAojIENPTkZJR19LRVlCT0FSRF9ORVdUT04gaXMgbm90IHNldAojIENP
TkZJR19LRVlCT0FSRF9TVE9XQVdBWSBpcyBub3Qgc2V0CkNPTkZJR19JTlBVVF9NT1VTRT15
CkNPTkZJR19NT1VTRV9QUzI9eQpDT05GSUdfTU9VU0VfUFMyX0FMUFM9eQpDT05GSUdfTU9V
U0VfUFMyX0xPR0lQUzJQUD15CkNPTkZJR19NT1VTRV9QUzJfU1lOQVBUSUNTPXkKQ09ORklH
X01PVVNFX1BTMl9MSUZFQk9PSz15CkNPTkZJR19NT1VTRV9QUzJfVFJBQ0tQT0lOVD15CiMg
Q09ORklHX01PVVNFX1BTMl9FTEFOVEVDSCBpcyBub3Qgc2V0CiMgQ09ORklHX01PVVNFX1BT
Ml9UT1VDSEtJVCBpcyBub3Qgc2V0CiMgQ09ORklHX01PVVNFX1NFUklBTCBpcyBub3Qgc2V0
CiMgQ09ORklHX01PVVNFX0FQUExFVE9VQ0ggaXMgbm90IHNldAojIENPTkZJR19NT1VTRV9C
Q001OTc0IGlzIG5vdCBzZXQKIyBDT05GSUdfTU9VU0VfSU5QT1JUIGlzIG5vdCBzZXQKIyBD
T05GSUdfTU9VU0VfTE9HSUJNIGlzIG5vdCBzZXQKIyBDT05GSUdfTU9VU0VfUEMxMTBQQUQg
aXMgbm90IHNldAojIENPTkZJR19NT1VTRV9WU1hYWEFBIGlzIG5vdCBzZXQKIyBDT05GSUdf
SU5QVVRfSk9ZU1RJQ0sgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9UQUJMRVQgaXMgbm90
IHNldAojIENPTkZJR19JTlBVVF9UT1VDSFNDUkVFTiBpcyBub3Qgc2V0CkNPTkZJR19JTlBV
VF9NSVNDPXkKIyBDT05GSUdfSU5QVVRfUENTUEtSIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5Q
VVRfV0lTVFJPTl9CVE5TIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfQVRMQVNfQlROUyBp
cyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0FUSV9SRU1PVEUgaXMgbm90IHNldAojIENPTkZJ
R19JTlBVVF9BVElfUkVNT1RFMiBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX1BPV0VSTUFU
RSBpcyBub3Qgc2V0CkNPTkZJR19JTlBVVF9VSU5QVVQ9eQoKIwojIEhhcmR3YXJlIEkvTyBw
b3J0cwojCkNPTkZJR19TRVJJTz15CkNPTkZJR19TRVJJT19JODA0Mj15CkNPTkZJR19TRVJJ
T19TRVJQT1JUPXkKIyBDT05GSUdfU0VSSU9fQ1Q4MkM3MTAgaXMgbm90IHNldAojIENPTkZJ
R19TRVJJT19QQ0lQUzIgaXMgbm90IHNldApDT05GSUdfU0VSSU9fTElCUFMyPXkKIyBDT05G
SUdfU0VSSU9fUkFXIGlzIG5vdCBzZXQKIyBDT05GSUdfR0FNRVBPUlQgaXMgbm90IHNldAoK
IwojIENoYXJhY3RlciBkZXZpY2VzCiMKQ09ORklHX1ZUPXkKQ09ORklHX0NPTlNPTEVfVFJB
TlNMQVRJT05TPXkKQ09ORklHX1ZUX0NPTlNPTEU9eQpDT05GSUdfSFdfQ09OU09MRT15CkNP
TkZJR19WVF9IV19DT05TT0xFX0JJTkRJTkc9eQpDT05GSUdfREVWS01FTT15CiMgQ09ORklH
X1NFUklBTF9OT05TVEFOREFSRCBpcyBub3Qgc2V0CgojCiMgU2VyaWFsIGRyaXZlcnMKIwpD
T05GSUdfU0VSSUFMXzgyNTA9eQojIENPTkZJR19TRVJJQUxfODI1MF9DT05TT0xFIGlzIG5v
dCBzZXQKQ09ORklHX0ZJWF9FQVJMWUNPTl9NRU09eQpDT05GSUdfU0VSSUFMXzgyNTBfUENJ
PXkKQ09ORklHX1NFUklBTF84MjUwX1BOUD15CkNPTkZJR19TRVJJQUxfODI1MF9OUl9VQVJU
Uz0yCkNPTkZJR19TRVJJQUxfODI1MF9SVU5USU1FX1VBUlRTPTIKIyBDT05GSUdfU0VSSUFM
XzgyNTBfRVhURU5ERUQgaXMgbm90IHNldAoKIwojIE5vbi04MjUwIHNlcmlhbCBwb3J0IHN1
cHBvcnQKIwpDT05GSUdfU0VSSUFMX0NPUkU9eQojIENPTkZJR19TRVJJQUxfSlNNIGlzIG5v
dCBzZXQKQ09ORklHX1VOSVg5OF9QVFlTPXkKIyBDT05GSUdfREVWUFRTX01VTFRJUExFX0lO
U1RBTkNFUyBpcyBub3Qgc2V0CkNPTkZJR19MRUdBQ1lfUFRZUz15CkNPTkZJR19MRUdBQ1lf
UFRZX0NPVU5UPTI1NgpDT05GSUdfSVBNSV9IQU5ETEVSPXkKQ09ORklHX0lQTUlfUEFOSUNf
RVZFTlQ9eQpDT05GSUdfSVBNSV9QQU5JQ19TVFJJTkc9eQpDT05GSUdfSVBNSV9ERVZJQ0Vf
SU5URVJGQUNFPXkKQ09ORklHX0lQTUlfU0k9eQpDT05GSUdfSVBNSV9XQVRDSERPRz15CkNP
TkZJR19JUE1JX1BPV0VST0ZGPXkKQ09ORklHX0hXX1JBTkRPTT15CkNPTkZJR19IV19SQU5E
T01fVElNRVJJT01FTT15CkNPTkZJR19IV19SQU5ET01fSU5URUw9eQojIENPTkZJR19IV19S
QU5ET01fQU1EIGlzIG5vdCBzZXQKIyBDT05GSUdfSFdfUkFORE9NX0dFT0RFIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSFdfUkFORE9NX1ZJQSBpcyBub3Qgc2V0CkNPTkZJR19OVlJBTT15CiMg
Q09ORklHX0RUTEsgaXMgbm90IHNldAojIENPTkZJR19SMzk2NCBpcyBub3Qgc2V0CiMgQ09O
RklHX0FQUExJQ09NIGlzIG5vdCBzZXQKIyBDT05GSUdfTVdBVkUgaXMgbm90IHNldAojIENP
TkZJR19QQzg3MzZ4X0dQSU8gaXMgbm90IHNldAojIENPTkZJR19OU0NfR1BJTyBpcyBub3Qg
c2V0CiMgQ09ORklHX0NTNTUzNV9HUElPIGlzIG5vdCBzZXQKIyBDT05GSUdfUkFXX0RSSVZF
UiBpcyBub3Qgc2V0CkNPTkZJR19IUEVUPXkKQ09ORklHX0hQRVRfTU1BUD15CkNPTkZJR19I
QU5HQ0hFQ0tfVElNRVI9eQpDT05GSUdfREVWUE9SVD15CkNPTkZJR19JMkM9eQpDT05GSUdf
STJDX0JPQVJESU5GTz15CkNPTkZJR19JMkNfQ0hBUkRFVj15CkNPTkZJR19JMkNfSEVMUEVS
X0FVVE89eQpDT05GSUdfSTJDX0FMR09QQ0E9eQoKIwojIEkyQyBIYXJkd2FyZSBCdXMgc3Vw
cG9ydAojCgojCiMgUEMgU01CdXMgaG9zdCBjb250cm9sbGVyIGRyaXZlcnMKIwojIENPTkZJ
R19JMkNfQUxJMTUzNSBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19BTEkxNVgzIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSTJDX0FNRDc1NiBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19BTUQ4MTEx
IGlzIG5vdCBzZXQKQ09ORklHX0kyQ19JODAxPXkKQ09ORklHX0kyQ19JU0NIPXkKQ09ORklH
X0kyQ19QSUlYND15CiMgQ09ORklHX0kyQ19ORk9SQ0UyIGlzIG5vdCBzZXQKIyBDT05GSUdf
STJDX1NJUzU1OTUgaXMgbm90IHNldAojIENPTkZJR19JMkNfU0lTNjMwIGlzIG5vdCBzZXQK
IyBDT05GSUdfSTJDX1NJUzk2WCBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19WSUFQUk8gaXMg
bm90IHNldAoKIwojIEkyQyBzeXN0ZW0gYnVzIGRyaXZlcnMgKG1vc3RseSBlbWJlZGRlZCAv
IHN5c3RlbS1vbi1jaGlwKQojCiMgQ09ORklHX0kyQ19TSU1URUMgaXMgbm90IHNldAoKIwoj
IEV4dGVybmFsIEkyQy9TTUJ1cyBhZGFwdGVyIGRyaXZlcnMKIwojIENPTkZJR19JMkNfUEFS
UE9SVF9MSUdIVCBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19USU5ZX1VTQiBpcyBub3Qgc2V0
CgojCiMgR3JhcGhpY3MgYWRhcHRlciBJMkMvRERDIGNoYW5uZWwgZHJpdmVycwojCiMgQ09O
RklHX0kyQ19WT09ET08zIGlzIG5vdCBzZXQKCiMKIyBPdGhlciBJMkMvU01CdXMgYnVzIGRy
aXZlcnMKIwojIENPTkZJR19JMkNfUENBX0lTQSBpcyBub3Qgc2V0CkNPTkZJR19JMkNfUENB
X1BMQVRGT1JNPXkKIyBDT05GSUdfU0N4MjAwX0FDQiBpcyBub3Qgc2V0CgojCiMgTWlzY2Vs
bGFuZW91cyBJMkMgQ2hpcCBzdXBwb3J0CiMKIyBDT05GSUdfUENGODU3NSBpcyBub3Qgc2V0
CiMgQ09ORklHX0kyQ19ERUJVR19DT1JFIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX0RFQlVH
X0FMR08gaXMgbm90IHNldAojIENPTkZJR19JMkNfREVCVUdfQlVTIGlzIG5vdCBzZXQKIyBD
T05GSUdfSTJDX0RFQlVHX0NISVAgaXMgbm90IHNldAojIENPTkZJR19TUEkgaXMgbm90IHNl
dApDT05GSUdfQVJDSF9XQU5UX09QVElPTkFMX0dQSU9MSUI9eQojIENPTkZJR19HUElPTElC
IGlzIG5vdCBzZXQKIyBDT05GSUdfVzEgaXMgbm90IHNldApDT05GSUdfUE9XRVJfU1VQUExZ
PXkKIyBDT05GSUdfUE9XRVJfU1VQUExZX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfUERB
X1BPV0VSIGlzIG5vdCBzZXQKIyBDT05GSUdfQkFUVEVSWV9EUzI3NjAgaXMgbm90IHNldAoj
IENPTkZJR19CQVRURVJZX0JRMjd4MDAgaXMgbm90IHNldApDT05GSUdfSFdNT049eQpDT05G
SUdfSFdNT05fVklEPXkKIyBDT05GSUdfU0VOU09SU19BRE0xMDIxIGlzIG5vdCBzZXQKIyBD
T05GSUdfU0VOU09SU19BRE0xMDI1IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRE05
MjQwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19EUzE2MjEgaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX0ZTQ0hFUiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfRlNDUE9T
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19GU0NITUQgaXMgbm90IHNldApDT05GSUdf
U0VOU09SU19HNzYwQT15CiMgQ09ORklHX1NFTlNPUlNfR0w1MThTTSBpcyBub3Qgc2V0CiMg
Q09ORklHX1NFTlNPUlNfR0w1MjBTTSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfSUJN
QUVNIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19JQk1QRVggaXMgbm90IHNldApDT05G
SUdfU0VOU09SU19JVDg3PXkKQ09ORklHX1NFTlNPUlNfTE02Mz15CkNPTkZJR19TRU5TT1JT
X0xNNzU9eQpDT05GSUdfU0VOU09SU19MTTc3PXkKQ09ORklHX1NFTlNPUlNfTE03OD15CkNP
TkZJR19TRU5TT1JTX0xNODM9eQpDT05GSUdfU0VOU09SU19MTTg3PXkKQ09ORklHX1NFTlNP
UlNfTE05MD15CiMgQ09ORklHX1NFTlNPUlNfTE05MiBpcyBub3Qgc2V0CiMgQ09ORklHX1NF
TlNPUlNfTE05MyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE05NTI0MSBpcyBub3Qg
c2V0CiMgQ09ORklHX1NFTlNPUlNfTUFYMTYxOSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNP
UlNfUEM4NzM2MCBpcyBub3Qgc2V0CkNPTkZJR19TRU5TT1JTX1BDRjg1OTE9eQojIENPTkZJ
R19TRU5TT1JTX1NJUzU1OTUgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1NNU0M0N00x
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRFM3ODI4IGlzIG5vdCBzZXQKIyBDT05G
SUdfU0VOU09SU19WSUE2ODZBIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19WVDgyMzEg
aXMgbm90IHNldApDT05GSUdfU0VOU09SU19XODM3ODFEPXkKQ09ORklHX1NFTlNPUlNfVzgz
NjI3SEY9eQpDT05GSUdfU0VOU09SU19XODM2MjdFSEY9eQojIENPTkZJR19TRU5TT1JTX0hE
QVBTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MSVMzTFYwMkQgaXMgbm90IHNldAoj
IENPTkZJR19TRU5TT1JTX0FQUExFU01DIGlzIG5vdCBzZXQKIyBDT05GSUdfSFdNT05fREVC
VUdfQ0hJUCBpcyBub3Qgc2V0CkNPTkZJR19USEVSTUFMPXkKQ09ORklHX1RIRVJNQUxfSFdN
T049eQpDT05GSUdfV0FUQ0hET0c9eQojIENPTkZJR19XQVRDSERPR19OT1dBWU9VVCBpcyBu
b3Qgc2V0CgojCiMgV2F0Y2hkb2cgRGV2aWNlIERyaXZlcnMKIwojIENPTkZJR19TT0ZUX1dB
VENIRE9HIGlzIG5vdCBzZXQKIyBDT05GSUdfQUNRVUlSRV9XRFQgaXMgbm90IHNldAojIENP
TkZJR19BRFZBTlRFQ0hfV0RUIGlzIG5vdCBzZXQKQ09ORklHX0FMSU0xNTM1X1dEVD15CiMg
Q09ORklHX0FMSU03MTAxX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NDNTIwX1dEVCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0VVUk9URUNIX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX0lCNzAw
X1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX0lCTUFTUiBpcyBub3Qgc2V0CiMgQ09ORklHX1dB
RkVSX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX0k2MzAwRVNCX1dEVCBpcyBub3Qgc2V0CkNP
TkZJR19JVENPX1dEVD15CkNPTkZJR19JVENPX1ZFTkRPUl9TVVBQT1JUPXkKQ09ORklHX0lU
ODcxMkZfV0RUPXkKIyBDT05GSUdfSFBfV0FUQ0hET0cgaXMgbm90IHNldAojIENPTkZJR19T
QzEyMDBfV0RUIGlzIG5vdCBzZXQKIyBDT05GSUdfUEM4NzQxM19XRFQgaXMgbm90IHNldAoj
IENPTkZJR182MFhYX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NCQzgzNjBfV0RUIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0JDNzI0MF9XRFQgaXMgbm90IHNldAojIENPTkZJR19DUFU1X1dE
VCBpcyBub3Qgc2V0CiMgQ09ORklHX1NNU0NfU0NIMzExWF9XRFQgaXMgbm90IHNldApDT05G
SUdfU01TQzM3Qjc4N19XRFQ9eQpDT05GSUdfVzgzNjI3SEZfV0RUPXkKQ09ORklHX1c4MzY5
N0hGX1dEVD15CkNPTkZJR19XODM2OTdVR19XRFQ9eQpDT05GSUdfVzgzODc3Rl9XRFQ9eQpD
T05GSUdfVzgzOTc3Rl9XRFQ9eQojIENPTkZJR19NQUNIWl9XRFQgaXMgbm90IHNldAojIENP
TkZJR19TQkNfRVBYX0MzX1dBVENIRE9HIGlzIG5vdCBzZXQKCiMKIyBJU0EtYmFzZWQgV2F0
Y2hkb2cgQ2FyZHMKIwojIENPTkZJR19QQ1dBVENIRE9HIGlzIG5vdCBzZXQKIyBDT05GSUdf
TUlYQ09NV0QgaXMgbm90IHNldAojIENPTkZJR19XRFQgaXMgbm90IHNldAoKIwojIFBDSS1i
YXNlZCBXYXRjaGRvZyBDYXJkcwojCiMgQ09ORklHX1BDSVBDV0FUQ0hET0cgaXMgbm90IHNl
dAojIENPTkZJR19XRFRQQ0kgaXMgbm90IHNldAoKIwojIFVTQi1iYXNlZCBXYXRjaGRvZyBD
YXJkcwojCiMgQ09ORklHX1VTQlBDV0FUQ0hET0cgaXMgbm90IHNldApDT05GSUdfU1NCX1BP
U1NJQkxFPXkKCiMKIyBTb25pY3MgU2lsaWNvbiBCYWNrcGxhbmUKIwojIENPTkZJR19TU0Ig
aXMgbm90IHNldAoKIwojIE11bHRpZnVuY3Rpb24gZGV2aWNlIGRyaXZlcnMKIwojIENPTkZJ
R19NRkRfQ09SRSBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9TTTUwMSBpcyBub3Qgc2V0CiMg
Q09ORklHX0hUQ19QQVNJQzMgaXMgbm90IHNldAojIENPTkZJR19UV0w0MDMwX0NPUkUgaXMg
bm90IHNldAojIENPTkZJR19NRkRfVE1JTyBpcyBub3Qgc2V0CiMgQ09ORklHX1BNSUNfREE5
MDNYIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1dNODQwMCBpcyBub3Qgc2V0CiMgQ09ORklH
X01GRF9XTTgzNTBfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1BDRjUwNjMzIGlzIG5v
dCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SIGlzIG5vdCBzZXQKCiMKIyBNdWx0aW1lZGlhIGRl
dmljZXMKIwoKIwojIE11bHRpbWVkaWEgY29yZSBzdXBwb3J0CiMKIyBDT05GSUdfVklERU9f
REVWIGlzIG5vdCBzZXQKIyBDT05GSUdfRFZCX0NPUkUgaXMgbm90IHNldAojIENPTkZJR19W
SURFT19NRURJQSBpcyBub3Qgc2V0CgojCiMgTXVsdGltZWRpYSBkcml2ZXJzCiMKIyBDT05G
SUdfREFCIGlzIG5vdCBzZXQKCiMKIyBHcmFwaGljcyBzdXBwb3J0CiMKQ09ORklHX0FHUD15
CiMgQ09ORklHX0FHUF9BTEkgaXMgbm90IHNldAojIENPTkZJR19BR1BfQVRJIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQUdQX0FNRCBpcyBub3Qgc2V0CiMgQ09ORklHX0FHUF9BTUQ2NCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0FHUF9JTlRFTCBpcyBub3Qgc2V0CiMgQ09ORklHX0FHUF9OVklE
SUEgaXMgbm90IHNldAojIENPTkZJR19BR1BfU0lTIGlzIG5vdCBzZXQKQ09ORklHX0FHUF9T
V09SS1M9eQojIENPTkZJR19BR1BfVklBIGlzIG5vdCBzZXQKIyBDT05GSUdfQUdQX0VGRklD
RU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNIGlzIG5vdCBzZXQKIyBDT05GSUdfVkdBU1RB
VEUgaXMgbm90IHNldApDT05GSUdfVklERU9fT1VUUFVUX0NPTlRST0w9eQpDT05GSUdfRkI9
eQpDT05GSUdfRklSTVdBUkVfRURJRD15CiMgQ09ORklHX0ZCX0REQyBpcyBub3Qgc2V0CkNP
TkZJR19GQl9CT09UX1ZFU0FfU1VQUE9SVD15CkNPTkZJR19GQl9DRkJfRklMTFJFQ1Q9eQpD
T05GSUdfRkJfQ0ZCX0NPUFlBUkVBPXkKQ09ORklHX0ZCX0NGQl9JTUFHRUJMSVQ9eQojIENP
TkZJR19GQl9DRkJfUkVWX1BJWEVMU19JTl9CWVRFIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJf
U1lTX0ZJTExSRUNUIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfU1lTX0NPUFlBUkVBIGlzIG5v
dCBzZXQKIyBDT05GSUdfRkJfU1lTX0lNQUdFQkxJVCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZC
X0ZPUkVJR05fRU5ESUFOIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfU1lTX0ZPUFMgaXMgbm90
IHNldAojIENPTkZJR19GQl9TVkdBTElCIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfTUFDTU9E
RVMgaXMgbm90IHNldAojIENPTkZJR19GQl9CQUNLTElHSFQgaXMgbm90IHNldApDT05GSUdf
RkJfTU9ERV9IRUxQRVJTPXkKIyBDT05GSUdfRkJfVElMRUJMSVRUSU5HIGlzIG5vdCBzZXQK
CiMKIyBGcmFtZSBidWZmZXIgaGFyZHdhcmUgZHJpdmVycwojCiMgQ09ORklHX0ZCX0NJUlJV
UyBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1BNMiBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX0NZ
QkVSMjAwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX0FSQyBpcyBub3Qgc2V0CiMgQ09ORklH
X0ZCX0FTSUxJQU5UIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfSU1TVFQgaXMgbm90IHNldAoj
IENPTkZJR19GQl9WR0ExNiBpcyBub3Qgc2V0CkNPTkZJR19GQl9VVkVTQT15CkNPTkZJR19G
Ql9WRVNBPXkKIyBDT05GSUdfRkJfTjQxMSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX0hHQSBp
cyBub3Qgc2V0CiMgQ09ORklHX0ZCX1MxRDEzWFhYIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJf
TlZJRElBIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfUklWQSBpcyBub3Qgc2V0CiMgQ09ORklH
X0ZCX0xFODA1NzggaXMgbm90IHNldAojIENPTkZJR19GQl9NQVRST1ggaXMgbm90IHNldAoj
IENPTkZJR19GQl9SQURFT04gaXMgbm90IHNldAojIENPTkZJR19GQl9BVFkxMjggaXMgbm90
IHNldApDT05GSUdfRkJfQVRZPXkKQ09ORklHX0ZCX0FUWV9DVD15CiMgQ09ORklHX0ZCX0FU
WV9HRU5FUklDX0xDRCBpcyBub3Qgc2V0CkNPTkZJR19GQl9BVFlfR1g9eQojIENPTkZJR19G
Ql9BVFlfQkFDS0xJR0hUIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfUzMgaXMgbm90IHNldAoj
IENPTkZJR19GQl9TSVMgaXMgbm90IHNldAojIENPTkZJR19GQl9WSUEgaXMgbm90IHNldAoj
IENPTkZJR19GQl9ORU9NQUdJQyBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX0tZUk8gaXMgbm90
IHNldAojIENPTkZJR19GQl8zREZYIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfVk9PRE9PMSBp
cyBub3Qgc2V0CiMgQ09ORklHX0ZCX1ZUODYyMyBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1RS
SURFTlQgaXMgbm90IHNldAojIENPTkZJR19GQl9BUksgaXMgbm90IHNldAojIENPTkZJR19G
Ql9DQVJNSU5FIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfVklSVFVBTCBpcyBub3Qgc2V0CiMg
Q09ORklHX0ZCX01FVFJPTk9NRSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX01CODYyWFggaXMg
bm90IHNldAojIENPTkZJR19GQl9CUk9BRFNIRUVUIGlzIG5vdCBzZXQKIyBDT05GSUdfQkFD
S0xJR0hUX0xDRF9TVVBQT1JUIGlzIG5vdCBzZXQKCiMKIyBEaXNwbGF5IGRldmljZSBzdXBw
b3J0CiMKIyBDT05GSUdfRElTUExBWV9TVVBQT1JUIGlzIG5vdCBzZXQKCiMKIyBDb25zb2xl
IGRpc3BsYXkgZHJpdmVyIHN1cHBvcnQKIwpDT05GSUdfVkdBX0NPTlNPTEU9eQpDT05GSUdf
VkdBQ09OX1NPRlRfU0NST0xMQkFDSz15CkNPTkZJR19WR0FDT05fU09GVF9TQ1JPTExCQUNL
X1NJWkU9MjU2CiMgQ09ORklHX01EQV9DT05TT0xFIGlzIG5vdCBzZXQKQ09ORklHX0RVTU1Z
X0NPTlNPTEU9eQpDT05GSUdfRlJBTUVCVUZGRVJfQ09OU09MRT15CkNPTkZJR19GUkFNRUJV
RkZFUl9DT05TT0xFX0RFVEVDVF9QUklNQVJZPXkKIyBDT05GSUdfRlJBTUVCVUZGRVJfQ09O
U09MRV9ST1RBVElPTiBpcyBub3Qgc2V0CkNPTkZJR19GQl9DT05fREVDT1I9eQojIENPTkZJ
R19GT05UUyBpcyBub3Qgc2V0CkNPTkZJR19GT05UXzh4OD15CkNPTkZJR19GT05UXzh4MTY9
eQpDT05GSUdfTE9HTz15CkNPTkZJR19MT0dPX0xJTlVYX01PTk89eQpDT05GSUdfTE9HT19M
SU5VWF9WR0ExNj15CkNPTkZJR19MT0dPX0xJTlVYX0NMVVQyMjQ9eQojIENPTkZJR19TT1VO
RCBpcyBub3Qgc2V0CkNPTkZJR19ISURfU1VQUE9SVD15CkNPTkZJR19ISUQ9eQojIENPTkZJ
R19ISURfREVCVUcgaXMgbm90IHNldAojIENPTkZJR19ISURSQVcgaXMgbm90IHNldAoKIwoj
IFVTQiBJbnB1dCBEZXZpY2VzCiMKQ09ORklHX1VTQl9ISUQ9eQpDT05GSUdfSElEX1BJRD15
CiMgQ09ORklHX1VTQl9ISURERVYgaXMgbm90IHNldAoKIwojIFNwZWNpYWwgSElEIGRyaXZl
cnMKIwpDT05GSUdfSElEX0E0VEVDSD15CkNPTkZJR19ISURfQVBQTEU9eQpDT05GSUdfSElE
X0JFTEtJTj15CkNPTkZJR19ISURfQ0hFUlJZPXkKQ09ORklHX0hJRF9DSElDT05ZPXkKQ09O
RklHX0hJRF9DWVBSRVNTPXkKIyBDT05GSUdfRFJBR09OUklTRV9GRiBpcyBub3Qgc2V0CkNP
TkZJR19ISURfRVpLRVk9eQpDT05GSUdfSElEX0tZRT15CkNPTkZJR19ISURfR1lSQVRJT049
eQpDT05GSUdfSElEX0tFTlNJTkdUT049eQpDT05GSUdfSElEX0xPR0lURUNIPXkKIyBDT05G
SUdfTE9HSVRFQ0hfRkYgaXMgbm90IHNldAojIENPTkZJR19MT0dJUlVNQkxFUEFEMl9GRiBp
cyBub3Qgc2V0CkNPTkZJR19ISURfTUlDUk9TT0ZUPXkKQ09ORklHX0hJRF9NT05URVJFWT15
CkNPTkZJR19ISURfTlRSSUc9eQpDT05GSUdfSElEX1BBTlRIRVJMT1JEPXkKIyBDT05GSUdf
UEFOVEhFUkxPUkRfRkYgaXMgbm90IHNldApDT05GSUdfSElEX1BFVEFMWU5YPXkKQ09ORklH
X0hJRF9TQU1TVU5HPXkKQ09ORklHX0hJRF9TT05ZPXkKQ09ORklHX0hJRF9TVU5QTFVTPXkK
IyBDT05GSUdfR1JFRU5BU0lBX0ZGIGlzIG5vdCBzZXQKQ09ORklHX0hJRF9UT1BTRUVEPXkK
IyBDT05GSUdfVEhSVVNUTUFTVEVSX0ZGIGlzIG5vdCBzZXQKIyBDT05GSUdfWkVST1BMVVNf
RkYgaXMgbm90IHNldApDT05GSUdfVVNCX1NVUFBPUlQ9eQpDT05GSUdfVVNCX0FSQ0hfSEFT
X0hDRD15CkNPTkZJR19VU0JfQVJDSF9IQVNfT0hDST15CkNPTkZJR19VU0JfQVJDSF9IQVNf
RUhDST15CkNPTkZJR19VU0I9eQojIENPTkZJR19VU0JfREVCVUcgaXMgbm90IHNldApDT05G
SUdfVVNCX0FOTk9VTkNFX05FV19ERVZJQ0VTPXkKCiMKIyBNaXNjZWxsYW5lb3VzIFVTQiBv
cHRpb25zCiMKQ09ORklHX1VTQl9ERVZJQ0VGUz15CkNPTkZJR19VU0JfREVWSUNFX0NMQVNT
PXkKQ09ORklHX1VTQl9EWU5BTUlDX01JTk9SUz15CkNPTkZJR19VU0JfU1VTUEVORD15CkNP
TkZJR19VU0JfTU9OPXkKQ09ORklHX1VTQl9XVVNCX0NCQUY9eQojIENPTkZJR19VU0JfV1VT
Ql9DQkFGX0RFQlVHIGlzIG5vdCBzZXQKCiMKIyBVU0IgSG9zdCBDb250cm9sbGVyIERyaXZl
cnMKIwpDT05GSUdfVVNCX0M2N1gwMF9IQ0Q9eQpDT05GSUdfVVNCX0VIQ0lfSENEPXkKQ09O
RklHX1VTQl9FSENJX1JPT1RfSFVCX1RUPXkKQ09ORklHX1VTQl9PWFUyMTBIUF9IQ0Q9eQpD
T05GSUdfVVNCX0lTUDExNlhfSENEPXkKQ09ORklHX1VTQl9PSENJX0hDRD15CiMgQ09ORklH
X1VTQl9PSENJX0JJR19FTkRJQU5fREVTQyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9PSENJ
X0JJR19FTkRJQU5fTU1JTyBpcyBub3Qgc2V0CkNPTkZJR19VU0JfT0hDSV9MSVRUTEVfRU5E
SUFOPXkKQ09ORklHX1VTQl9VSENJX0hDRD15CkNPTkZJR19VU0JfU0w4MTFfSENEPXkKQ09O
RklHX1VTQl9SOEE2NjU5N19IQ0Q9eQoKIwojIFVTQiBEZXZpY2UgQ2xhc3MgZHJpdmVycwoj
CkNPTkZJR19VU0JfQUNNPXkKQ09ORklHX1VTQl9QUklOVEVSPXkKQ09ORklHX1VTQl9XRE09
eQojIENPTkZJR19VU0JfVE1DIGlzIG5vdCBzZXQKCiMKIyBOT1RFOiBVU0JfU1RPUkFHRSBk
ZXBlbmRzIG9uIFNDU0kgYnV0IEJMS19ERVZfU0QgbWF5CiMKCiMKIyBhbHNvIGJlIG5lZWRl
ZDsgc2VlIFVTQl9TVE9SQUdFIEhlbHAgZm9yIG1vcmUgaW5mbwojCkNPTkZJR19VU0JfU1RP
UkFHRT15CkNPTkZJR19VU0JfU1RPUkFHRV9ERUJVRz15CkNPTkZJR19VU0JfU1RPUkFHRV9E
QVRBRkFCPXkKQ09ORklHX1VTQl9TVE9SQUdFX0ZSRUVDT009eQpDT05GSUdfVVNCX1NUT1JB
R0VfSVNEMjAwPXkKQ09ORklHX1VTQl9TVE9SQUdFX1VTQkFUPXkKQ09ORklHX1VTQl9TVE9S
QUdFX1NERFIwOT15CkNPTkZJR19VU0JfU1RPUkFHRV9TRERSNTU9eQpDT05GSUdfVVNCX1NU
T1JBR0VfSlVNUFNIT1Q9eQpDT05GSUdfVVNCX1NUT1JBR0VfQUxBVURBPXkKQ09ORklHX1VT
Ql9TVE9SQUdFX09ORVRPVUNIPXkKQ09ORklHX1VTQl9TVE9SQUdFX0tBUk1BPXkKQ09ORklH
X1VTQl9TVE9SQUdFX0NZUFJFU1NfQVRBQ0I9eQpDT05GSUdfVVNCX0xJQlVTVUFMPXkKCiMK
IyBVU0IgSW1hZ2luZyBkZXZpY2VzCiMKIyBDT05GSUdfVVNCX01EQzgwMCBpcyBub3Qgc2V0
CiMgQ09ORklHX1VTQl9NSUNST1RFSyBpcyBub3Qgc2V0CgojCiMgVVNCIHBvcnQgZHJpdmVy
cwojCiMgQ09ORklHX1VTQl9TRVJJQUwgaXMgbm90IHNldAoKIwojIFVTQiBNaXNjZWxsYW5l
b3VzIGRyaXZlcnMKIwojIENPTkZJR19VU0JfRU1JNjIgaXMgbm90IHNldAojIENPTkZJR19V
U0JfRU1JMjYgaXMgbm90IHNldAojIENPTkZJR19VU0JfQURVVFVYIGlzIG5vdCBzZXQKIyBD
T05GSUdfVVNCX1NFVlNFRyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9SSU81MDAgaXMgbm90
IHNldAojIENPTkZJR19VU0JfTEVHT1RPV0VSIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0xD
RCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9CRVJSWV9DSEFSR0UgaXMgbm90IHNldAojIENP
TkZJR19VU0JfTEVEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0NZUFJFU1NfQ1k3QzYzIGlz
IG5vdCBzZXQKIyBDT05GSUdfVVNCX0NZVEhFUk0gaXMgbm90IHNldAojIENPTkZJR19VU0Jf
SURNT1VTRSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9GVERJX0VMQU4gaXMgbm90IHNldAoj
IENPTkZJR19VU0JfQVBQTEVESVNQTEFZIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NJU1VT
QlZHQSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9MRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VT
Ql9UUkFOQ0VWSUJSQVRPUiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9JT1dBUlJJT1IgaXMg
bm90IHNldAojIENPTkZJR19VU0JfVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9JU0lH
SFRGVyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9WU1QgaXMgbm90IHNldAojIENPTkZJR19V
U0JfR0FER0VUIGlzIG5vdCBzZXQKCiMKIyBPVEcgYW5kIHJlbGF0ZWQgaW5mcmFzdHJ1Y3R1
cmUKIwojIENPTkZJR19OT1BfVVNCX1hDRUlWIGlzIG5vdCBzZXQKIyBDT05GSUdfTU1DIGlz
IG5vdCBzZXQKIyBDT05GSUdfTUVNU1RJQ0sgaXMgbm90IHNldAojIENPTkZJR19ORVdfTEVE
UyBpcyBub3Qgc2V0CiMgQ09ORklHX0FDQ0VTU0lCSUxJVFkgaXMgbm90IHNldAojIENPTkZJ
R19JTkZJTklCQU5EIGlzIG5vdCBzZXQKIyBDT05GSUdfRURBQyBpcyBub3Qgc2V0CkNPTkZJ
R19SVENfTElCPXkKQ09ORklHX1JUQ19DTEFTUz15CkNPTkZJR19SVENfSENUT1NZUz15CkNP
TkZJR19SVENfSENUT1NZU19ERVZJQ0U9InkiCkNPTkZJR19SVENfREVCVUc9eQoKIwojIFJU
QyBpbnRlcmZhY2VzCiMKQ09ORklHX1JUQ19JTlRGX1NZU0ZTPXkKQ09ORklHX1JUQ19JTlRG
X1BST0M9eQpDT05GSUdfUlRDX0lOVEZfREVWPXkKQ09ORklHX1JUQ19JTlRGX0RFVl9VSUVf
RU1VTD15CiMgQ09ORklHX1JUQ19EUlZfVEVTVCBpcyBub3Qgc2V0CgojCiMgSTJDIFJUQyBk
cml2ZXJzCiMKQ09ORklHX1JUQ19EUlZfRFMxMzA3PXkKQ09ORklHX1JUQ19EUlZfRFMxMzc0
PXkKQ09ORklHX1JUQ19EUlZfRFMxNjcyPXkKQ09ORklHX1JUQ19EUlZfTUFYNjkwMD15CkNP
TkZJR19SVENfRFJWX1JTNUMzNzI9eQpDT05GSUdfUlRDX0RSVl9JU0wxMjA4PXkKQ09ORklH
X1JUQ19EUlZfWDEyMDU9eQpDT05GSUdfUlRDX0RSVl9QQ0Y4NTYzPXkKQ09ORklHX1JUQ19E
UlZfUENGODU4Mz15CkNPTkZJR19SVENfRFJWX000MVQ4MD15CkNPTkZJR19SVENfRFJWX000
MVQ4MF9XRFQ9eQpDT05GSUdfUlRDX0RSVl9TMzUzOTBBPXkKQ09ORklHX1JUQ19EUlZfRk0z
MTMwPXkKQ09ORklHX1JUQ19EUlZfUlg4NTgxPXkKCiMKIyBTUEkgUlRDIGRyaXZlcnMKIwoK
IwojIFBsYXRmb3JtIFJUQyBkcml2ZXJzCiMKQ09ORklHX1JUQ19EUlZfQ01PUz15CkNPTkZJ
R19SVENfRFJWX0RTMTI4Nj15CkNPTkZJR19SVENfRFJWX0RTMTUxMT15CkNPTkZJR19SVENf
RFJWX0RTMTU1Mz15CkNPTkZJR19SVENfRFJWX0RTMTc0Mj15CkNPTkZJR19SVENfRFJWX1NU
SzE3VEE4PXkKQ09ORklHX1JUQ19EUlZfTTQ4VDg2PXkKQ09ORklHX1JUQ19EUlZfTTQ4VDM1
PXkKQ09ORklHX1JUQ19EUlZfTTQ4VDU5PXkKQ09ORklHX1JUQ19EUlZfQlE0ODAyPXkKQ09O
RklHX1JUQ19EUlZfVjMwMjA9eQoKIwojIG9uLUNQVSBSVEMgZHJpdmVycwojCkNPTkZJR19E
TUFERVZJQ0VTPXkKCiMKIyBETUEgRGV2aWNlcwojCkNPTkZJR19JTlRFTF9JT0FURE1BPXkK
Q09ORklHX0RNQV9FTkdJTkU9eQoKIwojIERNQSBDbGllbnRzCiMKQ09ORklHX05FVF9ETUE9
eQpDT05GSUdfQVNZTkNfVFhfRE1BPXkKIyBDT05GSUdfRE1BVEVTVCBpcyBub3Qgc2V0CkNP
TkZJR19EQ0E9eQojIENPTkZJR19BVVhESVNQTEFZIGlzIG5vdCBzZXQKIyBDT05GSUdfVUlP
IGlzIG5vdCBzZXQKIyBDT05GSUdfU1RBR0lORyBpcyBub3Qgc2V0CkNPTkZJR19YODZfUExB
VEZPUk1fREVWSUNFUz15CiMgQ09ORklHX0RFTExfV01JIGlzIG5vdCBzZXQKIyBDT05GSUdf
VEhJTktQQURfQUNQSSBpcyBub3Qgc2V0CiMgQ09ORklHX0lOVEVMX01FTkxPVyBpcyBub3Qg
c2V0CkNPTkZJR19BQ1BJX1dNST15CiMgQ09ORklHX0FDUElfQVNVUyBpcyBub3Qgc2V0CiMg
Q09ORklHX0FDUElfVE9TSElCQSBpcyBub3Qgc2V0CgojCiMgRmlybXdhcmUgRHJpdmVycwoj
CiMgQ09ORklHX0VERCBpcyBub3Qgc2V0CkNPTkZJR19GSVJNV0FSRV9NRU1NQVA9eQojIENP
TkZJR19ERUxMX1JCVSBpcyBub3Qgc2V0CiMgQ09ORklHX0RDREJBUyBpcyBub3Qgc2V0CkNP
TkZJR19ETUlJRD15CiMgQ09ORklHX0lTQ1NJX0lCRlRfRklORCBpcyBub3Qgc2V0CgojCiMg
RmlsZSBzeXN0ZW1zCiMKQ09ORklHX0VYVDJfRlM9eQpDT05GSUdfRVhUMl9GU19YQVRUUj15
CkNPTkZJR19FWFQyX0ZTX1BPU0lYX0FDTD15CkNPTkZJR19FWFQyX0ZTX1NFQ1VSSVRZPXkK
Q09ORklHX0VYVDJfRlNfWElQPXkKQ09ORklHX0VYVDNfRlM9eQojIENPTkZJR19FWFQzX0RF
RkFVTFRTX1RPX09SREVSRUQgaXMgbm90IHNldApDT05GSUdfRVhUM19GU19YQVRUUj15CkNP
TkZJR19FWFQzX0ZTX1BPU0lYX0FDTD15CkNPTkZJR19FWFQzX0ZTX1NFQ1VSSVRZPXkKQ09O
RklHX0VYVDRfRlM9eQpDT05GSUdfRVhUNERFVl9DT01QQVQ9eQpDT05GSUdfRVhUNF9GU19Y
QVRUUj15CkNPTkZJR19FWFQ0X0ZTX1BPU0lYX0FDTD15CkNPTkZJR19FWFQ0X0ZTX1NFQ1VS
SVRZPXkKQ09ORklHX0ZTX1hJUD15CkNPTkZJR19KQkQ9eQojIENPTkZJR19KQkRfREVCVUcg
aXMgbm90IHNldApDT05GSUdfSkJEMj15CiMgQ09ORklHX0pCRDJfREVCVUcgaXMgbm90IHNl
dApDT05GSUdfRlNfTUJDQUNIRT15CkNPTkZJR19SRUlTRVJGU19GUz15CiMgQ09ORklHX1JF
SVNFUkZTX0NIRUNLIGlzIG5vdCBzZXQKQ09ORklHX1JFSVNFUkZTX1BST0NfSU5GTz15CkNP
TkZJR19SRUlTRVJGU19GU19YQVRUUj15CkNPTkZJR19SRUlTRVJGU19GU19QT1NJWF9BQ0w9
eQpDT05GSUdfUkVJU0VSRlNfRlNfU0VDVVJJVFk9eQojIENPTkZJR19KRlNfRlMgaXMgbm90
IHNldApDT05GSUdfRlNfUE9TSVhfQUNMPXkKIyBDT05GSUdfWEZTX0ZTIGlzIG5vdCBzZXQK
IyBDT05GSUdfT0NGUzJfRlMgaXMgbm90IHNldApDT05GSUdfRklMRV9MT0NLSU5HPXkKQ09O
RklHX0ROT1RJRlk9eQpDT05GSUdfSU5PVElGWT15CkNPTkZJR19JTk9USUZZX1VTRVI9eQpD
T05GSUdfUVVPVEE9eQpDT05GSUdfUVVPVEFfTkVUTElOS19JTlRFUkZBQ0U9eQojIENPTkZJ
R19QUklOVF9RVU9UQV9XQVJOSU5HIGlzIG5vdCBzZXQKQ09ORklHX1FVT1RBX1RSRUU9eQoj
IENPTkZJR19RRk1UX1YxIGlzIG5vdCBzZXQKQ09ORklHX1FGTVRfVjI9eQpDT05GSUdfUVVP
VEFDVEw9eQojIENPTkZJR19BVVRPRlNfRlMgaXMgbm90IHNldApDT05GSUdfQVVUT0ZTNF9G
Uz15CkNPTkZJR19GVVNFX0ZTPXkKQ09ORklHX0dFTkVSSUNfQUNMPXkKCiMKIyBDYWNoZXMK
IwoKIwojIENELVJPTS9EVkQgRmlsZXN5c3RlbXMKIwpDT05GSUdfSVNPOTY2MF9GUz15CkNP
TkZJR19KT0xJRVQ9eQpDT05GSUdfWklTT0ZTPXkKQ09ORklHX1VERl9GUz15CkNPTkZJR19V
REZfTkxTPXkKCiMKIyBET1MvRkFUL05UIEZpbGVzeXN0ZW1zCiMKQ09ORklHX0ZBVF9GUz15
CkNPTkZJR19NU0RPU19GUz15CkNPTkZJR19WRkFUX0ZTPXkKQ09ORklHX0ZBVF9ERUZBVUxU
X0NPREVQQUdFPTg2NgpDT05GSUdfRkFUX0RFRkFVTFRfSU9DSEFSU0VUPSJjcDEyNTEiCkNP
TkZJR19OVEZTX0ZTPXkKIyBDT05GSUdfTlRGU19ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19O
VEZTX1JXPXkKCiMKIyBQc2V1ZG8gZmlsZXN5c3RlbXMKIwpDT05GSUdfUFJPQ19GUz15CkNP
TkZJR19QUk9DX0tDT1JFPXkKQ09ORklHX1BST0NfU1lTQ1RMPXkKQ09ORklHX1BST0NfUEFH
RV9NT05JVE9SPXkKQ09ORklHX1NZU0ZTPXkKQ09ORklHX1RNUEZTPXkKQ09ORklHX1RNUEZT
X1BPU0lYX0FDTD15CkNPTkZJR19IVUdFVExCRlM9eQpDT05GSUdfSFVHRVRMQl9QQUdFPXkK
Q09ORklHX0NPTkZJR0ZTX0ZTPXkKQ09ORklHX01JU0NfRklMRVNZU1RFTVM9eQojIENPTkZJ
R19IRlNQTFVTX0ZTIGlzIG5vdCBzZXQKQ09ORklHX0NSQU1GUz15CkNPTkZJR19TUVVBU0hG
Uz15CiMgQ09ORklHX1NRVUFTSEZTX0VNQkVEREVEIGlzIG5vdCBzZXQKQ09ORklHX1NRVUFT
SEZTX0ZSQUdNRU5UX0NBQ0hFX1NJWkU9MwojIENPTkZJR19WWEZTX0ZTIGlzIG5vdCBzZXQK
IyBDT05GSUdfTUlOSVhfRlMgaXMgbm90IHNldAojIENPTkZJR19PTUZTX0ZTIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSFBGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX1FOWDRGU19GUyBpcyBu
b3Qgc2V0CkNPTkZJR19ST01GU19GUz15CkNPTkZJR19ST01GU19CQUNLRURfQllfQkxPQ0s9
eQojIENPTkZJR19ST01GU19CQUNLRURfQllfTVREIGlzIG5vdCBzZXQKIyBDT05GSUdfUk9N
RlNfQkFDS0VEX0JZX0JPVEggaXMgbm90IHNldApDT05GSUdfUk9NRlNfT05fQkxPQ0s9eQoj
IENPTkZJR19TWVNWX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfVUZTX0ZTIGlzIG5vdCBzZXQK
Q09ORklHX05FVFdPUktfRklMRVNZU1RFTVM9eQojIENPTkZJR19ORlNfRlMgaXMgbm90IHNl
dAojIENPTkZJR19ORlNEIGlzIG5vdCBzZXQKIyBDT05GSUdfU01CX0ZTIGlzIG5vdCBzZXQK
Q09ORklHX0NJRlM9eQpDT05GSUdfQ0lGU19TVEFUUz15CkNPTkZJR19DSUZTX1NUQVRTMj15
CkNPTkZJR19DSUZTX1dFQUtfUFdfSEFTSD15CkNPTkZJR19DSUZTX1hBVFRSPXkKQ09ORklH
X0NJRlNfUE9TSVg9eQpDT05GSUdfQ0lGU19ERUJVRzI9eQojIENPTkZJR19OQ1BfRlMgaXMg
bm90IHNldAojIENPTkZJR19DT0RBX0ZTIGlzIG5vdCBzZXQKCiMKIyBQYXJ0aXRpb24gVHlw
ZXMKIwojIENPTkZJR19QQVJUSVRJT05fQURWQU5DRUQgaXMgbm90IHNldApDT05GSUdfTVNE
T1NfUEFSVElUSU9OPXkKQ09ORklHX05MUz15CkNPTkZJR19OTFNfREVGQVVMVD0iY3AxMjUx
IgojIENPTkZJR19OTFNfQ09ERVBBR0VfNDM3IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NP
REVQQUdFXzczNyBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV83NzUgaXMgbm90
IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODUwIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxT
X0NPREVQQUdFXzg1MiBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV84NTUgaXMg
bm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODU3IGlzIG5vdCBzZXQKIyBDT05GSUdf
TkxTX0NPREVQQUdFXzg2MCBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV84NjEg
aXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODYyIGlzIG5vdCBzZXQKIyBDT05G
SUdfTkxTX0NPREVQQUdFXzg2MyBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV84
NjQgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODY1IGlzIG5vdCBzZXQKQ09O
RklHX05MU19DT0RFUEFHRV84NjY9eQojIENPTkZJR19OTFNfQ09ERVBBR0VfODY5IGlzIG5v
dCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzkzNiBpcyBub3Qgc2V0CiMgQ09ORklHX05M
U19DT0RFUEFHRV85NTAgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfOTMyIGlz
IG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzk0OSBpcyBub3Qgc2V0CiMgQ09ORklH
X05MU19DT0RFUEFHRV84NzQgaXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV84IGlz
IG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzEyNTAgaXMgbm90IHNldApDT05GSUdf
TkxTX0NPREVQQUdFXzEyNTE9eQojIENPTkZJR19OTFNfQVNDSUkgaXMgbm90IHNldAojIENP
TkZJR19OTFNfSVNPODg1OV8xIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfMiBp
cyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084ODU5XzMgaXMgbm90IHNldAojIENPTkZJR19O
TFNfSVNPODg1OV80IGlzIG5vdCBzZXQKQ09ORklHX05MU19JU084ODU5XzU9eQojIENPTkZJ
R19OTFNfSVNPODg1OV82IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfNyBpcyBu
b3Qgc2V0CiMgQ09ORklHX05MU19JU084ODU5XzkgaXMgbm90IHNldAojIENPTkZJR19OTFNf
SVNPODg1OV8xMyBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084ODU5XzE0IGlzIG5vdCBz
ZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfMTUgaXMgbm90IHNldApDT05GSUdfTkxTX0tPSThf
Uj15CiMgQ09ORklHX05MU19LT0k4X1UgaXMgbm90IHNldApDT05GSUdfTkxTX1VURjg9eQoK
IwojIEtlcm5lbCBoYWNraW5nCiMKQ09ORklHX1RSQUNFX0lSUUZMQUdTX1NVUFBPUlQ9eQpD
T05GSUdfUFJJTlRLX1RJTUU9eQojIENPTkZJR19FTkFCTEVfV0FSTl9ERVBSRUNBVEVEIGlz
IG5vdCBzZXQKIyBDT05GSUdfRU5BQkxFX01VU1RfQ0hFQ0sgaXMgbm90IHNldApDT05GSUdf
RlJBTUVfV0FSTj0xMDI0CkNPTkZJR19NQUdJQ19TWVNSUT15CiMgQ09ORklHX1VOVVNFRF9T
WU1CT0xTIGlzIG5vdCBzZXQKQ09ORklHX0RFQlVHX0ZTPXkKIyBDT05GSUdfSEVBREVSU19D
SEVDSyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0tFUk5FTCBpcyBub3Qgc2V0CkNPTkZJ
R19TQ0hFRF9ERUJVRz15CkNPTkZJR19TQ0hFRFNUQVRTPXkKIyBDT05GSUdfU0xVQl9ERUJV
R19PTiBpcyBub3Qgc2V0CiMgQ09ORklHX1NMVUJfU1RBVFMgaXMgbm90IHNldApDT05GSUdf
U1RBQ0tUUkFDRT15CkNPTkZJR19ERUJVR19CVUdWRVJCT1NFPXkKQ09ORklHX0RFQlVHX01F
TU9SWV9JTklUPXkKQ09ORklHX0FSQ0hfV0FOVF9GUkFNRV9QT0lOVEVSUz15CkNPTkZJR19G
UkFNRV9QT0lOVEVSPXkKQ09ORklHX1JDVV9DUFVfU1RBTExfREVURUNUT1I9eQpDT05GSUdf
TEFURU5DWVRPUD15CkNPTkZJR19TWVNDVExfU1lTQ0FMTF9DSEVDSz15CkNPTkZJR19VU0VS
X1NUQUNLVFJBQ0VfU1VQUE9SVD15CkNPTkZJR19OT1BfVFJBQ0VSPXkKQ09ORklHX0hBVkVf
RlVOQ1RJT05fVFJBQ0VSPXkKQ09ORklHX0hBVkVfRlVOQ1RJT05fR1JBUEhfVFJBQ0VSPXkK
Q09ORklHX0hBVkVfRlVOQ1RJT05fVFJBQ0VfTUNPVU5UX1RFU1Q9eQpDT05GSUdfSEFWRV9E
WU5BTUlDX0ZUUkFDRT15CkNPTkZJR19IQVZFX0ZUUkFDRV9NQ09VTlRfUkVDT1JEPXkKQ09O
RklHX0hBVkVfRlRSQUNFX1NZU0NBTExTPXkKQ09ORklHX1JJTkdfQlVGRkVSPXkKQ09ORklH
X1RSQUNJTkc9eQpDT05GSUdfVFJBQ0lOR19TVVBQT1JUPXkKCiMKIyBUcmFjZXJzCiMKQ09O
RklHX0ZVTkNUSU9OX1RSQUNFUj15CiMgQ09ORklHX0ZVTkNUSU9OX0dSQVBIX1RSQUNFUiBp
cyBub3Qgc2V0CiMgQ09ORklHX0lSUVNPRkZfVFJBQ0VSIGlzIG5vdCBzZXQKIyBDT05GSUdf
U1lTUFJPRl9UUkFDRVIgaXMgbm90IHNldAojIENPTkZJR19TQ0hFRF9UUkFDRVIgaXMgbm90
IHNldApDT05GSUdfQ09OVEVYVF9TV0lUQ0hfVFJBQ0VSPXkKIyBDT05GSUdfRVZFTlRfVFJB
Q0VSIGlzIG5vdCBzZXQKIyBDT05GSUdfRlRSQUNFX1NZU0NBTExTIGlzIG5vdCBzZXQKIyBD
T05GSUdfQk9PVF9UUkFDRVIgaXMgbm90IHNldAojIENPTkZJR19UUkFDRV9CUkFOQ0hfUFJP
RklMSU5HIGlzIG5vdCBzZXQKIyBDT05GSUdfUE9XRVJfVFJBQ0VSIGlzIG5vdCBzZXQKIyBD
T05GSUdfU1RBQ0tfVFJBQ0VSIGlzIG5vdCBzZXQKIyBDT05GSUdfS01FTVRSQUNFIGlzIG5v
dCBzZXQKIyBDT05GSUdfV09SS1FVRVVFX1RSQUNFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0JM
S19ERVZfSU9fVFJBQ0UgaXMgbm90IHNldAojIENPTkZJR19EWU5BTUlDX0ZUUkFDRSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0ZUUkFDRV9TVEFSVFVQX1RFU1QgaXMgbm90IHNldAojIENPTkZJ
R19NTUlPVFJBQ0UgaXMgbm90IHNldAojIENPTkZJR19QUk9WSURFX09IQ0kxMzk0X0RNQV9J
TklUIGlzIG5vdCBzZXQKIyBDT05GSUdfRFlOQU1JQ19ERUJVRyBpcyBub3Qgc2V0CiMgQ09O
RklHX0RNQV9BUElfREVCVUcgaXMgbm90IHNldAojIENPTkZJR19TQU1QTEVTIGlzIG5vdCBz
ZXQKQ09ORklHX0hBVkVfQVJDSF9LR0RCPXkKQ09ORklHX1NUUklDVF9ERVZNRU09eQojIENP
TkZJR19YODZfVkVSQk9TRV9CT09UVVAgaXMgbm90IHNldApDT05GSUdfRUFSTFlfUFJJTlRL
PXkKIyBDT05GSUdfRUFSTFlfUFJJTlRLX0RCR1AgaXMgbm90IHNldAojIENPTkZJR180S1NU
QUNLUyBpcyBub3Qgc2V0CkNPTkZJR19ET1VCTEVGQVVMVD15CkNPTkZJR19IQVZFX01NSU9U
UkFDRV9TVVBQT1JUPXkKQ09ORklHX0lPX0RFTEFZX1RZUEVfMFg4MD0wCkNPTkZJR19JT19E
RUxBWV9UWVBFXzBYRUQ9MQpDT05GSUdfSU9fREVMQVlfVFlQRV9VREVMQVk9MgpDT05GSUdf
SU9fREVMQVlfVFlQRV9OT05FPTMKQ09ORklHX0lPX0RFTEFZXzBYODA9eQojIENPTkZJR19J
T19ERUxBWV8wWEVEIGlzIG5vdCBzZXQKIyBDT05GSUdfSU9fREVMQVlfVURFTEFZIGlzIG5v
dCBzZXQKIyBDT05GSUdfSU9fREVMQVlfTk9ORSBpcyBub3Qgc2V0CkNPTkZJR19ERUZBVUxU
X0lPX0RFTEFZX1RZUEU9MApDT05GSUdfT1BUSU1JWkVfSU5MSU5JTkc9eQoKIwojIFNlY3Vy
aXR5IG9wdGlvbnMKIwojIENPTkZJR19LRVlTIGlzIG5vdCBzZXQKQ09ORklHX1NFQ1VSSVRZ
PXkKQ09ORklHX1NFQ1VSSVRZRlM9eQpDT05GSUdfU0VDVVJJVFlfTkVUV09SSz15CkNPTkZJ
R19TRUNVUklUWV9ORVRXT1JLX1hGUk09eQpDT05GSUdfU0VDVVJJVFlfUEFUSD15CiMgQ09O
RklHX1NFQ1VSSVRZX0ZJTEVfQ0FQQUJJTElUSUVTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VD
VVJJVFlfUk9PVFBMVUcgaXMgbm90IHNldAojIENPTkZJR19TRUNVUklUWV9UT01PWU8gaXMg
bm90IHNldAojIENPTkZJR19JTUEgaXMgbm90IHNldApDT05GSUdfQ1JZUFRPPXkKCiMKIyBD
cnlwdG8gY29yZSBvciBoZWxwZXIKIwpDT05GSUdfQ1JZUFRPX0ZJUFM9eQpDT05GSUdfQ1JZ
UFRPX0FMR0FQST15CkNPTkZJR19DUllQVE9fQUxHQVBJMj15CkNPTkZJR19DUllQVE9fQUVB
RD15CkNPTkZJR19DUllQVE9fQUVBRDI9eQpDT05GSUdfQ1JZUFRPX0JMS0NJUEhFUj15CkNP
TkZJR19DUllQVE9fQkxLQ0lQSEVSMj15CkNPTkZJR19DUllQVE9fSEFTSD15CkNPTkZJR19D
UllQVE9fSEFTSDI9eQpDT05GSUdfQ1JZUFRPX1JORz15CkNPTkZJR19DUllQVE9fUk5HMj15
CkNPTkZJR19DUllQVE9fUENPTVA9eQpDT05GSUdfQ1JZUFRPX01BTkFHRVI9eQpDT05GSUdf
Q1JZUFRPX01BTkFHRVIyPXkKQ09ORklHX0NSWVBUT19HRjEyOE1VTD15CkNPTkZJR19DUllQ
VE9fTlVMTD15CkNPTkZJR19DUllQVE9fV09SS1FVRVVFPXkKQ09ORklHX0NSWVBUT19DUllQ
VEQ9eQpDT05GSUdfQ1JZUFRPX0FVVEhFTkM9eQoKIwojIEF1dGhlbnRpY2F0ZWQgRW5jcnlw
dGlvbiB3aXRoIEFzc29jaWF0ZWQgRGF0YQojCkNPTkZJR19DUllQVE9fQ0NNPXkKQ09ORklH
X0NSWVBUT19HQ009eQpDT05GSUdfQ1JZUFRPX1NFUUlWPXkKCiMKIyBCbG9jayBtb2Rlcwoj
CkNPTkZJR19DUllQVE9fQ0JDPXkKQ09ORklHX0NSWVBUT19DVFI9eQpDT05GSUdfQ1JZUFRP
X0NUUz15CkNPTkZJR19DUllQVE9fRUNCPXkKQ09ORklHX0NSWVBUT19QQ0JDPXkKCiMKIyBI
YXNoIG1vZGVzCiMKQ09ORklHX0NSWVBUT19ITUFDPXkKCiMKIyBEaWdlc3QKIwpDT05GSUdf
Q1JZUFRPX0NSQzMyQz15CkNPTkZJR19DUllQVE9fQ1JDMzJDX0lOVEVMPXkKQ09ORklHX0NS
WVBUT19NRDQ9eQpDT05GSUdfQ1JZUFRPX01ENT15CkNPTkZJR19DUllQVE9fTUlDSEFFTF9N
SUM9eQpDT05GSUdfQ1JZUFRPX1JNRDEyOD15CkNPTkZJR19DUllQVE9fUk1EMTYwPXkKQ09O
RklHX0NSWVBUT19STUQyNTY9eQpDT05GSUdfQ1JZUFRPX1JNRDMyMD15CkNPTkZJR19DUllQ
VE9fU0hBMT15CkNPTkZJR19DUllQVE9fU0hBMjU2PXkKQ09ORklHX0NSWVBUT19TSEE1MTI9
eQpDT05GSUdfQ1JZUFRPX1RHUjE5Mj15CkNPTkZJR19DUllQVE9fV1A1MTI9eQoKIwojIENp
cGhlcnMKIwpDT05GSUdfQ1JZUFRPX0FFUz15CkNPTkZJR19DUllQVE9fQUVTXzU4Nj15CkNP
TkZJR19DUllQVE9fQU5VQklTPXkKQ09ORklHX0NSWVBUT19BUkM0PXkKQ09ORklHX0NSWVBU
T19CTE9XRklTSD15CkNPTkZJR19DUllQVE9fQ0FNRUxMSUE9eQpDT05GSUdfQ1JZUFRPX0NB
U1Q1PXkKQ09ORklHX0NSWVBUT19DQVNUNj15CkNPTkZJR19DUllQVE9fREVTPXkKQ09ORklH
X0NSWVBUT19GQ1JZUFQ9eQpDT05GSUdfQ1JZUFRPX0tIQVpBRD15CkNPTkZJR19DUllQVE9f
U0VFRD15CkNPTkZJR19DUllQVE9fU0VSUEVOVD15CkNPTkZJR19DUllQVE9fVEVBPXkKQ09O
RklHX0NSWVBUT19UV09GSVNIPXkKQ09ORklHX0NSWVBUT19UV09GSVNIX0NPTU1PTj15CkNP
TkZJR19DUllQVE9fVFdPRklTSF81ODY9eQoKIwojIENvbXByZXNzaW9uCiMKQ09ORklHX0NS
WVBUT19ERUZMQVRFPXkKQ09ORklHX0NSWVBUT19aTElCPXkKQ09ORklHX0NSWVBUT19MWk89
eQoKIwojIFJhbmRvbSBOdW1iZXIgR2VuZXJhdGlvbgojCkNPTkZJR19DUllQVE9fQU5TSV9D
UFJORz15CiMgQ09ORklHX0NSWVBUT19IVyBpcyBub3Qgc2V0CkNPTkZJR19IQVZFX0tWTT15
CkNPTkZJR19IQVZFX0tWTV9JUlFDSElQPXkKIyBDT05GSUdfVklSVFVBTElaQVRJT04gaXMg
bm90IHNldApDT05GSUdfQklOQVJZX1BSSU5URj15CgojCiMgTGlicmFyeSByb3V0aW5lcwoj
CkNPTkZJR19CSVRSRVZFUlNFPXkKQ09ORklHX0dFTkVSSUNfRklORF9GSVJTVF9CSVQ9eQpD
T05GSUdfR0VORVJJQ19GSU5EX05FWFRfQklUPXkKQ09ORklHX0dFTkVSSUNfRklORF9MQVNU
X0JJVD15CkNPTkZJR19DUkNfQ0NJVFQ9eQpDT05GSUdfQ1JDMTY9eQpDT05GSUdfQ1JDX1Qx
MERJRj15CkNPTkZJR19DUkNfSVRVX1Q9eQpDT05GSUdfQ1JDMzI9eQpDT05GSUdfQ1JDNz15
CkNPTkZJR19MSUJDUkMzMkM9eQpDT05GSUdfWkxJQl9JTkZMQVRFPXkKQ09ORklHX1pMSUJf
REVGTEFURT15CkNPTkZJR19MWk9fQ09NUFJFU1M9eQpDT05GSUdfTFpPX0RFQ09NUFJFU1M9
eQpDT05GSUdfVEVYVFNFQVJDSD15CkNPTkZJR19URVhUU0VBUkNIX0tNUD15CkNPTkZJR19U
RVhUU0VBUkNIX0JNPXkKQ09ORklHX1RFWFRTRUFSQ0hfRlNNPXkKQ09ORklHX0hBU19JT01F
TT15CkNPTkZJR19IQVNfSU9QT1JUPXkKQ09ORklHX0hBU19ETUE9eQpDT05GSUdfTkxBVFRS
PXkK
------------261781911372B433--

