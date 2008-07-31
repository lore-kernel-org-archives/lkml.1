Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbYGaNEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbYGaNEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 09:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbYGaNE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 09:04:29 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59625 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbYGaNEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 09:04:21 -0400
To: linux-ide@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [bug] 2.6.27-rc1: I/O errors after resume
References: <200807281203.38822.j.schneider@uib.de> <20080730011223.8f04ba20.akpm@linux-foundation.org>
Message-Id: <E1KOXpA-00005w-Vl@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 31 Jul 2008 15:04:08 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.27-rc1 things break badly after resume on my T60.  Dmesg and
config attached.  2.6.26 worked fine.

Miklos


[    0.000000] Linux version 2.6.27-rc1-dirty (mszeredi@tucsk) (gcc version 4.2.1 (SUSE Linux)) #16 SMP Wed Jul 30 10:14:24 CEST 2008
[    0.000000] Command line: root=/dev/sda2 vga=0x365
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bfed0000 (usable)
[    0.000000]  BIOS-e820: 00000000bfed0000 - 00000000bfedf000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfedf000 - 00000000bff00000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bff00000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000] last_pfn = 0xbfed0 max_arch_pfn = 0x3ffffffff
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] init_memory_mapping
[    0.000000]  0000000000 - 00bfe00000 page 2M
[    0.000000]  00bfe00000 - 00bfed0000 page 4k
[    0.000000] kernel direct mapping tables up to bfed0000 @ 8000-d000
[    0.000000] last_map_addr: bfed0000 end: bfed0000
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F67E0, 0024 (r2 LENOVO)
[    0.000000] ACPI: XSDT BFED13C7, 008C (r1 LENOVO TP-79        2190  LTP        0)
[    0.000000] ACPI: FACP BFED1500, 00F4 (r3 LENOVO TP-79        2190 LNVO        1)
[    0.000000] ACPI Warning (tbfadt-0442): Optional field "Gpe1Block" has zero address or length: 000000000000102C/0 [20080609]
[    0.000000] ACPI: DSDT BFED185E, D3C2 (r1 LENOVO TP-79        2190 MSFT  100000E)
[    0.000000] ACPI: FACS BFEF4000, 0040
[    0.000000] ACPI: SSDT BFED16B4, 01AA (r1 LENOVO TP-79        2190 MSFT  100000E)
[    0.000000] ACPI: ECDT BFEDEC20, 0052 (r1 LENOVO TP-79        2190 LNVO        1)
[    0.000000] ACPI: TCPA BFEDEC72, 0032 (r2 LENOVO TP-79        2190 LNVO        1)
[    0.000000] ACPI: APIC BFEDECA4, 0068 (r1 LENOVO TP-79        2190 LNVO        1)
[    0.000000] ACPI: MCFG BFEDED0C, 003C (r1 LENOVO TP-79        2190 LNVO        1)
[    0.000000] ACPI: HPET BFEDED48, 0038 (r1 LENOVO TP-79        2190 LNVO        1)
[    0.000000] ACPI: SLIC BFEDEE62, 0176 (r1 LENOVO TP-79        2190  LTP        0)
[    0.000000] ACPI: BOOT BFEDEFD8, 0028 (r1 LENOVO TP-79        2190  LTP        1)
[    0.000000] ACPI: SSDT BFEF2655, 025F (r1 LENOVO TP-79        2190 INTL 20050513)
[    0.000000] ACPI: SSDT BFEF28B4, 00A6 (r1 LENOVO TP-79        2190 INTL 20050513)
[    0.000000] ACPI: SSDT BFEF295A, 04F7 (r1 LENOVO TP-79        2190 INTL 20050513)
[    0.000000] ACPI: SSDT BFEF2E51, 01D8 (r1 LENOVO TP-79        2190 INTL 20050513)
[    0.000000] (5 early reservations) ==> bootmem [0000000000 - 00bfed0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 0000c2bc98]    TEXT DATA BSS ==> [0000200000 - 0000c2bc98]
[    0.000000]   #3 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
[    0.000000]   #4 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
[    0.000000] Scan SMP from ffff880000000000 for 1024 bytes.
[    0.000000] Scan SMP from ffff88000009fc00 for 1024 bytes.
[    0.000000] Scan SMP from ffff8800000f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [ffff8800000f6810] 000f6810
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000bfed0
[    0.000000] On node 0 totalpages: 786031
[    0.000000]   DMA zone: 1235 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 771340 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] Allocating PCI resources starting at c4000000 (gap: c0000000:30000000)
[    0.000000] PERCPU: Allocating 435200 bytes of per cpu data
[    0.000000] NR_CPUS: 2, nr_cpu_ids: 2, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 772575
[    0.000000] Kernel command line: root=/dev/sda2 vga=0x365
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] Detected 1828.742 MHz processor.
[    0.008000] Console: colour dummy device 80x25
[    0.008000] console [tty0] enabled
[    0.008000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.008000] ... MAX_LOCKDEP_SUBCLASSES:    8
[    0.008000] ... MAX_LOCK_DEPTH:          48
[    0.008000] ... MAX_LOCKDEP_KEYS:        2048
[    0.008000] ... CLASSHASH_SIZE:           1024
[    0.008000] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.008000] ... MAX_LOCKDEP_CHAINS:      16384
[    0.008000] ... CHAINHASH_SIZE:          8192
[    0.008000]  memory used by lock dependency info: 1840 kB
[    0.008000]  per task-struct memory footprint: 3456 bytes
[    0.008000] ------------------------
[    0.008000] | Locking API testsuite:
[    0.008000] ----------------------------------------------------------------------------
[    0.008000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.008000]   --------------------------------------------------------------------------
[    0.008000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.008000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.008000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.008000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.008000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.008000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.008000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.008000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.008000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.008000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.008000]   --------------------------------------------------------------------------
[    0.008000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.008000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.008000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.008000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.008000]   --------------------------------------------------------------------------
[    0.008000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.008000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.008000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.008000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.008000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.008000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.008000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.008000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.008000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.008000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.008000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.008000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.008000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.008000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.008000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.008000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.008000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.008000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.008000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.008000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.008000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.008000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.008000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.008000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.008000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.008000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.008000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.008000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.008000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.008000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.008000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.008000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.008000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.008000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.008000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.008000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.008000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.008000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.008000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.008000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.008000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.008000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.008000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.008000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.008000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.008000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.008000]       hard-irq read-recursion/123:  ok  |
[    0.008000]       soft-irq read-recursion/123:  ok  |
[    0.008000]       hard-irq read-recursion/132:  ok  |
[    0.008000]       soft-irq read-recursion/132:  ok  |
[    0.008000]       hard-irq read-recursion/213:  ok  |
[    0.008000]       soft-irq read-recursion/213:  ok  |
[    0.008000]       hard-irq read-recursion/231:  ok  |
[    0.008000]       soft-irq read-recursion/231:  ok  |
[    0.008000]       hard-irq read-recursion/312:  ok  |
[    0.008000]       soft-irq read-recursion/312:  ok  |
[    0.008000]       hard-irq read-recursion/321:  ok  |
[    0.008000]       soft-irq read-recursion/321:  ok  |
[    0.008000] -------------------------------------------------------
[    0.008000] Good, all 218 testcases passed! |
[    0.008000] ---------------------------------
[    0.008000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.008000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.008000] Checking aperture...
[    0.008000] No AGP bridge found
[    0.008000] Memory: 3083172k/3144512k available (2670k kernel code, 60808k reserved, 1510k data, 648k init)
[    0.008000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.008000] hpet clockevent registered
[    0.008000] Calibrating delay loop (skipped), value calculated using timer frequency.. <6>3657.48 BogoMIPS (lpj=7314968)
[    0.008000] Mount-cache hash table entries: 256
[    0.008000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.008000] CPU: L2 cache: 2048K
[    0.008000] CPU: Physical Processor ID: 0
[    0.008000] CPU: Processor Core ID: 0
[    0.008000] CPU0: Thermal monitoring enabled (TM2)
[    0.008000] using mwait in idle threads.
[    0.008000] ACPI: Core revision 20080609
[    0.052003] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.092005] CPU0: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 06
[    0.092005] Using local APIC timer interrupts.
[    0.096006] APIC timer calibration result 10390579
[    0.096006] Detected 10.390 MHz APIC timer.
[    0.096006] lockdep: fixing up alternatives.
[    0.096006] Booting processor 1/1 ip 6000
[    0.104006] Initializing CPU#1
[    0.184055] Calibrating delay using timer specific routine.. <6>3657.56 BogoMIPS (lpj=7315124)
[    0.184063] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.184065] CPU: L2 cache: 2048K
[    0.184068] CPU: Physical Processor ID: 0
[    0.184069] CPU: Processor Core ID: 1
[    0.184076] CPU1: Thermal monitoring enabled (TM2)
[    0.184756] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.186786] CPU1: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 06
[    0.186847] checking TSC synchronization [CPU#0 -> CPU#1]:
[    0.188011] Measured 566258 cycles TSC warp between CPUs, turning off TSC clock.
[    0.188011] Marking TSC unstable due to check_tsc_sync_source failed
[    0.188068] Brought up 2 CPUs
[    0.188072] Total of 2 processors activated (7315.04 BogoMIPS).
[    0.188147] CPU0 attaching sched-domain:
[    0.188149]  domain 0: span 0-1 level MC
[    0.188151]   groups: 0 1
[    0.188162] CPU1 attaching sched-domain:
[    0.188163]  domain 0: span 0-1 level MC
[    0.188164]   groups: 1 0
[    0.188869] net_namespace: 1312 bytes
[    0.189191] NET: Registered protocol family 16
[    0.192523] ACPI: ACPI Dock Station Driver
[    0.193429] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.193483] ACPI: bus type pci registered
[    0.194218] PCI: Using configuration type 1 for base access
[    0.210706] ACPI: EC: EC description table is found, configuring boot EC
[    0.240681] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.254379] ACPI: Interpreter enabled
[    0.254387] ACPI: (supports S0 S3 S5)
[    0.254452] ACPI: Using IOAPIC for interrupt routing
[    0.289905] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
[    0.289915] ACPI: EC: driver started in interrupt mode
[    0.290289] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.290810] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.290821] pci 0000:00:01.0: PME# disabled
[    0.291049] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.291061] pci 0000:00:1b.0: PME# disabled
[    0.291191] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.291202] pci 0000:00:1c.0: PME# disabled
[    0.291326] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.291338] pci 0000:00:1c.1: PME# disabled
[    0.291461] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.291472] pci 0000:00:1c.2: PME# disabled
[    0.291600] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.291611] pci 0000:00:1c.3: PME# disabled
[    0.292240] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.292253] pci 0000:00:1d.7: PME# disabled
[    0.292520] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[    0.292533] pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
[    0.292834] pci 0000:00:1f.2: PME# supported from D3hot
[    0.292845] pci 0000:00:1f.2: PME# disabled
[    0.293357] pci 0000:01:00.0: supports D1
[    0.293359] pci 0000:01:00.0: supports D2
[    0.293779] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.293793] pci 0000:02:00.0: PME# disabled
[    0.294365] pci 0000:03:00.0: PME# supported from D0 D3hot
[    0.294384] pci 0000:03:00.0: PME# disabled
[    0.294855] pci 0000:15:00.0: supports D1
[    0.294858] pci 0000:15:00.0: supports D2
[    0.294860] pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.294873] pci 0000:15:00.0: PME# disabled
[    0.294970] pci 0000:00:1e.0: transparent bridge
[    0.295114] bus 00 -> node 0
[    0.295129] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.295881] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    0.296167] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.296502] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.296835] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    0.297175] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.297516] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.314373] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.314803] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.315230] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.315655] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.316091] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.316516] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.316944] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.317370] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.318429] ACPI: Power Resource [PUBS] (on)
[    0.319018] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.319191] pnp: PnP ACPI init
[    0.319234] ACPI: bus type pnp registered
[    0.330068] pnp: PnP ACPI: found 12 devices
[    0.330078] ACPI: ACPI bus type pnp unregistered
[    0.331122] SCSI subsystem initialized
[    0.331372] libata version 3.00 loaded.
[    0.331956] usbcore: registered new interface driver usbfs
[    0.332332] usbcore: registered new interface driver hub
[    0.332581] usbcore: registered new device driver usb
[    0.333462] PCI: Using ACPI for IRQ routing
[    0.352014] PCI-GART: No AMD northbridge found.
[    0.352027] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.352037] hpet0: 3 64-bit timers, 14318180 Hz
[    0.355932] Switched to high resolution mode on CPU 0
[    0.356589] Switched to high resolution mode on CPU 1
[    0.367960] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.367970] system 00:00: iomem range 0xc0000-0xc3fff has been reserved
[    0.367980] system 00:00: iomem range 0xc4000-0xc7fff has been reserved
[    0.367989] system 00:00: iomem range 0xc8000-0xcbfff has been reserved
[    0.367998] system 00:00: iomem range 0xcc000-0xcffff has been reserved
[    0.368007] system 00:00: iomem range 0xd0000-0xd3fff could not be reserved
[    0.368017] system 00:00: iomem range 0xdc000-0xdffff could not be reserved
[    0.368027] system 00:00: iomem range 0xe0000-0xe3fff could not be reserved
[    0.368037] system 00:00: iomem range 0xe4000-0xe7fff could not be reserved
[    0.368046] system 00:00: iomem range 0xe8000-0xebfff could not be reserved
[    0.368056] system 00:00: iomem range 0xec000-0xeffff could not be reserved
[    0.368065] system 00:00: iomem range 0xf0000-0xfffff could not be reserved
[    0.368075] system 00:00: iomem range 0x100000-0xbfffffff could not be reserved
[    0.368086] system 00:00: iomem range 0xfec00000-0xfed3ffff could not be reserved
[    0.368096] system 00:00: iomem range 0xfed41000-0xffffffff could not be reserved
[    0.368128] system 00:02: ioport range 0x164e-0x164f has been reserved
[    0.368137] system 00:02: ioport range 0x1000-0x107f has been reserved
[    0.368146] system 00:02: ioport range 0x1180-0x11bf has been reserved
[    0.368155] system 00:02: ioport range 0x800-0x80f has been reserved
[    0.368163] system 00:02: ioport range 0x15e0-0x15ef has been reserved
[    0.368173] system 00:02: ioport range 0x1600-0x165f could not be reserved
[    0.368183] system 00:02: iomem range 0xf0000000-0xf3ffffff could not be reserved
[    0.368194] system 00:02: iomem range 0xfed1c000-0xfed1ffff could not be reserved
[    0.368205] system 00:02: iomem range 0xfed14000-0xfed17fff could not be reserved
[    0.368215] system 00:02: iomem range 0xfed18000-0xfed18fff could not be reserved
[    0.368226] system 00:02: iomem range 0xfed19000-0xfed19fff could not be reserved
[    0.371100] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.371110] pci 0000:00:01.0:   IO window: 0x2000-0x2fff
[    0.371121] pci 0000:00:01.0:   MEM window: 0xee100000-0xee1fffff
[    0.371132] pci 0000:00:01.0:   PREFETCH window: 0x000000d8000000-0x000000dfffffff
[    0.371147] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.371156] pci 0000:00:1c.0:   IO window: 0x3000-0x3fff
[    0.371169] pci 0000:00:1c.0:   MEM window: 0xee000000-0xee0fffff
[    0.371180] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.371196] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.371205] pci 0000:00:1c.1:   IO window: 0x4000-0x5fff
[    0.371218] pci 0000:00:1c.1:   MEM window: 0xec000000-0xedffffff
[    0.371230] pci 0000:00:1c.1:   PREFETCH window: 0x000000e4000000-0x000000e40fffff
[    0.371248] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:04
[    0.371257] pci 0000:00:1c.2:   IO window: 0x6000-0x7fff
[    0.371270] pci 0000:00:1c.2:   MEM window: 0xe8000000-0xe9ffffff
[    0.371281] pci 0000:00:1c.2:   PREFETCH window: 0x000000e4100000-0x000000e41fffff
[    0.371299] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:0c
[    0.371308] pci 0000:00:1c.3:   IO window: 0x8000-0x9fff
[    0.371321] pci 0000:00:1c.3:   MEM window: 0xea000000-0xebffffff
[    0.371332] pci 0000:00:1c.3:   PREFETCH window: 0x000000e4200000-0x000000e42fffff
[    0.371357] pci 0000:15:00.0: CardBus bridge, secondary bus 0000:16
[    0.371364] pci 0000:15:00.0:   IO window: 0x00a000-0x00a0ff
[    0.371377] pci 0000:15:00.0:   IO window: 0x00a400-0x00a4ff
[    0.371389] pci 0000:15:00.0:   PREFETCH window: 0xe0000000-0xe3ffffff
[    0.371402] pci 0000:15:00.0:   MEM window: 0xc4000000-0xc7ffffff
[    0.371414] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:15
[    0.371423] pci 0000:00:1e.0:   IO window: 0xa000-0xdfff
[    0.371436] pci 0000:00:1e.0:   MEM window: 0xe4300000-0xe7ffffff
[    0.371448] pci 0000:00:1e.0:   PREFETCH window: 0x000000e0000000-0x000000e3ffffff
[    0.371483] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.371494] pci 0000:00:01.0: setting latency timer to 64
[    0.371512] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.371523] pci 0000:00:1c.0: setting latency timer to 64
[    0.371541] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.371553] pci 0000:00:1c.1: setting latency timer to 64
[    0.371570] pci 0000:00:1c.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    0.371582] pci 0000:00:1c.2: setting latency timer to 64
[    0.371599] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.371611] pci 0000:00:1c.3: setting latency timer to 64
[    0.371620] pci 0000:00:1e.0: enabling device (0005 -> 0007)
[    0.371633] pci 0000:00:1e.0: setting latency timer to 64
[    0.371651] pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.371789] NET: Registered protocol family 2
[    0.416233] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.418053] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.421280] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
[    0.427554] TCP: Hash tables configured (established 262144 bind 65536)
[    0.427616] TCP reno registered
[    0.436315] NET: Registered protocol family 1
[    0.436982] Simple Boot Flag at 0x35 set to 0x1
[    0.443600] msgmni has been set to 6022
[    0.444134] io scheduler noop registered
[    0.444205] io scheduler cfq registered (default)
[    0.444258] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x2000
[    0.444261] pci 0000:00:1d.0: Performing full reset
[    0.444286] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x2000
[    0.444289] pci 0000:00:1d.1: Performing full reset
[    0.444314] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x2000
[    0.444316] pci 0000:00:1d.2: Performing full reset
[    0.444340] pci 0000:00:1d.3: uhci_check_and_reset_hc: legsup = 0x2000
[    0.444343] pci 0000:00:1d.3: Performing full reset
[    0.444427] pci 0000:01:00.0: Boot video device
[    0.444888] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    0.444971] pcieport-driver 0000:00:01.0: found MSI capability
[    0.445010] pci_express 0000:00:01.0:pcie00: allocate port service
[    0.445281] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.445355] pcieport-driver 0000:00:1c.0: found MSI capability
[    0.445449] pci_express 0000:00:1c.0:pcie00: allocate port service
[    0.445655] pci_express 0000:00:1c.0:pcie02: allocate port service
[    0.445989] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.446063] pcieport-driver 0000:00:1c.1: found MSI capability
[    0.446149] pci_express 0000:00:1c.1:pcie00: allocate port service
[    0.446348] pci_express 0000:00:1c.1:pcie02: allocate port service
[    0.446668] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    0.446742] pcieport-driver 0000:00:1c.2: found MSI capability
[    0.446829] pci_express 0000:00:1c.2:pcie00: allocate port service
[    0.447026] pci_express 0000:00:1c.2:pcie02: allocate port service
[    0.447344] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    0.447419] pcieport-driver 0000:00:1c.3: found MSI capability
[    0.447506] pci_express 0000:00:1c.3:pcie00: allocate port service
[    0.447724] pci_express 0000:00:1c.3:pcie02: allocate port service
[    0.449189] vesafb: framebuffer at 0xd8000000, mapped to 0xffffc20000080000, using 5120k, total 16384k
[    0.449199] vesafb: mode is 1280x1024x16, linelength=2560, pages=5
[    0.449206] vesafb: scrolling: redraw
[    0.449211] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    0.493549] Console: switching to colour frame buffer device 160x64
[    0.536509] fb0: VESA VGA frame buffer device
[    0.665719] Real Time Clock Driver v1.12ac
[    0.666310] hpet_resources: 0xfed00000 is busy
[    0.666908] Non-volatile memory driver v1.2
[    0.667117] Linux agpgart interface v0.103
[    0.667321] Serial: 8250/16550 driver4 ports, IRQ sharing disabled
[    0.674508] loop: module loaded
[    0.674673] tun: Universal TUN/TAP device driver, 1.6
[    0.674922] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.675515] Uniform Multi-Platform E-IDE driver
[    0.676185] piix 0000:00:1f.1: IDE controller (0x8086:0x27df rev 0x02)
[    0.676521] pci 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
[    0.676867] piix 0000:00:1f.1: IDE port disabled
[    0.677141] piix 0000:00:1f.1: not 100% native mode: will probe irqs later
[    0.677484]     ide0: BM-DMA at 0x1880-0x1887
[    0.677705] Probing IDE interface ide0...
[    1.412234] hda: MATSHITADVD-RAM UJ-842, ATAPI CD/DVD-ROM drive
[    1.748159] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    1.748490] hda: UDMA/33 mode selected
[    1.749103] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    1.752577] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    1.753068] ide_generic: I/O resource 0x1F0-0x1F7 not free.
[    1.753344] ide_generic: I/O resource 0x170-0x177 not free.
[    1.754966] hda: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
[    1.755380] Uniform CD-ROM driver Revision: 3.20
[    1.760195] Driver 'sd' needs updating - please use bus_type methods
[    1.760927] ahci 0000:00:1f.2: version 3.0
[    1.760947] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    1.761689] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x1 impl SATA mode
[    1.762094] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
[    1.762432] ahci 0000:00:1f.2: setting latency timer to 64
[    1.762676] scsi0 : ahci
[    1.763352] scsi1 : ahci
[    1.763849] scsi2 : ahci
[    1.764396] scsi3 : ahci
[    1.764971] ata1: SATA max UDMA/133 abar m1024@0xee404400 port 0xee404500 irq 218
[    1.765336] ata2: DUMMY
[    1.765460] ata3: DUMMY
[    1.765584] ata4: DUMMY
[    2.307894] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.309799] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    2.309803] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    2.310096] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    2.311458] ata1.00: ATA-7: HTS541080G9SA00, MB4IC60R, max UDMA/100
[    2.311767] ata1.00: 156301488 sectors, multi 16: LBA48 
[    2.322252] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    2.322256] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    2.331205] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    2.341281] ata1.00: configured for UDMA/100
[    2.352758] ata1.00: configured for UDMA/100
[    2.361818] ata1: EH complete
[    2.371746] scsi 0:0:0:0: Direct-Access     ATA      HTS541080G9SA00  MB4I PQ: 0 ANSI: 5
[    2.382421] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
[    2.392439] sd 0:0:0:0: [sda] Write Protect is off
[    2.402507] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.402596] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.413746] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
[    2.424540] sd 0:0:0:0: [sda] Write Protect is off
[    2.435405] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.435494] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.446903]  sda: sda1 sda2 sda3 < sda5 >
[    2.908058] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.920824] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.933329] ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
[    2.934411] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    2.946569] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    2.958815] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.958820] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.972043] drivers/usb/core/inode.c: creating file 'devices'
[    2.972118] drivers/usb/core/inode.c: creating file '001'
[    2.972760] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    2.985549] ehci_hcd 0000:00:1d.7: reset hcs_params 0x104208 dbg=1 cc=4 pcc=2 ordered !ppc ports=8
[    2.985555] ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
[    2.985631] ehci_hcd 0000:00:1d.7: reset command 080022 (park)=0 ithresh=8 Async period=1024 Reset HALT
[    2.989541] ehci_hcd 0000:00:1d.7: debug port 1
[    3.002322] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    3.002325] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    3.002355] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xee404000
[    3.015382] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    3.019277] ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    3.027874] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    3.041366] usb usb1: default language 0x0409
[    3.041566] usb usb1: uevent
[    3.041734] usb usb1: usb_probe_device
[    3.041737] usb usb1: configuration #1 chosen from 1 choice
[    3.055273] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    3.055355] usb 1-0:1.0: uevent
[    3.055571] hub 1-0:1.0: usb_probe_interface
[    3.055574] hub 1-0:1.0: usb_probe_interface - got id
[    3.055578] hub 1-0:1.0: USB hub found
[    3.069009] hub 1-0:1.0: 8 ports detected
[    3.082231] hub 1-0:1.0: standalone hub
[    3.082233] hub 1-0:1.0: no power switching (usb 1.0)
[    3.082235] hub 1-0:1.0: individual port over-current protection
[    3.082237] hub 1-0:1.0: power on to power good time: 20ms
[    3.082360] hub 1-0:1.0: local power source is good
[    3.082364] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    3.183882] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001403 POWER sig=k CSC CONNECT
[    3.183890] hub 1-0:1.0: port 1: status 0501 change 0001
[    3.183909] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001403 POWER sig=k CSC CONNECT
[    3.183917] hub 1-0:1.0: port 2: status 0501 change 0001
[    3.183982] ehci_hcd 0000:00:1d.7: GetStatus port 8 status 001803 POWER sig=j CSC CONNECT
[    3.183990] hub 1-0:1.0: port 8: status 0501 change 0001
[    3.288102] hub 1-0:1.0: state 7 ports 8 chg 0106 evt 0000
[    3.288869] drivers/usb/core/inode.c: creating file '001'
[    3.289180] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    3.289278] ehci_hcd 0000:00:1d.7: port 1 low speed --> companion
[    3.289352] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.302803] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.316331] usb usb1: Product: EHCI Host Controller
[    3.329858] usb usb1: Manufacturer: Linux 2.6.27-rc1-dirty ehci_hcd
[    3.343400] usb usb1: SerialNumber: 0000:00:1d.7
[    3.356988] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 003002 POWER OWNER sig=se0 CSC
[    3.357095] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[    3.357114] ehci_hcd 0000:00:1d.7: port 2 low speed --> companion
[    3.357284] USB Universal Host Controller Interface driver v3.0
[    3.371569] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    3.385173] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.398627] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.398632] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.412228] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
[    3.412293] hub 1-0:1.0: port 8, status 0501, change 0000, 480 Mb/s
[    3.412341] drivers/usb/core/inode.c: creating file '002'
[    3.412690] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    3.426211] uhci_hcd 0000:00:1d.0: detected 2 ports
[    3.439570] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    3.439573] uhci_hcd 0000:00:1d.0: Performing full reset
[    3.439592] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    3.439621] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001800
[    3.453086] usb usb2: default language 0x0409
[    3.453278] usb usb2: uevent
[    3.453430] usb usb2: usb_probe_device
[    3.453433] usb usb2: configuration #1 chosen from 1 choice
[    3.466610] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    3.466685] usb 2-0:1.0: uevent
[    3.466834] hub 2-0:1.0: usb_probe_interface
[    3.466836] hub 2-0:1.0: usb_probe_interface - got id
[    3.466840] hub 2-0:1.0: USB hub found
[    3.480051] hub 2-0:1.0: 2 ports detected
[    3.493090] hub 2-0:1.0: standalone hub
[    3.493092] hub 2-0:1.0: no power switching (usb 1.0)
[    3.493094] hub 2-0:1.0: individual port over-current protection
[    3.493096] hub 2-0:1.0: power on to power good time: 2ms
[    3.493135] hub 2-0:1.0: local power source is good
[    3.493139] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    3.493421] ehci_hcd 0000:00:1d.7: port 8 full speed --> companion
[    3.493426] ehci_hcd 0000:00:1d.7: GetStatus port 8 status 003801 POWER OWNER sig=j CONNECT
[    3.493433] hub 1-0:1.0: port 8 not reset yet, waiting 50ms
[    3.547875] ehci_hcd 0000:00:1d.7: GetStatus port 8 status 003002 POWER OWNER sig=se0 CSC
[    3.547924] hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0100
[    3.595877] uhci_hcd 0000:00:1d.0: port 1 portsc 01ab,00
[    3.595884] hub 2-0:1.0: port 1: status 0301 change 0003
[    3.595914] uhci_hcd 0000:00:1d.0: port 2 portsc 01ab,00
[    3.595921] hub 2-0:1.0: port 2: status 0301 change 0003
[    3.700086] hub 2-0:1.0: state 7 ports 2 chg 0006 evt 0000
[    3.700347] drivers/usb/core/inode.c: creating file '001'
[    3.700607] hub 2-0:1.0: port 1, status 0301, change 0000, 1.5 Mb/s
[    3.700674] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    3.713942] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.727052] usb usb2: Product: UHCI Host Controller
[    3.739941] usb usb2: Manufacturer: Linux 2.6.27-rc1-dirty uhci_hcd
[    3.753081] usb usb2: SerialNumber: 0000:00:1d.0
[    3.766159] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.779192] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    3.779197] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.792418] drivers/usb/core/inode.c: creating file '003'
[    3.792706] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    3.805745] uhci_hcd 0000:00:1d.1: detected 2 ports
[    3.818598] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    3.818601] uhci_hcd 0000:00:1d.1: Performing full reset
[    3.818618] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    3.818645] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001820
[    3.831549] usb usb3: default language 0x0409
[    3.831733] usb usb3: uevent
[    3.831936] usb usb3: usb_probe_device
[    3.831939] usb usb3: configuration #1 chosen from 1 choice
[    3.844379] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    3.844455] usb 3-0:1.0: uevent
[    3.844605] hub 3-0:1.0: usb_probe_interface
[    3.844607] hub 3-0:1.0: usb_probe_interface - got id
[    3.844611] hub 3-0:1.0: USB hub found
[    3.857438] hub 3-0:1.0: 2 ports detected
[    3.870339] hub 3-0:1.0: standalone hub
[    3.870342] hub 3-0:1.0: no power switching (usb 1.0)
[    3.870344] hub 3-0:1.0: individual port over-current protection
[    3.870346] hub 3-0:1.0: power on to power good time: 2ms
[    3.870366] hub 3-0:1.0: local power source is good
[    3.870369] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    3.870401] usb 2-1: new low speed USB device using uhci_hcd and address 2
[    3.972364] drivers/usb/core/inode.c: creating file '001'
[    3.972665] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    3.985880] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.999032] usb usb3: Product: UHCI Host Controller
[    4.012292] usb usb3: Manufacturer: Linux 2.6.27-rc1-dirty uhci_hcd
[    4.025826] usb usb3: SerialNumber: 0000:00:1d.1
[    4.039823] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[    4.053379] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.066977] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    4.066982] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.080830] drivers/usb/core/inode.c: creating file '004'
[    4.081160] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    4.094893] uhci_hcd 0000:00:1d.2: detected 2 ports
[    4.108502] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    4.108505] uhci_hcd 0000:00:1d.2: Performing full reset
[    4.108523] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    4.108550] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001840
[    4.122803] usb 2-1: skipped 1 descriptor after interface
[    4.122430] usb usb4: default language 0x0409
[    4.122613] usb usb4: uevent
[    4.122764] usb usb4: usb_probe_device
[    4.122767] usb usb4: configuration #1 chosen from 1 choice
[    4.136350] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    4.136424] usb 4-0:1.0: uevent
[    4.136582] hub 4-0:1.0: usb_probe_interface
[    4.136584] hub 4-0:1.0: usb_probe_interface - got id
[    4.136588] hub 4-0:1.0: USB hub found
[    4.150962] usb 2-1: default language 0x0409
[    4.150481] hub 4-0:1.0: 2 ports detected
[    4.164343] hub 4-0:1.0: standalone hub
[    4.164345] hub 4-0:1.0: no power switching (usb 1.0)
[    4.164347] hub 4-0:1.0: individual port over-current protection
[    4.164350] hub 4-0:1.0: power on to power good time: 2ms
[    4.164369] hub 4-0:1.0: local power source is good
[    4.164373] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    4.172212] usb 2-1: uevent
[    4.172368] usb 2-1: usb_probe_device
[    4.172370] usb 2-1: configuration #1 chosen from 1 choice
[    4.189060] usb 2-1: adding 2-1:1.0 (config #1, interface 0)
[    4.189138] usb 2-1:1.0: uevent
[    4.189739] drivers/usb/core/inode.c: creating file '002'
[    4.190031] usb 2-1: New USB device found, idVendor=413c, idProduct=2003
[    4.203837] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.217656] usb 2-1: Product: Dell USB Keyboard
[    4.231320] usb 2-1: Manufacturer: Dell
[    4.244793] hub 2-0:1.0: port 2, status 0301, change 0000, 1.5 Mb/s
[    4.264361] drivers/usb/core/inode.c: creating file '001'
[    4.264659] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    4.278306] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.291877] usb usb4: Product: UHCI Host Controller
[    4.305235] usb usb4: Manufacturer: Linux 2.6.27-rc1-dirty uhci_hcd
[    4.318701] usb usb4: SerialNumber: 0000:00:1d.2
[    4.332169] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    4.345698] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    4.345703] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    4.359390] drivers/usb/core/inode.c: creating file '005'
[    4.359678] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    4.373367] usb 2-2: new low speed USB device using uhci_hcd and address 3
[    4.386997] uhci_hcd 0000:00:1d.3: detected 2 ports
[    4.400658] uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
[    4.400660] uhci_hcd 0000:00:1d.3: Performing full reset
[    4.400687] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001860
[    4.414500] usb usb5: default language 0x0409
[    4.414685] usb usb5: uevent
[    4.414835] usb usb5: usb_probe_device
[    4.414838] usb usb5: configuration #1 chosen from 1 choice
[    4.428520] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    4.428602] usb 5-0:1.0: uevent
[    4.428760] hub 5-0:1.0: usb_probe_interface
[    4.428763] hub 5-0:1.0: usb_probe_interface - got id
[    4.428766] hub 5-0:1.0: USB hub found
[    4.442319] hub 5-0:1.0: 2 ports detected
[    4.455727] hub 5-0:1.0: standalone hub
[    4.455729] hub 5-0:1.0: no power switching (usb 1.0)
[    4.455731] hub 5-0:1.0: individual port over-current protection
[    4.455734] hub 5-0:1.0: power on to power good time: 2ms
[    4.455753] hub 5-0:1.0: local power source is good
[    4.455757] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    4.546074] usb 2-2: skipped 1 descriptor after interface
[    4.551064] usb 2-2: default language 0x0409
[    4.555887] uhci_hcd 0000:00:1d.3: port 2 portsc 009b,00
[    4.555895] hub 5-0:1.0: port 2: status 0101 change 0003
[    4.568218] usb 2-2: uevent
[    4.568371] usb 2-2: usb_probe_device
[    4.568374] usb 2-2: configuration #1 chosen from 1 choice
[    4.584062] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
[    4.584139] usb 2-2:1.0: uevent
[    4.584728] drivers/usb/core/inode.c: creating file '003'
[    4.585031] usb 2-2: New USB device found, idVendor=045e, idProduct=0084
[    4.598638] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.612258] usb 2-2: Product: Basic Optical Mouse
[    4.625802] usb 2-2: Manufacturer: Microsoft
[    4.639210] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.639219] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.660149] hub 5-0:1.0: state 7 ports 2 chg 0004 evt 0000
[    4.660423] drivers/usb/core/inode.c: creating file '001'
[    4.660685] hub 5-0:1.0: port 2, status 0101, change 0000, 12 Mb/s
[    4.660743] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    4.674326] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.687902] usb usb5: Product: UHCI Host Controller
[    4.701374] usb usb5: Manufacturer: Linux 2.6.27-rc1-dirty uhci_hcd
[    4.714932] usb usb5: SerialNumber: 0000:00:1d.3
[    4.729126] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    4.749986] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.763694] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.777837] mice: PS/2 mouse device common for all mice
[    4.791514] usb 5-2: new full speed USB device using uhci_hcd and address 2
[    4.816031] usbhid 2-1:1.0: usb_probe_interface
[    4.816034] usbhid 2-1:1.0: usb_probe_interface - got id
[    4.810205] input: AT Translated Set 2 keyboard as /class/input/input0
[    4.824973] input: Dell Dell USB Keyboard as /class/input/input1
[    4.879933] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 16, phase 8, 118 us
[    4.892390] input,hidraw0: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:1d.0-1
[    4.906618] usbhid 2-2:1.0: usb_probe_interface
[    4.906621] usbhid 2-2:1.0: usb_probe_interface - got id
[    4.919777] input: Microsoft Basic Optical Mouse as /class/input/input2
[    4.955854] usb 5-2: ep0 maxpacket = 8
[    4.964289] input,hidraw1: USB HID v1.10 Mouse [Microsoft Basic Optical Mouse] on usb-0000:00:1d.0-2
[    4.991484] usb 5-2: default language 0x0409
[    5.010635] usb 5-2: uevent
[    5.010802] usb 5-2: usb_probe_device
[    5.010805] usb 5-2: configuration #1 chosen from 1 choice
[    5.027481] usb 5-2: adding 5-2:1.0 (config #1, interface 0)
[    5.027559] usb 5-2:1.0: uevent
[    5.028720] drivers/usb/core/inode.c: creating file '002'
[    5.029026] usb 5-2: New USB device found, idVendor=0483, idProduct=2016
[    5.043468] usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.057907] usb 5-2: Product: Biometric Coprocessor
[    5.072283] usb 5-2: Manufacturer: STMicroelectronics
[    5.086890] usbcore: registered new interface driver usbhid
[    5.101355] usbhid: v2.6:USB HID core driver
[    5.115869] usb usb3: suspend_rh (auto-stop)
[    5.116066] Advanced Linux Sound Architecture Driver Version 1.0.17.
[    5.131217] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    5.145978] hda_intel: probe_mask set to 0x1 for device 17aa:2010
[    5.160748] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    5.228773] ALSA device list:
[    5.243297]   #0: HDA Intel at 0xee400000 irq 17
[    5.258403] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    5.275944] ip_tables: (C) 2000-2006 Netfilter Core Team
[    5.290681] TCP cubic registered
[    5.305219] NET: Registered protocol family 17
[    5.363868] usb usb4: suspend_rh (auto-stop)
[    5.648200] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x81a0b1, caps: 0xa04793/0x300000
[    5.663023] serio: Synaptics pass-through port at isa0060/serio1/input0
[    5.720662] input: SynPS/2 Synaptics TouchPad as /class/input/input3
[    5.819961] hub 1-0:1.0: hub_suspend
[    5.820022] usb usb1: bus auto-suspend
[    5.820024] ehci_hcd 0000:00:1d.7: suspend root hub
[    6.819832] hub 3-0:1.0: hub_suspend
[    6.819841] usb usb3: bus auto-suspend
[    6.819852] usb usb3: suspend_rh
[    6.819876] hub 4-0:1.0: hub_suspend
[    6.819884] usb usb4: bus auto-suspend
[    6.819886] usb usb4: suspend_rh
[   11.214743] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   11.465919] input: TPPS/2 IBM TrackPoint as /class/input/input4
[   12.123537] kjournald starting.  Commit interval 5 seconds
[   12.133441] EXT3-fs: mounted filesystem with ordered data mode.
[   12.133528] VFS: Mounted root (ext3 filesystem) readonly.
[   12.133581] Freeing unused kernel memory: 648k freed
[   12.134010] Write protecting the kernel read-only data: 3864k
[   14.592401] usb usb2: uevent
[   14.592490] usb 2-0:1.0: uevent
[   14.592571] usb 2-1: uevent
[   14.592652] usb 2-1:1.0: uevent
[   14.592733] usb 2-2: uevent
[   14.592813] usb 2-2:1.0: uevent
[   14.592969] usb usb3: uevent
[   14.593061] usb 3-0:1.0: uevent
[   14.593216] usb usb4: uevent
[   14.593310] usb 4-0:1.0: uevent
[   14.593463] usb usb5: uevent
[   14.593542] usb 5-0:1.0: uevent
[   14.593630] usb 5-2: uevent
[   14.593709] usb 5-2:1.0: uevent
[   14.593863] usb usb1: uevent
[   14.593942] usb 1-0:1.0: uevent
[   15.629102] thinkpad_acpi: ThinkPad ACPI Extras v0.21
[   15.644564] thinkpad_acpi: http://ibm-acpi.sf.net/
[   15.660043] thinkpad_acpi: ThinkPad BIOS 79ETD9WW (2.19 ), EC 79HT50WW-1.07
[   15.675596] thinkpad_acpi: Lenovo ThinkPad T60, model 2007FUG
[   15.696791] thinkpad_acpi: radio switch found; radios are disabled
[   15.712954] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[   15.729162] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[   15.759763] thinkpad_acpi: setting the hotkey mask to 0xffffffff is likely not the best way to go about it
[   15.773022] thinkpad_acpi: please consider using the driver defaults, and refer to up-to-date thinkpad-acpi documentation
[   15.800931] thinkpad_acpi: requested hot key mask 0xffffffff, but firmware forced it to 0x00ffffff
[   15.834003] input: Power Button (FF) as /class/input/input5
[   15.854397] Registered led device: tpacpi::thinklight
[   15.871542] Registered led device: tpacpi::power
[   15.922968] Registered led device: tpacpi:orange:batt
[   15.940093] ACPI: Power Button (FF) [PWRF]
[   15.968313] ACPI: SSDT BFEF1D36, 0240 (r1  PmRef  Cpu0Ist      100 INTL 20050513)
[   15.962334] Registered led device: tpacpi:green:batt
[   15.962420] Registered led device: tpacpi::dock_active
[   15.962497] Registered led device: tpacpi::bay_active
[   15.962576] Registered led device: tpacpi::dock_batt
[   15.962652] Registered led device: tpacpi::unknown_led
[   15.962729] Registered led device: tpacpi::standby
[   16.091931] ACPI: SSDT BFEF1FFB, 065A (r1  PmRef  Cpu0Cst      100 INTL 20050513)
[   16.134011] thinkpad_acpi: Lenovo BIOS switched to ACPI backlight control mode
[   16.133230] Monitor-Mwait will be used to enter C-1 state
[   16.133234] Monitor-Mwait will be used to enter C-2 state
[   16.133238] Monitor-Mwait will be used to enter C-3 state
[   16.133247] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[   16.133486] processor ACPI0007:00: registered as cooling_device0
[   16.133500] ACPI: Processor [CPU0] (supports 8 throttling states)
[   16.133828] input: Lid Switch as /class/input/input6
[   16.134873] ACPI: SSDT BFEF1C6E, 00C8 (r1  PmRef  Cpu1Ist      100 INTL 20050513)
[   16.137360] ACPI: SSDT BFEF1F76, 0085 (r1  PmRef  Cpu1Cst      100 INTL 20050513)
[   16.245657] thinkpad_acpi: standard ACPI backlight interface available, not loading native one...
[   16.265543] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[   16.281850] processor ACPI0007:01: registered as cooling_device1
[   16.289251] input: ThinkPad Extra Buttons as /class/input/input7
[   16.313748] ACPI: Processor [CPU1] (supports 8 throttling states)
[   16.318584] ACPI: Lid Switch [LID]
[   16.318795] input: Sleep Button (CM) as /class/input/input8
[   16.448255] ACPI: Sleep Button (CM) [SLPB]
[   16.473867] thermal LNXTHERM:01: registered as thermal_zone0
[   16.508369] ACPI: Thermal Zone [THM0] (55 C)
[   16.531612] thermal LNXTHERM:02: registered as thermal_zone1
[   16.555197] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k2
[   16.555688] ACPI: Thermal Zone [THM1] (59 C)
[   16.588158] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   16.597494] ACPI: Battery Slot [BAT0] (battery present)
[   16.614661] ACPI: AC Adapter [AC] (on-line)
[   16.627695] e1000e 0000:02:00.0: Disabling L1 ASPM
[   16.627722] e1000e 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   16.627740] e1000e 0000:02:00.0: setting latency timer to 64
[   16.772729] eth0: (PCI Express:2.5GB/s:Width x1) 00:16:41:e3:2c:76
[   16.772744] eth0: Intel(R) PRO/1000 Network Connection
[   16.787449] eth0: MAC: 2, PHY: 2, PBA No: 005301-003
[   17.000384] Clocksource tsc unstable (delta = -83680835 ns)
[   17.275465] Adding 1542196k swap on /dev/sda1.  Priority:-1 extents:1 across:1542196k
[   18.048345] EXT3 FS on sda2, internal journal
[   20.135666] kjournald starting.  Commit interval 5 seconds
[   20.150924] EXT3 FS on sda5, internal journal
[   20.162201] EXT3-fs: mounted filesystem with ordered data mode.
[   20.269734] warning: `mount' uses 32-bit capabilities (legacy support in use)
[   20.406420] fuse init (API version 7.9)
[   24.251386] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
[   24.251829] firmware: requesting intel-ucode/06-0f-06
[   24.327974] firmware: requesting intel-ucode/06-0f-06
[   37.544652] eth0: Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[   37.544657] eth0: 10/100 speed: disabling TSO
[   38.076133] uhci_hcd 0000:00:1d.0: reserve dev 3 ep81-INT, period 8, phase 4, 93 us
[   38.095682] uhci_hcd 0000:00:1d.0: release dev 3 ep81-INT, period 8, phase 4, 93 us
[   38.248746] uhci_hcd 0000:00:1d.0: reserve dev 3 ep81-INT, period 8, phase 4, 93 us
[   38.268167] uhci_hcd 0000:00:1d.0: release dev 3 ep81-INT, period 8, phase 4, 93 us
[   38.835458] uhci_hcd 0000:00:1d.0: reserve dev 3 ep81-INT, period 8, phase 4, 93 us
[   47.257737] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[   47.391952] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=352 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=332 
[   47.431286] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=245 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=225 
[   47.647293] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=352 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=332 
[   47.906035] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=352 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=332 
[   54.267233] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[   62.281825] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[   77.375600] CPU0 attaching NULL sched-domain.
[   77.375705] CPU1 attaching NULL sched-domain.
[   77.389339] CPU0 attaching sched-domain:
[   77.389945]  domain 0: span 0-1 level MC
[   77.389952]   groups: 0 1
[   77.389969] CPU1 attaching sched-domain:
[   77.390747]  domain 0: span 0-1 level MC
[   77.390754]   groups: 1 0
[   78.283211] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[  110.283572] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[  174.290184] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[  302.298515] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[  339.083898] eth0: Link is Down
[  989.922658] eth0: Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[  989.922669] eth0: 10/100 speed: disabling TSO
[  996.212812] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=245 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=225 
[  996.236677] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=352 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=332 
[  996.261093] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[  996.494548] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=352 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=332 
[  996.752414] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=352 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=332 
[  999.273404] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[  999.271538] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=366 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=346 
[ 1000.012064] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=322 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=302 
[ 1003.279285] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[ 1011.283681] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[ 1027.279340] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[ 1059.299283] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[ 1123.288205] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[ 1251.291253] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[ 1507.298085] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[ 2019.300268] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[ 3043.303167] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[ 5091.310288] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[ 8691.318914] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[12291.323733] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[13964.551553] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:30:05:c6:dd:fb:08:00 SRC=192.168.0.8 DST=224.0.0.251 LEN=409 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=389 
[14430.106248] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:30:05:c6:dd:fb:08:00 SRC=192.168.0.8 DST=224.0.0.251 LEN=258 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=238 
[14430.357592] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:30:05:c6:dd:fb:08:00 SRC=192.168.0.8 DST=224.0.0.251 LEN=258 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=238 
[14430.608855] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:30:05:c6:dd:fb:08:00 SRC=192.168.0.8 DST=224.0.0.251 LEN=258 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=238 
[14430.808491] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:30:05:c6:dd:fb:08:00 SRC=192.168.0.8 DST=224.0.0.251 LEN=240 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=220 
[14430.983512] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:30:05:c6:dd:fb:08:00 SRC=192.168.0.8 DST=224.0.0.251 LEN=176 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=156 
[15891.322079] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[19491.320177] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[21272.094076] uhci_hcd 0000:00:1d.0: release dev 3 ep81-INT, period 8, phase 4, 93 us
[21272.653192] PM: Syncing filesystems ... done.
[21272.660574] Freezing user space processes ... (elapsed 0.00 seconds) done.
[21272.663905] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[21272.664041] Suspending console(s) (use no_console_suspend to debug)
[21272.890919] usb 5-2: usb suspend
[21273.883248] usb 2-2: usb suspend
[21273.896815] hub 5-0:1.0: hub_suspend
[21273.896863] usb usb5: bus suspend
[21273.896877] usb usb5: suspend_rh
[21273.898319] uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 16, phase 8, 118 us
[21273.901318] usb 2-1: usb suspend
[21273.916917] hub 2-0:1.0: hub_suspend
[21273.916932] usb usb2: bus suspend
[21273.916936] usb usb2: suspend_rh
[21273.917177] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[21273.917540] sd 0:0:0:0: [sda] Stopping disk
[21274.341950] e1000e 0000:02:00.0: PCI INT A disabled
[21274.341964] ACPI handle has no context!
[21274.389354] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[21274.407490] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[21274.407496] ehci_hcd 0000:00:1d.7: --> PCI D3
[21274.407502] uhci_hcd 0000:00:1d.3: uhci_pci_suspend
[21274.407601] uhci_hcd 0000:00:1d.3: PCI INT D disabled
[21274.407603] uhci_hcd 0000:00:1d.3: --> PCI D0/legacy
[21274.407608] uhci_hcd 0000:00:1d.2: uhci_pci_suspend
[21274.407668] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[21274.407670] uhci_hcd 0000:00:1d.2: --> PCI D0/legacy
[21274.407674] uhci_hcd 0000:00:1d.1: uhci_pci_suspend
[21274.407734] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[21274.407735] uhci_hcd 0000:00:1d.1: --> PCI D0/legacy
[21274.407740] uhci_hcd 0000:00:1d.0: uhci_pci_suspend
[21274.407799] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[21274.407801] uhci_hcd 0000:00:1d.0: --> PCI D0/legacy
[21274.421084] HDA Intel 0000:00:1b.0: PCI INT B disabled
[21274.588547] ACPI: Preparing to enter system sleep state S3
[21275.019202] Disabling non-boot CPUs ...
[21275.021008] Broke affinity for irq 9
[21275.021008] Broke affinity for irq 12
[21275.021008] Broke affinity for irq 16
[21275.021008] Broke affinity for irq 218
[21275.120777] CPU 1 is now offline
[21275.120780] lockdep: fixing up alternatives.
[21275.120788] SMP alternatives: switching to UP code
[21275.134792] CPU0 attaching NULL sched-domain.
[21275.134872] CPU1 attaching NULL sched-domain.
[21275.148843] CPU0 attaching NULL sched-domain.
[21275.150036] CPU1 is down
[21275.150193] Extended CMOS year: 2000
[21275.150193] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[21275.151012] Back to C!
[21275.151536] Extended CMOS year: 2000
[21275.151871] Enabling non-boot CPUs ...
[21275.152009] lockdep: fixing up alternatives.
[21275.152009] SMP alternatives: switching to SMP code
[21275.162233] Booting processor 1/1 ip 6000
[21275.167017] Initializing CPU#1
[21275.247022] Calibrating delay using timer specific routine.. <6>3657.63 BogoMIPS (lpj=7315267)
[21275.247030] CPU: L1 I cache: 32K, L1 D cache: 32K
[21275.247032] CPU: L2 cache: 2048K
[21275.247035] CPU: Physical Processor ID: 0
[21275.247036] CPU: Processor Core ID: 1
[21275.247715] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[21275.253850] CPU1: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 06
[21275.253913] CPU0 attaching NULL sched-domain.
[21275.252491] Switched to high resolution mode on CPU 1
[21275.268396] CPU0 attaching sched-domain:
[21275.268400]  domain 0: span 0-1 level MC
[21275.268402]   groups: 0 1
[21275.268410] CPU1 attaching sched-domain:
[21275.268413]  domain 0: span 0-1 level MC
[21275.268414]   groups: 1 0
[21275.265108] CPU1 is up
[21275.265112] ACPI: Waking up from system sleep state S3
[21276.572739] ACPI: EC: non-query interrupt received, switching to interrupt mode
[21276.618503] pcieport-driver 0000:00:01.0: restoring config space at offset 0x7 (was 0x20002020, writing 0x2020)
[21276.618518] pcieport-driver 0000:00:01.0: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[21276.618568] pcieport-driver 0000:00:01.0: setting latency timer to 64
[21276.631291] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100102)
[21276.631326] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[21276.631337] HDA Intel 0000:00:1b.0: setting latency timer to 64
[21276.719219] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[21276.719314] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[21276.719402] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[21276.719492] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[21276.719565] pcieport-driver 0000:00:1c.2: restoring config space at offset 0x7 (was 0x20007060, writing 0x7060)
[21276.719591] pcieport-driver 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[21276.719681] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[21276.719723] pcieport-driver 0000:00:1c.3: restoring config space at offset 0xf (was 0x40400, writing 0x4040b)
[21276.719754] pcieport-driver 0000:00:1c.3: restoring config space at offset 0x9 (was 0x10001, writing 0xe421e421)
[21276.719762] pcieport-driver 0000:00:1c.3: restoring config space at offset 0x8 (was 0x0, writing 0xebf0ea00)
[21276.719775] pcieport-driver 0000:00:1c.3: restoring config space at offset 0x7 (was 0x20000000, writing 0x9080)
[21276.719796] pcieport-driver 0000:00:1c.3: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[21276.719806] pcieport-driver 0000:00:1c.3: restoring config space at offset 0x1 (was 0x100000, writing 0x100507)
[21276.719900] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[21276.719911] uhci_hcd 0000:00:1d.0: PCI legacy resume
[21276.723487] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[21276.723495] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[21276.723502] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[21276.723551] uhci_hcd 0000:00:1d.0: uhci_pci_resume
[21276.723558] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x2f00
[21276.723560] uhci_hcd 0000:00:1d.0: Performing full reset
[21276.723584] usb usb2: root hub lost power or was reset
[21276.723587] usb usb2: suspend_rh
[21276.723697] uhci_hcd 0000:00:1d.1: PCI legacy resume
[21276.723706] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[21276.723713] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[21276.723761] uhci_hcd 0000:00:1d.1: uhci_pci_resume
[21276.723766] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x2000
[21276.723768] uhci_hcd 0000:00:1d.1: Performing full reset
[21276.723792] usb usb3: root hub lost power or was reset
[21276.723794] usb usb3: suspend_rh
[21276.723812] uhci_hcd 0000:00:1d.2: PCI legacy resume
[21276.724367] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[21276.724374] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[21276.724381] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[21276.724430] uhci_hcd 0000:00:1d.2: uhci_pci_resume
[21276.724435] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x2000
[21276.724437] uhci_hcd 0000:00:1d.2: Performing full reset
[21276.724460] usb usb4: root hub lost power or was reset
[21276.724462] usb usb4: suspend_rh
[21276.724481] uhci_hcd 0000:00:1d.3: PCI legacy resume
[21276.724488] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[21276.724495] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[21276.724544] uhci_hcd 0000:00:1d.3: uhci_pci_resume
[21276.724549] uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: legsup = 0x2000
[21276.724551] uhci_hcd 0000:00:1d.3: Performing full reset
[21276.724574] usb usb5: root hub lost power or was reset
[21276.724576] usb usb5: suspend_rh
[21276.724621] ehci_hcd 0000:00:1d.7: PCI D0, from previous PCI D3
[21276.725242] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[21276.725252] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[21276.725259] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[21276.725481] pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100005, writing 0x100007)
[21276.725508] pci 0000:00:1e.0: setting latency timer to 64
[21276.725639] PIIX_IDE 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
[21276.738824] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
[21276.738883] ahci 0000:00:1f.2: setting latency timer to 64
[21276.739311] pci 0000:01:00.0: restoring config space at offset 0x1 (was 0x100103, writing 0x100107)
[21276.754913] e1000e 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[21276.754923] e1000e 0000:02:00.0: setting latency timer to 64
[21276.814134] pci 0000:15:00.0: restoring config space at offset 0xf (was 0x34001ff, writing 0x3c0010b)
[21276.814143] pci 0000:15:00.0: restoring config space at offset 0xe (was 0x0, writing 0xa4fc)
[21276.814152] pci 0000:15:00.0: restoring config space at offset 0xd (was 0x0, writing 0xa400)
[21276.814160] pci 0000:15:00.0: restoring config space at offset 0xc (was 0x0, writing 0xa0fc)
[21276.814168] pci 0000:15:00.0: restoring config space at offset 0xb (was 0x0, writing 0xa000)
[21276.814177] pci 0000:15:00.0: restoring config space at offset 0xa (was 0x0, writing 0xc7fff000)
[21276.814185] pci 0000:15:00.0: restoring config space at offset 0x9 (was 0x0, writing 0xc4000000)
[21276.814194] pci 0000:15:00.0: restoring config space at offset 0x8 (was 0x0, writing 0xe3fff000)
[21276.814202] pci 0000:15:00.0: restoring config space at offset 0x7 (was 0x0, writing 0xe0000000)
[21276.814210] pci 0000:15:00.0: restoring config space at offset 0x6 (was 0x0, writing 0xb0171615)
[21276.814222] pci 0000:15:00.0: restoring config space at offset 0x4 (was 0x0, writing 0xe4300000)
[21276.814230] pci 0000:15:00.0: restoring config space at offset 0x3 (was 0x20000, writing 0x2a808)
[21276.814242] pci 0000:15:00.0: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100007)
[21276.814276] pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[21276.822533] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[21276.822826] hda: UDMA/33 mode selected
[21276.823840] sd 0:0:0:0: [sda] Starting disk
[21277.285295] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[21282.287089] ata1.00: qc timeout (cmd 0xec)
[21282.287107] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[21282.287112] ata1.00: revalidation failed (errno=-5)
[21282.831103] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[21292.831085] ata1.00: qc timeout (cmd 0xec)
[21292.831102] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[21292.831106] ata1.00: revalidation failed (errno=-5)
[21293.151157] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[21323.151085] ata1.00: qc timeout (cmd 0xec)
[21323.151101] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[21323.151106] ata1.00: revalidation failed (errno=-5)
[21323.151109] ata1.00: disabled
[21323.151134] ata1: hard resetting link
[21323.471141] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[21323.471155] ata1: EH complete
[21323.471450] sd 0:0:0:0: [sda] START_STOP FAILED
[21323.471454] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21323.471548] PM: Device 0:0:0:0 failed to resume: error 262144
[21323.471629] usb usb1: usb resume
[21323.471649] ehci_hcd 0000:00:1d.7: resume root hub
[21323.500064] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21323.500067] end_request: I/O error, dev sda, sector 113980368
[21323.500074] Buffer I/O error on device sda2, logical block 13861986
[21323.500076] lost page write due to I/O error on sda2
[21323.500168] JBD: Detected IO errors while flushing file data on sda2
[21323.500283] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21323.500286] end_request: I/O error, dev sda, sector 3253856
[21323.500356] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21323.500358] end_request: I/O error, dev sda, sector 3253872
[21323.500361] Buffer I/O error on device sda2, logical block 21174
[21323.500363] lost page write due to I/O error on sda2
[21323.500384] Aborting journal on device sda2.
[21323.500425] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21323.500428] end_request: I/O error, dev sda, sector 3096840
[21323.500431] Buffer I/O error on device sda2, logical block 1545
[21323.500433] lost page write due to I/O error on sda2
[21323.523632] ehci_hcd 0000:00:1d.7: port 2 low speed --> companion
[21323.523646] ehci_hcd 0000:00:1d.7: port 1 low speed --> companion
[21323.619900] ehci_hcd 0000:00:1d.7: port 8 full speed --> companion
[21323.619908] ehci_hcd 0000:00:1d.7: GetStatus port 8 status 003801 POWER OWNER sig=j CONNECT
[21323.619922] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
[21323.619936] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 003002 POWER OWNER sig=se0 CSC
[21323.635751] hub 1-0:1.0: hub_resume
[21323.636034] ehci_hcd 0000:00:1d.7: GetStatus port 8 status 003002 POWER OWNER sig=se0 CSC
[21323.739909] usb usb2: usb resume
[21323.739916] usb usb2: wakeup_rh
[21323.776108] hub 2-0:1.0: hub_reset_resume
[21323.776112] hub 2-0:1.0: trying to enable port power on non-switchable hub
[21323.880113] uhci_hcd 0000:00:1d.0: port 1 portsc 01ab,00
[21323.880129] hub 2-0:1.0: port 1: status 0301 change 0003
[21323.880191] uhci_hcd 0000:00:1d.0: port 2 portsc 01ab,00
[21323.880204] hub 2-0:1.0: port 2: status 0301 change 0003
[21323.984355] usb 2-1: finish reset-resume
[21324.243949] usb 2-1: reset low speed USB device using uhci_hcd and address 2
[21324.553817] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 16, phase 8, 118 us
[21324.553851] usb usb5: usb resume
[21324.553854] usb usb5: wakeup_rh
[21324.592097] hub 5-0:1.0: hub_reset_resume
[21324.592102] hub 5-0:1.0: trying to enable port power on non-switchable hub
[21324.696106] uhci_hcd 0000:00:1d.3: port 2 portsc 009b,00
[21324.696120] hub 5-0:1.0: port 2: status 0101 change 0003
[21324.800065] usb 2-2: finish reset-resume
[21325.059903] usb 2-2: reset low speed USB device using uhci_hcd and address 3
[21325.372156] usb 5-2: finish reset-resume
[21325.483632] usb 5-2: reset full speed USB device using uhci_hcd and address 2
[21325.615567] usb 5-2: ep0 maxpacket = 8
[21325.644009] Restarting tasks ... <2>ext3_abort called.
[21325.646508] EXT3-fs error (device sda2): ext3_journal_start_sb: Detected aborted journal
[21325.646519] Remounting filesystem read-only
[21325.673275] done.
[21325.689647] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21325.689652] end_request: I/O error, dev sda, sector 119819760
[21325.689971] hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0000
[21325.689985] hub 2-0:1.0: state 7 ports 2 chg 0006 evt 0000
[21325.690015] hub 2-0:1.0: port 1, status 0303, change 0000, 1.5 Mb/s
[21325.690032] hub 2-0:1.0: port 2, status 0303, change 0000, 1.5 Mb/s
[21325.690038] hub 5-0:1.0: state 7 ports 2 chg 0004 evt 0000
[21325.690056] hub 5-0:1.0: port 2, status 0103, change 0000, 12 Mb/s
[21325.690216] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21325.690220] end_request: I/O error, dev sda, sector 119819760
[21325.691980] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21325.691984] end_request: I/O error, dev sda, sector 119819936
[21325.692109] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21325.692112] end_request: I/O error, dev sda, sector 119819936
[21326.363187] uhci_hcd 0000:00:1d.0: reserve dev 3 ep81-INT, period 8, phase 4, 93 us
[21326.396473] uhci_hcd 0000:00:1d.0: release dev 3 ep81-INT, period 8, phase 4, 93 us
[21326.424986] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21326.424997] end_request: I/O error, dev sda, sector 107727184
[21326.426037] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21326.426046] end_request: I/O error, dev sda, sector 107727184
[21326.427164] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21326.427174] end_request: I/O error, dev sda, sector 107727184
[21326.593037] uhci_hcd 0000:00:1d.0: reserve dev 3 ep81-INT, period 8, phase 4, 93 us
[21327.820633] hub 1-0:1.0: hub_suspend
[21327.823044] usb usb1: bus auto-suspend
[21327.823066] ehci_hcd 0000:00:1d.7: suspend root hub
[21328.188056] eth0: Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[21328.188056] eth0: 10/100 speed: disabling TSO
[21330.680181] SFW2-OUT-ERROR IN= OUT=tun0 SRC=10.20.10.56 DST=10.20.0.6 LEN=89 TOS=0x00 PREC=0x00 TTL=64 ID=42862 DF PROTO=TCP SPT=10147 DPT=993 WINDOW=972 RES=0x00 ACK PSH FIN URGP=0 OPT (0101080A005039C47A78A702) 
[21336.164109] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[21336.370286] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=352 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=332 
[21336.443679] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=245 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=225 
[21336.628056] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=352 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=332 
[21336.884053] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=352 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=332 
[21337.072054] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21337.072054] end_request: I/O error, dev sda, sector 64548368
[21337.072054] EXT3-fs error (device sda2): ext3_find_entry: reading directory #3834545 offset 0
[21355.725332] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21355.725360] end_request: I/O error, dev sda, sector 112136592
[21355.725378] Buffer I/O error on device sda2, logical block 13631514
[21355.725388] lost page write due to I/O error on sda2
[21363.466428] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.466438] end_request: I/O error, dev sda, sector 87357760
[21363.466465] EXT3-fs error (device sda2): ext3_find_entry: reading directory #5259374 offset 0
[21363.486583] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.486592] end_request: I/O error, dev sda, sector 76136968
[21363.487434] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.487442] end_request: I/O error, dev sda, sector 76136976
[21363.488340] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.488348] end_request: I/O error, dev sda, sector 76136984
[21363.489071] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.489079] end_request: I/O error, dev sda, sector 76136992
[21363.489824] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.489832] end_request: I/O error, dev sda, sector 76137000
[21363.490764] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.490773] end_request: I/O error, dev sda, sector 76137008
[21363.491558] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.491566] end_request: I/O error, dev sda, sector 76137016
[21363.492318] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.492326] end_request: I/O error, dev sda, sector 76137024
[21363.493249] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.493258] end_request: I/O error, dev sda, sector 76137032
[21363.494034] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.494044] end_request: I/O error, dev sda, sector 76137040
[21363.494716] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.494724] end_request: I/O error, dev sda, sector 76137048
[21363.495346] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.495354] end_request: I/O error, dev sda, sector 76137056
[21363.496014] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.496021] end_request: I/O error, dev sda, sector 76137064
[21363.496647] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.496655] end_request: I/O error, dev sda, sector 76137064
[21363.497305] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.497312] end_request: I/O error, dev sda, sector 76137064
[21363.497932] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.497939] end_request: I/O error, dev sda, sector 76137064
[21363.498556] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.498563] end_request: I/O error, dev sda, sector 76137064
[21363.499200] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.499207] end_request: I/O error, dev sda, sector 76137064
[21363.499841] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.499848] end_request: I/O error, dev sda, sector 76137064
[21363.500502] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.500509] end_request: I/O error, dev sda, sector 76137064
[21363.501152] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.501159] end_request: I/O error, dev sda, sector 76137064
[21363.501780] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.501787] end_request: I/O error, dev sda, sector 76137064
[21363.502404] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.502411] end_request: I/O error, dev sda, sector 76137064
[21363.503028] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.503035] end_request: I/O error, dev sda, sector 76137064
[21363.503652] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.503659] end_request: I/O error, dev sda, sector 76137064
[21363.504831] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.504840] end_request: I/O error, dev sda, sector 76137064
[21363.505572] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.505579] end_request: I/O error, dev sda, sector 76137064
[21363.506204] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.506211] end_request: I/O error, dev sda, sector 76137064
[21363.506830] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.506837] end_request: I/O error, dev sda, sector 76137064
[21363.507460] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.507467] end_request: I/O error, dev sda, sector 76137064
[21363.508102] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.508110] end_request: I/O error, dev sda, sector 76137064
[21363.508729] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.508737] end_request: I/O error, dev sda, sector 76137064
[21363.509378] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.509385] end_request: I/O error, dev sda, sector 76137064
[21363.509999] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.510006] end_request: I/O error, dev sda, sector 76137064
[21363.510621] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.510628] end_request: I/O error, dev sda, sector 76137064
[21363.511258] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.511265] end_request: I/O error, dev sda, sector 76137064
[21363.511900] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.511907] end_request: I/O error, dev sda, sector 76137064
[21363.512527] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.512534] end_request: I/O error, dev sda, sector 76137064
[21363.513167] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.513174] end_request: I/O error, dev sda, sector 76137064
[21363.513791] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.513798] end_request: I/O error, dev sda, sector 76137064
[21363.514420] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.514427] end_request: I/O error, dev sda, sector 76137064
[21363.515046] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.515053] end_request: I/O error, dev sda, sector 76137064
[21363.515671] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.515679] end_request: I/O error, dev sda, sector 76137064
[21363.516328] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.516335] end_request: I/O error, dev sda, sector 76137064
[21363.516979] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.516986] end_request: I/O error, dev sda, sector 76137064
[21363.517606] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.517613] end_request: I/O error, dev sda, sector 76137064
[21363.518231] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.518238] end_request: I/O error, dev sda, sector 76137064
[21363.518849] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.518856] end_request: I/O error, dev sda, sector 76137064
[21363.519455] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.519462] end_request: I/O error, dev sda, sector 76137064
[21363.520155] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.520162] end_request: I/O error, dev sda, sector 76137064
[21363.520741] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.520748] end_request: I/O error, dev sda, sector 76137064
[21363.521613] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.521621] end_request: I/O error, dev sda, sector 76137064
[21363.522292] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21363.522299] end_request: I/O error, dev sda, sector 76136968
[21367.196056] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[21399.199282] SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.0.9 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[21414.252018] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21414.252018] end_request: I/O error, dev sda, sector 110674896
[21414.252018] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21414.252018] end_request: I/O error, dev sda, sector 110674896
[21414.287205] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21414.287220] end_request: I/O error, dev sda, sector 112311768
[21414.287268] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21414.287279] end_request: I/O error, dev sda, sector 112314904
[21414.287362] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21414.287372] end_request: I/O error, dev sda, sector 112311768
[21414.288444] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21414.288450] end_request: I/O error, dev sda, sector 112311768
[21421.112015] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21421.112015] end_request: I/O error, dev sda, sector 107712840
[21421.112015] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21421.112015] end_request: I/O error, dev sda, sector 107712840
[21421.112015] sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
[21421.112015] end_request: I/O error, dev sda, sector 107712840



#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.27-rc1
# Tue Jul 29 16:18:05 2008
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
# CONFIG_GENERIC_LOCKBREAK is not set
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
# CONFIG_GENERIC_GPIO is not set
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=20
# CONFIG_CGROUPS is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
# CONFIG_RELAY is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_COMPAT_BRK is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
# CONFIG_MARKERS is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
# CONFIG_HAVE_ARCH_TRACEHOOK is not set
# CONFIG_HAVE_DMA_ATTRS is not set
CONFIG_USE_GENERIC_SMP_HELPERS=y
# CONFIG_HAVE_CLK is not set
CONFIG_PROC_PAGE_MONITOR=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_CLASSIC_RCU=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
# CONFIG_AMD_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=2
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
# CONFIG_I8K is not set
CONFIG_MICROCODE=m
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_GET_USER_PAGES_FAST=y
CONFIG_HAVE_MEMORY_PRESENT=y
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x200000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options
#
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=y
# CONFIG_ACPI_BAY is not set
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=m
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=m
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=m
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
# CONFIG_X86_SPEEDSTEP_LIB is not set
# CONFIG_CPU_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
# CONFIG_DMAR is not set
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_HT_IRQ is not set
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_BINFMT_MISC is not set
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_MMAP is not set
CONFIG_UNIX=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IP_VS is not set
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y

#
# Core Netfilter Configuration
#
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
# CONFIG_NETFILTER_NETLINK_LOG is not set
CONFIG_NF_CONNTRACK=y
# CONFIG_NF_CT_ACCT is not set
# CONFIG_NF_CONNTRACK_MARK is not set
# CONFIG_NF_CONNTRACK_EVENTS is not set
# CONFIG_NF_CT_PROTO_DCCP is not set
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CT_PROTO_UDPLITE is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CONNTRACK_TFTP is not set
# CONFIG_NF_CT_NETLINK is not set
CONFIG_NETFILTER_XTABLES=y
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
# CONFIG_NETFILTER_XT_TARGET_CONNMARK is not set
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
# CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
# CONFIG_NETFILTER_XT_MATCH_CONNLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNMARK is not set
# CONFIG_NETFILTER_XT_MATCH_CONNTRACK is not set
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_HELPER is not set
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
# CONFIG_NETFILTER_XT_MATCH_MAC is not set
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=y
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
CONFIG_NETFILTER_XT_MATCH_STATE=y
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
# CONFIG_NETFILTER_XT_MATCH_STRING is not set
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV4=y
# CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=y
# CONFIG_IP_NF_MATCH_RECENT is not set
# CONFIG_IP_NF_MATCH_ECN is not set
# CONFIG_IP_NF_MATCH_AH is not set
# CONFIG_IP_NF_MATCH_TTL is not set
# CONFIG_IP_NF_MATCH_ADDRTYPE is not set
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_LOG=y
# CONFIG_IP_NF_TARGET_ULOG is not set
CONFIG_NF_NAT=y
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
# CONFIG_IP_NF_TARGET_REDIRECT is not set
# CONFIG_IP_NF_TARGET_NETMAP is not set
# CONFIG_NF_NAT_SNMP_BASIC is not set
# CONFIG_NF_NAT_FTP is not set
# CONFIG_NF_NAT_IRC is not set
# CONFIG_NF_NAT_TFTP is not set
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
# CONFIG_NF_NAT_SIP is not set
CONFIG_IP_NF_MANGLE=y
# CONFIG_IP_NF_TARGET_ECN is not set
# CONFIG_IP_NF_TARGET_TTL is not set
# CONFIG_IP_NF_TARGET_CLUSTERIP is not set
# CONFIG_IP_NF_RAW is not set
# CONFIG_IP_NF_ARPTABLES is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set

#
# Wireless
#
CONFIG_CFG80211=m
CONFIG_NL80211=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_MAC80211=m

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_PID=y
CONFIG_MAC80211_RC_DEFAULT_PID=y
CONFIG_MAC80211_RC_DEFAULT="pid"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_IEEE80211=m
# CONFIG_IEEE80211_DEBUG is not set
CONFIG_IEEE80211_CRYPT_WEP=m
CONFIG_IEEE80211_CRYPT_CCMP=m
CONFIG_IEEE80211_CRYPT_TKIP=m
CONFIG_RFKILL=m
CONFIG_RFKILL_INPUT=m
CONFIG_RFKILL_LEDS=y
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ACER_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
CONFIG_THINKPAD_ACPI=m
# CONFIG_THINKPAD_ACPI_DEBUG is not set
CONFIG_THINKPAD_ACPI_BAY=y
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y
CONFIG_BLK_DEV_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_BLK_DEV_IDEDISK=y
CONFIG_IDEDISK_MULTI_MODE=y
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
# CONFIG_BLK_DEV_IDESCSI is not set
CONFIG_BLK_DEV_IDEACPI=y
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_DH is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_SCH is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=y
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
CONFIG_E1000E=m
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_AIRO is not set
# CONFIG_HERMES is not set
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_P54_COMMON is not set
# CONFIG_ATH5K is not set
CONFIG_IWLWIFI=m
# CONFIG_IWLCORE is not set
# CONFIG_IWLWIFI_LEDS is not set
# CONFIG_IWL4965 is not set
CONFIG_IWL3945=m
CONFIG_IWL3945_RFKILL=y
# CONFIG_IWL3945_SPECTRUM_MEASUREMENT is not set
CONFIG_IWL3945_LEDS=y
# CONFIG_IWL3945_DEBUG is not set
# CONFIG_HOSTAP is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_ZD1211RW is not set
# CONFIG_RT2X00 is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_HSO is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
CONFIG_RTC=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_RTC_IRQ=y
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_WATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_VIDEO_MEDIA is not set

#
# Multimedia drivers
#
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
# CONFIG_FB_MODE_HELPERS is not set
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=y
# CONFIG_FB_EFI is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m
# CONFIG_BACKLIGHT_CORGI is not set
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=128
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
# CONFIG_SND_RTCTIMER is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_HWDEP=y
# CONFIG_SND_HDA_CODEC_REALTEK is not set
CONFIG_SND_HDA_CODEC_ANALOG=y
# CONFIG_SND_HDA_CODEC_SIGMATEL is not set
# CONFIG_SND_HDA_CODEC_VIA is not set
# CONFIG_SND_HDA_CODEC_ATIHDMI is not set
# CONFIG_SND_HDA_CODEC_CONEXANT is not set
# CONFIG_SND_HDA_CODEC_CMEDIA is not set
# CONFIG_SND_HDA_CODEC_SI3054 is not set
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=10
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_USB=y
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
# CONFIG_USB_HIDDEV is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_DPCM is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
CONFIG_USB_MON=y

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_AUERSWALD is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
# CONFIG_LEDS_CLEVO_MAIL is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_IDE_DISK is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_UIO is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
# CONFIG_NFS_V4 is not set
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
# CONFIG_NFSD_V4 is not set
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=m
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_UTF8 is not set
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_DEBUG_SLAB=y
CONFIG_DEBUG_SLAB_LEAK=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_HAVE_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
# CONFIG_FTRACE is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_CONTEXT_SWITCH_TRACER is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DIRECT_GBPAGES is not set
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_MMIOTRACE is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_MANAGER=y
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
