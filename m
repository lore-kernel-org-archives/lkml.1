Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317Ab0BBTJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 14:09:54 -0500
Received: from mx03.syneticon.net ([78.111.66.105]:35690 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241Ab0BBTJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 14:09:48 -0500
X-Greylist: delayed 545 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Feb 2010 14:09:47 EST
Message-ID: <4B687649.5070204@wpkg.org>
Date: Tue, 02 Feb 2010 20:00:25 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100122 Mandriva/3.0.1-2mdv2010.1 (2010.1) Thunderbird/3.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: core i7: hang at Booting processor 5 APIC 0x3 ip 0x6000
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From time to time (once a week or so), I can't boot a kernel on a PC with core i7 CPU - kernel hangs somewhere on Booting processor 5 APIC 0x3 ip 0x6000 / Initializing CPU#5 (on different CPUs).

Sometimes after some seconds pass, it goes on and boots.
Sometimes, it just hangs for good.

This is on a 2.6.32 kernel, but it used to happen on earlier kernels, too.

The mainboard is DX58SO.


Here is a log for a system boot where kernel waited for about 13 seconds after it detected 5 CPUs (full dmesg down below):

Feb  2 19:00:32 dom kernel: [    0.405098] Initializing CPU#4
Feb  2 19:00:32 dom kernel: [    0.464759] Calibrating delay using timer specific routine.. 5331.86 BogoMIPS (lpj=2665932)
Feb  2 19:00:32 dom kernel: [    0.464766] CPU: Physical Processor ID: 0
Feb  2 19:00:32 dom kernel: [    0.464767] CPU: Processor Core ID: 0
Feb  2 19:00:32 dom kernel: [    0.464769] CPU: L1 I cache: 32K, L1 D cache: 32K
Feb  2 19:00:32 dom kernel: [    0.464771] CPU: L2 cache: 256K
Feb  2 19:00:32 dom kernel: [    0.464772] CPU: L3 cache: 8192K
Feb  2 19:00:32 dom kernel: [    0.464774] CPU 4/0x1 -> Node 0
Feb  2 19:00:32 dom kernel: [    0.464784] CPU4: Thermal monitoring enabled (TM1)
Feb  2 19:00:32 dom kernel: [    0.464787] CPU 4 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
Feb  2 19:00:32 dom kernel: [    0.464828] CPU4: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05
Feb  2 19:00:32 dom kernel: [    0.465492] Booting processor 5 APIC 0x3 ip 0x6000
Feb  2 19:00:32 dom kernel: [   13.338073] Initializing CPU#5
Feb  2 19:00:32 dom kernel: [   13.496075] Calibrating delay using timer specific routine.. 5331.88 BogoMIPS (lpj=2665940)
Feb  2 19:00:32 dom kernel: [   13.496081] CPU: Physical Processor ID: 0
Feb  2 19:00:32 dom kernel: [   13.496082] CPU: Processor Core ID: 1
Feb  2 19:00:32 dom kernel: [   13.496083] CPU: L1 I cache: 32K, L1 D cache: 32K
Feb  2 19:00:32 dom kernel: [   13.496085] CPU: L2 cache: 256K
Feb  2 19:00:32 dom kernel: [   13.496085] CPU: L3 cache: 8192K
Feb  2 19:00:32 dom kernel: [   13.496087] CPU 5/0x3 -> Node 0
Feb  2 19:00:32 dom kernel: [   13.496096] CPU5: Thermal monitoring enabled (TM1)
Feb  2 19:00:32 dom kernel: [   13.496098] CPU 5 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
Feb  2 19:00:32 dom kernel: [   13.496126] CPU5: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05




And a full dmesg:

Feb  2 19:00:32 dom kernel: Linux version 2.6.32-desktop-1mnb (herton@celeste.mandriva.com) (gcc version 4.4.2 (GCC) ) #1 SMP Sat Dec 12 13:09:45 EST 2009
Feb  2 19:00:32 dom kernel: Command line: BOOT_IMAGE=desktop_2.6.32-1mnb root=/dev/md1 resume=/dev/md0 pci=nommconf printk.time=1
Feb  2 19:00:32 dom kernel: KERNEL supported cpus:
Feb  2 19:00:32 dom kernel:  Intel GenuineIntel
Feb  2 19:00:32 dom kernel:  AMD AuthenticAMD
Feb  2 19:00:32 dom kernel:  Centaur CentaurHauls
Feb  2 19:00:32 dom kernel: BIOS-provided physical RAM map:
Feb  2 19:00:32 dom kernel: BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
Feb  2 19:00:32 dom kernel: BIOS-e820: 000000000008f000 - 0000000000090000 (reserved)
Feb  2 19:00:32 dom kernel: BIOS-e820: 0000000000090000 - 000000000009d000 (usable)
Feb  2 19:00:32 dom kernel: BIOS-e820: 000000000009d000 - 00000000000a0000 (reserved)
Feb  2 19:00:32 dom kernel: BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
Feb  2 19:00:32 dom kernel: BIOS-e820: 0000000000100000 - 00000000bc6e8000 (usable)
Feb  2 19:00:32 dom kernel: BIOS-e820: 00000000bc6e8000 - 00000000bca12000 (ACPI NVS)
Feb  2 19:00:32 dom kernel: BIOS-e820: 00000000bca12000 - 00000000bf4bd000 (usable)
Feb  2 19:00:32 dom kernel: BIOS-e820: 00000000bf4bd000 - 00000000bf4bf000 (reserved)
Feb  2 19:00:32 dom kernel: BIOS-e820: 00000000bf4bf000 - 00000000bf718000 (usable)
Feb  2 19:00:32 dom kernel: BIOS-e820: 00000000bf718000 - 00000000bf7bf000 (ACPI NVS)
Feb  2 19:00:32 dom kernel: BIOS-e820: 00000000bf7bf000 - 00000000bf7e0000 (usable)
Feb  2 19:00:32 dom kernel: BIOS-e820: 00000000bf7e0000 - 00000000bf7ff000 (ACPI data)
Feb  2 19:00:32 dom kernel: BIOS-e820: 00000000bf7ff000 - 00000000bf800000 (usable)
Feb  2 19:00:32 dom kernel: BIOS-e820: 00000000bf800000 - 00000000c0000000 (reserved)
Feb  2 19:00:32 dom kernel: BIOS-e820: 00000000f8000000 - 00000000fd000000 (reserved)
Feb  2 19:00:32 dom kernel: BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
Feb  2 19:00:32 dom kernel: BIOS-e820: 0000000100000000 - 0000000240000000 (usable)
Feb  2 19:00:32 dom kernel: DMI 2.5 present.
Feb  2 19:00:32 dom kernel: last_pfn = 0x240000 max_arch_pfn = 0x400000000
Feb  2 19:00:32 dom kernel: MTRR default type: uncachable
Feb  2 19:00:32 dom kernel: MTRR fixed ranges enabled:
Feb  2 19:00:32 dom kernel:  00000-9FFFF write-back
Feb  2 19:00:32 dom kernel:  A0000-BFFFF uncachable
Feb  2 19:00:32 dom kernel:  C0000-DFFFF write-protect
Feb  2 19:00:32 dom kernel:  E0000-FFFFF uncachable
Feb  2 19:00:32 dom kernel: MTRR variable ranges enabled:
Feb  2 19:00:32 dom kernel:  0 base 000000000 mask F80000000 write-back
Feb  2 19:00:32 dom kernel:  1 base 080000000 mask FC0000000 write-back
Feb  2 19:00:32 dom kernel:  2 base 100000000 mask F00000000 write-back
Feb  2 19:00:32 dom kernel:  3 base 200000000 mask FC0000000 write-back
Feb  2 19:00:32 dom kernel:  4 base 0FFE00000 mask FFFE00000 write-protect
Feb  2 19:00:32 dom kernel:  5 base 0FFE00000 mask FFFFF0000 uncachable
Feb  2 19:00:32 dom kernel:  6 disabled
Feb  2 19:00:32 dom kernel:  7 disabled
Feb  2 19:00:32 dom kernel: x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Feb  2 19:00:32 dom kernel: last_pfn = 0xbf800 max_arch_pfn = 0x400000000
Feb  2 19:00:32 dom kernel: initial memory mapped : 0 - 20000000
Feb  2 19:00:32 dom kernel: init_memory_mapping: 0000000000000000-00000000bf800000
Feb  2 19:00:32 dom kernel: 0000000000 - 00bf800000 page 2M
Feb  2 19:00:32 dom kernel: kernel direct mapping tables up to bf800000 @ 8000-c000
Feb  2 19:00:32 dom kernel: init_memory_mapping: 0000000100000000-0000000240000000
Feb  2 19:00:32 dom kernel: 0100000000 - 0240000000 page 2M
Feb  2 19:00:32 dom kernel: kernel direct mapping tables up to 240000000 @ a000-14000
Feb  2 19:00:32 dom kernel: RAMDISK: 37be6000 - 37fef670
Feb  2 19:00:32 dom kernel: ACPI: RSDP 00000000000fe020 00024 (v02 INTEL )
Feb  2 19:00:32 dom kernel: ACPI: XSDT 00000000bf7fe120 0006C (v01 INTEL  DX58SO   00001135      01000013)
Feb  2 19:00:32 dom kernel: ACPI: FACP 00000000bf7fd000 000F4 (v03 INTEL  DX58SO   00001135 MSFT 0100000D)
Feb  2 19:00:32 dom kernel: ACPI Warning: Optional field Pm2ControlBlock has zero address or length: 0000000000000450/0 (20090903/tbfadt-557)
Feb  2 19:00:32 dom kernel: ACPI Warning: Invalid length for Pm2ControlBlock: 0, using default 8 (20090903/tbfadt-607)
Feb  2 19:00:32 dom kernel: ACPI: DSDT 00000000bf7f8000 04641 (v02 INTEL  DX58SO   00001135 MSFT 0100000D)
Feb  2 19:00:32 dom kernel: ACPI: FACS 00000000bf729000 00040
Feb  2 19:00:32 dom kernel: ACPI: APIC 00000000bf7f7000 00138 (v02 INTEL  DX58SO   00001135 MSFT 0100000D)
Feb  2 19:00:32 dom kernel: ACPI: WDDT 00000000bf7f6000 00040 (v01 INTEL  DX58SO   00001135 MSFT 0100000D)
Feb  2 19:00:32 dom kernel: ACPI: MCFG 00000000bf7f5000 0003C (v01 INTEL  DX58SO   00001135 MSFT 0100000D)
Feb  2 19:00:32 dom kernel: ACPI: ASF! 00000000bf7f4000 000AC (v32 INTEL  DX58SO   00001135 MSFT 0100000D)
Feb  2 19:00:32 dom kernel: ACPI: SSDT 00000000bf7e3000 0E134 (v01 INTEL  SSDT  PM 00001135 MSFT 0100000D)
Feb  2 19:00:32 dom kernel: ACPI: DMAR 00000000bf7e0000 00140 (v01 INTEL  DX58SO   00001135 MSFT 0100000D)
Feb  2 19:00:32 dom kernel: ACPI: WDTT 00000000bf7f2000 0020C (v02 INTEL  DX58SO   00001135 MSFT 0100000D)
Feb  2 19:00:32 dom kernel: ACPI: ASPT 00000000bf7f3000 00034 (v04 INTEL  PerfTune 00001135 MSFT 0100000D)
Feb  2 19:00:32 dom kernel: ACPI: Local APIC address 0xfee00000
Feb  2 19:00:32 dom kernel: No NUMA configuration found
Feb  2 19:00:32 dom kernel: Faking a node at 0000000000000000-0000000240000000
Feb  2 19:00:32 dom kernel: Bootmem setup node 0 0000000000000000-0000000240000000
Feb  2 19:00:32 dom kernel:  NODE_DATA [0000000000001000 - 0000000000005fff]
Feb  2 19:00:32 dom kernel:  bootmap [000000000000f000 -  0000000000056fff] pages 48
Feb  2 19:00:32 dom kernel: (8 early reservations) ==> bootmem [0000000000 - 0240000000]
Feb  2 19:00:32 dom kernel:  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
Feb  2 19:00:32 dom kernel:  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
Feb  2 19:00:32 dom kernel:  #2 [0001000000 - 000187a138]    TEXT DATA BSS ==> [0001000000 - 000187a138]
Feb  2 19:00:32 dom kernel:  #3 [0037be6000 - 0037fef670]          RAMDISK ==> [0037be6000 - 0037fef670]
Feb  2 19:00:32 dom kernel:  #4 [000009d000 - 0000100000]    BIOS reserved ==> [000009d000 - 0000100000]
Feb  2 19:00:32 dom kernel:  #5 [000187b000 - 000187b15e]              BRK ==> [000187b000 - 000187b15e]
Feb  2 19:00:32 dom kernel:  #6 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
Feb  2 19:00:32 dom kernel:  #7 [000000a000 - 000000f000]          PGTABLE ==> [000000a000 - 000000f000]
Feb  2 19:00:32 dom kernel: [ffffea0000000000-ffffea0007dfffff] PMD -> [ffff880001a00000-ffff8800089fffff] on node 0
Feb  2 19:00:32 dom kernel: Zone PFN ranges:
Feb  2 19:00:32 dom kernel:  DMA      0x00000000 -> 0x00001000
Feb  2 19:00:32 dom kernel:  DMA32    0x00001000 -> 0x00100000
Feb  2 19:00:32 dom kernel:  Normal   0x00100000 -> 0x00240000
Feb  2 19:00:32 dom kernel: Movable zone start PFN for each node
Feb  2 19:00:32 dom kernel: early_node_map[8] active PFN ranges
Feb  2 19:00:32 dom kernel:    0: 0x00000000 -> 0x0000008f
Feb  2 19:00:32 dom kernel:    0: 0x00000090 -> 0x0000009d
Feb  2 19:00:32 dom kernel:    0: 0x00000100 -> 0x000bc6e8
Feb  2 19:00:32 dom kernel:    0: 0x000bca12 -> 0x000bf4bd
Feb  2 19:00:32 dom kernel:    0: 0x000bf4bf -> 0x000bf718
Feb  2 19:00:32 dom kernel:    0: 0x000bf7bf -> 0x000bf7e0
Feb  2 19:00:32 dom kernel:    0: 0x000bf7ff -> 0x000bf800
Feb  2 19:00:32 dom kernel:    0: 0x00100000 -> 0x00240000
Feb  2 19:00:32 dom kernel: On node 0 totalpages: 2093994
Feb  2 19:00:32 dom kernel:  DMA zone: 56 pages used for memmap
Feb  2 19:00:32 dom kernel:  DMA zone: 109 pages reserved
Feb  2 19:00:32 dom kernel:  DMA zone: 3831 pages, LIFO batch:0
Feb  2 19:00:32 dom kernel:  DMA32 zone: 14280 pages used for memmap
Feb  2 19:00:32 dom kernel:  DMA32 zone: 764998 pages, LIFO batch:31
Feb  2 19:00:32 dom kernel:  Normal zone: 17920 pages used for memmap
Feb  2 19:00:32 dom kernel:  Normal zone: 1292800 pages, LIFO batch:31
Feb  2 19:00:32 dom kernel: ACPI: PM-Timer IO Port: 0x408
Feb  2 19:00:32 dom kernel: ACPI: Local APIC address 0xfee00000
Feb  2 19:00:32 dom kernel: ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Feb  2 19:00:32 dom kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
Feb  2 19:00:32 dom kernel: ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
Feb  2 19:00:32 dom kernel: ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] enabled)
Feb  2 19:00:32 dom kernel: ACPI: LAPIC (acpi_id[0x04] lapic_id[0x01] enabled)
Feb  2 19:00:32 dom kernel: ACPI: LAPIC (acpi_id[0x05] lapic_id[0x03] enabled)
Feb  2 19:00:32 dom kernel: ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
Feb  2 19:00:32 dom kernel: ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
Feb  2 19:00:32 dom kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] disabled)
Feb  2 19:00:32 dom kernel: ACPI: LAPIC (acpi_id[0x03] lapic_id[0x12] disabled)
Feb  2 19:00:32 dom kernel: ACPI: LAPIC (acpi_id[0x05] lapic_id[0x14] disabled)
Feb  2 19:00:32 dom kernel: ACPI: LAPIC (acpi_id[0x07] lapic_id[0x16] disabled)
Feb  2 19:00:32 dom kernel: ACPI: LAPIC (acpi_id[0x09] lapic_id[0x11] disabled)
Feb  2 19:00:32 dom kernel: ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x13] disabled)
Feb  2 19:00:32 dom kernel: ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x15] disabled)
Feb  2 19:00:32 dom kernel: ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x17] disabled)
Feb  2 19:00:32 dom kernel: ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
Feb  2 19:00:32 dom kernel: ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
Feb  2 19:00:32 dom kernel: ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
Feb  2 19:00:32 dom kernel: ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
Feb  2 19:00:32 dom kernel: ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
Feb  2 19:00:32 dom kernel: ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
Feb  2 19:00:32 dom kernel: ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
Feb  2 19:00:32 dom kernel: ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
Feb  2 19:00:32 dom kernel: ACPI: LAPIC_NMI (acpi_id[0x08] high level lint[0x1])
Feb  2 19:00:32 dom kernel: ACPI: LAPIC_NMI (acpi_id[0x09] high level lint[0x1])
Feb  2 19:00:32 dom kernel: ACPI: LAPIC_NMI (acpi_id[0x0a] high level lint[0x1])
Feb  2 19:00:32 dom kernel: ACPI: LAPIC_NMI (acpi_id[0x0b] high level lint[0x1])
Feb  2 19:00:32 dom kernel: ACPI: LAPIC_NMI (acpi_id[0x0c] high level lint[0x1])
Feb  2 19:00:32 dom kernel: ACPI: LAPIC_NMI (acpi_id[0x0d] high level lint[0x1])
Feb  2 19:00:32 dom kernel: ACPI: LAPIC_NMI (acpi_id[0x0e] high level lint[0x1])
Feb  2 19:00:32 dom kernel: ACPI: LAPIC_NMI (acpi_id[0x0f] high level lint[0x1])
Feb  2 19:00:32 dom kernel: ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
Feb  2 19:00:32 dom kernel: IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
Feb  2 19:00:32 dom kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Feb  2 19:00:32 dom kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Feb  2 19:00:32 dom kernel: ACPI: IRQ0 used by override.
Feb  2 19:00:32 dom kernel: ACPI: IRQ2 used by override.
Feb  2 19:00:32 dom kernel: ACPI: IRQ9 used by override.
Feb  2 19:00:32 dom kernel: Using ACPI (MADT) for SMP configuration information
Feb  2 19:00:32 dom kernel: SMP: Allowing 16 CPUs, 8 hotplug CPUs
Feb  2 19:00:32 dom kernel: nr_irqs_gsi: 24
Feb  2 19:00:32 dom kernel: PM: Registered nosave memory: 000000000008f000 - 0000000000090000
Feb  2 19:00:32 dom kernel: PM: Registered nosave memory: 000000000009d000 - 00000000000a0000
Feb  2 19:00:32 dom kernel: PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
Feb  2 19:00:32 dom kernel: PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Feb  2 19:00:32 dom kernel: PM: Registered nosave memory: 00000000bc6e8000 - 00000000bca12000
Feb  2 19:00:32 dom kernel: PM: Registered nosave memory: 00000000bf4bd000 - 00000000bf4bf000
Feb  2 19:00:32 dom kernel: PM: Registered nosave memory: 00000000bf718000 - 00000000bf7bf000
Feb  2 19:00:32 dom kernel: PM: Registered nosave memory: 00000000bf7e0000 - 00000000bf7ff000
Feb  2 19:00:32 dom kernel: PM: Registered nosave memory: 00000000bf800000 - 00000000c0000000
Feb  2 19:00:32 dom kernel: PM: Registered nosave memory: 00000000c0000000 - 00000000f8000000
Feb  2 19:00:32 dom kernel: PM: Registered nosave memory: 00000000f8000000 - 00000000fd000000
Feb  2 19:00:32 dom kernel: PM: Registered nosave memory: 00000000fd000000 - 00000000ffe00000
Feb  2 19:00:32 dom kernel: PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
Feb  2 19:00:32 dom kernel: Allocating PCI resources starting at c0000000 (gap: c0000000:38000000)
Feb  2 19:00:32 dom kernel: Booting paravirtualized kernel on bare hardware
Feb  2 19:00:32 dom kernel: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:16 nr_node_ids:1
Feb  2 19:00:32 dom kernel: PERCPU: Embedded 30 pages/cpu @ffff880008c00000 s90392 r8192 d24296 u131072
Feb  2 19:00:32 dom kernel: pcpu-alloc: s90392 r8192 d24296 u131072 alloc=1*2097152
Feb  2 19:00:32 dom kernel: pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15
Feb  2 19:00:32 dom kernel: Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2061629
Feb  2 19:00:32 dom kernel: Policy zone: Normal
Feb  2 19:00:32 dom kernel: Kernel command line: BOOT_IMAGE=desktop_2.6.32-1mnb root=/dev/md1 resume=/dev/md0 pci=nommconf printk.time=1
Feb  2 19:00:32 dom kernel: [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
Feb  2 19:00:32 dom kernel: [    0.000000] Initializing CPU#0
Feb  2 19:00:32 dom kernel: [    0.000000] Checking aperture...
Feb  2 19:00:32 dom kernel: [    0.000000] No AGP bridge found
Feb  2 19:00:32 dom kernel: [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
Feb  2 19:00:32 dom kernel: [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Feb  2 19:00:32 dom kernel: [    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Feb  2 19:00:32 dom kernel: [    0.000000] Placing 64MB software IO TLB between ffff880008dfe000 - ffff88000cdfe000
Feb  2 19:00:32 dom kernel: [    0.000000] software IO TLB at phys 0x8dfe000 - 0xcdfe000
Feb  2 19:00:32 dom kernel: [    0.000000] Memory: 8180156k/9437184k available (3902k kernel code, 1061208k absent, 195820k reserved, 3018k data, 700k init)
Feb  2 19:00:32 dom kernel: [    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
Feb  2 19:00:32 dom kernel: [    0.000000] Hierarchical RCU implementation.
Feb  2 19:00:32 dom kernel: [    0.000000] NR_IRQS:1280
Feb  2 19:00:32 dom kernel: [    0.000000] Extended CMOS year: 2000
Feb  2 19:00:32 dom kernel: [    0.000000] Console: colour VGA+ 80x25
Feb  2 19:00:32 dom kernel: [    0.000000] console [tty0] enabled
Feb  2 19:00:32 dom kernel: [    0.001000] Fast TSC calibration using PIT
Feb  2 19:00:32 dom kernel: [    0.002000] Detected 2666.801 MHz processor.
Feb  2 19:00:32 dom kernel: [    0.000004] Calibrating delay loop (skipped), value calculated using timer frequency.. 5333.60 BogoMIPS (lpj=2666801)
Feb  2 19:00:32 dom kernel: [    0.000129] Security Framework initialized
Feb  2 19:00:32 dom kernel: [    0.000185] TOMOYO Linux initialized
Feb  2 19:00:32 dom kernel: [    0.000711] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Feb  2 19:00:32 dom kernel: [    0.002572] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Feb  2 19:00:32 dom kernel: [    0.003410] Mount-cache hash table entries: 256
Feb  2 19:00:32 dom kernel: [    0.003557] CPU: Physical Processor ID: 0
Feb  2 19:00:32 dom kernel: [    0.003606] CPU: Processor Core ID: 0
Feb  2 19:00:32 dom kernel: [    0.003655] CPU: L1 I cache: 32K, L1 D cache: 32K
Feb  2 19:00:32 dom kernel: [    0.003734] CPU: L2 cache: 256K
Feb  2 19:00:32 dom kernel: [    0.003780] CPU: L3 cache: 8192K
Feb  2 19:00:32 dom kernel: [    0.003828] CPU 0/0x0 -> Node 0
Feb  2 19:00:32 dom kernel: [    0.003877] mce: CPU supports 9 MCE banks
Feb  2 19:00:32 dom kernel: [    0.003933] CPU0: Thermal monitoring enabled (TM1)
Feb  2 19:00:32 dom kernel: [    0.003984] CPU 0 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 CMCI:8
Feb  2 19:00:32 dom kernel: [    0.004221] using mwait in idle threads.
Feb  2 19:00:32 dom kernel: [    0.004269] Performance Events: Nehalem/Corei7 events, Intel PMU driver.
Feb  2 19:00:32 dom kernel: [    0.004382] ... version:                3
Feb  2 19:00:32 dom kernel: [    0.004431] ... bit width:              48
Feb  2 19:00:32 dom kernel: [    0.004479] ... generic registers:      4
Feb  2 19:00:32 dom kernel: [    0.004526] ... value mask:             0000ffffffffffff
Feb  2 19:00:32 dom kernel: [    0.004577] ... max period:             000000007fffffff
Feb  2 19:00:32 dom kernel: [    0.004629] ... fixed-purpose events:   3
Feb  2 19:00:32 dom kernel: [    0.004677] ... event mask:             000000070000000f
Feb  2 19:00:32 dom kernel: [    0.005533] ACPI: Checking initramfs for custom DSDT
Feb  2 19:00:32 dom kernel: [    0.050910] ACPI: Core revision 20090903
Feb  2 19:00:32 dom kernel: [    0.063832] ftrace: converting mcount calls to 0f 1f 44 00 00
Feb  2 19:00:32 dom kernel: [    0.063894] ftrace: allocating 17360 entries in 69 pages
Feb  2 19:00:32 dom kernel: [    0.068410] DMAR: Host address width 39
Feb  2 19:00:32 dom kernel: [    0.068460] DMAR: DRHD base: 0x000000fe711000 flags: 0x0
Feb  2 19:00:32 dom kernel: [    0.068516] IOMMU fe711000: ver 1:0 cap c9008010e60262 ecap f0207a
Feb  2 19:00:32 dom kernel: [    0.068569] DMAR: DRHD base: 0x000000fe710000 flags: 0x1
Feb  2 19:00:32 dom kernel: [    0.068624] IOMMU fe710000: ver 1:0 cap c90780106f0462 ecap f0207a
Feb  2 19:00:32 dom kernel: [    0.068677] DMAR: RMRR base: 0x000000000e9000 end: 0x000000000e9fff
Feb  2 19:00:32 dom kernel: [    0.068731] DMAR: RMRR base: 0x000000000ea000 end: 0x000000000eafff
Feb  2 19:00:32 dom kernel: [    0.068784] DMAR: RMRR base: 0x000000000eb000 end: 0x000000000ebfff
Feb  2 19:00:32 dom kernel: [    0.068837] DMAR: RMRR base: 0x000000000e6000 end: 0x000000000e6fff
Feb  2 19:00:32 dom kernel: [    0.068898] DMAR: RMRR base: 0x000000000e7000 end: 0x000000000e7fff
Feb  2 19:00:32 dom kernel: [    0.068951] DMAR: RMRR base: 0x000000000e8000 end: 0x000000000e8fff
Feb  2 19:00:32 dom kernel: [    0.069596] DMAR: RMRR base: 0x000000000ec000 end: 0x000000000eefff
Feb  2 19:00:32 dom kernel: [    0.069649] DMAR: No ATSR found
Feb  2 19:00:32 dom kernel: [    0.069699] IOAPIC id 8 under DRHD base 0xfe710000
Feb  2 19:00:32 dom kernel: [    0.069990] Enabled Interrupt-remapping
Feb  2 19:00:32 dom kernel: [    0.070048] Setting APIC routing to flat
Feb  2 19:00:32 dom kernel: [    0.070266] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [    0.070271] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [    0.070276] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [    0.070280] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [    0.070285] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [    0.070289] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [    0.070294] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [    0.070298] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [    0.070303] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [    0.070308] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [    0.070312] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [    0.070317] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [    0.070321] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [    0.070326] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [    0.070330] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [    0.070497] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Feb  2 19:00:32 dom kernel: [    0.080525] CPU0: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05
Feb  2 19:00:32 dom kernel: [    0.181663] Booting processor 1 APIC 0x2 ip 0x6000
Feb  2 19:00:32 dom kernel: [    0.192187] Initializing CPU#1
Feb  2 19:00:32 dom kernel: [    0.252373] Calibrating delay using timer specific routine.. 5331.87 BogoMIPS (lpj=2665939)
Feb  2 19:00:32 dom kernel: [    0.252379] CPU: Physical Processor ID: 0
Feb  2 19:00:32 dom kernel: [    0.252380] CPU: Processor Core ID: 1
Feb  2 19:00:32 dom kernel: [    0.252382] CPU: L1 I cache: 32K, L1 D cache: 32K
Feb  2 19:00:32 dom kernel: [    0.252383] CPU: L2 cache: 256K
Feb  2 19:00:32 dom kernel: [    0.252384] CPU: L3 cache: 8192K
Feb  2 19:00:32 dom kernel: [    0.252385] CPU 1/0x2 -> Node 0
Feb  2 19:00:32 dom kernel: [    0.252395] CPU1: Thermal monitoring enabled (TM1)
Feb  2 19:00:32 dom kernel: [    0.252397] CPU 1 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
Feb  2 19:00:32 dom kernel: [    0.252464] CPU1: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05
Feb  2 19:00:32 dom kernel: [    0.253066] Skipping synchronization checks as TSC is reliable.
Feb  2 19:00:32 dom kernel: [    0.253180] Booting processor 2 APIC 0x4 ip 0x6000
Feb  2 19:00:32 dom kernel: [    0.263563] Initializing CPU#2
Feb  2 19:00:32 dom kernel: [    0.323168] Calibrating delay using timer specific routine.. 5331.87 BogoMIPS (lpj=2665939)
Feb  2 19:00:32 dom kernel: [    0.323174] CPU: Physical Processor ID: 0
Feb  2 19:00:32 dom kernel: [    0.323175] CPU: Processor Core ID: 2
Feb  2 19:00:32 dom kernel: [    0.323177] CPU: L1 I cache: 32K, L1 D cache: 32K
Feb  2 19:00:32 dom kernel: [    0.323178] CPU: L2 cache: 256K
Feb  2 19:00:32 dom kernel: [    0.323179] CPU: L3 cache: 8192K
Feb  2 19:00:32 dom kernel: [    0.323181] CPU 2/0x4 -> Node 0
Feb  2 19:00:32 dom kernel: [    0.323190] CPU2: Thermal monitoring enabled (TM1)
Feb  2 19:00:32 dom kernel: [    0.323193] CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
Feb  2 19:00:32 dom kernel: [    0.323283] CPU2: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05
Feb  2 19:00:32 dom kernel: [    0.323948] Booting processor 3 APIC 0x6 ip 0x6000
Feb  2 19:00:32 dom kernel: [    0.334331] Initializing CPU#3
Feb  2 19:00:32 dom kernel: [    0.393963] Calibrating delay using timer specific routine.. 5331.88 BogoMIPS (lpj=2665940)
Feb  2 19:00:32 dom kernel: [    0.393970] CPU: Physical Processor ID: 0
Feb  2 19:00:32 dom kernel: [    0.393970] CPU: Processor Core ID: 3
Feb  2 19:00:32 dom kernel: [    0.393972] CPU: L1 I cache: 32K, L1 D cache: 32K
Feb  2 19:00:32 dom kernel: [    0.393973] CPU: L2 cache: 256K
Feb  2 19:00:32 dom kernel: [    0.393974] CPU: L3 cache: 8192K
Feb  2 19:00:32 dom kernel: [    0.393976] CPU 3/0x6 -> Node 0
Feb  2 19:00:32 dom kernel: [    0.393985] CPU3: Thermal monitoring enabled (TM1)
Feb  2 19:00:32 dom kernel: [    0.393988] CPU 3 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
Feb  2 19:00:32 dom kernel: [    0.394050] CPU3: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05
Feb  2 19:00:32 dom kernel: [    0.394714] Booting processor 4 APIC 0x1 ip 0x6000
Feb  2 19:00:32 dom kernel: [    0.405098] Initializing CPU#4
Feb  2 19:00:32 dom kernel: [    0.464759] Calibrating delay using timer specific routine.. 5331.86 BogoMIPS (lpj=2665932)
Feb  2 19:00:32 dom kernel: [    0.464766] CPU: Physical Processor ID: 0
Feb  2 19:00:32 dom kernel: [    0.464767] CPU: Processor Core ID: 0
Feb  2 19:00:32 dom kernel: [    0.464769] CPU: L1 I cache: 32K, L1 D cache: 32K
Feb  2 19:00:32 dom kernel: [    0.464771] CPU: L2 cache: 256K
Feb  2 19:00:32 dom kernel: [    0.464772] CPU: L3 cache: 8192K
Feb  2 19:00:32 dom kernel: [    0.464774] CPU 4/0x1 -> Node 0
Feb  2 19:00:32 dom kernel: [    0.464784] CPU4: Thermal monitoring enabled (TM1)
Feb  2 19:00:32 dom kernel: [    0.464787] CPU 4 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
Feb  2 19:00:32 dom kernel: [    0.464828] CPU4: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05
Feb  2 19:00:32 dom kernel: [    0.465492] Booting processor 5 APIC 0x3 ip 0x6000
Feb  2 19:00:32 dom kernel: [   13.338073] Initializing CPU#5
Feb  2 19:00:32 dom kernel: [   13.496075] Calibrating delay using timer specific routine.. 5331.88 BogoMIPS (lpj=2665940)
Feb  2 19:00:32 dom kernel: [   13.496081] CPU: Physical Processor ID: 0
Feb  2 19:00:32 dom kernel: [   13.496082] CPU: Processor Core ID: 1
Feb  2 19:00:32 dom kernel: [   13.496083] CPU: L1 I cache: 32K, L1 D cache: 32K
Feb  2 19:00:32 dom kernel: [   13.496085] CPU: L2 cache: 256K
Feb  2 19:00:32 dom kernel: [   13.496085] CPU: L3 cache: 8192K
Feb  2 19:00:32 dom kernel: [   13.496087] CPU 5/0x3 -> Node 0
Feb  2 19:00:32 dom kernel: [   13.496096] CPU5: Thermal monitoring enabled (TM1)
Feb  2 19:00:32 dom kernel: [   13.496098] CPU 5 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
Feb  2 19:00:32 dom kernel: [   13.496126] CPU5: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05
Feb  2 19:00:32 dom kernel: [   13.496791] Booting processor 6 APIC 0x5 ip 0x6000
Feb  2 19:00:32 dom kernel: [   13.507176] Initializing CPU#6
Feb  2 19:00:32 dom kernel: [   13.566870] Calibrating delay using timer specific routine.. 5331.87 BogoMIPS (lpj=2665938)
Feb  2 19:00:32 dom kernel: [   13.566876] CPU: Physical Processor ID: 0
Feb  2 19:00:32 dom kernel: [   13.566877] CPU: Processor Core ID: 2
Feb  2 19:00:32 dom kernel: [   13.566879] CPU: L1 I cache: 32K, L1 D cache: 32K
Feb  2 19:00:32 dom kernel: [   13.566880] CPU: L2 cache: 256K
Feb  2 19:00:32 dom kernel: [   13.566881] CPU: L3 cache: 8192K
Feb  2 19:00:32 dom kernel: [   13.566883] CPU 6/0x5 -> Node 0
Feb  2 19:00:32 dom kernel: [   13.566892] CPU6: Thermal monitoring enabled (TM1)
Feb  2 19:00:32 dom kernel: [   13.566894] CPU 6 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
Feb  2 19:00:32 dom kernel: [   13.566994] CPU6: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05
Feb  2 19:00:32 dom kernel: [   13.567657] Booting processor 7 APIC 0x7 ip 0x6000
Feb  2 19:00:32 dom kernel: [   13.578041] Initializing CPU#7
Feb  2 19:00:32 dom kernel: [   13.637666] Calibrating delay using timer specific routine.. 5331.88 BogoMIPS (lpj=2665940)
Feb  2 19:00:32 dom kernel: [   13.637671] CPU: Physical Processor ID: 0
Feb  2 19:00:32 dom kernel: [   13.637672] CPU: Processor Core ID: 3
Feb  2 19:00:32 dom kernel: [   13.637674] CPU: L1 I cache: 32K, L1 D cache: 32K
Feb  2 19:00:32 dom kernel: [   13.637675] CPU: L2 cache: 256K
Feb  2 19:00:32 dom kernel: [   13.637676] CPU: L3 cache: 8192K
Feb  2 19:00:32 dom kernel: [   13.637678] CPU 7/0x7 -> Node 0
Feb  2 19:00:32 dom kernel: [   13.637687] CPU7: Thermal monitoring enabled (TM1)
Feb  2 19:00:32 dom kernel: [   13.637689] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
Feb  2 19:00:32 dom kernel: [   13.637760] CPU7: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05
Feb  2 19:00:32 dom kernel: [   13.638374] Brought up 8 CPUs
Feb  2 19:00:32 dom kernel: [   13.638421] Total of 8 processors activated (42656.73 BogoMIPS).
Feb  2 19:00:32 dom kernel: [   13.641940] CPU0 attaching sched-domain:
Feb  2 19:00:32 dom kernel: [   13.641943]  domain 0: span 0-7 level MC
Feb  2 19:00:32 dom kernel: [   13.641944]   groups: 0 1 2 3 4 5 6 7
Feb  2 19:00:32 dom kernel: [   13.641950] CPU1 attaching sched-domain:
Feb  2 19:00:32 dom kernel: [   13.641952]  domain 0: span 0-7 level MC
Feb  2 19:00:32 dom kernel: [   13.641953]   groups: 1 2 3 4 5 6 7 0
Feb  2 19:00:32 dom kernel: [   13.641957] CPU2 attaching sched-domain:
Feb  2 19:00:32 dom kernel: [   13.641959]  domain 0: span 0-7 level MC
Feb  2 19:00:32 dom kernel: [   13.641960]   groups: 2 3 4 5 6 7 0 1
Feb  2 19:00:32 dom kernel: [   13.641964] CPU3 attaching sched-domain:
Feb  2 19:00:32 dom kernel: [   13.641965]  domain 0: span 0-7 level MC
Feb  2 19:00:32 dom kernel: [   13.641967]   groups: 3 4 5 6 7 0 1 2
Feb  2 19:00:32 dom kernel: [   13.641971] CPU4 attaching sched-domain:
Feb  2 19:00:32 dom kernel: [   13.641972]  domain 0: span 0-7 level MC
Feb  2 19:00:32 dom kernel: [   13.641974]   groups: 4 5 6 7 0 1 2 3
Feb  2 19:00:32 dom kernel: [   13.641978] CPU5 attaching sched-domain:
Feb  2 19:00:32 dom kernel: [   13.641979]  domain 0: span 0-7 level MC
Feb  2 19:00:32 dom kernel: [   13.641980]   groups: 5 6 7 0 1 2 3 4
Feb  2 19:00:32 dom kernel: [   13.641985] CPU6 attaching sched-domain:
Feb  2 19:00:32 dom kernel: [   13.641986]  domain 0: span 0-7 level MC
Feb  2 19:00:32 dom kernel: [   13.641987]   groups: 6 7 0 1 2 3 4 5
Feb  2 19:00:32 dom kernel: [   13.641991] CPU7 attaching sched-domain:
Feb  2 19:00:32 dom kernel: [   13.641993]  domain 0: span 0-7 level MC
Feb  2 19:00:32 dom kernel: [   13.641994]   groups: 7 0 1 2 3 4 5 6
Feb  2 19:00:32 dom kernel: [   13.642194] devtmpfs: initialized
Feb  2 19:00:32 dom kernel: [   13.643364] Time: 18:00:21  Date: 02/02/10
Feb  2 19:00:32 dom kernel: [   13.643443] NET: Registered protocol family 16
Feb  2 19:00:32 dom kernel: [   13.644307] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
Feb  2 19:00:32 dom kernel: [   13.644375] ACPI: bus type pci registered
Feb  2 19:00:32 dom kernel: [   13.644457] PCI: Using configuration type 1 for base access
Feb  2 19:00:32 dom kernel: [   13.644942] bio: create slab <bio-0> at 0
Feb  2 19:00:32 dom kernel: [   13.645703] ACPI: EC: Look up EC in DSDT
Feb  2 19:00:32 dom kernel: [   13.659504] ACPI: Interpreter enabled
Feb  2 19:00:32 dom kernel: [   13.659555] ACPI: (supports S0 S1 S3 S4 S5)
Feb  2 19:00:32 dom kernel: [   13.659765] ACPI: Using IOAPIC for interrupt routing
Feb  2 19:00:32 dom kernel: [   13.663693] ACPI: No dock devices found.
Feb  2 19:00:32 dom kernel: [   13.664161] ACPI: PCI Root Bridge [PCI0] (0000:00)
Feb  2 19:00:32 dom kernel: [   13.664319] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
Feb  2 19:00:32 dom kernel: [   13.664374] pci 0000:00:01.0: PME# disabled
Feb  2 19:00:32 dom kernel: [   13.664477] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
Feb  2 19:00:32 dom kernel: [   13.664531] pci 0000:00:03.0: PME# disabled
Feb  2 19:00:32 dom kernel: [   13.664636] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
Feb  2 19:00:32 dom kernel: [   13.664692] pci 0000:00:07.0: PME# disabled
Feb  2 19:00:32 dom kernel: [   13.665013] pci 0000:00:19.0: reg 10 32bit mmio: [0xc0200000-0xc021ffff]
Feb  2 19:00:32 dom kernel: [   13.665018] pci 0000:00:19.0: reg 14 32bit mmio: [0xc0223000-0xc0223fff]
Feb  2 19:00:32 dom kernel: [   13.665024] pci 0000:00:19.0: reg 18 io port: [0x3100-0x311f]
Feb  2 19:00:32 dom kernel: [   13.665057] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
Feb  2 19:00:32 dom kernel: [   13.665111] pci 0000:00:19.0: PME# disabled
Feb  2 19:00:32 dom kernel: [   13.665203] pci 0000:00:1a.0: reg 20 io port: [0x30e0-0x30ff]
Feb  2 19:00:32 dom kernel: [   13.665269] pci 0000:00:1a.1: reg 20 io port: [0x30c0-0x30df]
Feb  2 19:00:32 dom kernel: [   13.665333] pci 0000:00:1a.2: reg 20 io port: [0x30a0-0x30bf]
Feb  2 19:00:32 dom kernel: [   13.665395] pci 0000:00:1a.7: reg 10 32bit mmio: [0xc0222000-0xc02223ff]
Feb  2 19:00:32 dom kernel: [   13.665443] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
Feb  2 19:00:32 dom kernel: [   13.665497] pci 0000:00:1a.7: PME# disabled
Feb  2 19:00:32 dom kernel: [   13.665580] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf0000000-0xf0003fff]
Feb  2 19:00:32 dom kernel: [   13.665619] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
Feb  2 19:00:32 dom kernel: [   13.665675] pci 0000:00:1b.0: PME# disabled
Feb  2 19:00:32 dom kernel: [   13.665779] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
Feb  2 19:00:32 dom kernel: [   13.665833] pci 0000:00:1c.0: PME# disabled
Feb  2 19:00:32 dom kernel: [   13.665937] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
Feb  2 19:00:32 dom kernel: [   13.665991] pci 0000:00:1c.1: PME# disabled
Feb  2 19:00:32 dom kernel: [   13.666092] pci 0000:00:1d.0: reg 20 io port: [0x3080-0x309f]
Feb  2 19:00:32 dom kernel: [   13.666157] pci 0000:00:1d.1: reg 20 io port: [0x3060-0x307f]
Feb  2 19:00:32 dom kernel: [   13.666222] pci 0000:00:1d.2: reg 20 io port: [0x3040-0x305f]
Feb  2 19:00:32 dom kernel: [   13.666283] pci 0000:00:1d.7: reg 10 32bit mmio: [0xc0221000-0xc02213ff]
Feb  2 19:00:32 dom kernel: [   13.666331] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
Feb  2 19:00:32 dom kernel: [   13.666385] pci 0000:00:1d.7: PME# disabled
Feb  2 19:00:32 dom kernel: [   13.666551] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
Feb  2 19:00:32 dom kernel: [   13.666556] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
Feb  2 19:00:32 dom kernel: [   13.666625] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
Feb  2 19:00:32 dom kernel: [   13.666682] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
Feb  2 19:00:32 dom kernel: [   13.666751] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0810 (mask 007f)
Feb  2 19:00:32 dom kernel: [   13.666874] pci 0000:00:1f.2: reg 10 io port: [0x3128-0x312f]
Feb  2 19:00:32 dom kernel: [   13.666879] pci 0000:00:1f.2: reg 14 io port: [0x3134-0x3137]
Feb  2 19:00:32 dom kernel: [   13.666884] pci 0000:00:1f.2: reg 18 io port: [0x3120-0x3127]
Feb  2 19:00:32 dom kernel: [   13.666889] pci 0000:00:1f.2: reg 1c io port: [0x3130-0x3133]
Feb  2 19:00:32 dom kernel: [   13.666893] pci 0000:00:1f.2: reg 20 io port: [0x3020-0x303f]
Feb  2 19:00:32 dom kernel: [   13.666898] pci 0000:00:1f.2: reg 24 32bit mmio: [0xc0220000-0xc02207ff]
Feb  2 19:00:32 dom kernel: [   13.666925] pci 0000:00:1f.2: PME# supported from D3hot
Feb  2 19:00:32 dom kernel: [   13.666977] pci 0000:00:1f.2: PME# disabled
Feb  2 19:00:32 dom kernel: [   13.667048] pci 0000:00:1f.3: reg 10 64bit mmio: [0xf0004000-0xf00040ff]
Feb  2 19:00:32 dom kernel: [   13.667061] pci 0000:00:1f.3: reg 20 io port: [0x3000-0x301f]
Feb  2 19:00:32 dom kernel: [   13.667127] pci 0000:02:00.0: reg 10 64bit mmio pref: [0xd0000000-0xdfffffff]
Feb  2 19:00:32 dom kernel: [   13.667135] pci 0000:02:00.0: reg 18 64bit mmio: [0xc0100000-0xc010ffff]
Feb  2 19:00:32 dom kernel: [   13.667140] pci 0000:02:00.0: reg 20 io port: [0x2000-0x20ff]
Feb  2 19:00:32 dom kernel: [   13.667147] pci 0000:02:00.0: reg 30 32bit mmio pref: [0xfffe0000-0xffffffff]
Feb  2 19:00:32 dom kernel: [   13.667163] pci 0000:02:00.0: supports D1 D2
Feb  2 19:00:32 dom kernel: [   13.667190] pci 0000:02:00.1: reg 10 64bit mmio: [0xc0110000-0xc0113fff]
Feb  2 19:00:32 dom kernel: [   13.667220] pci 0000:02:00.1: supports D1 D2
Feb  2 19:00:32 dom kernel: [   13.667257] pci 0000:00:03.0: bridge io port: [0x2000-0x2fff]
Feb  2 19:00:32 dom kernel: [   13.667260] pci 0000:00:03.0: bridge 32bit mmio: [0xc0100000-0xc01fffff]
Feb  2 19:00:32 dom kernel: [   13.667264] pci 0000:00:03.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
Feb  2 19:00:32 dom kernel: [   13.667295] pci 0000:03:00.0: reg 10 64bit mmio pref: [0xe0000000-0xefffffff]
Feb  2 19:00:32 dom kernel: [   13.667305] pci 0000:03:00.0: reg 18 64bit mmio: [0xc0000000-0xc000ffff]
Feb  2 19:00:32 dom kernel: [   13.667312] pci 0000:03:00.0: reg 20 io port: [0x1000-0x10ff]
Feb  2 19:00:32 dom kernel: [   13.667322] pci 0000:03:00.0: reg 30 32bit mmio pref: [0xfffe0000-0xffffffff]
Feb  2 19:00:32 dom kernel: [   13.667343] pci 0000:03:00.0: supports D1 D2
Feb  2 19:00:32 dom kernel: [   13.667379] pci 0000:03:00.1: reg 10 64bit mmio: [0xc0010000-0xc0013fff]
Feb  2 19:00:32 dom kernel: [   13.667419] pci 0000:03:00.1: supports D1 D2
Feb  2 19:00:32 dom kernel: [   13.667462] pci 0000:00:07.0: bridge io port: [0x1000-0x1fff]
Feb  2 19:00:32 dom kernel: [   13.667464] pci 0000:00:07.0: bridge 32bit mmio: [0xc0000000-0xc00fffff]
Feb  2 19:00:32 dom kernel: [   13.667468] pci 0000:00:07.0: bridge 64bit mmio pref: [0xe0000000-0xefffffff]
Feb  2 19:00:32 dom kernel: [   13.667589] pci 0000:00:1e.0: transparent bridge
Feb  2 19:00:32 dom kernel: [   13.667669] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Feb  2 19:00:32 dom kernel: [   13.668086] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
Feb  2 19:00:32 dom kernel: [   13.668202] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG1._PRT]
Feb  2 19:00:32 dom kernel: [   13.668253] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG3._PRT]
Feb  2 19:00:32 dom kernel: [   13.668303] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG7._PRT]
Feb  2 19:00:32 dom kernel: [   13.668353] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
Feb  2 19:00:32 dom kernel: [   13.668403] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
Feb  2 19:00:32 dom kernel: [   13.674897] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
Feb  2 19:00:32 dom kernel: [   13.675418] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
Feb  2 19:00:32 dom kernel: [   13.675940] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
Feb  2 19:00:32 dom kernel: [   13.676454] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
Feb  2 19:00:32 dom kernel: [   13.676978] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
Feb  2 19:00:32 dom kernel: [   13.677493] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
Feb  2 19:00:32 dom kernel: [   13.678017] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
Feb  2 19:00:32 dom kernel: [   13.678534] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
Feb  2 19:00:32 dom kernel: [   13.679050] vgaarb: device added: PCI:0000:02:00.0,decodes=io+mem,owns=io+mem,locks=none
Feb  2 19:00:32 dom kernel: [   13.679122] vgaarb: device added: PCI:0000:03:00.0,decodes=io+mem,owns=none,locks=none
Feb  2 19:00:32 dom kernel: [   13.679189] vgaarb: loaded
Feb  2 19:00:32 dom kernel: [   13.679280] PCI: Using ACPI for IRQ routing
Feb  2 19:00:32 dom kernel: [   13.679460] NetLabel: Initializing
Feb  2 19:00:32 dom kernel: [   13.679508] NetLabel:  domain hash size = 128
Feb  2 19:00:32 dom kernel: [   13.679557] NetLabel:  protocols = UNLABELED CIPSOv4
Feb  2 19:00:32 dom kernel: [   13.679617] NetLabel:  unlabeled traffic allowed by default
Feb  2 19:00:32 dom kernel: [   13.679764] hpet clockevent registered
Feb  2 19:00:32 dom kernel: [   13.679767] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
Feb  2 19:00:32 dom kernel: [   13.679824] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
Feb  2 19:00:32 dom kernel: [   13.680017] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
Feb  2 19:00:32 dom kernel: [   13.687588] Switching to clocksource tsc
Feb  2 19:00:32 dom kernel: [   13.693362] pnp: PnP ACPI init
Feb  2 19:00:32 dom kernel: [   13.693418] ACPI: bus type pnp registered
Feb  2 19:00:32 dom kernel: [   13.694745] pnp: PnP ACPI: found 8 devices
Feb  2 19:00:32 dom kernel: [   13.694795] ACPI: ACPI bus type pnp unregistered
Feb  2 19:00:32 dom kernel: [   13.694851] system 00:05: ioport range 0x500-0x53f has been reserved
Feb  2 19:00:32 dom kernel: [   13.694904] system 00:05: ioport range 0x400-0x47f has been reserved
Feb  2 19:00:32 dom kernel: [   13.694960] system 00:05: ioport range 0x680-0x6ff has been reserved
Feb  2 19:00:32 dom kernel: [   13.699640] pci 0000:02:00.0: BAR 6: no parent found for of device [0xfffe0000-0xffffffff]
Feb  2 19:00:32 dom kernel: [   13.700293] pci 0000:03:00.0: BAR 6: no parent found for of device [0xfffe0000-0xffffffff]
Feb  2 19:00:32 dom kernel: [   13.700399] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
Feb  2 19:00:32 dom kernel: [   13.700451] pci 0000:00:01.0:   IO window: disabled
Feb  2 19:00:32 dom kernel: [   13.700502] pci 0000:00:01.0:   MEM window: disabled
Feb  2 19:00:32 dom kernel: [   13.700554] pci 0000:00:01.0:   PREFETCH window: disabled
Feb  2 19:00:32 dom kernel: [   13.700607] pci 0000:00:03.0: PCI bridge, secondary bus 0000:02
Feb  2 19:00:32 dom kernel: [   13.700660] pci 0000:00:03.0:   IO window: 0x2000-0x2fff
Feb  2 19:00:32 dom kernel: [   13.700713] pci 0000:00:03.0:   MEM window: 0xc0100000-0xc01fffff
Feb  2 19:00:32 dom kernel: [   13.700767] pci 0000:00:03.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
Feb  2 19:00:32 dom kernel: [   13.700838] pci 0000:00:07.0: PCI bridge, secondary bus 0000:03
Feb  2 19:00:32 dom kernel: [   13.700890] pci 0000:00:07.0:   IO window: 0x1000-0x1fff
Feb  2 19:00:32 dom kernel: [   13.700945] pci 0000:00:07.0:   MEM window: 0xc0000000-0xc00fffff
Feb  2 19:00:32 dom kernel: [   13.701000] pci 0000:00:07.0:   PREFETCH window: 0x000000e0000000-0x000000efffffff
Feb  2 19:00:32 dom kernel: [   13.701070] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:04
Feb  2 19:00:32 dom kernel: [   13.701121] pci 0000:00:1c.0:   IO window: disabled
Feb  2 19:00:32 dom kernel: [   13.701174] pci 0000:00:1c.0:   MEM window: disabled
Feb  2 19:00:32 dom kernel: [   13.701226] pci 0000:00:1c.0:   PREFETCH window: disabled
Feb  2 19:00:32 dom kernel: [   13.701278] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:05
Feb  2 19:00:32 dom kernel: [   13.701330] pci 0000:00:1c.1:   IO window: disabled
Feb  2 19:00:32 dom kernel: [   13.701382] pci 0000:00:1c.1:   MEM window: disabled
Feb  2 19:00:32 dom kernel: [   13.701434] pci 0000:00:1c.1:   PREFETCH window: disabled
Feb  2 19:00:32 dom kernel: [   13.701486] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:06
Feb  2 19:00:32 dom kernel: [   13.701538] pci 0000:00:1e.0:   IO window: disabled
Feb  2 19:00:32 dom kernel: [   13.701590] pci 0000:00:1e.0:   MEM window: disabled
Feb  2 19:00:32 dom kernel: [   13.701642] pci 0000:00:1e.0:   PREFETCH window: disabled
Feb  2 19:00:32 dom kernel: [   13.701701] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [   13.701706] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Feb  2 19:00:32 dom kernel: [   13.701762] pci 0000:00:01.0: setting latency timer to 64
Feb  2 19:00:32 dom kernel: [   13.701767] pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Feb  2 19:00:32 dom kernel: [   13.701823] pci 0000:00:03.0: setting latency timer to 64
Feb  2 19:00:32 dom kernel: [   13.701828] pci 0000:00:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Feb  2 19:00:32 dom kernel: [   13.701882] pci 0000:00:07.0: setting latency timer to 64
Feb  2 19:00:32 dom kernel: [   13.701889] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [   13.701893] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Feb  2 19:00:32 dom kernel: [   13.701951] pci 0000:00:1c.0: setting latency timer to 64
Feb  2 19:00:32 dom kernel: [   13.701957] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
Feb  2 19:00:32 dom kernel: [   13.702013] pci 0000:00:1c.1: setting latency timer to 64
Feb  2 19:00:32 dom kernel: [   13.702018] pci 0000:00:1e.0: setting latency timer to 64
Feb  2 19:00:32 dom kernel: [   13.702021] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
Feb  2 19:00:32 dom kernel: [   13.702022] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
Feb  2 19:00:32 dom kernel: [   13.702024] pci_bus 0000:02: resource 0 io:  [0x2000-0x2fff]
Feb  2 19:00:32 dom kernel: [   13.702026] pci_bus 0000:02: resource 1 mem: [0xc0100000-0xc01fffff]
Feb  2 19:00:32 dom kernel: [   13.702027] pci_bus 0000:02: resource 2 pref mem [0xd0000000-0xdfffffff]
Feb  2 19:00:32 dom kernel: [   13.702029] pci_bus 0000:03: resource 0 io:  [0x1000-0x1fff]
Feb  2 19:00:32 dom kernel: [   13.702030] pci_bus 0000:03: resource 1 mem: [0xc0000000-0xc00fffff]
Feb  2 19:00:32 dom kernel: [   13.702032] pci_bus 0000:03: resource 2 pref mem [0xe0000000-0xefffffff]
Feb  2 19:00:32 dom kernel: [   13.702034] pci_bus 0000:06: resource 3 io:  [0x00-0xffff]
Feb  2 19:00:32 dom kernel: [   13.702035] pci_bus 0000:06: resource 4 mem: [0x000000-0xffffffffffffffff]
Feb  2 19:00:32 dom kernel: [   13.702057] NET: Registered protocol family 2
Feb  2 19:00:32 dom kernel: [   13.702276] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
Feb  2 19:00:32 dom kernel: [   13.703141] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
Feb  2 19:00:32 dom kernel: [   13.704651] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Feb  2 19:00:32 dom kernel: [   13.704903] TCP: Hash tables configured (established 524288 bind 65536)
Feb  2 19:00:32 dom kernel: [   13.704960] TCP reno registered
Feb  2 19:00:32 dom kernel: [   13.705094] NET: Registered protocol family 1
Feb  2 19:00:32 dom kernel: [   13.705488] pci 0000:02:00.0: Boot video device
Feb  2 19:00:32 dom kernel: [   13.705523] Trying to unpack rootfs image as initramfs...
Feb  2 19:00:32 dom kernel: [   13.753968] Freeing initrd memory: 4133k freed
Feb  2 19:00:32 dom kernel: [   13.754973] audit: initializing netlink socket (disabled)
Feb  2 19:00:32 dom kernel: [   13.755032] type=2000 audit(1265133607.791:1): initialized
Feb  2 19:00:32 dom kernel: [   13.761928] HugeTLB registered 2 MB page size, pre-allocated 0 pages
Feb  2 19:00:32 dom kernel: [   13.762947] VFS: Disk quotas dquot_6.5.2
Feb  2 19:00:32 dom kernel: [   13.763032] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Feb  2 19:00:32 dom kernel: [   13.763187] msgmni has been set to 15984
Feb  2 19:00:32 dom kernel: [   13.763412] alg: No test for stdrng (krng)
Feb  2 19:00:32 dom kernel: [   13.763496] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
Feb  2 19:00:32 dom kernel: [   13.763563] io scheduler noop registered
Feb  2 19:00:32 dom kernel: [   13.763612] io scheduler anticipatory registered
Feb  2 19:00:32 dom kernel: [   13.763662] io scheduler deadline registered
Feb  2 19:00:32 dom kernel: [   13.763734] io scheduler cfq registered (default)
Feb  2 19:00:32 dom kernel: [   13.763936] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [   13.763944] pcieport 0000:00:01.0: irq 26 for MSI/MSI-X
Feb  2 19:00:32 dom kernel: [   13.763950] pcieport 0000:00:01.0: setting latency timer to 64
Feb  2 19:00:32 dom kernel: [   13.764028] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [   13.764034] pcieport 0000:00:03.0: irq 27 for MSI/MSI-X
Feb  2 19:00:32 dom kernel: [   13.764039] pcieport 0000:00:03.0: setting latency timer to 64
Feb  2 19:00:32 dom kernel: [   13.764116] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [   13.764122] pcieport 0000:00:07.0: irq 28 for MSI/MSI-X
Feb  2 19:00:32 dom kernel: [   13.764127] pcieport 0000:00:07.0: setting latency timer to 64
Feb  2 19:00:32 dom kernel: [   13.764203] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [   13.764210] pcieport 0000:00:1c.0: irq 29 for MSI/MSI-X
Feb  2 19:00:32 dom kernel: [   13.764216] pcieport 0000:00:1c.0: setting latency timer to 64
Feb  2 19:00:32 dom kernel: [   13.764295] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [   13.764302] pcieport 0000:00:1c.1: irq 30 for MSI/MSI-X
Feb  2 19:00:32 dom kernel: [   13.764308] pcieport 0000:00:1c.1: setting latency timer to 64
Feb  2 19:00:32 dom kernel: [   13.765136] Linux agpgart interface v0.103
Feb  2 19:00:32 dom kernel: [   13.765210] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Feb  2 19:00:32 dom kernel: [   13.765360] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
Feb  2 19:00:32 dom kernel: [   13.766150] brd: module loaded
Feb  2 19:00:32 dom kernel: [   13.766247] input: Macintosh mouse button emulation as /devices/virtual/input/input0
Feb  2 19:00:32 dom kernel: [   13.766359] PNP: No PS/2 controller found. Probing ports directly.
Feb  2 19:00:32 dom kernel: [   13.769441] serio: i8042 KBD port at 0x60,0x64 irq 1
Feb  2 19:00:32 dom kernel: [   13.769495] serio: i8042 AUX port at 0x60,0x64 irq 12
Feb  2 19:00:32 dom kernel: [   13.769602] mice: PS/2 mouse device common for all mice
Feb  2 19:00:32 dom kernel: [   13.769688] Driver 'rtc_cmos' needs updating - please use bus_type methods
Feb  2 19:00:32 dom kernel: [   13.769758] rtc_cmos 00:02: RTC can wake from S4
Feb  2 19:00:32 dom kernel: [   13.769827] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
Feb  2 19:00:32 dom kernel: [   13.769903] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
Feb  2 19:00:32 dom kernel: [   13.769962] cpuidle: using governor ladder
Feb  2 19:00:32 dom kernel: [   13.770011] cpuidle: using governor menu
Feb  2 19:00:32 dom kernel: [   13.770307] TCP cubic registered
Feb  2 19:00:32 dom kernel: [   13.770405] PM: Checking image partition /dev/md0
Feb  2 19:00:32 dom kernel: [   14.100064] PM: Resume from disk failed.
Feb  2 19:00:32 dom kernel: [   14.100071] registered taskstats version 1
Feb  2 19:00:32 dom kernel: [   14.100541]   Magic number: 14:992:37
Feb  2 19:00:32 dom kernel: [   14.100635] rtc_cmos 00:02: setting system clock to 2010-02-02 18:00:21 UTC (1265133621)
Feb  2 19:00:32 dom kernel: [   14.100704] BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
Feb  2 19:00:32 dom kernel: [   14.100835] Freeing unused kernel memory: 700k freed
Feb  2 19:00:32 dom kernel: [   14.370333] usbcore: registered new interface driver usbfs
Feb  2 19:00:32 dom kernel: [   14.370395] usbcore: registered new interface driver hub
Feb  2 19:00:32 dom kernel: [   14.370465] usbcore: registered new device driver usb
Feb  2 19:00:32 dom kernel: [   14.377784] usbcore: registered new interface driver hiddev
Feb  2 19:00:32 dom kernel: [   14.377843] usbcore: registered new interface driver usbhid
Feb  2 19:00:32 dom kernel: [   14.377895] usbhid: v2.6:USB HID core driver
Feb  2 19:00:32 dom kernel: [   14.380894] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Feb  2 19:00:32 dom kernel: [   14.380972] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [   14.380978] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Feb  2 19:00:32 dom kernel: [   14.381050] ehci_hcd 0000:00:1a.7: setting latency timer to 64
Feb  2 19:00:32 dom kernel: [   14.381053] ehci_hcd 0000:00:1a.7: EHCI Host Controller
Feb  2 19:00:32 dom kernel: [   14.381115] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
Feb  2 19:00:32 dom kernel: [   14.381204] ehci_hcd 0000:00:1a.7: debug port 1
Feb  2 19:00:32 dom kernel: [   14.385112] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
Feb  2 19:00:32 dom kernel: [   14.385124] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xc0222000
Feb  2 19:00:32 dom kernel: [   14.394928] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
Feb  2 19:00:32 dom kernel: [   14.395009] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
Feb  2 19:00:32 dom kernel: [   14.395063] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb  2 19:00:32 dom kernel: [   14.395129] usb usb1: Product: EHCI Host Controller
Feb  2 19:00:32 dom kernel: [   14.395180] usb usb1: Manufacturer: Linux 2.6.32-desktop-1mnb ehci_hcd
Feb  2 19:00:32 dom kernel: [   14.395233] usb usb1: SerialNumber: 0000:00:1a.7
Feb  2 19:00:32 dom kernel: [   14.395322] usb usb1: configuration #1 chosen from 1 choice
Feb  2 19:00:32 dom kernel: [   14.395391] hub 1-0:1.0: USB hub found
Feb  2 19:00:32 dom kernel: [   14.395442] hub 1-0:1.0: 6 ports detected
Feb  2 19:00:32 dom kernel: [   14.395534] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [   14.395538] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
Feb  2 19:00:32 dom kernel: [   14.395600] ehci_hcd 0000:00:1d.7: setting latency timer to 64
Feb  2 19:00:32 dom kernel: [   14.395603] ehci_hcd 0000:00:1d.7: EHCI Host Controller
Feb  2 19:00:32 dom kernel: [   14.395657] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
Feb  2 19:00:32 dom kernel: [   14.395744] ehci_hcd 0000:00:1d.7: debug port 1
Feb  2 19:00:32 dom kernel: [   14.399663] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
Feb  2 19:00:32 dom kernel: [   14.399672] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xc0221000
Feb  2 19:00:32 dom kernel: [   14.408891] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
Feb  2 19:00:32 dom kernel: [   14.408961] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
Feb  2 19:00:32 dom kernel: [   14.409019] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb  2 19:00:32 dom kernel: [   14.409085] usb usb2: Product: EHCI Host Controller
Feb  2 19:00:32 dom kernel: [   14.409136] usb usb2: Manufacturer: Linux 2.6.32-desktop-1mnb ehci_hcd
Feb  2 19:00:32 dom kernel: [   14.409189] usb usb2: SerialNumber: 0000:00:1d.7
Feb  2 19:00:32 dom kernel: [   14.409274] usb usb2: configuration #1 chosen from 1 choice
Feb  2 19:00:32 dom kernel: [   14.409341] hub 2-0:1.0: USB hub found
Feb  2 19:00:32 dom kernel: [   14.409391] hub 2-0:1.0: 6 ports detected
Feb  2 19:00:32 dom kernel: [   14.411846] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
Feb  2 19:00:32 dom kernel: [   14.414195] uhci_hcd: USB Universal Host Controller Interface driver
Feb  2 19:00:32 dom kernel: [   14.414267] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Feb  2 19:00:32 dom kernel: [   14.414326] uhci_hcd 0000:00:1a.0: setting latency timer to 64
Feb  2 19:00:32 dom kernel: [   14.414328] uhci_hcd 0000:00:1a.0: UHCI Host Controller
Feb  2 19:00:32 dom kernel: [   14.414383] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
Feb  2 19:00:32 dom kernel: [   14.414476] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000030e0
Feb  2 19:00:32 dom kernel: [   14.414551] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
Feb  2 19:00:32 dom kernel: [   14.414605] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb  2 19:00:32 dom kernel: [   14.414671] usb usb3: Product: UHCI Host Controller
Feb  2 19:00:32 dom kernel: [   14.414721] usb usb3: Manufacturer: Linux 2.6.32-desktop-1mnb uhci_hcd
Feb  2 19:00:32 dom kernel: [   14.414774] usb usb3: SerialNumber: 0000:00:1a.0
Feb  2 19:00:32 dom kernel: [   14.414861] usb usb3: configuration #1 chosen from 1 choice
Feb  2 19:00:32 dom kernel: [   14.414934] hub 3-0:1.0: USB hub found
Feb  2 19:00:32 dom kernel: [   14.414985] hub 3-0:1.0: 2 ports detected
Feb  2 19:00:32 dom kernel: [   14.415067] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [   14.415071] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
Feb  2 19:00:32 dom kernel: [   14.415128] uhci_hcd 0000:00:1a.1: setting latency timer to 64
Feb  2 19:00:32 dom kernel: [   14.415131] uhci_hcd 0000:00:1a.1: UHCI Host Controller
Feb  2 19:00:32 dom kernel: [   14.415185] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
Feb  2 19:00:32 dom kernel: [   14.415277] uhci_hcd 0000:00:1a.1: irq 21, io base 0x000030c0
Feb  2 19:00:32 dom kernel: [   14.415348] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
Feb  2 19:00:32 dom kernel: [   14.415403] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb  2 19:00:32 dom kernel: [   14.415469] usb usb4: Product: UHCI Host Controller
Feb  2 19:00:32 dom kernel: [   14.415519] usb usb4: Manufacturer: Linux 2.6.32-desktop-1mnb uhci_hcd
Feb  2 19:00:32 dom kernel: [   14.415572] usb usb4: SerialNumber: 0000:00:1a.1
Feb  2 19:00:32 dom kernel: [   14.415656] usb usb4: configuration #1 chosen from 1 choice
Feb  2 19:00:32 dom kernel: [   14.415723] hub 4-0:1.0: USB hub found
Feb  2 19:00:32 dom kernel: [   14.415773] hub 4-0:1.0: 2 ports detected
Feb  2 19:00:32 dom kernel: [   14.415853] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [   14.415857] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
Feb  2 19:00:32 dom kernel: [   14.415936] uhci_hcd 0000:00:1a.2: setting latency timer to 64
Feb  2 19:00:32 dom kernel: [   14.415939] uhci_hcd 0000:00:1a.2: UHCI Host Controller
Feb  2 19:00:32 dom kernel: [   14.415994] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
Feb  2 19:00:32 dom kernel: [   14.416085] uhci_hcd 0000:00:1a.2: irq 19, io base 0x000030a0
Feb  2 19:00:32 dom kernel: [   14.416157] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
Feb  2 19:00:32 dom kernel: [   14.416211] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb  2 19:00:32 dom kernel: [   14.416278] usb usb5: Product: UHCI Host Controller
Feb  2 19:00:32 dom kernel: [   14.416328] usb usb5: Manufacturer: Linux 2.6.32-desktop-1mnb uhci_hcd
Feb  2 19:00:32 dom kernel: [   14.416381] usb usb5: SerialNumber: 0000:00:1a.2
Feb  2 19:00:32 dom kernel: [   14.416469] usb usb5: configuration #1 chosen from 1 choice
Feb  2 19:00:32 dom kernel: [   14.416535] hub 5-0:1.0: USB hub found
Feb  2 19:00:32 dom kernel: [   14.416585] hub 5-0:1.0: 2 ports detected
Feb  2 19:00:32 dom kernel: [   14.416666] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
Feb  2 19:00:32 dom kernel: [   14.416724] uhci_hcd 0000:00:1d.0: setting latency timer to 64
Feb  2 19:00:32 dom kernel: [   14.416726] uhci_hcd 0000:00:1d.0: UHCI Host Controller
Feb  2 19:00:32 dom kernel: [   14.416784] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
Feb  2 19:00:32 dom kernel: [   14.417467] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00003080
Feb  2 19:00:32 dom kernel: [   14.417540] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
Feb  2 19:00:32 dom kernel: [   14.417594] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb  2 19:00:32 dom kernel: [   14.417661] usb usb6: Product: UHCI Host Controller
Feb  2 19:00:32 dom kernel: [   14.417711] usb usb6: Manufacturer: Linux 2.6.32-desktop-1mnb uhci_hcd
Feb  2 19:00:32 dom kernel: [   14.417764] usb usb6: SerialNumber: 0000:00:1d.0
Feb  2 19:00:32 dom kernel: [   14.417850] usb usb6: configuration #1 chosen from 1 choice
Feb  2 19:00:32 dom kernel: [   14.417919] hub 6-0:1.0: USB hub found
Feb  2 19:00:32 dom kernel: [   14.417969] hub 6-0:1.0: 2 ports detected
Feb  2 19:00:32 dom kernel: [   14.418048] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Feb  2 19:00:32 dom kernel: [   14.418105] uhci_hcd 0000:00:1d.1: setting latency timer to 64
Feb  2 19:00:32 dom kernel: [   14.418108] uhci_hcd 0000:00:1d.1: UHCI Host Controller
Feb  2 19:00:32 dom kernel: [   14.418163] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
Feb  2 19:00:32 dom kernel: [   14.418249] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00003060
Feb  2 19:00:32 dom kernel: [   14.418320] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
Feb  2 19:00:32 dom kernel: [   14.418374] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb  2 19:00:32 dom kernel: [   14.418440] usb usb7: Product: UHCI Host Controller
Feb  2 19:00:32 dom kernel: [   14.418491] usb usb7: Manufacturer: Linux 2.6.32-desktop-1mnb uhci_hcd
Feb  2 19:00:32 dom kernel: [   14.418544] usb usb7: SerialNumber: 0000:00:1d.1
Feb  2 19:00:32 dom kernel: [   14.418627] usb usb7: configuration #1 chosen from 1 choice
Feb  2 19:00:32 dom kernel: [   14.418695] hub 7-0:1.0: USB hub found
Feb  2 19:00:32 dom kernel: [   14.418744] hub 7-0:1.0: 2 ports detected
Feb  2 19:00:32 dom kernel: [   14.418825] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Feb  2 19:00:32 dom kernel: [   14.418885] uhci_hcd 0000:00:1d.2: setting latency timer to 64
Feb  2 19:00:32 dom kernel: [   14.418888] uhci_hcd 0000:00:1d.2: UHCI Host Controller
Feb  2 19:00:32 dom kernel: [   14.418942] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
Feb  2 19:00:32 dom kernel: [   14.419028] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00003040
Feb  2 19:00:32 dom kernel: [   14.419100] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
Feb  2 19:00:32 dom kernel: [   14.419154] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb  2 19:00:32 dom kernel: [   14.419221] usb usb8: Product: UHCI Host Controller
Feb  2 19:00:32 dom kernel: [   14.419272] usb usb8: Manufacturer: Linux 2.6.32-desktop-1mnb uhci_hcd
Feb  2 19:00:32 dom kernel: [   14.419325] usb usb8: SerialNumber: 0000:00:1d.2
Feb  2 19:00:32 dom kernel: [   14.419408] usb usb8: configuration #1 chosen from 1 choice
Feb  2 19:00:32 dom kernel: [   14.419473] hub 8-0:1.0: USB hub found
Feb  2 19:00:32 dom kernel: [   14.419525] hub 8-0:1.0: 2 ports detected
Feb  2 19:00:32 dom kernel: [   14.440215] md: raid1 personality registered for level 1
Feb  2 19:00:32 dom kernel: [   14.455041] SCSI subsystem initialized
Feb  2 19:00:32 dom kernel: [   14.475191] libata version 3.00 loaded.
Feb  2 19:00:32 dom kernel: [   14.479162] ahci 0000:00:1f.2: version 3.0
Feb  2 19:00:32 dom kernel: [   14.479172] ahci 0000:00:1f.2: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Feb  2 19:00:32 dom kernel: [   14.479261] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [   14.479268] ahci 0000:00:1f.2: irq 31 for MSI/MSI-X
Feb  2 19:00:32 dom kernel: [   14.479328] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
Feb  2 19:00:32 dom kernel: [   14.479397] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc ems
Feb  2 19:00:32 dom kernel: [   14.479467] ahci 0000:00:1f.2: setting latency timer to 64
Feb  2 19:00:32 dom kernel: [   14.488720] scsi0 : ahci
Feb  2 19:00:32 dom kernel: [   14.488822] scsi1 : ahci
Feb  2 19:00:32 dom kernel: [   14.488902] scsi2 : ahci
Feb  2 19:00:32 dom kernel: [   14.488980] scsi3 : ahci
Feb  2 19:00:32 dom kernel: [   14.489059] scsi4 : ahci
Feb  2 19:00:32 dom kernel: [   14.489138] scsi5 : ahci
Feb  2 19:00:32 dom kernel: [   14.489281] ata1: SATA max UDMA/133 abar m2048@0xc0220000 port 0xc0220100 irq 31
Feb  2 19:00:32 dom kernel: [   14.489349] ata2: SATA max UDMA/133 abar m2048@0xc0220000 port 0xc0220180 irq 31
Feb  2 19:00:32 dom kernel: [   14.489417] ata3: SATA max UDMA/133 abar m2048@0xc0220000 port 0xc0220200 irq 31
Feb  2 19:00:32 dom kernel: [   14.489484] ata4: SATA max UDMA/133 abar m2048@0xc0220000 port 0xc0220280 irq 31
Feb  2 19:00:32 dom kernel: [   14.489552] ata5: SATA max UDMA/133 abar m2048@0xc0220000 port 0xc0220300 irq 31
Feb  2 19:00:32 dom kernel: [   14.489619] ata6: SATA max UDMA/133 abar m2048@0xc0220000 port 0xc0220380 irq 31
Feb  2 19:00:32 dom kernel: [   14.793917] ata5: SATA link down (SStatus 0 SControl 300)
Feb  2 19:00:32 dom kernel: [   14.793922] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Feb  2 19:00:32 dom kernel: [   14.793928] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Feb  2 19:00:32 dom kernel: [   14.793948] ata4: SATA link down (SStatus 0 SControl 300)
Feb  2 19:00:32 dom kernel: [   14.793951] ata6: SATA link down (SStatus 0 SControl 300)
Feb  2 19:00:32 dom kernel: [   14.794991] ata3.00: ATAPI: Optiarc DVD RW AD-7201S, 1.05, max UDMA/100
Feb  2 19:00:32 dom kernel: [   14.795154] ata1.00: ATA-8: WDC WD10EADS-00M2B0, 01.00A01, max UDMA/133
Feb  2 19:00:32 dom kernel: [   14.795208] ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
Feb  2 19:00:32 dom kernel: [   14.796480] ata3.00: configured for UDMA/100
Feb  2 19:00:32 dom kernel: [   14.796809] ata1.00: configured for UDMA/133
Feb  2 19:00:32 dom kernel: [   14.797917] usb 1-3: new high speed USB device using ehci_hcd and address 3
Feb  2 19:00:32 dom kernel: [   14.806969] scsi 0:0:0:0: Direct-Access     ATA      WDC WD10EADS-00M 01.0 PQ: 0 ANSI: 5
Feb  2 19:00:32 dom kernel: [   14.807131] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Feb  2 19:00:32 dom kernel: [   14.807221] sd 0:0:0:0: [sda] Write Protect is off
Feb  2 19:00:32 dom kernel: [   14.807272] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Feb  2 19:00:32 dom kernel: [   14.807285] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Feb  2 19:00:32 dom kernel: [   14.807444]  sda:
Feb  2 19:00:32 dom kernel: [   14.912727] usb 1-3: New USB device found, idVendor=04e8, idProduct=342e
Feb  2 19:00:32 dom kernel: [   14.912833] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Feb  2 19:00:32 dom kernel: [   14.912888] usb 1-3: Product: SCX-4300 Series
Feb  2 19:00:32 dom kernel: [   14.912936] usb 1-3: Manufacturer: Samsung
Feb  2 19:00:32 dom kernel: [   14.912984] usb 1-3: SerialNumber: 1457BFFQA00445L.
Feb  2 19:00:32 dom kernel: [   14.913077] usb 1-3: configuration #1 chosen from 1 choice
Feb  2 19:00:32 dom kernel: [   14.997393] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Feb  2 19:00:32 dom kernel: [   15.008680] ata2.00: ATA-8: WDC WD10EADS-00M2B0, 01.00A01, max UDMA/133
Feb  2 19:00:32 dom kernel: [   15.008740] ata2.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
Feb  2 19:00:32 dom kernel: [   15.010842] ata2.00: configured for UDMA/133
Feb  2 19:00:32 dom kernel: [   15.021399] scsi 1:0:0:0: Direct-Access     ATA      WDC WD10EADS-00M 01.0 PQ: 0 ANSI: 5
Feb  2 19:00:32 dom kernel: [   15.021536] sd 1:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Feb  2 19:00:32 dom kernel: [   15.021627] sd 1:0:0:0: [sdb] Write Protect is off
Feb  2 19:00:32 dom kernel: [   15.021677] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Feb  2 19:00:32 dom kernel: [   15.021690] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Feb  2 19:00:32 dom kernel: [   15.021834]  sdb:
Feb  2 19:00:32 dom kernel: [   15.023048] scsi 2:0:0:0: CD-ROM            Optiarc  DVD RW AD-7201S  1.05 PQ: 0 ANSI: 5
Feb  2 19:00:32 dom kernel: [   15.050596]  sdb1 sdb2 sdb3 < sdb5 sdb6 > sdb4
Feb  2 19:00:32 dom kernel: [   15.086193] sd 1:0:0:0: [sdb] Attached SCSI disk
Feb  2 19:00:32 dom kernel: [   15.219815] usb 3-2: new full speed USB device using uhci_hcd and address 2
Feb  2 19:00:32 dom kernel: [   15.317952]  sda1 sda2 sda3 < sda5 sda6 > sda4
Feb  2 19:00:32 dom kernel: [   15.357545] sd 0:0:0:0: [sda] Attached SCSI disk
Feb  2 19:00:32 dom kernel: [   15.358123] usb 3-2: New USB device found, idVendor=067b, idProduct=2303
Feb  2 19:00:32 dom kernel: [   15.358177] usb 3-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Feb  2 19:00:32 dom kernel: [   15.358264] usb 3-2: configuration #1 chosen from 1 choice
Feb  2 19:00:32 dom kernel: [   15.566155] usb 4-2: new low speed USB device using uhci_hcd and address 2
Feb  2 19:00:32 dom kernel: [   15.691482] md: md1 stopped.
Feb  2 19:00:32 dom kernel: [   15.692210] md: bind<sdb2>
Feb  2 19:00:32 dom kernel: [   15.692390] md: bind<sda2>
Feb  2 19:00:32 dom kernel: [   15.692983] raid1: raid set md1 active with 2 out of 2 mirrors
Feb  2 19:00:32 dom kernel: [   15.693047] md1: detected capacity change from 0 to 104855764992
Feb  2 19:00:32 dom kernel: [   15.694838] md: md0 stopped.
Feb  2 19:00:32 dom kernel: [   15.695481] md: bind<sda1>
Feb  2 19:00:32 dom kernel: [   15.695655] md: bind<sdb1>
Feb  2 19:00:32 dom kernel: [   15.696212] raid1: raid set md0 active with 2 out of 2 mirrors
Feb  2 19:00:32 dom kernel: [   15.696277] md0: detected capacity change from 0 to 10478878720
Feb  2 19:00:32 dom kernel: [   15.729973] usb 4-2: New USB device found, idVendor=099a, idProduct=7202
Feb  2 19:00:32 dom kernel: [   15.730032] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Feb  2 19:00:32 dom kernel: [   15.730091] usb 4-2: Product: WirelessUSB
Feb  2 19:00:32 dom kernel: [   15.730139] usb 4-2: Manufacturer: Cypress
Feb  2 19:00:32 dom kernel: [   15.730226] usb 4-2: configuration #1 chosen from 1 choice
Feb  2 19:00:32 dom kernel: [   15.753025] input: Cypress WirelessUSB as /devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2:1.0/input/input1
Feb  2 19:00:32 dom kernel: [   15.753118] generic-usb 0003:099A:7202.0001: input,hidraw0: USB HID v1.11 Keyboard [Cypress WirelessUSB] on usb-0000:00:1a.1-2/input0
Feb  2 19:00:32 dom kernel: [   15.786110] input: Cypress WirelessUSB as /devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2:1.1/input/input2
Feb  2 19:00:32 dom kernel: [   15.786235] generic-usb 0003:099A:7202.0002: input,hiddev0,hidraw1: USB HID v1.11 Mouse [Cypress WirelessUSB] on usb-0000:00:1a.1-2/input1
Feb  2 19:00:32 dom kernel: [   15.874526]  md1:
Feb  2 19:00:32 dom kernel: [   15.958831]  md0: unknown partition table
Feb  2 19:00:32 dom kernel: [   15.987482] PM: Marking nosave pages: 000000000008f000 - 0000000000090000
Feb  2 19:00:32 dom kernel: [   15.987484] PM: Marking nosave pages: 000000000009d000 - 0000000000100000
Feb  2 19:00:32 dom kernel: [   15.987487] PM: Marking nosave pages: 00000000bc6e8000 - 00000000bca12000
Feb  2 19:00:32 dom kernel: [   15.987498] PM: Marking nosave pages: 00000000bf4bd000 - 00000000bf4bf000
Feb  2 19:00:32 dom kernel: [   15.987499] PM: Marking nosave pages: 00000000bf718000 - 00000000bf7bf000
Feb  2 19:00:32 dom kernel: [   15.987503] PM: Marking nosave pages: 00000000bf7e0000 - 00000000bf7ff000
Feb  2 19:00:32 dom kernel: [   15.987504] PM: Marking nosave pages: 00000000bf800000 - 0000000100000000
Feb  2 19:00:32 dom kernel: [   15.988120] PM: Basic memory bitmaps created
Feb  2 19:00:32 dom kernel: [   15.990845] usb 5-2: new low speed USB device using uhci_hcd and address 2
Feb  2 19:00:32 dom kernel: [   16.020294] PM: Basic memory bitmaps freed
Feb  2 19:00:32 dom kernel: [   16.046928] EXT4-fs (md1): mounted filesystem with ordered data mode
Feb  2 19:00:32 dom kernel: [   16.149441] Tomoyo security MAC extension available but disabled by default. If you want to
Feb  2 19:00:32 dom kernel: [   16.149443] enable and use it, ccs-tools package must be installed.
Feb  2 19:00:32 dom kernel: [   16.154693] usb 5-2: New USB device found, idVendor=099a, idProduct=7202
Feb  2 19:00:32 dom kernel: [   16.154756] usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Feb  2 19:00:32 dom kernel: [   16.154811] usb 5-2: Product: WirelessUSB
Feb  2 19:00:32 dom kernel: [   16.154859] usb 5-2: Manufacturer: Cypress
Feb  2 19:00:32 dom kernel: [   16.154949] usb 5-2: configuration #1 chosen from 1 choice
Feb  2 19:00:32 dom kernel: [   16.177737] input: Cypress WirelessUSB as /devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.0/input/input3
Feb  2 19:00:32 dom kernel: [   16.177830] generic-usb 0003:099A:7202.0003: input,hidraw2: USB HID v1.11 Keyboard [Cypress WirelessUSB] on usb-0000:00:1a.2-2/input0
Feb  2 19:00:32 dom kernel: [   16.210830] input: Cypress WirelessUSB as /devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.1/input/input4
Feb  2 19:00:32 dom kernel: [   16.210946] generic-usb 0003:099A:7202.0004: input,hiddev1,hidraw3: USB HID v1.11 Mouse [Cypress WirelessUSB] on usb-0000:00:1a.2-2/input1
Feb  2 19:00:32 dom kernel: [   20.259638] udev: starting version 151
Feb  2 19:00:32 dom kernel: [   20.471066] ACPI: WMI: Mapper loaded
Feb  2 19:00:32 dom kernel: [   20.520675] sd 0:0:0:0: Attached scsi generic sg0 type 0
Feb  2 19:00:32 dom kernel: [   20.520709] sd 1:0:0:0: Attached scsi generic sg1 type 0
Feb  2 19:00:32 dom kernel: [   20.520729] sr 2:0:0:0: Attached scsi generic sg2 type 5
Feb  2 19:00:32 dom kernel: [   20.523251] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Feb  2 19:00:32 dom kernel: [   20.523255] Uniform CD-ROM driver Revision: 3.20
Feb  2 19:00:32 dom kernel: [   20.523345] sr 2:0:0:0: Attached scsi CD-ROM sr0
Feb  2 19:00:32 dom kernel: [   20.524664] iTCO_vendor_support: vendor-support=0
Feb  2 19:00:32 dom kernel: [   20.528952] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input5
Feb  2 19:00:32 dom kernel: [   20.528962] ACPI: Sleep Button [SLPB]
Feb  2 19:00:32 dom kernel: [   20.529023] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input6
Feb  2 19:00:32 dom kernel: [   20.529027] ACPI: Power Button [PWRF]
Feb  2 19:00:32 dom kernel: [   20.540491] Monitor-Mwait will be used to enter C-1 state
Feb  2 19:00:32 dom kernel: [   20.540599] Monitor-Mwait will be used to enter C-3 state
Feb  2 19:00:32 dom kernel: [   20.540655] processor LNXCPU:00: registered as cooling_device0
Feb  2 19:00:32 dom kernel: [   20.541233] processor LNXCPU:01: registered as cooling_device1
Feb  2 19:00:32 dom kernel: [   20.541331] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
Feb  2 19:00:32 dom kernel: [   20.541388] iTCO_wdt: Found a ICH10R TCO device (Version=2, TCOBASE=0x0460)
Feb  2 19:00:32 dom kernel: [   20.541430] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=1)
Feb  2 19:00:32 dom kernel: [   20.541760] processor LNXCPU:02: registered as cooling_device2
Feb  2 19:00:32 dom kernel: [   20.542328] processor LNXCPU:03: registered as cooling_device3
Feb  2 19:00:32 dom kernel: [   20.542852] processor LNXCPU:04: registered as cooling_device4
Feb  2 19:00:32 dom kernel: [   20.543443] processor LNXCPU:05: registered as cooling_device5
Feb  2 19:00:32 dom kernel: [   20.543915] processor LNXCPU:06: registered as cooling_device6
Feb  2 19:00:32 dom kernel: [   20.544391] processor LNXCPU:07: registered as cooling_device7
Feb  2 19:00:32 dom kernel: [   20.549135] input: PC Speaker as /devices/platform/pcspkr/input/input7
Feb  2 19:00:32 dom kernel: [   20.571990] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 18 (level, low) -> IRQ 18
Feb  2 19:00:32 dom kernel: [   20.604381] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
Feb  2 19:00:32 dom kernel: [   20.604383] e1000e: Copyright (c) 1999-2008 Intel Corporation.
Feb  2 19:00:32 dom kernel: [   20.604410] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [   20.604415] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
Feb  2 19:00:32 dom kernel: [   20.604421] e1000e 0000:00:19.0: setting latency timer to 64
Feb  2 19:00:32 dom kernel: [   20.604503] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [   20.604512] e1000e 0000:00:19.0: irq 32 for MSI/MSI-X
Feb  2 19:00:32 dom kernel: [   20.616645] usbcore: registered new interface driver usbserial
Feb  2 19:00:32 dom kernel: [   20.616653] USB Serial support registered for generic
Feb  2 19:00:32 dom kernel: [   20.616676] usbcore: registered new interface driver usbserial_generic
Feb  2 19:00:32 dom kernel: [   20.616677] usbserial: USB Serial Driver core
Feb  2 19:00:32 dom kernel: [   20.695849] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1c:c0:a1:e2:0b
Feb  2 19:00:32 dom kernel: [   20.695852] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
Feb  2 19:00:32 dom kernel: [   20.695875] 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: ffffff-0ff
Feb  2 19:00:32 dom kernel: [   20.897024] USB Serial support registered for pl2303
Feb  2 19:00:32 dom kernel: [   20.897064] pl2303 3-2:1.0: pl2303 converter detected
Feb  2 19:00:32 dom kernel: [   20.902228] alloc irq_2_iommu on node 0
Feb  2 19:00:32 dom kernel: [   20.902235] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
Feb  2 19:00:32 dom kernel: [   20.902320] HDA Intel 0000:00:1b.0: setting latency timer to 64
Feb  2 19:00:32 dom kernel: [   20.908050] usb 3-2: pl2303 converter now attached to ttyUSB0
Feb  2 19:00:32 dom kernel: [   20.908063] usbcore: registered new interface driver pl2303
Feb  2 19:00:32 dom kernel: [   20.908065] pl2303: Prolific PL2303 USB to serial adaptor driver
Feb  2 19:00:32 dom kernel: [   20.958896] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input8
Feb  2 19:00:32 dom kernel: [   20.963147] HDA Intel 0000:02:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Feb  2 19:00:32 dom kernel: [   20.963178] HDA Intel 0000:02:00.1: setting latency timer to 64
Feb  2 19:00:32 dom kernel: [   21.998519] hda-intel: azx_get_response timeout, switching to polling mode: last cmd=0x002f0d00
Feb  2 19:00:32 dom kernel: [   21.998715] HDA Intel 0000:03:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Feb  2 19:00:32 dom kernel: [   21.998810] HDA Intel 0000:03:00.1: setting latency timer to 64
Feb  2 19:00:32 dom kernel: [   22.245277] md: md2 stopped.
Feb  2 19:00:32 dom kernel: [   22.246929] md: bind<sda5>
Feb  2 19:00:32 dom kernel: [   22.247053] md: bind<sdb5>
Feb  2 19:00:32 dom kernel: [   22.248225] raid1: raid set md2 active with 2 out of 2 mirrors
Feb  2 19:00:32 dom kernel: [   22.248238] md2: detected capacity change from 0 to 524287410176
Feb  2 19:00:32 dom kernel: [   22.248755]  md2:
Feb  2 19:00:32 dom kernel: [   22.249062] md: md3 stopped.
Feb  2 19:00:32 dom kernel: [   22.249959] md: bind<sda6>
Feb  2 19:00:32 dom kernel: [   22.250069] md: bind<sdb6>
Feb  2 19:00:32 dom kernel: [   22.250994]  unknown partition table
Feb  2 19:00:32 dom kernel: [   22.251415] raid1: raid set md3 active with 2 out of 2 mirrors
Feb  2 19:00:32 dom kernel: [   22.251427] md3: detected capacity change from 0 to 98566144
Feb  2 19:00:32 dom kernel: [   22.252085]  md3: unknown partition table
Feb  2 19:00:32 dom kernel: [   22.255710] md: md4 stopped.
Feb  2 19:00:32 dom kernel: [   22.256448] md: bind<sda4>
Feb  2 19:00:32 dom kernel: [   22.256554] md: bind<sdb4>
Feb  2 19:00:32 dom kernel: [   22.257629] raid1: raid set md4 active with 2 out of 2 mirrors
Feb  2 19:00:32 dom kernel: [   22.257643] md4: detected capacity change from 0 to 360481030144
Feb  2 19:00:32 dom kernel: [   22.258084]  md4: unknown partition table
Feb  2 19:00:32 dom kernel: [   22.280056] device-mapper: uevent: version 1.0.3
Feb  2 19:00:32 dom kernel: [   22.280254] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
Feb  2 19:00:32 dom kernel: [   22.333568] loop: module loaded
Feb  2 19:00:32 dom kernel: [   23.207493] EXT4-fs (md2): mounted filesystem with ordered data mode
Feb  2 19:00:32 dom kernel: [   23.289425] EXT4-fs (md3): mounted filesystem with ordered data mode
Feb  2 19:00:32 dom kernel: [   23.368734] EXT4-fs (md4): mounted filesystem with ordered data mode
Feb  2 19:00:32 dom kernel: [   23.775418] Adding 10233272k swap on /dev/md0.  Priority:-1 extents:1 across:10233272k
Feb  2 19:00:32 dom kernel: [   25.221794] NET: Registered protocol family 10
Feb  2 19:00:32 dom kernel: [   25.222725] lo: Disabled Privacy Extensions
Feb  2 19:00:32 dom kernel: [   25.223525] coretemp coretemp.0: Unable to access MSR 0xEE, for Tjmax, left at default
Feb  2 19:00:32 dom kernel: [   25.223608] coretemp coretemp.1: Unable to access MSR 0xEE, for Tjmax, left at default
Feb  2 19:00:32 dom kernel: [   25.223695] coretemp coretemp.2: Unable to access MSR 0xEE, for Tjmax, left at default
Feb  2 19:00:32 dom kernel: [   25.223744] coretemp coretemp.3: Unable to access MSR 0xEE, for Tjmax, left at default
Feb  2 19:00:32 dom kernel: [   25.223774] coretemp coretemp.4: Unable to access MSR 0xEE, for Tjmax, left at default
Feb  2 19:00:32 dom kernel: [   25.223861] coretemp coretemp.5: Unable to access MSR 0xEE, for Tjmax, left at default
Feb  2 19:00:32 dom kernel: [   25.223919] coretemp coretemp.6: Unable to access MSR 0xEE, for Tjmax, left at default
Feb  2 19:00:33 dom kernel: [   25.223949] coretemp coretemp.7: Unable to access MSR 0xEE, for Tjmax, left at default
Feb  2 19:00:33 dom kernel: [   25.869751] 0000:00:19.0: eth0: changing MTU from 1500 to 1200
Feb  2 19:00:33 dom kernel: [   25.929702] e1000e 0000:00:19.0: irq 32 for MSI/MSI-X
Feb  2 19:00:33 dom kernel: [   25.981449] e1000e 0000:00:19.0: irq 32 for MSI/MSI-X
Feb  2 19:00:33 dom kernel: [   25.982032] ADDRCONF(NETDEV_UP): eth0: link is not ready
Feb  2 19:00:33 dom kernel: [   26.221832] hda-intel: azx_get_response timeout, switching to polling mode: last cmd=0x20bb0002


-- 
Tomasz Chmielewski
http://wpkg.org
