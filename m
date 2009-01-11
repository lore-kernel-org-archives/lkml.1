Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbZAKULV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbZAKULV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 15:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbZAKULK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 15:11:10 -0500
Received: from vms046pub.verizon.net ([206.46.252.46]:53543 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbZAKULE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 15:11:04 -0500
Date: Sun, 11 Jan 2009 15:10:30 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Linux 2.6.29-rc1 MAJOR advisory
In-reply-to: <alpine.LFD.2.00.0901101551420.6528@localhost.localdomain>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200901111510.30064.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: Multipart/Mixed; boundary="Boundary-00=_2IlaJuHgFhmvxmo"
References: <alpine.LFD.2.00.0901101551420.6528@localhost.localdomain>
User-Agent: KMail/1.9.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_2IlaJuHgFhmvxmo
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Saturday 10 January 2009, Linus Torvalds wrote:
>The merge window is over, and while it is quite possible that I missed a
>few merge requests in the crazy week that is behind us, apart from those
>we should now have most of the bulk of 2.6.29 merged up. And now it's just
>a small matter of making sure it's all stable and ready to go.

I don't believe it is.  MAJOR problem. I have an ASUS M2N-SLI Deluxe 
motherboard I paid about $275 for in late Sept 2008, and one attempt to boot 
the 2.6.29-rc1 I had built destroyed the MCP55 eth0 port, no power on the 
port at all now, and I've rebooted to 2.6.28, still no eth0, so I have now 
enabled in the bios and am using the 2nd & last eth1 port on this mobo.

dmesg from that boot attempt is attached for forensics.  Please look it over.  
And advise of course if its something I did.

Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
I'm going to raise an issue and stick it in your ear.
		-- John Foreman

--Boundary-00=_2IlaJuHgFhmvxmo
Content-Type: text/plain;
  charset="iso 8859-15";
  name="dmesg-2.6.29-rc1"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg-2.6.29-rc1"

[    0.000000] Linux version 2.6.29-rc1 (root@coyote.coyote.den) (gcc version 4.1.2 20070925 (Red Hat 4.1.2-33)) #1 SMP PREEMPT Sun Jan 11 11:54:15 EST 2009
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000dfee0000 (usable)
[    0.000000]  BIOS-e820: 00000000dfee0000 - 00000000dfee3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000dfee3000 - 00000000dfef0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000dfef0000 - 00000000dff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] DMI 2.4 present.
[    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working it around.
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x1000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:398 generic_get_mtrr+0x11c/0x130()
[    0.000000] Hardware name: System Product Name
[    0.000000] mtrr: your BIOS has set up an incorrect mask, fixing it up.
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.29-rc1 #1
[    0.000000] Call Trace:
[    0.000000]  [<c0428939>] warn_slowpath+0x99/0xc0
[    0.000000]  [<c043f561>] up+0x11/0x40
[    0.000000]  [<c042906d>] release_console_sem+0x18d/0x1c0
[    0.000000]  [<c0600020>] iret_exc+0x1dc/0x882
[    0.000000]  [<c06ffac1>] dmi_string_nosave+0x51/0x70
[    0.000000]  [<c042962b>] printk+0x1b/0x20
[    0.000000]  [<c041ba8c>] pat_init+0x7c/0xa0
[    0.000000]  [<c040fd5c>] generic_get_mtrr+0x11c/0x130
[    0.000000]  [<c06ea68b>] mtrr_trim_uncached_memory+0x7b/0x360
[    0.000000]  [<c06eaa41>] mtrr_bp_init+0xd1/0x700
[    0.000000]  [<c042962b>] printk+0x1b/0x20
[    0.000000]  [<c06e7125>] e820_end_pfn+0xc5/0xf0
[    0.000000]  [<c06e5689>] setup_arch+0x409/0x980
[    0.000000]  [<c06e864b>] reserve_early_overlap_ok+0x4b/0x60
[    0.000000]  [<c06e1a0a>] start_kernel+0x6a/0x2e0
[    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009f000 (usable)
[    0.000000]  modified: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000dfee0000 (usable)
[    0.000000]  modified: 00000000dfee0000 - 00000000dfee3000 (ACPI NVS)
[    0.000000]  modified: 00000000dfee3000 - 00000000dfef0000 (ACPI data)
[    0.000000]  modified: 00000000dfef0000 - 00000000dff00000 (reserved)
[    0.000000]  modified: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] kernel direct mapping tables up to 379fe000 @ 10000-16000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] RAMDISK: 37cfb000 - 37feff16
[    0.000000] Allocated new RAMDISK: 00100000 - 003f4f16
[    0.000000] Move RAMDISK from 0000000037cfb000 - 0000000037feff15 to 00100000 - 003f4f15
[    0.000000] ACPI: RSDP 000F7D20, 0024 (r2 Nvidia)
[    0.000000] ACPI: XSDT DFEE3100, 004C (r1 Nvidia ASUSACPI 42302E31 AWRD        0)
[    0.000000] ACPI: FACP DFEEADC0, 00F4 (r3 Nvidia ASUSACPI 42302E31 AWRD        0)
[    0.000000] ACPI Warning (tbfadt-0568): 32/64X length mismatch in Pm1aEventBlock: 32/8 [20081204]
[    0.000000] ACPI Warning (tbfadt-0568): 32/64X length mismatch in Pm1aControlBlock: 16/8 [20081204]
[    0.000000] ACPI Warning (tbfadt-0568): 32/64X length mismatch in PmTimerBlock: 32/8 [20081204]
[    0.000000] ACPI Warning (tbfadt-0568): 32/64X length mismatch in Gpe0Block: 64/8 [20081204]
[    0.000000] ACPI Warning (tbfadt-0568): 32/64X length mismatch in Gpe1Block: 128/8 [20081204]
[    0.000000] ACPI Warning (tbfadt-0412): Invalid length for Pm1aEventBlock: 8, using default 32 [20081204]
[    0.000000] ACPI Warning (tbfadt-0412): Invalid length for Pm1aControlBlock: 8, using default 16 [20081204]
[    0.000000] ACPI Warning (tbfadt-0412): Invalid length for PmTimerBlock: 8, using default 32 [20081204]
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
[    0.000000] ACPI: DSDT DFEE3280, 7ACE (r1 NVIDIA AWRDACPI     1000 MSFT  3000000)
[    0.000000] ACPI: FACS DFEE0000, 0040
[    0.000000] ACPI: SSDT DFEEB000, 0544 (r1 PTLTD  POWERNOW        1  LTP        1)
[    0.000000] ACPI: HPET DFEEB5C0, 0038 (r1 Nvidia ASUSACPI 42302E31 AWRD       98)
[    0.000000] ACPI: MCFG DFEEB640, 003C (r1 Nvidia ASUSACPI 42302E31 AWRD        0)
[    0.000000] ACPI: APIC DFEEAF00, 0098 (r1 Nvidia ASUSACPI 42302E31 AWRD        0)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 3718MB HIGHMEM available.
[    0.000000] 889MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 379fe000
[    0.000000]   low ram: 00000000 - 379fe000
[    0.000000]   bootmap 00013000 - 00019f40
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00379fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0000400000 - 00007888f4]    TEXT DATA BSS ==> [0000400000 - 00007888f4]
[    0.000000]   #4 [0000789000 - 0000791000]    INIT_PG_TABLE ==> [0000789000 - 0000791000]
[    0.000000]   #5 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
[    0.000000]   #6 [0000010000 - 0000013000]          PGTABLE ==> [0000010000 - 0000013000]
[    0.000000]   #7 [0000100000 - 00003f4f16]      NEW RAMDISK ==> [0000100000 - 00003f4f16]
[    0.000000]   #8 [0000013000 - 000001a000]          BOOTMAP ==> [0000013000 - 000001a000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000379fe
[    0.000000]   HighMem  0x000379fe -> 0x00120000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000dfee0
[    0.000000]     0: 0x00100000 -> 0x00120000
[    0.000000] On node 0 totalpages: 1048175
[    0.000000] free_area_init_node: node 0, pgdat c06c1a00, node_mem_map c1000200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1748 pages used for memmap
[    0.000000]   Normal zone: 221994 pages, LIFO batch:31
[    0.000000]   HighMem zone: 7437 pages used for memmap
[    0.000000]   HighMem zone: 813013 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfefff000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] Allocating PCI resources starting at e0000000 (gap: dff00000:10100000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Allocating 36864 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1038958
[    0.000000] Kernel command line: ro root=LABEL=/ rhgb quiet nomodeset
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Preemptible RCU implementation.
[    0.000000] CPU 0 irqstacks, hard=c073d000 soft=c0735000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2209.458 MHz processor.
[    0.000999] spurious 8259A interrupt: IRQ7.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000999] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000999] Memory: 4147232k/4718592k available (2049k kernel code, 44688k reserved, 882k data, 324k init, 3281800k highmem)
[    0.000999] virtual kernel memory layout:
[    0.000999]     fixmap  : 0xfff51000 - 0xfffff000   ( 696 kB)
[    0.000999]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.000999]     vmalloc : 0xf81fe000 - 0xff9fe000   ( 120 MB)
[    0.000999]     lowmem  : 0xc0000000 - 0xf79fe000   ( 889 MB)
[    0.000999]       .init : 0xc06e1000 - 0xc0732000   ( 324 kB)
[    0.000999]       .data : 0xc06006c6 - 0xc06dcfa0   ( 882 kB)
[    0.000999]       .text : 0xc0400000 - 0xc06006c6   (2049 kB)
[    0.000999] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000999] hpet clockevent registered
[    0.000999] Calibrating delay loop (skipped), value calculated using timer frequency.. 4418.91 BogoMIPS (lpj=2209458)
[    0.000999] Mount-cache hash table entries: 512
[    0.000999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.000999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 0
[    0.000999] using C1E aware idle routine
[    0.000999] Checking 'hlt' instruction... OK.
[    0.004210] Freeing SMP alternatives: 9k freed
[    0.004213] ACPI: Core revision 20081204
[    0.015511] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.025866] CPU0: AMD Phenom(tm) 9550 Quad-Core Processor stepping 03
[    0.025999] CPU 1 irqstacks, hard=c073e000 soft=c0736000
[    0.025999] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 4420.42 BogoMIPS (lpj=2210211)
[    0.000999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.000999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.096725] CPU1: AMD Phenom(tm) 9550 Quad-Core Processor stepping 03
[    0.096733] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.097070] CPU 2 irqstacks, hard=c073f000 soft=c0737000
[    0.097072] Booting processor 2 APIC 0x2 ip 0x6000
[    0.000999] Initializing CPU#2
[    0.000999] Calibrating delay using timer specific routine.. 4420.30 BogoMIPS (lpj=2210150)
[    0.000999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.000999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 2
[    0.000999] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.168639] CPU2: AMD Phenom(tm) 9550 Quad-Core Processor stepping 03
[    0.168648] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.169061] CPU 3 irqstacks, hard=c0740000 soft=c0738000
[    0.169063] Booting processor 3 APIC 0x3 ip 0x6000
[    0.000999] Initializing CPU#3
[    0.000999] Calibrating delay using timer specific routine.. 4420.31 BogoMIPS (lpj=2210158)
[    0.000999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.000999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 3
[    0.000999] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.240646] CPU3: AMD Phenom(tm) 9550 Quad-Core Processor stepping 03
[    0.240655] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.241021] Brought up 4 CPUs
[    0.241023] Total of 4 processors activated (17679.95 BogoMIPS).
[    0.242030] net_namespace: 532 bytes
[    0.242227] NET: Registered protocol family 16
[    0.242508] ACPI: bus type pci registered
[    0.242609] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
[    0.242612] PCI: MCFG area at f0000000 reserved in E820
[    0.242613] PCI: Using MMCONFIG for extended config space
[    0.242615] PCI: Using configuration type 1 for base access
[    0.244311] bio: create slab <bio-0> at 0
[    0.245220] ACPI: EC: Look up EC in DSDT
[    0.255673] ACPI: Interpreter enabled
[    0.255677] ACPI: (supports S0 S5)
[    0.255687] ACPI: Using IOAPIC for interrupt routing
[    0.267781] ACPI: No dock devices found.
[    0.267793] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.268021] pci 0000:00:01.1: reg 10 io port: [0xfc00-0xfc3f]
[    0.268031] pci 0000:00:01.1: reg 20 io port: [0x1c00-0x1c3f]
[    0.268035] pci 0000:00:01.1: reg 24 io port: [0x1c40-0x1c7f]
[    0.268053] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.268058] pci 0000:00:01.1: PME# disabled
[    0.268081] pci 0000:00:02.0: reg 10 32bit mmio: [0xfe02f000-0xfe02ffff]
[    0.268099] pci 0000:00:02.0: supports D1 D2
[    0.268101] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.268103] pci 0000:00:02.0: PME# disabled
[    0.268120] pci 0000:00:02.1: reg 10 32bit mmio: [0xfe02e000-0xfe02e0ff]
[    0.268138] pci 0000:00:02.1: supports D1 D2
[    0.268139] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.268142] pci 0000:00:02.1: PME# disabled
[    0.268164] pci 0000:00:04.0: reg 20 io port: [0xf000-0xf00f]
[    0.268188] pci 0000:00:05.0: reg 10 io port: [0x9f0-0x9f7]
[    0.268191] pci 0000:00:05.0: reg 14 io port: [0xbf0-0xbf3]
[    0.268194] pci 0000:00:05.0: reg 18 io port: [0x970-0x977]
[    0.268197] pci 0000:00:05.0: reg 1c io port: [0xb70-0xb73]
[    0.268200] pci 0000:00:05.0: reg 20 io port: [0xdc00-0xdc0f]
[    0.268203] pci 0000:00:05.0: reg 24 32bit mmio: [0xfe02d000-0xfe02dfff]
[    0.268230] pci 0000:00:05.1: reg 10 io port: [0x9e0-0x9e7]
[    0.268233] pci 0000:00:05.1: reg 14 io port: [0xbe0-0xbe3]
[    0.268236] pci 0000:00:05.1: reg 18 io port: [0x960-0x967]
[    0.268238] pci 0000:00:05.1: reg 1c io port: [0xb60-0xb63]
[    0.268241] pci 0000:00:05.1: reg 20 io port: [0xc800-0xc80f]
[    0.268244] pci 0000:00:05.1: reg 24 32bit mmio: [0xfe02c000-0xfe02cfff]
[    0.268271] pci 0000:00:05.2: reg 10 io port: [0xc400-0xc407]
[    0.268274] pci 0000:00:05.2: reg 14 io port: [0xc000-0xc003]
[    0.268277] pci 0000:00:05.2: reg 18 io port: [0xbc00-0xbc07]
[    0.268280] pci 0000:00:05.2: reg 1c io port: [0xb800-0xb803]
[    0.268283] pci 0000:00:05.2: reg 20 io port: [0xb400-0xb40f]
[    0.268286] pci 0000:00:05.2: reg 24 32bit mmio: [0xfe02b000-0xfe02bfff]
[    0.268336] pci 0000:00:06.1: reg 10 32bit mmio: [0xfe024000-0xfe027fff]
[    0.268357] pci 0000:00:06.1: PME# supported from D3hot D3cold
[    0.268360] pci 0000:00:06.1: PME# disabled
[    0.268388] pci 0000:00:08.0: reg 10 32bit mmio: [0xfe02a000-0xfe02afff]
[    0.268391] pci 0000:00:08.0: reg 14 io port: [0xb000-0xb007]
[    0.268394] pci 0000:00:08.0: reg 18 32bit mmio: [0xfe029000-0xfe0290ff]
[    0.268397] pci 0000:00:08.0: reg 1c 32bit mmio: [0xfe028000-0xfe02800f]
[    0.268416] pci 0000:00:08.0: supports D1 D2
[    0.268417] pci 0000:00:08.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.268421] pci 0000:00:08.0: PME# disabled
[    0.268454] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.268456] pci 0000:00:0e.0: PME# disabled
[    0.268482] pci 0000:00:0f.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.268484] pci 0000:00:0f.0: PME# disabled
[    0.268575] pci 0000:01:07.0: reg 10 io port: [0xac00-0xac3f]
[    0.268600] pci 0000:01:07.0: supports D1 D2
[    0.268621] pci 0000:01:08.0: reg 10 32bit mmio: [0xfb000000-0xfbffffff]
[    0.268664] pci 0000:01:08.2: reg 10 32bit mmio: [0xfa000000-0xfaffffff]
[    0.268710] pci 0000:01:0b.0: reg 10 32bit mmio: [0xfcfff000-0xfcfff7ff]
[    0.268714] pci 0000:01:0b.0: reg 14 32bit mmio: [0xfcff8000-0xfcffbfff]
[    0.268739] pci 0000:01:0b.0: supports D1 D2
[    0.268740] pci 0000:01:0b.0: PME# supported from D0 D1 D2 D3hot
[    0.268743] pci 0000:01:0b.0: PME# disabled
[    0.268761] pci 0000:00:06.0: transparent bridge
[    0.268763] pci 0000:00:06.0: bridge io port: [0xa000-0xafff]
[    0.268766] pci 0000:00:06.0: bridge 32bit mmio: [0xfa000000-0xfcffffff]
[    0.268823] pci 0000:02:00.0: reg 24 32bit mmio: [0xfdefe000-0xfdefffff]
[    0.268830] pci 0000:02:00.0: reg 30 32bit mmio: [0xfdee0000-0xfdeeffff]
[    0.268851] pci 0000:02:00.0: PME# supported from D3hot
[    0.268854] pci 0000:02:00.0: PME# disabled
[    0.268889] pci 0000:02:00.1: reg 10 io port: [0x9c00-0x9c07]
[    0.268896] pci 0000:02:00.1: reg 14 io port: [0x9800-0x9803]
[    0.268902] pci 0000:02:00.1: reg 18 io port: [0x9400-0x9407]
[    0.268908] pci 0000:02:00.1: reg 1c io port: [0x9000-0x9003]
[    0.268914] pci 0000:02:00.1: reg 20 io port: [0x8c00-0x8c0f]
[    0.268961] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.269026] pci 0000:00:0e.0: bridge io port: [0x8000-0x9fff]
[    0.269028] pci 0000:00:0e.0: bridge 32bit mmio: [0xfde00000-0xfdefffff]
[    0.269050] pci 0000:03:00.0: reg 10 64bit mmio: [0xe0000000-0xefffffff]
[    0.269057] pci 0000:03:00.0: reg 18 64bit mmio: [0xfdde0000-0xfddeffff]
[    0.269061] pci 0000:03:00.0: reg 20 io port: [0x7c00-0x7cff]
[    0.269068] pci 0000:03:00.0: reg 30 32bit mmio: [0xfddc0000-0xfdddffff]
[    0.269082] pci 0000:03:00.0: supports D1 D2
[    0.269106] pci 0000:03:00.1: reg 10 64bit mmio: [0xfddfc000-0xfddfffff]
[    0.269132] pci 0000:03:00.1: supports D1 D2
[    0.271054] pci 0000:00:0f.0: bridge io port: [0x7000-0x7fff]
[    0.271056] pci 0000:00:0f.0: bridge 32bit mmio: [0xfdd00000-0xfddfffff]
[    0.271059] pci 0000:00:0f.0: bridge 64bit mmio pref: [0xe0000000-0xefffffff]
[    0.271065] pci_bus 0000:00: on NUMA node 0
[    0.271071] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.271348] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.331310] ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.331531] ACPI: PCI Interrupt Link [LNK2] (IRQs *5 7 9 10 11 14 15)
[    0.331746] ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.331962] ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.332180] ACPI: PCI Interrupt Link [LNK5] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.332397] ACPI: PCI Interrupt Link [LNK6] (IRQs 5 7 9 *10 11 14 15)
[    0.332613] ACPI: PCI Interrupt Link [LNK7] (IRQs 5 7 9 10 *11 14 15)
[    0.332825] ACPI: PCI Interrupt Link [LNK8] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.333046] ACPI: PCI Interrupt Link [LP2P] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.333262] ACPI: PCI Interrupt Link [LUBA] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.333479] ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7 9 *10 11 14 15)
[    0.333693] ACPI: PCI Interrupt Link [LMC1] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.333910] ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 9 10 *11 14 15)
[    0.334133] ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.334349] ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.334564] ACPI: PCI Interrupt Link [LUB2] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.334775] ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.334992] ACPI: PCI Interrupt Link [LSID] (IRQs *5 7 9 10 11 14 15)
[    0.335211] ACPI: PCI Interrupt Link [LFID] (IRQs 5 7 9 *10 11 14 15)
[    0.335428] ACPI: PCI Interrupt Link [LSA2] (IRQs 5 7 9 10 *11 14 15)
[    0.335675] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
[    0.335911] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
[    0.336155] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0, disabled.
[    0.336388] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
[    0.336615] ACPI: PCI Interrupt Link [APC5] (IRQs 16) *0, disabled.
[    0.336846] ACPI: PCI Interrupt Link [APC6] (IRQs 16) *0
[    0.337091] ACPI: PCI Interrupt Link [APC7] (IRQs 16) *0
[    0.337319] ACPI: PCI Interrupt Link [APC8] (IRQs 16) *0, disabled.
[    0.337552] ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabled.
[    0.337781] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
[    0.338022] ACPI: PCI Interrupt Link [AMC1] (IRQs 20 21 22 23) *0, disabled.
[    0.338256] ACPI: PCI Interrupt Link [APMU] (IRQs 20 21 22 23) *0, disabled.
[    0.338484] ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22 23) *0
[    0.338722] ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
[    0.338955] ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabled.
[    0.339192] ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22 23) *0, disabled.
[    0.339426] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
[    0.339661] ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
[    0.339890] ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0
[    0.340124] ACPI: PCI Interrupt Link [ASA2] (IRQs 20 21 22 23) *0
[    0.340527] usbcore: registered new interface driver usbfs
[    0.340587] usbcore: registered new interface driver hub
[    0.340633] usbcore: registered new device driver usb
[    0.340761] PCI: Using ACPI for IRQ routing
[    0.345017] hpet0: at MMIO 0xfefff000, IRQs 2, 8, 31
[    0.345021] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
[    0.351006] pnp: PnP ACPI init
[    0.351011] ACPI: bus type pnp registered
[    0.357371] pnp: PnP ACPI: found 13 devices
[    0.357372] ACPI: ACPI bus type pnp unregistered
[    0.357380] system 00:01: ioport range 0x1000-0x107f has been reserved
[    0.357383] system 00:01: ioport range 0x1080-0x10ff has been reserved
[    0.357385] system 00:01: ioport range 0x1400-0x147f has been reserved
[    0.357387] system 00:01: ioport range 0x1480-0x14ff has been reserved
[    0.357390] system 00:01: ioport range 0x1800-0x187f has been reserved
[    0.357392] system 00:01: ioport range 0x1880-0x18ff has been reserved
[    0.357397] system 00:02: ioport range 0x4d0-0x4d1 has been reserved
[    0.357399] system 00:02: ioport range 0x800-0x87f has been reserved
[    0.357401] system 00:02: ioport range 0x290-0x297 has been reserved
[    0.357408] system 00:0b: iomem range 0xf0000000-0xf3ffffff has been reserved
[    0.357413] system 00:0c: iomem range 0xd2800-0xd3fff has been reserved
[    0.357415] system 00:0c: iomem range 0xf0000-0xf7fff could not be reserved
[    0.357417] system 00:0c: iomem range 0xf8000-0xfbfff could not be reserved
[    0.357419] system 00:0c: iomem range 0xfc000-0xfffff could not be reserved
[    0.357422] system 00:0c: iomem range 0xfefff000-0xfefff0ff has been reserved
[    0.357424] system 00:0c: iomem range 0xdfee0000-0xdfefffff could not be reserved
[    0.357427] system 00:0c: iomem range 0xffff0000-0xffffffff has been reserved
[    0.357429] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.357432] system 00:0c: iomem range 0x100000-0xdfedffff could not be reserved
[    0.357434] system 00:0c: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.357437] system 00:0c: iomem range 0xfee00000-0xfeefffff has been reserved
[    0.357439] system 00:0c: iomem range 0xfefff000-0xfeffffff could not be reserved
[    0.357442] system 00:0c: iomem range 0xfff80000-0xfff80fff has been reserved
[    0.357444] system 00:0c: iomem range 0xfff90000-0xfffbffff has been reserved
[    0.357447] system 00:0c: iomem range 0xfffed000-0xfffeffff has been reserved
[    0.392387] pci 0000:00:06.0: PCI bridge, secondary bus 0000:01
[    0.392389] pci 0000:00:06.0:   IO window: 0xa000-0xafff
[    0.392392] pci 0000:00:06.0:   MEM window: 0xfa000000-0xfcffffff
[    0.392394] pci 0000:00:06.0:   PREFETCH window: disabled
[    0.392397] pci 0000:00:0e.0: PCI bridge, secondary bus 0000:02
[    0.392399] pci 0000:00:0e.0:   IO window: 0x8000-0x9fff
[    0.392401] pci 0000:00:0e.0:   MEM window: 0xfde00000-0xfdefffff
[    0.392403] pci 0000:00:0e.0:   PREFETCH window: disabled
[    0.392406] pci 0000:00:0f.0: PCI bridge, secondary bus 0000:03
[    0.392408] pci 0000:00:0f.0:   IO window: 0x7000-0x7fff
[    0.392411] pci 0000:00:0f.0:   MEM window: 0xfdd00000-0xfddfffff
[    0.392413] pci 0000:00:0f.0:   PREFETCH window: 0x000000e0000000-0x000000efffffff
[    0.392419] pci 0000:00:06.0: setting latency timer to 64
[    0.392422] pci 0000:00:0e.0: setting latency timer to 64
[    0.392425] pci 0000:00:0f.0: setting latency timer to 64
[    0.392427] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.392430] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.392432] pci_bus 0000:01: resource 0 io:  [0xa000-0xafff]
[    0.392434] pci_bus 0000:01: resource 1 mem: [0xfa000000-0xfcffffff]
[    0.392435] pci_bus 0000:01: resource 2 mem: [0x0-0x0]
[    0.392437] pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
[    0.392439] pci_bus 0000:01: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.392441] pci_bus 0000:02: resource 0 io:  [0x8000-0x9fff]
[    0.392443] pci_bus 0000:02: resource 1 mem: [0xfde00000-0xfdefffff]
[    0.392445] pci_bus 0000:02: resource 2 mem: [0x0-0x0]
[    0.392446] pci_bus 0000:02: resource 3 mem: [0x0-0x0]
[    0.392448] pci_bus 0000:03: resource 0 io:  [0x7000-0x7fff]
[    0.392450] pci_bus 0000:03: resource 1 mem: [0xfdd00000-0xfddfffff]
[    0.392456] pci_bus 0000:03: resource 2 mem: [0xe0000000-0xefffffff]
[    0.392458] pci_bus 0000:03: resource 3 mem: [0x0-0x0]
[    0.392513] NET: Registered protocol family 2
[    0.408074] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.408339] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.408807] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.409061] TCP: Hash tables configured (established 131072 bind 65536)
[    0.409063] TCP reno registered
[    0.414095] NET: Registered protocol family 1
[    0.414196] Unpacking initramfs...<7>Switched to high resolution mode on CPU 2
[    0.500719] Switched to high resolution mode on CPU 3
[    0.500797] Switched to high resolution mode on CPU 1
[    0.501046] Switched to high resolution mode on CPU 0
[    0.516046]  done
[    0.516997] Freeing initrd memory: 3027k freed
[    0.518271] Scanning for low memory corruption every 60 seconds
[    0.518444] audit: initializing netlink socket (disabled)
[    0.518456] type=2000 audit(1231701629.518:1): initialized
[    0.518861] highmem bounce pool size: 64 pages
[    0.518865] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.519046] msgmni has been set to 1697
[    0.519233] alg: No test for stdrng (krng)
[    0.519286] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    0.519288] io scheduler noop registered
[    0.519305] io scheduler cfq registered (default)
[    0.532277] pci 0000:03:00.0: Boot video device
[    0.532387] pcieport-driver 0000:00:0e.0: setting latency timer to 64
[    0.532497] pcieport-driver 0000:00:0f.0: setting latency timer to 64
[    0.532725] fan PNP0C0B:00: registered as cooling_device0
[    0.532728] ACPI: Fan [FAN] (on)
[    0.533201] processor ACPI_CPU:00: registered as cooling_device1
[    0.533252] processor ACPI_CPU:01: registered as cooling_device2
[    0.533301] processor ACPI_CPU:02: registered as cooling_device3
[    0.533352] processor ACPI_CPU:03: registered as cooling_device4
[    0.533816] ACPI Warning (nspredef-0940): \_TZ_.THRM._PSL: Return Package type mismatch at index 0 - found [NULL Object Descriptor], expected Reference [20081204]
[    0.533821] ACPI: Expecting a [Reference] package element, found type 0
[    0.534074] thermal LNXTHERM:01: registered as thermal_zone0
[    0.534495] ACPI: Thermal Zone [THRM] (40 C)
[    0.537040] Real Time Clock Driver v1.12b
[    0.537271] Non-volatile memory driver v1.3
[    0.537275] Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
[    0.537384] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.537727] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.538119] PNP: No PS/2 controller found. Probing ports directly.
[    0.538515] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.538521] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.538614] mice: PS/2 mouse device common for all mice
[    0.538751] cpuidle: using governor ladder
[    0.539470] usbcore: registered new interface driver hiddev
[    0.539502] usbcore: registered new interface driver usbhid
[    0.539504] usbhid: v2.6:USB HID core driver
[    0.539738] TCP cubic registered
[    0.539739] Initializing XFRM netlink socket
[    0.539750] NET: Registered protocol family 17
[    0.539764] Using IPI Shortcut mode
[    0.540125] Freeing unused kernel memory: 324k freed
[    0.796064] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.796453] ACPI: PCI Interrupt Link [APCL] enabled at IRQ 23
[    0.796463] ehci_hcd 0000:00:02.1: PCI INT B -> Link[APCL] -> GSI 23 (level, low) -> IRQ 23
[    0.796487] ehci_hcd 0000:00:02.1: setting latency timer to 64
[    0.796489] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    0.796575] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[    0.796596] ehci_hcd 0000:00:02.1: debug port 1
[    0.796599] ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
[    0.796615] ehci_hcd 0000:00:02.1: irq 23, io mem 0xfe02e000
[    0.802392] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    0.802415] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.802418] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.802420] usb usb1: Product: EHCI Host Controller
[    0.802421] usb usb1: Manufacturer: Linux 2.6.29-rc1 ehci_hcd
[    0.802423] usb usb1: SerialNumber: 0000:00:02.1
[    0.802480] usb usb1: configuration #1 chosen from 1 choice
[    0.802520] hub 1-0:1.0: USB hub found
[    0.802525] hub 1-0:1.0: 10 ports detected
[    0.804748] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.805137] ACPI: PCI Interrupt Link [APCF] enabled at IRQ 22
[    0.805148] ohci_hcd 0000:00:02.0: PCI INT A -> Link[APCF] -> GSI 22 (level, low) -> IRQ 22
[    0.805171] ohci_hcd 0000:00:02.0: setting latency timer to 64
[    0.805173] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    0.805250] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[    0.805275] ohci_hcd 0000:00:02.0: irq 22, io mem 0xfe02f000
[    0.859166] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    0.859168] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.859170] usb usb2: Product: OHCI Host Controller
[    0.859171] usb usb2: Manufacturer: Linux 2.6.29-rc1 ohci_hcd
[    0.859173] usb usb2: SerialNumber: 0000:00:02.0
[    0.859231] usb usb2: configuration #1 chosen from 1 choice
[    0.859269] hub 2-0:1.0: USB hub found
[    0.859276] hub 2-0:1.0: 10 ports detected
[    0.861443] uhci_hcd: USB Universal Host Controller Interface driver
[    0.880819] SCSI subsystem initialized
[    0.883719] Driver 'sd' needs updating - please use bus_type methods
[    0.896217] libata version 3.00 loaded.
[    0.898353] pata_amd 0000:00:04.0: version 0.3.11
[    0.898386] pata_amd 0000:00:04.0: setting latency timer to 64
[    0.898445] scsi0 : pata_amd
[    0.898523] scsi1 : pata_amd
[    0.899295] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[    0.899298] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[    1.320952] ata1.00: ATA-7: MAXTOR STM3320620A, 3.AAE, max UDMA/100
[    1.320955] ata1.00: 625142448 sectors, multi 1: LBA48 
[    1.320981] ata1.01: ATAPI: HP DVD Writer 1040d, EH24, max UDMA/66
[    1.321009] ata1: nv_mode_filter: 0x3f39f&0x3f01f->0x3f01f, BIOS=0x3f000 (0xc6c50000) ACPI=0x3f01f (20:30:0x1f)
[    1.321013] ata1: nv_mode_filter: 0x1f39f&0x1f01f->0x1f01f, BIOS=0x1f000 (0xc6c50000) ACPI=0x1f01f (20:30:0x1f)
[    1.361142] usb 1-10: new high speed USB device using ehci_hcd and address 5
[    1.395910] ata1.00: configured for UDMA/100
[    1.417574] ata1.01: configured for UDMA/66
[    1.418349] scsi 0:0:0:0: Direct-Access     ATA      MAXTOR STM332062 3.AA PQ: 0 ANSI: 5
[    1.418427] sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
[    1.418437] sd 0:0:0:0: [sda] Write Protect is off
[    1.418439] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.418451] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.418494] sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
[    1.418502] sd 0:0:0:0: [sda] Write Protect is off
[    1.418503] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.418521] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.418523]  sda: sda1 sda2 sda3
[    1.443986] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.445090] scsi 0:0:1:0: CD-ROM            HP       DVD Writer 1040d EH24 PQ: 0 ANSI: 5
[    1.445169] ata2: port disabled. ignoring.
[    1.475232] usb 1-10: New USB device found, idVendor=0409, idProduct=0059
[    1.475235] usb 1-10: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.475294] usb 1-10: configuration #1 chosen from 1 choice
[    1.475390] hub 1-10:1.0: USB hub found
[    1.475478] hub 1-10:1.0: 4 ports detected
[    1.693391] usb 2-2: new full speed USB device using ohci_hcd and address 2
[    1.843483] usb 2-2: New USB device found, idVendor=04b8, idProduct=0005
[    1.843485] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.843487] usb 2-2: Product: USB Printer
[    1.843488] usb 2-2: Manufacturer: EPSON
[    1.843490] usb 2-2: SerialNumber: RL0200301161041200
[    1.843545] usb 2-2: configuration #1 chosen from 1 choice
[    2.063392] usb 2-4: new low speed USB device using ohci_hcd and address 3
[    2.208604] usb 2-4: New USB device found, idVendor=046d, idProduct=c517
[    2.208606] usb 2-4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.208608] usb 2-4: Product: USB Receiver
[    2.208609] usb 2-4: Manufacturer: Logitech
[    2.208667] usb 2-4: configuration #1 chosen from 1 choice
[    2.218810] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:02.0/usb2/2-4/2-4:1.0/input/input0
[    2.224432] logitech 0003:046D:C517.0001: input,hidraw0: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:02.0-4/input0
[    2.232612] logitech 0003:046D:C517.0002: fixing up Logitech keyboard report descriptor
[    2.233148] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:02.0/usb2/2-4/2-4:1.1/input/input1
[    2.244491] logitech 0003:046D:C517.0002: input,hiddev96,hidraw1: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:02.0-4/input1
[    2.461392] usb 2-5: new full speed USB device using ohci_hcd and address 4
[    2.596733] usb 2-5: New USB device found, idVendor=0451, idProduct=2046
[    2.596735] usb 2-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.596791] usb 2-5: configuration #1 chosen from 1 choice
[    2.599769] hub 2-5:1.0: USB hub found
[    2.602734] hub 2-5:1.0: 4 ports detected
[    2.696399] usb 1-10.1: new low speed USB device using ehci_hcd and address 6
[    2.901824] usb 1-10.1: New USB device found, idVendor=050d, idProduct=0751
[    2.901826] usb 1-10.1: New USB device strings: Mfr=4, Product=20, SerialNumber=0
[    2.901828] usb 1-10.1: Product: Belkin UPS
[    2.901829] usb 1-10.1: Manufacturer: Belkin 
[    2.901883] usb 1-10.1: configuration #1 chosen from 1 choice
[    3.622497] generic-usb 0003:050D:0751.0003: hiddev97,hidraw2: USB HID v1.11 Device [Belkin  Belkin UPS] on usb-0000:00:02.1-10.1/input0
[    3.696719] usb 1-10.2: new full speed USB device using ehci_hcd and address 7
[    3.792741] usb 1-10.2: New USB device found, idVendor=0403, idProduct=6001
[    3.792744] usb 1-10.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.792745] usb 1-10.2: Product: USB FAST SERIAL ADAPTER
[    3.792747] usb 1-10.2: Manufacturer: FTDI
[    3.792748] usb 1-10.2: SerialNumber: FTOOS09N
[    3.792801] usb 1-10.2: configuration #1 chosen from 1 choice
[    3.869768] usb 1-10.3: new full speed USB device using ehci_hcd and address 8
[    3.949209] sata_nv 0000:00:05.0: version 3.5
[    3.949569] ACPI: PCI Interrupt Link [APSI] enabled at IRQ 21
[    3.949579] sata_nv 0000:00:05.0: PCI INT A -> Link[APSI] -> GSI 21 (level, low) -> IRQ 21
[    3.949581] sata_nv 0000:00:05.0: Using SWNCQ mode
[    3.949888] sata_nv 0000:00:05.0: setting latency timer to 64
[    3.950284] scsi2 : sata_nv
[    3.950358] scsi3 : sata_nv
[    3.950532] ata3: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xdc00 irq 21
[    3.950534] ata4: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xdc08 irq 21
[    3.957546] usb 1-10.3: New USB device found, idVendor=03eb, idProduct=3301
[    3.957549] usb 1-10.3: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    3.957550] usb 1-10.3: Product: Standard USB Hub
[    3.957613] usb 1-10.3: configuration #1 chosen from 1 choice
[    3.958317] hub 1-10.3:1.0: USB hub found
[    3.958420] hub 1-10.3:1.0: 4 ports detected
[    4.032828] usb 1-10.4: new high speed USB device using ehci_hcd and address 9
[    4.120099] usb 1-10.4: New USB device found, idVendor=0409, idProduct=0059
[    4.120101] usb 1-10.4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.120148] usb 1-10.4: configuration #1 chosen from 1 choice
[    4.120255] hub 1-10.4:1.0: USB hub found
[    4.120348] hub 1-10.4:1.0: 4 ports detected
[    4.393942] usb 1-10.4.4: new full speed USB device using ehci_hcd and address 10
[    4.405162] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.409632] ata3.00: ATA-8: ST3500320AS, SD15, max UDMA/133
[    4.409634] ata3.00: 976773168 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    4.415895] ata3.00: configured for UDMA/133
[    4.415971] scsi 2:0:0:0: Direct-Access     ATA      ST3500320AS      SD15 PQ: 0 ANSI: 5
[    4.416049] sd 2:0:0:0: [sdb] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
[    4.416059] sd 2:0:0:0: [sdb] Write Protect is off
[    4.416061] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    4.416074] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.416118] sd 2:0:0:0: [sdb] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
[    4.416133] sd 2:0:0:0: [sdb] Write Protect is off
[    4.416135] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    4.416150] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.416152]  sdb: sdb1 sdb2 sdb3
[    4.419347] sd 2:0:0:0: [sdb] Attached SCSI disk
[    4.482093] usb 1-10.4.4: New USB device found, idVendor=04b8, idProduct=010f
[    4.482096] usb 1-10.4.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.482098] usb 1-10.4.4: Product: EPSON Scanner 010F
[    4.482099] usb 1-10.4.4: Manufacturer: EPSON
[    4.482149] usb 1-10.4.4: configuration #1 chosen from 1 choice
[    4.873290] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.876563] ata4.00: ATA-7: Hitachi HDT725040VLA360, V5COA7EA, max UDMA/133
[    4.876565] ata4.00: 781422768 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    4.882700] ata4.00: configured for UDMA/133
[    4.893445] scsi 3:0:0:0: Direct-Access     ATA      Hitachi HDT72504 V5CO PQ: 0 ANSI: 5
[    4.893544] sd 3:0:0:0: [sdc] 781422768 512-byte hardware sectors: (400 GB/372 GiB)
[    4.893554] sd 3:0:0:0: [sdc] Write Protect is off
[    4.893556] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    4.893568] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.893605] sd 3:0:0:0: [sdc] 781422768 512-byte hardware sectors: (400 GB/372 GiB)
[    4.893612] sd 3:0:0:0: [sdc] Write Protect is off
[    4.893614] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    4.893629] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.893631]  sdc: sdc1
[    4.903147] sd 3:0:0:0: [sdc] Attached SCSI disk
[    4.903582] ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 20
[    4.903592] sata_nv 0000:00:05.1: PCI INT B -> Link[APSJ] -> GSI 20 (level, low) -> IRQ 20
[    4.903594] sata_nv 0000:00:05.1: Using SWNCQ mode
[    4.903879] sata_nv 0000:00:05.1: setting latency timer to 64
[    4.904211] scsi4 : sata_nv
[    4.904272] scsi5 : sata_nv
[    4.904444] ata5: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xc800 irq 20
[    4.904447] ata6: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xc808 irq 20
[    5.511496] ACPI: PCI Interrupt Link [ASA2] enabled at IRQ 23
[    5.511499] sata_nv 0000:00:05.2: PCI INT C -> Link[ASA2] -> GSI 23 (level, low) -> IRQ 23
[    5.511502] sata_nv 0000:00:05.2: Using SWNCQ mode
[    5.511781] sata_nv 0000:00:05.2: setting latency timer to 64
[    5.512096] scsi6 : sata_nv
[    5.512151] scsi7 : sata_nv
[    5.512323] ata7: SATA max UDMA/133 cmd 0xc400 ctl 0xc000 bmdma 0xb400 irq 23
[    5.512325] ata8: SATA max UDMA/133 cmd 0xbc00 ctl 0xb800 bmdma 0xb408 irq 23
[    8.621702] pata_jmicron 0000:02:00.1: enabling device (0000 -> 0001)
[    8.622082] ACPI: PCI Interrupt Link [APC8] enabled at IRQ 16
[    8.622092] pata_jmicron 0000:02:00.1: PCI INT B -> Link[APC8] -> GSI 16 (level, low) -> IRQ 16
[    8.622123] pata_jmicron 0000:02:00.1: setting latency timer to 64
[    8.622184] scsi8 : pata_jmicron
[    8.622245] scsi9 : pata_jmicron
[    8.622313] ata9: PATA max UDMA/100 cmd 0x9c00 ctl 0x9800 bmdma 0x8c00 irq 16
[    8.622315] ata10: PATA max UDMA/100 cmd 0x9400 ctl 0x9000 bmdma 0x8c08 irq 16
[   11.439618] ahci 0000:02:00.0: version 3.0
[   11.439994] ACPI: PCI Interrupt Link [APC7] enabled at IRQ 16
[   11.439997] ahci 0000:02:00.0: PCI INT A -> Link[APC7] -> GSI 16 (level, low) -> IRQ 16
[   11.451155] ahci 0000:02:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[   11.451159] ahci 0000:02:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
[   11.451163] ahci 0000:02:00.0: setting latency timer to 64
[   11.451291] scsi10 : ahci
[   11.451379] scsi11 : ahci
[   11.451411] ata11: SATA max UDMA/133 abar m8192@0xfdefe000 port 0xfdefe100 irq 16
[   11.451414] ata12: SATA max UDMA/133 abar m8192@0xfdefe000 port 0xfdefe180 irq 16
[   11.757154] ata11: SATA link down (SStatus 0 SControl 300)
[   12.083280] ata12: SATA link down (SStatus 0 SControl 300)
[   14.936457] kjournald starting.  Commit interval 5 seconds
[   14.936463] EXT3-fs: mounted filesystem with ordered data mode.
[   17.095964] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[   17.099383] ACPI: Power Button (FF) [PWRF]
[   17.099428] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input3
[   17.104392] ACPI: Power Button (CM) [PWRB]
[   17.202203] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x1c00
[   17.202208] ACPI: I/O resource nForce2_smbus [0x1c40-0x1c7f] conflicts with ACPI region SM01 [0x1c40-0x1c45]
[   17.202210] ACPI: Device needs an ACPI driver
[   17.202222] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x1c40
[   17.259339] IT8716 SuperIO detected.
[   17.259568] parport_pc 00:0a: reported by Plug and Play ACPI
[   17.259643] parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
[   17.282703] usblp0: USB Bidirectional printer dev 2 if 0 alt 0 proto 2 vid 0x04B8 pid 0x0005
[   17.282723] usbcore: registered new interface driver usblp
[   17.282798] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   17.282819] scsi 0:0:1:0: Attached scsi generic sg1 type 5
[   17.282840] sd 2:0:0:0: Attached scsi generic sg2 type 0
[   17.282860] sd 3:0:0:0: Attached scsi generic sg3 type 0
[   17.295578] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   17.309126] Driver 'sr' needs updating - please use bus_type methods
[   17.314103] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[   17.314106] Uniform CD-ROM driver Revision: 3.20
[   17.314172] sr 0:0:1:0: Attached scsi CD-ROM sr0
[   17.320099] usbcore: registered new interface driver usbserial
[   17.320102] usbserial: USB Serial Driver core
[   17.398981] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
[   17.399369] ACPI: PCI Interrupt Link [APCH] enabled at IRQ 22
[   17.399374] forcedeth 0000:00:08.0: PCI INT A -> Link[APCH] -> GSI 22 (level, low) -> IRQ 22
[   17.399378] forcedeth 0000:00:08.0: setting latency timer to 64
[   17.399471] nv_probe: set workaround bit for reversed mac addr
[   17.402478] Floppy drive(s): fd0 is 1.44M
[   17.418139] FDC 0 is a post-1991 82077
[   17.420219] USB Serial support registered for FTDI USB Serial Device
[   17.420269] ftdi_sio 1-10.2:1.0: FTDI USB Serial Device converter detected
[   17.420285] usb 1-10.2: Detected FT232RL
[   17.420338] usb 1-10.2: FTDI USB Serial Device converter now attached to ttyUSB0
[   17.420365] usbcore: registered new interface driver ftdi_sio
[   17.420367] ftdi_sio: v1.4.3:USB FTDI Serial Converters Driver
[   17.490630] ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
[   17.490641] firewire_ohci 0000:01:0b.0: PCI INT A -> Link[APC4] -> GSI 19 (level, low) -> IRQ 19
[   17.545870] Linux video capture interface: v2.00
[   17.547825] firewire_ohci: Added fw-ohci device 0000:01:0b.0, OHCI version 1.10
[   17.809433] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
[   17.810018] cx88[0]: subsystem: 7063:3000, board: pcHDTV HD3000 HDTV [card=22,autodetected], frontend(s): 1
[   17.810021] cx88[0]: TV tuner type 60, Radio tuner type -1
[   17.815112] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
[   17.912492] forcedeth 0000:00:08.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:1f:c6:62:fc:bb
[   17.912496] forcedeth 0000:00:08.0: highdma csum vlan pwrctl mgmt timirq gbit lnktim msi desc-v3
[   17.912911] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 21
[   17.912916] HDA Intel 0000:00:06.1: PCI INT B -> Link[AAZA] -> GSI 21 (level, low) -> IRQ 21
[   17.912970] HDA Intel 0000:00:06.1: setting latency timer to 64
[   17.956269] tuner' 2-0043: chip found @ 0x86 (cx88[0])
[   17.962033] tda9887 2-0043: creating new instance
[   17.962036] tda9887 2-0043: tda988[5/6/7] found
[   17.965170] tuner' 2-0061: chip found @ 0xc2 (cx88[0])
[   18.027345] tuner-simple 2-0061: creating new instance
[   18.027349] tuner-simple 2-0061: type set to 60 (Thomson DTT 761X (ATSC/NTSC))
[   18.029659] cx88[0]/2: cx2388x 8802 Driver Manager
[   18.030044] ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
[   18.030055] cx88-mpeg driver manager 0000:01:08.2: PCI INT A -> Link[APC3] -> GSI 18 (level, low) -> IRQ 18
[   18.030061] cx88[0]/2: found at 0000:01:08.2, rev: 5, irq: 18, latency: 32, mmio: 0xfa000000
[   18.030066] IRQ 18/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[   18.030102] cx8800 0000:01:08.0: PCI INT A -> Link[APC3] -> GSI 18 (level, low) -> IRQ 18
[   18.030107] cx88[0]/0: found at 0000:01:08.0, rev: 5, irq: 18, latency: 32, mmio: 0xfb000000
[   18.030113] IRQ 18/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[   18.030160] cx88[0]/0: registered device video0 [v4l2]
[   18.030178] cx88[0]/0: registered device vbi0
[   18.030193] cx88[0]/0: registered device radio0
[   18.032901] ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
[   18.032908] EMU10K1_Audigy 0000:01:07.0: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
[   18.035129] Audigy2 value: Special config.
[   18.047461] firewire_core: created device fw0: GUID 001e8c00012f990c, S400
[   18.056930] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[   18.056934] cx88/2: registering cx8802 driver, type: dvb access: shared
[   18.056938] cx88[0]/2: subsystem: 7063:3000, board: pcHDTV HD3000 HDTV [card=22]
[   18.056940] cx88[0]/2: cx2388x based DVB/ATSC card
[   18.056949] BUG: unable to handle kernel NULL pointer dereference at (null)
[   18.057019] IP: [<c05fe336>] __mutex_lock_slowpath+0x26/0x90
[   18.057070] *pdpt = 0000000036859001 *pde = 0000000000000000 
[   18.057074] Oops: 0002 [#1] PREEMPT SMP 
[   18.057158] last sysfs file: /sys/devices/pci0000:00/0000:00:06.0/0000:01:0b.0/fw0/dev
[   18.057185] Modules linked in: cx88_dvb(+) snd_emu10k1_synth videobuf_dvb dvb_core tuner_simple tuner_types tda9887 tda8290 tuner snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_emu10k1 snd_rawmidi snd_ac97_codec snd_hda_intel(+) snd_hda_codec snd_seq_dummy ac97_bus snd_seq_oss(+) snd_seq_midi_event snd_seq cx8800 cx8802 snd_pcm_oss cx88xx snd_mixer_oss snd_pcm ir_common snd_seq_device v4l2_common videodev i2c_algo_bit snd_util_mem v4l1_compat tveeprom firewire_ohci snd_hwdep btcx_risc snd_timer videobuf_dma_sg firewire_core snd videobuf_core ftdi_sio floppy forcedeth snd_page_alloc crc_itu_t soundcore usbserial sr_mod pcspkr sg usblp parport_pc cdrom evdev joydev i2c_nforce2 parport i2c_core button ahci pata_jmicron sata_nv pata_amd libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
[   18.057379] 
[   18.057379] Pid: 1780, comm: modprobe Tainted: G        W  (2.6.29-rc1 #1) System Product Name
[   18.057379] EIP: 0060:[<c05fe336>] EFLAGS: 00010246 CPU: 3
[   18.057379] EIP is at __mutex_lock_slowpath+0x26/0x90
[   18.057379] EAX: f64eb308 EBX: f64eb304 ECX: 00000086 EDX: 00000000
[   18.057379] ESI: f64eb308 EDI: f64eb30c EBP: f76158d0 ESP: f6464e7c
[   18.057379]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   18.057379] Process modprobe (pid: 1780, ti=f6464000 task=f76158d0 task.ti=f6464000)
[   18.057379] Stack:
[   18.057379]  f64eb30c f6464ea2 c0660242 f64eb2fc f691c800 00000001 f64eb304 c05fe19a
[   18.057379]  f845a122 ffffffed f691c800 00000001 f64eb204 f9644453 f96470a4 f691c810
[   18.057379]  00000042 205b5138 38312020 3635302e 5d303339 f691c810 f64eb200 f9644150
[   18.057379] Call Trace:
[   18.057379]  [<c05fe19a>] mutex_lock+0xa/0x10
[   18.057379]  [<f845a122>] videobuf_dvb_get_frontend+0x12/0x60 [videobuf_dvb]
[   18.057379]  [<f9644453>] cx8802_dvb_probe+0xe3/0x1e00 [cx88_dvb]
[   18.057379]  [<f9644150>] cx8802_dvb_remove+0x0/0x60 [cx88_dvb]
[   18.057379]  [<f9644370>] cx8802_dvb_probe+0x0/0x1e00 [cx88_dvb]
[   18.057379]  [<f843c534>] cx8802_register_driver+0x1a4/0x1f0 [cx8802]
[   18.057379]  [<f9646210>] dvb_init+0x0/0x40 [cx88_dvb]
[   18.057379]  [<c0401032>] _stext+0x32/0x170
[   18.057379]  [<c042146a>] enqueue_task_fair+0x1a/0x40
[   18.057379]  [<c041f2f3>] resched_task+0x53/0x60
[   18.057379]  [<c04224d6>] try_to_wake_up+0xd6/0x160
[   18.057379]  [<c044d637>] sys_init_module+0x87/0x1b0
[   18.057379]  [<c04878f1>] sys_read+0x41/0x70
[   18.057379]  [<c04032ed>] sysenter_do_call+0x12/0x21
[   18.057379] Code: b6 00 00 00 00 55 57 56 53 89 c3 8d 70 04 83 ec 0c 89 f0 64 8b 2d 00 c0 72 c0 e8 06 10 00 00 8d 7b 08 8b 57 04 89 3c 24 89 67 04 <89> 22 89 54 24 04 ba ff ff ff ff 89 6c 24 08 89 d0 87 03 83 e8 
[   18.057379] EIP: [<c05fe336>] __mutex_lock_slowpath+0x26/0x90 SS:ESP 0068:f6464e7c
[   18.063279] ---[ end trace 4eaa2a86a8e2da24 ]---
[   18.063340] note: modprobe[1780] exited with preempt_count 1
[   18.063411] BUG: scheduling while atomic: modprobe/1780/0x10000002
[   18.063472] Modules linked in: cx88_dvb(+) snd_emu10k1_synth videobuf_dvb dvb_core tuner_simple tuner_types tda9887 tda8290 tuner snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_emu10k1 snd_rawmidi snd_ac97_codec snd_hda_intel(+) snd_hda_codec snd_seq_dummy ac97_bus snd_seq_oss(+) snd_seq_midi_event snd_seq cx8800 cx8802 snd_pcm_oss cx88xx snd_mixer_oss snd_pcm ir_common snd_seq_device v4l2_common videodev i2c_algo_bit snd_util_mem v4l1_compat tveeprom firewire_ohci snd_hwdep btcx_risc snd_timer videobuf_dma_sg firewire_core snd videobuf_core ftdi_sio floppy forcedeth snd_page_alloc crc_itu_t soundcore usbserial sr_mod pcspkr sg usblp parport_pc cdrom evdev joydev i2c_nforce2 parport i2c_core button ahci pata_jmicron sata_nv pata_amd libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
[   18.065501] Pid: 1780, comm: modprobe Tainted: G      D W  2.6.29-rc1 #1
[   18.065554] Call Trace:
[   18.065614]  [<c05fdbdc>] schedule+0x66c/0x790
[   18.065674]  [<c044624d>] tick_dev_program_event+0x3d/0xc0
[   18.065737]  [<c047bc9d>] free_pages_and_swap_cache+0x8d/0xb0
[   18.065799]  [<c04240e3>] __cond_resched+0x13/0x30
[   18.065853]  [<c05fde47>] _cond_resched+0x27/0x30
[   18.065913]  [<c04708fb>] unmap_vmas+0x7ab/0x7e0
[   18.065976]  [<c042d1f5>] irq_exit+0x45/0x50
[   18.066038]  [<c0474c6e>] exit_mmap+0x8e/0x150
[   18.066100]  [<c0426723>] mmput+0x33/0xa0
[   18.066160]  [<c042a026>] exit_mm+0xc6/0xf0
[   18.066212]  [<c042b476>] do_exit+0x106/0x7d0
[   18.066267]  [<c04066f0>] oops_begin+0x0/0x90
[   18.066325]  [<c041831c>] do_page_fault+0x1ec/0x830
[   18.066391]  [<c044046a>] sched_clock_cpu+0x12a/0x180
[   18.066445]  [<c0418130>] do_page_fault+0x0/0x830
[   18.066511]  [<c05ff9a2>] error_code+0x72/0x78
[   18.066564]  [<c05fe336>] __mutex_lock_slowpath+0x26/0x90
[   18.066623]  [<c05fe19a>] mutex_lock+0xa/0x10
[   18.066684]  [<f845a122>] videobuf_dvb_get_frontend+0x12/0x60 [videobuf_dvb]
[   18.066740]  [<f9644453>] cx8802_dvb_probe+0xe3/0x1e00 [cx88_dvb]
[   18.066812]  [<f9644150>] cx8802_dvb_remove+0x0/0x60 [cx88_dvb]
[   18.066867]  [<f9644370>] cx8802_dvb_probe+0x0/0x1e00 [cx88_dvb]
[   18.066935]  [<f843c534>] cx8802_register_driver+0x1a4/0x1f0 [cx8802]
[   18.067005]  [<f9646210>] dvb_init+0x0/0x40 [cx88_dvb]
[   18.067059]  [<c0401032>] _stext+0x32/0x170
[   18.067119]  [<c042146a>] enqueue_task_fair+0x1a/0x40
[   18.067181]  [<c041f2f3>] resched_task+0x53/0x60
[   18.067240]  [<c04224d6>] try_to_wake_up+0xd6/0x160
[   18.067314]  [<c044d637>] sys_init_module+0x87/0x1b0
[   18.067369]  [<c04878f1>] sys_read+0x41/0x70
[   18.067436]  [<c04032ed>] sysenter_do_call+0x12/0x21
[   18.591541] HDA Intel 0000:03:00.1: PCI INT B -> Link[APC7] -> GSI 16 (level, low) -> IRQ 16
[   18.591710] HDA Intel 0000:03:00.1: setting latency timer to 64
[   20.541779] EXT3 FS on sdb3, internal journal
[   20.652519] kjournald starting.  Commit interval 5 seconds
[   20.652917] EXT3 FS on sdb1, internal journal
[   20.653002] EXT3-fs: mounted filesystem with ordered data mode.
[   20.660489] kjournald starting.  Commit interval 5 seconds
[   20.660742] EXT3 FS on sdc1, internal journal
[   20.660818] EXT3-fs: mounted filesystem with ordered data mode.
[   21.215159] Adding 4192956k swap on /dev/sdb2.  Priority:-1 extents:1 across:4192956k 

--Boundary-00=_2IlaJuHgFhmvxmo--
