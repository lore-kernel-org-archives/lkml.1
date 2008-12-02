Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbYLBMPC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbYLBMPC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 07:15:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbYLBMOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 07:14:53 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:58124 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbYLBMOt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 07:14:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=xHaZAiUowZTtLAyygASiRXiq25e5ooqhH9U87GS969wSMoMGKtoqungylLR1I81wpu
         ebZNU29LY7UfBQcx44ZQSPJmeu9e5XdUuqRCUtpYLXyTjERHkUWBW4SoRwJKQbWg+tTH
         hgRWBRDq6P2OlrStUx7aCVpaxBHAueqrpjuWA=
Date: Tue, 2 Dec 2008 13:14:42 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc7
Message-ID: <20081202131442.42e7df48@varda>
In-Reply-To: <alpine.LFD.2.00.0812012004370.3256@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0812012004370.3256@nehalem.linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Mon, 1 Dec 2008 20:11:55 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> escribió:

> 
> I was gone for a week, and it wasn't quite as quiet as I was hoping for, 
> but there's a new -rc out there now with the merges of the fallout.
> 
> Almost all of it is various driver fixes, at least if you ignore the 
> (bulky) powerpc defconfig updates. The bulk being ACPI, DRM, input and 
> V4L, but with a smattering of usb, networking, infiniband and firewire.
> 
> Oh, and a number of section warning fixes.
> 
> The shortlog is about as informative as it gets - it's all about a lot of 
> small details.
> 
> 		Linus
> 

 Just tried it on my Ubuntu 8.10 install.
 Booted fine and the distro got to its safe graphics mode because i'm
 evil and use the nvidia kernel module. i switch to VT1 and the fun
 begins something weird happens with the terminal...
 I can not see the login: not the password: promts 
 I log in blindly
 When i type a command nothing appears on screen i have to hit enter twice
 one make the command appear the second actually executes
 After that i have to hit enter once more to get the shell promt again
 Also I couldn't use sudo the password promt did not get my password
 
 All of this happens without the nvidia module loaded (not even compiled) 
 

 If i boot into single mode everything is ok 

 2.6.28-rc6-00007-ged31348 the first 28 series i tried does not have this
 problem

[    0.000000] BIOS EBDA/lowmem at: 0009fc00/0009fc00
[    0.000000] Linux version 2.6.28-rc7 (alex@varda) (gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu11) ) #2 SMP PREEMPT Tue Dec 2 12:48:19 CET 2008
[    0.000000] Command line: BOOT_IMAGE=(hd0,2)/vmlinuz-2.6.28-rc7 root=UUID=22b22080-8f07-4864-9b26-a62f2e8c96f7 ro single
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bffb0000 (usable)
[    0.000000]  BIOS-e820: 00000000bffb0000 - 00000000bffc0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bffc0000 - 00000000bfff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfff0000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff380000 - 0000000100000000 (reserved)
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working it around.
[    0.000000] last_pfn = 0xbffb0 max_arch_pfn = 0x3ffffffff
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] init_memory_mapping: 0000000000000000-00000000bffb0000
[    0.000000]  0000000000 - 00bfe00000 page 2M
[    0.000000]  00bfe00000 - 00bffb0000 page 4k
[    0.000000] kernel direct mapping tables up to bffb0000 @ 10000-15000
[    0.000000] last_map_addr: bffb0000 end: bffb0000
[    0.000000] RAMDISK: 37ba2000 - 37fef76d
[    0.000000] ACPI: RSDP 000F90F0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT BFFB0000, 0040 (r1 A M I  OEMRSDT   3000715 MSFT       97)
[    0.000000] ACPI: FACP BFFB0200, 0084 (r2 A M I  OEMFACP  12000601 MSFT       97)
[    0.000000] ACPI: DSDT BFFB0440, 4B5A (r1  AM2ES AM2ES136      136 INTL  2002026)
[    0.000000] ACPI: FACS BFFC0000, 0040
[    0.000000] ACPI: APIC BFFB0390, 0068 (r1 A M I  OEMAPIC   3000715 MSFT       97)
[    0.000000] ACPI: MCFG BFFB0400, 003C (r1 A M I  OEMMCFG   3000715 MSFT       97)
[    0.000000] ACPI: SSDT BFFB4FA0, 002B (r1 OEM_ID OEMTBLID        1 INTL  2002026)
[    0.000000] ACPI: OEMB BFFC0040, 0056 (r1 A M I  AMI_OEM   3000715 MSFT       97)
[    0.000000] ACPI: HPET BFFB4FD0, 0038 (r1 A M I  OEMHPET   3000715 MSFT       97)
[    0.000000] ACPI: SSDT BFFB5010, 01C4 (r1 A M I  POWERNOW        1 AMD         1)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (6 early reservations) ==> bootmem [0000000000 - 00bffb0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 00005d2718]    TEXT DATA BSS ==> [0000200000 - 00005d2718]
[    0.000000]   #3 [0037ba2000 - 0037fef76d]          RAMDISK ==> [0037ba2000 - 0037fef76d]
[    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #5 [0000010000 - 0000013000]          PGTABLE ==> [0000010000 - 0000013000]
[    0.000000]  [ffffe20000000000-ffffe200029fffff] PMD -> [ffff880001200000-ffff880003bfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000bffb0
[    0.000000] On node 0 totalpages: 786239
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1080 pages reserved
[    0.000000]   DMA zone: 2847 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 10695 pages used for memmap
[    0.000000]   DMA32 zone: 771561 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec10000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 3, version 0, address 0xfec10000, GSI 24-44
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] Allocating PCI resources starting at c4000000 (gap: c0000000:3f380000)
[    0.000000] PERCPU: Allocating 49152 bytes of per cpu data
[    0.000000] NR_CPUS: 2, nr_cpu_ids: 2, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 774408
[    0.000000] Kernel command line: BOOT_IMAGE=(hd0,2)/vmlinuz-2.6.28-rc7 root=UUID=22b22080-8f07-4864-9b26-a62f2e8c96f7 ro single
[    0.000000] Initializing CPU#0
[    0.000000] Preemptible RCU implementation.
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2000.010 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000999] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000999] Checking aperture...
[    0.000999] No AGP bridge found
[    0.000999] Node 0: aperture @ b56a000000 size 32 MB
[    0.000999] Aperture beyond 4GB. Ignoring.
[    0.000999] Memory: 3086548k/3145408k available (2146k kernel code, 452k absent, 57764k reserved, 1032k data, 328k init)
[    0.000999] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000999] hpet clockevent registered
[    0.000999] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.001009] Calibrating delay loop (skipped), value calculated using timer frequency.. 4000.02 BogoMIPS (lpj=2000010)
[    0.001138] Mount-cache hash table entries: 256
[    0.001319] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.001375] CPU: L2 Cache: 512K (64 bytes/line)
[    0.001428] tseg: 0000000000
[    0.001435] CPU: Physical Processor ID: 0
[    0.001487] CPU: Processor Core ID: 0
[    0.001546] using C1E aware idle routine
[    0.001610] ACPI: Core revision 20080926
[    0.007793] Setting APIC routing to flat
[    0.008556] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.018619] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[    0.018997] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 3999.75 BogoMIPS (lpj=1999877)
[    0.000999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.000999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.089385] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[    0.089897] Brought up 2 CPUs
[    0.089949] Total of 2 processors activated (7999.77 BogoMIPS).
[    0.090124] CPU0 attaching sched-domain:
[    0.090127]  domain 0: span 0-1 level CPU
[    0.090129]   groups: 0 1
[    0.090133] CPU1 attaching sched-domain:
[    0.090135]  domain 0: span 0-1 level CPU
[    0.090137]   groups: 1 0
[    0.090192] net_namespace: 1280 bytes
[    0.090272] NET: Registered protocol family 16
[    0.090343] node 0 link 0: io port [1000, ffffff]
[    0.090343] TOM: 00000000c0000000 aka 3072M
[    0.090988] node 0 link 0: mmio [e0000000, efffffff]
[    0.090992] node 0 link 0: mmio [a0000, bffff]
[    0.090994] node 0 link 0: mmio [c0000000, ffffffff]
[    0.090997] bus: [00,ff] on node 0 link 0
[    0.090999] bus: 00 index 0 io port: [0, ffff]
[    0.091001] bus: 00 index 1 mmio: [c0000000, fcffffffff]
[    0.091003] bus: 00 index 2 mmio: [a0000, bffff]
[    0.091009] ACPI: bus type pci registered
[    0.091070] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.091079] PCI: Not using MMCONFIG.
[    0.091131] PCI: Using configuration type 1 for base access
[    0.093665] ACPI: EC: Look up EC in DSDT
[    0.102499] ACPI: Interpreter enabled
[    0.102556] ACPI: (supports S0 S1 S3 S5)
[    0.102781] ACPI: Using IOAPIC for interrupt routing
[    0.102887] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.107417] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.117364] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.125095] ACPI: No dock devices found.
[    0.125207] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.126050] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.126106] pci 0000:00:01.0: PME# disabled
[    0.126183] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.126238] pci 0000:00:02.0: PME# disabled
[    0.126315] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.126370] pci 0000:00:03.0: PME# disabled
[    0.126446] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.126501] pci 0000:00:04.0: PME# disabled
[    0.126604] pci 0000:00:12.0: reg 10 io port: [0xc800-0xc8ff]
[    0.126609] pci 0000:00:12.0: reg 14 32bit mmio: [0xdbfefc00-0xdbfefcff]
[    0.126630] pci 0000:00:12.0: PME# supported from D3hot D3cold
[    0.126685] pci 0000:00:12.0: PME# disabled
[    0.126751] pci 0000:00:13.0: reg 10 32bit mmio: [0xdbfee000-0xdbfeefff]
[    0.126784] pci 0000:00:13.1: reg 10 32bit mmio: [0xdbfed000-0xdbfedfff]
[    0.126816] pci 0000:00:13.2: reg 10 32bit mmio: [0xdbfec000-0xdbfecfff]
[    0.126859] pci 0000:00:13.3: reg 10 32bit mmio: [0xdbfef800-0xdbfef8ff]
[    0.126882] pci 0000:00:13.3: PME# supported from D0 D3hot D3cold
[    0.126983] pci 0000:00:13.3: PME# disabled
[    0.127064] pci 0000:00:14.0: reg 10 64bit mmio: [0xdbfd4000-0xdbfd7fff]
[    0.127084] pci 0000:00:14.0: PME# supported from D0 D3hot D3cold
[    0.127140] pci 0000:00:14.0: PME# disabled
[    0.127279] pci 0000:00:15.1: quirk: region 4000-403f claimed by ali7101 ACPI
[    0.127375] pci 0000:00:16.0: reg 20 io port: [0xff00-0xff0f]
[    0.127408] pci 0000:00:16.1: reg 10 io port: [0xc400-0xc407]
[    0.127413] pci 0000:00:16.1: reg 14 io port: [0xc000-0xc003]
[    0.127418] pci 0000:00:16.1: reg 18 io port: [0xb800-0xb807]
[    0.127423] pci 0000:00:16.1: reg 1c io port: [0xb400-0xb403]
[    0.127428] pci 0000:00:16.1: reg 20 io port: [0xb000-0xb00f]
[    0.127433] pci 0000:00:16.1: reg 24 32bit mmio: [0xdbfef400-0xdbfef7ff]
[    0.127443] pci 0000:00:16.1: PME# supported from D3hot
[    0.127497] pci 0000:00:16.1: PME# disabled
[    0.127642] pci 0000:01:00.0: reg 10 32bit mmio: [0xdd000000-0xddffffff]
[    0.127650] pci 0000:01:00.0: reg 14 64bit mmio: [0xc0000000-0xcfffffff]
[    0.127658] pci 0000:01:00.0: reg 1c 64bit mmio: [0xdc000000-0xdcffffff]
[    0.127663] pci 0000:01:00.0: reg 24 io port: [0xd800-0xd87f]
[    0.127668] pci 0000:01:00.0: reg 30 32bit mmio: [0xdeee0000-0xdeefffff]
[    0.127697] pci 0000:00:01.0: bridge io port: [0xd000-0xdfff]
[    0.127700] pci 0000:00:01.0: bridge 32bit mmio: [0xdc000000-0xdeefffff]
[    0.127704] pci 0000:00:01.0: bridge 32bit mmio pref: [0xc0000000-0xcfffffff]
[    0.127726] pci 0000:00:02.0: bridge 32bit mmio pref: [0xdad00000-0xdadfffff]
[    0.127748] pci 0000:00:03.0: bridge 32bit mmio pref: [0xdae00000-0xdaefffff]
[    0.127770] pci 0000:00:04.0: bridge 32bit mmio pref: [0xdaf00000-0xdaffffff]
[    0.127810] pci 0000:05:0a.0: reg 10 32bit mmio: [0xdeffe000-0xdeffffff]
[    0.127870] pci 0000:05:0b.0: reg 10 io port: [0xe800-0xe8ff]
[    0.127877] pci 0000:05:0b.0: reg 14 32bit mmio: [0xdeffdc00-0xdeffdcff]
[    0.127899] pci 0000:05:0b.0: reg 30 32bit mmio: [0xdefc0000-0xdefdffff]
[    0.127908] pci 0000:05:0b.0: supports D1 D2
[    0.127910] pci 0000:05:0b.0: PME# supported from D1 D2 D3hot D3cold
[    0.127983] pci 0000:05:0b.0: PME# disabled
[    0.128062] pci 0000:05:0c.0: reg 10 32bit mmio: [0xdeffc000-0xdeffcfff]
[    0.128094] pci 0000:05:0c.0: PME# supported from D0 D1 D3hot D3cold
[    0.128150] pci 0000:05:0c.0: PME# disabled
[    0.128228] pci 0000:05:0c.1: reg 10 32bit mmio: [0xdeff3000-0xdeff3fff]
[    0.128260] pci 0000:05:0c.1: PME# supported from D0 D1 D3hot D3cold
[    0.128316] pci 0000:05:0c.1: PME# disabled
[    0.128395] pci 0000:05:0c.2: reg 10 32bit mmio: [0xdeff2000-0xdeff2fff]
[    0.128426] pci 0000:05:0c.2: PME# supported from D0 D1 D3hot D3cold
[    0.128482] pci 0000:05:0c.2: PME# disabled
[    0.128566] pci 0000:05:0c.3: reg 10 32bit mmio: [0xdeffd800-0xdeffd8ff]
[    0.128598] pci 0000:05:0c.3: PME# supported from D0 D3hot D3cold
[    0.128654] pci 0000:05:0c.3: PME# disabled
[    0.128737] pci 0000:00:11.0: bridge io port: [0xe000-0xefff]
[    0.128740] pci 0000:00:11.0: bridge 32bit mmio: [0xdef00000-0xdeffffff]
[    0.128754] bus 00 -> node 0
[    0.128760] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.128918] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE2P._PRT]
[    0.129106] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB1._PRT]
[    0.129208] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB2._PRT]
[    0.129310] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB3._PRT]
[    0.129412] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB4._PRT]
[    0.141133] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.141840] ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.142519] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.143236] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.143944] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.144640] ACPI: PCI Interrupt Link [LNKF] (IRQs 5 6 *10 11 12 14 15)
[    0.145236] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.145981] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.146687] ACPI: PCI Interrupt Link [LNKP] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.147272] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] - 52, should be 2D [20080926]
[    0.147272] SCSI subsystem initialized
[    0.147272] libata version 3.00 loaded.
[    0.148024] PCI: Using ACPI for IRQ routing
[    0.155096] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.155312] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.157986] Switched to high resolution mode on CPU 0
[    0.158321] Switched to high resolution mode on CPU 1
[    0.166014] pnp: PnP ACPI init
[    0.166074] ACPI: bus type pnp registered
[    0.171132] pnp: PnP ACPI: found 15 devices
[    0.171186] ACPI: ACPI bus type pnp unregistered
[    0.171248] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
[    0.171304] system 00:07: ioport range 0x4000-0x40bf could not be reserved
[    0.171360] system 00:07: ioport range 0x40c0-0x40df has been reserved
[    0.171415] system 00:07: ioport range 0x400-0x40f has been reserved
[    0.171470] system 00:07: ioport range 0x480-0x48f has been reserved
[    0.171526] system 00:07: iomem range 0xfff80000-0xffffffff has been reserved
[    0.171582] system 00:07: iomem range 0xfec10000-0xfec10fff has been reserved
[    0.171638] system 00:07: iomem range 0xfe000000-0xfe0000ff has been reserved
[    0.171697] system 00:09: iomem range 0xff380000-0xffffffff could not be reserved
[    0.171760] system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.171816] system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.171875] system 00:0c: ioport range 0x290-0x29f has been reserved
[    0.171932] system 00:0d: iomem range 0xe0000000-0xefffffff has been reserved
[    0.171991] system 00:0e: iomem range 0x0-0x9ffff could not be reserved
[    0.172056] system 00:0e: iomem range 0xc0000-0xcffff has been reserved
[    0.172112] system 00:0e: iomem range 0xe0000-0xfffff could not be reserved
[    0.176145] system 00:0e: iomem range 0x100000-0xbfffffff could not be reserved
[    0.181340] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.181396] pci 0000:00:01.0:   IO window: 0xd000-0xdfff
[    0.181451] pci 0000:00:01.0:   MEM window: 0xdc000000-0xdeefffff
[    0.181507] pci 0000:00:01.0:   PREFETCH window: 0x000000c0000000-0x000000cfffffff
[    0.181572] pci 0000:00:02.0: PCI bridge, secondary bus 0000:02
[    0.181626] pci 0000:00:02.0:   IO window: disabled
[    0.181680] pci 0000:00:02.0:   MEM window: disabled
[    0.181734] pci 0000:00:02.0:   PREFETCH window: 0x000000dad00000-0x000000dadfffff
[    0.181799] pci 0000:00:03.0: PCI bridge, secondary bus 0000:03
[    0.181853] pci 0000:00:03.0:   IO window: disabled
[    0.181907] pci 0000:00:03.0:   MEM window: disabled
[    0.181961] pci 0000:00:03.0:   PREFETCH window: 0x000000dae00000-0x000000daefffff
[    0.182034] pci 0000:00:04.0: PCI bridge, secondary bus 0000:04
[    0.182088] pci 0000:00:04.0:   IO window: disabled
[    0.182142] pci 0000:00:04.0:   MEM window: disabled
[    0.182196] pci 0000:00:04.0:   PREFETCH window: 0x000000daf00000-0x000000daffffff
[    0.182262] pci 0000:00:11.0: PCI bridge, secondary bus 0000:05
[    0.182317] pci 0000:00:11.0:   IO window: 0xe000-0xefff
[    0.182372] pci 0000:00:11.0:   MEM window: 0xdef00000-0xdeffffff
[    0.182428] pci 0000:00:11.0:   PREFETCH window: disabled
[    0.182491] pci 0000:00:01.0: PCI INT A -> GSI 29 (level, low) -> IRQ 29
[    0.182548] pci 0000:00:01.0: setting latency timer to 64
[    0.182554] pci 0000:00:02.0: PCI INT A -> GSI 34 (level, low) -> IRQ 34
[    0.182610] pci 0000:00:02.0: setting latency timer to 64
[    0.182615] pci 0000:00:03.0: PCI INT A -> GSI 39 (level, low) -> IRQ 39
[    0.182671] pci 0000:00:03.0: setting latency timer to 64
[    0.182677] pci 0000:00:04.0: PCI INT A -> GSI 44 (level, low) -> IRQ 44
[    0.182732] pci 0000:00:04.0: setting latency timer to 64
[    0.182737] pci 0000:00:11.0: setting latency timer to 64
[    0.182740] bus: 00 index 0 io port: [0x00-0xffff]
[    0.182794] bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
[    0.182848] bus: 01 index 0 io port: [0xd000-0xdfff]
[    0.182902] bus: 01 index 1 mmio: [0xdc000000-0xdeefffff]
[    0.182955] bus: 01 index 2 mmio: [0xc0000000-0xcfffffff]
[    0.183017] bus: 01 index 3 mmio: [0x0-0x0]
[    0.183070] bus: 02 index 0 mmio: [0x0-0x0]
[    0.183123] bus: 02 index 1 mmio: [0x0-0x0]
[    0.183175] bus: 02 index 2 mmio: [0xdad00000-0xdadfffff]
[    0.183229] bus: 02 index 3 mmio: [0x0-0x0]
[    0.183282] bus: 03 index 0 mmio: [0x0-0x0]
[    0.183334] bus: 03 index 1 mmio: [0x0-0x0]
[    0.183387] bus: 03 index 2 mmio: [0xdae00000-0xdaefffff]
[    0.183440] bus: 03 index 3 mmio: [0x0-0x0]
[    0.183493] bus: 04 index 0 mmio: [0x0-0x0]
[    0.183546] bus: 04 index 1 mmio: [0x0-0x0]
[    0.183598] bus: 04 index 2 mmio: [0xdaf00000-0xdaffffff]
[    0.183652] bus: 04 index 3 mmio: [0x0-0x0]
[    0.183704] bus: 05 index 0 io port: [0xe000-0xefff]
[    0.183758] bus: 05 index 1 mmio: [0xdef00000-0xdeffffff]
[    0.183811] bus: 05 index 2 mmio: [0x0-0x0]
[    0.183864] bus: 05 index 3 mmio: [0x0-0x0]
[    0.183928] NET: Registered protocol family 2
[    0.217067] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.218166] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.220833] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.221543] TCP: Hash tables configured (established 262144 bind 65536)
[    0.221600] TCP reno registered
[    0.233192] checking if image is initramfs... it is
[    0.569057] Freeing initrd memory: 4405k freed
[    0.576637] msgmni has been set to 6038
[    0.576811] io scheduler noop registered
[    0.576864] io scheduler anticipatory registered (default)
[    0.576929] pci 0000:00:00.0: Enabling HT MSI Mapping
[    0.576997] pci 0000:00:01.0: Enabling HT MSI Mapping
[    0.577070] pci 0000:00:02.0: Enabling HT MSI Mapping
[    0.577133] pci 0000:00:03.0: Enabling HT MSI Mapping
[    0.577196] pci 0000:00:04.0: Enabling HT MSI Mapping
[    0.610072] pci 0000:01:00.0: Boot video device
[    0.614749] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    0.614772] pcieport-driver 0000:00:01.0: found MSI capability
[    0.614842] pcieport-driver 0000:00:01.0: irq 319 for MSI/MSI-X
[    0.614849] pci_express 0000:00:01.0:pcie00: allocate port service
[    0.614890] pci_express 0000:00:01.0:pcie01: allocate port service
[    0.614927] pci_express 0000:00:01.0:pcie03: allocate port service
[    0.614995] pcieport-driver 0000:00:02.0: setting latency timer to 64
[    0.615025] pcieport-driver 0000:00:02.0: found MSI capability
[    0.615090] pcieport-driver 0000:00:02.0: irq 318 for MSI/MSI-X
[    0.615097] pci_express 0000:00:02.0:pcie00: allocate port service
[    0.615136] pci_express 0000:00:02.0:pcie01: allocate port service
[    0.615173] pci_express 0000:00:02.0:pcie03: allocate port service
[    0.615240] pcieport-driver 0000:00:03.0: setting latency timer to 64
[    0.615262] pcieport-driver 0000:00:03.0: found MSI capability
[    0.615326] pcieport-driver 0000:00:03.0: irq 317 for MSI/MSI-X
[    0.615333] pci_express 0000:00:03.0:pcie00: allocate port service
[    0.615373] pci_express 0000:00:03.0:pcie01: allocate port service
[    0.615410] pci_express 0000:00:03.0:pcie03: allocate port service
[    0.615476] pcieport-driver 0000:00:04.0: setting latency timer to 64
[    0.615497] pcieport-driver 0000:00:04.0: found MSI capability
[    0.615562] pcieport-driver 0000:00:04.0: irq 316 for MSI/MSI-X
[    0.615569] pci_express 0000:00:04.0:pcie00: allocate port service
[    0.615605] pci_express 0000:00:04.0:pcie01: allocate port service
[    0.615642] pci_express 0000:00:04.0:pcie03: allocate port service
[    0.618226] aer 0000:00:01.0:pcie01: service driver aer loaded
[    0.620682] aer 0000:00:02.0:pcie01: service driver aer loaded
[    0.623155] aer 0000:00:03.0:pcie01: service driver aer loaded
[    0.625622] aer 0000:00:04.0:pcie01: service driver aer loaded
[    0.629189] Linux agpgart interface v0.103
[    0.630969] brd: module loaded
[    0.631079] Driver 'sd' needs updating - please use bus_type methods
[    0.631201] ahci 0000:00:16.1: version 3.0
[    0.631216] ahci 0000:00:16.1: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    0.631363] ahci 0000:00:16.1: AHCI 0001.0000 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[    0.631427] ahci 0000:00:16.1: flags: ncq sntf ilck pm led clo pmp pio slum part 
[    0.631940] scsi0 : ahci
[    0.632178] scsi1 : ahci
[    0.632341] scsi2 : ahci
[    0.632500] scsi3 : ahci
[    0.632696] ata1: SATA max UDMA/133 abar m1024@0xdbfef400 port 0xdbfef500 irq 21
[    0.632760] ata2: SATA max UDMA/133 abar m1024@0xdbfef400 port 0xdbfef580 irq 21
[    0.632824] ata3: SATA max UDMA/133 abar m1024@0xdbfef400 port 0xdbfef600 irq 21
[    0.632888] ata4: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 21
[    0.937022] ata1: SATA link down (SStatus 0 SControl 300)
[    1.253020] ata2: SATA link down (SStatus 0 SControl 300)
[    1.569022] ata3: SATA link down (SStatus 0 SControl 300)
[    2.467041] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.508760] ata4.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
[    2.508816] ata4.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.567080] ata4.00: configured for UDMA/133
[    2.578046] isa bounce pool size: 16 pages
[    2.578152] scsi 3:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
[    2.578427] sd 3:0:0:0: [sda] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
[    2.578502] sd 3:0:0:0: [sda] Write Protect is off
[    2.578556] sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.578576] sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.578703] sd 3:0:0:0: [sda] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
[    2.578777] sd 3:0:0:0: [sda] Write Protect is off
[    2.578830] sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.578849] sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.578914]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    2.637604] sd 3:0:0:0: [sda] Attached SCSI disk
[    2.637791] pata_ali 0000:00:16.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    2.637983] scsi4 : pata_ali
[    2.638159] scsi5 : pata_ali
[    2.639978] ata5: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
[    2.640034] ata6: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
[    2.793518] ata5.01: ATA-7: Maxtor 6Y080L0, YAR41BW0, max UDMA/133
[    2.793573] ata5.01: 160086528 sectors, multi 16: LBA 
[    2.799459] ata5.01: configured for UDMA/133
[    2.964367] ata6.00: ATAPI: _NEC DVD_RW ND-3540A, 1.01, max UDMA/33
[    2.964437] ata6.00: WARNING: ATAPI DMA disabled for reliablity issues.  It can be enabled
[    2.964501] ata6.00: WARNING: via pata_ali.atapi_dma modparam or corresponding sysfs node.
[    2.970324] ata6.00: configured for UDMA/33
[    2.981080] scsi 4:0:1:0: Direct-Access     ATA      Maxtor 6Y080L0   YAR4 PQ: 0 ANSI: 5
[    2.981328] sd 4:0:1:0: [sdb] 160086528 512-byte hardware sectors: (81.9 GB/76.3 GiB)
[    2.981403] sd 4:0:1:0: [sdb] Write Protect is off
[    2.981457] sd 4:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    2.981477] sd 4:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.981609] sd 4:0:1:0: [sdb] 160086528 512-byte hardware sectors: (81.9 GB/76.3 GiB)
[    2.981682] sd 4:0:1:0: [sdb] Write Protect is off
[    2.981735] sd 4:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    2.981754] sd 4:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.981819]  sdb: sdb1 sdb2 sdb3
[    2.984267] sd 4:0:1:0: [sdb] Attached SCSI disk
[    2.985760] scsi 5:0:0:0: CD-ROM            _NEC     DVD_RW ND-3540A  1.01 PQ: 0 ANSI: 5
[    2.986114] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    2.986170] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    2.986681] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.986855] mice: PS/2 mouse device common for all mice
[    2.987032] rtc_cmos 00:02: RTC can wake from S4
[    2.987147] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    2.987230] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
[    2.987334] cpuidle: using governor ladder
[    2.987387] cpuidle: using governor menu
[    2.987902] TCP cubic registered
[    2.988089] registered taskstats version 1
[    2.988333] rtc_cmos 00:02: setting system clock to 2008-12-02 12:59:38 UTC (1228222778)
[    2.988431] Freeing unused kernel memory: 328k freed
[    2.988658] Write protecting the kernel read-only data: 2948k
[    3.005825] NET: Registered protocol family 1
[    3.016754] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    3.082720] fuse init (API version 7.10)
[    3.092525] ACPI: duty_cycle spans bit 4
[    3.092654] processor ACPI_CPU:00: registered as cooling_device0
[    3.092770] processor ACPI_CPU:01: registered as cooling_device1
[    3.216807] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    3.216887] r8169 0000:05:0b.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    3.216983] r8169 0000:05:0b.0: no PCI Express capability
[    3.217331] eth0: RTL8110s at 0xffffc200100e2c00, 00:4f:63:00:a4:73, XID 04000000 IRQ 19
[    3.223308] usbcore: registered new interface driver usbfs
[    3.223397] usbcore: registered new interface driver hub
[    3.223486] usbcore: registered new device driver usb
[    3.225487] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.225572] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    3.225657] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    3.225758] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 1
[    3.225857] ohci_hcd 0000:00:13.0: irq 17, io mem 0xdbfee000
[    3.228114] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.228171] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    3.250426] sd 3:0:0:0: Attached scsi generic sg0 type 0
[    3.250511] sd 4:0:1:0: Attached scsi generic sg1 type 0
[    3.250589] scsi 5:0:0:0: Attached scsi generic sg2 type 5
[    3.279126] usb usb1: configuration #1 chosen from 1 choice
[    3.279216] hub 1-0:1.0: USB hub found
[    3.279277] hub 1-0:1.0: 3 ports detected
[    3.279470] ehci_hcd 0000:00:13.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    3.279560] ehci_hcd 0000:00:13.3: EHCI Host Controller
[    3.279641] ehci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 2
[    3.301033] ehci_hcd 0000:00:13.3: debug port 1
[    3.301124] ehci_hcd 0000:00:13.3: irq 23, io mem 0xdbfef800
[    3.307024] ehci_hcd 0000:00:13.3: USB 2.0 started, EHCI 1.00
[    3.307179] usb usb2: configuration #1 chosen from 1 choice
[    3.307261] hub 2-0:1.0: USB hub found
[    3.307323] hub 2-0:1.0: 8 ports detected
[    3.307520] ehci_hcd 0000:05:0c.3: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    3.307609] ehci_hcd 0000:05:0c.3: EHCI Host Controller
[    3.307693] ehci_hcd 0000:05:0c.3: new USB bus registered, assigned bus number 3
[    3.307811] ohci_hcd 0000:00:13.1: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[    3.307875] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    3.307953] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 4
[    3.308091] ohci_hcd 0000:00:13.1: irq 18, io mem 0xdbfed000
[    3.324306] Driver 'sr' needs updating - please use bus_type methods
[    3.329050] ehci_hcd 0000:05:0c.3: debug port 1
[    3.329141] ehci_hcd 0000:05:0c.3: irq 20, io mem 0xdeffd800
[    3.331725] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[    3.331786] Uniform CD-ROM driver Revision: 3.20
[    3.331943] sr 5:0:0:0: Attached scsi CD-ROM sr0
[    3.337070] ehci_hcd 0000:05:0c.3: USB 2.0 started, EHCI 1.00
[    3.337229] usb usb3: configuration #1 chosen from 1 choice
[    3.337311] hub 3-0:1.0: USB hub found
[    3.337371] hub 3-0:1.0: 6 ports detected
[    3.361136] usb usb4: configuration #1 chosen from 1 choice
[    3.361223] hub 4-0:1.0: USB hub found
[    3.361284] hub 4-0:1.0: 3 ports detected
[    3.361450] ohci_hcd 0000:00:13.2: PCI INT C -> GSI 19 (level, low) -> IRQ 19
[    3.361542] ohci_hcd 0000:00:13.2: OHCI Host Controller
[    3.361626] ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 5
[    3.361728] ohci_hcd 0000:00:13.2: irq 19, io mem 0xdbfec000
[    3.415112] usb usb5: configuration #1 chosen from 1 choice
[    3.415201] hub 5-0:1.0: USB hub found
[    3.415261] hub 5-0:1.0: 3 ports detected
[    3.415431] ohci_hcd 0000:05:0c.0: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    3.415511] ohci_hcd 0000:05:0c.0: OHCI Host Controller
[    3.415593] ohci_hcd 0000:05:0c.0: new USB bus registered, assigned bus number 6
[    3.415678] ohci_hcd 0000:05:0c.0: irq 21, io mem 0xdeffc000
[    3.468113] usb usb6: configuration #1 chosen from 1 choice
[    3.468208] hub 6-0:1.0: USB hub found
[    3.468268] hub 6-0:1.0: 2 ports detected
[    3.468435] ohci_hcd 0000:05:0c.1: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    3.468514] ohci_hcd 0000:05:0c.1: OHCI Host Controller
[    3.468591] ohci_hcd 0000:05:0c.1: new USB bus registered, assigned bus number 7
[    3.468692] ohci_hcd 0000:05:0c.1: irq 22, io mem 0xdeff3000
[    3.521093] usb usb7: configuration #1 chosen from 1 choice
[    3.521173] hub 7-0:1.0: USB hub found
[    3.521233] hub 7-0:1.0: 2 ports detected
[    3.521389] ohci_hcd 0000:05:0c.2: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    3.521459] ohci_hcd 0000:05:0c.2: OHCI Host Controller
[    3.521534] ohci_hcd 0000:05:0c.2: new USB bus registered, assigned bus number 8
[    3.521614] ohci_hcd 0000:05:0c.2: irq 23, io mem 0xdeff2000
[    3.574112] usb usb8: configuration #1 chosen from 1 choice
[    3.574196] hub 8-0:1.0: USB hub found
[    3.574256] hub 8-0:1.0: 2 ports detected
[    3.658729] EXT3-fs: INFO: recovery required on readonly filesystem.
[    3.658786] EXT3-fs: write access will be enabled during recovery.
[    3.729385] kjournald starting.  Commit interval 5 seconds
[    3.729399] EXT3-fs: recovery complete.
[    3.729845] EXT3-fs: mounted filesystem with ordered data mode.
[    3.877029] usb 1-2: new low speed USB device using ohci_hcd and address 2
[    4.024112] usb 1-2: configuration #1 chosen from 1 choice
[    4.250020] usb 5-2: new full speed USB device using ohci_hcd and address 2
[    4.415112] usb 5-2: configuration #1 chosen from 1 choice
[    8.965997] udevd version 124 started
[    9.130213] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[    9.130324] uli526x 0000:00:12.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    9.152551] eth1: ULi M5263 at pci0000:00:12.0, 00:13:8f:b3:14:a4, irq 20.
[    9.174929] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    9.182281] ACPI: Power Button (FF) [PWRF]
[    9.182451] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[    9.190275] ACPI: Power Button (CM) [PWRB]
[    9.193299] cfg80211: Calling CRDA to update world regulatory domain
[    9.267773] rt2500pci 0000:05:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    9.281810] phy0: Selected rate control algorithm 'minstrel'
[    9.310100] parport_pc 00:05: reported by Plug and Play ACPI
[    9.310208] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
[    9.377576] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
[    9.377744] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    9.399421] 00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    9.409917] Registered led device: rt2500pci-phy0:radio
[    9.422525] usbcore: registered new interface driver hiddev
[    9.428362] input: KYE NetScroll+ Traveler as /devices/pci0000:00/0000:00:13.0/usb1/1-2/1-2:1.0/input/input3
[    9.436413] generic-usb 0003:0458:002E.0001: input,hidraw0: USB HID v1.10 Mouse [KYE NetScroll+ Traveler] on usb-0000:00:13.0-2/input0
[    9.436518] usbcore: registered new interface driver usbhid
[    9.436574] usbhid: v2.6:USB HID core driver
[    9.452151] usblp0: USB Bidirectional printer dev 2 if 0 alt 0 proto 2 vid 0x03F0 pid 0x1904
[    9.452246] usbcore: registered new interface driver usblp
[    9.563872] ali15x3_smbus 0000:00:15.1: ALI15X3_smb region uninitialized - upgrade BIOS or use force_addr=0xaddr
[    9.563943] ali15x3_smbus 0000:00:15.1: ALI15X3 not detected, module not inserted.
[    9.576530] ali1535_smbus 0000:00:15.1: ALI1535_smb region uninitialized - upgrade BIOS?
[    9.576598] ali1535_smbus 0000:00:15.1: ALI1535 not detected, module not inserted.
[    9.581271] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   10.163408] HDA Intel 0000:00:14.0: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[   10.173184] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
[   10.884035] lp0: using parport0 (interrupt-driven).
[   10.912954] w83627ehf: Found W83627EHG chip at 0x290
[   11.146354] Adding 1020116k swap on /dev/sdb2.  Priority:1 extents:1 across:1020116k
[   11.378979] EXT3 FS on sda3, internal journal
[   15.926364] kjournald starting.  Commit interval 5 seconds
[   15.926923] EXT3 FS on sda2, internal journal
[   15.926929] EXT3-fs: mounted filesystem with ordered data mode.
[   15.954559] JFS: nTxBlock = 8192, nTxLock = 65536
[   16.362700] ip_tables: (C) 2000-2006 Netfilter Core Team
[   17.276851] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   17.278129] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[   17.278132] nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
[   17.278135] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[  101.744347] nvidia: module license 'NVIDIA' taints kernel.
[  102.003828] nvidia 0000:01:00.0: PCI INT A -> GSI 25 (level, low) -> IRQ 25
[  102.003838] nvidia 0000:01:00.0: setting latency timer to 64
[  102.004747] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  180.06  Sat Nov  8 17:50:38 PST 2008


