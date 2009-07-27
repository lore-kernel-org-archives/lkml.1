Return-Path: <linux-kernel-owner+w=401wt.eu-S1752997AbZG0TpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997AbZG0TpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 15:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbZG0TpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 15:45:22 -0400
Received: from mail-fx0-f214.google.com ([209.85.220.214]:43363 "EHLO
	mail-fx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbZG0TpR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 15:45:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=pz2uejJAFNQGtZ1nVoFqwBw44I8PvHOTYoUEFLPNH/jbvUwDgM2dAvZiRl0gcSILtF
         GYA5lXztYbEPny0EokW3bD+JiFW9XbQXyitroqWfKVluGWM7g9szcDt639+5AIBrFVtP
         taGIeHGdiDB8kNE6fWpC2pORZLoYOvrNvmTrk=
MIME-Version: 1.0
In-Reply-To: <20090727192720.GA30366@bit.office.eurotux.com>
References: <20090727192720.GA30366@bit.office.eurotux.com>
Date: Mon, 27 Jul 2009 22:45:14 +0300
X-Google-Sender-Auth: b641759fc330d4d1
Message-ID: <84144f020907271245q1d635e49j15a32c85303bf073@mail.gmail.com>
Subject: Re: eeepc_hotkey adds 25s to boot
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Luciano Rocha <luciano@eurotux.com>, linux-kernel@vger.kernel.org,
       corentincj@iksaif.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Corentin to cc)

On Mon, Jul 27, 2009 at 10:27 PM, Luciano Rocha<luciano@eurotux.com> wrote:
> As subject says, loading the eeepc_hotkeys driver or including it inside
> the kernel adds 25s to the boot process:
> [   13.990092] eeepc: Eee PC Hotkey Driver
> [   39.560645] eeepc: Hotkey init flags 0x41
> [   39.566131] eeepc: Get control methods supported: 0x101713
> [   39.566418] input: Asus EeePC extra buttons as ...
>
> Kernel is 2.6.30.3 (with tuxonice).
>
> Config and full dmesg follows.
>
> Also, a "rmmod eeepc_hotkeys" resulted in a kernel panic. If asked, I'll
> try to replicate it.

Yes, please.

> dmesg:
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 2.6.30.3 (root@void.local) (gcc version 4.4.0 20090506 (Red Hat 4.4.0-4) (GCC) ) #3 SMP PREEMPT Sun Jul 26 20:59:56 WEST 2009
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   NSC Geode by NSC
> [    0.000000]   Cyrix CyrixInstead
> [    0.000000]   Centaur CentaurHauls
> [    0.000000]   Transmeta GenuineTMx86
> [    0.000000]   Transmeta TransmetaCPU
> [    0.000000]   UMC UMC UMC UMC
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 000000003f7a0000 (usable)
> [    0.000000]  BIOS-e820: 000000003f7a0000 - 000000003f7ae000 (ACPI data)
> [    0.000000]  BIOS-e820: 000000003f7ae000 - 000000003f7f0000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 000000003f7f0000 - 000000003f800000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
> [    0.000000] DMI present.
> [    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
> [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
> [    0.000000] last_pfn = 0x3f7a0 max_arch_pfn = 0x100000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-DFFFF uncachable
> [    0.000000]   E0000-E3FFF write-protect
> [    0.000000]   E4000-EFFFF write-through
> [    0.000000]   F0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000 mask 0C0000000 write-back
> [    0.000000]   1 base 03F800000 mask 0FF800000 uncachable
> [    0.000000]   2 disabled
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] original variable MTRRs
> [    0.000000] reg 0, base: 0GB, range: 1GB, type WB
> [    0.000000] reg 1, base: 1016MB, range: 8MB, type UC
> [    0.000000] total RAM coverred: 1016M
> [    0.000000] Found optimal setting for mtrr clean up
> [    0.000000]  gran_size: 64K  chunk_size: 16M         num_reg: 2      lose cover RAM: 0G
> [    0.000000] New variable MTRRs
> [    0.000000] reg 0, base: 0GB, range: 1GB, type WB
> [    0.000000] reg 1, base: 1016MB, range: 8MB, type UC
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] Warning only 895MB will be used.
> [    0.000000] Use a HIGHMEM enabled kernel.
> [    0.000000] init_memory_mapping: 0000000000000000-0000000037f9b000
> [    0.000000]  0000000000 - 0000400000 page 4k
> [    0.000000]  0000400000 - 0037c00000 page 2M
> [    0.000000]  0037c00000 - 0037f9b000 page 4k
> [    0.000000] kernel direct mapping tables up to 37f9b000 @ 10000-15000
> [    0.000000] RAMDISK: 37c94000 - 37fefccb
> [    0.000000] Allocated new RAMDISK: 00a27000 - 00d82ccb
> [    0.000000] Move RAMDISK from 0000000037c94000 - 0000000037fefcca to 00a27000 - 00d82cca
> [    0.000000] ACPI: RSDP 000fbcf0 00014 (v00 ACPIAM)
> [    0.000000] ACPI: RSDT 3f7a0000 0003C (v01 A_M_I_ OEMRSDT  03000904 MSFT 00000097)
> [    0.000000] ACPI: FACP 3f7a0200 00084 (v02 A_M_I_ OEMFACP  03000904 MSFT 00000097)
> [    0.000000] ACPI: DSDT 3f7a05b0 054EF (v01  P0018 P0018000 00000000 INTL 20060113)
> [    0.000000] ACPI: FACS 3f7ae000 00040
> [    0.000000] ACPI: APIC 3f7a0390 0005C (v01 A_M_I_ OEMAPIC  03000904 MSFT 00000097)
> [    0.000000] ACPI: MCFG 3f7a03f0 0003C (v01 A_M_I_ OEMMCFG  03000904 MSFT 00000097)
> [    0.000000] ACPI: OEMB 3f7ae040 00061 (v01 A_M_I_ AMI_OEM  03000904 MSFT 00000097)
> [    0.000000] ACPI: HPET 3f7a5aa0 00038 (v01 A_M_I_ OEMHPET  03000904 MSFT 00000097)
> [    0.000000] ACPI: SSDT 3f7aeb80 004F0 (v01  PmRef    CpuPm 00003000 INTL 20060113)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] 895MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 37f9b000
> [    0.000000]   low ram: 0 - 37f9b000
> [    0.000000]   node 0 low ram: 00000000 - 37f9b000
> [    0.000000]   node 0 bootmap 00011000 - 00017ff4
> [    0.000000] (9 early reservations) ==> bootmem [0000000000 - 0037f9b000]
> [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
> [    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
> [    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
> [    0.000000]   #3 [0000400000 - 0000a229b0]    TEXT DATA BSS ==> [0000400000 - 0000a229b0]
> [    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
> [    0.000000]   #5 [0000a23000 - 0000a261fc]              BRK ==> [0000a23000 - 0000a261fc]
> [    0.000000]   #6 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
> [    0.000000]   #7 [0000a27000 - 0000d82ccb]      NEW RAMDISK ==> [0000a27000 - 0000d82ccb]
> [    0.000000]   #8 [0000011000 - 0000018000]          BOOTMAP ==> [0000011000 - 0000018000]
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000010 -> 0x00001000
> [    0.000000]   Normal   0x00001000 -> 0x00037f9b
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[2] active PFN ranges
> [    0.000000]     0: 0x00000010 -> 0x0000009f
> [    0.000000]     0: 0x00000100 -> 0x00037f9b
> [    0.000000] On node 0 totalpages: 229162
> [    0.000000] free_area_init_node: node 0, pgdat c094c0c0, node_mem_map c1000200
> [    0.000000]   DMA zone: 32 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 3951 pages, LIFO batch:0
> [    0.000000]   Normal zone: 1760 pages used for memmap
> [    0.000000]   Normal zone: 223419 pages, LIFO batch:31
> [    0.000000] Using APIC driver default
> [    0.000000] ACPI: PM-Timer IO Port: 0x808
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
> [    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 24
> [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
> [    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
> [    0.000000] Allocating PCI resources starting at 40000000 (gap: 3f800000:bf600000)
> [    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 11 pages at c1704000, static data 23708 bytes
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 227370
> [    0.000000] Kernel command line: ro root=/dev/mapper/vg_void-lv_root rhgb quiet
> [    0.000000] Enabling fast FPU save and restore... done.
> [    0.000000] Enabling unmasked SIMD FPU exception support... done.
> [    0.000000] Initializing CPU#0
> [    0.000000] NR_IRQS:320
> [    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 1600.061 MHz processor.
> [    0.003333] Console: colour VGA+ 80x25
> [    0.003333] console [tty0] enabled
> [    0.003333] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> [    0.003333] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.003333] allocated 4585180 bytes of page_cgroup
> [    0.003333] please try cgroup_disable=memory option if you don't want
> [    0.003333] Memory: 894108k/917100k available (3860k kernel code, 22372k reserved, 1644k data, 308k init, 0k highmem)
> [    0.003333] virtual kernel memory layout:
> [    0.003333]     fixmap  : 0xfff9d000 - 0xfffff000   ( 392 kB)
> [    0.003333]     vmalloc : 0xf879b000 - 0xfff9b000   ( 120 MB)
> [    0.003333]     lowmem  : 0xc0000000 - 0xf7f9b000   ( 895 MB)
> [    0.003333]       .init : 0xc0968000 - 0xc09b5000   ( 308 kB)
> [    0.003333]       .data : 0xc07c50b4 - 0xc09602f4   (1644 kB)
> [    0.003333]       .text : 0xc0400000 - 0xc07c50b4   (3860 kB)
> [    0.003333] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.003333] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [    0.003333] hpet clockevent registered
> [    0.003333] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> [    0.003333] Calibrating delay loop (skipped), value calculated using timer frequency.. 3201.46 BogoMIPS (lpj=5333536)
> [    0.003333] Mount-cache hash table entries: 512
> [    0.003333] Initializing cgroup subsys ns
> [    0.003333] Initializing cgroup subsys cpuacct
> [    0.003333] Initializing cgroup subsys memory
> [    0.003333] Initializing cgroup subsys devices
> [    0.003333] Initializing cgroup subsys freezer
> [    0.003333] Initializing cgroup subsys net_cls
> [    0.003333] CPU: L1 I cache: 32K, L1 D cache: 24K
> [    0.003333] CPU: L2 cache: 512K
> [    0.003333] CPU: Physical Processor ID: 0
> [    0.003333] CPU: Processor Core ID: 0
> [    0.003333] Intel machine check architecture supported.
> [    0.003333] Intel machine check reporting enabled on CPU#0.
> [    0.003333] using mwait in idle threads.
> [    0.003333] Checking 'hlt' instruction... OK.
> [    0.013786] ACPI: Core revision 20090320
> [    0.030475] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.065705] CPU0: Intel(R) Atom(TM) CPU N270   @ 1.60GHz stepping 02
> [    0.066666] Booting processor 1 APIC 0x1 ip 0x6000
> [    0.003333] Initializing CPU#1
> [    0.003333] Calibrating delay using timer specific routine.. 3201.27 BogoMIPS (lpj=5333234)
> [    0.003333] CPU: L1 I cache: 32K, L1 D cache: 24K
> [    0.003333] CPU: L2 cache: 512K
> [    0.003333] CPU: Physical Processor ID: 0
> [    0.003333] CPU: Processor Core ID: 0
> [    0.003333] Intel machine check architecture supported.
> [    0.003333] Intel machine check reporting enabled on CPU#1.
> [    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
> [    0.157781] CPU1: Intel(R) Atom(TM) CPU N270   @ 1.60GHz stepping 02
> [    0.157809] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> [    0.160044] Brought up 2 CPUs
> [    0.160050] Total of 2 processors activated (6402.73 BogoMIPS).
> [    0.160185] net_namespace: 544 bytes
> [    0.160221] NET: Registered protocol family 16
> [    0.160306] ACPI: bus type pci registered
> [    0.160418] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 63
> [    0.160425] PCI: Not using MMCONFIG.
> [    0.160771] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=6
> [    0.160776] PCI: Using configuration type 1 for base access
> [    0.164653] bio: create slab <bio-0> at 0
> [    0.164707] ACPI: EC: Look up EC in DSDT
> [    0.176969] ACPI: Interpreter enabled
> [    0.176981] ACPI: (supports S0 S1 S3 S4 S5)
> [    0.177027] ACPI: Using IOAPIC for interrupt routing
> [    0.177152] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 63
> [    0.181211] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
> [    0.181217] PCI: Using MMCONFIG for extended config space
> [    0.191935] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
> [    0.191941] ACPI: EC: driver started in poll mode
> [    0.192340] ACPI: No dock devices found.
> [    0.192502] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [    0.192635] pci 0000:00:02.0: reg 10 32bit mmio: [0xf7f00000-0xf7f7ffff]
> [    0.192645] pci 0000:00:02.0: reg 14 io port: [0xdc80-0xdc87]
> [    0.192654] pci 0000:00:02.0: reg 18 32bit mmio: [0xd0000000-0xdfffffff]
> [    0.192663] pci 0000:00:02.0: reg 1c 32bit mmio: [0xf7ec0000-0xf7efffff]
> [    0.192713] pci 0000:00:02.1: reg 10 32bit mmio: [0xf7f80000-0xf7ffffff]
> [    0.192850] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf7eb8000-0xf7ebbfff]
> [    0.192925] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.192934] pci 0000:00:1b.0: PME# disabled
> [    0.193035] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.193043] pci 0000:00:1c.0: PME# disabled
> [    0.193148] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> [    0.193156] pci 0000:00:1c.1: PME# disabled
> [    0.193260] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
> [    0.193268] pci 0000:00:1c.2: PME# disabled
> [    0.193384] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
> [    0.193392] pci 0000:00:1c.3: PME# disabled
> [    0.193472] pci 0000:00:1d.0: reg 20 io port: [0xd480-0xd49f]
> [    0.193555] pci 0000:00:1d.1: reg 20 io port: [0xd800-0xd81f]
> [    0.193636] pci 0000:00:1d.2: reg 20 io port: [0xd880-0xd89f]
> [    0.193717] pci 0000:00:1d.3: reg 20 io port: [0xdc00-0xdc1f]
> [    0.193802] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf7eb7c00-0xf7eb7fff]
> [    0.193879] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> [    0.193888] pci 0000:00:1d.7: PME# disabled
> [    0.194077] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
> [    0.194085] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
> [    0.194093] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0380 (mask 0003)
> [    0.194100] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0290 (mask 0007)
> [    0.194108] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0068 (mask 0003)
> [    0.194187] pci 0000:00:1f.2: reg 10 io port: [0x00-0x07]
> [    0.194199] pci 0000:00:1f.2: reg 14 io port: [0x00-0x03]
> [    0.194211] pci 0000:00:1f.2: reg 18 io port: [0x00-0x07]
> [    0.194223] pci 0000:00:1f.2: reg 1c io port: [0x00-0x03]
> [    0.194235] pci 0000:00:1f.2: reg 20 io port: [0xffa0-0xffaf]
> [    0.194279] pci 0000:00:1f.2: PME# supported from D3hot
> [    0.194286] pci 0000:00:1f.2: PME# disabled
> [    0.194354] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
> [    0.194550] pci 0000:04:00.0: reg 10 64bit mmio: [0xfbfc0000-0xfbffffff]
> [    0.194565] pci 0000:04:00.0: reg 18 io port: [0xec80-0xecff]
> [    0.194657] pci 0000:04:00.0: PME# supported from D3hot D3cold
> [    0.194666] pci 0000:04:00.0: PME# disabled
> [    0.194713] pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
> [    0.194842] pci 0000:00:1c.1: bridge io port: [0xe000-0xefff]
> [    0.194851] pci 0000:00:1c.1: bridge 32bit mmio: [0xfbf00000-0xfbffffff]
> [    0.195008] pci 0000:00:1c.3: bridge 32bit mmio: [0xf8000000-0xfbefffff]
> [    0.195021] pci 0000:00:1c.3: bridge 64bit mmio pref: [0xf0000000-0xf6ffffff]
> [    0.195092] pci 0000:00:1e.0: transparent bridge
> [    0.195144] pci_bus 0000:00: on NUMA node 0
> [    0.195158] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.195433] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
> [    0.195578] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
> [    0.195716] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
> [    0.195875] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
> [    0.223785] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 *7 10 11 12 14 15)
> [    0.224099] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
> [    0.224411] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 *4 5 6 7 10 11 12 14 15)
> [    0.224721] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> [    0.225030] ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 6 7 10 11 12 14 15)
> [    0.225339] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 7 10 11 12 14 15)
> [    0.225649] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *10 11 12 14 15)
> [    0.225956] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> [    0.226287] SCSI subsystem initialized
> [    0.226348] libata version 3.00 loaded.
> [    0.226348] usbcore: registered new interface driver usbfs
> [    0.226348] usbcore: registered new interface driver hub
> [    0.226348] usbcore: registered new device driver usb
> [    0.226789] ACPI: WMI: Mapper loaded
> [    0.226794] PCI: Using ACPI for IRQ routing
> [    0.236681] Bluetooth: Core ver 2.15
> [    0.236715] NET: Registered protocol family 31
> [    0.236715] Bluetooth: HCI device and connection manager initialized
> [    0.236715] Bluetooth: HCI socket layer initialized
> [    0.276732] cfg80211: Calling CRDA to update world regulatory domain
> [    0.276783] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> [    0.276794] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
> [    0.290011] pnp: PnP ACPI init
> [    0.290029] ACPI: bus type pnp registered
> [    0.294159] pnp: PnP ACPI: found 13 devices
> [    0.294165] ACPI: ACPI bus type pnp unregistered
> [    0.294189] system 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
> [    0.294207] system 00:08: ioport range 0x25c-0x25f has been reserved
> [    0.294214] system 00:08: ioport range 0x380-0x383 has been reserved
> [    0.294221] system 00:08: ioport range 0x400-0x41f has been reserved
> [    0.294228] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
> [    0.294234] system 00:08: ioport range 0x800-0x87f has been reserved
> [    0.294242] system 00:08: ioport range 0x480-0x4bf has been reserved
> [    0.294249] system 00:08: iomem range 0x8c000000-0x8c01ffff has been reserved
> [    0.294256] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
> [    0.294264] system 00:08: iomem range 0xfed20000-0xfed3ffff has been reserved
> [    0.294271] system 00:08: iomem range 0xfed50000-0xfed8ffff has been reserved
> [    0.294279] system 00:08: iomem range 0xffb00000-0xffbfffff has been reserved
> [    0.294286] system 00:08: iomem range 0xfff00000-0xffffffff could not be reserved
> [    0.294299] system 00:0a: iomem range 0xfec00000-0xfec00fff has been reserved
> [    0.294306] system 00:0a: iomem range 0xfee00000-0xfee00fff has been reserved
> [    0.294318] system 00:0b: iomem range 0xe0000000-0xe3ffffff has been reserved
> [    0.294330] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
> [    0.294337] system 00:0c: iomem range 0xc0000-0xcffff could not be reserved
> [    0.294344] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
> [    0.294351] system 00:0c: iomem range 0x100000-0x3f7fffff could not be reserved
> [    0.329305] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:05
> [    0.329310] pci 0000:00:1c.0:   IO window: disabled
> [    0.329321] pci 0000:00:1c.0:   MEM window: disabled
> [    0.329328] pci 0000:00:1c.0:   PREFETCH window: disabled
> [    0.329340] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:04
> [    0.329348] pci 0000:00:1c.1:   IO window: 0xe000-0xefff
> [    0.329358] pci 0000:00:1c.1:   MEM window: 0xfbf00000-0xfbffffff
> [    0.329365] pci 0000:00:1c.1:   PREFETCH window: disabled
> [    0.329377] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:03
> [    0.329381] pci 0000:00:1c.2:   IO window: disabled
> [    0.329390] pci 0000:00:1c.2:   MEM window: disabled
> [    0.329397] pci 0000:00:1c.2:   PREFETCH window: disabled
> [    0.329409] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:01
> [    0.329413] pci 0000:00:1c.3:   IO window: disabled
> [    0.329423] pci 0000:00:1c.3:   MEM window: 0xf8000000-0xfbefffff
> [    0.329432] pci 0000:00:1c.3:   PREFETCH window: 0x000000f0000000-0x000000f6ffffff
> [    0.329444] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:06
> [    0.329448] pci 0000:00:1e.0:   IO window: disabled
> [    0.329457] pci 0000:00:1e.0:   MEM window: disabled
> [    0.329465] pci 0000:00:1e.0:   PREFETCH window: disabled
> [    0.329497] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> [    0.329508] pci 0000:00:1c.0: setting latency timer to 64
> [    0.329525] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
> [    0.329534] pci 0000:00:1c.1: setting latency timer to 64
> [    0.329550] pci 0000:00:1c.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
> [    0.329558] pci 0000:00:1c.2: setting latency timer to 64
> [    0.329574] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
> [    0.329583] pci 0000:00:1c.3: setting latency timer to 64
> [    0.329595] pci 0000:00:1e.0: setting latency timer to 64
> [    0.329604] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
> [    0.329610] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
> [    0.329617] pci_bus 0000:04: resource 0 io:  [0xe000-0xefff]
> [    0.329623] pci_bus 0000:04: resource 1 mem: [0xfbf00000-0xfbffffff]
> [    0.329630] pci_bus 0000:01: resource 1 mem: [0xf8000000-0xfbefffff]
> [    0.329636] pci_bus 0000:01: resource 2 pref mem [0xf0000000-0xf6ffffff]
> [    0.329642] pci_bus 0000:06: resource 3 io:  [0x00-0xffff]
> [    0.329648] pci_bus 0000:06: resource 4 mem: [0x000000-0xffffffff]
> [    0.329680] NET: Registered protocol family 2
> [    0.356721] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.356882] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.357964] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.358512] TCP: Hash tables configured (established 131072 bind 65536)
> [    0.358519] TCP reno registered
> [    0.366834] NET: Registered protocol family 1
> [    0.366944] Trying to unpack rootfs image as initramfs...
> [    0.501201] Switched to high resolution mode on CPU 1
> [    0.503411] Switched to high resolution mode on CPU 0
> [    0.527933] Freeing initrd memory: 3439k freed
> [    0.532534] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [    0.533100] HugeTLB registered 4 MB page size, pre-allocated 0 pages
> [    0.536980] fuse init (API version 7.11)
> [    0.537217] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
> [    0.538047] SGI XFS Quota Management subsystem
> [    0.538272] msgmni has been set to 1753
> [    0.538509] alg: No test for cipher_null (cipher_null-generic)
> [    0.538558] alg: No test for ecb(cipher_null) (ecb-cipher_null)
> [    0.538612] alg: No test for digest_null (digest_null-generic)
> [    0.538662] alg: No test for compress_null (compress_null-generic)
> [    0.542016] alg: No test for stdrng (krng)
> [    0.542069] alg: No test for stdrng (ansi_cprng)
> [    0.542250] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> [    0.542259] io scheduler noop registered
> [    0.542264] io scheduler anticipatory registered (default)
> [    0.542268] io scheduler deadline registered
> [    0.542369] io scheduler cfq registered
> [    0.542397] pci 0000:00:02.0: Boot video device
> [    0.542749] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
> [    0.542775] pcieport-driver 0000:00:1c.0: setting latency timer to 64
> [    0.543009] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
> [    0.543032] pcieport-driver 0000:00:1c.1: setting latency timer to 64
> [    0.543261] pcieport-driver 0000:00:1c.2: irq 26 for MSI/MSI-X
> [    0.543285] pcieport-driver 0000:00:1c.2: setting latency timer to 64
> [    0.543577] pcieport-driver 0000:00:1c.3: irq 27 for MSI/MSI-X
> [    0.543602] pcieport-driver 0000:00:1c.3: setting latency timer to 64
> [    0.543783] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    0.546567] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> [    0.546573] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> [    0.550833] ALI M7101 PMU not found.
> [    0.551053] ACPI: AC Adapter [AC0] (off-line)
> [    0.551225] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [    0.551232] ACPI: Power Button [PWRF]
> [    0.551376] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
> [    0.552534] ACPI: EC: non-query interrupt received, switching to interrupt mode
> [    0.565739] ACPI: Lid Switch [LID]
> [    0.565876] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
> [    0.565882] ACPI: Sleep Button [SLPB]
> [    0.566008] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input3
> [    0.566014] ACPI: Power Button [PWRB]
> [    0.566717] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:17/input/input4
> [    0.566725] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
> [    0.567866] ACPI: SSDT 3f7ae180 0023C (v01  PmRef  Cpu0Ist 00003000 INTL 20060113)
> [    0.568477] ACPI: SSDT 3f7ae450 00724 (v01  PmRef  Cpu0Cst 00003001 INTL 20060113)
> [    0.569225] Monitor-Mwait will be used to enter C-1 state
> [    0.569288] Monitor-Mwait will be used to enter C-2 state
> [    0.569335] Monitor-Mwait will be used to enter C-3 state
> [    0.569351] Marking TSC unstable due to TSC halts in idle
> [    0.569392] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
> [    0.569452] processor ACPI_CPU:00: registered as cooling_device0
> [    0.569462] ACPI: Processor [P001] (supports 8 throttling states)
> [    0.570116] ACPI: SSDT 3f7ae0b0 000CC (v01  PmRef  Cpu1Ist 00003000 INTL 20060113)
> [    0.570655] ACPI: SSDT 3f7ae3c0 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20060113)
> [    0.571684] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
> [    0.571735] processor ACPI_CPU:01: registered as cooling_device1
> [    0.571744] ACPI: Processor [P002] (supports 8 throttling states)
> [    0.601843] thermal LNXTHERM:01: registered as thermal_zone0
> [    0.601861] ACPI: Thermal Zone [TZ00] (50 C)
> [    0.604536] Non-volatile memory driver v1.3
> [    0.604544] toshiba: not a supported Toshiba laptop
> [    0.605082] intel_rng: FWH not detected
> [    0.605146] Linux agpgart interface v0.103
> [    0.605181] agpgart-intel 0000:00:00.0: Intel 945GME Chipset
> [    0.605393] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
> [    0.608117] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
> [    0.608168] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
> [    0.608173] Hangcheck: Using get_cycles().
> [    0.608227] [drm] Initialized drm 1.1.0 20060810
> [    0.608275] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    0.608283] i915 0000:00:02.0: setting latency timer to 64
> [    0.856827] integrated sync not supported
> [    1.116780] integrated sync not supported
> [    1.122298] allocated 1024x600 fb: 0x007df000, bo f6f1c0c0
> [    1.122405] fbcon: inteldrmfb (fb0) is primary device
> [    1.124456] ACPI: Battery Slot [BAT0] (battery present)
> [    1.434767] [drm] LVDS-8: set mode 1024x600 c
> [    1.862137] Console: switching to colour frame buffer device 128x37
> [    1.868327] fb0: inteldrmfb frame buffer device
> [    1.868332] registered panic notifier
> [    1.868345] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> [    1.868399] intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/945GME/965G/965GM chipsets
> [    1.868405] intelfb: Version 0.9.6
> [    1.868447] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [    1.870500] brd: module loaded
> [    1.871232] loop: module loaded
> [    1.871267] Driver 'sd' needs updating - please use bus_type methods
> [    1.871288] Driver 'sr' needs updating - please use bus_type methods
> [    1.871396] ata_piix 0000:00:1f.2: version 2.13
> [    1.871433] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> [    1.871443] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
> [    1.871510] ata_piix 0000:00:1f.2: setting latency timer to 64
> [    1.871666] scsi0 : ata_piix
> [    1.871867] scsi1 : ata_piix
> [    1.874779] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
> [    1.874786] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
> [    1.874959] ATL1E 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [    1.874977] ATL1E 0000:04:00.0: setting latency timer to 64
> [    1.920219] hso: drivers/net/usb/hso.c: 1.2 Option Wireless
> [    1.920262] usbcore: registered new interface driver hso
> [    1.920310] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    1.920347] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> [    1.920369] ehci_hcd 0000:00:1d.7: setting latency timer to 64
> [    1.920377] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> [    1.920445] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
> [    1.924357] ehci_hcd 0000:00:1d.7: debug port 1
> [    1.924368] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
> [    1.924397] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf7eb7c00
> [    1.936696] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
> [    1.936751] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    1.936757] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.936763] usb usb1: Product: EHCI Host Controller
> [    1.936768] usb usb1: Manufacturer: Linux 2.6.30.3 ehci_hcd
> [    1.936773] usb usb1: SerialNumber: 0000:00:1d.7
> [    1.936888] usb usb1: configuration #1 chosen from 1 choice
> [    1.936947] hub 1-0:1.0: USB hub found
> [    1.936963] hub 1-0:1.0: 8 ports detected
> [    1.937166] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    1.937202] uhci_hcd: USB Universal Host Controller Interface driver
> [    1.937283] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> [    1.937297] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [    1.937304] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [    1.937346] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
> [    1.937383] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d480
> [    1.937453] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
> [    1.937459] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.937464] usb usb2: Product: UHCI Host Controller
> [    1.937469] usb usb2: Manufacturer: Linux 2.6.30.3 uhci_hcd
> [    1.937474] usb usb2: SerialNumber: 0000:00:1d.0
> [    1.937565] usb usb2: configuration #1 chosen from 1 choice
> [    1.937625] hub 2-0:1.0: USB hub found
> [    1.937638] hub 2-0:1.0: 2 ports detected
> [    1.937785] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> [    1.937797] uhci_hcd 0000:00:1d.1: setting latency timer to 64
> [    1.937804] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [    1.937845] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
> [    1.937892] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d800
> [    1.937960] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> [    1.937966] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.937971] usb usb3: Product: UHCI Host Controller
> [    1.937976] usb usb3: Manufacturer: Linux 2.6.30.3 uhci_hcd
> [    1.937981] usb usb3: SerialNumber: 0000:00:1d.1
> [    1.938074] usb usb3: configuration #1 chosen from 1 choice
> [    1.938129] hub 3-0:1.0: USB hub found
> [    1.938142] hub 3-0:1.0: 2 ports detected
> [    1.938295] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    1.938307] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> [    1.938314] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [    1.938365] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
> [    1.938411] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d880
> [    1.938481] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> [    1.938488] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.938493] usb usb4: Product: UHCI Host Controller
> [    1.938498] usb usb4: Manufacturer: Linux 2.6.30.3 uhci_hcd
> [    1.938502] usb usb4: SerialNumber: 0000:00:1d.2
> [    1.938601] usb usb4: configuration #1 chosen from 1 choice
> [    1.938656] hub 4-0:1.0: USB hub found
> [    1.938669] hub 4-0:1.0: 2 ports detected
> [    1.938817] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
> [    1.938829] uhci_hcd 0000:00:1d.3: setting latency timer to 64
> [    1.938835] uhci_hcd 0000:00:1d.3: UHCI Host Controller
> [    1.938880] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
> [    1.938916] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000dc00
> [    1.938984] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
> [    1.938990] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.938995] usb usb5: Product: UHCI Host Controller
> [    1.939000] usb usb5: Manufacturer: Linux 2.6.30.3 uhci_hcd
> [    1.939004] usb usb5: SerialNumber: 0000:00:1d.3
> [    1.939099] usb usb5: configuration #1 chosen from 1 choice
> [    1.939155] hub 5-0:1.0: USB hub found
> [    1.939168] hub 5-0:1.0: 2 ports detected
> [    1.939403] usbcore: registered new interface driver libusual
> [    1.939469] usbcore: registered new interface driver usbserial
> [    1.939491] USB Serial support registered for generic
> [    1.939523] usbcore: registered new interface driver usbserial_generic
> [    1.939527] usbserial: USB Serial Driver core
> [    1.939531] idmouse: 0.6:Siemens ID Mouse FingerTIP Sensor Driver
> [    1.939558] usbcore: registered new interface driver idmouse
> [    1.939646] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
> [    1.987439] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    1.987452] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    1.987523] mice: PS/2 mouse device common for all mice
> [    1.987905] rtc_cmos 00:03: RTC can wake from S4
> [    1.987995] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
> [    1.988041] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
> [    1.988072] i2c /dev entries driver
> [    1.988246] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> [    1.988394] coretemp: Unknown CPU model 1c
> [    1.988400] coretemp: Unknown CPU model 1c
> [    1.988425] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
> [    1.988548] iTCO_wdt: Found a ICH7-M or ICH7-U TCO device (Version=2, TCOBASE=0x0860)
> [    1.988614] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> [    1.988622] iTCO_vendor_support: vendor-support=0
> [    1.988894] device-mapper: uevent: version 1.0.3
> [    1.989109] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
> [    1.989342] Bluetooth: Generic Bluetooth USB driver ver 0.5
> [    1.989393] usbcore: registered new interface driver btusb
> [    1.989667] cpuidle: using governor ladder
> [    1.990498] cpuidle: using governor menu
> [    1.991039] usbcore: registered new interface driver hiddev
> [    1.991071] usbcore: registered new interface driver usbhid
> [    1.991076] usbhid: v2.6:USB HID core driver
> [    1.991185] nf_conntrack version 0.5.0 (14329 buckets, 57316 max)
> [    1.991405] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
> [    1.991410] nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
> [    1.991414] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
> [    1.991568] TCP cubic registered
> [    1.991574] NET: Registered protocol family 17
> [    1.991591] Bluetooth: L2CAP ver 2.13
> [    1.991595] Bluetooth: L2CAP socket layer initialized
> [    1.991601] Bluetooth: SCO (Voice Link) ver 0.6
> [    1.991604] Bluetooth: SCO socket layer initialized
> [    1.991727] Bluetooth: RFCOMM socket layer initialized
> [    1.991759] Bluetooth: RFCOMM TTY layer initialized
> [    1.991763] Bluetooth: RFCOMM ver 1.11
> [    1.991768] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [    1.991772] Bluetooth: BNEP filters: protocol multicast
> [    1.991776] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
> [    1.991818] lib80211: common routines for IEEE802.11 drivers
> [    1.991824] lib80211_crypt: registered algorithm 'NULL'
> [    1.992766] Using IPI No-Shortcut mode
> [    1.992924] TuxOnIce 3.0.1 (http://tuxonice.net)
> [    1.993030] TuxOnIce: Ignoring late initcall, as requested.
> [    1.993235] BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
> [    2.030841] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
> [    2.217590] ata2.00: CFA: ASUS-PHISON SSD, TST2.04U, max UDMA/66
> [    2.217598] ata2.00: 15761088 sectors, multi 0: LBA
> [    2.217654] ata2.01: CFA: ASUS-PHISON SSD, TST2.04P, max UDMA/66
> [    2.217660] ata2.01: 63045360 sectors, multi 0: LBA
> [    2.223828] ata2.00: configured for UDMA/66
> [    2.230481] ata2.01: configured for UDMA/66
> [    2.243619] scsi 1:0:0:0: Direct-Access     ATA      ASUS-PHISON SSD  TST2 PQ: 0 ANSI: 5
> [    2.243867] sd 1:0:0:0: Attached scsi generic sg0 type 0
> [    2.244043] scsi 1:0:1:0: Direct-Access     ATA      ASUS-PHISON SSD  TST2 PQ: 0 ANSI: 5
> [    2.244261] sd 1:0:1:0: Attached scsi generic sg1 type 0
> [    2.244387] sd 1:0:0:0: [sda] 15761088 512-byte hardware sectors: (8.06 GB/7.51 GiB)
> [    2.244428] sd 1:0:0:0: [sda] Write Protect is off
> [    2.244437] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    2.244451] sd 1:0:1:0: [sdb] 63045360 512-byte hardware sectors: (32.2 GB/30.0 GiB)
> [    2.244491] sd 1:0:1:0: [sdb] Write Protect is off
> [    2.244500] sd 1:0:1:0: [sdb] Mode Sense: 00 3a 00 00
> [    2.244506] sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> [    2.244580] sd 1:0:1:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> [    2.244804]  sda: sda1 sda2
> [    2.246263]  sdb:<5>sd 1:0:0:0: [sda] Attached SCSI disk
> [    2.247567]  sdb1 sdb2
> [    2.247967] sd 1:0:1:0: [sdb] Attached SCSI disk
> [    2.247996] Freeing unused kernel memory: 308k freed
> [    2.360877] usb 1-8: new high speed USB device using ehci_hcd and address 3
> [    2.503376] Clocksource tsc unstable (delta = -147696974 ns)
> [    2.534096] usb 1-8: New USB device found, idVendor=04f2, idProduct=b071
> [    2.534107] usb 1-8: New USB device strings: Mfr=2, Product=1, SerialNumber=3
> [    2.534115] usb 1-8: Product: CNF7129
> [    2.534121] usb 1-8: Manufacturer: Chicony Electronics Co., Ltd.
> [    2.534128] usb 1-8: SerialNumber: SN0001
> [    2.534317] usb 1-8: configuration #1 chosen from 1 choice
> [    2.723459] elantech.c: assuming hardware version 2, firmware version 2.48
> [    2.769780] usb 5-1: new full speed USB device using uhci_hcd and address 2
> [    2.820710] elantech.c: Synaptics capabilities query result 0x00, 0x02, 0x64.
> [    2.928032] usb 5-1: New USB device found, idVendor=0b05, idProduct=b700
> [    2.928048] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [    2.928060] usb 5-1: Product: BT-253
> [    2.928069] usb 5-1: Manufacturer: Broadcom Corp
> [    2.928077] usb 5-1: SerialNumber: 0015AFF93438
> [    2.928344] usb 5-1: configuration #1 chosen from 1 choice
> [    3.040748] input: ETPS/2 Elantech Touchpad as /devices/platform/i8042/serio1/input/input6
> [   11.001968] NILFS: INFO: recovery required for readonly filesystem.
> [   11.001976] NILFS: write access will be enabled during recovery.
> [   11.617945] NILFS: recovery complete.
> [   13.802149] udev: starting version 141
> [   13.990092] eeepc: Eee PC Hotkey Driver
> [   39.560645] eeepc: Hotkey init flags 0x41
> [   39.566131] eeepc: Get control methods supported: 0x101713
> [   39.566418] input: Asus EeePC extra buttons as /devices/virtual/input/input7
> [   40.591799] segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
> [   40.684069] kjournald starting.  Commit interval 5 seconds
> [   40.685101] EXT3 FS on sda1, internal journal
> [   40.685121] EXT3-fs: mounted filesystem with writeback data mode.
> [   40.795538] segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
> [   40.814804] NILFS warning: mounting unchecked fs
> [   40.846754] NILFS: recovery complete.
> [   40.965232] kjournald starting.  Commit interval 5 seconds
> [   40.967359] EXT3 FS on sdb2, internal journal
> [   40.967381] EXT3-fs: mounted filesystem with writeback data mode.
> [   41.489156] Adding 524280k swap on /dev/mapper/vg_void-lv_swap.  Priority:-1 extents:1 across:524280k
> [   46.165107] Bridge firewalling registered
> [   50.292425] ATL1E 0000:04:00.0: irq 28 for MSI/MSI-X
> [   59.083629] integrated sync not supported
> [   59.366945] integrated sync not supported
> [   65.140193] integrated sync not supported
> [   65.423612] integrated sync not supported
> [   65.706924] integrated sync not supported
> [   83.596834] usb 5-1: USB disconnect, address 2
> [   83.597038] btusb_intr_complete: hci0 urb f558ea00 failed to resubmit (19)
> [   83.597067] btusb_bulk_complete: hci0 urb f558e580 failed to resubmit (19)
> [   83.598011] btusb_bulk_complete: hci0 urb f558ea80 failed to resubmit (19)
> [   83.598786] btusb_send_frame: hci0 urb f3205300 submission failed
>
> config:
>
> #
> # Automatically generated make config: don't edit
> # Linux kernel version: 2.6.30.3
> # Sun Jul 26 20:56:06 2009
> #
> # CONFIG_64BIT is not set
> CONFIG_X86_32=y
> # CONFIG_X86_64 is not set
> CONFIG_X86=y
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
> CONFIG_GENERIC_TIME=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> CONFIG_FAST_CMPXCHG_LOCAL=y
> CONFIG_MMU=y
> CONFIG_ZONE_DMA=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> # CONFIG_RWSEM_GENERIC_SPINLOCK is not set
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> # CONFIG_GENERIC_TIME_VSYSCALL is not set
> CONFIG_ARCH_HAS_CPU_RELAX=y
> CONFIG_ARCH_HAS_DEFAULT_IDLE=y
> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> CONFIG_HAVE_DYNAMIC_PER_CPU_AREA=y
> # CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> # CONFIG_ZONE_DMA32 is not set
> CONFIG_ARCH_POPULATES_NODE_MAP=y
> # CONFIG_AUDIT_ARCH is not set
> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> CONFIG_GENERIC_HARDIRQS=y
> CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_PENDING_IRQ=y
> CONFIG_USE_GENERIC_SMP_HELPERS=y
> CONFIG_X86_32_SMP=y
> CONFIG_X86_HT=y
> CONFIG_X86_TRAMPOLINE=y
> CONFIG_X86_32_LAZY_GS=y
> CONFIG_KTIME_SCALAR=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
>
> #
> # General setup
> #
> CONFIG_EXPERIMENTAL=y
> CONFIG_LOCK_KERNEL=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_LOCALVERSION=""
> # CONFIG_LOCALVERSION_AUTO is not set
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_HAVE_KERNEL_BZIP2=y
> CONFIG_HAVE_KERNEL_LZMA=y
> # CONFIG_KERNEL_GZIP is not set
> # CONFIG_KERNEL_BZIP2 is not set
> CONFIG_KERNEL_LZMA=y
> CONFIG_SWAP=y
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> CONFIG_POSIX_MQUEUE=y
> CONFIG_POSIX_MQUEUE_SYSCTL=y
> # CONFIG_BSD_PROCESS_ACCT is not set
> # CONFIG_TASKSTATS is not set
> # CONFIG_AUDIT is not set
>
> #
> # RCU Subsystem
> #
> CONFIG_CLASSIC_RCU=y
> # CONFIG_TREE_RCU is not set
> # CONFIG_PREEMPT_RCU is not set
> # CONFIG_TREE_RCU_TRACE is not set
> # CONFIG_PREEMPT_RCU_TRACE is not set
> CONFIG_IKCONFIG=y
> CONFIG_IKCONFIG_PROC=y
> CONFIG_LOG_BUF_SHIFT=18
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> CONFIG_GROUP_SCHED=y
> CONFIG_FAIR_GROUP_SCHED=y
> CONFIG_RT_GROUP_SCHED=y
> # CONFIG_USER_SCHED is not set
> CONFIG_CGROUP_SCHED=y
> CONFIG_CGROUPS=y
> # CONFIG_CGROUP_DEBUG is not set
> CONFIG_CGROUP_NS=y
> CONFIG_CGROUP_FREEZER=y
> CONFIG_CGROUP_DEVICE=y
> CONFIG_CPUSETS=y
> CONFIG_PROC_PID_CPUSET=y
> CONFIG_CGROUP_CPUACCT=y
> CONFIG_RESOURCE_COUNTERS=y
> CONFIG_CGROUP_MEM_RES_CTLR=y
> CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
> CONFIG_MM_OWNER=y
> # CONFIG_SYSFS_DEPRECATED_V2 is not set
> CONFIG_RELAY=y
> CONFIG_NAMESPACES=y
> CONFIG_UTS_NS=y
> CONFIG_IPC_NS=y
> CONFIG_USER_NS=y
> CONFIG_PID_NS=y
> CONFIG_NET_NS=y
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_RD_GZIP=y
> CONFIG_RD_BZIP2=y
> CONFIG_RD_LZMA=y
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> CONFIG_SYSCTL=y
> CONFIG_ANON_INODES=y
> # CONFIG_EMBEDDED is not set
> CONFIG_UID16=y
> CONFIG_SYSCTL_SYSCALL=y
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_EXTRA_PASS=y
> # CONFIG_STRIP_ASM_SYMS is not set
> CONFIG_HOTPLUG=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_PCSPKR_PLATFORM=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_AIO=y
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_PCI_QUIRKS=y
> CONFIG_SLUB_DEBUG=y
> # CONFIG_COMPAT_BRK is not set
> # CONFIG_SLAB is not set
> CONFIG_SLUB=y
> # CONFIG_SLOB is not set
> # CONFIG_PROFILING is not set
> # CONFIG_MARKERS is not set
> CONFIG_HAVE_OPROFILE=y
> # CONFIG_KPROBES is not set
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_HAVE_IOREMAP_PROT=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> CONFIG_HAVE_DMA_API_DEBUG=y
> # CONFIG_SLOW_WORK is not set
> CONFIG_HAVE_GENERIC_DMA_COHERENT=y
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=0
> CONFIG_MODULES=y
> # CONFIG_MODULE_FORCE_LOAD is not set
> CONFIG_MODULE_UNLOAD=y
> # CONFIG_MODULE_FORCE_UNLOAD is not set
> CONFIG_MODVERSIONS=y
> CONFIG_MODULE_SRCVERSION_ALL=y
> CONFIG_STOP_MACHINE=y
> CONFIG_BLOCK=y
> CONFIG_LBD=y
> CONFIG_BLK_DEV_BSG=y
> CONFIG_BLK_DEV_INTEGRITY=y
>
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_AS=y
> CONFIG_IOSCHED_DEADLINE=y
> CONFIG_IOSCHED_CFQ=y
> CONFIG_DEFAULT_AS=y
> # CONFIG_DEFAULT_DEADLINE is not set
> # CONFIG_DEFAULT_CFQ is not set
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="anticipatory"
> CONFIG_FREEZER=y
>
> #
> # Processor type and features
> #
> CONFIG_TICK_ONESHOT=y
> CONFIG_NO_HZ=y
> CONFIG_HIGH_RES_TIMERS=y
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> CONFIG_SMP=y
> # CONFIG_SPARSE_IRQ is not set
> # CONFIG_X86_MPPARSE is not set
> # CONFIG_X86_BIGSMP is not set
> # CONFIG_X86_EXTENDED_PLATFORM is not set
> CONFIG_SCHED_OMIT_FRAME_POINTER=y
> # CONFIG_PARAVIRT_GUEST is not set
> # CONFIG_MEMTEST is not set
> # CONFIG_M386 is not set
> # CONFIG_M486 is not set
> # CONFIG_M586 is not set
> # CONFIG_M586TSC is not set
> # CONFIG_M586MMX is not set
> # CONFIG_M686 is not set
> # CONFIG_MPENTIUMII is not set
> # CONFIG_MPENTIUMIII is not set
> # CONFIG_MPENTIUMM is not set
> # CONFIG_MPENTIUM4 is not set
> # CONFIG_MK6 is not set
> # CONFIG_MK7 is not set
> # CONFIG_MK8 is not set
> # CONFIG_MCRUSOE is not set
> # CONFIG_MEFFICEON is not set
> # CONFIG_MWINCHIPC6 is not set
> # CONFIG_MWINCHIP3D is not set
> # CONFIG_MGEODEGX1 is not set
> # CONFIG_MGEODE_LX is not set
> # CONFIG_MCYRIXIII is not set
> # CONFIG_MVIAC3_2 is not set
> # CONFIG_MVIAC7 is not set
> # CONFIG_MPSC is not set
> CONFIG_MCORE2=y
> # CONFIG_GENERIC_CPU is not set
> CONFIG_X86_GENERIC=y
> CONFIG_X86_CPU=y
> CONFIG_X86_L1_CACHE_BYTES=64
> CONFIG_X86_INTERNODE_CACHE_BYTES=64
> CONFIG_X86_CMPXCHG=y
> CONFIG_X86_L1_CACHE_SHIFT=6
> CONFIG_X86_XADD=y
> CONFIG_X86_WP_WORKS_OK=y
> CONFIG_X86_INVLPG=y
> CONFIG_X86_BSWAP=y
> CONFIG_X86_POPAD_OK=y
> CONFIG_X86_INTEL_USERCOPY=y
> CONFIG_X86_USE_PPRO_CHECKSUM=y
> CONFIG_X86_TSC=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=4
> CONFIG_X86_DEBUGCTLMSR=y
> CONFIG_CPU_SUP_INTEL=y
> CONFIG_CPU_SUP_CYRIX_32=y
> CONFIG_CPU_SUP_AMD=y
> CONFIG_CPU_SUP_CENTAUR=y
> CONFIG_CPU_SUP_TRANSMETA_32=y
> CONFIG_CPU_SUP_UMC_32=y
> # CONFIG_X86_DS is not set
> CONFIG_HPET_TIMER=y
> CONFIG_HPET_EMULATE_RTC=y
> CONFIG_DMI=y
> # CONFIG_IOMMU_HELPER is not set
> # CONFIG_IOMMU_API is not set
> CONFIG_NR_CPUS=2
> CONFIG_SCHED_SMT=y
> CONFIG_SCHED_MC=y
> # CONFIG_PREEMPT_NONE is not set
> # CONFIG_PREEMPT_VOLUNTARY is not set
> CONFIG_PREEMPT=y
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> # CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
> CONFIG_X86_MCE=y
> # CONFIG_X86_MCE_NONFATAL is not set
> # CONFIG_X86_MCE_P4THERMAL is not set
> CONFIG_VM86=y
> CONFIG_TOSHIBA=y
> CONFIG_I8K=y
> # CONFIG_X86_REBOOTFIXUPS is not set
> CONFIG_MICROCODE=y
> CONFIG_MICROCODE_INTEL=y
> # CONFIG_MICROCODE_AMD is not set
> CONFIG_MICROCODE_OLD_INTERFACE=y
> CONFIG_X86_MSR=y
> CONFIG_X86_CPUID=y
> # CONFIG_X86_CPU_DEBUG is not set
> CONFIG_NOHIGHMEM=y
> # CONFIG_HIGHMEM4G is not set
> # CONFIG_HIGHMEM64G is not set
> CONFIG_PAGE_OFFSET=0xC0000000
> # CONFIG_X86_PAE is not set
> # CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
> CONFIG_ARCH_FLATMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_SELECT_MEMORY_MODEL=y
> CONFIG_FLATMEM_MANUAL=y
> # CONFIG_DISCONTIGMEM_MANUAL is not set
> # CONFIG_SPARSEMEM_MANUAL is not set
> CONFIG_FLATMEM=y
> CONFIG_FLAT_NODE_MEM_MAP=y
> CONFIG_SPARSEMEM_STATIC=y
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_SPLIT_PTLOCK_CPUS=4
> # CONFIG_PHYS_ADDR_T_64BIT is not set
> CONFIG_ZONE_DMA_FLAG=1
> CONFIG_BOUNCE=y
> CONFIG_VIRT_TO_BUS=y
> CONFIG_UNEVICTABLE_LRU=y
> CONFIG_HAVE_MLOCK=y
> CONFIG_HAVE_MLOCKED_PAGE_BIT=y
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> # CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
> CONFIG_X86_RESERVE_LOW_64K=y
> # CONFIG_MATH_EMULATION is not set
> CONFIG_MTRR=y
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> CONFIG_X86_PAT=y
> # CONFIG_EFI is not set
> CONFIG_SECCOMP=y
> # CONFIG_CC_STACKPROTECTOR is not set
> # CONFIG_HZ_100 is not set
> # CONFIG_HZ_250 is not set
> CONFIG_HZ_300=y
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=300
> CONFIG_SCHED_HRTICK=y
> CONFIG_KEXEC=y
> # CONFIG_KEXEC_JUMP is not set
> CONFIG_PHYSICAL_START=0x100000
> # CONFIG_RELOCATABLE is not set
> CONFIG_PHYSICAL_ALIGN=0x400000
> CONFIG_HOTPLUG_CPU=y
> # CONFIG_COMPAT_VDSO is not set
> # CONFIG_CMDLINE_BOOL is not set
>
> #
> # Power management and ACPI options
> #
> CONFIG_PM=y
> # CONFIG_PM_DEBUG is not set
> CONFIG_PM_SLEEP_SMP=y
> CONFIG_PM_SLEEP=y
> CONFIG_SUSPEND=y
> CONFIG_SUSPEND_FREEZER=y
> CONFIG_HIBERNATION=y
> CONFIG_PM_STD_PARTITION=""
> CONFIG_TOI_CORE=y
>
> #
> # Image Storage (you need at least one allocator)
> #
> CONFIG_TOI_FILE=y
> CONFIG_TOI_SWAP=y
>
> #
> # General Options
> #
> CONFIG_TOI_CRYPTO=y
> CONFIG_TOI_USERUI=y
> CONFIG_TOI_USERUI_DEFAULT_PATH="/usr/local/sbin/tuxoniceui_text"
> # CONFIG_TOI_KEEP_IMAGE is not set
> CONFIG_TOI_REPLACE_SWSUSP=y
> CONFIG_TOI_IGNORE_LATE_INITCALL=y
> CONFIG_TOI_DEFAULT_WAIT=25
> CONFIG_TOI_DEFAULT_EXTRA_PAGES_ALLOWANCE=2000
> # CONFIG_TOI_CHECKSUM is not set
> CONFIG_TOI=y
> CONFIG_ACPI=y
> CONFIG_ACPI_SLEEP=y
> # CONFIG_ACPI_PROCFS is not set
> # CONFIG_ACPI_PROCFS_POWER is not set
> CONFIG_ACPI_SYSFS_POWER=y
> # CONFIG_ACPI_PROC_EVENT is not set
> CONFIG_ACPI_AC=y
> CONFIG_ACPI_BATTERY=y
> CONFIG_ACPI_BUTTON=y
> CONFIG_ACPI_VIDEO=y
> CONFIG_ACPI_FAN=y
> CONFIG_ACPI_DOCK=y
> CONFIG_ACPI_PROCESSOR=y
> CONFIG_ACPI_HOTPLUG_CPU=y
> CONFIG_ACPI_THERMAL=y
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> CONFIG_ACPI_BLACKLIST_YEAR=1999
> # CONFIG_ACPI_DEBUG is not set
> CONFIG_ACPI_PCI_SLOT=y
> CONFIG_X86_PM_TIMER=y
> CONFIG_ACPI_CONTAINER=y
> CONFIG_ACPI_SBS=y
> # CONFIG_APM is not set
>
> #
> # CPU Frequency scaling
> #
> CONFIG_CPU_FREQ=y
> CONFIG_CPU_FREQ_TABLE=y
> CONFIG_CPU_FREQ_DEBUG=y
> CONFIG_CPU_FREQ_STAT=y
> CONFIG_CPU_FREQ_STAT_DETAILS=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
> CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
> CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
> CONFIG_CPU_FREQ_GOV_POWERSAVE=y
> CONFIG_CPU_FREQ_GOV_USERSPACE=y
> CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
>
> #
> # CPUFreq processor drivers
> #
> CONFIG_X86_ACPI_CPUFREQ=y
> # CONFIG_X86_POWERNOW_K6 is not set
> # CONFIG_X86_POWERNOW_K7 is not set
> # CONFIG_X86_POWERNOW_K8 is not set
> # CONFIG_X86_GX_SUSPMOD is not set
> # CONFIG_X86_SPEEDSTEP_CENTRINO is not set
> CONFIG_X86_SPEEDSTEP_ICH=y
> CONFIG_X86_SPEEDSTEP_SMI=y
> # CONFIG_X86_P4_CLOCKMOD is not set
> # CONFIG_X86_CPUFREQ_NFORCE2 is not set
> CONFIG_X86_LONGRUN=y
> # CONFIG_X86_LONGHAUL is not set
> # CONFIG_X86_E_POWERSAVER is not set
>
> #
> # shared options
> #
> CONFIG_X86_SPEEDSTEP_LIB=y
> # CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set
> CONFIG_CPU_IDLE=y
> CONFIG_CPU_IDLE_GOV_LADDER=y
> CONFIG_CPU_IDLE_GOV_MENU=y
>
> #
> # Bus options (PCI etc.)
> #
> CONFIG_PCI=y
> # CONFIG_PCI_GOBIOS is not set
> # CONFIG_PCI_GOMMCONFIG is not set
> # CONFIG_PCI_GODIRECT is not set
> # CONFIG_PCI_GOOLPC is not set
> CONFIG_PCI_GOANY=y
> CONFIG_PCI_BIOS=y
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_MMCONFIG=y
> CONFIG_PCI_DOMAINS=y
> # CONFIG_DMAR is not set
> CONFIG_PCIEPORTBUS=y
> CONFIG_HOTPLUG_PCI_PCIE=y
> CONFIG_PCIEAER=y
> CONFIG_PCIEASPM=y
> # CONFIG_PCIEASPM_DEBUG is not set
> CONFIG_ARCH_SUPPORTS_MSI=y
> CONFIG_PCI_MSI=y
> CONFIG_PCI_LEGACY=y
> # CONFIG_PCI_STUB is not set
> # CONFIG_HT_IRQ is not set
> # CONFIG_PCI_IOV is not set
> CONFIG_ISA_DMA_API=y
> # CONFIG_ISA is not set
> # CONFIG_MCA is not set
> # CONFIG_SCx200 is not set
> # CONFIG_OLPC is not set
> # CONFIG_PCCARD is not set
> CONFIG_HOTPLUG_PCI=y
> # CONFIG_HOTPLUG_PCI_FAKE is not set
> # CONFIG_HOTPLUG_PCI_COMPAQ is not set
> # CONFIG_HOTPLUG_PCI_IBM is not set
> CONFIG_HOTPLUG_PCI_ACPI=y
> # CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
> # CONFIG_HOTPLUG_PCI_CPCI is not set
> # CONFIG_HOTPLUG_PCI_SHPC is not set
>
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
> CONFIG_HAVE_AOUT=y
> # CONFIG_BINFMT_AOUT is not set
> CONFIG_BINFMT_MISC=y
> CONFIG_HAVE_ATOMIC_IOMAP=y
> CONFIG_NET=y
>
> #
> # Networking options
> #
> CONFIG_PACKET=y
> CONFIG_PACKET_MMAP=y
> CONFIG_UNIX=y
> # CONFIG_NET_KEY is not set
> CONFIG_INET=y
> CONFIG_IP_MULTICAST=y
> CONFIG_IP_ADVANCED_ROUTER=y
> CONFIG_ASK_IP_FIB_HASH=y
> # CONFIG_IP_FIB_TRIE is not set
> CONFIG_IP_FIB_HASH=y
> CONFIG_IP_MULTIPLE_TABLES=y
> CONFIG_IP_ROUTE_MULTIPATH=y
> CONFIG_IP_ROUTE_VERBOSE=y
> # CONFIG_IP_PNP is not set
> CONFIG_NET_IPIP=m
> CONFIG_NET_IPGRE=m
> CONFIG_NET_IPGRE_BROADCAST=y
> CONFIG_IP_MROUTE=y
> CONFIG_IP_PIMSM_V1=y
> CONFIG_IP_PIMSM_V2=y
> # CONFIG_ARPD is not set
> CONFIG_SYN_COOKIES=y
> # CONFIG_INET_AH is not set
> # CONFIG_INET_ESP is not set
> # CONFIG_INET_IPCOMP is not set
> # CONFIG_INET_XFRM_TUNNEL is not set
> CONFIG_INET_TUNNEL=m
> # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
> # CONFIG_INET_XFRM_MODE_TUNNEL is not set
> # CONFIG_INET_XFRM_MODE_BEET is not set
> CONFIG_INET_LRO=y
> CONFIG_INET_DIAG=y
> CONFIG_INET_TCP_DIAG=y
> CONFIG_TCP_CONG_ADVANCED=y
> CONFIG_TCP_CONG_BIC=m
> CONFIG_TCP_CONG_CUBIC=y
> CONFIG_TCP_CONG_WESTWOOD=m
> CONFIG_TCP_CONG_HTCP=m
> CONFIG_TCP_CONG_HSTCP=m
> CONFIG_TCP_CONG_HYBLA=m
> CONFIG_TCP_CONG_VEGAS=m
> CONFIG_TCP_CONG_SCALABLE=m
> CONFIG_TCP_CONG_LP=m
> CONFIG_TCP_CONG_VENO=m
> CONFIG_TCP_CONG_YEAH=m
> CONFIG_TCP_CONG_ILLINOIS=m
> # CONFIG_DEFAULT_BIC is not set
> CONFIG_DEFAULT_CUBIC=y
> # CONFIG_DEFAULT_HTCP is not set
> # CONFIG_DEFAULT_VEGAS is not set
> # CONFIG_DEFAULT_WESTWOOD is not set
> # CONFIG_DEFAULT_RENO is not set
> CONFIG_DEFAULT_TCP_CONG="cubic"
> CONFIG_TCP_MD5SIG=y
> # CONFIG_IPV6 is not set
> # CONFIG_NETWORK_SECMARK is not set
> CONFIG_NETFILTER=y
> # CONFIG_NETFILTER_DEBUG is not set
> CONFIG_NETFILTER_ADVANCED=y
> CONFIG_BRIDGE_NETFILTER=y
>
> #
> # Core Netfilter Configuration
> #
> CONFIG_NETFILTER_NETLINK=m
> CONFIG_NETFILTER_NETLINK_QUEUE=m
> CONFIG_NETFILTER_NETLINK_LOG=m
> CONFIG_NF_CONNTRACK=y
> CONFIG_NF_CT_ACCT=y
> CONFIG_NF_CONNTRACK_MARK=y
> CONFIG_NF_CONNTRACK_EVENTS=y
> CONFIG_NF_CT_PROTO_DCCP=m
> CONFIG_NF_CT_PROTO_GRE=m
> CONFIG_NF_CT_PROTO_SCTP=m
> CONFIG_NF_CT_PROTO_UDPLITE=m
> CONFIG_NF_CONNTRACK_AMANDA=m
> CONFIG_NF_CONNTRACK_FTP=m
> CONFIG_NF_CONNTRACK_H323=m
> CONFIG_NF_CONNTRACK_IRC=m
> CONFIG_NF_CONNTRACK_NETBIOS_NS=m
> CONFIG_NF_CONNTRACK_PPTP=m
> CONFIG_NF_CONNTRACK_SANE=m
> CONFIG_NF_CONNTRACK_SIP=m
> CONFIG_NF_CONNTRACK_TFTP=m
> CONFIG_NF_CT_NETLINK=m
> CONFIG_NETFILTER_TPROXY=m
> CONFIG_NETFILTER_XTABLES=y
> CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
> CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
> CONFIG_NETFILTER_XT_TARGET_DSCP=m
> CONFIG_NETFILTER_XT_TARGET_HL=m
> # CONFIG_NETFILTER_XT_TARGET_LED is not set
> CONFIG_NETFILTER_XT_TARGET_MARK=m
> CONFIG_NETFILTER_XT_TARGET_NFLOG=m
> CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
> CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
> CONFIG_NETFILTER_XT_TARGET_RATEEST=m
> CONFIG_NETFILTER_XT_TARGET_TPROXY=m
> CONFIG_NETFILTER_XT_TARGET_TRACE=m
> CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
> CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m
> # CONFIG_NETFILTER_XT_MATCH_CLUSTER is not set
> CONFIG_NETFILTER_XT_MATCH_COMMENT=m
> CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
> CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
> CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
> CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
> CONFIG_NETFILTER_XT_MATCH_DCCP=m
> CONFIG_NETFILTER_XT_MATCH_DSCP=m
> CONFIG_NETFILTER_XT_MATCH_ESP=m
> CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
> CONFIG_NETFILTER_XT_MATCH_HELPER=m
> CONFIG_NETFILTER_XT_MATCH_HL=m
> CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
> CONFIG_NETFILTER_XT_MATCH_LENGTH=m
> CONFIG_NETFILTER_XT_MATCH_LIMIT=m
> CONFIG_NETFILTER_XT_MATCH_MAC=m
> CONFIG_NETFILTER_XT_MATCH_MARK=m
> CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
> CONFIG_NETFILTER_XT_MATCH_OWNER=m
> CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
> CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
> CONFIG_NETFILTER_XT_MATCH_QUOTA=m
> CONFIG_NETFILTER_XT_MATCH_RATEEST=m
> CONFIG_NETFILTER_XT_MATCH_REALM=m
> CONFIG_NETFILTER_XT_MATCH_RECENT=m
> # CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT is not set
> CONFIG_NETFILTER_XT_MATCH_SCTP=m
> CONFIG_NETFILTER_XT_MATCH_SOCKET=m
> CONFIG_NETFILTER_XT_MATCH_STATE=y
> CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
> CONFIG_NETFILTER_XT_MATCH_STRING=m
> CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
> CONFIG_NETFILTER_XT_MATCH_TIME=m
> CONFIG_NETFILTER_XT_MATCH_U32=m
> # CONFIG_IP_VS is not set
>
> #
> # IP: Netfilter Configuration
> #
> CONFIG_NF_DEFRAG_IPV4=y
> CONFIG_NF_CONNTRACK_IPV4=y
> # CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
> # CONFIG_IP_NF_QUEUE is not set
> CONFIG_IP_NF_IPTABLES=m
> CONFIG_IP_NF_MATCH_ADDRTYPE=m
> CONFIG_IP_NF_MATCH_AH=m
> CONFIG_IP_NF_MATCH_ECN=m
> CONFIG_IP_NF_MATCH_TTL=m
> CONFIG_IP_NF_FILTER=m
> CONFIG_IP_NF_TARGET_REJECT=m
> CONFIG_IP_NF_TARGET_LOG=m
> CONFIG_IP_NF_TARGET_ULOG=m
> CONFIG_NF_NAT=m
> CONFIG_NF_NAT_NEEDED=y
> CONFIG_IP_NF_TARGET_MASQUERADE=m
> CONFIG_IP_NF_TARGET_NETMAP=m
> CONFIG_IP_NF_TARGET_REDIRECT=m
> CONFIG_NF_NAT_SNMP_BASIC=m
> CONFIG_NF_NAT_PROTO_DCCP=m
> CONFIG_NF_NAT_PROTO_GRE=m
> CONFIG_NF_NAT_PROTO_UDPLITE=m
> CONFIG_NF_NAT_PROTO_SCTP=m
> CONFIG_NF_NAT_FTP=m
> CONFIG_NF_NAT_IRC=m
> CONFIG_NF_NAT_TFTP=m
> CONFIG_NF_NAT_AMANDA=m
> CONFIG_NF_NAT_PPTP=m
> CONFIG_NF_NAT_H323=m
> CONFIG_NF_NAT_SIP=m
> CONFIG_IP_NF_MANGLE=m
> CONFIG_IP_NF_TARGET_CLUSTERIP=m
> CONFIG_IP_NF_TARGET_ECN=m
> CONFIG_IP_NF_TARGET_TTL=m
> CONFIG_IP_NF_RAW=m
> CONFIG_IP_NF_ARPTABLES=m
> CONFIG_IP_NF_ARPFILTER=m
> CONFIG_IP_NF_ARP_MANGLE=m
> CONFIG_BRIDGE_NF_EBTABLES=m
> CONFIG_BRIDGE_EBT_BROUTE=m
> CONFIG_BRIDGE_EBT_T_FILTER=m
> CONFIG_BRIDGE_EBT_T_NAT=m
> CONFIG_BRIDGE_EBT_802_3=m
> CONFIG_BRIDGE_EBT_AMONG=m
> CONFIG_BRIDGE_EBT_ARP=m
> CONFIG_BRIDGE_EBT_IP=m
> CONFIG_BRIDGE_EBT_LIMIT=m
> CONFIG_BRIDGE_EBT_MARK=m
> CONFIG_BRIDGE_EBT_PKTTYPE=m
> CONFIG_BRIDGE_EBT_STP=m
> CONFIG_BRIDGE_EBT_VLAN=m
> CONFIG_BRIDGE_EBT_ARPREPLY=m
> CONFIG_BRIDGE_EBT_DNAT=m
> CONFIG_BRIDGE_EBT_MARK_T=m
> CONFIG_BRIDGE_EBT_REDIRECT=m
> CONFIG_BRIDGE_EBT_SNAT=m
> CONFIG_BRIDGE_EBT_LOG=m
> CONFIG_BRIDGE_EBT_ULOG=m
> CONFIG_BRIDGE_EBT_NFLOG=m
> # CONFIG_IP_DCCP is not set
> # CONFIG_IP_SCTP is not set
> # CONFIG_TIPC is not set
> # CONFIG_ATM is not set
> CONFIG_STP=m
> CONFIG_GARP=m
> CONFIG_BRIDGE=m
> # CONFIG_NET_DSA is not set
> CONFIG_VLAN_8021Q=m
> CONFIG_VLAN_8021Q_GVRP=y
> # CONFIG_DECNET is not set
> CONFIG_LLC=m
> # CONFIG_LLC2 is not set
> # CONFIG_IPX is not set
> # CONFIG_ATALK is not set
> # CONFIG_X25 is not set
> # CONFIG_LAPB is not set
> # CONFIG_ECONET is not set
> # CONFIG_WAN_ROUTER is not set
> # CONFIG_PHONET is not set
> CONFIG_NET_SCHED=y
>
> #
> # Queueing/Scheduling
> #
> CONFIG_NET_SCH_CBQ=m
> CONFIG_NET_SCH_HTB=m
> CONFIG_NET_SCH_HFSC=m
> CONFIG_NET_SCH_PRIO=m
> CONFIG_NET_SCH_MULTIQ=m
> CONFIG_NET_SCH_RED=m
> CONFIG_NET_SCH_SFQ=m
> CONFIG_NET_SCH_TEQL=m
> CONFIG_NET_SCH_TBF=m
> CONFIG_NET_SCH_GRED=m
> CONFIG_NET_SCH_DSMARK=m
> CONFIG_NET_SCH_NETEM=m
> CONFIG_NET_SCH_DRR=m
> CONFIG_NET_SCH_INGRESS=m
>
> #
> # Classification
> #
> CONFIG_NET_CLS=y
> CONFIG_NET_CLS_BASIC=m
> CONFIG_NET_CLS_TCINDEX=m
> CONFIG_NET_CLS_ROUTE4=m
> CONFIG_NET_CLS_ROUTE=y
> CONFIG_NET_CLS_FW=m
> CONFIG_NET_CLS_U32=m
> CONFIG_CLS_U32_PERF=y
> CONFIG_CLS_U32_MARK=y
> CONFIG_NET_CLS_RSVP=m
> CONFIG_NET_CLS_RSVP6=m
> CONFIG_NET_CLS_FLOW=m
> CONFIG_NET_CLS_CGROUP=y
> CONFIG_NET_EMATCH=y
> CONFIG_NET_EMATCH_STACK=32
> CONFIG_NET_EMATCH_CMP=m
> CONFIG_NET_EMATCH_NBYTE=m
> CONFIG_NET_EMATCH_U32=m
> CONFIG_NET_EMATCH_META=m
> CONFIG_NET_EMATCH_TEXT=m
> CONFIG_NET_CLS_ACT=y
> CONFIG_NET_ACT_POLICE=m
> CONFIG_NET_ACT_GACT=m
> CONFIG_GACT_PROB=y
> CONFIG_NET_ACT_MIRRED=m
> CONFIG_NET_ACT_IPT=m
> CONFIG_NET_ACT_NAT=m
> CONFIG_NET_ACT_PEDIT=m
> CONFIG_NET_ACT_SIMP=m
> CONFIG_NET_ACT_SKBEDIT=m
> CONFIG_NET_CLS_IND=y
> CONFIG_NET_SCH_FIFO=y
> # CONFIG_DCB is not set
>
> #
> # Network testing
> #
> # CONFIG_NET_PKTGEN is not set
> # CONFIG_HAMRADIO is not set
> # CONFIG_CAN is not set
> # CONFIG_IRDA is not set
> CONFIG_BT=y
> CONFIG_BT_L2CAP=y
> CONFIG_BT_SCO=y
> CONFIG_BT_RFCOMM=y
> CONFIG_BT_RFCOMM_TTY=y
> CONFIG_BT_BNEP=y
> CONFIG_BT_BNEP_MC_FILTER=y
> CONFIG_BT_BNEP_PROTO_FILTER=y
> CONFIG_BT_HIDP=y
>
> #
> # Bluetooth device drivers
> #
> CONFIG_BT_HCIBTUSB=y
> # CONFIG_BT_HCIUART is not set
> # CONFIG_BT_HCIBCM203X is not set
> # CONFIG_BT_HCIBPA10X is not set
> # CONFIG_BT_HCIBFUSB is not set
> # CONFIG_BT_HCIVHCI is not set
> # CONFIG_AF_RXRPC is not set
> CONFIG_FIB_RULES=y
> CONFIG_WIRELESS=y
> CONFIG_CFG80211=y
> CONFIG_CFG80211_REG_DEBUG=y
> # CONFIG_WIRELESS_OLD_REGULATORY is not set
> CONFIG_WIRELESS_EXT=y
> CONFIG_WIRELESS_EXT_SYSFS=y
> CONFIG_LIB80211=y
> # CONFIG_LIB80211_DEBUG is not set
> CONFIG_MAC80211=y
>
> #
> # Rate control algorithm selection
> #
> CONFIG_MAC80211_RC_MINSTREL=y
> # CONFIG_MAC80211_RC_DEFAULT_PID is not set
> CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
> CONFIG_MAC80211_RC_DEFAULT="minstrel"
> CONFIG_MAC80211_MESH=y
> CONFIG_MAC80211_LEDS=y
> CONFIG_MAC80211_DEBUGFS=y
> # CONFIG_MAC80211_DEBUG_MENU is not set
> # CONFIG_WIMAX is not set
> CONFIG_RFKILL=y
> CONFIG_RFKILL_INPUT=y
> CONFIG_RFKILL_LEDS=y
> # CONFIG_NET_9P is not set
>
> #
> # Device Drivers
> #
>
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER_PATH=""
> CONFIG_STANDALONE=y
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> # CONFIG_FIRMWARE_IN_KERNEL is not set
> CONFIG_EXTRA_FIRMWARE=""
> # CONFIG_SYS_HYPERVISOR is not set
> CONFIG_CONNECTOR=y
> CONFIG_PROC_EVENTS=y
> # CONFIG_MTD is not set
> # CONFIG_PARPORT is not set
> CONFIG_PNP=y
> # CONFIG_PNP_DEBUG_MESSAGES is not set
>
> #
> # Protocols
> #
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> # CONFIG_BLK_DEV_FD is not set
> # CONFIG_BLK_CPQ_DA is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_UMEM is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=y
> # CONFIG_BLK_DEV_CRYPTOLOOP is not set
> CONFIG_BLK_DEV_NBD=m
> # CONFIG_BLK_DEV_SX8 is not set
> # CONFIG_BLK_DEV_UB is not set
> CONFIG_BLK_DEV_RAM=y
> CONFIG_BLK_DEV_RAM_COUNT=16
> CONFIG_BLK_DEV_RAM_SIZE=16384
> # CONFIG_BLK_DEV_XIP is not set
> # CONFIG_CDROM_PKTCDVD is not set
> # CONFIG_ATA_OVER_ETH is not set
> # CONFIG_BLK_DEV_HD is not set
> CONFIG_MISC_DEVICES=y
> # CONFIG_IBM_ASM is not set
> # CONFIG_PHANTOM is not set
> # CONFIG_SGI_IOC4 is not set
> # CONFIG_TIFM_CORE is not set
> # CONFIG_ICS932S401 is not set
> # CONFIG_ENCLOSURE_SERVICES is not set
> # CONFIG_HP_ILO is not set
> # CONFIG_ISL29003 is not set
> # CONFIG_C2PORT is not set
>
> #
> # EEPROM support
> #
> # CONFIG_EEPROM_AT24 is not set
> # CONFIG_EEPROM_LEGACY is not set
> # CONFIG_EEPROM_93CX6 is not set
> CONFIG_HAVE_IDE=y
> # CONFIG_IDE is not set
>
> #
> # SCSI device support
> #
> # CONFIG_RAID_ATTRS is not set
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> # CONFIG_SCSI_TGT is not set
> # CONFIG_SCSI_NETLINK is not set
> # CONFIG_SCSI_PROC_FS is not set
>
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=y
> # CONFIG_CHR_DEV_ST is not set
> # CONFIG_CHR_DEV_OSST is not set
> CONFIG_BLK_DEV_SR=y
> CONFIG_BLK_DEV_SR_VENDOR=y
> CONFIG_CHR_DEV_SG=y
> # CONFIG_CHR_DEV_SCH is not set
>
> #
> # Some SCSI devices (e.g. CD jukebox) support multiple LUNs
> #
> CONFIG_SCSI_MULTI_LUN=y
> CONFIG_SCSI_CONSTANTS=y
> CONFIG_SCSI_LOGGING=y
> CONFIG_SCSI_SCAN_ASYNC=y
> CONFIG_SCSI_WAIT_SCAN=m
>
> #
> # SCSI Transports
> #
> # CONFIG_SCSI_SPI_ATTRS is not set
> # CONFIG_SCSI_FC_ATTRS is not set
> # CONFIG_SCSI_ISCSI_ATTRS is not set
> # CONFIG_SCSI_SAS_ATTRS is not set
> # CONFIG_SCSI_SAS_LIBSAS is not set
> # CONFIG_SCSI_SRP_ATTRS is not set
> # CONFIG_SCSI_LOWLEVEL is not set
> # CONFIG_SCSI_DH is not set
> # CONFIG_SCSI_OSD_INITIATOR is not set
> CONFIG_ATA=y
> # CONFIG_ATA_NONSTANDARD is not set
> CONFIG_ATA_ACPI=y
> CONFIG_SATA_PMP=y
> CONFIG_SATA_AHCI=y
> # CONFIG_SATA_SIL24 is not set
> CONFIG_ATA_SFF=y
> # CONFIG_SATA_SVW is not set
> CONFIG_ATA_PIIX=y
> # CONFIG_SATA_MV is not set
> # CONFIG_SATA_NV is not set
> # CONFIG_PDC_ADMA is not set
> # CONFIG_SATA_QSTOR is not set
> # CONFIG_SATA_PROMISE is not set
> # CONFIG_SATA_SX4 is not set
> # CONFIG_SATA_SIL is not set
> # CONFIG_SATA_SIS is not set
> # CONFIG_SATA_ULI is not set
> # CONFIG_SATA_VIA is not set
> # CONFIG_SATA_VITESSE is not set
> # CONFIG_SATA_INIC162X is not set
> CONFIG_PATA_ACPI=y
> # CONFIG_PATA_ALI is not set
> # CONFIG_PATA_AMD is not set
> # CONFIG_PATA_ARTOP is not set
> # CONFIG_PATA_ATIIXP is not set
> # CONFIG_PATA_CMD640_PCI is not set
> # CONFIG_PATA_CMD64X is not set
> # CONFIG_PATA_CS5520 is not set
> # CONFIG_PATA_CS5530 is not set
> # CONFIG_PATA_CS5535 is not set
> # CONFIG_PATA_CS5536 is not set
> # CONFIG_PATA_CYPRESS is not set
> # CONFIG_PATA_EFAR is not set
> CONFIG_ATA_GENERIC=y
> # CONFIG_PATA_HPT366 is not set
> # CONFIG_PATA_HPT37X is not set
> # CONFIG_PATA_HPT3X2N is not set
> # CONFIG_PATA_HPT3X3 is not set
> # CONFIG_PATA_IT821X is not set
> # CONFIG_PATA_IT8213 is not set
> # CONFIG_PATA_JMICRON is not set
> # CONFIG_PATA_TRIFLEX is not set
> # CONFIG_PATA_MARVELL is not set
> # CONFIG_PATA_MPIIX is not set
> # CONFIG_PATA_OLDPIIX is not set
> # CONFIG_PATA_NETCELL is not set
> # CONFIG_PATA_NINJA32 is not set
> # CONFIG_PATA_NS87410 is not set
> # CONFIG_PATA_NS87415 is not set
> # CONFIG_PATA_OPTI is not set
> # CONFIG_PATA_OPTIDMA is not set
> # CONFIG_PATA_PDC_OLD is not set
> # CONFIG_PATA_RADISYS is not set
> # CONFIG_PATA_RZ1000 is not set
> # CONFIG_PATA_SC1200 is not set
> # CONFIG_PATA_SERVERWORKS is not set
> # CONFIG_PATA_PDC2027X is not set
> # CONFIG_PATA_SIL680 is not set
> # CONFIG_PATA_SIS is not set
> # CONFIG_PATA_VIA is not set
> # CONFIG_PATA_WINBOND is not set
> # CONFIG_PATA_SCH is not set
> CONFIG_MD=y
> CONFIG_BLK_DEV_MD=m
> CONFIG_MD_LINEAR=m
> CONFIG_MD_RAID0=m
> CONFIG_MD_RAID1=m
> CONFIG_MD_RAID10=m
> CONFIG_MD_RAID456=m
> CONFIG_MD_RAID6_PQ=m
> CONFIG_MD_MULTIPATH=m
> # CONFIG_MD_FAULTY is not set
> CONFIG_BLK_DEV_DM=y
> CONFIG_DM_DEBUG=y
> CONFIG_DM_CRYPT=y
> CONFIG_DM_SNAPSHOT=y
> CONFIG_DM_MIRROR=y
> CONFIG_DM_ZERO=y
> # CONFIG_DM_MULTIPATH is not set
> # CONFIG_DM_DELAY is not set
> CONFIG_DM_UEVENT=y
> # CONFIG_FUSION is not set
>
> #
> # IEEE 1394 (FireWire) support
> #
>
> #
> # Enable only one of the two stacks, unless you know what you are doing
> #
> # CONFIG_FIREWIRE is not set
> # CONFIG_IEEE1394 is not set
> # CONFIG_I2O is not set
> # CONFIG_MACINTOSH_DRIVERS is not set
> CONFIG_NETDEVICES=y
> CONFIG_COMPAT_NET_DEV_OPS=y
> # CONFIG_IFB is not set
> # CONFIG_DUMMY is not set
> # CONFIG_BONDING is not set
> CONFIG_MACVLAN=m
> # CONFIG_EQUALIZER is not set
> CONFIG_TUN=m
> CONFIG_VETH=m
> # CONFIG_NET_SB1000 is not set
> # CONFIG_ARCNET is not set
> # CONFIG_NET_ETHERNET is not set
> CONFIG_MII=y
> CONFIG_NETDEV_1000=y
> # CONFIG_ACENIC is not set
> # CONFIG_DL2K is not set
> # CONFIG_E1000 is not set
> # CONFIG_E1000E is not set
> # CONFIG_IP1000 is not set
> # CONFIG_IGB is not set
> # CONFIG_IGBVF is not set
> # CONFIG_NS83820 is not set
> # CONFIG_HAMACHI is not set
> # CONFIG_YELLOWFIN is not set
> # CONFIG_R8169 is not set
> # CONFIG_SIS190 is not set
> # CONFIG_SKGE is not set
> # CONFIG_SKY2 is not set
> # CONFIG_VIA_VELOCITY is not set
> # CONFIG_TIGON3 is not set
> # CONFIG_BNX2 is not set
> # CONFIG_QLA3XXX is not set
> # CONFIG_ATL1 is not set
> CONFIG_ATL1E=y
> # CONFIG_ATL1C is not set
> # CONFIG_JME is not set
> # CONFIG_NETDEV_10000 is not set
> # CONFIG_TR is not set
>
> #
> # Wireless LAN
> #
> # CONFIG_WLAN_PRE80211 is not set
> CONFIG_WLAN_80211=y
> # CONFIG_LIBERTAS is not set
> # CONFIG_LIBERTAS_THINFIRM is not set
> # CONFIG_AIRO is not set
> # CONFIG_ATMEL is not set
> # CONFIG_AT76C50X_USB is not set
> # CONFIG_PRISM54 is not set
> # CONFIG_USB_ZD1201 is not set
> # CONFIG_USB_NET_RNDIS_WLAN is not set
> # CONFIG_RTL8180 is not set
> # CONFIG_RTL8187 is not set
> # CONFIG_ADM8211 is not set
> # CONFIG_MAC80211_HWSIM is not set
> # CONFIG_MWL8K is not set
> # CONFIG_P54_COMMON is not set
> # CONFIG_ATH5K is not set
> # CONFIG_ATH9K is not set
> # CONFIG_AR9170_USB is not set
> # CONFIG_IPW2100 is not set
> # CONFIG_IPW2200 is not set
> # CONFIG_IWLWIFI is not set
> # CONFIG_HOSTAP is not set
> # CONFIG_B43 is not set
> # CONFIG_B43LEGACY is not set
> # CONFIG_ZD1211RW is not set
> # CONFIG_RT2X00 is not set
> # CONFIG_HERMES is not set
>
> #
> # Enable WiMAX (Networking options) to see the WiMAX drivers
> #
>
> #
> # USB Network Adapters
> #
> # CONFIG_USB_CATC is not set
> # CONFIG_USB_KAWETH is not set
> # CONFIG_USB_PEGASUS is not set
> # CONFIG_USB_RTL8150 is not set
> # CONFIG_USB_USBNET is not set
> CONFIG_USB_HSO=y
> # CONFIG_WAN is not set
> # CONFIG_FDDI is not set
> # CONFIG_HIPPI is not set
> CONFIG_PPP=m
> CONFIG_PPP_MULTILINK=y
> CONFIG_PPP_FILTER=y
> CONFIG_PPP_ASYNC=m
> CONFIG_PPP_SYNC_TTY=m
> CONFIG_PPP_DEFLATE=m
> # CONFIG_PPP_BSDCOMP is not set
> CONFIG_PPP_MPPE=m
> CONFIG_PPPOE=m
> CONFIG_PPPOL2TP=m
> # CONFIG_SLIP is not set
> CONFIG_SLHC=m
> # CONFIG_NET_FC is not set
> # CONFIG_NETCONSOLE is not set
> # CONFIG_NETPOLL is not set
> # CONFIG_NET_POLL_CONTROLLER is not set
> # CONFIG_ISDN is not set
> # CONFIG_PHONE is not set
>
> #
> # Input device support
> #
> CONFIG_INPUT=y
> # CONFIG_INPUT_FF_MEMLESS is not set
> # CONFIG_INPUT_POLLDEV is not set
>
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=y
> # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> CONFIG_INPUT_JOYDEV=y
> CONFIG_INPUT_EVDEV=y
> # CONFIG_INPUT_EVBUG is not set
>
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> CONFIG_KEYBOARD_ATKBD=y
> # CONFIG_KEYBOARD_SUNKBD is not set
> # CONFIG_KEYBOARD_LKKBD is not set
> # CONFIG_KEYBOARD_XTKBD is not set
> # CONFIG_KEYBOARD_NEWTON is not set
> # CONFIG_KEYBOARD_STOWAWAY is not set
> CONFIG_INPUT_MOUSE=y
> CONFIG_MOUSE_PS2=y
> CONFIG_MOUSE_PS2_ALPS=y
> CONFIG_MOUSE_PS2_LOGIPS2PP=y
> CONFIG_MOUSE_PS2_SYNAPTICS=y
> CONFIG_MOUSE_PS2_LIFEBOOK=y
> CONFIG_MOUSE_PS2_TRACKPOINT=y
> CONFIG_MOUSE_PS2_ELANTECH=y
> # CONFIG_MOUSE_PS2_TOUCHKIT is not set
> # CONFIG_MOUSE_SERIAL is not set
> # CONFIG_MOUSE_APPLETOUCH is not set
> # CONFIG_MOUSE_BCM5974 is not set
> # CONFIG_MOUSE_VSXXXAA is not set
> # CONFIG_INPUT_JOYSTICK is not set
> # CONFIG_INPUT_TABLET is not set
> # CONFIG_INPUT_TOUCHSCREEN is not set
> # CONFIG_INPUT_MISC is not set
>
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_SERIO_I8042=y
> # CONFIG_SERIO_SERPORT is not set
> # CONFIG_SERIO_CT82C710 is not set
> # CONFIG_SERIO_PCIPS2 is not set
> CONFIG_SERIO_LIBPS2=y
> CONFIG_SERIO_RAW=m
> # CONFIG_GAMEPORT is not set
>
> #
> # Character devices
> #
> CONFIG_VT=y
> CONFIG_CONSOLE_TRANSLATIONS=y
> CONFIG_VT_CONSOLE=y
> CONFIG_HW_CONSOLE=y
> CONFIG_VT_HW_CONSOLE_BINDING=y
> CONFIG_DEVKMEM=y
> # CONFIG_SERIAL_NONSTANDARD is not set
> CONFIG_NOZOMI=m
>
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> # CONFIG_SERIAL_8250_CONSOLE is not set
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> # CONFIG_SERIAL_8250_EXTENDED is not set
>
> #
> # Non-8250 serial port support
> #
> CONFIG_SERIAL_CORE=y
> # CONFIG_SERIAL_JSM is not set
> CONFIG_UNIX98_PTYS=y
> CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
> # CONFIG_LEGACY_PTYS is not set
> # CONFIG_IPMI_HANDLER is not set
> CONFIG_HW_RANDOM=y
> # CONFIG_HW_RANDOM_TIMERIOMEM is not set
> CONFIG_HW_RANDOM_INTEL=y
> # CONFIG_HW_RANDOM_AMD is not set
> # CONFIG_HW_RANDOM_GEODE is not set
> # CONFIG_HW_RANDOM_VIA is not set
> CONFIG_NVRAM=y
> # CONFIG_R3964 is not set
> # CONFIG_APPLICOM is not set
> # CONFIG_SONYPI is not set
> # CONFIG_MWAVE is not set
> # CONFIG_PC8736x_GPIO is not set
> # CONFIG_NSC_GPIO is not set
> # CONFIG_CS5535_GPIO is not set
> # CONFIG_RAW_DRIVER is not set
> CONFIG_HPET=y
> CONFIG_HPET_MMAP=y
> CONFIG_HANGCHECK_TIMER=y
> # CONFIG_TCG_TPM is not set
> # CONFIG_TELCLOCK is not set
> CONFIG_DEVPORT=y
> CONFIG_I2C=y
> CONFIG_I2C_BOARDINFO=y
> CONFIG_I2C_CHARDEV=y
> CONFIG_I2C_HELPER_AUTO=y
> CONFIG_I2C_ALGOBIT=y
>
> #
> # I2C Hardware Bus support
> #
>
> #
> # PC SMBus host controller drivers
> #
> # CONFIG_I2C_ALI1535 is not set
> # CONFIG_I2C_ALI1563 is not set
> # CONFIG_I2C_ALI15X3 is not set
> # CONFIG_I2C_AMD756 is not set
> # CONFIG_I2C_AMD8111 is not set
> CONFIG_I2C_I801=y
> # CONFIG_I2C_ISCH is not set
> # CONFIG_I2C_PIIX4 is not set
> # CONFIG_I2C_NFORCE2 is not set
> # CONFIG_I2C_SIS5595 is not set
> # CONFIG_I2C_SIS630 is not set
> # CONFIG_I2C_SIS96X is not set
> # CONFIG_I2C_VIA is not set
> # CONFIG_I2C_VIAPRO is not set
>
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> # CONFIG_I2C_OCORES is not set
> # CONFIG_I2C_SIMTEC is not set
>
> #
> # External I2C/SMBus adapter drivers
> #
> # CONFIG_I2C_PARPORT_LIGHT is not set
> # CONFIG_I2C_TAOS_EVM is not set
> # CONFIG_I2C_TINY_USB is not set
>
> #
> # Graphics adapter I2C/DDC channel drivers
> #
> # CONFIG_I2C_VOODOO3 is not set
>
> #
> # Other I2C/SMBus bus drivers
> #
> # CONFIG_I2C_PCA_PLATFORM is not set
> # CONFIG_I2C_STUB is not set
> # CONFIG_SCx200_ACB is not set
>
> #
> # Miscellaneous I2C Chip support
> #
> # CONFIG_DS1682 is not set
> # CONFIG_SENSORS_PCF8574 is not set
> # CONFIG_PCF8575 is not set
> # CONFIG_SENSORS_PCA9539 is not set
> # CONFIG_SENSORS_MAX6875 is not set
> # CONFIG_SENSORS_TSL2550 is not set
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> # CONFIG_I2C_DEBUG_CHIP is not set
> # CONFIG_SPI is not set
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> # CONFIG_GPIOLIB is not set
> # CONFIG_W1 is not set
> CONFIG_POWER_SUPPLY=y
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> # CONFIG_PDA_POWER is not set
> # CONFIG_BATTERY_DS2760 is not set
> # CONFIG_BATTERY_BQ27x00 is not set
> CONFIG_HWMON=y
> # CONFIG_HWMON_VID is not set
> # CONFIG_SENSORS_ABITUGURU is not set
> # CONFIG_SENSORS_ABITUGURU3 is not set
> # CONFIG_SENSORS_AD7414 is not set
> # CONFIG_SENSORS_AD7418 is not set
> # CONFIG_SENSORS_ADM1021 is not set
> # CONFIG_SENSORS_ADM1025 is not set
> # CONFIG_SENSORS_ADM1026 is not set
> # CONFIG_SENSORS_ADM1029 is not set
> # CONFIG_SENSORS_ADM1031 is not set
> # CONFIG_SENSORS_ADM9240 is not set
> # CONFIG_SENSORS_ADT7462 is not set
> # CONFIG_SENSORS_ADT7470 is not set
> # CONFIG_SENSORS_ADT7473 is not set
> # CONFIG_SENSORS_ADT7475 is not set
> # CONFIG_SENSORS_K8TEMP is not set
> # CONFIG_SENSORS_ASB100 is not set
> # CONFIG_SENSORS_ATK0110 is not set
> # CONFIG_SENSORS_ATXP1 is not set
> # CONFIG_SENSORS_DS1621 is not set
> # CONFIG_SENSORS_I5K_AMB is not set
> # CONFIG_SENSORS_F71805F is not set
> # CONFIG_SENSORS_F71882FG is not set
> # CONFIG_SENSORS_F75375S is not set
> # CONFIG_SENSORS_FSCHER is not set
> # CONFIG_SENSORS_FSCPOS is not set
> # CONFIG_SENSORS_FSCHMD is not set
> # CONFIG_SENSORS_G760A is not set
> # CONFIG_SENSORS_GL518SM is not set
> # CONFIG_SENSORS_GL520SM is not set
> CONFIG_SENSORS_CORETEMP=y
> # CONFIG_SENSORS_IT87 is not set
> # CONFIG_SENSORS_LM63 is not set
> # CONFIG_SENSORS_LM75 is not set
> # CONFIG_SENSORS_LM77 is not set
> # CONFIG_SENSORS_LM78 is not set
> # CONFIG_SENSORS_LM80 is not set
> # CONFIG_SENSORS_LM83 is not set
> # CONFIG_SENSORS_LM85 is not set
> # CONFIG_SENSORS_LM87 is not set
> # CONFIG_SENSORS_LM90 is not set
> # CONFIG_SENSORS_LM92 is not set
> # CONFIG_SENSORS_LM93 is not set
> # CONFIG_SENSORS_LTC4215 is not set
> # CONFIG_SENSORS_LTC4245 is not set
> # CONFIG_SENSORS_LM95241 is not set
> # CONFIG_SENSORS_MAX1619 is not set
> # CONFIG_SENSORS_MAX6650 is not set
> # CONFIG_SENSORS_PC87360 is not set
> # CONFIG_SENSORS_PC87427 is not set
> # CONFIG_SENSORS_PCF8591 is not set
> # CONFIG_SENSORS_SIS5595 is not set
> # CONFIG_SENSORS_DME1737 is not set
> # CONFIG_SENSORS_SMSC47M1 is not set
> # CONFIG_SENSORS_SMSC47M192 is not set
> # CONFIG_SENSORS_SMSC47B397 is not set
> # CONFIG_SENSORS_ADS7828 is not set
> # CONFIG_SENSORS_THMC50 is not set
> # CONFIG_SENSORS_VIA686A is not set
> # CONFIG_SENSORS_VT1211 is not set
> # CONFIG_SENSORS_VT8231 is not set
> # CONFIG_SENSORS_W83781D is not set
> # CONFIG_SENSORS_W83791D is not set
> # CONFIG_SENSORS_W83792D is not set
> # CONFIG_SENSORS_W83793 is not set
> # CONFIG_SENSORS_W83L785TS is not set
> # CONFIG_SENSORS_W83L786NG is not set
> # CONFIG_SENSORS_W83627HF is not set
> # CONFIG_SENSORS_W83627EHF is not set
> # CONFIG_SENSORS_HDAPS is not set
> # CONFIG_SENSORS_LIS3LV02D is not set
> # CONFIG_SENSORS_APPLESMC is not set
> # CONFIG_HWMON_DEBUG_CHIP is not set
> CONFIG_THERMAL=y
> CONFIG_THERMAL_HWMON=y
> CONFIG_WATCHDOG=y
> # CONFIG_WATCHDOG_NOWAYOUT is not set
>
> #
> # Watchdog Device Drivers
> #
> # CONFIG_SOFT_WATCHDOG is not set
> # CONFIG_ACQUIRE_WDT is not set
> # CONFIG_ADVANTECH_WDT is not set
> # CONFIG_ALIM1535_WDT is not set
> # CONFIG_ALIM7101_WDT is not set
> # CONFIG_SC520_WDT is not set
> # CONFIG_EUROTECH_WDT is not set
> # CONFIG_IB700_WDT is not set
> # CONFIG_IBMASR is not set
> # CONFIG_WAFER_WDT is not set
> # CONFIG_I6300ESB_WDT is not set
> CONFIG_ITCO_WDT=y
> CONFIG_ITCO_VENDOR_SUPPORT=y
> # CONFIG_IT8712F_WDT is not set
> # CONFIG_IT87_WDT is not set
> # CONFIG_HP_WATCHDOG is not set
> # CONFIG_SC1200_WDT is not set
> # CONFIG_PC87413_WDT is not set
> # CONFIG_60XX_WDT is not set
> # CONFIG_SBC8360_WDT is not set
> # CONFIG_SBC7240_WDT is not set
> # CONFIG_CPU5_WDT is not set
> # CONFIG_SMSC_SCH311X_WDT is not set
> # CONFIG_SMSC37B787_WDT is not set
> # CONFIG_W83627HF_WDT is not set
> # CONFIG_W83697HF_WDT is not set
> # CONFIG_W83697UG_WDT is not set
> # CONFIG_W83877F_WDT is not set
> # CONFIG_W83977F_WDT is not set
> # CONFIG_MACHZ_WDT is not set
> # CONFIG_SBC_EPX_C3_WATCHDOG is not set
>
> #
> # PCI-based Watchdog Cards
> #
> # CONFIG_PCIPCWATCHDOG is not set
> # CONFIG_WDTPCI is not set
>
> #
> # USB-based Watchdog Cards
> #
> # CONFIG_USBPCWATCHDOG is not set
> CONFIG_SSB_POSSIBLE=y
>
> #
> # Sonics Silicon Backplane
> #
> # CONFIG_SSB is not set
>
> #
> # Multifunction device drivers
> #
> # CONFIG_MFD_CORE is not set
> # CONFIG_MFD_SM501 is not set
> # CONFIG_HTC_PASIC3 is not set
> # CONFIG_TWL4030_CORE is not set
> # CONFIG_MFD_TMIO is not set
> # CONFIG_PMIC_DA903X is not set
> # CONFIG_MFD_WM8400 is not set
> # CONFIG_MFD_WM8350_I2C is not set
> # CONFIG_MFD_PCF50633 is not set
> # CONFIG_REGULATOR is not set
>
> #
> # Multimedia devices
> #
>
> #
> # Multimedia core support
> #
> # CONFIG_VIDEO_DEV is not set
> # CONFIG_DVB_CORE is not set
> # CONFIG_VIDEO_MEDIA is not set
>
> #
> # Multimedia drivers
> #
> # CONFIG_DAB is not set
>
> #
> # Graphics support
> #
> CONFIG_AGP=y
> # CONFIG_AGP_ALI is not set
> # CONFIG_AGP_ATI is not set
> # CONFIG_AGP_AMD is not set
> # CONFIG_AGP_AMD64 is not set
> CONFIG_AGP_INTEL=y
> # CONFIG_AGP_NVIDIA is not set
> # CONFIG_AGP_SIS is not set
> # CONFIG_AGP_SWORKS is not set
> # CONFIG_AGP_VIA is not set
> # CONFIG_AGP_EFFICEON is not set
> CONFIG_DRM=y
> # CONFIG_DRM_TDFX is not set
> # CONFIG_DRM_R128 is not set
> # CONFIG_DRM_RADEON is not set
> # CONFIG_DRM_I810 is not set
> # CONFIG_DRM_I830 is not set
> CONFIG_DRM_I915=y
> CONFIG_DRM_I915_KMS=y
> # CONFIG_DRM_MGA is not set
> # CONFIG_DRM_SIS is not set
> # CONFIG_DRM_VIA is not set
> # CONFIG_DRM_SAVAGE is not set
> # CONFIG_VGASTATE is not set
> CONFIG_VIDEO_OUTPUT_CONTROL=y
> CONFIG_FB=y
> CONFIG_FIRMWARE_EDID=y
> CONFIG_FB_DDC=y
> CONFIG_FB_BOOT_VESA_SUPPORT=y
> CONFIG_FB_CFB_FILLRECT=y
> CONFIG_FB_CFB_COPYAREA=y
> CONFIG_FB_CFB_IMAGEBLIT=y
> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> # CONFIG_FB_SYS_FILLRECT is not set
> # CONFIG_FB_SYS_COPYAREA is not set
> # CONFIG_FB_SYS_IMAGEBLIT is not set
> # CONFIG_FB_FOREIGN_ENDIAN is not set
> # CONFIG_FB_SYS_FOPS is not set
> # CONFIG_FB_SVGALIB is not set
> # CONFIG_FB_MACMODES is not set
> # CONFIG_FB_BACKLIGHT is not set
> CONFIG_FB_MODE_HELPERS=y
> CONFIG_FB_TILEBLITTING=y
>
> #
> # Frame buffer hardware drivers
> #
> # CONFIG_FB_CIRRUS is not set
> # CONFIG_FB_PM2 is not set
> # CONFIG_FB_CYBER2000 is not set
> # CONFIG_FB_ARC is not set
> # CONFIG_FB_ASILIANT is not set
> # CONFIG_FB_IMSTT is not set
> # CONFIG_FB_VGA16 is not set
> # CONFIG_FB_UVESA is not set
> # CONFIG_FB_VESA is not set
> # CONFIG_FB_N411 is not set
> # CONFIG_FB_HGA is not set
> # CONFIG_FB_S1D13XXX is not set
> # CONFIG_FB_NVIDIA is not set
> # CONFIG_FB_RIVA is not set
> # CONFIG_FB_I810 is not set
> # CONFIG_FB_LE80578 is not set
> CONFIG_FB_INTEL=y
> # CONFIG_FB_INTEL_DEBUG is not set
> CONFIG_FB_INTEL_I2C=y
> # CONFIG_FB_MATROX is not set
> # CONFIG_FB_RADEON is not set
> # CONFIG_FB_ATY128 is not set
> # CONFIG_FB_ATY is not set
> # CONFIG_FB_S3 is not set
> # CONFIG_FB_SAVAGE is not set
> # CONFIG_FB_SIS is not set
> # CONFIG_FB_VIA is not set
> # CONFIG_FB_NEOMAGIC is not set
> # CONFIG_FB_KYRO is not set
> # CONFIG_FB_3DFX is not set
> # CONFIG_FB_VOODOO1 is not set
> # CONFIG_FB_VT8623 is not set
> # CONFIG_FB_TRIDENT is not set
> # CONFIG_FB_ARK is not set
> # CONFIG_FB_PM3 is not set
> # CONFIG_FB_CARMINE is not set
> # CONFIG_FB_GEODE is not set
> # CONFIG_FB_VIRTUAL is not set
> # CONFIG_FB_METRONOME is not set
> # CONFIG_FB_MB862XX is not set
> # CONFIG_FB_BROADSHEET is not set
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> CONFIG_LCD_CLASS_DEVICE=y
> # CONFIG_LCD_ILI9320 is not set
> CONFIG_LCD_PLATFORM=y
> CONFIG_BACKLIGHT_CLASS_DEVICE=y
> CONFIG_BACKLIGHT_GENERIC=y
> CONFIG_BACKLIGHT_PROGEAR=y
> # CONFIG_BACKLIGHT_MBP_NVIDIA is not set
> # CONFIG_BACKLIGHT_SAHARA is not set
>
> #
> # Display device support
> #
> CONFIG_DISPLAY_SUPPORT=y
>
> #
> # Display hardware drivers
> #
>
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> CONFIG_VGACON_SOFT_SCROLLBACK=y
> CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
> CONFIG_DUMMY_CONSOLE=y
> CONFIG_FRAMEBUFFER_CONSOLE=y
> CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
> CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
> # CONFIG_FONTS is not set
> CONFIG_FONT_8x8=y
> CONFIG_FONT_8x16=y
> CONFIG_LOGO=y
> # CONFIG_LOGO_LINUX_MONO is not set
> # CONFIG_LOGO_LINUX_VGA16 is not set
> CONFIG_LOGO_LINUX_CLUT224=y
> # CONFIG_SOUND is not set
> CONFIG_HID_SUPPORT=y
> CONFIG_HID=y
> CONFIG_HID_DEBUG=y
> CONFIG_HIDRAW=y
>
> #
> # USB Input Devices
> #
> CONFIG_USB_HID=y
> # CONFIG_HID_PID is not set
> CONFIG_USB_HIDDEV=y
>
> #
> # Special HID drivers
> #
> CONFIG_HID_A4TECH=y
> CONFIG_HID_APPLE=y
> CONFIG_HID_BELKIN=y
> CONFIG_HID_CHERRY=y
> CONFIG_HID_CHICONY=y
> CONFIG_HID_CYPRESS=y
> # CONFIG_DRAGONRISE_FF is not set
> CONFIG_HID_EZKEY=y
> CONFIG_HID_KYE=y
> CONFIG_HID_GYRATION=y
> CONFIG_HID_KENSINGTON=y
> CONFIG_HID_LOGITECH=y
> # CONFIG_LOGITECH_FF is not set
> # CONFIG_LOGIRUMBLEPAD2_FF is not set
> CONFIG_HID_MICROSOFT=y
> CONFIG_HID_MONTEREY=y
> CONFIG_HID_NTRIG=y
> CONFIG_HID_PANTHERLORD=y
> # CONFIG_PANTHERLORD_FF is not set
> CONFIG_HID_PETALYNX=y
> CONFIG_HID_SAMSUNG=y
> CONFIG_HID_SONY=y
> CONFIG_HID_SUNPLUS=y
> # CONFIG_GREENASIA_FF is not set
> CONFIG_HID_TOPSEED=y
> # CONFIG_THRUSTMASTER_FF is not set
> # CONFIG_ZEROPLUS_FF is not set
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB_ARCH_HAS_OHCI=y
> CONFIG_USB_ARCH_HAS_EHCI=y
> CONFIG_USB=y
> # CONFIG_USB_DEBUG is not set
> CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
>
> #
> # Miscellaneous USB options
> #
> CONFIG_USB_DEVICEFS=y
> # CONFIG_USB_DEVICE_CLASS is not set
> CONFIG_USB_DYNAMIC_MINORS=y
> CONFIG_USB_SUSPEND=y
> # CONFIG_USB_OTG is not set
> # CONFIG_USB_MON is not set
> # CONFIG_USB_WUSB is not set
> # CONFIG_USB_WUSB_CBAF is not set
>
> #
> # USB Host Controller Drivers
> #
> # CONFIG_USB_C67X00_HCD is not set
> CONFIG_USB_EHCI_HCD=y
> CONFIG_USB_EHCI_ROOT_HUB_TT=y
> CONFIG_USB_EHCI_TT_NEWSCHED=y
> # CONFIG_USB_OXU210HP_HCD is not set
> # CONFIG_USB_ISP116X_HCD is not set
> # CONFIG_USB_ISP1760_HCD is not set
> CONFIG_USB_OHCI_HCD=y
> # CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
> # CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> CONFIG_USB_UHCI_HCD=y
> # CONFIG_USB_SL811_HCD is not set
> # CONFIG_USB_R8A66597_HCD is not set
> # CONFIG_USB_WHCI_HCD is not set
> # CONFIG_USB_HWA_HCD is not set
>
> #
> # USB Device Class drivers
> #
> CONFIG_USB_ACM=m
> CONFIG_USB_PRINTER=m
> # CONFIG_USB_WDM is not set
> # CONFIG_USB_TMC is not set
>
> #
> # NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
> #
>
> #
> # also be needed; see USB_STORAGE Help for more info
> #
> CONFIG_USB_STORAGE=m
> # CONFIG_USB_STORAGE_DEBUG is not set
> CONFIG_USB_STORAGE_DATAFAB=m
> CONFIG_USB_STORAGE_FREECOM=m
> CONFIG_USB_STORAGE_ISD200=m
> CONFIG_USB_STORAGE_USBAT=m
> CONFIG_USB_STORAGE_SDDR09=m
> CONFIG_USB_STORAGE_SDDR55=m
> CONFIG_USB_STORAGE_JUMPSHOT=m
> CONFIG_USB_STORAGE_ALAUDA=m
> CONFIG_USB_STORAGE_ONETOUCH=m
> CONFIG_USB_STORAGE_KARMA=m
> CONFIG_USB_STORAGE_CYPRESS_ATACB=m
> CONFIG_USB_LIBUSUAL=y
>
> #
> # USB Imaging devices
> #
> # CONFIG_USB_MDC800 is not set
> # CONFIG_USB_MICROTEK is not set
>
> #
> # USB port drivers
> #
> CONFIG_USB_SERIAL=y
> # CONFIG_USB_SERIAL_CONSOLE is not set
> CONFIG_USB_EZUSB=y
> CONFIG_USB_SERIAL_GENERIC=y
> CONFIG_USB_SERIAL_AIRCABLE=m
> CONFIG_USB_SERIAL_ARK3116=m
> CONFIG_USB_SERIAL_BELKIN=m
> CONFIG_USB_SERIAL_CH341=m
> CONFIG_USB_SERIAL_WHITEHEAT=m
> CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
> CONFIG_USB_SERIAL_CP210X=m
> CONFIG_USB_SERIAL_CYPRESS_M8=m
> CONFIG_USB_SERIAL_EMPEG=m
> CONFIG_USB_SERIAL_FTDI_SIO=m
> CONFIG_USB_SERIAL_FUNSOFT=m
> CONFIG_USB_SERIAL_VISOR=m
> CONFIG_USB_SERIAL_IPAQ=m
> CONFIG_USB_SERIAL_IR=m
> CONFIG_USB_SERIAL_EDGEPORT=m
> CONFIG_USB_SERIAL_EDGEPORT_TI=m
> CONFIG_USB_SERIAL_GARMIN=m
> CONFIG_USB_SERIAL_IPW=m
> CONFIG_USB_SERIAL_IUU=m
> CONFIG_USB_SERIAL_KEYSPAN_PDA=m
> CONFIG_USB_SERIAL_KEYSPAN=m
> CONFIG_USB_SERIAL_KLSI=m
> CONFIG_USB_SERIAL_KOBIL_SCT=m
> CONFIG_USB_SERIAL_MCT_U232=m
> CONFIG_USB_SERIAL_MOS7720=m
> CONFIG_USB_SERIAL_MOS7840=m
> CONFIG_USB_SERIAL_MOTOROLA=m
> CONFIG_USB_SERIAL_NAVMAN=m
> CONFIG_USB_SERIAL_PL2303=m
> CONFIG_USB_SERIAL_OTI6858=m
> CONFIG_USB_SERIAL_QUALCOMM=m
> CONFIG_USB_SERIAL_SPCP8X5=m
> CONFIG_USB_SERIAL_HP4X=m
> CONFIG_USB_SERIAL_SAFE=m
> CONFIG_USB_SERIAL_SAFE_PADDED=y
> CONFIG_USB_SERIAL_SIEMENS_MPI=m
> CONFIG_USB_SERIAL_SIERRAWIRELESS=m
> # CONFIG_USB_SERIAL_SYMBOL is not set
> CONFIG_USB_SERIAL_TI=m
> CONFIG_USB_SERIAL_CYBERJACK=m
> CONFIG_USB_SERIAL_XIRCOM=m
> CONFIG_USB_SERIAL_OPTION=m
> CONFIG_USB_SERIAL_OMNINET=m
> CONFIG_USB_SERIAL_OPTICON=m
> CONFIG_USB_SERIAL_DEBUG=m
>
> #
> # USB Miscellaneous drivers
> #
> # CONFIG_USB_EMI62 is not set
> # CONFIG_USB_EMI26 is not set
> # CONFIG_USB_ADUTUX is not set
> # CONFIG_USB_SEVSEG is not set
> # CONFIG_USB_RIO500 is not set
> # CONFIG_USB_LEGOTOWER is not set
> # CONFIG_USB_LCD is not set
> # CONFIG_USB_BERRY_CHARGE is not set
> # CONFIG_USB_LED is not set
> # CONFIG_USB_CYPRESS_CY7C63 is not set
> # CONFIG_USB_CYTHERM is not set
> CONFIG_USB_IDMOUSE=y
> # CONFIG_USB_FTDI_ELAN is not set
> # CONFIG_USB_APPLEDISPLAY is not set
> CONFIG_USB_SISUSBVGA=m
> CONFIG_USB_SISUSBVGA_CON=y
> # CONFIG_USB_LD is not set
> # CONFIG_USB_TRANCEVIBRATOR is not set
> # CONFIG_USB_IOWARRIOR is not set
> # CONFIG_USB_TEST is not set
> # CONFIG_USB_ISIGHTFW is not set
> # CONFIG_USB_VST is not set
> # CONFIG_USB_GADGET is not set
>
> #
> # OTG and related infrastructure
> #
> # CONFIG_NOP_USB_XCEIV is not set
> CONFIG_UWB=y
> # CONFIG_UWB_HWA is not set
> # CONFIG_UWB_WHCI is not set
> # CONFIG_UWB_WLP is not set
> # CONFIG_MMC is not set
> # CONFIG_MEMSTICK is not set
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=y
>
> #
> # LED drivers
> #
> CONFIG_LEDS_ALIX2=m
> # CONFIG_LEDS_PCA9532 is not set
> # CONFIG_LEDS_LP5521 is not set
> CONFIG_LEDS_CLEVO_MAIL=m
> # CONFIG_LEDS_PCA955X is not set
> # CONFIG_LEDS_BD2802 is not set
>
> #
> # LED Triggers
> #
> CONFIG_LEDS_TRIGGERS=y
> CONFIG_LEDS_TRIGGER_TIMER=m
> CONFIG_LEDS_TRIGGER_HEARTBEAT=m
> CONFIG_LEDS_TRIGGER_BACKLIGHT=m
> CONFIG_LEDS_TRIGGER_DEFAULT_ON=m
>
> #
> # iptables trigger is under Netfilter config (LED target)
> #
> # CONFIG_ACCESSIBILITY is not set
> # CONFIG_INFINIBAND is not set
> # CONFIG_EDAC is not set
> CONFIG_RTC_LIB=y
> CONFIG_RTC_CLASS=y
> # CONFIG_RTC_HCTOSYS is not set
> # CONFIG_RTC_DEBUG is not set
>
> #
> # RTC interfaces
> #
> CONFIG_RTC_INTF_SYSFS=y
> CONFIG_RTC_INTF_PROC=y
> CONFIG_RTC_INTF_DEV=y
> # CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
> # CONFIG_RTC_DRV_TEST is not set
>
> #
> # I2C RTC drivers
> #
> # CONFIG_RTC_DRV_DS1307 is not set
> # CONFIG_RTC_DRV_DS1374 is not set
> # CONFIG_RTC_DRV_DS1672 is not set
> # CONFIG_RTC_DRV_MAX6900 is not set
> # CONFIG_RTC_DRV_RS5C372 is not set
> # CONFIG_RTC_DRV_ISL1208 is not set
> # CONFIG_RTC_DRV_X1205 is not set
> # CONFIG_RTC_DRV_PCF8563 is not set
> # CONFIG_RTC_DRV_PCF8583 is not set
> # CONFIG_RTC_DRV_M41T80 is not set
> # CONFIG_RTC_DRV_S35390A is not set
> # CONFIG_RTC_DRV_FM3130 is not set
> # CONFIG_RTC_DRV_RX8581 is not set
>
> #
> # SPI RTC drivers
> #
>
> #
> # Platform RTC drivers
> #
> CONFIG_RTC_DRV_CMOS=y
> # CONFIG_RTC_DRV_DS1286 is not set
> # CONFIG_RTC_DRV_DS1511 is not set
> # CONFIG_RTC_DRV_DS1553 is not set
> # CONFIG_RTC_DRV_DS1742 is not set
> # CONFIG_RTC_DRV_STK17TA8 is not set
> # CONFIG_RTC_DRV_M48T86 is not set
> # CONFIG_RTC_DRV_M48T35 is not set
> # CONFIG_RTC_DRV_M48T59 is not set
> # CONFIG_RTC_DRV_BQ4802 is not set
> # CONFIG_RTC_DRV_V3020 is not set
>
> #
> # on-CPU RTC drivers
> #
> # CONFIG_DMADEVICES is not set
> # CONFIG_AUXDISPLAY is not set
> # CONFIG_UIO is not set
> CONFIG_STAGING=y
> # CONFIG_STAGING_EXCLUDE_BUILD is not set
> # CONFIG_ET131X is not set
> # CONFIG_SLICOSS is not set
> # CONFIG_ME4000 is not set
> # CONFIG_MEILHAUS is not set
> CONFIG_USB_IP_COMMON=m
> CONFIG_USB_IP_VHCI_HCD=m
> CONFIG_USB_IP_HOST=m
> # CONFIG_W35UND is not set
> # CONFIG_PRISM2_USB is not set
> # CONFIG_ECHO is not set
> # CONFIG_USB_ATMEL is not set
> # CONFIG_AGNX is not set
> # CONFIG_OTUS is not set
> CONFIG_RT2860=y
> # CONFIG_RT2870 is not set
> # CONFIG_RT3070 is not set
> # CONFIG_COMEDI is not set
> # CONFIG_ASUS_OLED is not set
> # CONFIG_ALTERA_PCIE_CHDMA is not set
> # CONFIG_RTL8187SE is not set
> # CONFIG_INPUT_MIMIO is not set
> # CONFIG_TRANZPORT is not set
> # CONFIG_EPL is not set
>
> #
> # Android
> #
> # CONFIG_ANDROID is not set
> # CONFIG_ANDROID_BINDER_IPC is not set
> # CONFIG_ANDROID_LOGGER is not set
> # CONFIG_ANDROID_RAM_CONSOLE is not set
> # CONFIG_ANDROID_LOW_MEMORY_KILLER is not set
> # CONFIG_DST is not set
> # CONFIG_POHMELFS is not set
> # CONFIG_USB_SERIAL_ATEN2011 is not set
> # CONFIG_B3DFG is not set
> # CONFIG_IDE_PHISON is not set
> # CONFIG_PLAN9AUTH is not set
> # CONFIG_HECI is not set
> # CONFIG_USB_SERIAL_QUATECH_ESU100 is not set
> CONFIG_X86_PLATFORM_DEVICES=y
> # CONFIG_ACER_WMI is not set
> # CONFIG_DELL_WMI is not set
> # CONFIG_FUJITSU_LAPTOP is not set
> # CONFIG_TC1100_WMI is not set
> # CONFIG_HP_WMI is not set
> # CONFIG_MSI_LAPTOP is not set
> # CONFIG_PANASONIC_LAPTOP is not set
> # CONFIG_COMPAL_LAPTOP is not set
> # CONFIG_SONY_LAPTOP is not set
> # CONFIG_THINKPAD_ACPI is not set
> # CONFIG_INTEL_MENLOW is not set
> CONFIG_EEEPC_LAPTOP=m
> CONFIG_ACPI_WMI=y
> CONFIG_ACPI_ASUS=y
> # CONFIG_ACPI_TOSHIBA is not set
>
> #
> # Firmware Drivers
> #
> CONFIG_EDD=y
> # CONFIG_EDD_OFF is not set
> CONFIG_FIRMWARE_MEMMAP=y
> # CONFIG_DELL_RBU is not set
> # CONFIG_DCDBAS is not set
> CONFIG_DMIID=y
> # CONFIG_ISCSI_IBFT_FIND is not set
>
> #
> # File systems
> #
> CONFIG_EXT2_FS=m
> CONFIG_EXT2_FS_XATTR=y
> CONFIG_EXT2_FS_POSIX_ACL=y
> CONFIG_EXT2_FS_SECURITY=y
> CONFIG_EXT2_FS_XIP=y
> CONFIG_EXT3_FS=y
> # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
> CONFIG_EXT3_FS_XATTR=y
> CONFIG_EXT3_FS_POSIX_ACL=y
> CONFIG_EXT3_FS_SECURITY=y
> CONFIG_EXT4_FS=y
> # CONFIG_EXT4DEV_COMPAT is not set
> CONFIG_EXT4_FS_XATTR=y
> CONFIG_EXT4_FS_POSIX_ACL=y
> CONFIG_EXT4_FS_SECURITY=y
> CONFIG_FS_XIP=y
> CONFIG_JBD=y
> # CONFIG_JBD_DEBUG is not set
> CONFIG_JBD2=y
> # CONFIG_JBD2_DEBUG is not set
> CONFIG_FS_MBCACHE=y
> # CONFIG_REISERFS_FS is not set
> # CONFIG_JFS_FS is not set
> CONFIG_FS_POSIX_ACL=y
> CONFIG_XFS_FS=y
> CONFIG_XFS_QUOTA=y
> CONFIG_XFS_POSIX_ACL=y
> # CONFIG_XFS_RT is not set
> # CONFIG_XFS_DEBUG is not set
> # CONFIG_GFS2_FS is not set
> # CONFIG_OCFS2_FS is not set
> # CONFIG_BTRFS_FS is not set
> CONFIG_FILE_LOCKING=y
> # CONFIG_DNOTIFY is not set
> CONFIG_INOTIFY=y
> CONFIG_INOTIFY_USER=y
> # CONFIG_QUOTA is not set
> CONFIG_QUOTACTL=y
> # CONFIG_AUTOFS_FS is not set
> # CONFIG_AUTOFS4_FS is not set
> CONFIG_FUSE_FS=y
> CONFIG_GENERIC_ACL=y
>
> #
> # Caches
> #
> # CONFIG_FSCACHE is not set
>
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=y
> CONFIG_JOLIET=y
> CONFIG_ZISOFS=y
> CONFIG_UDF_FS=y
> CONFIG_UDF_NLS=y
>
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=y
> CONFIG_MSDOS_FS=y
> CONFIG_VFAT_FS=y
> CONFIG_FAT_DEFAULT_CODEPAGE=850
> CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-15"
> # CONFIG_NTFS_FS is not set
>
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> CONFIG_PROC_KCORE=y
> CONFIG_PROC_SYSCTL=y
> CONFIG_PROC_PAGE_MONITOR=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> CONFIG_TMPFS_POSIX_ACL=y
> CONFIG_HUGETLBFS=y
> CONFIG_HUGETLB_PAGE=y
> CONFIG_CONFIGFS_FS=y
> CONFIG_MISC_FILESYSTEMS=y
> # CONFIG_ADFS_FS is not set
> # CONFIG_AFFS_FS is not set
> CONFIG_HFS_FS=m
> CONFIG_HFSPLUS_FS=m
> # CONFIG_BEFS_FS is not set
> # CONFIG_BFS_FS is not set
> # CONFIG_EFS_FS is not set
> CONFIG_CRAMFS=m
> CONFIG_SQUASHFS=m
> # CONFIG_SQUASHFS_EMBEDDED is not set
> CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
> # CONFIG_VXFS_FS is not set
> # CONFIG_MINIX_FS is not set
> # CONFIG_OMFS_FS is not set
> # CONFIG_HPFS_FS is not set
> # CONFIG_QNX4FS_FS is not set
> # CONFIG_ROMFS_FS is not set
> # CONFIG_SYSV_FS is not set
> # CONFIG_UFS_FS is not set
> CONFIG_NILFS2_FS=y
> CONFIG_NETWORK_FILESYSTEMS=y
> CONFIG_NFS_FS=m
> CONFIG_NFS_V3=y
> CONFIG_NFS_V3_ACL=y
> CONFIG_NFS_V4=y
> # CONFIG_NFSD is not set
> CONFIG_LOCKD=m
> CONFIG_LOCKD_V4=y
> CONFIG_EXPORTFS=y
> CONFIG_NFS_ACL_SUPPORT=m
> CONFIG_NFS_COMMON=y
> CONFIG_SUNRPC=m
> CONFIG_SUNRPC_GSS=m
> CONFIG_RPCSEC_GSS_KRB5=m
> # CONFIG_RPCSEC_GSS_SPKM3 is not set
> # CONFIG_SMB_FS is not set
> CONFIG_CIFS=m
> CONFIG_CIFS_STATS=y
> # CONFIG_CIFS_STATS2 is not set
> CONFIG_CIFS_WEAK_PW_HASH=y
> CONFIG_CIFS_XATTR=y
> CONFIG_CIFS_POSIX=y
> # CONFIG_CIFS_DEBUG2 is not set
> CONFIG_CIFS_EXPERIMENTAL=y
> # CONFIG_NCP_FS is not set
> # CONFIG_CODA_FS is not set
> # CONFIG_AFS_FS is not set
>
> #
> # Partition Types
> #
> CONFIG_PARTITION_ADVANCED=y
> # CONFIG_ACORN_PARTITION is not set
> CONFIG_OSF_PARTITION=y
> CONFIG_AMIGA_PARTITION=y
> # CONFIG_ATARI_PARTITION is not set
> CONFIG_MAC_PARTITION=y
> CONFIG_MSDOS_PARTITION=y
> CONFIG_BSD_DISKLABEL=y
> CONFIG_MINIX_SUBPARTITION=y
> CONFIG_SOLARIS_X86_PARTITION=y
> CONFIG_UNIXWARE_DISKLABEL=y
> # CONFIG_LDM_PARTITION is not set
> CONFIG_SGI_PARTITION=y
> # CONFIG_ULTRIX_PARTITION is not set
> CONFIG_SUN_PARTITION=y
> CONFIG_KARMA_PARTITION=y
> CONFIG_EFI_PARTITION=y
> # CONFIG_SYSV68_PARTITION is not set
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="utf8"
> CONFIG_NLS_CODEPAGE_437=y
> # CONFIG_NLS_CODEPAGE_737 is not set
> # CONFIG_NLS_CODEPAGE_775 is not set
> CONFIG_NLS_CODEPAGE_850=y
> # CONFIG_NLS_CODEPAGE_852 is not set
> # CONFIG_NLS_CODEPAGE_855 is not set
> # CONFIG_NLS_CODEPAGE_857 is not set
> # CONFIG_NLS_CODEPAGE_860 is not set
> # CONFIG_NLS_CODEPAGE_861 is not set
> # CONFIG_NLS_CODEPAGE_862 is not set
> # CONFIG_NLS_CODEPAGE_863 is not set
> # CONFIG_NLS_CODEPAGE_864 is not set
> # CONFIG_NLS_CODEPAGE_865 is not set
> # CONFIG_NLS_CODEPAGE_866 is not set
> # CONFIG_NLS_CODEPAGE_869 is not set
> # CONFIG_NLS_CODEPAGE_936 is not set
> # CONFIG_NLS_CODEPAGE_950 is not set
> # CONFIG_NLS_CODEPAGE_932 is not set
> # CONFIG_NLS_CODEPAGE_949 is not set
> # CONFIG_NLS_CODEPAGE_874 is not set
> # CONFIG_NLS_ISO8859_8 is not set
> # CONFIG_NLS_CODEPAGE_1250 is not set
> # CONFIG_NLS_CODEPAGE_1251 is not set
> CONFIG_NLS_ASCII=y
> CONFIG_NLS_ISO8859_1=y
> # CONFIG_NLS_ISO8859_2 is not set
> # CONFIG_NLS_ISO8859_3 is not set
> # CONFIG_NLS_ISO8859_4 is not set
> # CONFIG_NLS_ISO8859_5 is not set
> # CONFIG_NLS_ISO8859_6 is not set
> # CONFIG_NLS_ISO8859_7 is not set
> # CONFIG_NLS_ISO8859_9 is not set
> # CONFIG_NLS_ISO8859_13 is not set
> # CONFIG_NLS_ISO8859_14 is not set
> CONFIG_NLS_ISO8859_15=y
> # CONFIG_NLS_KOI8_R is not set
> # CONFIG_NLS_KOI8_U is not set
> CONFIG_NLS_UTF8=y
> # CONFIG_DLM is not set
>
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> CONFIG_PRINTK_TIME=y
> # CONFIG_ENABLE_WARN_DEPRECATED is not set
> CONFIG_ENABLE_MUST_CHECK=y
> CONFIG_FRAME_WARN=1024
> CONFIG_MAGIC_SYSRQ=y
> CONFIG_UNUSED_SYMBOLS=y
> CONFIG_DEBUG_FS=y
> # CONFIG_HEADERS_CHECK is not set
> # CONFIG_DEBUG_KERNEL is not set
> # CONFIG_SLUB_DEBUG_ON is not set
> # CONFIG_SLUB_STATS is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> CONFIG_DEBUG_MEMORY_INIT=y
> CONFIG_ARCH_WANT_FRAME_POINTERS=y
> # CONFIG_FRAME_POINTER is not set
> # CONFIG_RCU_CPU_STALL_DETECTOR is not set
> # CONFIG_LATENCYTOP is not set
> # CONFIG_SYSCTL_SYSCALL_CHECK is not set
> CONFIG_USER_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_HAVE_FTRACE_SYSCALLS=y
> CONFIG_TRACING_SUPPORT=y
>
> #
> # Tracers
> #
> # CONFIG_FUNCTION_TRACER is not set
> # CONFIG_IRQSOFF_TRACER is not set
> # CONFIG_PREEMPT_TRACER is not set
> # CONFIG_SYSPROF_TRACER is not set
> # CONFIG_SCHED_TRACER is not set
> # CONFIG_CONTEXT_SWITCH_TRACER is not set
> # CONFIG_EVENT_TRACER is not set
> # CONFIG_FTRACE_SYSCALLS is not set
> # CONFIG_BOOT_TRACER is not set
> # CONFIG_TRACE_BRANCH_PROFILING is not set
> # CONFIG_POWER_TRACER is not set
> # CONFIG_STACK_TRACER is not set
> # CONFIG_KMEMTRACE is not set
> # CONFIG_WORKQUEUE_TRACER is not set
> # CONFIG_BLK_DEV_IO_TRACE is not set
> # CONFIG_MMIOTRACE is not set
> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> # CONFIG_DYNAMIC_DEBUG is not set
> # CONFIG_DMA_API_DEBUG is not set
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> CONFIG_STRICT_DEVMEM=y
> # CONFIG_X86_VERBOSE_BOOTUP is not set
> CONFIG_EARLY_PRINTK=y
> # CONFIG_EARLY_PRINTK_DBGP is not set
> # CONFIG_4KSTACKS is not set
> CONFIG_DOUBLEFAULT=y
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> # CONFIG_IO_DELAY_0X80 is not set
> # CONFIG_IO_DELAY_0XED is not set
> # CONFIG_IO_DELAY_UDELAY is not set
> CONFIG_IO_DELAY_NONE=y
> CONFIG_DEFAULT_IO_DELAY_TYPE=3
> CONFIG_OPTIMIZE_INLINING=y
>
> #
> # Security options
> #
> # CONFIG_KEYS is not set
> # CONFIG_SECURITY is not set
> # CONFIG_SECURITYFS is not set
> # CONFIG_SECURITY_FILE_CAPABILITIES is not set
> # CONFIG_IMA is not set
> CONFIG_XOR_BLOCKS=m
> CONFIG_ASYNC_CORE=m
> CONFIG_ASYNC_MEMCPY=m
> CONFIG_ASYNC_XOR=m
> CONFIG_CRYPTO=y
>
> #
> # Crypto core or helper
> #
> CONFIG_CRYPTO_FIPS=y
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_ALGAPI2=y
> CONFIG_CRYPTO_AEAD=y
> CONFIG_CRYPTO_AEAD2=y
> CONFIG_CRYPTO_BLKCIPHER=y
> CONFIG_CRYPTO_BLKCIPHER2=y
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_HASH2=y
> CONFIG_CRYPTO_RNG=y
> CONFIG_CRYPTO_RNG2=y
> CONFIG_CRYPTO_PCOMP=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> CONFIG_CRYPTO_GF128MUL=y
> CONFIG_CRYPTO_NULL=y
> CONFIG_CRYPTO_WORKQUEUE=y
> # CONFIG_CRYPTO_CRYPTD is not set
> CONFIG_CRYPTO_AUTHENC=y
> # CONFIG_CRYPTO_TEST is not set
>
> #
> # Authenticated Encryption with Associated Data
> #
> CONFIG_CRYPTO_CCM=y
> CONFIG_CRYPTO_GCM=y
> CONFIG_CRYPTO_SEQIV=y
>
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=y
> CONFIG_CRYPTO_CTR=y
> CONFIG_CRYPTO_CTS=m
> CONFIG_CRYPTO_ECB=y
> CONFIG_CRYPTO_LRW=y
> CONFIG_CRYPTO_PCBC=y
> CONFIG_CRYPTO_XTS=y
>
> #
> # Hash modes
> #
> CONFIG_CRYPTO_HMAC=y
> CONFIG_CRYPTO_XCBC=y
>
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=y
> CONFIG_CRYPTO_CRC32C_INTEL=y
> CONFIG_CRYPTO_MD4=y
> CONFIG_CRYPTO_MD5=y
> CONFIG_CRYPTO_MICHAEL_MIC=y
> CONFIG_CRYPTO_RMD128=y
> CONFIG_CRYPTO_RMD160=y
> CONFIG_CRYPTO_RMD256=y
> CONFIG_CRYPTO_RMD320=y
> CONFIG_CRYPTO_SHA1=y
> CONFIG_CRYPTO_SHA256=y
> CONFIG_CRYPTO_SHA512=y
> CONFIG_CRYPTO_TGR192=y
> CONFIG_CRYPTO_WP512=y
>
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> CONFIG_CRYPTO_AES_586=y
> CONFIG_CRYPTO_ANUBIS=m
> CONFIG_CRYPTO_ARC4=y
> CONFIG_CRYPTO_BLOWFISH=m
> CONFIG_CRYPTO_CAMELLIA=m
> CONFIG_CRYPTO_CAST5=m
> CONFIG_CRYPTO_CAST6=m
> CONFIG_CRYPTO_DES=m
> CONFIG_CRYPTO_FCRYPT=m
> CONFIG_CRYPTO_KHAZAD=m
> CONFIG_CRYPTO_SALSA20=m
> CONFIG_CRYPTO_SALSA20_586=m
> CONFIG_CRYPTO_SEED=m
> CONFIG_CRYPTO_SERPENT=m
> CONFIG_CRYPTO_TEA=m
> CONFIG_CRYPTO_TWOFISH=m
> CONFIG_CRYPTO_TWOFISH_COMMON=m
> CONFIG_CRYPTO_TWOFISH_586=m
>
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=y
> CONFIG_CRYPTO_ZLIB=y
> CONFIG_CRYPTO_LZO=y
>
> #
> # Random Number Generation
> #
> CONFIG_CRYPTO_ANSI_CPRNG=y
> # CONFIG_CRYPTO_HW is not set
> CONFIG_HAVE_KVM=y
> CONFIG_HAVE_KVM_IRQCHIP=y
> # CONFIG_VIRTUALIZATION is not set
> # CONFIG_BINARY_PRINTF is not set
>
> #
> # Library routines
> #
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_GENERIC_FIND_NEXT_BIT=y
> CONFIG_GENERIC_FIND_LAST_BIT=y
> CONFIG_CRC_CCITT=y
> CONFIG_CRC16=y
> CONFIG_CRC_T10DIF=y
> CONFIG_CRC_ITU_T=y
> CONFIG_CRC32=y
> # CONFIG_CRC7 is not set
> CONFIG_LIBCRC32C=y
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_LZO_COMPRESS=y
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_DECOMPRESS_GZIP=y
> CONFIG_DECOMPRESS_BZIP2=y
> CONFIG_DECOMPRESS_LZMA=y
> CONFIG_TEXTSEARCH=y
> CONFIG_TEXTSEARCH_KMP=m
> CONFIG_TEXTSEARCH_BM=m
> CONFIG_TEXTSEARCH_FSM=m
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y
> CONFIG_NLATTR=y
>
> --
> Luciano Rocha <luciano@eurotux.com>
> Eurotux Informática, S.A. <http://www.eurotux.com/>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
