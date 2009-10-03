Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbZJCKI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbZJCKI6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 06:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487AbZJCKI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 06:08:57 -0400
Received: from mail.agmk.net ([91.192.224.71]:41311 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477AbZJCKIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 06:08:46 -0400
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [2.6.31] ir-kbd-i2c oops.
Date: Sat, 3 Oct 2009 12:08:36 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-dirty; KDE/4.3.1; x86_64; ; )
Cc: Andy Walls <awalls@radix.net>, linux-kernel@vger.kernel.org,
       LMML <linux-media@vger.kernel.org>
References: <200909160300.28382.pluto@agmk.net> <1254354727.4771.13.camel@palomino.walls.org> <20091001134343.30e7cd98@hyperion.delvare>
In-Reply-To: <20091001134343.30e7cd98@hyperion.delvare>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_kKyxKId30nsTw3M"
Message-Id: <200910031208.36524.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_kKyxKId30nsTw3M
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

On Thursday 01 October 2009 13:43:43 Jean Delvare wrote:

> Pawel, please give a try to the following patch. Please keep the debug
> patches apply too, in case we need additional info.

the second patch helps. here's a dmesg log.

--Boundary-00=_kKyxKId30nsTw3M
Content-Type: text/x-log;
  charset="utf-8";
  name="dmesg.log"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
	filename="dmesg.log"

Oct  3 11:45:24 vmx kernel: [    0.000000] Initializing cgroup subsys cpuset
Oct  3 11:45:24 vmx kernel: [    0.000000] Initializing cgroup subsys cpu
Oct  3 11:45:24 vmx kernel: [    0.000000] Linux version 2.6.31-0.4 (pluto@pldmachine) (gcc version 4.4.1 20090724 (release) (PLD-Linux) ) #1 SMP Wed Sep 16 09:45:40 CEST 2009
Oct  3 11:45:24 vmx kernel: [    0.000000] Command line: root=/dev/md0
Oct  3 11:45:24 vmx kernel: [    0.000000] KERNEL supported cpus:
Oct  3 11:45:24 vmx kernel: [    0.000000]   Intel GenuineIntel
Oct  3 11:45:24 vmx kernel: [    0.000000]   AMD AuthenticAMD
Oct  3 11:45:24 vmx kernel: [    0.000000]   Centaur CentaurHauls
Oct  3 11:45:24 vmx kernel: [    0.000000] BIOS-provided physical RAM map:
Oct  3 11:45:24 vmx kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
Oct  3 11:45:24 vmx kernel: [    0.000000]  BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
Oct  3 11:45:24 vmx kernel: [    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
Oct  3 11:45:24 vmx kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 00000000cff70000 (usable)
Oct  3 11:45:24 vmx kernel: [    0.000000]  BIOS-e820: 00000000cff70000 - 00000000cff7e000 (ACPI data)
Oct  3 11:45:24 vmx kernel: [    0.000000]  BIOS-e820: 00000000cff7e000 - 00000000cffd0000 (ACPI NVS)
Oct  3 11:45:24 vmx kernel: [    0.000000]  BIOS-e820: 00000000cffd0000 - 00000000d0000000 (reserved)
Oct  3 11:45:24 vmx kernel: [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Oct  3 11:45:24 vmx kernel: [    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
Oct  3 11:45:24 vmx kernel: [    0.000000]  BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
Oct  3 11:45:24 vmx kernel: [    0.000000] DMI present.
Oct  3 11:45:24 vmx kernel: [    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
Oct  3 11:45:24 vmx kernel: [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
Oct  3 11:45:24 vmx kernel: [    0.000000] last_pfn = 0x230000 max_arch_pfn = 0x400000000
Oct  3 11:45:24 vmx kernel: [    0.000000] MTRR default type: uncachable
Oct  3 11:45:24 vmx kernel: [    0.000000] MTRR fixed ranges enabled:
Oct  3 11:45:24 vmx kernel: [    0.000000]   00000-9FFFF write-back
Oct  3 11:45:24 vmx kernel: [    0.000000]   A0000-BFFFF uncachable
Oct  3 11:45:24 vmx kernel: [    0.000000]   C0000-DFFFF write-protect
Oct  3 11:45:24 vmx kernel: [    0.000000]   E0000-EFFFF write-through
Oct  3 11:45:24 vmx kernel: [    0.000000]   F0000-FFFFF write-protect
Oct  3 11:45:24 vmx kernel: [    0.000000] MTRR variable ranges enabled:
Oct  3 11:45:24 vmx kernel: [    0.000000]   0 base 000000000 mask E00000000 write-back
Oct  3 11:45:24 vmx kernel: [    0.000000]   1 base 200000000 mask FE0000000 write-back
Oct  3 11:45:24 vmx kernel: [    0.000000]   2 base 220000000 mask FF0000000 write-back
Oct  3 11:45:24 vmx kernel: [    0.000000]   3 base 0D0000000 mask FF0000000 uncachable
Oct  3 11:45:24 vmx kernel: [    0.000000]   4 base 0E0000000 mask FE0000000 uncachable
Oct  3 11:45:24 vmx kernel: [    0.000000]   5 disabled
Oct  3 11:45:24 vmx kernel: [    0.000000]   6 disabled
Oct  3 11:45:24 vmx kernel: [    0.000000]   7 disabled
Oct  3 11:45:24 vmx kernel: [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Oct  3 11:45:24 vmx kernel: [    0.000000] e820 update range: 00000000d0000000 - 0000000100000000 (usable) ==> (reserved)
Oct  3 11:45:24 vmx kernel: [    0.000000] last_pfn = 0xcff70 max_arch_pfn = 0x400000000
Oct  3 11:45:24 vmx kernel: [    0.000000] Scanning 0 areas for low memory corruption
Oct  3 11:45:24 vmx kernel: [    0.000000] modified physical RAM map:
Oct  3 11:45:24 vmx kernel: [    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
Oct  3 11:45:24 vmx kernel: [    0.000000]  modified: 0000000000010000 - 000000000009cc00 (usable)
Oct  3 11:45:24 vmx kernel: [    0.000000]  modified: 000000000009cc00 - 00000000000a0000 (reserved)
Oct  3 11:45:24 vmx kernel: [    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
Oct  3 11:45:24 vmx kernel: [    0.000000]  modified: 0000000000100000 - 00000000cff70000 (usable)
Oct  3 11:45:24 vmx kernel: [    0.000000]  modified: 00000000cff70000 - 00000000cff7e000 (ACPI data)
Oct  3 11:45:24 vmx kernel: [    0.000000]  modified: 00000000cff7e000 - 00000000cffd0000 (ACPI NVS)
Oct  3 11:45:24 vmx kernel: [    0.000000]  modified: 00000000cffd0000 - 00000000d0000000 (reserved)
Oct  3 11:45:24 vmx kernel: [    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
Oct  3 11:45:24 vmx kernel: [    0.000000]  modified: 00000000fff00000 - 0000000100000000 (reserved)
Oct  3 11:45:24 vmx kernel: [    0.000000]  modified: 0000000100000000 - 0000000230000000 (usable)
Oct  3 11:45:24 vmx kernel: [    0.000000] initial memory mapped : 0 - 20000000
Oct  3 11:45:24 vmx kernel: [    0.000000] init_memory_mapping: 0000000000000000-00000000cff70000
Oct  3 11:45:24 vmx kernel: [    0.000000] NX (Execute Disable) protection: active
Oct  3 11:45:24 vmx kernel: [    0.000000]  0000000000 - 00cfe00000 page 2M
Oct  3 11:45:24 vmx kernel: [    0.000000]  00cfe00000 - 00cff70000 page 4k
Oct  3 11:45:24 vmx kernel: [    0.000000] kernel direct mapping tables up to cff70000 @ 10000-16000
Oct  3 11:45:24 vmx kernel: [    0.000000] init_memory_mapping: 0000000100000000-0000000230000000
Oct  3 11:45:24 vmx kernel: [    0.000000] NX (Execute Disable) protection: active
Oct  3 11:45:24 vmx kernel: [    0.000000]  0100000000 - 0230000000 page 2M
Oct  3 11:45:24 vmx kernel: [    0.000000] kernel direct mapping tables up to 230000000 @ 11000-1b000
Oct  3 11:45:24 vmx kernel: [    0.000000] RAMDISK: 37f18000 - 37fef730
Oct  3 11:45:24 vmx kernel: [    0.000000] ACPI: RSDP 00000000000fb460 00024 (v02 ACPIAM)
Oct  3 11:45:24 vmx kernel: [    0.000000] ACPI: XSDT 00000000cff70100 0005C (v01 A_M_I_ OEMXSDT  08000820 MSFT 00000097)
Oct  3 11:45:24 vmx kernel: [    0.000000] ACPI: FACP 00000000cff70290 000F4 (v03 A_M_I_ OEMFACP  08000820 MSFT 00000097)
Oct  3 11:45:24 vmx kernel: [    0.000000] ACPI: DSDT 00000000cff70440 0964B (v01  A1012 A1012001 00000001 INTL 20060113)
Oct  3 11:45:24 vmx kernel: [    0.000000] ACPI: FACS 00000000cff7e000 00040
Oct  3 11:45:24 vmx kernel: [    0.000000] ACPI: APIC 00000000cff70390 0006C (v01 A_M_I_ OEMAPIC  08000820 MSFT 00000097)
Oct  3 11:45:24 vmx kernel: [    0.000000] ACPI: MCFG 00000000cff70400 0003C (v01 A_M_I_ OEMMCFG  08000820 MSFT 00000097)
Oct  3 11:45:24 vmx kernel: [    0.000000] ACPI: OEMB 00000000cff7e040 00081 (v01 A_M_I_ AMI_OEM  08000820 MSFT 00000097)
Oct  3 11:45:24 vmx kernel: [    0.000000] ACPI: HPET 00000000cff79a90 00038 (v01 A_M_I_ OEMHPET  08000820 MSFT 00000097)
Oct  3 11:45:24 vmx kernel: [    0.000000] ACPI: OSFR 00000000cff79ad0 000B0 (v01 A_M_I_ OEMOSFR  08000820 MSFT 00000097)
Oct  3 11:45:24 vmx kernel: [    0.000000] ACPI: SSDT 00000000cff7e8d0 00A7C (v01 DpgPmm    CpuPm 00000012 INTL 20060113)
Oct  3 11:45:24 vmx kernel: [    0.000000] ACPI: Local APIC address 0xfee00000
Oct  3 11:45:24 vmx kernel: [    0.000000] No NUMA configuration found
Oct  3 11:45:24 vmx kernel: [    0.000000] Faking a node at 0000000000000000-0000000230000000
Oct  3 11:45:24 vmx kernel: [    0.000000] Bootmem setup node 0 0000000000000000-0000000230000000
Oct  3 11:45:24 vmx kernel: [    0.000000]   NODE_DATA [0000000000016000 - 000000000001afff]
Oct  3 11:45:24 vmx kernel: [    0.000000]   bootmap [000000000001b000 -  0000000000060fff] pages 46
Oct  3 11:45:24 vmx kernel: [    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0230000000]
Oct  3 11:45:24 vmx kernel: [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
Oct  3 11:45:24 vmx kernel: [    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
Oct  3 11:45:24 vmx kernel: [    0.000000]   #2 [0001000000 - 0001780a40]    TEXT DATA BSS ==> [0001000000 - 0001780a40]
Oct  3 11:45:24 vmx kernel: [    0.000000]   #3 [0037f18000 - 0037fef730]          RAMDISK ==> [0037f18000 - 0037fef730]
Oct  3 11:45:24 vmx kernel: [    0.000000]   #4 [000009cc00 - 0000100000]    BIOS reserved ==> [000009cc00 - 0000100000]
Oct  3 11:45:24 vmx kernel: [    0.000000]   #5 [0001781000 - 0001781278]              BRK ==> [0001781000 - 0001781278]
Oct  3 11:45:24 vmx kernel: [    0.000000]   #6 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
Oct  3 11:45:24 vmx kernel: [    0.000000]   #7 [0000011000 - 0000016000]          PGTABLE ==> [0000011000 - 0000016000]
Oct  3 11:45:24 vmx kernel: [    0.000000]  [ffffea0000000000-ffffea0007bfffff] PMD -> [ffff880028600000-ffff88002f7fffff] on node 0
Oct  3 11:45:24 vmx kernel: [    0.000000] Zone PFN ranges:
Oct  3 11:45:24 vmx kernel: [    0.000000]   DMA      0x00000010 -> 0x00001000
Oct  3 11:45:24 vmx kernel: [    0.000000]   DMA32    0x00001000 -> 0x00100000
Oct  3 11:45:24 vmx kernel: [    0.000000]   Normal   0x00100000 -> 0x00230000
Oct  3 11:45:24 vmx kernel: [    0.000000] Movable zone start PFN for each node
Oct  3 11:45:24 vmx kernel: [    0.000000] early_node_map[3] active PFN ranges
Oct  3 11:45:24 vmx kernel: [    0.000000]     0: 0x00000010 -> 0x0000009c
Oct  3 11:45:24 vmx kernel: [    0.000000]     0: 0x00000100 -> 0x000cff70
Oct  3 11:45:24 vmx kernel: [    0.000000]     0: 0x00100000 -> 0x00230000
Oct  3 11:45:24 vmx kernel: [    0.000000] On node 0 totalpages: 2096892
Oct  3 11:45:24 vmx kernel: [    0.000000]   DMA zone: 56 pages used for memmap
Oct  3 11:45:24 vmx kernel: [    0.000000]   DMA zone: 108 pages reserved
Oct  3 11:45:24 vmx kernel: [    0.000000]   DMA zone: 3816 pages, LIFO batch:0
Oct  3 11:45:24 vmx kernel: [    0.000000]   DMA32 zone: 14280 pages used for memmap
Oct  3 11:45:24 vmx kernel: [    0.000000]   DMA32 zone: 833448 pages, LIFO batch:31
Oct  3 11:45:24 vmx kernel: [    0.000000]   Normal zone: 17024 pages used for memmap
Oct  3 11:45:24 vmx kernel: [    0.000000]   Normal zone: 1228160 pages, LIFO batch:31
Oct  3 11:45:24 vmx kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x808
Oct  3 11:45:24 vmx kernel: [    0.000000] ACPI: Local APIC address 0xfee00000
Oct  3 11:45:24 vmx kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Oct  3 11:45:24 vmx kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Oct  3 11:45:24 vmx kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
Oct  3 11:45:24 vmx kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
Oct  3 11:45:24 vmx kernel: [    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
Oct  3 11:45:24 vmx kernel: [    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
Oct  3 11:45:24 vmx kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Oct  3 11:45:24 vmx kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Oct  3 11:45:24 vmx kernel: [    0.000000] ACPI: IRQ0 used by override.
Oct  3 11:45:24 vmx kernel: [    0.000000] ACPI: IRQ2 used by override.
Oct  3 11:45:24 vmx kernel: [    0.000000] ACPI: IRQ9 used by override.
Oct  3 11:45:24 vmx kernel: [    0.000000] Using ACPI (MADT) for SMP configuration information
Oct  3 11:45:24 vmx kernel: [    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
Oct  3 11:45:24 vmx kernel: [    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
Oct  3 11:45:24 vmx kernel: [    0.000000] nr_irqs_gsi: 24
Oct  3 11:45:24 vmx kernel: [    0.000000] PM: Registered nosave memory: 000000000009c000 - 000000000009d000
Oct  3 11:45:24 vmx kernel: [    0.000000] PM: Registered nosave memory: 000000000009d000 - 00000000000a0000
Oct  3 11:45:24 vmx kernel: [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
Oct  3 11:45:24 vmx kernel: [    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
Oct  3 11:45:24 vmx kernel: [    0.000000] PM: Registered nosave memory: 00000000cff70000 - 00000000cff7e000
Oct  3 11:45:24 vmx kernel: [    0.000000] PM: Registered nosave memory: 00000000cff7e000 - 00000000cffd0000
Oct  3 11:45:24 vmx kernel: [    0.000000] PM: Registered nosave memory: 00000000cffd0000 - 00000000d0000000
Oct  3 11:45:24 vmx kernel: [    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000fee00000
Oct  3 11:45:24 vmx kernel: [    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
Oct  3 11:45:24 vmx kernel: [    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000fff00000
Oct  3 11:45:24 vmx kernel: [    0.000000] PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
Oct  3 11:45:24 vmx kernel: [    0.000000] Allocating PCI resources starting at d0000000 (gap: d0000000:2ee00000)
Oct  3 11:45:24 vmx kernel: [    0.000000] NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4 nr_node_ids:1
Oct  3 11:45:24 vmx kernel: [    0.000000] PERCPU: Embedded 25 pages at ffff880028032000, static data 72416 bytes
Oct  3 11:45:24 vmx kernel: [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2065424
Oct  3 11:45:24 vmx kernel: [    0.000000] Policy zone: Normal
Oct  3 11:45:24 vmx kernel: [    0.000000] Kernel command line: root=/dev/md0
Oct  3 11:45:24 vmx kernel: [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
Oct  3 11:45:24 vmx kernel: [    0.000000] Initializing CPU#0
Oct  3 11:45:24 vmx kernel: [    0.000000] Checking aperture...
Oct  3 11:45:24 vmx kernel: [    0.000000] No AGP bridge found
Oct  3 11:45:24 vmx kernel: [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
Oct  3 11:45:24 vmx kernel: [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Oct  3 11:45:24 vmx kernel: [    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Oct  3 11:45:24 vmx kernel: [    0.000000] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
Oct  3 11:45:24 vmx kernel: [    0.000000] software IO TLB at phys 0x20000000 - 0x24000000
Oct  3 11:45:24 vmx kernel: [    0.000000] Memory: 8195644k/9175040k available (3915k kernel code, 787472k absent, 191924k reserved, 2352k data, 504k init)
Oct  3 11:45:24 vmx kernel: [    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Oct  3 11:45:24 vmx kernel: [    0.000000] NR_IRQS:4352 nr_irqs:440
Oct  3 11:45:24 vmx kernel: [    0.000000] Extended CMOS year: 2000
Oct  3 11:45:24 vmx kernel: [    0.000000] Fast TSC calibration using PIT
Oct  3 11:45:24 vmx kernel: [    0.000000] Detected 2499.916 MHz processor.
Oct  3 11:45:24 vmx kernel: [    0.000608] Console: colour VGA+ 80x25
Oct  3 11:45:24 vmx kernel: [    0.000611] console [tty0] enabled
Oct  3 11:45:24 vmx kernel: [    0.003333] allocated 83886080 bytes of page_cgroup
Oct  3 11:45:24 vmx kernel: [    0.003333] please try 'cgroup_disable=memory' option if you don't want memory cgroups
Oct  3 11:45:24 vmx kernel: [    0.003333] hpet clockevent registered
Oct  3 11:45:24 vmx kernel: [    0.003333] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
Oct  3 11:45:24 vmx kernel: [    0.003333] Calibrating delay loop (skipped), value calculated using timer frequency.. 5001.15 BogoMIPS (lpj=8333053)
Oct  3 11:45:24 vmx kernel: [    0.003333] Security Framework initialized
Oct  3 11:45:24 vmx kernel: [    0.003333] SELinux:  Disabled at boot.
Oct  3 11:45:24 vmx kernel: [    0.003333] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Oct  3 11:45:24 vmx kernel: [    0.003921] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Oct  3 11:45:24 vmx kernel: [    0.005404] Mount-cache hash table entries: 256
Oct  3 11:45:24 vmx kernel: [    0.005570] Initializing cgroup subsys ns
Oct  3 11:45:24 vmx kernel: [    0.005603] Initializing cgroup subsys cpuacct
Oct  3 11:45:24 vmx kernel: [    0.005634] Initializing cgroup subsys memory
Oct  3 11:45:24 vmx kernel: [    0.005668] Initializing cgroup subsys devices
Oct  3 11:45:24 vmx kernel: [    0.005698] Initializing cgroup subsys freezer
Oct  3 11:45:24 vmx kernel: [    0.005728] Initializing cgroup subsys net_cls
Oct  3 11:45:24 vmx kernel: [    0.005769] CPU: L1 I cache: 32K, L1 D cache: 32K
Oct  3 11:45:24 vmx kernel: [    0.005822] CPU: L2 cache: 3072K
Oct  3 11:45:24 vmx kernel: [    0.005852] CPU 0/0x0 -> Node 0
Oct  3 11:45:24 vmx kernel: [    0.005881] CPU: Physical Processor ID: 0
Oct  3 11:45:24 vmx kernel: [    0.005910] CPU: Processor Core ID: 0
Oct  3 11:45:24 vmx kernel: [    0.005940] mce: CPU supports 6 MCE banks
Oct  3 11:45:24 vmx kernel: [    0.005974] CPU0: Thermal monitoring enabled (TM2)
Oct  3 11:45:24 vmx kernel: [    0.006006] using mwait in idle threads.
Oct  3 11:45:24 vmx kernel: [    0.006035] Performance Counters: Core2 events, Intel PMU driver.
Oct  3 11:45:24 vmx kernel: [    0.006114] ... version:                 2
Oct  3 11:45:24 vmx kernel: [    0.006143] ... bit width:               40
Oct  3 11:45:24 vmx kernel: [    0.006172] ... generic counters:        2
Oct  3 11:45:24 vmx kernel: [    0.006200] ... value mask:              000000ffffffffff
Oct  3 11:45:24 vmx kernel: [    0.006230] ... max period:              000000007fffffff
Oct  3 11:45:24 vmx kernel: [    0.006259] ... fixed-purpose counters:  3
Oct  3 11:45:24 vmx kernel: [    0.006287] ... counter mask:            0000000700000003
Oct  3 11:45:24 vmx kernel: [    0.006333] ACPI: Core revision 20090521
Oct  3 11:45:24 vmx kernel: [    0.020054] Setting APIC routing to flat
Oct  3 11:45:24 vmx kernel: [    0.020381] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Oct  3 11:45:24 vmx kernel: [    0.053447] CPU0: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
Oct  3 11:45:24 vmx kernel: [    0.056666] Booting processor 1 APIC 0x1 ip 0x6000
Oct  3 11:45:24 vmx kernel: [    0.003333] Initializing CPU#1
Oct  3 11:45:24 vmx kernel: [    0.003333] Calibrating delay using timer specific routine.. 5001.73 BogoMIPS (lpj=8332370)
Oct  3 11:45:24 vmx kernel: [    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
Oct  3 11:45:24 vmx kernel: [    0.003333] CPU: L2 cache: 3072K
Oct  3 11:45:24 vmx kernel: [    0.003333] CPU 1/0x1 -> Node 0
Oct  3 11:45:24 vmx kernel: [    0.003333] CPU: Physical Processor ID: 0
Oct  3 11:45:24 vmx kernel: [    0.003333] CPU: Processor Core ID: 1
Oct  3 11:45:24 vmx kernel: [    0.003333] mce: CPU supports 6 MCE banks
Oct  3 11:45:24 vmx kernel: [    0.003333] CPU1: Thermal monitoring enabled (TM2)
Oct  3 11:45:24 vmx kernel: [    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
Oct  3 11:45:24 vmx kernel: [    0.147957] CPU1: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
Oct  3 11:45:24 vmx kernel: [    0.148321] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Oct  3 11:45:24 vmx kernel: [    0.150088] Booting processor 2 APIC 0x2 ip 0x6000
Oct  3 11:45:24 vmx kernel: [    0.003333] Initializing CPU#2
Oct  3 11:45:24 vmx kernel: [    0.003333] Calibrating delay using timer specific routine.. 5001.75 BogoMIPS (lpj=8332403)
Oct  3 11:45:24 vmx kernel: [    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
Oct  3 11:45:24 vmx kernel: [    0.003333] CPU: L2 cache: 3072K
Oct  3 11:45:24 vmx kernel: [    0.003333] CPU 2/0x2 -> Node 0
Oct  3 11:45:24 vmx kernel: [    0.003333] CPU: Physical Processor ID: 0
Oct  3 11:45:24 vmx kernel: [    0.003333] CPU: Processor Core ID: 2
Oct  3 11:45:24 vmx kernel: [    0.003333] mce: CPU supports 6 MCE banks
Oct  3 11:45:24 vmx kernel: [    0.003333] CPU2: Thermal monitoring enabled (TM2)
Oct  3 11:45:24 vmx kernel: [    0.003333] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
Oct  3 11:45:24 vmx kernel: [    0.244606] CPU2: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
Oct  3 11:45:24 vmx kernel: [    0.245302] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
Oct  3 11:45:24 vmx kernel: [    0.246727] Booting processor 3 APIC 0x3 ip 0x6000
Oct  3 11:45:24 vmx kernel: [    0.003333] Initializing CPU#3
Oct  3 11:45:24 vmx kernel: [    0.003333] Calibrating delay using timer specific routine.. 5001.75 BogoMIPS (lpj=8332406)
Oct  3 11:45:24 vmx kernel: [    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
Oct  3 11:45:24 vmx kernel: [    0.003333] CPU: L2 cache: 3072K
Oct  3 11:45:24 vmx kernel: [    0.003333] CPU 3/0x3 -> Node 0
Oct  3 11:45:24 vmx kernel: [    0.003333] CPU: Physical Processor ID: 0
Oct  3 11:45:24 vmx kernel: [    0.003333] CPU: Processor Core ID: 3
Oct  3 11:45:24 vmx kernel: [    0.003333] mce: CPU supports 6 MCE banks
Oct  3 11:45:24 vmx kernel: [    0.003333] CPU3: Thermal monitoring enabled (TM2)
Oct  3 11:45:24 vmx kernel: [    0.003333] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
Oct  3 11:45:24 vmx kernel: [    0.341334] CPU3: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
Oct  3 11:45:24 vmx kernel: [    0.341696] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Oct  3 11:45:24 vmx kernel: [    0.343342] Brought up 4 CPUs
Oct  3 11:45:24 vmx kernel: [    0.343380] Total of 4 processors activated (20006.39 BogoMIPS).
Oct  3 11:45:24 vmx kernel: [    0.343522] regulator: core version 0.5
Oct  3 11:45:24 vmx kernel: [    0.343522] NET: Registered protocol family 16
Oct  3 11:45:24 vmx kernel: [    0.343522] ACPI: bus type pci registered
Oct  3 11:45:24 vmx kernel: [    0.346701] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
Oct  3 11:45:24 vmx kernel: [    0.346732] PCI: Not using MMCONFIG.
Oct  3 11:45:24 vmx kernel: [    0.346761] PCI: Using configuration type 1 for base access
Oct  3 11:45:24 vmx kernel: [    0.346812] bio: create slab <bio-0> at 0
Oct  3 11:45:24 vmx kernel: [    0.350116] ACPI: EC: Look up EC in DSDT
Oct  3 11:45:24 vmx kernel: [    0.361921] ACPI: Interpreter enabled
Oct  3 11:45:24 vmx kernel: [    0.361957] ACPI: (supports S0 S1 S3 S4 S5)
Oct  3 11:45:24 vmx kernel: [    0.362129] ACPI: Using IOAPIC for interrupt routing
Oct  3 11:45:24 vmx kernel: [    0.362202] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
Oct  3 11:45:24 vmx kernel: [    0.364507] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
Oct  3 11:45:24 vmx kernel: [    0.370269] PCI: Using MMCONFIG at e0000000 - efffffff
Oct  3 11:45:24 vmx kernel: [    0.376835] ACPI: No dock devices found.
Oct  3 11:45:24 vmx kernel: [    0.376963] ACPI: PCI Root Bridge [PCI0] (0000:00)
Oct  3 11:45:24 vmx kernel: [    0.377023] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
Oct  3 11:45:24 vmx kernel: [    0.377023] pci 0000:00:01.0: PME# disabled
Oct  3 11:45:24 vmx kernel: [    0.377023] pci 0000:00:1a.0: reg 20 io port: [0xa800-0xa81f]
Oct  3 11:45:24 vmx kernel: [    0.377023] pci 0000:00:1a.1: reg 20 io port: [0xa880-0xa89f]
Oct  3 11:45:24 vmx kernel: [    0.377023] pci 0000:00:1a.2: reg 20 io port: [0xac00-0xac1f]
Oct  3 11:45:24 vmx kernel: [    0.377023] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfe7ffc00-0xfe7fffff]
Oct  3 11:45:24 vmx kernel: [    0.377050] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
Oct  3 11:45:24 vmx kernel: [    0.377082] pci 0000:00:1a.7: PME# disabled
Oct  3 11:45:24 vmx kernel: [    0.377151] pci 0000:00:1b.0: reg 10 64bit mmio: [0xfe7f8000-0xfe7fbfff]
Oct  3 11:45:24 vmx kernel: [    0.377184] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
Oct  3 11:45:24 vmx kernel: [    0.377215] pci 0000:00:1b.0: PME# disabled
Oct  3 11:45:24 vmx kernel: [    0.377290] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
Oct  3 11:45:24 vmx kernel: [    0.377321] pci 0000:00:1c.0: PME# disabled
Oct  3 11:45:24 vmx kernel: [    0.377407] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
Oct  3 11:45:24 vmx kernel: [    0.377438] pci 0000:00:1c.4: PME# disabled
Oct  3 11:45:24 vmx kernel: [    0.377511] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
Oct  3 11:45:24 vmx kernel: [    0.377542] pci 0000:00:1c.5: PME# disabled
Oct  3 11:45:24 vmx kernel: [    0.377613] pci 0000:00:1d.0: reg 20 io port: [0xa080-0xa09f]
Oct  3 11:45:24 vmx kernel: [    0.377667] pci 0000:00:1d.1: reg 20 io port: [0xa400-0xa41f]
Oct  3 11:45:24 vmx kernel: [    0.377722] pci 0000:00:1d.2: reg 20 io port: [0xa480-0xa49f]
Oct  3 11:45:24 vmx kernel: [    0.377780] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfe7ff800-0xfe7ffbff]
Oct  3 11:45:24 vmx kernel: [    0.377824] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
Oct  3 11:45:24 vmx kernel: [    0.377856] pci 0000:00:1d.7: PME# disabled
Oct  3 11:45:24 vmx kernel: [    0.377980] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
Oct  3 11:45:24 vmx kernel: [    0.378015] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
Oct  3 11:45:24 vmx kernel: [    0.378047] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0294 (mask 0003)
Oct  3 11:45:24 vmx kernel: [    0.378083] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 4700 (mask 001f)
Oct  3 11:45:24 vmx kernel: [    0.378165] pci 0000:00:1f.2: reg 10 io port: [0x9c00-0x9c07]
Oct  3 11:45:24 vmx kernel: [    0.378169] pci 0000:00:1f.2: reg 14 io port: [0x9880-0x9883]
Oct  3 11:45:24 vmx kernel: [    0.378173] pci 0000:00:1f.2: reg 18 io port: [0x9800-0x9807]
Oct  3 11:45:24 vmx kernel: [    0.378178] pci 0000:00:1f.2: reg 1c io port: [0x9480-0x9483]
Oct  3 11:45:24 vmx kernel: [    0.378182] pci 0000:00:1f.2: reg 20 io port: [0x9400-0x941f]
Oct  3 11:45:24 vmx kernel: [    0.378186] pci 0000:00:1f.2: reg 24 32bit mmio: [0xfe7fe800-0xfe7fefff]
Oct  3 11:45:24 vmx kernel: [    0.378211] pci 0000:00:1f.2: PME# supported from D3hot
Oct  3 11:45:24 vmx kernel: [    0.378242] pci 0000:00:1f.2: PME# disabled
Oct  3 11:45:24 vmx kernel: [    0.378291] pci 0000:00:1f.3: reg 10 64bit mmio: [0xfe7ff400-0xfe7ff4ff]
Oct  3 11:45:24 vmx kernel: [    0.378301] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
Oct  3 11:45:24 vmx kernel: [    0.378336] pci 0000:01:00.0: reg 10 32bit mmio: [0xd0000000-0xdfffffff]
Oct  3 11:45:24 vmx kernel: [    0.378340] pci 0000:01:00.0: reg 14 io port: [0xb000-0xb0ff]
Oct  3 11:45:24 vmx kernel: [    0.378344] pci 0000:01:00.0: reg 18 32bit mmio: [0xfe8e0000-0xfe8effff]
Oct  3 11:45:24 vmx kernel: [    0.378356] pci 0000:01:00.0: reg 30 32bit mmio: [0xfe8c0000-0xfe8dffff]
Oct  3 11:45:24 vmx kernel: [    0.378370] pci 0000:01:00.0: supports D1 D2
Oct  3 11:45:24 vmx kernel: [    0.378392] pci 0000:01:00.1: reg 10 32bit mmio: [0xfe8f0000-0xfe8fffff]
Oct  3 11:45:24 vmx kernel: [    0.378420] pci 0000:01:00.1: supports D1 D2
Oct  3 11:45:24 vmx kernel: [    0.378455] pci 0000:00:01.0: bridge io port: [0xb000-0xbfff]
Oct  3 11:45:24 vmx kernel: [    0.378457] pci 0000:00:01.0: bridge 32bit mmio: [0xfe800000-0xfe8fffff]
Oct  3 11:45:24 vmx kernel: [    0.378460] pci 0000:00:01.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
Oct  3 11:45:24 vmx kernel: [    0.378495] pci 0000:00:1c.0: bridge 64bit mmio pref: [0xfdf00000-0xfdffffff]
Oct  3 11:45:24 vmx kernel: [    0.378533] pci 0000:03:00.0: reg 10 io port: [0xdc00-0xdc07]
Oct  3 11:45:24 vmx kernel: [    0.378540] pci 0000:03:00.0: reg 14 io port: [0xd880-0xd883]
Oct  3 11:45:24 vmx kernel: [    0.378546] pci 0000:03:00.0: reg 18 io port: [0xd800-0xd807]
Oct  3 11:45:24 vmx kernel: [    0.378553] pci 0000:03:00.0: reg 1c io port: [0xd480-0xd483]
Oct  3 11:45:24 vmx kernel: [    0.378560] pci 0000:03:00.0: reg 20 io port: [0xd400-0xd40f]
Oct  3 11:45:24 vmx kernel: [    0.378566] pci 0000:03:00.0: reg 24 32bit mmio: [0xfeaffc00-0xfeafffff]
Oct  3 11:45:24 vmx kernel: [    0.378601] pci 0000:03:00.0: supports D1
Oct  3 11:45:24 vmx kernel: [    0.378602] pci 0000:03:00.0: PME# supported from D0 D1 D3hot
Oct  3 11:45:24 vmx kernel: [    0.378634] pci 0000:03:00.0: PME# disabled
Oct  3 11:45:24 vmx kernel: [    0.380038] pci 0000:00:1c.4: bridge io port: [0xd000-0xdfff]
Oct  3 11:45:24 vmx kernel: [    0.380041] pci 0000:00:1c.4: bridge 32bit mmio: [0xfea00000-0xfeafffff]
Oct  3 11:45:24 vmx kernel: [    0.380089] pci 0000:02:00.0: reg 10 64bit mmio: [0xfe9c0000-0xfe9fffff]
Oct  3 11:45:24 vmx kernel: [    0.380096] pci 0000:02:00.0: reg 18 io port: [0xcc00-0xcc7f]
Oct  3 11:45:24 vmx kernel: [    0.380146] pci 0000:02:00.0: PME# supported from D3hot D3cold
Oct  3 11:45:24 vmx kernel: [    0.380179] pci 0000:02:00.0: PME# disabled
Oct  3 11:45:24 vmx kernel: [    0.380247] pci 0000:00:1c.5: bridge io port: [0xc000-0xcfff]
Oct  3 11:45:24 vmx kernel: [    0.380250] pci 0000:00:1c.5: bridge 32bit mmio: [0xfe900000-0xfe9fffff]
Oct  3 11:45:24 vmx kernel: [    0.380280] pci 0000:05:00.0: reg 10 32bit mmio: [0xfebff800-0xfebfffff]
Oct  3 11:45:24 vmx kernel: [    0.380319] pci 0000:05:00.0: supports D1 D2
Oct  3 11:45:24 vmx kernel: [    0.380349] pci 0000:05:01.0: reg 10 io port: [0xe800-0xe8ff]
Oct  3 11:45:24 vmx kernel: [    0.380354] pci 0000:05:01.0: reg 14 32bit mmio: [0xfebff400-0xfebff4ff]
Oct  3 11:45:24 vmx kernel: [    0.380376] pci 0000:05:01.0: reg 30 32bit mmio: [0xfebe0000-0xfebeffff]
Oct  3 11:45:24 vmx kernel: [    0.380392] pci 0000:05:01.0: PME# supported from D0
Oct  3 11:45:24 vmx kernel: [    0.380424] pci 0000:05:01.0: PME# disabled
Oct  3 11:45:24 vmx kernel: [    0.380489] pci 0000:00:1e.0: transparent bridge
Oct  3 11:45:24 vmx kernel: [    0.380520] pci 0000:00:1e.0: bridge io port: [0xe000-0xefff]
Oct  3 11:45:24 vmx kernel: [    0.380523] pci 0000:00:1e.0: bridge 32bit mmio: [0xfeb00000-0xfebfffff]
Oct  3 11:45:24 vmx kernel: [    0.380544] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Oct  3 11:45:24 vmx kernel: [    0.380656] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
Oct  3 11:45:24 vmx kernel: [    0.380704] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
Oct  3 11:45:24 vmx kernel: [    0.380793] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
Oct  3 11:45:24 vmx kernel: [    0.380837] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
Oct  3 11:45:24 vmx kernel: [    0.380900] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
Oct  3 11:45:24 vmx kernel: [    0.394032] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
Oct  3 11:45:24 vmx kernel: [    0.394032] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
Oct  3 11:45:24 vmx kernel: [    0.394234] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 *15)
Oct  3 11:45:24 vmx kernel: [    0.394634] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 12 14 15)
Oct  3 11:45:24 vmx kernel: [    0.395034] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
Oct  3 11:45:24 vmx kernel: [    0.396951] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 *14 15)
Oct  3 11:45:24 vmx kernel: [    0.397352] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
Oct  3 11:45:24 vmx kernel: [    0.397752] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 10 11 12 14 15)
Oct  3 11:45:24 vmx kernel: [    0.398107] PCI: Using ACPI for IRQ routing
Oct  3 11:45:24 vmx kernel: [    0.410005] NetLabel: Initializing
Oct  3 11:45:24 vmx kernel: [    0.410036] NetLabel:  domain hash size = 128
Oct  3 11:45:24 vmx kernel: [    0.410066] NetLabel:  protocols = UNLABELED CIPSOv4
Oct  3 11:45:24 vmx kernel: [    0.410115] NetLabel:  unlabeled traffic allowed by default
Oct  3 11:45:24 vmx kernel: [    0.410175] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
Oct  3 11:45:24 vmx kernel: [    0.410323] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
Oct  3 11:45:24 vmx kernel: [    0.430005] pnp: PnP ACPI init
Oct  3 11:45:24 vmx kernel: [    0.430045] ACPI: bus type pnp registered
Oct  3 11:45:24 vmx kernel: [    0.433033] pnp: PnP ACPI: found 14 devices
Oct  3 11:45:24 vmx kernel: [    0.433064] ACPI: ACPI bus type pnp unregistered
Oct  3 11:45:24 vmx kernel: [    0.433099] system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
Oct  3 11:45:24 vmx kernel: [    0.433133] system 00:06: ioport range 0x290-0x29f has been reserved
Oct  3 11:45:24 vmx kernel: [    0.433166] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
Oct  3 11:45:24 vmx kernel: [    0.433196] system 00:07: ioport range 0x800-0x87f has been reserved
Oct  3 11:45:24 vmx kernel: [    0.433227] system 00:07: ioport range 0x500-0x57f could not be reserved
Oct  3 11:45:24 vmx kernel: [    0.433258] system 00:07: iomem range 0xfed08000-0xfed08fff has been reserved
Oct  3 11:45:24 vmx kernel: [    0.433289] system 00:07: iomem range 0xfed1c000-0xfed1ffff has been reserved
Oct  3 11:45:24 vmx kernel: [    0.433320] system 00:07: iomem range 0xfed20000-0xfed3ffff has been reserved
Oct  3 11:45:24 vmx kernel: [    0.433354] system 00:07: iomem range 0xfed50000-0xfed8ffff has been reserved
Oct  3 11:45:24 vmx kernel: [    0.433388] system 00:0a: iomem range 0xffc00000-0xffefffff has been reserved
Oct  3 11:45:24 vmx kernel: [    0.433421] system 00:0b: iomem range 0xfec00000-0xfec00fff could not be reserved
Oct  3 11:45:24 vmx kernel: [    0.433455] system 00:0b: iomem range 0xfee00000-0xfee00fff has been reserved
Oct  3 11:45:24 vmx kernel: [    0.433487] system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
Oct  3 11:45:24 vmx kernel: [    0.433520] system 00:0d: iomem range 0x0-0x9ffff could not be reserved
Oct  3 11:45:24 vmx kernel: [    0.433551] system 00:0d: iomem range 0xc0000-0xcffff has been reserved
Oct  3 11:45:24 vmx kernel: [    0.433582] system 00:0d: iomem range 0xe0000-0xfffff could not be reserved
Oct  3 11:45:24 vmx kernel: [    0.433612] system 00:0d: iomem range 0x100000-0xcfffffff could not be reserved
Oct  3 11:45:24 vmx kernel: [    0.439150] pci 0000:05:01.0: BAR 6: address space collision on of device [0xfebe0000-0xfebeffff]
Oct  3 11:45:24 vmx kernel: [    0.439211] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
Oct  3 11:45:24 vmx kernel: [    0.439241] pci 0000:00:01.0:   IO window: 0xb000-0xbfff
Oct  3 11:45:24 vmx kernel: [    0.439272] pci 0000:00:01.0:   MEM window: 0xfe800000-0xfe8fffff
Oct  3 11:45:24 vmx kernel: [    0.439303] pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
Oct  3 11:45:24 vmx kernel: [    0.439338] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:04
Oct  3 11:45:24 vmx kernel: [    0.439368] pci 0000:00:1c.0:   IO window: disabled
Oct  3 11:45:24 vmx kernel: [    0.439399] pci 0000:00:1c.0:   MEM window: disabled
Oct  3 11:45:24 vmx kernel: [    0.439430] pci 0000:00:1c.0:   PREFETCH window: 0x000000fdf00000-0x000000fdffffff
Oct  3 11:45:24 vmx kernel: [    0.439466] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:03
Oct  3 11:45:24 vmx kernel: [    0.439497] pci 0000:00:1c.4:   IO window: 0xd000-0xdfff
Oct  3 11:45:24 vmx kernel: [    0.439528] pci 0000:00:1c.4:   MEM window: 0xfea00000-0xfeafffff
Oct  3 11:45:24 vmx kernel: [    0.439560] pci 0000:00:1c.4:   PREFETCH window: disabled
Oct  3 11:45:24 vmx kernel: [    0.439591] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:02
Oct  3 11:45:24 vmx kernel: [    0.439621] pci 0000:00:1c.5:   IO window: 0xc000-0xcfff
Oct  3 11:45:24 vmx kernel: [    0.439653] pci 0000:00:1c.5:   MEM window: 0xfe900000-0xfe9fffff
Oct  3 11:45:24 vmx kernel: [    0.439684] pci 0000:00:1c.5:   PREFETCH window: disabled
Oct  3 11:45:24 vmx kernel: [    0.439716] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
Oct  3 11:45:24 vmx kernel: [    0.439746] pci 0000:00:1e.0:   IO window: 0xe000-0xefff
Oct  3 11:45:24 vmx kernel: [    0.439778] pci 0000:00:1e.0:   MEM window: 0xfeb00000-0xfebfffff
Oct  3 11:45:24 vmx kernel: [    0.439809] pci 0000:00:1e.0:   PREFETCH window: 0xf0000000-0xf00fffff
Oct  3 11:45:24 vmx kernel: [    0.439844]   alloc irq_desc for 16 on node 0
Oct  3 11:45:24 vmx kernel: [    0.439846]   alloc kstat_irqs on node 0
Oct  3 11:45:24 vmx kernel: [    0.439850] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct  3 11:45:24 vmx kernel: [    0.439881] pci 0000:00:01.0: setting latency timer to 64
Oct  3 11:45:24 vmx kernel: [    0.439886]   alloc irq_desc for 17 on node 0
Oct  3 11:45:24 vmx kernel: [    0.439887]   alloc kstat_irqs on node 0
Oct  3 11:45:24 vmx kernel: [    0.439889] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Oct  3 11:45:24 vmx kernel: [    0.439921] pci 0000:00:1c.0: setting latency timer to 64
Oct  3 11:45:24 vmx kernel: [    0.439926] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Oct  3 11:45:24 vmx kernel: [    0.439957] pci 0000:00:1c.4: setting latency timer to 64
Oct  3 11:45:24 vmx kernel: [    0.439962] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
Oct  3 11:45:24 vmx kernel: [    0.439994] pci 0000:00:1c.5: setting latency timer to 64
Oct  3 11:45:24 vmx kernel: [    0.440005] pci 0000:00:1e.0: setting latency timer to 64
Oct  3 11:45:24 vmx kernel: [    0.440008] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
Oct  3 11:45:24 vmx kernel: [    0.440010] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
Oct  3 11:45:24 vmx kernel: [    0.440012] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
Oct  3 11:45:24 vmx kernel: [    0.440013] pci_bus 0000:01: resource 1 mem: [0xfe800000-0xfe8fffff]
Oct  3 11:45:24 vmx kernel: [    0.440015] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xdfffffff]
Oct  3 11:45:24 vmx kernel: [    0.440017] pci_bus 0000:04: resource 2 pref mem [0xfdf00000-0xfdffffff]
Oct  3 11:45:24 vmx kernel: [    0.440019] pci_bus 0000:03: resource 0 io:  [0xd000-0xdfff]
Oct  3 11:45:24 vmx kernel: [    0.440020] pci_bus 0000:03: resource 1 mem: [0xfea00000-0xfeafffff]
Oct  3 11:45:24 vmx kernel: [    0.440022] pci_bus 0000:02: resource 0 io:  [0xc000-0xcfff]
Oct  3 11:45:24 vmx kernel: [    0.440024] pci_bus 0000:02: resource 1 mem: [0xfe900000-0xfe9fffff]
Oct  3 11:45:24 vmx kernel: [    0.440026] pci_bus 0000:05: resource 0 io:  [0xe000-0xefff]
Oct  3 11:45:24 vmx kernel: [    0.440027] pci_bus 0000:05: resource 1 mem: [0xfeb00000-0xfebfffff]
Oct  3 11:45:24 vmx kernel: [    0.440029] pci_bus 0000:05: resource 2 pref mem [0xf0000000-0xf00fffff]
Oct  3 11:45:24 vmx kernel: [    0.440031] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
Oct  3 11:45:24 vmx kernel: [    0.440032] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
Oct  3 11:45:24 vmx kernel: [    0.440042] NET: Registered protocol family 2
Oct  3 11:45:24 vmx kernel: [    0.440226] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
Oct  3 11:45:24 vmx kernel: [    0.441195] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
Oct  3 11:45:24 vmx kernel: [    0.444156] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Oct  3 11:45:24 vmx kernel: [    0.444546] TCP: Hash tables configured (established 524288 bind 65536)
Oct  3 11:45:24 vmx kernel: [    0.444576] TCP reno registered
Oct  3 11:45:24 vmx kernel: [    0.444683] NET: Registered protocol family 1
Oct  3 11:45:24 vmx kernel: [    0.444774] Trying to unpack rootfs image as initramfs...
Oct  3 11:45:24 vmx kernel: [    0.445441] rootfs image is not initramfs (no cpio magic); looks like an initrd
Oct  3 11:45:24 vmx kernel: [    0.446251] Freeing initrd memory: 861k freed
Oct  3 11:45:24 vmx kernel: [    0.447898] Scanning for low memory corruption every 60 seconds
Oct  3 11:45:24 vmx kernel: [    0.448231] audit: initializing netlink socket (disabled)
Oct  3 11:45:24 vmx kernel: [    0.448270] type=2000 audit(1254563066.446:1): initialized
Oct  3 11:45:24 vmx kernel: [    0.453842] HugeTLB registered 2 MB page size, pre-allocated 0 pages
Oct  3 11:45:24 vmx kernel: [    0.461039] VFS: Disk quotas dquot_6.5.2
Oct  3 11:45:24 vmx kernel: [    0.461137] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Oct  3 11:45:24 vmx kernel: [    0.461271] ROMFS MTD (C) 2007 Red Hat, Inc.
Oct  3 11:45:24 vmx kernel: [    0.461368] msgmni has been set to 16008
Oct  3 11:45:24 vmx kernel: [    0.461921] alg: No test for stdrng (krng)
Oct  3 11:45:24 vmx kernel: [    0.462085] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
Oct  3 11:45:24 vmx kernel: [    0.462127] io scheduler noop registered
Oct  3 11:45:24 vmx kernel: [    0.462162] io scheduler anticipatory registered
Oct  3 11:45:24 vmx kernel: [    0.462192] io scheduler deadline registered
Oct  3 11:45:24 vmx kernel: [    0.462343] io scheduler cfq registered (default)
Oct  3 11:45:24 vmx kernel: [    0.462517] pci 0000:01:00.0: Boot video device
Oct  3 11:45:24 vmx kernel: [    0.462684]   alloc irq_desc for 24 on node 0
Oct  3 11:45:24 vmx kernel: [    0.462685]   alloc kstat_irqs on node 0
Oct  3 11:45:24 vmx kernel: [    0.462692] pcieport-driver 0000:00:01.0: irq 24 for MSI/MSI-X
Oct  3 11:45:24 vmx kernel: [    0.462696] pcieport-driver 0000:00:01.0: setting latency timer to 64
Oct  3 11:45:24 vmx kernel: [    0.462884]   alloc irq_desc for 25 on node 0
Oct  3 11:45:24 vmx kernel: [    0.462885]   alloc kstat_irqs on node 0
Oct  3 11:45:24 vmx kernel: [    0.462890] pcieport-driver 0000:00:1c.0: irq 25 for MSI/MSI-X
Oct  3 11:45:24 vmx kernel: [    0.462896] pcieport-driver 0000:00:1c.0: setting latency timer to 64
Oct  3 11:45:24 vmx kernel: [    0.463137]   alloc irq_desc for 26 on node 0
Oct  3 11:45:24 vmx kernel: [    0.463139]   alloc kstat_irqs on node 0
Oct  3 11:45:24 vmx kernel: [    0.463144] pcieport-driver 0000:00:1c.4: irq 26 for MSI/MSI-X
Oct  3 11:45:24 vmx kernel: [    0.463149] pcieport-driver 0000:00:1c.4: setting latency timer to 64
Oct  3 11:45:24 vmx kernel: [    0.463396]   alloc irq_desc for 27 on node 0
Oct  3 11:45:24 vmx kernel: [    0.463397]   alloc kstat_irqs on node 0
Oct  3 11:45:24 vmx kernel: [    0.463402] pcieport-driver 0000:00:1c.5: irq 27 for MSI/MSI-X
Oct  3 11:45:24 vmx kernel: [    0.463408] pcieport-driver 0000:00:1c.5: setting latency timer to 64
Oct  3 11:45:24 vmx kernel: [    0.501877] Switched to high resolution mode on CPU 1
Oct  3 11:45:24 vmx kernel: [    0.501978] Switched to high resolution mode on CPU 3
Oct  3 11:45:24 vmx kernel: [    0.502245] Switched to high resolution mode on CPU 2
Oct  3 11:45:24 vmx kernel: [    0.503487] Switched to high resolution mode on CPU 0
Oct  3 11:45:24 vmx kernel: [    0.504128] Linux agpgart interface v0.103
Oct  3 11:45:24 vmx kernel: [    0.504249] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Oct  3 11:45:24 vmx kernel: [    0.507744] brd: module loaded
Oct  3 11:45:24 vmx kernel: [    0.507896] input: Macintosh mouse button emulation as /devices/virtual/input/input0
Oct  3 11:45:24 vmx kernel: [    0.508053] Fixed MDIO Bus: probed
Oct  3 11:45:24 vmx kernel: [    0.508290] PNP: No PS/2 controller found. Probing ports directly.
Oct  3 11:45:24 vmx kernel: [    0.510971] serio: i8042 KBD port at 0x60,0x64 irq 1
Oct  3 11:45:24 vmx kernel: [    0.511003] serio: i8042 AUX port at 0x60,0x64 irq 12
Oct  3 11:45:24 vmx kernel: [    0.511306] mice: PS/2 mouse device common for all mice
Oct  3 11:45:24 vmx kernel: [    0.511444] rtc_cmos 00:03: RTC can wake from S4
Oct  3 11:45:24 vmx kernel: [    0.511565] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
Oct  3 11:45:24 vmx kernel: [    0.511614] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
Oct  3 11:45:24 vmx kernel: [    0.511711] cpuidle: using governor ladder
Oct  3 11:45:24 vmx kernel: [    0.511740] cpuidle: using governor menu
Oct  3 11:45:24 vmx kernel: [    0.511937] TCP cubic registered
Oct  3 11:45:24 vmx kernel: [    0.512444] NET: Registered protocol family 10
Oct  3 11:45:24 vmx kernel: [    0.512889] lo: Disabled Privacy Extensions
Oct  3 11:45:24 vmx kernel: [    0.513273] Mobile IPv6
Oct  3 11:45:24 vmx kernel: [    0.513303] NET: Registered protocol family 17
Oct  3 11:45:24 vmx kernel: [    0.513653] TuxOnIce: Ignoring late initcall, as requested.
Oct  3 11:45:24 vmx kernel: [    0.513691] registered taskstats version 1
Oct  3 11:45:24 vmx kernel: [    0.513862] No TPM chip found, activating TPM-bypass!
Oct  3 11:45:24 vmx kernel: [    0.514065] rtc_cmos 00:03: setting system clock to 2009-10-03 09:44:26 UTC (1254563066)
Oct  3 11:45:24 vmx kernel: [    0.514129] Initalizing network drop monitor service
Oct  3 11:45:24 vmx kernel: [    0.553935] RAMDISK: gzip image found at block 0
Oct  3 11:45:24 vmx kernel: [    0.571946] VFS: Mounted root (romfs filesystem) readonly on device 1:0.
Oct  3 11:45:24 vmx kernel: [    0.583827] SCSI subsystem initialized
Oct  3 11:45:24 vmx kernel: [    0.594830] libata version 3.00 loaded.
Oct  3 11:45:24 vmx kernel: [    0.597665] ahci 0000:00:1f.2: version 3.0
Oct  3 11:45:24 vmx kernel: [    0.597677]   alloc irq_desc for 19 on node 0
Oct  3 11:45:24 vmx kernel: [    0.597679]   alloc kstat_irqs on node 0
Oct  3 11:45:24 vmx kernel: [    0.597684] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Oct  3 11:45:24 vmx kernel: [    0.597761]   alloc irq_desc for 28 on node 0
Oct  3 11:45:24 vmx kernel: [    0.597762]   alloc kstat_irqs on node 0
Oct  3 11:45:24 vmx kernel: [    0.597768] ahci 0000:00:1f.2: irq 28 for MSI/MSI-X
Oct  3 11:45:24 vmx kernel: [    0.597794] ahci: SSS flag set, parallel bus scan disabled
Oct  3 11:45:24 vmx kernel: [    0.597850] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
Oct  3 11:45:24 vmx kernel: [    0.597884] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part ems 
Oct  3 11:45:24 vmx kernel: [    0.597925] ahci 0000:00:1f.2: setting latency timer to 64
Oct  3 11:45:24 vmx kernel: [    0.633375] scsi0 : ahci
Oct  3 11:45:24 vmx kernel: [    0.633801] scsi1 : ahci
Oct  3 11:45:24 vmx kernel: [    0.634010] scsi2 : ahci
Oct  3 11:45:24 vmx kernel: [    0.634227] scsi3 : ahci
Oct  3 11:45:24 vmx kernel: [    0.634443] scsi4 : ahci
Oct  3 11:45:24 vmx kernel: [    0.634661] scsi5 : ahci
Oct  3 11:45:24 vmx kernel: [    0.634915] ata1: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7fe900 irq 28
Oct  3 11:45:24 vmx kernel: [    0.634950] ata2: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7fe980 irq 28
Oct  3 11:45:24 vmx kernel: [    0.634984] ata3: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7fea00 irq 28
Oct  3 11:45:24 vmx kernel: [    0.635018] ata4: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7fea80 irq 28
Oct  3 11:45:24 vmx kernel: [    0.635052] ata5: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7feb00 irq 28
Oct  3 11:45:24 vmx kernel: [    0.635086] ata6: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7feb80 irq 28
Oct  3 11:45:24 vmx kernel: [    1.113344] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Oct  3 11:45:24 vmx kernel: [    1.113852] ata1.00: ATA-7: WDC WD1600YD-01NVB1, 10.02E01, max UDMA/133
Oct  3 11:45:24 vmx kernel: [    1.113886] ata1.00: 321672960 sectors, multi 0: LBA48 NCQ (depth 1)
Oct  3 11:45:24 vmx kernel: [    1.114468] ata1.00: configured for UDMA/133
Oct  3 11:45:24 vmx kernel: [    1.126761] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600YD-01N 10.0 PQ: 0 ANSI: 5
Oct  3 11:45:24 vmx kernel: [    2.006676] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Oct  3 11:45:24 vmx kernel: [    2.007175] ata2.00: ATA-7: WDC WD1600YD-01NVB1, 10.02E01, max UDMA/133
Oct  3 11:45:24 vmx kernel: [    2.007209] ata2.00: 321672960 sectors, multi 0: LBA48 NCQ (depth 1)
Oct  3 11:45:24 vmx kernel: [    2.007793] ata2.00: configured for UDMA/133
Oct  3 11:45:24 vmx kernel: [    2.020122] scsi 1:0:0:0: Direct-Access     ATA      WDC WD1600YD-01N 10.0 PQ: 0 ANSI: 5
Oct  3 11:45:24 vmx kernel: [    2.340010] ata3: SATA link down (SStatus 0 SControl 300)
Oct  3 11:45:24 vmx kernel: [    2.673343] ata4: SATA link down (SStatus 0 SControl 300)
Oct  3 11:45:24 vmx kernel: [    3.006677] ata5: SATA link down (SStatus 0 SControl 300)
Oct  3 11:45:24 vmx kernel: [    3.340009] ata6: SATA link down (SStatus 0 SControl 300)
Oct  3 11:45:24 vmx kernel: [    8.356517] JFS: nTxBlock = 8192, nTxLock = 65536
Oct  3 11:45:24 vmx kernel: [    8.372666] md: raid1 personality registered for level 1
Oct  3 11:45:24 vmx kernel: [    8.375806] sd 0:0:0:0: [sda] 321672960 512-byte logical blocks: (164 GB/153 GiB)
Oct  3 11:45:24 vmx kernel: [    8.375851] sd 1:0:0:0: [sdb] 321672960 512-byte logical blocks: (164 GB/153 GiB)
Oct  3 11:45:24 vmx kernel: [    8.375884] sd 1:0:0:0: [sdb] Write Protect is off
Oct  3 11:45:24 vmx kernel: [    8.375885] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Oct  3 11:45:24 vmx kernel: [    8.375901] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct  3 11:45:24 vmx kernel: [    8.375982] sd 0:0:0:0: [sda] Write Protect is off
Oct  3 11:45:24 vmx kernel: [    8.375999]  sdb:
Oct  3 11:45:24 vmx kernel: [    8.376038] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Oct  3 11:45:24 vmx kernel: [    8.376081] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct  3 11:45:24 vmx kernel: [    8.376206]  sda: sdb1 sdb2 sdb3
Oct  3 11:45:24 vmx kernel: [    8.394329] sd 1:0:0:0: [sdb] Attached SCSI disk
Oct  3 11:45:24 vmx kernel: [    8.395674]  sda1 sda2 sda3
Oct  3 11:45:24 vmx kernel: [    8.396572] sd 0:0:0:0: [sda] Attached SCSI disk
Oct  3 11:45:24 vmx kernel: [   13.406050] usbcore: registered new interface driver usbfs
Oct  3 11:45:24 vmx kernel: [   13.406191] usbcore: registered new interface driver hub
Oct  3 11:45:24 vmx kernel: [   13.406318] usbcore: registered new device driver usb
Oct  3 11:45:24 vmx kernel: [   13.407984] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Oct  3 11:45:24 vmx kernel: [   13.408051]   alloc irq_desc for 18 on node 0
Oct  3 11:45:24 vmx kernel: [   13.408053]   alloc kstat_irqs on node 0
Oct  3 11:45:24 vmx kernel: [   13.408057] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Oct  3 11:45:24 vmx kernel: [   13.408127] ehci_hcd 0000:00:1a.7: setting latency timer to 64
Oct  3 11:45:24 vmx kernel: [   13.408129] ehci_hcd 0000:00:1a.7: EHCI Host Controller
Oct  3 11:45:24 vmx kernel: [   13.408181] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
Oct  3 11:45:24 vmx kernel: [   13.412117] ehci_hcd 0000:00:1a.7: debug port 1
Oct  3 11:45:24 vmx kernel: [   13.412150] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
Oct  3 11:45:24 vmx kernel: [   13.412161] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfe7ffc00
Oct  3 11:45:24 vmx kernel: [   13.426674] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
Oct  3 11:45:24 vmx kernel: [   13.426722] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
Oct  3 11:45:24 vmx kernel: [   13.426754] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct  3 11:45:24 vmx kernel: [   13.426795] usb usb1: Product: EHCI Host Controller
Oct  3 11:45:24 vmx kernel: [   13.426824] usb usb1: Manufacturer: Linux 2.6.31-0.4 ehci_hcd
Oct  3 11:45:24 vmx kernel: [   13.426854] usb usb1: SerialNumber: 0000:00:1a.7
Oct  3 11:45:24 vmx kernel: [   13.427022] usb usb1: configuration #1 chosen from 1 choice
Oct  3 11:45:24 vmx kernel: [   13.427133] hub 1-0:1.0: USB hub found
Oct  3 11:45:24 vmx kernel: [   13.427168] hub 1-0:1.0: 6 ports detected
Oct  3 11:45:24 vmx kernel: [   13.427358]   alloc irq_desc for 23 on node 0
Oct  3 11:45:24 vmx kernel: [   13.427359]   alloc kstat_irqs on node 0
Oct  3 11:45:24 vmx kernel: [   13.427362] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
Oct  3 11:45:24 vmx kernel: [   13.427399] ehci_hcd 0000:00:1d.7: setting latency timer to 64
Oct  3 11:45:24 vmx kernel: [   13.427402] ehci_hcd 0000:00:1d.7: EHCI Host Controller
Oct  3 11:45:24 vmx kernel: [   13.427438] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
Oct  3 11:45:24 vmx kernel: [   13.431373] ehci_hcd 0000:00:1d.7: debug port 1
Oct  3 11:45:24 vmx kernel: [   13.431405] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
Oct  3 11:45:24 vmx kernel: [   13.431414] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfe7ff800
Oct  3 11:45:24 vmx kernel: [   13.446671] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
Oct  3 11:45:24 vmx kernel: [   13.446714] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
Oct  3 11:45:24 vmx kernel: [   13.446747] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct  3 11:45:24 vmx kernel: [   13.446797] usb usb2: Product: EHCI Host Controller
Oct  3 11:45:24 vmx kernel: [   13.446826] usb usb2: Manufacturer: Linux 2.6.31-0.4 ehci_hcd
Oct  3 11:45:24 vmx kernel: [   13.446855] usb usb2: SerialNumber: 0000:00:1d.7
Oct  3 11:45:24 vmx kernel: [   13.446985] usb usb2: configuration #1 chosen from 1 choice
Oct  3 11:45:24 vmx kernel: [   13.447086] hub 2-0:1.0: USB hub found
Oct  3 11:45:24 vmx kernel: [   13.447121] hub 2-0:1.0: 6 ports detected
Oct  3 11:45:24 vmx kernel: [   13.448678] uhci_hcd: USB Universal Host Controller Interface driver
Oct  3 11:45:24 vmx kernel: [   13.448855] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct  3 11:45:24 vmx kernel: [   13.448889] uhci_hcd 0000:00:1a.0: setting latency timer to 64
Oct  3 11:45:24 vmx kernel: [   13.448892] uhci_hcd 0000:00:1a.0: UHCI Host Controller
Oct  3 11:45:24 vmx kernel: [   13.448928] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
Oct  3 11:45:24 vmx kernel: [   13.448986] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000a800
Oct  3 11:45:24 vmx kernel: [   13.449039] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
Oct  3 11:45:24 vmx kernel: [   13.449069] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct  3 11:45:24 vmx kernel: [   13.449103] usb usb3: Product: UHCI Host Controller
Oct  3 11:45:24 vmx kernel: [   13.449132] usb usb3: Manufacturer: Linux 2.6.31-0.4 uhci_hcd
Oct  3 11:45:24 vmx kernel: [   13.449161] usb usb3: SerialNumber: 0000:00:1a.0
Oct  3 11:45:24 vmx kernel: [   13.449296] usb usb3: configuration #1 chosen from 1 choice
Oct  3 11:45:24 vmx kernel: [   13.449404] hub 3-0:1.0: USB hub found
Oct  3 11:45:24 vmx kernel: [   13.449437] hub 3-0:1.0: 2 ports detected
Oct  3 11:45:24 vmx kernel: [   13.449618]   alloc irq_desc for 21 on node 0
Oct  3 11:45:24 vmx kernel: [   13.449619]   alloc kstat_irqs on node 0
Oct  3 11:45:24 vmx kernel: [   13.449623] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
Oct  3 11:45:24 vmx kernel: [   13.449657] uhci_hcd 0000:00:1a.1: setting latency timer to 64
Oct  3 11:45:24 vmx kernel: [   13.449659] uhci_hcd 0000:00:1a.1: UHCI Host Controller
Oct  3 11:45:24 vmx kernel: [   13.449694] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
Oct  3 11:45:24 vmx kernel: [   13.449750] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000a880
Oct  3 11:45:24 vmx kernel: [   13.449802] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
Oct  3 11:45:24 vmx kernel: [   13.449832] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct  3 11:45:24 vmx kernel: [   13.449866] usb usb4: Product: UHCI Host Controller
Oct  3 11:45:24 vmx kernel: [   13.449895] usb usb4: Manufacturer: Linux 2.6.31-0.4 uhci_hcd
Oct  3 11:45:24 vmx kernel: [   13.449925] usb usb4: SerialNumber: 0000:00:1a.1
Oct  3 11:45:24 vmx kernel: [   13.450053] usb usb4: configuration #1 chosen from 1 choice
Oct  3 11:45:24 vmx kernel: [   13.450156] hub 4-0:1.0: USB hub found
Oct  3 11:45:24 vmx kernel: [   13.450190] hub 4-0:1.0: 2 ports detected
Oct  3 11:45:24 vmx kernel: [   13.450364] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Oct  3 11:45:24 vmx kernel: [   13.450398] uhci_hcd 0000:00:1a.2: setting latency timer to 64
Oct  3 11:45:24 vmx kernel: [   13.450400] uhci_hcd 0000:00:1a.2: UHCI Host Controller
Oct  3 11:45:24 vmx kernel: [   13.450435] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
Oct  3 11:45:24 vmx kernel: [   13.450486] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000ac00
Oct  3 11:45:24 vmx kernel: [   13.450540] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
Oct  3 11:45:24 vmx kernel: [   13.450570] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct  3 11:45:24 vmx kernel: [   13.450604] usb usb5: Product: UHCI Host Controller
Oct  3 11:45:24 vmx kernel: [   13.450633] usb usb5: Manufacturer: Linux 2.6.31-0.4 uhci_hcd
Oct  3 11:45:24 vmx kernel: [   13.450663] usb usb5: SerialNumber: 0000:00:1a.2
Oct  3 11:45:24 vmx kernel: [   13.450791] usb usb5: configuration #1 chosen from 1 choice
Oct  3 11:45:24 vmx kernel: [   13.450896] hub 5-0:1.0: USB hub found
Oct  3 11:45:24 vmx kernel: [   13.450928] hub 5-0:1.0: 2 ports detected
Oct  3 11:45:24 vmx kernel: [   13.451107] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
Oct  3 11:45:24 vmx kernel: [   13.451140] uhci_hcd 0000:00:1d.0: setting latency timer to 64
Oct  3 11:45:24 vmx kernel: [   13.451143] uhci_hcd 0000:00:1d.0: UHCI Host Controller
Oct  3 11:45:24 vmx kernel: [   13.451178] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
Oct  3 11:45:24 vmx kernel: [   13.451229] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000a080
Oct  3 11:45:24 vmx kernel: [   13.451292] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
Oct  3 11:45:24 vmx kernel: [   13.451323] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct  3 11:45:24 vmx kernel: [   13.451356] usb usb6: Product: UHCI Host Controller
Oct  3 11:45:24 vmx kernel: [   13.451385] usb usb6: Manufacturer: Linux 2.6.31-0.4 uhci_hcd
Oct  3 11:45:24 vmx kernel: [   13.451415] usb usb6: SerialNumber: 0000:00:1d.0
Oct  3 11:45:24 vmx kernel: [   13.451544] usb usb6: configuration #1 chosen from 1 choice
Oct  3 11:45:24 vmx kernel: [   13.451649] hub 6-0:1.0: USB hub found
Oct  3 11:45:24 vmx kernel: [   13.451681] hub 6-0:1.0: 2 ports detected
Oct  3 11:45:24 vmx kernel: [   13.451852] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Oct  3 11:45:24 vmx kernel: [   13.451885] uhci_hcd 0000:00:1d.1: setting latency timer to 64
Oct  3 11:45:24 vmx kernel: [   13.451887] uhci_hcd 0000:00:1d.1: UHCI Host Controller
Oct  3 11:45:24 vmx kernel: [   13.451927] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
Oct  3 11:45:24 vmx kernel: [   13.451983] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000a400
Oct  3 11:45:24 vmx kernel: [   13.452035] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
Oct  3 11:45:24 vmx kernel: [   13.452065] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct  3 11:45:24 vmx kernel: [   13.452098] usb usb7: Product: UHCI Host Controller
Oct  3 11:45:24 vmx kernel: [   13.452128] usb usb7: Manufacturer: Linux 2.6.31-0.4 uhci_hcd
Oct  3 11:45:24 vmx kernel: [   13.452157] usb usb7: SerialNumber: 0000:00:1d.1
Oct  3 11:45:24 vmx kernel: [   13.452287] usb usb7: configuration #1 chosen from 1 choice
Oct  3 11:45:24 vmx kernel: [   13.452393] hub 7-0:1.0: USB hub found
Oct  3 11:45:24 vmx kernel: [   13.452424] hub 7-0:1.0: 2 ports detected
Oct  3 11:45:24 vmx kernel: [   13.452600] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Oct  3 11:45:24 vmx kernel: [   13.452633] uhci_hcd 0000:00:1d.2: setting latency timer to 64
Oct  3 11:45:24 vmx kernel: [   13.452635] uhci_hcd 0000:00:1d.2: UHCI Host Controller
Oct  3 11:45:24 vmx kernel: [   13.452670] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
Oct  3 11:45:24 vmx kernel: [   13.452721] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000a480
Oct  3 11:45:24 vmx kernel: [   13.453106] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
Oct  3 11:45:24 vmx kernel: [   13.453136] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct  3 11:45:24 vmx kernel: [   13.453170] usb usb8: Product: UHCI Host Controller
Oct  3 11:45:24 vmx kernel: [   13.453199] usb usb8: Manufacturer: Linux 2.6.31-0.4 uhci_hcd
Oct  3 11:45:24 vmx kernel: [   13.453229] usb usb8: SerialNumber: 0000:00:1d.2
Oct  3 11:45:24 vmx kernel: [   13.453357] usb usb8: configuration #1 chosen from 1 choice
Oct  3 11:45:24 vmx kernel: [   13.453463] hub 8-0:1.0: USB hub found
Oct  3 11:45:24 vmx kernel: [   13.453501] hub 8-0:1.0: 2 ports detected
Oct  3 11:45:24 vmx kernel: [   13.464519] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
Oct  3 11:45:24 vmx kernel: [   13.469906] usbcore: registered new interface driver hiddev
Oct  3 11:45:24 vmx kernel: [   13.469991] usbcore: registered new interface driver usbhid
Oct  3 11:45:24 vmx kernel: [   13.470022] usbhid: v2.6:USB HID core driver
Oct  3 11:45:24 vmx kernel: [   13.471143] md: md0 stopped.
Oct  3 11:45:24 vmx kernel: [   13.592294] md: bind<sda2>
Oct  3 11:45:24 vmx kernel: [   13.592439] md: bind<sdb2>
Oct  3 11:45:24 vmx kernel: [   13.592602] raid1: raid set md0 active with 2 out of 2 mirrors
Oct  3 11:45:24 vmx kernel: [   13.592667] md0: detected capacity change from 0 to 12000559104
Oct  3 11:45:24 vmx kernel: [   13.594220]  md0: unknown partition table
Oct  3 11:45:24 vmx kernel: [   13.682127] VFS: Mounted root (jfs filesystem) readonly on device 9:0.
Oct  3 11:45:24 vmx kernel: [   13.682161] Trying to move old root to /initrd ... okay
Oct  3 11:45:24 vmx kernel: [   13.710316] Freeing unused kernel memory: 504k freed
Oct  3 11:45:24 vmx kernel: [   13.980007] usb 6-1: new low speed USB device using uhci_hcd and address 2
Oct  3 11:45:24 vmx kernel: [   14.147240] usb 6-1: New USB device found, idVendor=046d, idProduct=c051
Oct  3 11:45:24 vmx kernel: [   14.147275] usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Oct  3 11:45:24 vmx kernel: [   14.147307] usb 6-1: Product: USB-PS/2 Optical Mouse
Oct  3 11:45:24 vmx kernel: [   14.147344] usb 6-1: Manufacturer: Logitech
Oct  3 11:45:24 vmx kernel: [   14.147537] usb 6-1: configuration #1 chosen from 1 choice
Oct  3 11:45:24 vmx kernel: [   14.166533] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb6/6-1/6-1:1.0/input/input1
Oct  3 11:45:24 vmx kernel: [   14.166717] generic-usb 0003:046D:C051.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1/input0
Oct  3 11:45:24 vmx kernel: [   14.391258] usb 6-2: new low speed USB device using uhci_hcd and address 3
Oct  3 11:45:24 vmx kernel: [   14.566212] usb 6-2: New USB device found, idVendor=045e, idProduct=00db
Oct  3 11:45:24 vmx kernel: [   14.566248] usb 6-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Oct  3 11:45:24 vmx kernel: [   14.566280] usb 6-2: Product: Natural® Ergonomic Keyboard 4000
Oct  3 11:45:24 vmx kernel: [   14.566316] usb 6-2: Manufacturer: Microsoft
Oct  3 11:45:24 vmx kernel: [   14.566515] usb 6-2: configuration #1 chosen from 1 choice
Oct  3 11:45:24 vmx kernel: [   14.583508] input: Microsoft Natural® Ergonomic Keyboard 4000 as /devices/pci0000:00/0000:00:1d.0/usb6/6-2/6-2:1.0/input/input2
Oct  3 11:45:24 vmx kernel: [   14.583630] microsoft 0003:045E:00DB.0002: input,hidraw1: USB HID v1.11 Keyboard [Microsoft Natural® Ergonomic Keyboard 4000] on usb-0000:00:1d.0-2/input0
Oct  3 11:45:24 vmx kernel: [   14.607360] input: Microsoft Natural® Ergonomic Keyboard 4000 as /devices/pci0000:00/0000:00:1d.0/usb6/6-2/6-2:1.1/input/input3
Oct  3 11:45:24 vmx kernel: [   14.607509] microsoft 0003:045E:00DB.0003: input,hidraw2: USB HID v1.11 Device [Microsoft Natural® Ergonomic Keyboard 4000] on usb-0000:00:1d.0-2/input1
Oct  3 11:45:24 vmx kernel: [   16.456149] sd 0:0:0:0: Attached scsi generic sg0 type 0
Oct  3 11:45:24 vmx kernel: [   16.456185] sd 1:0:0:0: Attached scsi generic sg1 type 0
Oct  3 11:45:24 vmx kernel: [   16.487357] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
Oct  3 11:45:24 vmx kernel: [   16.487423] ACPI: Power Button [PWRF]
Oct  3 11:45:24 vmx kernel: [   16.487480] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input5
Oct  3 11:45:24 vmx kernel: [   16.487512] ACPI: Power Button [PWRB]
Oct  3 11:45:24 vmx kernel: [   16.490141] ACPI: SSDT 00000000cff7e0d0 001F3 (v01 DpgPmm  P001Ist 00000011 INTL 20060113)
Oct  3 11:45:24 vmx kernel: [   16.490599] processor LNXCPU:00: registered as cooling_device0
Oct  3 11:45:24 vmx kernel: [   16.490956] ACPI: SSDT 00000000cff7e2d0 001F3 (v01 DpgPmm  P002Ist 00000012 INTL 20060113)
Oct  3 11:45:24 vmx kernel: [   16.491381] processor LNXCPU:01: registered as cooling_device1
Oct  3 11:45:24 vmx kernel: [   16.491742] ACPI: SSDT 00000000cff7e4d0 001F3 (v01 DpgPmm  P003Ist 00000012 INTL 20060113)
Oct  3 11:45:24 vmx kernel: [   16.492202] processor LNXCPU:02: registered as cooling_device2
Oct  3 11:45:24 vmx kernel: [   16.492574] ACPI: SSDT 00000000cff7e6d0 001F3 (v01 DpgPmm  P004Ist 00000012 INTL 20060113)
Oct  3 11:45:24 vmx kernel: [   16.493001] processor LNXCPU:03: registered as cooling_device3
Oct  3 11:45:24 vmx kernel: [   16.514998] ATL1E 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Oct  3 11:45:24 vmx kernel: [   16.515015] ATL1E 0000:02:00.0: setting latency timer to 64
Oct  3 11:45:24 vmx kernel: [   16.530827] input: PC Speaker as /devices/platform/pcspkr/input/input6
Oct  3 11:45:24 vmx kernel: [   16.572183] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Oct  3 11:45:24 vmx kernel: [   16.572193] ACPI: I/O resource 0000:00:1f.3 [0x400-0x41f] conflicts with ACPI region SMRG [0x400-0x40f]
Oct  3 11:45:24 vmx kernel: [   16.572195] ACPI: Device needs an ACPI driver
Oct  3 11:45:24 vmx kernel: [   16.572210] i801_smbus: probe of 0000:00:1f.3 failed with error -16
Oct  3 11:45:24 vmx kernel: [   16.802768] iTCO_vendor_support: vendor-support=0
Oct  3 11:45:24 vmx kernel: [   16.817071] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
Oct  3 11:45:24 vmx kernel: [   16.817157] iTCO_wdt: Found a ICH10R TCO device (Version=2, TCOBASE=0x0860)
Oct  3 11:45:24 vmx kernel: [   16.817244] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
Oct  3 11:45:24 vmx kernel: [   16.951252]   alloc irq_desc for 22 on node 0
Oct  3 11:45:24 vmx kernel: [   16.951255]   alloc kstat_irqs on node 0
Oct  3 11:45:24 vmx kernel: [   16.951260] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
Oct  3 11:45:24 vmx kernel: [   16.951317] HDA Intel 0000:00:1b.0: setting latency timer to 64
Oct  3 11:45:24 vmx kernel: [   16.979572] via-rhine.c:v1.10-LK1.4.3 2007-03-06 Written by Donald Becker
Oct  3 11:45:24 vmx kernel: [   16.979706] via-rhine 0000:05:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Oct  3 11:45:24 vmx kernel: [   16.983819] eth1: VIA Rhine II at 0xfebff400, 00:05:5d:e1:f9:45, IRQ 17.
Oct  3 11:45:24 vmx kernel: [   16.984527] eth1: MII PHY found at address 8, status 0x7809 advertising 01e1 Link 0000.
Oct  3 11:45:24 vmx kernel: [   16.984548] pata_marvell 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct  3 11:45:24 vmx kernel: [   16.984571] pata_marvell 0000:03:00.0: setting latency timer to 64
Oct  3 11:45:24 vmx kernel: [   16.984641] scsi6 : pata_marvell
Oct  3 11:45:24 vmx kernel: [   16.984721] scsi7 : pata_marvell
Oct  3 11:45:24 vmx kernel: [   16.984762] ata7: PATA max UDMA/100 cmd 0xdc00 ctl 0xd880 bmdma 0xd400 irq 16
Oct  3 11:45:24 vmx kernel: [   16.984764] ata8: PATA max UDMA/133 cmd 0xd800 ctl 0xd480 bmdma 0xd408 irq 16
Oct  3 11:45:24 vmx kernel: [   17.144936] ata7.00: ATAPI: ASUS    DRW-1814BL, 1.10, max UDMA/66
Oct  3 11:45:24 vmx kernel: [   17.158273] ata7.00: configured for UDMA/66
Oct  3 11:45:24 vmx kernel: [   17.159462] scsi 6:0:0:0: CD-ROM            ASUS     DRW-1814BL       1.10 PQ: 0 ANSI: 5
Oct  3 11:45:24 vmx kernel: [   17.159612] scsi 6:0:0:0: Attached scsi generic sg2 type 5
Oct  3 11:45:24 vmx kernel: [   17.321524] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input7
Oct  3 11:45:24 vmx kernel: [   17.360956] Uniform Multi-Platform E-IDE driver
Oct  3 11:45:24 vmx kernel: [   17.362766] Linux video capture interface: v2.00
Oct  3 11:45:24 vmx kernel: [   17.384330] saa7130/34: v4l2 driver version 0.2.15 loaded
Oct  3 11:45:24 vmx kernel: [   17.384858] saa7134 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct  3 11:45:24 vmx kernel: [   17.384864] saa7133[0]: found at 0000:05:00.0, rev: 209, irq: 16, latency: 64, mmio: 0xfebff800
Oct  3 11:45:24 vmx kernel: [   17.384870] saa7133[0]: subsystem: 11bd:002e, board: Pinnacle PCTV 40i/50i/110i (saa7133) [card=77,autodetected]
Oct  3 11:45:24 vmx kernel: [   17.384913] saa7133[0]: board init: gpio is 200e000
Oct  3 11:45:24 vmx kernel: [   17.384917] IRQ 16/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
Oct  3 11:45:24 vmx kernel: [   17.404930] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
Oct  3 11:45:24 vmx kernel: [   17.404933] Uniform CD-ROM driver Revision: 3.20
Oct  3 11:45:24 vmx kernel: [   17.405112] sr 6:0:0:0: Attached scsi CD-ROM sr0
Oct  3 11:45:24 vmx kernel: [   17.533337] saa7133[0]: i2c eeprom 00: bd 11 2e 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
Oct  3 11:45:24 vmx kernel: [   17.533345] saa7133[0]: i2c eeprom 10: ff e0 60 02 ff 20 ff ff ff ff ff ff ff ff ff ff
Oct  3 11:45:24 vmx kernel: [   17.533353] saa7133[0]: i2c eeprom 20: 01 2c 01 23 23 01 04 30 98 ff 00 e2 ff 22 00 c2
Oct  3 11:45:24 vmx kernel: [   17.533360] saa7133[0]: i2c eeprom 30: 96 ff 03 30 15 01 ff 15 13 25 53 89 01 45 32 7b
Oct  3 11:45:24 vmx kernel: [   17.533367] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Oct  3 11:45:24 vmx kernel: [   17.533374] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Oct  3 11:45:24 vmx kernel: [   17.533382] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Oct  3 11:45:24 vmx kernel: [   17.533389] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Oct  3 11:45:24 vmx kernel: [   17.533396] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Oct  3 11:45:24 vmx kernel: [   17.533403] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Oct  3 11:45:24 vmx kernel: [   17.533410] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Oct  3 11:45:24 vmx kernel: [   17.533417] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Oct  3 11:45:24 vmx kernel: [   17.533425] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Oct  3 11:45:24 vmx kernel: [   17.533432] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Oct  3 11:45:24 vmx kernel: [   17.533439] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Oct  3 11:45:24 vmx kernel: [   17.533451] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Oct  3 11:45:24 vmx kernel: [   17.533457] i2c-adapter i2c-0: Invalid 7-bit address 0x7a
Oct  3 11:45:24 vmx kernel: [   17.620059] tuner 0-004b: chip found @ 0x96 (saa7133[0])
Oct  3 11:45:24 vmx kernel: [   17.693336] tda829x 0-004b: setting tuner address to 61
Oct  3 11:45:24 vmx kernel: [   17.760004] tda829x 0-004b: type set to tda8290+75a
Oct  3 11:45:24 vmx kernel: [   43.146807] saa7133[0]: registered device video0 [v4l2]
Oct  3 11:45:24 vmx kernel: [   43.146851] saa7133[0]: registered device vbi0
Oct  3 11:45:24 vmx kernel: [   43.146891] saa7133[0]: registered device radio0
Oct  3 11:45:24 vmx kernel: [   43.217802] saa7134 ALSA driver for DMA sound loaded
Oct  3 11:45:24 vmx kernel: [   43.217811] IRQ 16/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
Oct  3 11:45:24 vmx kernel: [   43.217827] saa7133[0]/alsa: saa7133[0] at 0xfebff800 irq 16 registered as card 1
Oct  3 11:45:24 vmx kernel: [   45.704124] Adding 6000236k swap on /dev/sda1.  Priority:0 extents:1 across:6000236k 
Oct  3 11:45:24 vmx kernel: [   45.713197] Adding 6000236k swap on /dev/sdb1.  Priority:0 extents:1 across:6000236k 
Oct  3 11:45:24 vmx kernel: [   46.959692] device-mapper: uevent: version 1.0.3
Oct  3 11:45:24 vmx kernel: [   46.960194] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
Oct  3 11:45:24 vmx kernel: [   47.233119] md: md1 stopped.
Oct  3 11:45:24 vmx kernel: [   47.235377] md: bind<sdb3>
Oct  3 11:45:24 vmx kernel: [   47.235522] md: bind<sda3>
Oct  3 11:45:24 vmx kernel: [   47.246975] md: raid10 personality registered for level 10
Oct  3 11:45:24 vmx kernel: [   47.247620] raid10: raid set md1 active with 2 out of 2 devices
Oct  3 11:45:24 vmx kernel: [   47.247652] md1: detected capacity change from 0 to 146549637120
Oct  3 11:45:24 vmx kernel: [   47.310568]  md1: unknown partition table
Oct  3 11:45:24 vmx kernel: [   48.978038] ip6_tables: (C) 2000-2006 Netfilter Core Team
Oct  3 11:45:24 vmx kernel: [   49.033674] ip_tables: (C) 2000-2006 Netfilter Core Team
Oct  3 11:45:24 vmx kernel: [   49.063478] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
Oct  3 11:45:24 vmx kernel: [   49.063660] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
Oct  3 11:45:24 vmx kernel: [   49.063662] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
Oct  3 11:45:24 vmx kernel: [   49.063663] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
Oct  3 11:45:24 vmx kernel: [   49.977773]   alloc irq_desc for 29 on node 0
Oct  3 11:45:24 vmx kernel: [   49.977776]   alloc kstat_irqs on node 0
Oct  3 11:45:24 vmx kernel: [   49.977788] ATL1E 0000:02:00.0: irq 29 for MSI/MSI-X
Oct  3 11:45:24 vmx kernel: [   49.977916] ATL1E 0000:02:00.0: ATL1E: eth0 NIC Link is Up<100 Mbps Full Duplex>
Oct  3 11:45:24 vmx kernel: [   49.978662] ADDRCONF(NETDEV_UP): eth0: link is not ready
Oct  3 11:45:24 vmx kernel: [   49.979501] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
Oct  3 11:45:24 vmx kernel: [   55.774769] ATL1E 0000:02:00.0: ATL1E: eth0 NIC Link is Up<100 Mbps Full Duplex>
Oct  3 11:45:24 vmx kernel: [   55.776315] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
Oct  3 11:45:24 vmx kernel: [   55.888366] eth1: link down
Oct  3 11:45:24 vmx kernel: [   55.889223] ADDRCONF(NETDEV_UP): eth1: link is not ready
Oct  3 11:45:24 vmx kernel: [   57.679559] Bluetooth: Core ver 2.15
Oct  3 11:45:24 vmx kernel: [   57.679608] NET: Registered protocol family 31
Oct  3 11:45:24 vmx kernel: [   57.679610] Bluetooth: HCI device and connection manager initialized
Oct  3 11:45:24 vmx kernel: [   57.679612] Bluetooth: HCI socket layer initialized
Oct  3 11:45:24 vmx kernel: [   57.687841] Bluetooth: L2CAP ver 2.13
Oct  3 11:45:24 vmx kernel: [   57.687844] Bluetooth: L2CAP socket layer initialized
Oct  3 11:45:24 vmx kernel: [   57.690853] Bluetooth: RFCOMM TTY layer initialized
Oct  3 11:45:24 vmx kernel: [   57.690856] Bluetooth: RFCOMM socket layer initialized
Oct  3 11:45:24 vmx kernel: [   57.690858] Bluetooth: RFCOMM ver 1.11
Oct  3 11:45:24 vmx kernel: [   58.149679] coretemp coretemp.0: Using relative temperature scale!
Oct  3 11:45:24 vmx kernel: [   58.149765] coretemp coretemp.1: Using relative temperature scale!
Oct  3 11:45:24 vmx kernel: [   58.149852] coretemp coretemp.2: Using relative temperature scale!
Oct  3 11:45:24 vmx kernel: [   58.149907] coretemp coretemp.3: Using relative temperature scale!
Oct  3 11:45:24 vmx kernel: [   58.509999] dummy0: no IPv6 routers present
Oct  3 11:45:35 vmx kernel: [   62.330672] radeonfb 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct  3 11:45:35 vmx kernel: [   62.331097] radeonfb: Found Intel x86 BIOS ROM Image
Oct  3 11:45:35 vmx kernel: [   62.331099] radeonfb: Retrieved PLL infos from BIOS
Oct  3 11:45:35 vmx kernel: [   62.331101] radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=400.00 Mhz, System=350.00 MHz
Oct  3 11:45:35 vmx kernel: [   62.331103] radeonfb: PLL min 20000 max 40000
Oct  3 11:45:35 vmx kernel: [   62.591079] i2c-adapter i2c-3: unable to read EDID block.
Oct  3 11:45:35 vmx kernel: [   62.734411] i2c-adapter i2c-3: unable to read EDID block.
Oct  3 11:45:35 vmx kernel: [   62.877744] i2c-adapter i2c-3: unable to read EDID block.
Oct  3 11:45:35 vmx kernel: [   63.181002] radeonfb: Monitor 1 type DFP found
Oct  3 11:45:35 vmx kernel: [   63.181003] radeonfb: EDID probed
Oct  3 11:45:35 vmx kernel: [   63.181005] radeonfb: Monitor 2 type no found
Oct  3 11:45:35 vmx kernel: [   63.201175] Console: switching to colour frame buffer device 210x65
Oct  3 11:45:35 vmx kernel: [   63.212308] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
Oct  3 11:45:35 vmx kernel: [   63.212310] radeonfb (0000:01:00.0): ATI Radeon 5b63 "[c"
Oct  3 11:45:37 vmx kernel: [   64.774411] vboxdrv: Trying to deactivate the NMI watchdog permanently...
Oct  3 11:45:37 vmx kernel: [   64.774414] vboxdrv: Successfully done.
Oct  3 11:45:37 vmx kernel: [   64.774416] vboxdrv: Found 4 processor cores.
Oct  3 11:45:37 vmx kernel: [   64.774558] VBoxDrv: dbg - g_abExecMemory=ffffffffa0558000
Oct  3 11:45:37 vmx kernel: [   64.774606] vboxdrv: fAsync=0 offMin=0x3b1 offMax=0x13dd
Oct  3 11:45:37 vmx kernel: [   64.774873] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
Oct  3 11:45:37 vmx kernel: [   64.774875] vboxdrv: Successfully loaded version 3.0.6 (interface 0x000e0000).
Oct  3 11:45:37 vmx kernel: [   64.784905] VBoxNetFlt: dbg - g_abExecMemory=ffffffffa06fc000
Oct  3 11:48:08 vmx kernel: [    0.000000] BIOS-provided physical RAM map:
Oct  3 11:48:08 vmx kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
Oct  3 11:48:08 vmx kernel: [    0.000000]  BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
Oct  3 11:48:08 vmx kernel: [    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
Oct  3 11:48:08 vmx kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 00000000cff70000 (usable)
Oct  3 11:48:08 vmx kernel: [    0.000000]  BIOS-e820: 00000000cff70000 - 00000000cff7e000 (ACPI data)
Oct  3 11:48:08 vmx kernel: [    0.000000]  BIOS-e820: 00000000cff7e000 - 00000000cffd0000 (ACPI NVS)
Oct  3 11:48:08 vmx kernel: [    0.000000]  BIOS-e820: 00000000cffd0000 - 00000000d0000000 (reserved)
Oct  3 11:48:08 vmx kernel: [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Oct  3 11:48:08 vmx kernel: [    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
Oct  3 11:48:08 vmx kernel: [    0.000000]  BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
Oct  3 11:48:08 vmx kernel: [    0.000000] DMI present.
Oct  3 11:48:08 vmx kernel: [    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
Oct  3 11:48:08 vmx kernel: [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
Oct  3 11:48:08 vmx kernel: [    0.000000] last_pfn = 0x230000 max_arch_pfn = 0x400000000
Oct  3 11:48:08 vmx kernel: [    0.000000] MTRR default type: uncachable
Oct  3 11:48:08 vmx kernel: [    0.000000] MTRR fixed ranges enabled:
Oct  3 11:48:08 vmx kernel: [    0.000000]   00000-9FFFF write-back
Oct  3 11:48:08 vmx kernel: [    0.000000]   A0000-BFFFF uncachable
Oct  3 11:48:08 vmx kernel: [    0.000000]   C0000-DFFFF write-protect
Oct  3 11:48:08 vmx kernel: [    0.000000]   E0000-EFFFF write-through
Oct  3 11:48:08 vmx kernel: [    0.000000]   F0000-FFFFF write-protect
Oct  3 11:48:08 vmx kernel: [    0.000000] MTRR variable ranges enabled:
Oct  3 11:48:08 vmx kernel: [    0.000000]   0 base 000000000 mask E00000000 write-back
Oct  3 11:48:08 vmx kernel: [    0.000000]   1 base 200000000 mask FE0000000 write-back
Oct  3 11:48:08 vmx kernel: [    0.000000]   2 base 220000000 mask FF0000000 write-back
Oct  3 11:48:08 vmx kernel: [    0.000000]   3 base 0D0000000 mask FF0000000 uncachable
Oct  3 11:48:08 vmx kernel: [    0.000000]   4 base 0E0000000 mask FE0000000 uncachable
Oct  3 11:48:08 vmx kernel: [    0.000000]   5 disabled
Oct  3 11:48:08 vmx kernel: [    0.000000]   6 disabled
Oct  3 11:48:08 vmx kernel: [    0.000000]   7 disabled
Oct  3 11:48:08 vmx kernel: [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Oct  3 11:48:08 vmx kernel: [    0.000000] e820 update range: 00000000d0000000 - 0000000100000000 (usable) ==> (reserved)
Oct  3 11:48:08 vmx kernel: [    0.000000] last_pfn = 0xcff70 max_arch_pfn = 0x400000000
Oct  3 11:48:08 vmx kernel: [    0.000000] Scanning 0 areas for low memory corruption
Oct  3 11:48:08 vmx kernel: [    0.000000] modified physical RAM map:
Oct  3 11:48:08 vmx kernel: [    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
Oct  3 11:48:08 vmx kernel: [    0.000000]  modified: 0000000000010000 - 000000000009cc00 (usable)
Oct  3 11:48:08 vmx kernel: [    0.000000]  modified: 000000000009cc00 - 00000000000a0000 (reserved)
Oct  3 11:48:08 vmx kernel: [    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
Oct  3 11:48:08 vmx kernel: [    0.000000]  modified: 0000000000100000 - 00000000cff70000 (usable)
Oct  3 11:48:08 vmx kernel: [    0.000000]  modified: 00000000cff70000 - 00000000cff7e000 (ACPI data)
Oct  3 11:48:08 vmx kernel: [    0.000000]  modified: 00000000cff7e000 - 00000000cffd0000 (ACPI NVS)
Oct  3 11:48:08 vmx kernel: [    0.000000]  modified: 00000000cffd0000 - 00000000d0000000 (reserved)
Oct  3 11:48:08 vmx kernel: [    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
Oct  3 11:48:08 vmx kernel: [    0.000000]  modified: 00000000fff00000 - 0000000100000000 (reserved)
Oct  3 11:48:08 vmx kernel: [    0.000000]  modified: 0000000100000000 - 0000000230000000 (usable)
Oct  3 11:48:08 vmx kernel: [    0.000000] initial memory mapped : 0 - 20000000
Oct  3 11:48:08 vmx kernel: [    0.000000] init_memory_mapping: 0000000000000000-00000000cff70000
Oct  3 11:48:08 vmx kernel: [    0.000000]  0000000000 - 00cfe00000 page 2M
Oct  3 11:48:08 vmx kernel: [    0.000000]  00cfe00000 - 00cff70000 page 4k
Oct  3 11:48:08 vmx kernel: [    0.000000] kernel direct mapping tables up to cff70000 @ 10000-16000
Oct  3 11:48:08 vmx kernel: [    0.000000] init_memory_mapping: 0000000100000000-0000000230000000
Oct  3 11:48:08 vmx kernel: [    0.000000]  0100000000 - 0230000000 page 2M
Oct  3 11:48:08 vmx kernel: [    0.000000] kernel direct mapping tables up to 230000000 @ 14000-1e000
Oct  3 11:48:08 vmx kernel: [    0.000000] RAMDISK: 37f0e000 - 37fef404
Oct  3 11:48:08 vmx kernel: [    0.000000] ACPI: RSDP 00000000000fb460 00024 (v02 ACPIAM)
Oct  3 11:48:08 vmx kernel: [    0.000000] ACPI: XSDT 00000000cff70100 0005C (v01 A_M_I_ OEMXSDT  08000820 MSFT 00000097)
Oct  3 11:48:08 vmx kernel: [    0.000000] ACPI: FACP 00000000cff70290 000F4 (v03 A_M_I_ OEMFACP  08000820 MSFT 00000097)
Oct  3 11:48:08 vmx kernel: [    0.000000] ACPI: DSDT 00000000cff70440 0964B (v01  A1012 A1012001 00000001 INTL 20060113)
Oct  3 11:48:08 vmx kernel: [    0.000000] ACPI: FACS 00000000cff7e000 00040
Oct  3 11:48:08 vmx kernel: [    0.000000] ACPI: APIC 00000000cff70390 0006C (v01 A_M_I_ OEMAPIC  08000820 MSFT 00000097)
Oct  3 11:48:08 vmx kernel: [    0.000000] ACPI: MCFG 00000000cff70400 0003C (v01 A_M_I_ OEMMCFG  08000820 MSFT 00000097)
Oct  3 11:48:08 vmx kernel: [    0.000000] ACPI: OEMB 00000000cff7e040 00081 (v01 A_M_I_ AMI_OEM  08000820 MSFT 00000097)
Oct  3 11:48:08 vmx kernel: [    0.000000] ACPI: HPET 00000000cff79a90 00038 (v01 A_M_I_ OEMHPET  08000820 MSFT 00000097)
Oct  3 11:48:08 vmx kernel: [    0.000000] ACPI: OSFR 00000000cff79ad0 000B0 (v01 A_M_I_ OEMOSFR  08000820 MSFT 00000097)
Oct  3 11:48:08 vmx kernel: [    0.000000] ACPI: SSDT 00000000cff7e8d0 00A7C (v01 DpgPmm    CpuPm 00000012 INTL 20060113)
Oct  3 11:48:08 vmx kernel: [    0.000000] ACPI: Local APIC address 0xfee00000
Oct  3 11:48:08 vmx kernel: [    0.000000] No NUMA configuration found
Oct  3 11:48:08 vmx kernel: [    0.000000] Faking a node at 0000000000000000-0000000230000000
Oct  3 11:48:08 vmx kernel: [    0.000000] Bootmem setup node 0 0000000000000000-0000000230000000
Oct  3 11:48:08 vmx kernel: [    0.000000]   NODE_DATA [0000000000019000 - 000000000001dfff]
Oct  3 11:48:08 vmx kernel: [    0.000000]   bootmap [000000000001e000 -  0000000000063fff] pages 46
Oct  3 11:48:08 vmx kernel: [    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0230000000]
Oct  3 11:48:08 vmx kernel: [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
Oct  3 11:48:08 vmx kernel: [    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
Oct  3 11:48:08 vmx kernel: [    0.000000]   #2 [0001000000 - 0001669b80]    TEXT DATA BSS ==> [0001000000 - 0001669b80]
Oct  3 11:48:08 vmx kernel: [    0.000000]   #3 [0037f0e000 - 0037fef404]          RAMDISK ==> [0037f0e000 - 0037fef404]
Oct  3 11:48:08 vmx kernel: [    0.000000]   #4 [000009cc00 - 0000100000]    BIOS reserved ==> [000009cc00 - 0000100000]
Oct  3 11:48:08 vmx kernel: [    0.000000]   #5 [000166a000 - 000166a278]              BRK ==> [000166a000 - 000166a278]
Oct  3 11:48:08 vmx kernel: [    0.000000]   #6 [0000010000 - 0000014000]          PGTABLE ==> [0000010000 - 0000014000]
Oct  3 11:48:08 vmx kernel: [    0.000000]   #7 [0000014000 - 0000019000]          PGTABLE ==> [0000014000 - 0000019000]
Oct  3 11:48:08 vmx kernel: [    0.000000]  [ffffea0000000000-ffffea0007bfffff] PMD -> [ffff880028600000-ffff88002f7fffff] on node 0
Oct  3 11:48:08 vmx kernel: [    0.000000] Zone PFN ranges:
Oct  3 11:48:08 vmx kernel: [    0.000000]   DMA      0x00000010 -> 0x00001000
Oct  3 11:48:08 vmx kernel: [    0.000000]   DMA32    0x00001000 -> 0x00100000
Oct  3 11:48:08 vmx kernel: [    0.000000]   Normal   0x00100000 -> 0x00230000
Oct  3 11:48:08 vmx kernel: [    0.000000] Movable zone start PFN for each node
Oct  3 11:48:08 vmx kernel: [    0.000000] early_node_map[3] active PFN ranges
Oct  3 11:48:08 vmx kernel: [    0.000000]     0: 0x00000010 -> 0x0000009c
Oct  3 11:48:08 vmx kernel: [    0.000000]     0: 0x00000100 -> 0x000cff70
Oct  3 11:48:08 vmx kernel: [    0.000000]     0: 0x00100000 -> 0x00230000
Oct  3 11:48:08 vmx kernel: [    0.000000] On node 0 totalpages: 2096892
Oct  3 11:48:08 vmx kernel: [    0.000000]   DMA zone: 56 pages used for memmap
Oct  3 11:48:08 vmx kernel: [    0.000000]   DMA zone: 111 pages reserved
Oct  3 11:48:08 vmx kernel: [    0.000000]   DMA zone: 3813 pages, LIFO batch:0
Oct  3 11:48:08 vmx kernel: [    0.000000]   DMA32 zone: 14280 pages used for memmap
Oct  3 11:48:08 vmx kernel: [    0.000000]   DMA32 zone: 833448 pages, LIFO batch:31
Oct  3 11:48:08 vmx kernel: [    0.000000]   Normal zone: 17024 pages used for memmap
Oct  3 11:48:08 vmx kernel: [    0.000000]   Normal zone: 1228160 pages, LIFO batch:31
Oct  3 11:48:08 vmx kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x808
Oct  3 11:48:08 vmx kernel: [    0.000000] ACPI: Local APIC address 0xfee00000
Oct  3 11:48:08 vmx kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Oct  3 11:48:08 vmx kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Oct  3 11:48:08 vmx kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
Oct  3 11:48:08 vmx kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
Oct  3 11:48:08 vmx kernel: [    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
Oct  3 11:48:08 vmx kernel: [    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
Oct  3 11:48:08 vmx kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Oct  3 11:48:08 vmx kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Oct  3 11:48:08 vmx kernel: [    0.000000] ACPI: IRQ0 used by override.
Oct  3 11:48:08 vmx kernel: [    0.000000] ACPI: IRQ2 used by override.
Oct  3 11:48:08 vmx kernel: [    0.000000] ACPI: IRQ9 used by override.
Oct  3 11:48:08 vmx kernel: [    0.000000] Using ACPI (MADT) for SMP configuration information
Oct  3 11:48:08 vmx kernel: [    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
Oct  3 11:48:08 vmx kernel: [    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
Oct  3 11:48:08 vmx kernel: [    0.000000] nr_irqs_gsi: 24
Oct  3 11:48:08 vmx kernel: [    0.000000] PM: Registered nosave memory: 000000000009c000 - 000000000009d000
Oct  3 11:48:08 vmx kernel: [    0.000000] PM: Registered nosave memory: 000000000009d000 - 00000000000a0000
Oct  3 11:48:08 vmx kernel: [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
Oct  3 11:48:08 vmx kernel: [    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
Oct  3 11:48:08 vmx kernel: [    0.000000] PM: Registered nosave memory: 00000000cff70000 - 00000000cff7e000
Oct  3 11:48:08 vmx kernel: [    0.000000] PM: Registered nosave memory: 00000000cff7e000 - 00000000cffd0000
Oct  3 11:48:08 vmx kernel: [    0.000000] PM: Registered nosave memory: 00000000cffd0000 - 00000000d0000000
Oct  3 11:48:08 vmx kernel: [    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000fee00000
Oct  3 11:48:08 vmx kernel: [    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
Oct  3 11:48:08 vmx kernel: [    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000fff00000
Oct  3 11:48:08 vmx kernel: [    0.000000] PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
Oct  3 11:48:08 vmx kernel: [    0.000000] Allocating PCI resources starting at d0000000 (gap: d0000000:2ee00000)
Oct  3 11:48:08 vmx kernel: [    0.000000] NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4 nr_node_ids:1
Oct  3 11:48:08 vmx kernel: [    0.000000] PERCPU: Embedded 28 pages at ffff880028034000, static data 82208 bytes
Oct  3 11:48:08 vmx kernel: [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2065421
Oct  3 11:48:08 vmx kernel: [    0.000000] Policy zone: Normal
Oct  3 11:48:08 vmx kernel: [    0.000000] Kernel command line: root=/dev/md0 radeonfb.mode_option=1680x1050
Oct  3 11:48:08 vmx kernel: [    0.000000] Unknown boot option `radeonfb.mode_option=1680x1050': ignoring
Oct  3 11:48:08 vmx kernel: [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
Oct  3 11:48:08 vmx kernel: [    0.000000] Initializing CPU#0
Oct  3 11:48:08 vmx kernel: [    0.000000] Checking aperture...
Oct  3 11:48:08 vmx kernel: [    0.000000] No AGP bridge found
Oct  3 11:48:08 vmx kernel: [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
Oct  3 11:48:08 vmx kernel: [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Oct  3 11:48:08 vmx kernel: [    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Oct  3 11:48:08 vmx kernel: [    0.000000] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
Oct  3 11:48:08 vmx kernel: [    0.000000] software IO TLB at phys 0x20000000 - 0x24000000
Oct  3 11:48:08 vmx kernel: [    0.000000] Memory: 8196628k/9175040k available (3620k kernel code, 787472k absent, 190940k reserved, 1776k data, 512k init)
Oct  3 11:48:08 vmx kernel: [    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Oct  3 11:48:08 vmx kernel: [    0.000000] NR_IRQS:4352 nr_irqs:440
Oct  3 11:48:08 vmx kernel: [    0.000000] Extended CMOS year: 2000
Oct  3 11:48:08 vmx kernel: [    0.000000] Fast TSC calibration using PIT
Oct  3 11:48:08 vmx kernel: [    0.000000] Detected 2499.723 MHz processor.
Oct  3 11:48:08 vmx kernel: [    0.000605] Console: colour VGA+ 80x25
Oct  3 11:48:08 vmx kernel: [    0.000607] console [tty0] enabled
Oct  3 11:48:08 vmx kernel: [    0.003333] allocated 83886080 bytes of page_cgroup
Oct  3 11:48:08 vmx kernel: [    0.003333] please try 'cgroup_disable=memory' option if you don't want memory cgroups
Oct  3 11:48:08 vmx kernel: [    0.003333] hpet clockevent registered
Oct  3 11:48:08 vmx kernel: [    0.003333] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
Oct  3 11:48:08 vmx kernel: [    0.003333] Calibrating delay loop (skipped), value calculated using timer frequency.. 5001.75 BogoMIPS (lpj=8332410)
Oct  3 11:48:08 vmx kernel: [    0.003333] Security Framework initialized
Oct  3 11:48:08 vmx kernel: [    0.003333] SELinux:  Disabled at boot.
Oct  3 11:48:08 vmx kernel: [    0.003333] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Oct  3 11:48:08 vmx kernel: [    0.003943] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Oct  3 11:48:08 vmx kernel: [    0.005431] Mount-cache hash table entries: 256
Oct  3 11:48:08 vmx kernel: [    0.005593] Initializing cgroup subsys ns
Oct  3 11:48:08 vmx kernel: [    0.005627] Initializing cgroup subsys cpuacct
Oct  3 11:48:08 vmx kernel: [    0.005657] Initializing cgroup subsys memory
Oct  3 11:48:08 vmx kernel: [    0.005690] Initializing cgroup subsys devices
Oct  3 11:48:08 vmx kernel: [    0.005720] Initializing cgroup subsys freezer
Oct  3 11:48:08 vmx kernel: [    0.005749] Initializing cgroup subsys net_cls
Oct  3 11:48:08 vmx kernel: [    0.005791] CPU: L1 I cache: 32K, L1 D cache: 32K
Oct  3 11:48:08 vmx kernel: [    0.005843] CPU: L2 cache: 3072K
Oct  3 11:48:08 vmx kernel: [    0.005873] CPU 0/0x0 -> Node 0
Oct  3 11:48:08 vmx kernel: [    0.005902] CPU: Physical Processor ID: 0
Oct  3 11:48:08 vmx kernel: [    0.005931] CPU: Processor Core ID: 0
Oct  3 11:48:08 vmx kernel: [    0.005961] mce: CPU supports 6 MCE banks
Oct  3 11:48:08 vmx kernel: [    0.005994] CPU0: Thermal monitoring enabled (TM2)
Oct  3 11:48:08 vmx kernel: [    0.006025] using mwait in idle threads.
Oct  3 11:48:08 vmx kernel: [    0.006054] Performance Counters: Core2 events, Intel PMU driver.
Oct  3 11:48:08 vmx kernel: [    0.006133] ... version:                 2
Oct  3 11:48:08 vmx kernel: [    0.006162] ... bit width:               40
Oct  3 11:48:08 vmx kernel: [    0.006190] ... generic counters:        2
Oct  3 11:48:08 vmx kernel: [    0.006219] ... value mask:              000000ffffffffff
Oct  3 11:48:08 vmx kernel: [    0.006248] ... max period:              000000007fffffff
Oct  3 11:48:08 vmx kernel: [    0.006277] ... fixed-purpose counters:  3
Oct  3 11:48:08 vmx kernel: [    0.006305] ... counter mask:            0000000700000003
Oct  3 11:48:08 vmx kernel: [    0.006351] ACPI: Core revision 20090521
Oct  3 11:48:08 vmx kernel: [    0.020047] Setting APIC routing to flat
Oct  3 11:48:08 vmx kernel: [    0.020375] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Oct  3 11:48:08 vmx kernel: [    0.053463] CPU0: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
Oct  3 11:48:08 vmx kernel: [    0.056666] Booting processor 1 APIC 0x1 ip 0x6000
Oct  3 11:48:08 vmx kernel: [    0.003333] Initializing CPU#1
Oct  3 11:48:08 vmx kernel: [    0.003333] Calibrating delay using timer specific routine.. 5001.65 BogoMIPS (lpj=8332252)
Oct  3 11:48:08 vmx kernel: [    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
Oct  3 11:48:08 vmx kernel: [    0.003333] CPU: L2 cache: 3072K
Oct  3 11:48:08 vmx kernel: [    0.003333] CPU 1/0x1 -> Node 0
Oct  3 11:48:08 vmx kernel: [    0.003333] CPU: Physical Processor ID: 0
Oct  3 11:48:08 vmx kernel: [    0.003333] CPU: Processor Core ID: 1
Oct  3 11:48:08 vmx kernel: [    0.003333] mce: CPU supports 6 MCE banks
Oct  3 11:48:08 vmx kernel: [    0.003333] CPU1: Thermal monitoring enabled (TM2)
Oct  3 11:48:08 vmx kernel: [    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
Oct  3 11:48:08 vmx kernel: [    0.147932] CPU1: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
Oct  3 11:48:08 vmx kernel: [    0.148294] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Oct  3 11:48:08 vmx kernel: [    0.150086] Booting processor 2 APIC 0x2 ip 0x6000
Oct  3 11:48:08 vmx kernel: [    0.003333] Initializing CPU#2
Oct  3 11:48:08 vmx kernel: [    0.003333] Calibrating delay using timer specific routine.. 5001.68 BogoMIPS (lpj=8332290)
Oct  3 11:48:08 vmx kernel: [    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
Oct  3 11:48:08 vmx kernel: [    0.003333] CPU: L2 cache: 3072K
Oct  3 11:48:08 vmx kernel: [    0.003333] CPU 2/0x2 -> Node 0
Oct  3 11:48:08 vmx kernel: [    0.003333] CPU: Physical Processor ID: 0
Oct  3 11:48:08 vmx kernel: [    0.003333] CPU: Processor Core ID: 2
Oct  3 11:48:08 vmx kernel: [    0.003333] mce: CPU supports 6 MCE banks
Oct  3 11:48:08 vmx kernel: [    0.003333] CPU2: Thermal monitoring enabled (TM2)
Oct  3 11:48:08 vmx kernel: [    0.003333] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
Oct  3 11:48:08 vmx kernel: [    0.244569] CPU2: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
Oct  3 11:48:08 vmx kernel: [    0.245262] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
Oct  3 11:48:08 vmx kernel: [    0.246725] Booting processor 3 APIC 0x3 ip 0x6000
Oct  3 11:48:08 vmx kernel: [    0.003333] Initializing CPU#3
Oct  3 11:48:08 vmx kernel: [    0.003333] Calibrating delay using timer specific routine.. 5001.68 BogoMIPS (lpj=8332292)
Oct  3 11:48:08 vmx kernel: [    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
Oct  3 11:48:08 vmx kernel: [    0.003333] CPU: L2 cache: 3072K
Oct  3 11:48:08 vmx kernel: [    0.003333] CPU 3/0x3 -> Node 0
Oct  3 11:48:08 vmx kernel: [    0.003333] CPU: Physical Processor ID: 0
Oct  3 11:48:08 vmx kernel: [    0.003333] CPU: Processor Core ID: 3
Oct  3 11:48:08 vmx kernel: [    0.003333] mce: CPU supports 6 MCE banks
Oct  3 11:48:08 vmx kernel: [    0.003333] CPU3: Thermal monitoring enabled (TM2)
Oct  3 11:48:08 vmx kernel: [    0.003333] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
Oct  3 11:48:08 vmx kernel: [    0.341285] CPU3: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
Oct  3 11:48:08 vmx kernel: [    0.341645] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Oct  3 11:48:08 vmx kernel: [    0.343341] Brought up 4 CPUs
Oct  3 11:48:08 vmx kernel: [    0.343379] Total of 4 processors activated (20005.77 BogoMIPS).
Oct  3 11:48:08 vmx kernel: [    0.343478] regulator: core version 0.5
Oct  3 11:48:08 vmx kernel: [    0.343478] NET: Registered protocol family 16
Oct  3 11:48:08 vmx kernel: [    0.343478] ACPI: bus type pci registered
Oct  3 11:48:08 vmx kernel: [    0.343478] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
Oct  3 11:48:08 vmx kernel: [    0.346668] PCI: Not using MMCONFIG.
Oct  3 11:48:08 vmx kernel: [    0.346697] PCI: Using configuration type 1 for base access
Oct  3 11:48:08 vmx kernel: [    0.346736] bio: create slab <bio-0> at 0
Oct  3 11:48:08 vmx kernel: [    0.347217] ACPI: EC: Look up EC in DSDT
Oct  3 11:48:08 vmx kernel: [    0.361404] ACPI: Interpreter enabled
Oct  3 11:48:08 vmx kernel: [    0.361440] ACPI: (supports S0 S1 S3 S4 S5)
Oct  3 11:48:08 vmx kernel: [    0.361601] ACPI: Using IOAPIC for interrupt routing
Oct  3 11:48:08 vmx kernel: [    0.361674] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
Oct  3 11:48:08 vmx kernel: [    0.364044] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
Oct  3 11:48:08 vmx kernel: [    0.369451] PCI: Using MMCONFIG at e0000000 - efffffff
Oct  3 11:48:08 vmx kernel: [    0.376834] ACPI: No dock devices found.
Oct  3 11:48:08 vmx kernel: [    0.376962] ACPI: PCI Root Bridge [PCI0] (0000:00)
Oct  3 11:48:08 vmx kernel: [    0.377017] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
Oct  3 11:48:08 vmx kernel: [    0.377017] pci 0000:00:01.0: PME# disabled
Oct  3 11:48:08 vmx kernel: [    0.377017] pci 0000:00:1a.0: reg 20 io port: [0xa800-0xa81f]
Oct  3 11:48:08 vmx kernel: [    0.377017] pci 0000:00:1a.1: reg 20 io port: [0xa880-0xa89f]
Oct  3 11:48:08 vmx kernel: [    0.377017] pci 0000:00:1a.2: reg 20 io port: [0xac00-0xac1f]
Oct  3 11:48:08 vmx kernel: [    0.377017] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfe7ffc00-0xfe7fffff]
Oct  3 11:48:08 vmx kernel: [    0.377048] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
Oct  3 11:48:08 vmx kernel: [    0.377080] pci 0000:00:1a.7: PME# disabled
Oct  3 11:48:08 vmx kernel: [    0.377139] pci 0000:00:1b.0: reg 10 64bit mmio: [0xfe7f8000-0xfe7fbfff]
Oct  3 11:48:08 vmx kernel: [    0.377171] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
Oct  3 11:48:08 vmx kernel: [    0.377202] pci 0000:00:1b.0: PME# disabled
Oct  3 11:48:08 vmx kernel: [    0.377277] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
Oct  3 11:48:08 vmx kernel: [    0.377308] pci 0000:00:1c.0: PME# disabled
Oct  3 11:48:08 vmx kernel: [    0.377383] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
Oct  3 11:48:08 vmx kernel: [    0.377414] pci 0000:00:1c.4: PME# disabled
Oct  3 11:48:08 vmx kernel: [    0.377487] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
Oct  3 11:48:08 vmx kernel: [    0.377518] pci 0000:00:1c.5: PME# disabled
Oct  3 11:48:08 vmx kernel: [    0.377588] pci 0000:00:1d.0: reg 20 io port: [0xa080-0xa09f]
Oct  3 11:48:08 vmx kernel: [    0.377643] pci 0000:00:1d.1: reg 20 io port: [0xa400-0xa41f]
Oct  3 11:48:08 vmx kernel: [    0.377697] pci 0000:00:1d.2: reg 20 io port: [0xa480-0xa49f]
Oct  3 11:48:08 vmx kernel: [    0.377755] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfe7ff800-0xfe7ffbff]
Oct  3 11:48:08 vmx kernel: [    0.377800] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
Oct  3 11:48:08 vmx kernel: [    0.377831] pci 0000:00:1d.7: PME# disabled
Oct  3 11:48:08 vmx kernel: [    0.377965] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
Oct  3 11:48:08 vmx kernel: [    0.378000] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
Oct  3 11:48:08 vmx kernel: [    0.378031] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0294 (mask 0003)
Oct  3 11:48:08 vmx kernel: [    0.378067] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 4700 (mask 001f)
Oct  3 11:48:08 vmx kernel: [    0.378149] pci 0000:00:1f.2: reg 10 io port: [0x9c00-0x9c07]
Oct  3 11:48:08 vmx kernel: [    0.378154] pci 0000:00:1f.2: reg 14 io port: [0x9880-0x9883]
Oct  3 11:48:08 vmx kernel: [    0.378162] pci 0000:00:1f.2: reg 18 io port: [0x9800-0x9807]
Oct  3 11:48:08 vmx kernel: [    0.378171] pci 0000:00:1f.2: reg 1c io port: [0x9480-0x9483]
Oct  3 11:48:08 vmx kernel: [    0.378175] pci 0000:00:1f.2: reg 20 io port: [0x9400-0x941f]
Oct  3 11:48:08 vmx kernel: [    0.378180] pci 0000:00:1f.2: reg 24 32bit mmio: [0xfe7fe800-0xfe7fefff]
Oct  3 11:48:08 vmx kernel: [    0.378204] pci 0000:00:1f.2: PME# supported from D3hot
Oct  3 11:48:08 vmx kernel: [    0.378235] pci 0000:00:1f.2: PME# disabled
Oct  3 11:48:08 vmx kernel: [    0.378284] pci 0000:00:1f.3: reg 10 64bit mmio: [0xfe7ff400-0xfe7ff4ff]
Oct  3 11:48:08 vmx kernel: [    0.378295] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
Oct  3 11:48:08 vmx kernel: [    0.378329] pci 0000:01:00.0: reg 10 32bit mmio: [0xd0000000-0xdfffffff]
Oct  3 11:48:08 vmx kernel: [    0.378333] pci 0000:01:00.0: reg 14 io port: [0xb000-0xb0ff]
Oct  3 11:48:08 vmx kernel: [    0.378337] pci 0000:01:00.0: reg 18 32bit mmio: [0xfe8e0000-0xfe8effff]
Oct  3 11:48:08 vmx kernel: [    0.378349] pci 0000:01:00.0: reg 30 32bit mmio: [0xfe8c0000-0xfe8dffff]
Oct  3 11:48:08 vmx kernel: [    0.378363] pci 0000:01:00.0: supports D1 D2
Oct  3 11:48:08 vmx kernel: [    0.378385] pci 0000:01:00.1: reg 10 32bit mmio: [0xfe8f0000-0xfe8fffff]
Oct  3 11:48:08 vmx kernel: [    0.378413] pci 0000:01:00.1: supports D1 D2
Oct  3 11:48:08 vmx kernel: [    0.378447] pci 0000:00:01.0: bridge io port: [0xb000-0xbfff]
Oct  3 11:48:08 vmx kernel: [    0.378449] pci 0000:00:01.0: bridge 32bit mmio: [0xfe800000-0xfe8fffff]
Oct  3 11:48:08 vmx kernel: [    0.378452] pci 0000:00:01.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
Oct  3 11:48:08 vmx kernel: [    0.378487] pci 0000:00:1c.0: bridge 64bit mmio pref: [0xfdf00000-0xfdffffff]
Oct  3 11:48:08 vmx kernel: [    0.378525] pci 0000:03:00.0: reg 10 io port: [0xdc00-0xdc07]
Oct  3 11:48:08 vmx kernel: [    0.378532] pci 0000:03:00.0: reg 14 io port: [0xd880-0xd883]
Oct  3 11:48:08 vmx kernel: [    0.378539] pci 0000:03:00.0: reg 18 io port: [0xd800-0xd807]
Oct  3 11:48:08 vmx kernel: [    0.378545] pci 0000:03:00.0: reg 1c io port: [0xd480-0xd483]
Oct  3 11:48:08 vmx kernel: [    0.378552] pci 0000:03:00.0: reg 20 io port: [0xd400-0xd40f]
Oct  3 11:48:08 vmx kernel: [    0.378559] pci 0000:03:00.0: reg 24 32bit mmio: [0xfeaffc00-0xfeafffff]
Oct  3 11:48:08 vmx kernel: [    0.378593] pci 0000:03:00.0: supports D1
Oct  3 11:48:08 vmx kernel: [    0.378594] pci 0000:03:00.0: PME# supported from D0 D1 D3hot
Oct  3 11:48:08 vmx kernel: [    0.378627] pci 0000:03:00.0: PME# disabled
Oct  3 11:48:08 vmx kernel: [    0.378692] pci 0000:00:1c.4: bridge io port: [0xd000-0xdfff]
Oct  3 11:48:08 vmx kernel: [    0.378695] pci 0000:00:1c.4: bridge 32bit mmio: [0xfea00000-0xfeafffff]
Oct  3 11:48:08 vmx kernel: [    0.378743] pci 0000:02:00.0: reg 10 64bit mmio: [0xfe9c0000-0xfe9fffff]
Oct  3 11:48:08 vmx kernel: [    0.378750] pci 0000:02:00.0: reg 18 io port: [0xcc00-0xcc7f]
Oct  3 11:48:08 vmx kernel: [    0.378800] pci 0000:02:00.0: PME# supported from D3hot D3cold
Oct  3 11:48:08 vmx kernel: [    0.378832] pci 0000:02:00.0: PME# disabled
Oct  3 11:48:08 vmx kernel: [    0.378901] pci 0000:00:1c.5: bridge io port: [0xc000-0xcfff]
Oct  3 11:48:08 vmx kernel: [    0.378904] pci 0000:00:1c.5: bridge 32bit mmio: [0xfe900000-0xfe9fffff]
Oct  3 11:48:08 vmx kernel: [    0.378934] pci 0000:05:00.0: reg 10 32bit mmio: [0xfebff800-0xfebfffff]
Oct  3 11:48:08 vmx kernel: [    0.378973] pci 0000:05:00.0: supports D1 D2
Oct  3 11:48:08 vmx kernel: [    0.379002] pci 0000:05:01.0: reg 10 io port: [0xe800-0xe8ff]
Oct  3 11:48:08 vmx kernel: [    0.379008] pci 0000:05:01.0: reg 14 32bit mmio: [0xfebff400-0xfebff4ff]
Oct  3 11:48:08 vmx kernel: [    0.379030] pci 0000:05:01.0: reg 30 32bit mmio: [0xfebe0000-0xfebeffff]
Oct  3 11:48:08 vmx kernel: [    0.379046] pci 0000:05:01.0: PME# supported from D0
Oct  3 11:48:08 vmx kernel: [    0.379078] pci 0000:05:01.0: PME# disabled
Oct  3 11:48:08 vmx kernel: [    0.379143] pci 0000:00:1e.0: transparent bridge
Oct  3 11:48:08 vmx kernel: [    0.379173] pci 0000:00:1e.0: bridge io port: [0xe000-0xefff]
Oct  3 11:48:08 vmx kernel: [    0.379176] pci 0000:00:1e.0: bridge 32bit mmio: [0xfeb00000-0xfebfffff]
Oct  3 11:48:08 vmx kernel: [    0.379197] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Oct  3 11:48:08 vmx kernel: [    0.379308] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
Oct  3 11:48:08 vmx kernel: [    0.379356] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
Oct  3 11:48:08 vmx kernel: [    0.379444] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
Oct  3 11:48:08 vmx kernel: [    0.380014] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
Oct  3 11:48:08 vmx kernel: [    0.380078] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
Oct  3 11:48:08 vmx kernel: [    0.393581] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
Oct  3 11:48:08 vmx kernel: [    0.393814] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
Oct  3 11:48:08 vmx kernel: [    0.394227] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 *15)
Oct  3 11:48:08 vmx kernel: [    0.394638] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 12 14 15)
Oct  3 11:48:08 vmx kernel: [    0.395039] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
Oct  3 11:48:08 vmx kernel: [    0.395490] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 *14 15)
Oct  3 11:48:08 vmx kernel: [    0.396856] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
Oct  3 11:48:08 vmx kernel: [    0.397257] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 10 11 12 14 15)
Oct  3 11:48:08 vmx kernel: [    0.397606] PCI: Using ACPI for IRQ routing
Oct  3 11:48:08 vmx kernel: [    0.410007] NetLabel: Initializing
Oct  3 11:48:08 vmx kernel: [    0.410038] NetLabel:  domain hash size = 128
Oct  3 11:48:08 vmx kernel: [    0.410069] NetLabel:  protocols = UNLABELED CIPSOv4
Oct  3 11:48:08 vmx kernel: [    0.410119] NetLabel:  unlabeled traffic allowed by default
Oct  3 11:48:08 vmx kernel: [    0.410180] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
Oct  3 11:48:08 vmx kernel: [    0.410327] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
Oct  3 11:48:08 vmx kernel: [    0.430005] pnp: PnP ACPI init
Oct  3 11:48:08 vmx kernel: [    0.430045] ACPI: bus type pnp registered
Oct  3 11:48:08 vmx kernel: [    0.432893] pnp: PnP ACPI: found 14 devices
Oct  3 11:48:08 vmx kernel: [    0.432923] ACPI: ACPI bus type pnp unregistered
Oct  3 11:48:08 vmx kernel: [    0.432961] system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
Oct  3 11:48:08 vmx kernel: [    0.432995] system 00:06: ioport range 0x290-0x29f has been reserved
Oct  3 11:48:08 vmx kernel: [    0.433027] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
Oct  3 11:48:08 vmx kernel: [    0.433058] system 00:07: ioport range 0x800-0x87f has been reserved
Oct  3 11:48:08 vmx kernel: [    0.433088] system 00:07: ioport range 0x500-0x57f could not be reserved
Oct  3 11:48:08 vmx kernel: [    0.433119] system 00:07: iomem range 0xfed08000-0xfed08fff has been reserved
Oct  3 11:48:08 vmx kernel: [    0.433150] system 00:07: iomem range 0xfed1c000-0xfed1ffff has been reserved
Oct  3 11:48:08 vmx kernel: [    0.433180] system 00:07: iomem range 0xfed20000-0xfed3ffff has been reserved
Oct  3 11:48:08 vmx kernel: [    0.433211] system 00:07: iomem range 0xfed50000-0xfed8ffff has been reserved
Oct  3 11:48:08 vmx kernel: [    0.433244] system 00:0a: iomem range 0xffc00000-0xffefffff has been reserved
Oct  3 11:48:08 vmx kernel: [    0.433277] system 00:0b: iomem range 0xfec00000-0xfec00fff could not be reserved
Oct  3 11:48:08 vmx kernel: [    0.433311] system 00:0b: iomem range 0xfee00000-0xfee00fff has been reserved
Oct  3 11:48:08 vmx kernel: [    0.433348] system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
Oct  3 11:48:08 vmx kernel: [    0.433381] system 00:0d: iomem range 0x0-0x9ffff could not be reserved
Oct  3 11:48:08 vmx kernel: [    0.433411] system 00:0d: iomem range 0xc0000-0xcffff has been reserved
Oct  3 11:48:08 vmx kernel: [    0.433442] system 00:0d: iomem range 0xe0000-0xfffff could not be reserved
Oct  3 11:48:08 vmx kernel: [    0.433472] system 00:0d: iomem range 0x100000-0xcfffffff could not be reserved
Oct  3 11:48:08 vmx kernel: [    0.438647] pci 0000:05:01.0: BAR 6: address space collision on of device [0xfebe0000-0xfebeffff]
Oct  3 11:48:08 vmx kernel: [    0.438718] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
Oct  3 11:48:08 vmx kernel: [    0.438749] pci 0000:00:01.0:   IO window: 0xb000-0xbfff
Oct  3 11:48:08 vmx kernel: [    0.438779] pci 0000:00:01.0:   MEM window: 0xfe800000-0xfe8fffff
Oct  3 11:48:08 vmx kernel: [    0.438810] pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
Oct  3 11:48:08 vmx kernel: [    0.438845] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:04
Oct  3 11:48:08 vmx kernel: [    0.438874] pci 0000:00:1c.0:   IO window: disabled
Oct  3 11:48:08 vmx kernel: [    0.438905] pci 0000:00:1c.0:   MEM window: disabled
Oct  3 11:48:08 vmx kernel: [    0.438936] pci 0000:00:1c.0:   PREFETCH window: 0x000000fdf00000-0x000000fdffffff
Oct  3 11:48:08 vmx kernel: [    0.438973] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:03
Oct  3 11:48:08 vmx kernel: [    0.439003] pci 0000:00:1c.4:   IO window: 0xd000-0xdfff
Oct  3 11:48:08 vmx kernel: [    0.439035] pci 0000:00:1c.4:   MEM window: 0xfea00000-0xfeafffff
Oct  3 11:48:08 vmx kernel: [    0.439066] pci 0000:00:1c.4:   PREFETCH window: disabled
Oct  3 11:48:08 vmx kernel: [    0.439097] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:02
Oct  3 11:48:08 vmx kernel: [    0.439127] pci 0000:00:1c.5:   IO window: 0xc000-0xcfff
Oct  3 11:48:08 vmx kernel: [    0.439158] pci 0000:00:1c.5:   MEM window: 0xfe900000-0xfe9fffff
Oct  3 11:48:08 vmx kernel: [    0.439189] pci 0000:00:1c.5:   PREFETCH window: disabled
Oct  3 11:48:08 vmx kernel: [    0.439221] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
Oct  3 11:48:08 vmx kernel: [    0.439251] pci 0000:00:1e.0:   IO window: 0xe000-0xefff
Oct  3 11:48:08 vmx kernel: [    0.439283] pci 0000:00:1e.0:   MEM window: 0xfeb00000-0xfebfffff
Oct  3 11:48:08 vmx kernel: [    0.439314] pci 0000:00:1e.0:   PREFETCH window: 0xf0000000-0xf00fffff
Oct  3 11:48:08 vmx kernel: [    0.439349]   alloc irq_desc for 16 on node 0
Oct  3 11:48:08 vmx kernel: [    0.439351]   alloc kstat_irqs on node 0
Oct  3 11:48:08 vmx kernel: [    0.439355] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct  3 11:48:08 vmx kernel: [    0.439386] pci 0000:00:01.0: setting latency timer to 64
Oct  3 11:48:08 vmx kernel: [    0.439391]   alloc irq_desc for 17 on node 0
Oct  3 11:48:08 vmx kernel: [    0.439392]   alloc kstat_irqs on node 0
Oct  3 11:48:08 vmx kernel: [    0.439394] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Oct  3 11:48:08 vmx kernel: [    0.439425] pci 0000:00:1c.0: setting latency timer to 64
Oct  3 11:48:08 vmx kernel: [    0.439430] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Oct  3 11:48:08 vmx kernel: [    0.439462] pci 0000:00:1c.4: setting latency timer to 64
Oct  3 11:48:08 vmx kernel: [    0.439466] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
Oct  3 11:48:08 vmx kernel: [    0.439498] pci 0000:00:1c.5: setting latency timer to 64
Oct  3 11:48:08 vmx kernel: [    0.439502] pci 0000:00:1e.0: setting latency timer to 64
Oct  3 11:48:08 vmx kernel: [    0.439505] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
Oct  3 11:48:08 vmx kernel: [    0.439507] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
Oct  3 11:48:08 vmx kernel: [    0.439509] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
Oct  3 11:48:08 vmx kernel: [    0.439511] pci_bus 0000:01: resource 1 mem: [0xfe800000-0xfe8fffff]
Oct  3 11:48:08 vmx kernel: [    0.439512] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xdfffffff]
Oct  3 11:48:08 vmx kernel: [    0.439514] pci_bus 0000:04: resource 2 pref mem [0xfdf00000-0xfdffffff]
Oct  3 11:48:08 vmx kernel: [    0.439516] pci_bus 0000:03: resource 0 io:  [0xd000-0xdfff]
Oct  3 11:48:08 vmx kernel: [    0.439518] pci_bus 0000:03: resource 1 mem: [0xfea00000-0xfeafffff]
Oct  3 11:48:08 vmx kernel: [    0.439520] pci_bus 0000:02: resource 0 io:  [0xc000-0xcfff]
Oct  3 11:48:08 vmx kernel: [    0.439521] pci_bus 0000:02: resource 1 mem: [0xfe900000-0xfe9fffff]
Oct  3 11:48:08 vmx kernel: [    0.439523] pci_bus 0000:05: resource 0 io:  [0xe000-0xefff]
Oct  3 11:48:08 vmx kernel: [    0.439525] pci_bus 0000:05: resource 1 mem: [0xfeb00000-0xfebfffff]
Oct  3 11:48:08 vmx kernel: [    0.439526] pci_bus 0000:05: resource 2 pref mem [0xf0000000-0xf00fffff]
Oct  3 11:48:08 vmx kernel: [    0.439528] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
Oct  3 11:48:08 vmx kernel: [    0.439530] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
Oct  3 11:48:08 vmx kernel: [    0.439542] NET: Registered protocol family 2
Oct  3 11:48:08 vmx kernel: [    0.439722] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
Oct  3 11:48:08 vmx kernel: [    0.440685] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
Oct  3 11:48:08 vmx kernel: [    0.443634] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Oct  3 11:48:08 vmx kernel: [    0.444031] TCP: Hash tables configured (established 524288 bind 65536)
Oct  3 11:48:08 vmx kernel: [    0.444062] TCP reno registered
Oct  3 11:48:08 vmx kernel: [    0.444175] NET: Registered protocol family 1
Oct  3 11:48:08 vmx kernel: [    0.444261] Trying to unpack rootfs image as initramfs...
Oct  3 11:48:08 vmx kernel: [    0.444910] rootfs image is not initramfs (no cpio magic); looks like an initrd
Oct  3 11:48:08 vmx kernel: [    0.445777] Freeing initrd memory: 901k freed
Oct  3 11:48:08 vmx kernel: [    0.447456] Scanning for low memory corruption every 60 seconds
Oct  3 11:48:08 vmx kernel: [    0.447798] audit: initializing netlink socket (disabled)
Oct  3 11:48:08 vmx kernel: [    0.447837] type=2000 audit(1254563253.446:1): initialized
Oct  3 11:48:08 vmx kernel: [    0.453247] HugeTLB registered 2 MB page size, pre-allocated 0 pages
Oct  3 11:48:08 vmx kernel: [    0.456148] VFS: Disk quotas dquot_6.5.2
Oct  3 11:48:08 vmx kernel: [    0.456223] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Oct  3 11:48:08 vmx kernel: [    0.456325] ROMFS MTD (C) 2007 Red Hat, Inc.
Oct  3 11:48:08 vmx kernel: [    0.456395] msgmni has been set to 16010
Oct  3 11:48:08 vmx kernel: [    0.456641] alg: No test for stdrng (krng)
Oct  3 11:48:08 vmx kernel: [    0.456749] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
Oct  3 11:48:08 vmx kernel: [    0.456783] io scheduler noop registered
Oct  3 11:48:08 vmx kernel: [    0.456812] io scheduler anticipatory registered
Oct  3 11:48:08 vmx kernel: [    0.456841] io scheduler deadline registered
Oct  3 11:48:08 vmx kernel: [    0.456915] io scheduler cfq registered (default)
Oct  3 11:48:08 vmx kernel: [    0.457075] pci 0000:01:00.0: Boot video device
Oct  3 11:48:08 vmx kernel: [    0.457190]   alloc irq_desc for 24 on node 0
Oct  3 11:48:08 vmx kernel: [    0.457191]   alloc kstat_irqs on node 0
Oct  3 11:48:08 vmx kernel: [    0.457197] pcieport-driver 0000:00:01.0: irq 24 for MSI/MSI-X
Oct  3 11:48:08 vmx kernel: [    0.457202] pcieport-driver 0000:00:01.0: setting latency timer to 64
Oct  3 11:48:08 vmx kernel: [    0.457327]   alloc irq_desc for 25 on node 0
Oct  3 11:48:08 vmx kernel: [    0.457328]   alloc kstat_irqs on node 0
Oct  3 11:48:08 vmx kernel: [    0.457333] pcieport-driver 0000:00:1c.0: irq 25 for MSI/MSI-X
Oct  3 11:48:08 vmx kernel: [    0.457340] pcieport-driver 0000:00:1c.0: setting latency timer to 64
Oct  3 11:48:08 vmx kernel: [    0.457493]   alloc irq_desc for 26 on node 0
Oct  3 11:48:08 vmx kernel: [    0.457494]   alloc kstat_irqs on node 0
Oct  3 11:48:08 vmx kernel: [    0.457499] pcieport-driver 0000:00:1c.4: irq 26 for MSI/MSI-X
Oct  3 11:48:08 vmx kernel: [    0.457506] pcieport-driver 0000:00:1c.4: setting latency timer to 64
Oct  3 11:48:08 vmx kernel: [    0.457655]   alloc irq_desc for 27 on node 0
Oct  3 11:48:08 vmx kernel: [    0.457657]   alloc kstat_irqs on node 0
Oct  3 11:48:08 vmx kernel: [    0.457662] pcieport-driver 0000:00:1c.5: irq 27 for MSI/MSI-X
Oct  3 11:48:08 vmx kernel: [    0.457668] pcieport-driver 0000:00:1c.5: setting latency timer to 64
Oct  3 11:48:08 vmx kernel: [    0.490709] Linux agpgart interface v0.103
Oct  3 11:48:08 vmx kernel: [    0.490795] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Oct  3 11:48:08 vmx kernel: [    0.492860] brd: module loaded
Oct  3 11:48:08 vmx kernel: [    0.492960] input: Macintosh mouse button emulation as /devices/virtual/input/input0
Oct  3 11:48:08 vmx kernel: [    0.493056] Fixed MDIO Bus: probed
Oct  3 11:48:08 vmx kernel: [    0.493186] PNP: No PS/2 controller found. Probing ports directly.
Oct  3 11:48:08 vmx kernel: [    0.496002] serio: i8042 KBD port at 0x60,0x64 irq 1
Oct  3 11:48:08 vmx kernel: [    0.496039] serio: i8042 AUX port at 0x60,0x64 irq 12
Oct  3 11:48:08 vmx kernel: [    0.496326] mice: PS/2 mouse device common for all mice
Oct  3 11:48:08 vmx kernel: [    0.496463] rtc_cmos 00:03: RTC can wake from S4
Oct  3 11:48:08 vmx kernel: [    0.496574] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
Oct  3 11:48:08 vmx kernel: [    0.496624] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
Oct  3 11:48:08 vmx kernel: [    0.496702] cpuidle: using governor ladder
Oct  3 11:48:08 vmx kernel: [    0.496736] cpuidle: using governor menu
Oct  3 11:48:08 vmx kernel: [    0.496830] TCP cubic registered
Oct  3 11:48:08 vmx kernel: [    0.497125] NET: Registered protocol family 10
Oct  3 11:48:08 vmx kernel: [    0.497335] lo: Disabled Privacy Extensions
Oct  3 11:48:08 vmx kernel: [    0.497384] Mobile IPv6
Oct  3 11:48:08 vmx kernel: [    0.497745] NET: Registered protocol family 17
Oct  3 11:48:08 vmx kernel: [    0.498046] registered taskstats version 1
Oct  3 11:48:08 vmx kernel: [    0.498138] No TPM chip found, activating TPM-bypass!
Oct  3 11:48:08 vmx kernel: [    0.498319] rtc_cmos 00:03: setting system clock to 2009-10-03 09:47:33 UTC (1254563253)
Oct  3 11:48:08 vmx kernel: [    0.498383] Initalizing network drop monitor service
Oct  3 11:48:08 vmx kernel: [    0.501802] Switched to high resolution mode on CPU 1
Oct  3 11:48:08 vmx kernel: [    0.501841] Switched to high resolution mode on CPU 3
Oct  3 11:48:08 vmx kernel: [    0.502136] Switched to high resolution mode on CPU 2
Oct  3 11:48:08 vmx kernel: [    0.503446] Switched to high resolution mode on CPU 0
Oct  3 11:48:08 vmx kernel: [    0.538950] RAMDISK: gzip image found at block 0
Oct  3 11:48:08 vmx kernel: [    0.557892] VFS: Mounted root (romfs filesystem) readonly on device 1:0.
Oct  3 11:48:08 vmx kernel: [    0.568785] SCSI subsystem initialized
Oct  3 11:48:08 vmx kernel: [    0.579393] libata version 3.00 loaded.
Oct  3 11:48:08 vmx kernel: [    0.582072] ahci 0000:00:1f.2: version 3.0
Oct  3 11:48:08 vmx kernel: [    0.582085]   alloc irq_desc for 19 on node 0
Oct  3 11:48:08 vmx kernel: [    0.582086]   alloc kstat_irqs on node 0
Oct  3 11:48:08 vmx kernel: [    0.582092] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Oct  3 11:48:08 vmx kernel: [    0.582170]   alloc irq_desc for 28 on node 0
Oct  3 11:48:08 vmx kernel: [    0.582171]   alloc kstat_irqs on node 0
Oct  3 11:48:08 vmx kernel: [    0.582177] ahci 0000:00:1f.2: irq 28 for MSI/MSI-X
Oct  3 11:48:08 vmx kernel: [    0.582207] ahci: SSS flag set, parallel bus scan disabled
Oct  3 11:48:08 vmx kernel: [    0.582263] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
Oct  3 11:48:08 vmx kernel: [    0.582297] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part ems 
Oct  3 11:48:08 vmx kernel: [    0.582333] ahci 0000:00:1f.2: setting latency timer to 64
Oct  3 11:48:08 vmx kernel: [    0.613376] scsi0 : ahci
Oct  3 11:48:08 vmx kernel: [    0.613614] scsi1 : ahci
Oct  3 11:48:08 vmx kernel: [    0.613803] scsi2 : ahci
Oct  3 11:48:08 vmx kernel: [    0.613989] scsi3 : ahci
Oct  3 11:48:08 vmx kernel: [    0.614175] scsi4 : ahci
Oct  3 11:48:08 vmx kernel: [    0.614363] scsi5 : ahci
Oct  3 11:48:08 vmx kernel: [    0.614586] ata1: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7fe900 irq 28
Oct  3 11:48:08 vmx kernel: [    0.614631] ata2: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7fe980 irq 28
Oct  3 11:48:08 vmx kernel: [    0.614665] ata3: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7fea00 irq 28
Oct  3 11:48:08 vmx kernel: [    0.614699] ata4: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7fea80 irq 28
Oct  3 11:48:08 vmx kernel: [    0.614733] ata5: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7feb00 irq 28
Oct  3 11:48:08 vmx kernel: [    0.614767] ata6: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7feb80 irq 28
Oct  3 11:48:08 vmx kernel: [    1.093351] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Oct  3 11:48:08 vmx kernel: [    1.093860] ata1.00: ATA-7: WDC WD1600YD-01NVB1, 10.02E01, max UDMA/133
Oct  3 11:48:08 vmx kernel: [    1.093893] ata1.00: 321672960 sectors, multi 0: LBA48 NCQ (depth 1)
Oct  3 11:48:08 vmx kernel: [    1.094472] ata1.00: configured for UDMA/133
Oct  3 11:48:08 vmx kernel: [    1.106759] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600YD-01N 10.0 PQ: 0 ANSI: 5
Oct  3 11:48:08 vmx kernel: [    1.986684] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Oct  3 11:48:08 vmx kernel: [    1.987176] ata2.00: ATA-7: WDC WD1600YD-01NVB1, 10.02E01, max UDMA/133
Oct  3 11:48:08 vmx kernel: [    1.987209] ata2.00: 321672960 sectors, multi 0: LBA48 NCQ (depth 1)
Oct  3 11:48:08 vmx kernel: [    1.987795] ata2.00: configured for UDMA/133
Oct  3 11:48:08 vmx kernel: [    2.000067] scsi 1:0:0:0: Direct-Access     ATA      WDC WD1600YD-01N 10.0 PQ: 0 ANSI: 5
Oct  3 11:48:08 vmx kernel: [    2.320013] ata3: SATA link down (SStatus 0 SControl 300)
Oct  3 11:48:08 vmx kernel: [    2.653343] ata4: SATA link down (SStatus 0 SControl 300)
Oct  3 11:48:08 vmx kernel: [    2.986677] ata5: SATA link down (SStatus 0 SControl 300)
Oct  3 11:48:08 vmx kernel: [    3.320012] ata6: SATA link down (SStatus 0 SControl 300)
Oct  3 11:48:08 vmx kernel: [    8.336514] JFS: nTxBlock = 8192, nTxLock = 65536
Oct  3 11:48:08 vmx kernel: [    8.351982] md: raid1 personality registered for level 1
Oct  3 11:48:08 vmx kernel: [    8.355099] sd 1:0:0:0: [sdb] 321672960 512-byte logical blocks: (164 GB/153 GiB)
Oct  3 11:48:08 vmx kernel: [    8.355102] sd 0:0:0:0: [sda] 321672960 512-byte logical blocks: (164 GB/153 GiB)
Oct  3 11:48:08 vmx kernel: [    8.355132] sd 0:0:0:0: [sda] Write Protect is off
Oct  3 11:48:08 vmx kernel: [    8.355134] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Oct  3 11:48:08 vmx kernel: [    8.355149] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct  3 11:48:08 vmx kernel: [    8.355251]  sda:
Oct  3 11:48:08 vmx kernel: [    8.355266] sd 1:0:0:0: [sdb] Write Protect is off
Oct  3 11:48:08 vmx kernel: [    8.355268] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Oct  3 11:48:08 vmx kernel: [    8.355283] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct  3 11:48:08 vmx kernel: [    8.355438]  sdb: sdb1 sdb2 sdb3
Oct  3 11:48:08 vmx kernel: [    8.370112] sd 1:0:0:0: [sdb] Attached SCSI disk
Oct  3 11:48:08 vmx kernel: [    8.371303]  sda1 sda2 sda3
Oct  3 11:48:08 vmx kernel: [    8.372246] sd 0:0:0:0: [sda] Attached SCSI disk
Oct  3 11:48:08 vmx kernel: [   13.381180] usbcore: registered new interface driver usbfs
Oct  3 11:48:08 vmx kernel: [   13.381324] usbcore: registered new interface driver hub
Oct  3 11:48:08 vmx kernel: [   13.381435] usbcore: registered new device driver usb
Oct  3 11:48:08 vmx kernel: [   13.383038] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Oct  3 11:48:08 vmx kernel: [   13.383106]   alloc irq_desc for 18 on node 0
Oct  3 11:48:08 vmx kernel: [   13.383107]   alloc kstat_irqs on node 0
Oct  3 11:48:08 vmx kernel: [   13.383113] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Oct  3 11:48:08 vmx kernel: [   13.383182] ehci_hcd 0000:00:1a.7: setting latency timer to 64
Oct  3 11:48:08 vmx kernel: [   13.383185] ehci_hcd 0000:00:1a.7: EHCI Host Controller
Oct  3 11:48:08 vmx kernel: [   13.383234] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
Oct  3 11:48:08 vmx kernel: [   13.387169] ehci_hcd 0000:00:1a.7: debug port 1
Oct  3 11:48:08 vmx kernel: [   13.387201] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
Oct  3 11:48:08 vmx kernel: [   13.387214] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfe7ffc00
Oct  3 11:48:08 vmx kernel: [   13.400005] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
Oct  3 11:48:08 vmx kernel: [   13.400053] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
Oct  3 11:48:08 vmx kernel: [   13.400085] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct  3 11:48:08 vmx kernel: [   13.400125] usb usb1: Product: EHCI Host Controller
Oct  3 11:48:08 vmx kernel: [   13.400155] usb usb1: Manufacturer: Linux 2.6.31-dirty ehci_hcd
Oct  3 11:48:08 vmx kernel: [   13.400184] usb usb1: SerialNumber: 0000:00:1a.7
Oct  3 11:48:08 vmx kernel: [   13.400342] usb usb1: configuration #1 chosen from 1 choice
Oct  3 11:48:08 vmx kernel: [   13.400437] hub 1-0:1.0: USB hub found
Oct  3 11:48:08 vmx kernel: [   13.400470] hub 1-0:1.0: 6 ports detected
Oct  3 11:48:08 vmx kernel: [   13.400643]   alloc irq_desc for 23 on node 0
Oct  3 11:48:08 vmx kernel: [   13.400645]   alloc kstat_irqs on node 0
Oct  3 11:48:08 vmx kernel: [   13.400648] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
Oct  3 11:48:08 vmx kernel: [   13.400685] ehci_hcd 0000:00:1d.7: setting latency timer to 64
Oct  3 11:48:08 vmx kernel: [   13.400687] ehci_hcd 0000:00:1d.7: EHCI Host Controller
Oct  3 11:48:08 vmx kernel: [   13.400722] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
Oct  3 11:48:08 vmx kernel: [   13.404653] ehci_hcd 0000:00:1d.7: debug port 1
Oct  3 11:48:08 vmx kernel: [   13.404685] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
Oct  3 11:48:08 vmx kernel: [   13.404695] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfe7ff800
Oct  3 11:48:08 vmx kernel: [   13.416671] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
Oct  3 11:48:08 vmx kernel: [   13.416715] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
Oct  3 11:48:08 vmx kernel: [   13.416747] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct  3 11:48:08 vmx kernel: [   13.416792] usb usb2: Product: EHCI Host Controller
Oct  3 11:48:08 vmx kernel: [   13.416825] usb usb2: Manufacturer: Linux 2.6.31-dirty ehci_hcd
Oct  3 11:48:08 vmx kernel: [   13.416854] usb usb2: SerialNumber: 0000:00:1d.7
Oct  3 11:48:08 vmx kernel: [   13.416961] usb usb2: configuration #1 chosen from 1 choice
Oct  3 11:48:08 vmx kernel: [   13.417058] hub 2-0:1.0: USB hub found
Oct  3 11:48:08 vmx kernel: [   13.417094] hub 2-0:1.0: 6 ports detected
Oct  3 11:48:08 vmx kernel: [   13.418569] uhci_hcd: USB Universal Host Controller Interface driver
Oct  3 11:48:08 vmx kernel: [   13.418732] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct  3 11:48:08 vmx kernel: [   13.418767] uhci_hcd 0000:00:1a.0: setting latency timer to 64
Oct  3 11:48:08 vmx kernel: [   13.418769] uhci_hcd 0000:00:1a.0: UHCI Host Controller
Oct  3 11:48:08 vmx kernel: [   13.418807] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
Oct  3 11:48:08 vmx kernel: [   13.418865] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000a800
Oct  3 11:48:08 vmx kernel: [   13.418919] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
Oct  3 11:48:08 vmx kernel: [   13.418950] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct  3 11:48:08 vmx kernel: [   13.418983] usb usb3: Product: UHCI Host Controller
Oct  3 11:48:08 vmx kernel: [   13.419012] usb usb3: Manufacturer: Linux 2.6.31-dirty uhci_hcd
Oct  3 11:48:08 vmx kernel: [   13.419042] usb usb3: SerialNumber: 0000:00:1a.0
Oct  3 11:48:08 vmx kernel: [   13.419158] usb usb3: configuration #1 chosen from 1 choice
Oct  3 11:48:08 vmx kernel: [   13.419253] hub 3-0:1.0: USB hub found
Oct  3 11:48:08 vmx kernel: [   13.419285] hub 3-0:1.0: 2 ports detected
Oct  3 11:48:08 vmx kernel: [   13.419446]   alloc irq_desc for 21 on node 0
Oct  3 11:48:08 vmx kernel: [   13.419448]   alloc kstat_irqs on node 0
Oct  3 11:48:08 vmx kernel: [   13.419451] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
Oct  3 11:48:08 vmx kernel: [   13.419484] uhci_hcd 0000:00:1a.1: setting latency timer to 64
Oct  3 11:48:08 vmx kernel: [   13.419486] uhci_hcd 0000:00:1a.1: UHCI Host Controller
Oct  3 11:48:08 vmx kernel: [   13.419522] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
Oct  3 11:48:08 vmx kernel: [   13.419578] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000a880
Oct  3 11:48:08 vmx kernel: [   13.419630] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
Oct  3 11:48:08 vmx kernel: [   13.419661] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct  3 11:48:08 vmx kernel: [   13.419694] usb usb4: Product: UHCI Host Controller
Oct  3 11:48:08 vmx kernel: [   13.419723] usb usb4: Manufacturer: Linux 2.6.31-dirty uhci_hcd
Oct  3 11:48:08 vmx kernel: [   13.419753] usb usb4: SerialNumber: 0000:00:1a.1
Oct  3 11:48:08 vmx kernel: [   13.419864] usb usb4: configuration #1 chosen from 1 choice
Oct  3 11:48:08 vmx kernel: [   13.419955] hub 4-0:1.0: USB hub found
Oct  3 11:48:08 vmx kernel: [   13.419987] hub 4-0:1.0: 2 ports detected
Oct  3 11:48:08 vmx kernel: [   13.420154] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Oct  3 11:48:08 vmx kernel: [   13.420187] uhci_hcd 0000:00:1a.2: setting latency timer to 64
Oct  3 11:48:08 vmx kernel: [   13.420189] uhci_hcd 0000:00:1a.2: UHCI Host Controller
Oct  3 11:48:08 vmx kernel: [   13.420224] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
Oct  3 11:48:08 vmx kernel: [   13.420275] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000ac00
Oct  3 11:48:08 vmx kernel: [   13.420328] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
Oct  3 11:48:08 vmx kernel: [   13.420359] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct  3 11:48:08 vmx kernel: [   13.420392] usb usb5: Product: UHCI Host Controller
Oct  3 11:48:08 vmx kernel: [   13.420422] usb usb5: Manufacturer: Linux 2.6.31-dirty uhci_hcd
Oct  3 11:48:08 vmx kernel: [   13.420451] usb usb5: SerialNumber: 0000:00:1a.2
Oct  3 11:48:08 vmx kernel: [   13.420567] usb usb5: configuration #1 chosen from 1 choice
Oct  3 11:48:08 vmx kernel: [   13.420660] hub 5-0:1.0: USB hub found
Oct  3 11:48:08 vmx kernel: [   13.420692] hub 5-0:1.0: 2 ports detected
Oct  3 11:48:08 vmx kernel: [   13.420853] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
Oct  3 11:48:08 vmx kernel: [   13.420886] uhci_hcd 0000:00:1d.0: setting latency timer to 64
Oct  3 11:48:08 vmx kernel: [   13.420888] uhci_hcd 0000:00:1d.0: UHCI Host Controller
Oct  3 11:48:08 vmx kernel: [   13.420923] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
Oct  3 11:48:08 vmx kernel: [   13.420974] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000a080
Oct  3 11:48:08 vmx kernel: [   13.421026] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
Oct  3 11:48:08 vmx kernel: [   13.421056] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct  3 11:48:08 vmx kernel: [   13.421089] usb usb6: Product: UHCI Host Controller
Oct  3 11:48:08 vmx kernel: [   13.421118] usb usb6: Manufacturer: Linux 2.6.31-dirty uhci_hcd
Oct  3 11:48:08 vmx kernel: [   13.421148] usb usb6: SerialNumber: 0000:00:1d.0
Oct  3 11:48:08 vmx kernel: [   13.421255] usb usb6: configuration #1 chosen from 1 choice
Oct  3 11:48:08 vmx kernel: [   13.421328] hub 6-0:1.0: USB hub found
Oct  3 11:48:08 vmx kernel: [   13.421361] hub 6-0:1.0: 2 ports detected
Oct  3 11:48:08 vmx kernel: [   13.421500] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Oct  3 11:48:08 vmx kernel: [   13.421533] uhci_hcd 0000:00:1d.1: setting latency timer to 64
Oct  3 11:48:08 vmx kernel: [   13.421535] uhci_hcd 0000:00:1d.1: UHCI Host Controller
Oct  3 11:48:08 vmx kernel: [   13.421570] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
Oct  3 11:48:08 vmx kernel: [   13.421626] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000a400
Oct  3 11:48:08 vmx kernel: [   13.421679] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
Oct  3 11:48:08 vmx kernel: [   13.421710] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct  3 11:48:08 vmx kernel: [   13.421743] usb usb7: Product: UHCI Host Controller
Oct  3 11:48:08 vmx kernel: [   13.421772] usb usb7: Manufacturer: Linux 2.6.31-dirty uhci_hcd
Oct  3 11:48:08 vmx kernel: [   13.421802] usb usb7: SerialNumber: 0000:00:1d.1
Oct  3 11:48:08 vmx kernel: [   13.421886] usb usb7: configuration #1 chosen from 1 choice
Oct  3 11:48:08 vmx kernel: [   13.421954] hub 7-0:1.0: USB hub found
Oct  3 11:48:08 vmx kernel: [   13.421986] hub 7-0:1.0: 2 ports detected
Oct  3 11:48:08 vmx kernel: [   13.422115] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Oct  3 11:48:08 vmx kernel: [   13.422148] uhci_hcd 0000:00:1d.2: setting latency timer to 64
Oct  3 11:48:08 vmx kernel: [   13.422150] uhci_hcd 0000:00:1d.2: UHCI Host Controller
Oct  3 11:48:08 vmx kernel: [   13.422185] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
Oct  3 11:48:08 vmx kernel: [   13.422236] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000a480
Oct  3 11:48:08 vmx kernel: [   13.422288] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
Oct  3 11:48:08 vmx kernel: [   13.422318] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct  3 11:48:08 vmx kernel: [   13.422683] usb usb8: Product: UHCI Host Controller
Oct  3 11:48:08 vmx kernel: [   13.422712] usb usb8: Manufacturer: Linux 2.6.31-dirty uhci_hcd
Oct  3 11:48:08 vmx kernel: [   13.422742] usb usb8: SerialNumber: 0000:00:1d.2
Oct  3 11:48:08 vmx kernel: [   13.422830] usb usb8: configuration #1 chosen from 1 choice
Oct  3 11:48:08 vmx kernel: [   13.422896] hub 8-0:1.0: USB hub found
Oct  3 11:48:08 vmx kernel: [   13.422931] hub 8-0:1.0: 2 ports detected
Oct  3 11:48:08 vmx kernel: [   13.433250] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
Oct  3 11:48:08 vmx kernel: [   13.438324] usbcore: registered new interface driver hiddev
Oct  3 11:48:08 vmx kernel: [   13.438410] usbcore: registered new interface driver usbhid
Oct  3 11:48:08 vmx kernel: [   13.438445] usbhid: v2.6:USB HID core driver
Oct  3 11:48:08 vmx kernel: [   13.439629] md: md0 stopped.
Oct  3 11:48:08 vmx kernel: [   13.560230] md: bind<sda2>
Oct  3 11:48:08 vmx kernel: [   13.560376] md: bind<sdb2>
Oct  3 11:48:08 vmx kernel: [   13.560538] raid1: raid set md0 active with 2 out of 2 mirrors
Oct  3 11:48:08 vmx kernel: [   13.560603] md0: detected capacity change from 0 to 12000559104
Oct  3 11:48:08 vmx kernel: [   13.562186]  md0: unknown partition table
Oct  3 11:48:08 vmx kernel: [   13.650068] VFS: Mounted root (jfs filesystem) readonly on device 9:0.
Oct  3 11:48:08 vmx kernel: [   13.650102] Trying to move old root to /initrd ... okay
Oct  3 11:48:08 vmx kernel: [   13.678009] Freeing unused kernel memory: 512k freed
Oct  3 11:48:08 vmx kernel: [   13.678167] Write protecting the kernel read-only data: 4944k
Oct  3 11:48:08 vmx kernel: [   13.950425] usb 6-1: new low speed USB device using uhci_hcd and address 2
Oct  3 11:48:08 vmx kernel: [   14.174032] usb 6-1: New USB device found, idVendor=046d, idProduct=c051
Oct  3 11:48:08 vmx kernel: [   14.174067] usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Oct  3 11:48:08 vmx kernel: [   14.174099] usb 6-1: Product: USB-PS/2 Optical Mouse
Oct  3 11:48:08 vmx kernel: [   14.174135] usb 6-1: Manufacturer: Logitech
Oct  3 11:48:08 vmx kernel: [   14.174340] usb 6-1: configuration #1 chosen from 1 choice
Oct  3 11:48:08 vmx kernel: [   14.193345] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb6/6-1/6-1:1.0/input/input1
Oct  3 11:48:08 vmx kernel: [   14.193565] generic-usb 0003:046D:C051.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1/input0
Oct  3 11:48:08 vmx kernel: [   14.417925] usb 6-2: new low speed USB device using uhci_hcd and address 3
Oct  3 11:48:08 vmx kernel: [   14.594026] usb 6-2: New USB device found, idVendor=045e, idProduct=00db
Oct  3 11:48:08 vmx kernel: [   14.594060] usb 6-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Oct  3 11:48:08 vmx kernel: [   14.594092] usb 6-2: Product: Natural® Ergonomic Keyboard 4000
Oct  3 11:48:08 vmx kernel: [   14.594123] usb 6-2: Manufacturer: Microsoft
Oct  3 11:48:08 vmx kernel: [   14.594302] usb 6-2: configuration #1 chosen from 1 choice
Oct  3 11:48:08 vmx kernel: [   14.611339] input: Microsoft Natural® Ergonomic Keyboard 4000 as /devices/pci0000:00/0000:00:1d.0/usb6/6-2/6-2:1.0/input/input2
Oct  3 11:48:08 vmx kernel: [   14.611500] microsoft 0003:045E:00DB.0002: input,hidraw1: USB HID v1.11 Keyboard [Microsoft Natural® Ergonomic Keyboard 4000] on usb-0000:00:1d.0-2/input0
Oct  3 11:48:08 vmx kernel: [   14.634185] input: Microsoft Natural® Ergonomic Keyboard 4000 as /devices/pci0000:00/0000:00:1d.0/usb6/6-2/6-2:1.1/input/input3
Oct  3 11:48:08 vmx kernel: [   14.634298] microsoft 0003:045E:00DB.0003: input,hidraw2: USB HID v1.11 Device [Microsoft Natural® Ergonomic Keyboard 4000] on usb-0000:00:1d.0-2/input1
Oct  3 11:48:08 vmx kernel: [   16.333784] ACPI: SSDT 00000000cff7e0d0 001F3 (v01 DpgPmm  P001Ist 00000011 INTL 20060113)
Oct  3 11:48:08 vmx kernel: [   16.334248] processor LNXCPU:00: registered as cooling_device0
Oct  3 11:48:08 vmx kernel: [   16.334306] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
Oct  3 11:48:08 vmx kernel: [   16.334313] ACPI: Power Button [PWRF]
Oct  3 11:48:08 vmx kernel: [   16.334378] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input5
Oct  3 11:48:08 vmx kernel: [   16.334381] ACPI: Power Button [PWRB]
Oct  3 11:48:08 vmx kernel: [   16.334937] ACPI: SSDT 00000000cff7e2d0 001F3 (v01 DpgPmm  P002Ist 00000012 INTL 20060113)
Oct  3 11:48:08 vmx kernel: [   16.335382] processor LNXCPU:01: registered as cooling_device1
Oct  3 11:48:08 vmx kernel: [   16.335738] ACPI: SSDT 00000000cff7e4d0 001F3 (v01 DpgPmm  P003Ist 00000012 INTL 20060113)
Oct  3 11:48:08 vmx kernel: [   16.336180] processor LNXCPU:02: registered as cooling_device2
Oct  3 11:48:08 vmx kernel: [   16.336539] ACPI: SSDT 00000000cff7e6d0 001F3 (v01 DpgPmm  P004Ist 00000012 INTL 20060113)
Oct  3 11:48:08 vmx kernel: [   16.336979] processor LNXCPU:03: registered as cooling_device3
Oct  3 11:48:08 vmx kernel: [   16.376031] ATL1E 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Oct  3 11:48:08 vmx kernel: [   16.376042] ATL1E 0000:02:00.0: setting latency timer to 64
Oct  3 11:48:08 vmx kernel: [   16.405172] iTCO_vendor_support: vendor-support=0
Oct  3 11:48:08 vmx kernel: [   16.417357] sd 0:0:0:0: Attached scsi generic sg0 type 0
Oct  3 11:48:08 vmx kernel: [   16.417393] sd 1:0:0:0: Attached scsi generic sg1 type 0
Oct  3 11:48:08 vmx kernel: [   16.432225] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
Oct  3 11:48:08 vmx kernel: [   16.432315] iTCO_wdt: Found a ICH10R TCO device (Version=2, TCOBASE=0x0860)
Oct  3 11:48:08 vmx kernel: [   16.432377] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
Oct  3 11:48:08 vmx kernel: [   16.506760] via-rhine.c:v1.10-LK1.4.3 2007-03-06 Written by Donald Becker
Oct  3 11:48:08 vmx kernel: [   16.506931] via-rhine 0000:05:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Oct  3 11:48:08 vmx kernel: [   16.511116] eth1: VIA Rhine II at 0xfebff400, 00:05:5d:e1:f9:45, IRQ 17.
Oct  3 11:48:08 vmx kernel: [   16.511825] eth1: MII PHY found at address 8, status 0x7809 advertising 01e1 Link 0000.
Oct  3 11:48:08 vmx kernel: [   16.571263] Uniform Multi-Platform E-IDE driver
Oct  3 11:48:08 vmx kernel: [   16.571579] input: PC Speaker as /devices/platform/pcspkr/input/input6
Oct  3 11:48:08 vmx kernel: [   16.695608] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Oct  3 11:48:08 vmx kernel: [   16.695618] ACPI: I/O resource 0000:00:1f.3 [0x400-0x41f] conflicts with ACPI region SMRG [0x400-0x40f]
Oct  3 11:48:08 vmx kernel: [   16.695619] ACPI: Device needs an ACPI driver
Oct  3 11:48:08 vmx kernel: [   16.695640] i801_smbus: probe of 0000:00:1f.3 failed with error -16
Oct  3 11:48:08 vmx kernel: [   16.855556] Linux video capture interface: v2.00
Oct  3 11:48:08 vmx kernel: [   16.885745] saa7130/34: v4l2 driver version 0.2.15 loaded
Oct  3 11:48:08 vmx kernel: [   16.885841] saa7134 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct  3 11:48:08 vmx kernel: [   16.885847] saa7133[0]: found at 0000:05:00.0, rev: 209, irq: 16, latency: 64, mmio: 0xfebff800
Oct  3 11:48:08 vmx kernel: [   16.885851] saa7133[0]: subsystem: 11bd:002e, board: Pinnacle PCTV 40i/50i/110i (saa7133) [card=77,autodetected]
Oct  3 11:48:08 vmx kernel: [   16.885895] saa7133[0]: board init: gpio is 200c000
Oct  3 11:48:08 vmx kernel: [   16.885899] IRQ 16/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
Oct  3 11:48:08 vmx kernel: [   16.897650]   alloc irq_desc for 22 on node 0
Oct  3 11:48:08 vmx kernel: [   16.897652]   alloc kstat_irqs on node 0
Oct  3 11:48:08 vmx kernel: [   16.897657] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
Oct  3 11:48:08 vmx kernel: [   16.897694] HDA Intel 0000:00:1b.0: setting latency timer to 64
Oct  3 11:48:08 vmx kernel: [   16.952013] pata_marvell 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct  3 11:48:08 vmx kernel: [   16.952041] pata_marvell 0000:03:00.0: setting latency timer to 64
Oct  3 11:48:08 vmx kernel: [   16.952103] scsi6 : pata_marvell
Oct  3 11:48:08 vmx kernel: [   16.952241] scsi7 : pata_marvell
Oct  3 11:48:08 vmx kernel: [   16.952316] ata7: PATA max UDMA/100 cmd 0xdc00 ctl 0xd880 bmdma 0xd400 irq 16
Oct  3 11:48:08 vmx kernel: [   16.952318] ata8: PATA max UDMA/133 cmd 0xd800 ctl 0xd480 bmdma 0xd408 irq 16
Oct  3 11:48:08 vmx kernel: [   17.040004] saa7133[0]: i2c eeprom 00: bd 11 2e 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
Oct  3 11:48:08 vmx kernel: [   17.040013] saa7133[0]: i2c eeprom 10: ff e0 60 02 ff 20 ff ff ff ff ff ff ff ff ff ff
Oct  3 11:48:08 vmx kernel: [   17.040020] saa7133[0]: i2c eeprom 20: 01 2c 01 23 23 01 04 30 98 ff 00 e2 ff 22 00 c2
Oct  3 11:48:08 vmx kernel: [   17.040028] saa7133[0]: i2c eeprom 30: 96 ff 03 30 15 01 ff 15 13 25 53 89 01 45 32 7b
Oct  3 11:48:08 vmx kernel: [   17.040035] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Oct  3 11:48:08 vmx kernel: [   17.040042] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Oct  3 11:48:08 vmx kernel: [   17.040049] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Oct  3 11:48:08 vmx kernel: [   17.040056] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Oct  3 11:48:08 vmx kernel: [   17.040063] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Oct  3 11:48:08 vmx kernel: [   17.040070] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Oct  3 11:48:08 vmx kernel: [   17.040077] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Oct  3 11:48:08 vmx kernel: [   17.040084] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Oct  3 11:48:08 vmx kernel: [   17.040091] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Oct  3 11:48:08 vmx kernel: [   17.040098] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Oct  3 11:48:08 vmx kernel: [   17.040105] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Oct  3 11:48:08 vmx kernel: [   17.040117] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Oct  3 11:48:08 vmx kernel: [   17.040124] i2c-adapter i2c-0: Invalid 7-bit address 0x7a
Oct  3 11:48:08 vmx kernel: [   17.111603] ata7.00: ATAPI: ASUS    DRW-1814BL, 1.10, max UDMA/66
Oct  3 11:48:08 vmx kernel: [   17.124938] ata7.00: configured for UDMA/66
Oct  3 11:48:08 vmx kernel: [   17.126879] scsi 6:0:0:0: CD-ROM            ASUS     DRW-1814BL       1.10 PQ: 0 ANSI: 5
Oct  3 11:48:08 vmx kernel: [   17.127035] scsi 6:0:0:0: Attached scsi generic sg2 type 5
Oct  3 11:48:08 vmx kernel: [   17.288324] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input7
Oct  3 11:48:08 vmx kernel: [   17.352662] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
Oct  3 11:48:08 vmx kernel: [   17.352666] Uniform CD-ROM driver Revision: 3.20
Oct  3 11:48:08 vmx kernel: [   17.352832] sr 6:0:0:0: Attached scsi CD-ROM sr0
Oct  3 11:48:08 vmx kernel: [   17.376726] tuner 0-004b: chip found @ 0x96 (saa7133[0])
Oct  3 11:48:08 vmx kernel: [   17.443338] tda829x 0-004b: setting tuner address to 61
Oct  3 11:48:08 vmx kernel: [   17.520007] tda829x 0-004b: type set to tda8290+75a
Oct  3 11:48:08 vmx kernel: [   21.215056] ir_probe: addr=0x47
Oct  3 11:48:08 vmx kernel: [   21.215058] ir_probe: [before override] ir_codes=(null), name=SAA713x remote, get_key=(null)
Oct  3 11:48:08 vmx kernel: [   21.215061] ir_probe: [after  override] ir_codes=ffffffffa02ce1e0, name=Pinnacle PCTV, get_key=ffffffffa02df4c0
Oct  3 11:48:08 vmx kernel: [   21.215064] ir_input_init: dev=ffff880221cca000, ir=ffff880224e19018, ir_type=99, ir_codes=ffffffffa02ce1e0
Oct  3 11:48:08 vmx kernel: [   21.215066] ir_input_init: [i=0] Setting bit 401 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215068] ir_input_init: [i=1] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215069] ir_input_init: [i=2] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215071] ir_input_init: [i=3] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215072] ir_input_init: [i=4] Setting bit 399 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215073] ir_input_init: [i=5] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215075] ir_input_init: [i=6] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215076] ir_input_init: [i=7] Setting bit 173 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215078] ir_input_init: [i=8] Setting bit 158 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215079] ir_input_init: [i=9] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215081] ir_input_init: [i=10] Setting bit 14 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215082] ir_input_init: [i=11] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215084] ir_input_init: [i=12] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215085] ir_input_init: [i=13] Setting bit 353 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215086] ir_input_init: [i=14] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215088] ir_input_init: [i=15] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215089] ir_input_init: [i=16] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215091] ir_input_init: [i=17] Setting bit 400 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215092] ir_input_init: [i=18] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215094] ir_input_init: [i=19] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215095] ir_input_init: [i=20] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215096] ir_input_init: [i=21] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215098] ir_input_init: [i=22] Setting bit 402 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215099] ir_input_init: [i=23] Setting bit 403 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215101] ir_input_init: [i=24] Setting bit 388 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215102] ir_input_init: [i=25] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215104] ir_input_init: [i=26] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215105] ir_input_init: [i=27] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215106] ir_input_init: [i=28] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215108] ir_input_init: [i=29] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215109] ir_input_init: [i=30] Setting bit 114 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215110] ir_input_init: [i=31] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215112] ir_input_init: [i=32] Setting bit 103 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215113] ir_input_init: [i=33] Setting bit 108 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215115] ir_input_init: [i=34] Setting bit 105 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215116] ir_input_init: [i=35] Setting bit 106 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215118] ir_input_init: [i=36] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215119] ir_input_init: [i=37] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215120] ir_input_init: [i=38] Setting bit 377 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215122] ir_input_init: [i=39] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215123] ir_input_init: [i=40] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215124] ir_input_init: [i=41] Setting bit 167 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215126] ir_input_init: [i=42] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215127] ir_input_init: [i=43] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215129] ir_input_init: [i=44] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215130] ir_input_init: [i=45] Setting bit 115 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215132] ir_input_init: [i=46] Setting bit 207 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215133] ir_input_init: [i=47] Setting bit 372 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215134] ir_input_init: [i=48] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215136] ir_input_init: [i=49] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215137] ir_input_init: [i=50] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215139] ir_input_init: [i=51] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215140] ir_input_init: [i=52] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215141] ir_input_init: [i=53] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215143] ir_input_init: [i=54] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215144] ir_input_init: [i=55] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215145] ir_input_init: [i=56] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215147] ir_input_init: [i=57] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215148] ir_input_init: [i=58] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215150] ir_input_init: [i=59] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215151] ir_input_init: [i=60] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215152] ir_input_init: [i=61] Setting bit 210 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215154] ir_input_init: [i=62] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215155] ir_input_init: [i=63] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215157] ir_input_init: [i=64] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215158] ir_input_init: [i=65] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215159] ir_input_init: [i=66] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215161] ir_input_init: [i=67] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215162] ir_input_init: [i=68] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215164] ir_input_init: [i=69] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215165] ir_input_init: [i=70] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215166] ir_input_init: [i=71] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215168] ir_input_init: [i=72] Setting bit 398 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215169] ir_input_init: [i=73] Setting bit 139 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215171] ir_input_init: [i=74] Setting bit 116 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215172] ir_input_init: [i=75] Setting bit 119 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215173] ir_input_init: [i=76] Setting bit 128 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215175] ir_input_init: [i=77] Setting bit 168 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215176] ir_input_init: [i=78] Setting bit 159 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215178] ir_input_init: [i=79] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215179] ir_input_init: [i=80] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215180] ir_input_init: [i=81] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215182] ir_input_init: [i=82] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215183] ir_input_init: [i=83] Setting bit 412 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215185] ir_input_init: [i=84] Setting bit 407 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215186] ir_input_init: [i=85] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215187] ir_input_init: [i=86] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215189] ir_input_init: [i=87] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215190] ir_input_init: [i=88] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215192] ir_input_init: [i=89] Setting bit 113 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215193] ir_input_init: [i=90] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215194] ir_input_init: [i=91] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215196] ir_input_init: [i=92] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215197] ir_input_init: [i=93] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215198] ir_input_init: [i=94] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215200] ir_input_init: [i=95] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215201] ir_input_init: [i=96] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215203] ir_input_init: [i=97] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215204] ir_input_init: [i=98] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215205] ir_input_init: [i=99] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215207] ir_input_init: [i=100] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215208] ir_input_init: [i=101] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215209] ir_input_init: [i=102] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215211] ir_input_init: [i=103] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215212] ir_input_init: [i=104] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215214] ir_input_init: [i=105] Setting bit 11 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215215] ir_input_init: [i=106] Setting bit 2 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215216] ir_input_init: [i=107] Setting bit 3 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215218] ir_input_init: [i=108] Setting bit 4 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215219] ir_input_init: [i=109] Setting bit 5 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215220] ir_input_init: [i=110] Setting bit 6 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215222] ir_input_init: [i=111] Setting bit 7 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215223] ir_input_init: [i=112] Setting bit 8 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215225] ir_input_init: [i=113] Setting bit 9 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215226] ir_input_init: [i=114] Setting bit 10 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215227] ir_input_init: [i=115] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215229] ir_input_init: [i=116] Setting bit 363 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215230] ir_input_init: [i=117] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215232] ir_input_init: [i=118] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215233] ir_input_init: [i=119] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215234] ir_input_init: [i=120] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215236] ir_input_init: [i=121] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215237] ir_input_init: [i=122] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215239] ir_input_init: [i=123] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215240] ir_input_init: [i=124] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215241] ir_input_init: [i=125] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215243] ir_input_init: [i=126] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215244] ir_input_init: [i=127] Setting bit 0 of dev->keybit
Oct  3 11:48:08 vmx kernel: [   21.215312] input: i2c IR (Pinnacle PCTV) as /devices/virtual/input/input8
Oct  3 11:48:08 vmx kernel: [   21.215412] ir-kbd-i2c: i2c IR (Pinnacle PCTV) detected at i2c-0/0-0047/ir0 [saa7133[0]]
Oct  3 11:48:08 vmx kernel: [   21.276757] saa7133[0]: registered device video0 [v4l2]
Oct  3 11:48:08 vmx kernel: [   21.276791] saa7133[0]: registered device vbi0
Oct  3 11:48:08 vmx kernel: [   21.276814] saa7133[0]: registered device radio0
Oct  3 11:48:08 vmx kernel: [   21.322564] saa7134 ALSA driver for DMA sound loaded
Oct  3 11:48:08 vmx kernel: [   21.322574] IRQ 16/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
Oct  3 11:48:08 vmx kernel: [   21.322592] saa7133[0]/alsa: saa7133[0] at 0xfebff800 irq 16 registered as card 1
Oct  3 11:48:08 vmx kernel: [   22.233338] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:48:08 vmx kernel: [   22.344170] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:48:08 vmx kernel: [   22.740840] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:08 vmx kernel: [   22.854171] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:08 vmx kernel: [   23.704181] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:48:08 vmx kernel: [   23.721277] Adding 6000236k swap on /dev/sda1.  Priority:0 extents:1 across:6000236k 
Oct  3 11:48:08 vmx kernel: [   23.723735] Adding 6000236k swap on /dev/sdb1.  Priority:0 extents:1 across:6000236k 
Oct  3 11:48:08 vmx kernel: [   23.810837] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:48:08 vmx kernel: [   24.137512] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:08 vmx kernel: [   24.240004] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:08 vmx kernel: [   24.936398] device-mapper: uevent: version 1.0.3
Oct  3 11:48:08 vmx kernel: [   24.936640] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
Oct  3 11:48:08 vmx kernel: [   25.249830] md: md1 stopped.
Oct  3 11:48:08 vmx kernel: [   25.250934] md: bind<sdb3>
Oct  3 11:48:08 vmx kernel: [   25.251055] md: bind<sda3>
Oct  3 11:48:08 vmx kernel: [   25.272556] md: raid10 personality registered for level 10
Oct  3 11:48:08 vmx kernel: [   25.272990] raid10: raid set md1 active with 2 out of 2 devices
Oct  3 11:48:08 vmx kernel: [   25.273022] md1: detected capacity change from 0 to 146549637120
Oct  3 11:48:08 vmx kernel: [   25.384152]  md1: unknown partition table
Oct  3 11:48:08 vmx kernel: [   26.801190] ip6_tables: (C) 2000-2006 Netfilter Core Team
Oct  3 11:48:08 vmx kernel: [   26.888977] ip_tables: (C) 2000-2006 Netfilter Core Team
Oct  3 11:48:08 vmx kernel: [   26.904750] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
Oct  3 11:48:08 vmx kernel: [   26.904954] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
Oct  3 11:48:08 vmx kernel: [   26.904956] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
Oct  3 11:48:08 vmx kernel: [   26.904957] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
Oct  3 11:48:08 vmx kernel: [   26.917504] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:08 vmx kernel: [   27.024172] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:08 vmx kernel: [   27.713342]   alloc irq_desc for 29 on node 0
Oct  3 11:48:08 vmx kernel: [   27.713345]   alloc kstat_irqs on node 0
Oct  3 11:48:08 vmx kernel: [   27.713357] ATL1E 0000:02:00.0: irq 29 for MSI/MSI-X
Oct  3 11:48:08 vmx kernel: [   27.713479] ATL1E 0000:02:00.0: ATL1E: eth0 NIC Link is Up<100 Mbps Full Duplex>
Oct  3 11:48:08 vmx kernel: [   27.884171] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:48:08 vmx kernel: [   27.990003] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:48:08 vmx kernel: [   28.310003] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:08 vmx kernel: [   28.417505] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:08 vmx kernel: [   29.274170] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:48:08 vmx kernel: [   29.376668] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:48:08 vmx kernel: [   29.696668] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:08 vmx kernel: [   29.803334] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:08 vmx kernel: [   32.470004] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:08 vmx kernel: [   32.576668] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:08 vmx kernel: [   32.703515] ATL1E 0000:02:00.0: ATL1E: eth0 NIC Link is Up<100 Mbps Full Duplex>
Oct  3 11:48:08 vmx kernel: [   32.705074] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
Oct  3 11:48:08 vmx kernel: [   32.817684] eth1: link down
Oct  3 11:48:08 vmx kernel: [   32.818534] ADDRCONF(NETDEV_UP): eth1: link is not ready
Oct  3 11:48:08 vmx kernel: [   33.433339] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:48:08 vmx kernel: [   33.540840] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:48:08 vmx kernel: [   33.860837] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:08 vmx kernel: [   33.967506] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:08 vmx kernel: [   34.251636] Bluetooth: Core ver 2.15
Oct  3 11:48:08 vmx kernel: [   34.251696] NET: Registered protocol family 31
Oct  3 11:48:08 vmx kernel: [   34.251698] Bluetooth: HCI device and connection manager initialized
Oct  3 11:48:08 vmx kernel: [   34.251700] Bluetooth: HCI socket layer initialized
Oct  3 11:48:08 vmx kernel: [   34.254994] Bluetooth: L2CAP ver 2.13
Oct  3 11:48:08 vmx kernel: [   34.254996] Bluetooth: L2CAP socket layer initialized
Oct  3 11:48:08 vmx kernel: [   34.257942] Bluetooth: RFCOMM TTY layer initialized
Oct  3 11:48:08 vmx kernel: [   34.257946] Bluetooth: RFCOMM socket layer initialized
Oct  3 11:48:08 vmx kernel: [   34.257948] Bluetooth: RFCOMM ver 1.11
Oct  3 11:48:08 vmx kernel: [   34.739935] coretemp coretemp.0: Using relative temperature scale!
Oct  3 11:48:08 vmx kernel: [   34.740049] coretemp coretemp.1: Using relative temperature scale!
Oct  3 11:48:08 vmx kernel: [   34.740292] coretemp coretemp.2: Using relative temperature scale!
Oct  3 11:48:08 vmx kernel: [   34.740372] coretemp coretemp.3: Using relative temperature scale!
Oct  3 11:48:08 vmx kernel: [   34.820004] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:48:08 vmx kernel: [   34.926671] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:48:08 vmx kernel: [   35.246671] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:08 vmx kernel: [   35.354172] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:09 vmx kernel: [   36.237917] dummy0: no IPv6 routers present
Oct  3 11:48:11 vmx kernel: [   38.186672] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:11 vmx kernel: [   38.293336] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:18 vmx kernel: [   38.966510] radeonfb 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct  3 11:48:18 vmx kernel: [   38.966925] radeonfb: Found Intel x86 BIOS ROM Image
Oct  3 11:48:18 vmx kernel: [   38.966927] radeonfb: Retrieved PLL infos from BIOS
Oct  3 11:48:18 vmx kernel: [   38.966930] radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=400.00 Mhz, System=350.00 MHz
Oct  3 11:48:18 vmx kernel: [   38.966931] radeonfb: PLL min 20000 max 40000
Oct  3 11:48:18 vmx kernel: [   39.146669] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:48:18 vmx kernel: [   39.224414] i2c-adapter i2c-3: unable to read EDID block.
Oct  3 11:48:19 vmx kernel: [   39.253335] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:48:19 vmx kernel: [   39.367747] i2c-adapter i2c-3: unable to read EDID block.
Oct  3 11:48:19 vmx kernel: [   39.511081] i2c-adapter i2c-3: unable to read EDID block.
Oct  3 11:48:19 vmx kernel: [   39.573334] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:19 vmx kernel: [   39.680002] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:19 vmx kernel: [   39.814339] radeonfb: Monitor 1 type DFP found
Oct  3 11:48:19 vmx kernel: [   39.814340] radeonfb: EDID probed
Oct  3 11:48:19 vmx kernel: [   39.814341] radeonfb: Monitor 2 type no found
Oct  3 11:48:19 vmx kernel: [   39.834520] Console: switching to colour frame buffer device 210x65
Oct  3 11:48:19 vmx kernel: [   39.845653] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
Oct  3 11:48:19 vmx kernel: [   39.845655] radeonfb (0000:01:00.0): ATI Radeon 5b63 "[c"
Oct  3 11:48:20 vmx kernel: [   40.537503] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:48:20 vmx kernel: [   40.644174] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:48:20 vmx kernel: [   40.963337] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:20 vmx kernel: [   41.070004] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:23 vmx kernel: [   43.736668] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:23 vmx kernel: [   43.843336] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:24 vmx kernel: [   44.696668] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:48:24 vmx kernel: [   44.803334] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:48:24 vmx kernel: [   45.123334] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:24 vmx kernel: [   45.230000] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:25 vmx kernel: [   46.083334] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:48:25 vmx kernel: [   46.190000] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:48:26 vmx kernel: [   46.510002] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:26 vmx kernel: [   46.616668] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:29 vmx kernel: [   49.286683] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:29 vmx kernel: [   49.393333] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:29 vmx kernel: [   50.246667] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:48:30 vmx kernel: [   50.354167] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:48:30 vmx kernel: [   50.673333] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:30 vmx kernel: [   50.780000] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:31 vmx kernel: [   51.633334] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:48:31 vmx kernel: [   51.740000] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:48:31 vmx kernel: [   52.060000] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:31 vmx kernel: [   52.166666] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:34 vmx kernel: [   54.836670] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:34 vmx kernel: [   54.943334] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:35 vmx kernel: [   55.796666] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:48:35 vmx kernel: [   55.903333] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:48:35 vmx kernel: [   56.223333] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:36 vmx kernel: [   56.329999] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:36 vmx kernel: [   57.183333] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:48:37 vmx kernel: [   57.289999] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:48:37 vmx kernel: [   57.609999] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:37 vmx kernel: [   57.716666] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:40 vmx kernel: [   60.383335] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:40 vmx kernel: [   60.489999] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:41 vmx kernel: [   61.343332] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:48:41 vmx kernel: [   61.449999] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:48:41 vmx kernel: [   61.769999] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:41 vmx kernel: [   61.876665] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:42 vmx kernel: [   62.729999] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:48:42 vmx kernel: [   62.836665] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:48:42 vmx kernel: [   63.156667] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:43 vmx kernel: [   63.263332] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:45 vmx kernel: [   65.929999] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:45 vmx kernel: [   66.036665] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:46 vmx kernel: [   66.889998] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:48:46 vmx kernel: [   66.996666] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:48:47 vmx kernel: [   67.316666] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:47 vmx kernel: [   67.423332] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:48 vmx kernel: [   68.276665] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:48:48 vmx kernel: [   68.383331] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:48:48 vmx kernel: [   68.703331] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:48 vmx kernel: [   68.809998] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:51 vmx kernel: [   71.476665] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:51 vmx kernel: [   71.584169] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:52 vmx kernel: [   72.436664] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:48:52 vmx kernel: [   72.543331] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:48:52 vmx kernel: [   72.864164] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:52 vmx kernel: [   72.969998] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:53 vmx kernel: [   73.823331] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:48:53 vmx kernel: [   73.929997] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:48:54 vmx kernel: [   74.249997] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:54 vmx kernel: [   74.356664] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:56 vmx kernel: [   77.023331] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:56 vmx kernel: [   77.129997] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:57 vmx kernel: [   77.983331] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:48:57 vmx kernel: [   78.089997] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:48:58 vmx kernel: [   78.409997] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:58 vmx kernel: [   78.516664] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:48:59 vmx kernel: [   79.369998] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:48:59 vmx kernel: [   79.476664] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:48:59 vmx kernel: [   79.796663] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:48:59 vmx kernel: [   79.903331] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:02 vmx kernel: [   82.569997] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:02 vmx kernel: [   82.676663] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:03 vmx kernel: [   83.529997] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:49:03 vmx kernel: [   83.636663] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:49:03 vmx kernel: [   83.956663] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:03 vmx kernel: [   84.063330] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:04 vmx kernel: [   84.916663] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:49:04 vmx kernel: [   85.023331] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:49:05 vmx kernel: [   85.343330] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:05 vmx kernel: [   85.449996] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:07 vmx kernel: [   88.116663] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:07 vmx kernel: [   88.223330] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:08 vmx kernel: [   89.076662] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:49:08 vmx kernel: [   89.183329] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:49:09 vmx kernel: [   89.504163] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:09 vmx kernel: [   89.609996] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:10 vmx kernel: [   90.463330] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:49:10 vmx kernel: [   90.569996] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:49:10 vmx kernel: [   90.889996] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:10 vmx kernel: [   90.996662] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:13 vmx kernel: [   93.663329] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:13 vmx kernel: [   93.769995] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:14 vmx kernel: [   94.623329] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:49:14 vmx kernel: [   94.729995] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:49:14 vmx kernel: [   95.049996] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:14 vmx kernel: [   95.156662] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:15 vmx kernel: [   96.009996] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:49:15 vmx kernel: [   96.116662] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:49:16 vmx kernel: [   96.436662] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:16 vmx kernel: [   96.543328] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:18 vmx kernel: [   99.209995] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:19 vmx kernel: [   99.316662] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:19 vmx kernel: [  100.169995] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:49:20 vmx kernel: [  100.276662] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:49:20 vmx kernel: [  100.596661] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:20 vmx kernel: [  100.703328] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:21 vmx kernel: [  101.556661] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:49:21 vmx kernel: [  101.663328] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:49:21 vmx kernel: [  101.983328] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:21 vmx kernel: [  102.089995] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:24 vmx kernel: [  104.756661] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:24 vmx kernel: [  104.863328] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:25 vmx kernel: [  105.716661] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:49:25 vmx kernel: [  105.823328] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:49:25 vmx kernel: [  106.143328] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:26 vmx kernel: [  106.249994] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:26 vmx kernel: [  107.103328] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:49:26 vmx kernel: [  107.209994] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:49:27 vmx kernel: [  107.529994] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:27 vmx kernel: [  107.636661] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:30 vmx kernel: [  110.304163] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:30 vmx kernel: [  110.409995] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:31 vmx kernel: [  111.263327] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:49:31 vmx kernel: [  111.369994] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:49:31 vmx kernel: [  111.689994] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:31 vmx kernel: [  111.796660] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:32 vmx kernel: [  112.653330] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:49:32 vmx kernel: [  112.760828] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:49:32 vmx kernel: [  113.079996] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:32 vmx kernel: [  113.187523] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:33 vmx kernel: [  113.415715] [drm] Initialized drm 1.1.0 20060810
Oct  3 11:49:33 vmx kernel: [  113.430141] radeonfb 0000:01:00.0: setting latency timer to 64
Oct  3 11:49:33 vmx kernel: [  113.430337] [drm] Initialized radeon 1.31.0 20080528 for 0000:01:00.0 on minor 0
Oct  3 11:49:33 vmx kernel: [  113.431135] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
Oct  3 11:49:33 vmx kernel: [  113.670832] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
Oct  3 11:49:33 vmx kernel: [  113.670884] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
Oct  3 11:49:33 vmx kernel: [  113.670917] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
Oct  3 11:49:33 vmx kernel: [  113.894239] [drm] Setting GART location based on new memory map
Oct  3 11:49:33 vmx kernel: [  113.894977] [drm] Loading R300 Microcode
Oct  3 11:49:33 vmx kernel: [  113.894999] [drm] Num pipes: 1
Oct  3 11:49:33 vmx kernel: [  113.895005] [drm] writeback test succeeded in 1 usecs
Oct  3 11:49:35 vmx kernel: [  115.867497] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:35 vmx kernel: [  115.974162] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:36 vmx kernel: [  116.827429] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:49:36 vmx kernel: [  116.940830] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:49:37 vmx kernel: [  117.260829] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:37 vmx kernel: [  117.367497] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:37 vmx kernel: [  118.219998] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:49:38 vmx kernel: [  118.326660] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:49:38 vmx kernel: [  118.647495] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:38 vmx kernel: [  118.753330] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:41 vmx kernel: [  121.423330] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:41 vmx kernel: [  121.529994] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:42 vmx kernel: [  122.383330] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:49:42 vmx kernel: [  122.490829] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:49:42 vmx kernel: [  122.810832] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:42 vmx kernel: [  122.916661] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:43 vmx kernel: [  123.769994] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:49:43 vmx kernel: [  123.876660] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:49:43 vmx kernel: [  124.197492] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:44 vmx kernel: [  124.304159] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:46 vmx kernel: [  126.973334] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:46 vmx kernel: [  127.079997] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:47 vmx kernel: [  127.933327] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:49:47 vmx kernel: [  128.039992] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:49:48 vmx kernel: [  128.363326] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:48 vmx kernel: [  128.469993] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:49 vmx kernel: [  129.323331] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:49:49 vmx kernel: [  129.430827] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:49:49 vmx kernel: [  129.750827] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:49 vmx kernel: [  129.857497] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:52 vmx kernel: [  132.527499] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:52 vmx kernel: [  132.633337] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:53 vmx kernel: [  133.486670] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:49:53 vmx kernel: [  133.593326] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:49:53 vmx kernel: [  133.913344] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:53 vmx kernel: [  134.020833] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:54 vmx kernel: [  134.873329] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:49:54 vmx kernel: [  134.979992] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:49:55 vmx kernel: [  135.300001] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:55 vmx kernel: [  135.406659] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:57 vmx kernel: [  138.073326] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:57 vmx kernel: [  138.179992] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:49:58 vmx kernel: [  139.033324] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:49:58 vmx kernel: [  139.139991] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:49:59 vmx kernel: [  139.459991] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:49:59 vmx kernel: [  139.566658] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:00 vmx kernel: [  140.420829] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:50:00 vmx kernel: [  140.526658] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:50:00 vmx kernel: [  140.846658] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:00 vmx kernel: [  140.953325] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:03 vmx kernel: [  143.619991] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:03 vmx kernel: [  143.726658] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:04 vmx kernel: [  144.583328] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:50:04 vmx kernel: [  144.690829] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:50:04 vmx kernel: [  145.009995] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:04 vmx kernel: [  145.117504] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:05 vmx kernel: [  145.974161] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:50:05 vmx kernel: [  146.087494] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:50:06 vmx kernel: [  146.406664] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:06 vmx kernel: [  146.513327] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:08 vmx kernel: [  149.187500] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:09 vmx kernel: [  149.294162] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:09 vmx kernel: [  150.146660] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:50:10 vmx kernel: [  150.254160] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:50:10 vmx kernel: [  150.573323] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:10 vmx kernel: [  150.679990] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:11 vmx kernel: [  151.533324] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:50:11 vmx kernel: [  151.639990] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:50:11 vmx kernel: [  151.959990] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:11 vmx kernel: [  152.066656] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:14 vmx kernel: [  154.734160] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:14 vmx kernel: [  154.840877] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:15 vmx kernel: [  155.693328] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:50:15 vmx kernel: [  155.799990] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:50:15 vmx kernel: [  156.119991] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:15 vmx kernel: [  156.226656] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:16 vmx kernel: [  157.079992] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:50:16 vmx kernel: [  157.186656] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:50:17 vmx kernel: [  157.506658] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:17 vmx kernel: [  157.613323] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:20 vmx kernel: [  160.279992] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:20 vmx kernel: [  160.386656] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:20 vmx kernel: [  161.239990] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:50:21 vmx kernel: [  161.346657] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:50:21 vmx kernel: [  161.666657] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:21 vmx kernel: [  161.773322] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:22 vmx kernel: [  162.626657] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:50:22 vmx kernel: [  162.733322] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:50:22 vmx kernel: [  163.053323] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:22 vmx kernel: [  163.159989] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:25 vmx kernel: [  165.826657] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:25 vmx kernel: [  165.933322] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:26 vmx kernel: [  166.786655] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:50:26 vmx kernel: [  166.893322] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:50:26 vmx kernel: [  167.213324] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:27 vmx kernel: [  167.319988] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:27 vmx kernel: [  168.173325] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:50:28 vmx kernel: [  168.279990] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:50:28 vmx kernel: [  168.599992] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:28 vmx kernel: [  168.707490] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:31 vmx kernel: [  171.374158] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:31 vmx kernel: [  171.483325] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:32 vmx kernel: [  172.340825] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:50:32 vmx kernel: [  172.447491] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:50:32 vmx kernel: [  172.767498] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:32 vmx kernel: [  172.873325] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:33 vmx kernel: [  173.726657] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:50:33 vmx kernel: [  173.833322] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:50:33 vmx kernel: [  174.153321] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:34 vmx kernel: [  174.260823] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:36 vmx kernel: [  176.926656] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:36 vmx kernel: [  177.033321] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:37 vmx kernel: [  177.886655] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:50:37 vmx kernel: [  177.993320] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:50:38 vmx kernel: [  178.313320] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:38 vmx kernel: [  178.419987] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:39 vmx kernel: [  179.273321] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:50:39 vmx kernel: [  179.379987] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:50:39 vmx kernel: [  179.699988] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:39 vmx kernel: [  179.806654] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:42 vmx kernel: [  182.474156] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:42 vmx kernel: [  182.579988] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:43 vmx kernel: [  183.433323] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:50:43 vmx kernel: [  183.539987] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:50:43 vmx kernel: [  183.859995] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:43 vmx kernel: [  183.966658] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:44 vmx kernel: [  184.820825] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:50:44 vmx kernel: [  184.926657] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:50:44 vmx kernel: [  185.246658] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:45 vmx kernel: [  185.353321] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:47 vmx kernel: [  188.026656] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:47 vmx kernel: [  188.133340] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:48 vmx kernel: [  188.986657] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:50:48 vmx kernel: [  189.094154] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:50:49 vmx kernel: [  189.414163] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:49 vmx kernel: [  189.520261] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:50 vmx kernel: [  190.373322] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:50:50 vmx kernel: [  190.480826] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:50:50 vmx kernel: [  190.799991] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:50 vmx kernel: [  190.906656] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:53 vmx kernel: [  193.573324] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:53 vmx kernel: [  193.679989] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:54 vmx kernel: [  194.533327] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:50:54 vmx kernel: [  194.639986] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:50:54 vmx kernel: [  194.959985] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:54 vmx kernel: [  195.067490] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:55 vmx kernel: [  195.920827] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:50:55 vmx kernel: [  196.026655] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:50:56 vmx kernel: [  196.346652] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:56 vmx kernel: [  196.454161] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:58 vmx kernel: [  199.119988] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:50:58 vmx kernel: [  199.226652] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:50:59 vmx kernel: [  200.079986] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:50:59 vmx kernel: [  200.186652] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:51:00 vmx kernel: [  200.506652] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:00 vmx kernel: [  200.613319] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:01 vmx kernel: [  201.466652] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:51:01 vmx kernel: [  201.573319] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:51:01 vmx kernel: [  201.893318] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:01 vmx kernel: [  201.999985] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:04 vmx kernel: [  204.666652] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:04 vmx kernel: [  204.773318] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:05 vmx kernel: [  205.626652] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:51:05 vmx kernel: [  205.733318] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:51:05 vmx kernel: [  206.053317] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:05 vmx kernel: [  206.159984] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:06 vmx kernel: [  207.013321] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:51:06 vmx kernel: [  207.120825] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:51:07 vmx kernel: [  207.439988] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:07 vmx kernel: [  207.546651] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:09 vmx kernel: [  210.213321] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:10 vmx kernel: [  210.319986] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:10 vmx kernel: [  211.177493] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:51:11 vmx kernel: [  211.283321] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:51:11 vmx kernel: [  211.604152] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:11 vmx kernel: [  211.710816] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:12 vmx kernel: [  212.564158] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:51:12 vmx kernel: [  212.669989] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:51:12 vmx kernel: [  212.989987] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:12 vmx kernel: [  213.096652] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:15 vmx kernel: [  215.766653] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:15 vmx kernel: [  215.873317] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:16 vmx kernel: [  216.726653] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:51:16 vmx kernel: [  216.833317] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:51:16 vmx kernel: [  217.153316] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:17 vmx kernel: [  217.259985] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:17 vmx kernel: [  218.113317] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:51:17 vmx kernel: [  218.219983] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:51:18 vmx kernel: [  218.539983] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:18 vmx kernel: [  218.647488] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:21 vmx kernel: [  221.314156] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:21 vmx kernel: [  221.320896] [drm] Num pipes: 1
Oct  3 11:51:21 vmx kernel: [  221.420819] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:22 vmx kernel: [  222.273317] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:51:22 vmx kernel: [  222.379983] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:51:22 vmx kernel: [  222.699986] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:22 vmx kernel: [  222.806649] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:23 vmx kernel: [  223.659985] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:51:23 vmx kernel: [  223.766649] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:51:23 vmx kernel: [  224.086649] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:23 vmx kernel: [  224.193316] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:26 vmx kernel: [  226.859985] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:26 vmx kernel: [  226.966649] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:27 vmx kernel: [  227.819986] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:51:27 vmx kernel: [  227.926650] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:51:27 vmx kernel: [  228.246649] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:28 vmx kernel: [  228.353316] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:28 vmx kernel: [  229.206650] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:51:29 vmx kernel: [  229.313316] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:51:29 vmx kernel: [  229.633318] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:29 vmx kernel: [  229.739982] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:32 vmx kernel: [  232.409985] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:32 vmx kernel: [  232.516648] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:33 vmx kernel: [  233.369985] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:51:33 vmx kernel: [  233.476649] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:51:33 vmx kernel: [  233.796650] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:33 vmx kernel: [  233.903315] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:34 vmx kernel: [  234.757486] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:51:34 vmx kernel: [  234.863315] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:51:34 vmx kernel: [  235.183315] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:35 vmx kernel: [  235.289981] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:37 vmx kernel: [  237.956649] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:37 vmx kernel: [  238.063315] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:38 vmx kernel: [  238.916648] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:51:38 vmx kernel: [  239.023314] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:51:39 vmx kernel: [  239.343316] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:39 vmx kernel: [  239.449981] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:40 vmx kernel: [  240.303316] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:51:40 vmx kernel: [  240.409981] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:51:40 vmx kernel: [  240.729982] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:40 vmx kernel: [  240.836648] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:43 vmx kernel: [  243.504150] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:43 vmx kernel: [  243.609982] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:44 vmx kernel: [  244.463314] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:51:44 vmx kernel: [  244.569980] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:51:44 vmx kernel: [  244.889981] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:44 vmx kernel: [  244.996647] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:45 vmx kernel: [  245.849982] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:51:45 vmx kernel: [  245.956647] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:51:46 vmx kernel: [  246.276647] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:46 vmx kernel: [  246.383314] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:48 vmx kernel: [  249.049981] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:48 vmx kernel: [  249.156647] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:49 vmx kernel: [  250.009982] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:51:49 vmx kernel: [  250.116647] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:51:50 vmx kernel: [  250.436647] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:50 vmx kernel: [  250.543313] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:51 vmx kernel: [  251.396649] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:51:51 vmx kernel: [  251.504148] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:51:51 vmx kernel: [  251.823314] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:51 vmx kernel: [  251.929980] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:53 vmx kernel: [  254.063314] i2c IR (Pinnacle PCTV): unknown key: key=0x5c raw=0x5c down=1
Oct  3 11:51:53 vmx kernel: [  254.169979] i2c IR (Pinnacle PCTV): unknown key: key=0x5c raw=0x5c down=0
Oct  3 11:51:54 vmx kernel: [  254.596649] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:54 vmx kernel: [  254.703314] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:55 vmx kernel: [  255.556646] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:51:55 vmx kernel: [  255.663314] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:51:55 vmx kernel: [  255.983313] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:55 vmx kernel: [  256.089979] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:56 vmx kernel: [  256.943313] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:51:56 vmx kernel: [  257.049979] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:51:57 vmx kernel: [  257.369979] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:51:57 vmx kernel: [  257.476646] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:51:59 vmx kernel: [  260.143314] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:00 vmx kernel: [  260.249979] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:00 vmx kernel: [  261.107482] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:52:00 vmx kernel: [  261.213312] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:52:01 vmx kernel: [  261.533312] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:01 vmx kernel: [  261.639981] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:02 vmx kernel: [  262.493313] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:52:02 vmx kernel: [  262.599981] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:52:02 vmx kernel: [  262.919979] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:02 vmx kernel: [  263.026645] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:05 vmx kernel: [  265.693315] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:05 vmx kernel: [  265.799978] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:06 vmx kernel: [  266.653314] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:52:06 vmx kernel: [  266.759978] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:52:06 vmx kernel: [  267.079979] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:06 vmx kernel: [  267.186648] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:07 vmx kernel: [  268.039979] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:52:07 vmx kernel: [  268.146645] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:52:08 vmx kernel: [  268.466645] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:08 vmx kernel: [  268.573311] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:10 vmx kernel: [  271.239980] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:11 vmx kernel: [  271.346646] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:11 vmx kernel: [  272.199991] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:52:12 vmx kernel: [  272.306645] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:52:12 vmx kernel: [  272.626646] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:12 vmx kernel: [  272.733311] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:13 vmx kernel: [  273.587480] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:52:13 vmx kernel: [  273.693311] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:52:13 vmx kernel: [  274.013311] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:13 vmx kernel: [  274.119977] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:16 vmx kernel: [  276.786646] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:16 vmx kernel: [  276.893311] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:17 vmx kernel: [  277.746646] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:52:17 vmx kernel: [  277.853311] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:52:17 vmx kernel: [  278.173311] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:18 vmx kernel: [  278.279977] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:18 vmx kernel: [  279.133312] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:52:18 vmx kernel: [  279.239977] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:52:19 vmx kernel: [  279.559978] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:19 vmx kernel: [  279.666646] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:22 vmx kernel: [  282.333312] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:22 vmx kernel: [  282.439977] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:23 vmx kernel: [  283.293311] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:52:23 vmx kernel: [  283.399977] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:52:23 vmx kernel: [  283.719978] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:23 vmx kernel: [  283.826644] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:24 vmx kernel: [  284.679978] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:52:24 vmx kernel: [  284.786643] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:52:24 vmx kernel: [  285.106644] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:24 vmx kernel: [  285.213310] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:27 vmx kernel: [  287.879979] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:27 vmx kernel: [  287.986643] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:28 vmx kernel: [  288.839977] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:52:28 vmx kernel: [  288.946643] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:52:29 vmx kernel: [  289.267476] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:29 vmx kernel: [  289.373309] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:29 vmx kernel: [  290.226644] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:52:30 vmx kernel: [  290.333309] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:52:30 vmx kernel: [  290.653311] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:30 vmx kernel: [  290.759976] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:33 vmx kernel: [  293.429978] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:33 vmx kernel: [  293.536642] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:34 vmx kernel: [  294.389977] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:52:34 vmx kernel: [  294.496642] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:52:34 vmx kernel: [  294.816644] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:34 vmx kernel: [  294.924145] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:35 vmx kernel: [  295.776644] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:52:35 vmx kernel: [  295.883310] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:52:35 vmx kernel: [  296.204145] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:36 vmx kernel: [  296.310809] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:38 vmx kernel: [  298.976644] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:38 vmx kernel: [  299.083309] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:39 vmx kernel: [  299.936643] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:52:39 vmx kernel: [  300.043308] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:52:40 vmx kernel: [  300.363308] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:40 vmx kernel: [  300.469975] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:41 vmx kernel: [  301.323309] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:52:41 vmx kernel: [  301.429975] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:52:41 vmx kernel: [  301.749976] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:41 vmx kernel: [  301.856641] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:44 vmx kernel: [  304.523310] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:44 vmx kernel: [  304.629976] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:45 vmx kernel: [  305.483308] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:52:45 vmx kernel: [  305.590810] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:52:45 vmx kernel: [  305.910808] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:45 vmx kernel: [  306.016641] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:46 vmx kernel: [  306.869975] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:52:46 vmx kernel: [  306.976641] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:52:47 vmx kernel: [  307.296641] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:47 vmx kernel: [  307.403307] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:49 vmx kernel: [  310.069976] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:49 vmx kernel: [  310.176641] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:50 vmx kernel: [  311.029975] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:52:50 vmx kernel: [  311.136640] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:52:51 vmx kernel: [  311.456640] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:51 vmx kernel: [  311.563307] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:52 vmx kernel: [  312.416642] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:52:52 vmx kernel: [  312.524142] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:52:52 vmx kernel: [  312.843309] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:52 vmx kernel: [  312.949974] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:55 vmx kernel: [  315.616642] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:55 vmx kernel: [  315.723307] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:56 vmx kernel: [  316.576641] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:52:56 vmx kernel: [  316.684141] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:52:56 vmx kernel: [  317.004140] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:56 vmx kernel: [  317.110807] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:52:57 vmx kernel: [  317.963308] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:52:57 vmx kernel: [  318.069973] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:52:58 vmx kernel: [  318.389973] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:52:58 vmx kernel: [  318.496640] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:00 vmx kernel: [  321.163308] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:01 vmx kernel: [  321.269973] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:01 vmx kernel: [  322.123307] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:53:01 vmx kernel: [  322.229974] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:53:02 vmx kernel: [  322.549972] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:02 vmx kernel: [  322.656641] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:03 vmx kernel: [  323.510807] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:53:03 vmx kernel: [  323.616640] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:53:03 vmx kernel: [  323.936639] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:03 vmx kernel: [  324.043306] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:06 vmx kernel: [  326.710808] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:06 vmx kernel: [  326.816639] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:07 vmx kernel: [  327.669974] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:53:07 vmx kernel: [  327.776639] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:53:07 vmx kernel: [  328.096639] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:07 vmx kernel: [  328.203305] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:08 vmx kernel: [  329.056640] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:53:08 vmx kernel: [  329.163305] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:53:09 vmx kernel: [  329.483305] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:09 vmx kernel: [  329.590809] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:12 vmx kernel: [  332.256844] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:12 vmx kernel: [  332.363305] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:12 vmx kernel: [  333.216639] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:53:13 vmx kernel: [  333.323305] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:53:13 vmx kernel: [  333.643317] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:13 vmx kernel: [  333.749973] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:14 vmx kernel: [  334.603307] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:53:14 vmx kernel: [  334.710805] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:53:14 vmx kernel: [  335.029972] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:14 vmx kernel: [  335.136638] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:17 vmx kernel: [  337.803307] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:17 vmx kernel: [  337.910805] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:18 vmx kernel: [  338.763305] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:53:18 vmx kernel: [  338.869971] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:53:18 vmx kernel: [  339.189971] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:19 vmx kernel: [  339.296638] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:19 vmx kernel: [  340.149973] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:53:20 vmx kernel: [  340.256638] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:53:20 vmx kernel: [  340.576637] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:20 vmx kernel: [  340.683306] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:23 vmx kernel: [  343.349973] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:23 vmx kernel: [  343.456638] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:24 vmx kernel: [  344.310805] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:53:24 vmx kernel: [  344.416637] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:53:24 vmx kernel: [  344.736638] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:24 vmx kernel: [  344.843304] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:25 vmx kernel: [  345.697475] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:53:25 vmx kernel: [  345.803304] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:53:25 vmx kernel: [  346.123303] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:25 vmx kernel: [  346.229970] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:28 vmx kernel: [  348.896638] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:28 vmx kernel: [  349.004137] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:29 vmx kernel: [  349.856638] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:53:29 vmx kernel: [  349.963303] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:53:30 vmx kernel: [  350.283303] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:30 vmx kernel: [  350.389970] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:30 vmx kernel: [  351.243304] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:53:31 vmx kernel: [  351.349971] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:53:31 vmx kernel: [  351.669972] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:31 vmx kernel: [  351.776636] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:34 vmx kernel: [  354.443304] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:34 vmx kernel: [  354.549969] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:35 vmx kernel: [  355.403305] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:53:35 vmx kernel: [  355.510803] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:53:35 vmx kernel: [  355.829972] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:35 vmx kernel: [  355.936636] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:36 vmx kernel: [  356.789970] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:53:36 vmx kernel: [  356.896636] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:53:36 vmx kernel: [  357.216636] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:37 vmx kernel: [  357.323304] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:39 vmx kernel: [  359.492065] [drm] Loading R300 Microcode
Oct  3 11:53:39 vmx kernel: [  359.492086] [drm] Num pipes: 1
Oct  3 11:53:39 vmx kernel: [  359.994147] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:39 vmx kernel: [  360.100813] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:40 vmx kernel: [  360.953306] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:53:40 vmx kernel: [  361.059970] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:53:41 vmx kernel: [  361.379977] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:41 vmx kernel: [  361.486644] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:42 vmx kernel: [  362.339973] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:53:42 vmx kernel: [  362.446636] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:53:42 vmx kernel: [  362.766639] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:42 vmx kernel: [  362.873302] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:45 vmx kernel: [  365.543306] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:45 vmx kernel: [  365.649973] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:46 vmx kernel: [  366.504138] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:53:46 vmx kernel: [  366.610809] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:53:46 vmx kernel: [  366.929973] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:46 vmx kernel: [  367.036635] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:47 vmx kernel: [  367.890810] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:53:47 vmx kernel: [  367.997471] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:53:48 vmx kernel: [  368.317479] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:48 vmx kernel: [  368.423302] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:50 vmx kernel: [  371.090827] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:50 vmx kernel: [  371.196643] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:51 vmx kernel: [  372.050809] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:53:51 vmx kernel: [  372.156635] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:53:52 vmx kernel: [  372.476640] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:52 vmx kernel: [  372.583307] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:53 vmx kernel: [  373.436640] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:53:53 vmx kernel: [  373.543301] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:53:53 vmx kernel: [  373.863301] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:53 vmx kernel: [  373.969968] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:56 vmx kernel: [  376.636637] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:56 vmx kernel: [  376.744139] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:57 vmx kernel: [  377.596639] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:53:57 vmx kernel: [  377.703301] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:53:57 vmx kernel: [  378.023303] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:57 vmx kernel: [  378.129967] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:53:58 vmx kernel: [  378.983303] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:53:58 vmx kernel: [  379.089970] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:53:59 vmx kernel: [  379.409968] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:53:59 vmx kernel: [  379.516636] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:01 vmx kernel: [  382.184142] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:02 vmx kernel: [  382.290808] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:02 vmx kernel: [  383.143303] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:54:03 vmx kernel: [  383.249967] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:54:03 vmx kernel: [  383.569969] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:03 vmx kernel: [  383.676636] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:04 vmx kernel: [  384.529971] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:54:04 vmx kernel: [  384.636636] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:54:04 vmx kernel: [  384.956638] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:04 vmx kernel: [  385.063301] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:07 vmx kernel: [  387.729970] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:07 vmx kernel: [  387.836633] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:08 vmx kernel: [  388.689971] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:54:08 vmx kernel: [  388.796633] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:54:08 vmx kernel: [  389.116636] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:08 vmx kernel: [  389.223300] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:09 vmx kernel: [  390.077471] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:54:09 vmx kernel: [  390.183300] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:54:10 vmx kernel: [  390.503300] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:10 vmx kernel: [  390.609967] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:13 vmx kernel: [  393.276637] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:13 vmx kernel: [  393.383300] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:13 vmx kernel: [  394.236642] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:54:14 vmx kernel: [  394.343300] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:54:14 vmx kernel: [  394.663302] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:14 vmx kernel: [  394.769966] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:15 vmx kernel: [  395.623302] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:54:15 vmx kernel: [  395.729968] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:54:15 vmx kernel: [  396.049965] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:15 vmx kernel: [  396.156632] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:18 vmx kernel: [  398.823301] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:18 vmx kernel: [  398.930801] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:19 vmx kernel: [  399.783301] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:54:19 vmx kernel: [  399.889965] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:54:19 vmx kernel: [  400.209965] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:20 vmx kernel: [  400.316631] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:20 vmx kernel: [  401.169969] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:54:21 vmx kernel: [  401.276632] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:54:21 vmx kernel: [  401.597472] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:21 vmx kernel: [  401.703299] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:24 vmx kernel: [  404.369967] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:24 vmx kernel: [  404.476634] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:25 vmx kernel: [  405.329967] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:54:25 vmx kernel: [  405.436632] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:54:25 vmx kernel: [  405.756634] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:25 vmx kernel: [  405.863300] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:26 vmx kernel: [  406.716634] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:54:26 vmx kernel: [  406.823303] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:54:26 vmx kernel: [  407.143303] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:27 vmx kernel: [  407.249967] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:29 vmx kernel: [  409.916639] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:29 vmx kernel: [  410.023298] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:30 vmx kernel: [  410.876634] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:54:30 vmx kernel: [  410.983300] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:54:31 vmx kernel: [  411.303298] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:31 vmx kernel: [  411.409964] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:32 vmx kernel: [  412.263300] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:54:32 vmx kernel: [  412.369964] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:54:32 vmx kernel: [  412.689967] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:32 vmx kernel: [  412.796631] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:35 vmx kernel: [  415.463301] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:35 vmx kernel: [  415.569963] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:36 vmx kernel: [  416.423299] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:54:36 vmx kernel: [  416.530801] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:54:36 vmx kernel: [  416.849967] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:36 vmx kernel: [  416.956630] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:37 vmx kernel: [  417.809966] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:54:37 vmx kernel: [  417.916635] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:54:37 vmx kernel: [  418.236632] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:38 vmx kernel: [  418.343297] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:40 vmx kernel: [  421.009966] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:40 vmx kernel: [  421.116630] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:41 vmx kernel: [  421.973299] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:54:41 vmx kernel: [  422.079966] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:54:42 vmx kernel: [  422.399966] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:42 vmx kernel: [  422.506630] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:43 vmx kernel: [  423.359966] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:54:43 vmx kernel: [  423.466629] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:54:43 vmx kernel: [  423.786632] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:43 vmx kernel: [  423.893296] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:46 vmx kernel: [  426.559966] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:46 vmx kernel: [  426.668388] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:47 vmx kernel: [  427.519965] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:54:47 vmx kernel: [  427.627469] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:54:47 vmx kernel: [  427.946635] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:47 vmx kernel: [  428.053296] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:48 vmx kernel: [  428.906632] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:54:48 vmx kernel: [  429.013296] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:54:49 vmx kernel: [  429.333296] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:49 vmx kernel: [  429.439962] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:51 vmx kernel: [  432.106631] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:51 vmx kernel: [  432.213295] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:52 vmx kernel: [  433.066630] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:54:52 vmx kernel: [  433.173296] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:54:53 vmx kernel: [  433.493298] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:53 vmx kernel: [  433.599966] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:54 vmx kernel: [  434.453298] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:54:54 vmx kernel: [  434.559963] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:54:54 vmx kernel: [  434.879964] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:54 vmx kernel: [  434.986629] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:57 vmx kernel: [  437.653299] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:57 vmx kernel: [  437.759961] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:58 vmx kernel: [  438.613298] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:54:58 vmx kernel: [  438.719961] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:54:58 vmx kernel: [  439.039965] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:54:58 vmx kernel: [  439.146629] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:54:59 vmx kernel: [  439.999964] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:54:59 vmx kernel: [  440.106631] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:55:00 vmx kernel: [  440.426630] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:00 vmx kernel: [  440.534130] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:02 vmx kernel: [  443.199963] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:03 vmx kernel: [  443.306630] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:03 vmx kernel: [  444.159963] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:55:04 vmx kernel: [  444.266627] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:55:04 vmx kernel: [  444.586634] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:04 vmx kernel: [  444.693294] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:05 vmx kernel: [  445.546637] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:55:05 vmx kernel: [  445.653296] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:55:05 vmx kernel: [  445.973304] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:05 vmx kernel: [  446.079963] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:08 vmx kernel: [  448.747466] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:08 vmx kernel: [  448.853294] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:09 vmx kernel: [  449.706632] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:55:09 vmx kernel: [  449.813294] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:55:09 vmx kernel: [  450.133297] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:09 vmx kernel: [  450.239960] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:10 vmx kernel: [  451.093296] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:55:10 vmx kernel: [  451.199960] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:55:11 vmx kernel: [  451.519961] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:11 vmx kernel: [  451.626629] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:14 vmx kernel: [  454.293296] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:14 vmx kernel: [  454.399960] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:15 vmx kernel: [  455.254134] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:55:15 vmx kernel: [  455.359960] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:55:15 vmx kernel: [  455.683296] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:15 vmx kernel: [  455.789960] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:16 vmx kernel: [  456.643297] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:55:16 vmx kernel: [  456.749960] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:55:16 vmx kernel: [  457.069962] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:16 vmx kernel: [  457.176626] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:19 vmx kernel: [  459.844128] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:19 vmx kernel: [  459.949959] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:20 vmx kernel: [  460.803299] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:55:20 vmx kernel: [  460.909959] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:55:20 vmx kernel: [  461.229962] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:21 vmx kernel: [  461.337462] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:21 vmx kernel: [  462.189961] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:55:22 vmx kernel: [  462.296625] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:55:22 vmx kernel: [  462.616629] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:22 vmx kernel: [  462.723293] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:25 vmx kernel: [  465.389964] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:25 vmx kernel: [  465.496625] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:26 vmx kernel: [  466.350802] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:55:26 vmx kernel: [  466.456625] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:55:26 vmx kernel: [  466.776628] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:26 vmx kernel: [  466.883291] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:27 vmx kernel: [  467.736628] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:55:27 vmx kernel: [  467.844129] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:55:27 vmx kernel: [  468.163294] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:28 vmx kernel: [  468.269959] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:30 vmx kernel: [  470.936628] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:30 vmx kernel: [  471.044151] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:31 vmx kernel: [  471.896627] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:55:31 vmx kernel: [  472.003292] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:55:32 vmx kernel: [  472.323294] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:32 vmx kernel: [  472.430814] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:33 vmx kernel: [  473.283294] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:55:33 vmx kernel: [  473.389958] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:55:33 vmx kernel: [  473.709961] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:33 vmx kernel: [  473.816624] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:36 vmx kernel: [  476.483294] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:36 vmx kernel: [  476.590798] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:37 vmx kernel: [  477.443293] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:55:37 vmx kernel: [  477.550015] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:55:37 vmx kernel: [  477.869960] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:37 vmx kernel: [  477.976624] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:38 vmx kernel: [  478.829960] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:55:38 vmx kernel: [  478.936624] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:55:39 vmx kernel: [  479.256629] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:39 vmx kernel: [  479.363292] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:41 vmx kernel: [  482.029969] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:41 vmx kernel: [  482.136624] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:42 vmx kernel: [  482.989960] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:55:42 vmx kernel: [  483.096626] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:55:43 vmx kernel: [  483.417461] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:43 vmx kernel: [  483.523290] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:44 vmx kernel: [  484.376626] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:55:44 vmx kernel: [  484.483298] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:55:44 vmx kernel: [  484.803294] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:44 vmx kernel: [  484.909957] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:47 vmx kernel: [  487.576627] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:47 vmx kernel: [  487.683293] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:48 vmx kernel: [  488.536629] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:55:48 vmx kernel: [  488.643293] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:55:48 vmx kernel: [  488.963290] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:48 vmx kernel: [  489.069960] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:49 vmx kernel: [  489.924131] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:55:49 vmx kernel: [  490.030794] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:55:50 vmx kernel: [  490.349960] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:50 vmx kernel: [  490.456623] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:52 vmx kernel: [  493.126627] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:52 vmx kernel: [  493.233290] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:53 vmx kernel: [  494.086626] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:55:53 vmx kernel: [  494.193289] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:55:54 vmx kernel: [  494.513289] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:54 vmx kernel: [  494.619964] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:55 vmx kernel: [  495.473292] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:55:55 vmx kernel: [  495.579956] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:55:55 vmx kernel: [  495.903291] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:55 vmx kernel: [  496.009955] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:58 vmx kernel: [  498.677460] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:58 vmx kernel: [  498.783289] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:55:59 vmx kernel: [  499.636626] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:55:59 vmx kernel: [  499.743289] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:55:59 vmx kernel: [  500.063290] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:55:59 vmx kernel: [  500.169956] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:00 vmx kernel: [  501.023292] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:56:00 vmx kernel: [  501.130794] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:56:01 vmx kernel: [  501.449958] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:01 vmx kernel: [  501.556624] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:03 vmx kernel: [  504.223292] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:04 vmx kernel: [  504.329955] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:04 vmx kernel: [  505.183291] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:56:05 vmx kernel: [  505.289955] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:56:05 vmx kernel: [  505.609960] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:05 vmx kernel: [  505.716621] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:06 vmx kernel: [  506.569958] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:56:06 vmx kernel: [  506.676621] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:56:06 vmx kernel: [  506.996621] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:06 vmx kernel: [  507.103288] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:09 vmx kernel: [  509.769957] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:09 vmx kernel: [  509.876626] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:10 vmx kernel: [  510.729957] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:56:10 vmx kernel: [  510.836621] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:56:10 vmx kernel: [  511.157457] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:11 vmx kernel: [  511.264121] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:11 vmx kernel: [  512.116623] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:56:11 vmx kernel: [  512.223287] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:56:12 vmx kernel: [  512.543306] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:12 vmx kernel: [  512.649956] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:15 vmx kernel: [  515.316623] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:15 vmx kernel: [  515.423291] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:16 vmx kernel: [  516.276623] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:56:16 vmx kernel: [  516.383287] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:56:16 vmx kernel: [  516.703287] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:16 vmx kernel: [  516.809953] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:17 vmx kernel: [  517.663289] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:56:17 vmx kernel: [  517.769953] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:56:17 vmx kernel: [  518.089956] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:17 vmx kernel: [  518.196620] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:20 vmx kernel: [  520.863289] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:20 vmx kernel: [  520.969953] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:21 vmx kernel: [  521.823289] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:56:21 vmx kernel: [  521.929953] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:56:22 vmx kernel: [  522.249956] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:22 vmx kernel: [  522.356620] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:22 vmx kernel: [  523.209956] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:56:23 vmx kernel: [  523.316620] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:56:23 vmx kernel: [  523.636623] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:23 vmx kernel: [  523.743288] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:26 vmx kernel: [  526.409956] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:26 vmx kernel: [  526.516621] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:27 vmx kernel: [  527.369955] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:56:27 vmx kernel: [  527.476621] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:56:27 vmx kernel: [  527.796622] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:27 vmx kernel: [  527.903289] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:28 vmx kernel: [  528.756622] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:56:28 vmx kernel: [  528.863286] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:56:28 vmx kernel: [  529.183288] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:29 vmx kernel: [  529.289952] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:31 vmx kernel: [  531.956622] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:31 vmx kernel: [  532.063290] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:32 vmx kernel: [  532.916622] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:56:32 vmx kernel: [  533.023288] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:56:33 vmx kernel: [  533.343288] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:33 vmx kernel: [  533.449952] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:34 vmx kernel: [  534.303288] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:56:34 vmx kernel: [  534.409952] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:56:34 vmx kernel: [  534.729953] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:34 vmx kernel: [  534.836618] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:37 vmx kernel: [  537.504122] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:37 vmx kernel: [  537.609952] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:38 vmx kernel: [  538.463287] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:56:38 vmx kernel: [  538.569954] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:56:38 vmx kernel: [  538.890789] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:38 vmx kernel: [  538.996618] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:39 vmx kernel: [  539.849955] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:56:39 vmx kernel: [  539.956621] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:56:40 vmx kernel: [  540.276621] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:40 vmx kernel: [  540.383285] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:42 vmx kernel: [  543.049954] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:42 vmx kernel: [  543.156618] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:43 vmx kernel: [  544.009953] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:56:43 vmx kernel: [  544.116620] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:56:44 vmx kernel: [  544.436620] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:44 vmx kernel: [  544.544123] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:45 vmx kernel: [  545.396620] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:56:45 vmx kernel: [  545.504118] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:56:45 vmx kernel: [  545.823287] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:45 vmx kernel: [  545.929953] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:48 vmx kernel: [  548.597466] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:48 vmx kernel: [  548.703287] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:49 vmx kernel: [  549.557458] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:56:49 vmx kernel: [  549.663285] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:56:49 vmx kernel: [  549.983285] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:49 vmx kernel: [  550.090788] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:50 vmx kernel: [  550.943286] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:56:50 vmx kernel: [  551.049998] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:56:51 vmx kernel: [  551.369953] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:51 vmx kernel: [  551.476620] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:53 vmx kernel: [  554.143287] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:54 vmx kernel: [  554.249950] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:54 vmx kernel: [  555.103287] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:56:54 vmx kernel: [  555.209950] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:56:55 vmx kernel: [  555.529955] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:55 vmx kernel: [  555.636618] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:56 vmx kernel: [  556.489952] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:56:56 vmx kernel: [  556.596626] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:56:56 vmx kernel: [  556.916616] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:56 vmx kernel: [  557.023288] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:56:59 vmx kernel: [  559.689952] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:56:59 vmx kernel: [  559.796616] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:00 vmx kernel: [  560.649952] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:57:00 vmx kernel: [  560.756616] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:57:00 vmx kernel: [  561.076615] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:00 vmx kernel: [  561.183282] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:01 vmx kernel: [  562.036618] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:57:01 vmx kernel: [  562.143282] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:57:02 vmx kernel: [  562.463282] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:02 vmx kernel: [  562.569949] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:04 vmx kernel: [  565.236618] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:05 vmx kernel: [  565.343282] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:05 vmx kernel: [  566.196618] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:57:06 vmx kernel: [  566.303283] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:57:06 vmx kernel: [  566.623287] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:06 vmx kernel: [  566.729949] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:07 vmx kernel: [  567.583290] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:57:07 vmx kernel: [  567.689950] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:57:07 vmx kernel: [  568.009948] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:07 vmx kernel: [  568.116617] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:10 vmx kernel: [  570.783284] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:10 vmx kernel: [  570.889948] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:11 vmx kernel: [  571.743285] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:57:11 vmx kernel: [  571.850802] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:57:11 vmx kernel: [  572.169951] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:12 vmx kernel: [  572.276614] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:12 vmx kernel: [  573.129951] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:57:12 vmx kernel: [  573.236615] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:57:13 vmx kernel: [  573.556619] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:13 vmx kernel: [  573.663281] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:16 vmx kernel: [  576.329950] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:16 vmx kernel: [  576.436614] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:17 vmx kernel: [  577.289950] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:57:17 vmx kernel: [  577.396614] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:57:17 vmx kernel: [  577.716616] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:17 vmx kernel: [  577.823280] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:18 vmx kernel: [  578.676617] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:57:18 vmx kernel: [  578.783280] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:57:18 vmx kernel: [  579.103284] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:18 vmx kernel: [  579.209947] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:21 vmx kernel: [  581.876616] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:21 vmx kernel: [  581.983280] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:22 vmx kernel: [  582.836616] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:57:22 vmx kernel: [  582.943280] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:57:23 vmx kernel: [  583.264114] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:23 vmx kernel: [  583.369949] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:23 vmx kernel: [  584.223283] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:57:24 vmx kernel: [  584.329947] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:57:24 vmx kernel: [  584.650787] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:24 vmx kernel: [  584.756617] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:27 vmx kernel: [  587.423283] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:27 vmx kernel: [  587.529952] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:28 vmx kernel: [  588.383282] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:57:28 vmx kernel: [  588.489948] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:57:28 vmx kernel: [  588.809949] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:28 vmx kernel: [  588.917459] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:29 vmx kernel: [  589.769949] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:57:29 vmx kernel: [  589.876613] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:57:29 vmx kernel: [  590.196616] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:30 vmx kernel: [  590.303279] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:32 vmx kernel: [  592.969948] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:32 vmx kernel: [  593.076615] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:33 vmx kernel: [  593.929948] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:57:33 vmx kernel: [  594.036617] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:57:34 vmx kernel: [  594.356615] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:34 vmx kernel: [  594.463279] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:35 vmx kernel: [  595.316614] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:57:35 vmx kernel: [  595.423279] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:57:35 vmx kernel: [  595.743281] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:35 vmx kernel: [  595.849946] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:38 vmx kernel: [  598.516614] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:38 vmx kernel: [  598.623281] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:39 vmx kernel: [  599.476622] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:57:39 vmx kernel: [  599.583285] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:57:39 vmx kernel: [  599.903282] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:39 vmx kernel: [  600.009947] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:40 vmx kernel: [  600.863281] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:57:40 vmx kernel: [  600.969948] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:57:41 vmx kernel: [  601.290784] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:41 vmx kernel: [  601.396614] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:43 vmx kernel: [  604.063281] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:43 vmx kernel: [  604.169945] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:44 vmx kernel: [  605.023282] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:57:44 vmx kernel: [  605.129948] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:57:45 vmx kernel: [  605.449948] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:45 vmx kernel: [  605.556615] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:46 vmx kernel: [  606.409948] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:57:46 vmx kernel: [  606.516611] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:57:46 vmx kernel: [  606.836613] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:46 vmx kernel: [  606.943278] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:49 vmx kernel: [  609.609949] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:49 vmx kernel: [  609.716611] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:50 vmx kernel: [  610.569947] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:57:50 vmx kernel: [  610.677448] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:57:50 vmx kernel: [  610.996614] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:50 vmx kernel: [  611.103280] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:51 vmx kernel: [  611.956614] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:57:51 vmx kernel: [  612.063278] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:57:52 vmx kernel: [  612.383280] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:52 vmx kernel: [  612.489944] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:54 vmx kernel: [  615.159946] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:55 vmx kernel: [  615.267443] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:55 vmx kernel: [  616.119946] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:57:55 vmx kernel: [  616.226610] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:57:56 vmx kernel: [  616.546613] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:56 vmx kernel: [  616.653280] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:57:57 vmx kernel: [  617.506613] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:57:57 vmx kernel: [  617.613279] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:57:57 vmx kernel: [  617.933276] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:57:57 vmx kernel: [  618.039944] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:00 vmx kernel: [  620.707447] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:00 vmx kernel: [  620.813291] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:01 vmx kernel: [  621.666612] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:58:01 vmx kernel: [  621.773280] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:58:01 vmx kernel: [  622.093282] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:01 vmx kernel: [  622.199943] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:02 vmx kernel: [  623.053280] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:58:02 vmx kernel: [  623.159943] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:58:03 vmx kernel: [  623.479943] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:03 vmx kernel: [  623.586611] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:06 vmx kernel: [  626.253279] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:06 vmx kernel: [  626.359943] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:06 vmx kernel: [  627.213278] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:58:07 vmx kernel: [  627.319943] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:58:07 vmx kernel: [  627.639946] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:07 vmx kernel: [  627.746613] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:08 vmx kernel: [  628.600781] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:58:08 vmx kernel: [  628.706609] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:58:08 vmx kernel: [  629.026609] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:08 vmx kernel: [  629.133278] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:11 vmx kernel: [  631.799944] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:11 vmx kernel: [  631.906609] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:12 vmx kernel: [  632.759945] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:58:12 vmx kernel: [  632.866608] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:58:12 vmx kernel: [  633.186611] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:13 vmx kernel: [  633.293278] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:13 vmx kernel: [  634.146611] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:58:14 vmx kernel: [  634.253275] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:58:14 vmx kernel: [  634.573275] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:14 vmx kernel: [  634.679944] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:17 vmx kernel: [  637.346611] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:17 vmx kernel: [  637.453274] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:18 vmx kernel: [  638.306610] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:58:18 vmx kernel: [  638.413275] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:58:18 vmx kernel: [  638.733277] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:18 vmx kernel: [  638.839941] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:19 vmx kernel: [  639.693277] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:58:19 vmx kernel: [  639.799941] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:58:19 vmx kernel: [  640.119942] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:19 vmx kernel: [  640.226607] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:22 vmx kernel: [  642.893277] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:22 vmx kernel: [  642.999941] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:23 vmx kernel: [  643.853277] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:58:23 vmx kernel: [  643.959945] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:58:24 vmx kernel: [  644.279944] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:24 vmx kernel: [  644.386608] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:24 vmx kernel: [  645.239945] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:58:25 vmx kernel: [  645.346607] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:58:25 vmx kernel: [  645.666611] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:25 vmx kernel: [  645.773274] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:28 vmx kernel: [  648.439944] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:28 vmx kernel: [  648.546614] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:29 vmx kernel: [  649.399945] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:58:29 vmx kernel: [  649.506612] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:58:29 vmx kernel: [  649.826617] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:29 vmx kernel: [  649.933274] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:30 vmx kernel: [  650.786607] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:58:30 vmx kernel: [  650.893273] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:58:30 vmx kernel: [  651.213276] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:31 vmx kernel: [  651.319940] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:33 vmx kernel: [  653.986610] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:33 vmx kernel: [  654.093278] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:34 vmx kernel: [  654.946610] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:58:34 vmx kernel: [  655.053277] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:58:35 vmx kernel: [  655.373273] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:35 vmx kernel: [  655.479939] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:36 vmx kernel: [  656.333276] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:58:36 vmx kernel: [  656.439939] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:58:36 vmx kernel: [  656.759942] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:36 vmx kernel: [  656.866606] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:39 vmx kernel: [  659.533281] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:39 vmx kernel: [  659.639942] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:40 vmx kernel: [  660.493275] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:58:40 vmx kernel: [  660.599942] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:58:40 vmx kernel: [  660.919942] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:40 vmx kernel: [  661.027442] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:41 vmx kernel: [  661.879941] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:58:41 vmx kernel: [  661.986606] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:58:42 vmx kernel: [  662.306609] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:42 vmx kernel: [  662.413273] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:44 vmx kernel: [  665.079942] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:44 vmx kernel: [  665.186606] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:45 vmx kernel: [  666.039941] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:58:45 vmx kernel: [  666.146605] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:58:46 vmx kernel: [  666.467439] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:46 vmx kernel: [  666.573272] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:47 vmx kernel: [  667.426608] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:58:47 vmx kernel: [  667.533791] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:58:47 vmx kernel: [  667.853274] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:47 vmx kernel: [  667.959940] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:50 vmx kernel: [  670.627446] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:50 vmx kernel: [  670.733275] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:51 vmx kernel: [  671.590776] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:58:51 vmx kernel: [  671.693271] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:58:51 vmx kernel: [  672.013274] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:51 vmx kernel: [  672.119941] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:52 vmx kernel: [  672.973274] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:58:52 vmx kernel: [  673.079938] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:58:53 vmx kernel: [  673.399939] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:53 vmx kernel: [  673.507441] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:55 vmx kernel: [  676.174108] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:56 vmx kernel: [  676.279938] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:56 vmx kernel: [  677.133273] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:58:56 vmx kernel: [  677.239937] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:58:57 vmx kernel: [  677.559941] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:57 vmx kernel: [  677.666607] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:58:58 vmx kernel: [  678.519937] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:58:58 vmx kernel: [  678.630777] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:58:58 vmx kernel: [  678.949937] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:58:58 vmx kernel: [  679.056604] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:01 vmx kernel: [  681.723273] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:01 vmx kernel: [  681.829942] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:02 vmx kernel: [  682.684108] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:59:02 vmx kernel: [  682.789940] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:59:02 vmx kernel: [  683.109940] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:02 vmx kernel: [  683.216604] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:03 vmx kernel: [  684.069940] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:59:03 vmx kernel: [  684.176605] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:59:04 vmx kernel: [  684.497441] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:04 vmx kernel: [  684.603274] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:07 vmx kernel: [  687.269939] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:07 vmx kernel: [  687.376603] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:07 vmx kernel: [  688.229939] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:59:08 vmx kernel: [  688.336603] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:59:08 vmx kernel: [  688.656605] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:08 vmx kernel: [  688.763269] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:09 vmx kernel: [  689.616606] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:59:09 vmx kernel: [  689.723269] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:59:09 vmx kernel: [  690.044110] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:09 vmx kernel: [  690.149940] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:12 vmx kernel: [  692.817447] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:12 vmx kernel: [  692.924104] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:13 vmx kernel: [  693.776606] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:59:13 vmx kernel: [  693.883270] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:59:13 vmx kernel: [  694.203272] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:14 vmx kernel: [  694.309945] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:14 vmx kernel: [  695.163272] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:59:15 vmx kernel: [  695.269940] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:59:15 vmx kernel: [  695.590775] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:15 vmx kernel: [  695.696603] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:18 vmx kernel: [  698.363273] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:18 vmx kernel: [  698.469937] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:19 vmx kernel: [  699.323272] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:59:19 vmx kernel: [  699.430774] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:59:19 vmx kernel: [  699.754113] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:19 vmx kernel: [  699.860776] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:20 vmx kernel: [  700.716605] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:59:20 vmx kernel: [  700.823268] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:59:20 vmx kernel: [  701.143271] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:21 vmx kernel: [  701.249935] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:23 vmx kernel: [  703.916604] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:23 vmx kernel: [  704.023268] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:24 vmx kernel: [  704.876601] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:59:24 vmx kernel: [  704.984110] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:59:25 vmx kernel: [  705.303270] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:25 vmx kernel: [  705.409935] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:26 vmx kernel: [  706.264108] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:59:26 vmx kernel: [  706.369939] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:59:26 vmx kernel: [  706.690774] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:26 vmx kernel: [  706.796601] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:29 vmx kernel: [  709.463270] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:29 vmx kernel: [  709.569934] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:30 vmx kernel: [  710.426610] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:59:30 vmx kernel: [  710.533269] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:59:30 vmx kernel: [  710.854104] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:30 vmx kernel: [  710.959936] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:31 vmx kernel: [  711.814106] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:59:31 vmx kernel: [  711.919942] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:59:31 vmx kernel: [  712.239938] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:32 vmx kernel: [  712.346605] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:34 vmx kernel: [  715.013279] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:34 vmx kernel: [  715.119935] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:35 vmx kernel: [  715.973270] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:59:35 vmx kernel: [  716.079934] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:59:36 vmx kernel: [  716.400772] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:36 vmx kernel: [  716.507442] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:37 vmx kernel: [  717.359936] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:59:37 vmx kernel: [  717.466603] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:59:37 vmx kernel: [  717.786604] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:37 vmx kernel: [  717.893267] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:40 vmx kernel: [  720.559937] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:40 vmx kernel: [  720.666604] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:41 vmx kernel: [  721.519936] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:59:41 vmx kernel: [  721.626600] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:59:41 vmx kernel: [  721.946621] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:41 vmx kernel: [  722.053272] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:42 vmx kernel: [  722.906601] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:59:42 vmx kernel: [  723.013266] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:59:43 vmx kernel: [  723.333267] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:43 vmx kernel: [  723.439934] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:45 vmx kernel: [  726.106602] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:45 vmx kernel: [  726.213266] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:46 vmx kernel: [  727.066601] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:59:46 vmx kernel: [  727.173266] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:59:47 vmx kernel: [  727.493266] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:47 vmx kernel: [  727.600768] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:48 vmx kernel: [  728.453266] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:59:48 vmx kernel: [  728.559932] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:59:48 vmx kernel: [  728.879934] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:48 vmx kernel: [  728.986599] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:51 vmx kernel: [  731.653268] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:51 vmx kernel: [  731.759932] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:52 vmx kernel: [  732.613269] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:59:52 vmx kernel: [  732.719932] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:59:52 vmx kernel: [  733.039932] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:52 vmx kernel: [  733.146598] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:53 vmx kernel: [  733.999934] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:59:53 vmx kernel: [  734.106598] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:59:54 vmx kernel: [  734.426598] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:54 vmx kernel: [  734.533265] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:56 vmx kernel: [  737.199937] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:57 vmx kernel: [  737.307431] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:57 vmx kernel: [  738.159933] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:59:58 vmx kernel: [  738.266598] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:59:58 vmx kernel: [  738.587434] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:58 vmx kernel: [  738.693266] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 11:59:59 vmx kernel: [  739.546598] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 11:59:59 vmx kernel: [  739.653267] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 11:59:59 vmx kernel: [  739.973264] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 11:59:59 vmx kernel: [  740.079932] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:02 vmx kernel: [  742.746600] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:02 vmx kernel: [  742.853264] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:03 vmx kernel: [  743.706600] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:00:03 vmx kernel: [  743.813264] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:00:03 vmx kernel: [  744.133264] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:03 vmx kernel: [  744.239930] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:04 vmx kernel: [  745.093266] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:00:04 vmx kernel: [  745.199931] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:00:05 vmx kernel: [  745.519930] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:05 vmx kernel: [  745.626599] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:08 vmx kernel: [  748.296599] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:08 vmx kernel: [  748.404096] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:09 vmx kernel: [  749.256602] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:00:09 vmx kernel: [  749.363263] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:00:09 vmx kernel: [  749.683266] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:09 vmx kernel: [  749.789930] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:10 vmx kernel: [  750.643267] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:00:10 vmx kernel: [  750.749930] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:00:10 vmx kernel: [  751.069930] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:10 vmx kernel: [  751.176597] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:13 vmx kernel: [  753.843266] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:13 vmx kernel: [  753.949930] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:14 vmx kernel: [  754.804098] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:00:14 vmx kernel: [  754.909930] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:00:14 vmx kernel: [  755.229931] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:15 vmx kernel: [  755.336596] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:15 vmx kernel: [  756.189930] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:00:16 vmx kernel: [  756.296596] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:00:16 vmx kernel: [  756.616598] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:16 vmx kernel: [  756.723263] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:19 vmx kernel: [  759.389932] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:19 vmx kernel: [  759.496596] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:20 vmx kernel: [  760.349932] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:00:20 vmx kernel: [  760.456596] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:00:20 vmx kernel: [  760.776598] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:20 vmx kernel: [  760.883263] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:21 vmx kernel: [  761.736598] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:00:21 vmx kernel: [  761.843263] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:00:21 vmx kernel: [  762.163262] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:22 vmx kernel: [  762.269929] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:24 vmx kernel: [  764.936598] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:24 vmx kernel: [  765.043262] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:25 vmx kernel: [  765.896598] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:00:25 vmx kernel: [  766.004096] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:00:26 vmx kernel: [  766.323262] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:26 vmx kernel: [  766.429928] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:27 vmx kernel: [  767.283264] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:00:27 vmx kernel: [  767.389929] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:00:27 vmx kernel: [  767.709931] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:27 vmx kernel: [  767.816595] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:30 vmx kernel: [  770.483264] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:30 vmx kernel: [  770.590765] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:31 vmx kernel: [  771.443263] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:00:31 vmx kernel: [  771.549928] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:00:31 vmx kernel: [  771.869930] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:31 vmx kernel: [  771.976595] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:32 vmx kernel: [  772.829930] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:00:32 vmx kernel: [  772.936594] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:00:33 vmx kernel: [  773.257428] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:33 vmx kernel: [  773.363261] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:35 vmx kernel: [  776.029930] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:35 vmx kernel: [  776.136594] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:36 vmx kernel: [  776.989929] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:00:36 vmx kernel: [  777.096594] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:00:37 vmx kernel: [  777.416594] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:37 vmx kernel: [  777.523260] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:38 vmx kernel: [  778.376596] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:00:38 vmx kernel: [  778.483260] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:00:38 vmx kernel: [  778.804095] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:38 vmx kernel: [  778.909927] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:41 vmx kernel: [  781.576595] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:41 vmx kernel: [  781.683263] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:42 vmx kernel: [  782.536594] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:00:42 vmx kernel: [  782.643262] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:00:42 vmx kernel: [  782.963260] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:42 vmx kernel: [  783.069927] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:43 vmx kernel: [  783.923261] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:00:43 vmx kernel: [  784.029927] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:00:44 vmx kernel: [  784.349927] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:44 vmx kernel: [  784.456593] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:46 vmx kernel: [  787.126595] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:46 vmx kernel: [  787.233260] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:47 vmx kernel: [  788.086595] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:00:47 vmx kernel: [  788.193260] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:00:48 vmx kernel: [  788.513259] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:48 vmx kernel: [  788.619928] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:49 vmx kernel: [  789.473260] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:00:49 vmx kernel: [  789.579926] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:00:49 vmx kernel: [  789.899928] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:49 vmx kernel: [  790.007426] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:52 vmx kernel: [  792.673270] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:52 vmx kernel: [  792.779926] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:53 vmx kernel: [  793.633262] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:00:53 vmx kernel: [  793.739959] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:00:53 vmx kernel: [  794.060769] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:53 vmx kernel: [  794.166594] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:54 vmx kernel: [  795.019930] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:00:54 vmx kernel: [  795.126593] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:00:55 vmx kernel: [  795.446595] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:55 vmx kernel: [  795.553259] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:57 vmx kernel: [  798.220767] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:58 vmx kernel: [  798.326596] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:00:58 vmx kernel: [  799.183261] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:00:59 vmx kernel: [  799.289933] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:00:59 vmx kernel: [  799.610789] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:00:59 vmx kernel: [  799.716593] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:00 vmx kernel: [  800.570792] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:01:00 vmx kernel: [  800.676595] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:01:00 vmx kernel: [  800.997451] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:00 vmx kernel: [  801.104136] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:03 vmx kernel: [  803.769927] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:03 vmx kernel: [  803.876597] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:04 vmx kernel: [  804.730765] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:01:04 vmx kernel: [  804.837428] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:01:04 vmx kernel: [  805.156596] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:05 vmx kernel: [  805.263259] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:05 vmx kernel: [  806.116594] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:01:05 vmx kernel: [  806.223259] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:01:06 vmx kernel: [  806.543267] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:06 vmx kernel: [  806.650764] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:09 vmx kernel: [  809.334095] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:09 vmx kernel: [  809.439925] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:10 vmx kernel: [  810.293260] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:01:10 vmx kernel: [  810.399924] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:01:10 vmx kernel: [  810.719926] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:10 vmx kernel: [  810.826594] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:11 vmx kernel: [  811.679927] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:01:11 vmx kernel: [  811.786590] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:01:11 vmx kernel: [  812.106590] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:11 vmx kernel: [  812.214091] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:14 vmx kernel: [  814.879927] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:14 vmx kernel: [  814.986591] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:15 vmx kernel: [  815.839926] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:01:15 vmx kernel: [  815.946590] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:01:16 vmx kernel: [  816.266590] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:16 vmx kernel: [  816.373257] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:16 vmx kernel: [  817.226593] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:01:17 vmx kernel: [  817.333256] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:01:17 vmx kernel: [  817.653259] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:17 vmx kernel: [  817.759923] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:20 vmx kernel: [  820.426592] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:20 vmx kernel: [  820.533256] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:21 vmx kernel: [  821.386593] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:01:21 vmx kernel: [  821.493257] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:01:21 vmx kernel: [  821.814094] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:21 vmx kernel: [  821.919924] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:22 vmx kernel: [  822.780769] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:01:22 vmx kernel: [  822.884096] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:01:22 vmx kernel: [  823.207426] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:23 vmx kernel: [  823.313260] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:25 vmx kernel: [  825.979932] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:25 vmx kernel: [  826.086595] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:26 vmx kernel: [  826.947427] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:01:26 vmx kernel: [  827.053257] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:01:27 vmx kernel: [  827.373261] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:27 vmx kernel: [  827.479923] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:28 vmx kernel: [  828.333264] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:01:28 vmx kernel: [  828.439923] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:01:28 vmx kernel: [  828.759925] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:28 vmx kernel: [  828.866589] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:31 vmx kernel: [  831.533264] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:31 vmx kernel: [  831.639925] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:32 vmx kernel: [  832.493258] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:01:32 vmx kernel: [  832.600759] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:01:32 vmx kernel: [  832.919925] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:32 vmx kernel: [  833.026589] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:33 vmx kernel: [  833.879925] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:01:33 vmx kernel: [  833.986589] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:01:34 vmx kernel: [  834.306591] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:34 vmx kernel: [  834.413255] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:36 vmx kernel: [  837.079922] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:36 vmx kernel: [  837.186588] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:37 vmx kernel: [  838.039931] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:01:37 vmx kernel: [  838.146598] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:01:38 vmx kernel: [  838.467427] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:38 vmx kernel: [  838.573259] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:39 vmx kernel: [  839.426591] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:01:39 vmx kernel: [  839.533261] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:01:39 vmx kernel: [  839.853255] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:39 vmx kernel: [  839.959921] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:42 vmx kernel: [  842.626588] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:42 vmx kernel: [  842.733253] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:43 vmx kernel: [  843.586589] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:01:43 vmx kernel: [  843.693255] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:01:43 vmx kernel: [  844.013254] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:43 vmx kernel: [  844.119920] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:44 vmx kernel: [  844.973254] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:01:44 vmx kernel: [  845.079920] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:01:45 vmx kernel: [  845.399921] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:45 vmx kernel: [  845.506587] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:47 vmx kernel: [  848.173256] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:48 vmx kernel: [  848.279922] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:48 vmx kernel: [  849.133256] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:01:48 vmx kernel: [  849.239921] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:01:49 vmx kernel: [  849.559923] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:49 vmx kernel: [  849.666590] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:50 vmx kernel: [  850.519923] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:01:50 vmx kernel: [  850.626589] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:01:50 vmx kernel: [  850.946587] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:50 vmx kernel: [  851.053254] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:53 vmx kernel: [  853.719923] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:53 vmx kernel: [  853.826586] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:54 vmx kernel: [  854.679923] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:01:54 vmx kernel: [  854.786592] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:01:54 vmx kernel: [  855.106587] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:54 vmx kernel: [  855.213253] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:55 vmx kernel: [  856.066589] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:01:55 vmx kernel: [  856.173253] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:01:56 vmx kernel: [  856.493253] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:56 vmx kernel: [  856.599927] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:59 vmx kernel: [  859.266589] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:01:59 vmx kernel: [  859.373253] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:01:59 vmx kernel: [  860.226591] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:02:00 vmx kernel: [  860.333252] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:02:00 vmx kernel: [  860.653255] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:00 vmx kernel: [  860.759919] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:01 vmx kernel: [  861.613258] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:02:01 vmx kernel: [  861.720756] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:02:01 vmx kernel: [  862.039922] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:01 vmx kernel: [  862.146586] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:04 vmx kernel: [  864.813255] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:04 vmx kernel: [  864.919919] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:05 vmx kernel: [  865.773255] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:02:05 vmx kernel: [  865.879918] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:02:05 vmx kernel: [  866.199921] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:06 vmx kernel: [  866.306586] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:06 vmx kernel: [  867.159921] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:02:07 vmx kernel: [  867.267419] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:02:07 vmx kernel: [  867.587425] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:07 vmx kernel: [  867.693264] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:10 vmx kernel: [  870.359921] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:10 vmx kernel: [  870.466585] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:11 vmx kernel: [  871.319923] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:02:11 vmx kernel: [  871.426585] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:02:11 vmx kernel: [  871.746585] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:11 vmx kernel: [  871.853254] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:12 vmx kernel: [  872.706587] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:02:12 vmx kernel: [  872.813254] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:02:12 vmx kernel: [  873.133250] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:12 vmx kernel: [  873.239918] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:15 vmx kernel: [  875.906587] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:15 vmx kernel: [  876.013251] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:16 vmx kernel: [  876.867421] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:02:16 vmx kernel: [  876.973251] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:02:17 vmx kernel: [  877.293254] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:17 vmx kernel: [  877.399918] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:18 vmx kernel: [  878.253253] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:02:18 vmx kernel: [  878.359918] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:02:18 vmx kernel: [  878.679920] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:18 vmx kernel: [  878.786590] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:21 vmx kernel: [  881.454087] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:21 vmx kernel: [  881.559919] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:22 vmx kernel: [  882.413253] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:02:22 vmx kernel: [  882.520769] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:02:22 vmx kernel: [  882.840758] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:22 vmx kernel: [  882.946586] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:23 vmx kernel: [  883.799918] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:02:23 vmx kernel: [  883.906583] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:02:23 vmx kernel: [  884.227424] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:24 vmx kernel: [  884.333252] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:26 vmx kernel: [  886.999917] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:26 vmx kernel: [  887.106588] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:27 vmx kernel: [  887.959920] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:02:27 vmx kernel: [  888.066583] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:02:28 vmx kernel: [  888.387419] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:28 vmx kernel: [  888.494087] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:29 vmx kernel: [  889.346587] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:02:29 vmx kernel: [  889.453250] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:02:29 vmx kernel: [  889.773251] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:29 vmx kernel: [  889.879916] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:32 vmx kernel: [  892.549918] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:32 vmx kernel: [  892.656584] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:33 vmx kernel: [  893.509918] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:02:33 vmx kernel: [  893.617417] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:02:33 vmx kernel: [  893.936585] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:33 vmx kernel: [  894.043251] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:34 vmx kernel: [  894.897418] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:02:34 vmx kernel: [  895.004082] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:02:35 vmx kernel: [  895.323252] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:35 vmx kernel: [  895.429916] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:37 vmx kernel: [  898.096586] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:37 vmx kernel: [  898.203252] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:38 vmx kernel: [  899.056585] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:02:38 vmx kernel: [  899.163248] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:02:39 vmx kernel: [  899.483252] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:39 vmx kernel: [  899.590753] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:40 vmx kernel: [  900.444102] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:02:40 vmx kernel: [  900.549916] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:02:40 vmx kernel: [  900.869918] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:40 vmx kernel: [  900.976582] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:43 vmx kernel: [  903.643252] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:43 vmx kernel: [  903.749919] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:44 vmx kernel: [  904.603289] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:02:44 vmx kernel: [  904.709915] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:02:44 vmx kernel: [  905.029918] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:44 vmx kernel: [  905.136585] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:45 vmx kernel: [  905.989917] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:02:45 vmx kernel: [  906.096581] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:02:46 vmx kernel: [  906.416582] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:46 vmx kernel: [  906.523248] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:48 vmx kernel: [  909.189917] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:49 vmx kernel: [  909.296583] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:49 vmx kernel: [  910.149919] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:02:50 vmx kernel: [  910.256581] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:02:50 vmx kernel: [  910.576581] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:50 vmx kernel: [  910.683249] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:51 vmx kernel: [  911.536581] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:02:51 vmx kernel: [  911.643249] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:02:51 vmx kernel: [  911.963250] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:51 vmx kernel: [  912.069914] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:54 vmx kernel: [  914.736585] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:54 vmx kernel: [  914.843250] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:55 vmx kernel: [  915.696583] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:02:55 vmx kernel: [  915.803248] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:02:55 vmx kernel: [  916.123249] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:55 vmx kernel: [  916.229915] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:56 vmx kernel: [  917.083249] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:02:56 vmx kernel: [  917.189914] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:02:57 vmx kernel: [  917.509918] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:02:57 vmx kernel: [  917.617420] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:02:59 vmx kernel: [  919.749917] i2c IR (Pinnacle PCTV): unknown key: key=0x5c raw=0x5c down=1
Oct  3 12:02:59 vmx kernel: [  919.856583] i2c IR (Pinnacle PCTV): unknown key: key=0x5c raw=0x5c down=0
Oct  3 12:03:00 vmx kernel: [  920.283253] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:03:00 vmx kernel: [  920.389913] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:03:00 vmx kernel: [  921.243251] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:03:01 vmx kernel: [  921.349914] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:03:01 vmx kernel: [  921.670754] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:03:01 vmx kernel: [  921.776585] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:03:02 vmx kernel: [  922.629917] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:03:02 vmx kernel: [  922.736581] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:03:02 vmx kernel: [  923.056583] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:03:02 vmx kernel: [  923.163246] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:03:05 vmx kernel: [  925.833254] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:03:05 vmx kernel: [  925.939918] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:03:06 vmx kernel: [  926.793248] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:03:06 vmx kernel: [  926.899912] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:03:06 vmx kernel: [  927.219924] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:03:07 vmx kernel: [  927.327415] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:03:07 vmx kernel: [  928.179916] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:03:08 vmx kernel: [  928.286580] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:03:08 vmx kernel: [  928.606583] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:03:08 vmx kernel: [  928.713249] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:03:11 vmx kernel: [  931.379915] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:03:11 vmx kernel: [  931.486579] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:03:12 vmx kernel: [  932.339914] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:03:12 vmx kernel: [  932.446580] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:03:12 vmx kernel: [  932.766581] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:03:12 vmx kernel: [  932.873245] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:03:13 vmx kernel: [  933.726580] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:03:13 vmx kernel: [  933.833245] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:03:13 vmx kernel: [  934.153246] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:03:14 vmx kernel: [  934.259912] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:03:16 vmx kernel: [  936.926581] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:03:16 vmx kernel: [  937.033246] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:03:17 vmx kernel: [  937.886581] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:03:17 vmx kernel: [  937.993245] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:03:18 vmx kernel: [  938.313245] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:03:18 vmx kernel: [  938.419914] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:03:19 vmx kernel: [  939.273249] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=1
Oct  3 12:03:19 vmx kernel: [  939.379955] i2c IR (Pinnacle PCTV): unknown key: key=0x24 raw=0x24 down=0
Oct  3 12:03:19 vmx kernel: [  939.699914] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:03:19 vmx kernel: [  939.806578] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0
Oct  3 12:03:22 vmx kernel: [  942.473248] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=1
Oct  3 12:03:22 vmx kernel: [  942.579917] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12 down=0

--Boundary-00=_kKyxKId30nsTw3M--
