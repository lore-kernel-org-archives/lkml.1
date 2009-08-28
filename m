Return-Path: <linux-kernel-owner+w=401wt.eu-S1751011AbZH1WsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751011AbZH1WsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 18:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750790AbZH1WsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 18:48:14 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:57319 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbZH1WsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 18:48:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=tQOW1GEDbm0D7PI2X9jwnLJJp9DsObOx4tE28WrY+pQF8fzjlAtBmD/jJdhFSFfMJ6
         Gk+Jcgfz++IhOHlmPsj9aFVLGL57JAyK9tT5LXXQLAPQ86Kd51UxCj3LJtvqcV7mGeBy
         qJtiqMeGs0ijDHnhESj66u33hDufa/Sf4Alrc=
Date: Sat, 29 Aug 2009 00:48:07 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.31-rc8
Message-ID: <20090829004807.4ca1e5d2@varda>
In-Reply-To: <alpine.LFD.2.01.0908271805210.3218@localhost.localdomain>
References: <alpine.LFD.2.01.0908271805210.3218@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Thu, 27 Aug 2009 18:24:09 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> escribió:

> 
> This should be the last -rc, and it's really been quieting down. There's 
> 131 commits there, and it's all pretty trivial. For example, in the 
> dirstat below, most of the arch/x86 changes are due to some vmlinux.lds.S 
> changes to fix problems with older binutils, not actual code changes. And 
> on powerpc, it's all the ps3 defconfig update.

[ ... ]

 This rc hangs during boot in this stage 
  
  Registered led device: rt2500pci-phy0::quality
 
 Last rc i tied is rc5 which booted fine.
 i attach the dmesg from a succesfull boot of 2.6.30 estable
 (yeah i know nvidia module crap and all that. rc5 and rc8 where tested without
 nvidia module)

> 
> I'll be gone for the next week, but it should be quiet. But pester the 
> usual suspects (aka "maintainers") about any bugs you see, and they'll fix 
> it while I'm diving. And then we'll have a final release for labor day.

 
[    0.000000] Linux version 2.6.30.5-00282-ga1e74cc (alex@varda) (gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) ) #25 SMP PREEMPT Mon Aug 17 13:09:08 CEST 2009
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.30.5-00282-ga1e74cc root=UUID=22b22080-8f07-4864-9b26-a62f2e8c96f7 ro quiet splash
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
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbffb0 max_arch_pfn = 0x100000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 base 0080000000 mask FFC0000000 write-back
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] init_memory_mapping: 0000000000000000-00000000bffb0000
[    0.000000]  0000000000 - 00bfe00000 page 2M
[    0.000000]  00bfe00000 - 00bffb0000 page 4k
[    0.000000] kernel direct mapping tables up to bffb0000 @ 10000-15000
[    0.000000] RAMDISK: 37b71000 - 37fefcb1
[    0.000000] ACPI: RSDP 00000000000f90f0 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 00000000bffb0000 00040 (v01 A M I  OEMRSDT  03000715 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bffb0200 00084 (v02 A M I  OEMFACP  12000601 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bffb0440 04B5A (v01  AM2ES AM2ES136 00000136 INTL 02002026)
[    0.000000] ACPI: FACS 00000000bffc0000 00040
[    0.000000] ACPI: APIC 00000000bffb0390 00068 (v01 A M I  OEMAPIC  03000715 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bffb0400 0003C (v01 A M I  OEMMCFG  03000715 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bffb4fa0 0002B (v01 OEM_ID OEMTBLID 00000001 INTL 02002026)
[    0.000000] ACPI: OEMB 00000000bffc0040 00056 (v01 A M I  AMI_OEM  03000715 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bffb4fd0 00038 (v01 A M I  OEMHPET  03000715 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bffb5010 001C4 (v01 A M I  POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 00bffb0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 0000623c0c]    TEXT DATA BSS ==> [0000200000 - 0000623c0c]
[    0.000000]   #3 [0037b71000 - 0037fefcb1]          RAMDISK ==> [0037b71000 - 0037fefcb1]
[    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #5 [0000624000 - 0000624123]              BRK ==> [0000624000 - 0000624123]
[    0.000000]   #6 [0000010000 - 0000013000]          PGTABLE ==> [0000010000 - 0000013000]
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
[    0.000000]   DMA zone: 1161 pages reserved
[    0.000000]   DMA zone: 2766 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 10695 pages used for memmap
[    0.000000]   DMA32 zone: 771561 pages, LIFO batch:31
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
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 45
[    0.000000] Allocating PCI resources starting at c4000000 (gap: c0000000:3f380000)
[    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages at ffff88000101c000, static data 70340 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 774327
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.30.5-00282-ga1e74cc root=UUID=22b22080-8f07-4864-9b26-a62f2e8c96f7 ro quiet splash
[    0.000000] Initializing CPU#0
[    0.000000] Preemptible RCU implementation.
[    0.000000] NR_IRQS:320
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2000.104 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000999] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000999] Checking aperture...
[    0.000999] No AGP bridge found
[    0.000999] Node 0: aperture @ b56a000000 size 32 MB
[    0.000999] Aperture beyond 4GB. Ignoring.
[    0.000999] Memory: 3085832k/3145408k available (2294k kernel code, 452k absent, 58392k reserved, 1080k data, 360k init)
[    0.000999] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000999] hpet clockevent registered
[    0.000999] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.001009] Calibrating delay loop (skipped), value calculated using timer frequency.. 4000.20 BogoMIPS (lpj=2000104)
[    0.001040] Mount-cache hash table entries: 256
[    0.001185] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.001188] CPU: L2 Cache: 512K (64 bytes/line)
[    0.001190] tseg: 0000000000
[    0.001201] CPU: Physical Processor ID: 0
[    0.001203] CPU: Processor Core ID: 0
[    0.001214] using C1E aware idle routine
[    0.001228] ACPI: Core revision 20090320
[    0.007045] Setting APIC routing to flat
[    0.007769] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.018077] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[    0.018997] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 3999.75 BogoMIPS (lpj=1999876)
[    0.000999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.000999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.089407] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[    0.089419] Brought up 2 CPUs
[    0.089422] Total of 2 processors activated (7999.96 BogoMIPS).
[    0.089561] CPU0 attaching sched-domain:
[    0.089565]  domain 0: span 0-1 level CPU
[    0.089567]   groups: 0 1
[    0.089572] CPU1 attaching sched-domain:
[    0.089574]  domain 0: span 0-1 level CPU
[    0.089577]   groups: 1 0
[    0.089635] net_namespace: 1720 bytes
[    0.090121] NET: Registered protocol family 16
[    0.090121] node 0 link 0: io port [1000, ffffff]
[    0.090121] TOM: 00000000c0000000 aka 3072M
[    0.090121] node 0 link 0: mmio [e0000000, efffffff]
[    0.090121] node 0 link 0: mmio [a0000, bffff]
[    0.090121] node 0 link 0: mmio [c0000000, ffffffff]
[    0.090121] bus: [00,ff] on node 0 link 0
[    0.090121] bus: 00 index 0 io port: [0, ffff]
[    0.090121] bus: 00 index 1 mmio: [c0000000, fcffffffff]
[    0.090121] bus: 00 index 2 mmio: [a0000, bffff]
[    0.090121] ACPI: bus type pci registered
[    0.090121] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.090121] PCI: Not using MMCONFIG.
[    0.090121] PCI: Using configuration type 1 for base access
[    0.092025] bio: create slab <bio-0> at 0
[    0.093474] ACPI: EC: Look up EC in DSDT
[    0.102354] ACPI: Interpreter enabled
[    0.102359] ACPI: (supports S0 S1 S3 S5)
[    0.102378] ACPI: Using IOAPIC for interrupt routing
[    0.102436] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.107576] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.112952] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.121103] ACPI Warning (tbutils-0246): Incorrect checksum in table [OEMB] - 52, should be 2D [20090320]
[    0.121188] ACPI: No dock devices found.
[    0.122056] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.122088] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.122088] pci 0000:00:01.0: PME# disabled
[    0.122105] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.122109] pci 0000:00:02.0: PME# disabled
[    0.122144] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.122147] pci 0000:00:03.0: PME# disabled
[    0.122182] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.122185] pci 0000:00:04.0: PME# disabled
[    0.122242] pci 0000:00:12.0: reg 10 io port: [0xc800-0xc8ff]
[    0.122248] pci 0000:00:12.0: reg 14 32bit mmio: [0xdbfefc00-0xdbfefcff]
[    0.122274] pci 0000:00:12.0: PME# supported from D3hot D3cold
[    0.122278] pci 0000:00:12.0: PME# disabled
[    0.122295] pci 0000:00:13.0: reg 10 32bit mmio: [0xdbfee000-0xdbfeefff]
[    0.122331] pci 0000:00:13.1: reg 10 32bit mmio: [0xdbfed000-0xdbfedfff]
[    0.122366] pci 0000:00:13.2: reg 10 32bit mmio: [0xdbfec000-0xdbfecfff]
[    0.122412] pci 0000:00:13.3: reg 10 32bit mmio: [0xdbfef800-0xdbfef8ff]
[    0.122444] pci 0000:00:13.3: PME# supported from D0 D3hot D3cold
[    0.122447] pci 0000:00:13.3: PME# disabled
[    0.122479] pci 0000:00:14.0: reg 10 64bit mmio: [0xdbfd4000-0xdbfd7fff]
[    0.122506] pci 0000:00:14.0: PME# supported from D0 D3hot D3cold
[    0.122509] pci 0000:00:14.0: PME# disabled
[    0.122600] pci 0000:00:15.1: quirk: region 4000-403f claimed by ali7101 ACPI
[    0.122645] pci 0000:00:16.0: reg 20 io port: [0xff00-0xff0f]
[    0.122685] pci 0000:00:16.1: reg 10 io port: [0xc400-0xc407]
[    0.122690] pci 0000:00:16.1: reg 14 io port: [0xc000-0xc003]
[    0.122696] pci 0000:00:16.1: reg 18 io port: [0xb800-0xb807]
[    0.122701] pci 0000:00:16.1: reg 1c io port: [0xb400-0xb403]
[    0.122707] pci 0000:00:16.1: reg 20 io port: [0xb000-0xb00f]
[    0.122712] pci 0000:00:16.1: reg 24 32bit mmio: [0xdbfef400-0xdbfef7ff]
[    0.122728] pci 0000:00:16.1: PME# supported from D3hot
[    0.122731] pci 0000:00:16.1: PME# disabled
[    0.122838] pci 0000:01:00.0: reg 10 32bit mmio: [0xdd000000-0xddffffff]
[    0.122847] pci 0000:01:00.0: reg 14 64bit mmio: [0xc0000000-0xcfffffff]
[    0.122855] pci 0000:01:00.0: reg 1c 64bit mmio: [0xdc000000-0xdcffffff]
[    0.122986] pci 0000:01:00.0: reg 24 io port: [0xd800-0xd87f]
[    0.122992] pci 0000:01:00.0: reg 30 32bit mmio: [0xdeee0000-0xdeefffff]
[    0.123034] pci 0000:00:01.0: bridge io port: [0xd000-0xdfff]
[    0.123038] pci 0000:00:01.0: bridge 32bit mmio: [0xdc000000-0xdeefffff]
[    0.123042] pci 0000:00:01.0: bridge 32bit mmio pref: [0xc0000000-0xcfffffff]
[    0.123067] pci 0000:00:02.0: bridge 32bit mmio pref: [0xdad00000-0xdadfffff]
[    0.123093] pci 0000:00:03.0: bridge 32bit mmio pref: [0xdae00000-0xdaefffff]
[    0.123118] pci 0000:00:04.0: bridge 32bit mmio pref: [0xdaf00000-0xdaffffff]
[    0.123161] pci 0000:05:0a.0: reg 10 32bit mmio: [0xdeffe000-0xdeffffff]
[    0.123231] pci 0000:05:0b.0: reg 10 io port: [0xe800-0xe8ff]
[    0.123238] pci 0000:05:0b.0: reg 14 32bit mmio: [0xdeffdc00-0xdeffdcff]
[    0.123261] pci 0000:05:0b.0: reg 30 32bit mmio: [0xdefc0000-0xdefdffff]
[    0.123278] pci 0000:05:0b.0: supports D1 D2
[    0.123280] pci 0000:05:0b.0: PME# supported from D1 D2 D3hot D3cold
[    0.123285] pci 0000:05:0b.0: PME# disabled
[    0.123314] pci 0000:05:0c.0: reg 10 32bit mmio: [0xdeffc000-0xdeffcfff]
[    0.123353] pci 0000:05:0c.0: PME# supported from D0 D1 D3hot D3cold
[    0.123357] pci 0000:05:0c.0: PME# disabled
[    0.123387] pci 0000:05:0c.1: reg 10 32bit mmio: [0xdeff3000-0xdeff3fff]
[    0.123425] pci 0000:05:0c.1: PME# supported from D0 D1 D3hot D3cold
[    0.123430] pci 0000:05:0c.1: PME# disabled
[    0.123459] pci 0000:05:0c.2: reg 10 32bit mmio: [0xdeff2000-0xdeff2fff]
[    0.123498] pci 0000:05:0c.2: PME# supported from D0 D1 D3hot D3cold
[    0.123502] pci 0000:05:0c.2: PME# disabled
[    0.123537] pci 0000:05:0c.3: reg 10 32bit mmio: [0xdeffd800-0xdeffd8ff]
[    0.123580] pci 0000:05:0c.3: PME# supported from D0 D3hot D3cold
[    0.123584] pci 0000:05:0c.3: PME# disabled
[    0.123619] pci 0000:00:11.0: bridge io port: [0xe000-0xefff]
[    0.123623] pci 0000:00:11.0: bridge 32bit mmio: [0xdef00000-0xdeffffff]
[    0.123638] pci_bus 0000:00: on NUMA node 0
[    0.123644] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.123739] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE2P._PRT]
[    0.123852] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB1._PRT]
[    0.123915] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB2._PRT]
[    0.123986] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB3._PRT]
[    0.124059] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB4._PRT]
[    0.137176] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.138134] ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.138332] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.138528] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.138727] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.138924] ACPI: PCI Interrupt Link [LNKF] (IRQs 5 6 *10 11 12 14 15)
[    0.139125] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.139322] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.139518] ACPI: PCI Interrupt Link [LNKP] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.139574] SCSI subsystem initialized
[    0.139574] libata version 3.00 loaded.
[    0.139998] PCI: Using ACPI for IRQ routing
[    0.148100] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.148106] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.151987] Switched to high resolution mode on CPU 0
[    0.152364] Switched to high resolution mode on CPU 1
[    0.160012] pnp: PnP ACPI init
[    0.160021] ACPI: bus type pnp registered
[    0.165382] pnp: PnP ACPI: found 15 devices
[    0.165384] ACPI: ACPI bus type pnp unregistered
[    0.165398] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
[    0.165402] system 00:07: ioport range 0x4000-0x40bf could not be reserved
[    0.165405] system 00:07: ioport range 0x40c0-0x40df has been reserved
[    0.165408] system 00:07: ioport range 0x400-0x40f has been reserved
[    0.165412] system 00:07: ioport range 0x480-0x48f has been reserved
[    0.165416] system 00:07: iomem range 0xfff80000-0xffffffff has been reserved
[    0.165419] system 00:07: iomem range 0xfec10000-0xfec10fff could not be reserved
[    0.165423] system 00:07: iomem range 0xfe000000-0xfe0000ff has been reserved
[    0.165429] system 00:09: iomem range 0xff380000-0xffffffff could not be reserved
[    0.165433] system 00:09: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.165436] system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.165443] system 00:0c: ioport range 0x290-0x29f has been reserved
[    0.165449] system 00:0d: iomem range 0xe0000000-0xefffffff has been reserved
[    0.165455] system 00:0e: iomem range 0x0-0x9ffff could not be reserved
[    0.165459] system 00:0e: iomem range 0xc0000-0xcffff has been reserved
[    0.165462] system 00:0e: iomem range 0xe0000-0xfffff could not be reserved
[    0.165465] system 00:0e: iomem range 0x100000-0xbfffffff could not be reserved
[    0.170470] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.170473] pci 0000:00:01.0:   IO window: 0xd000-0xdfff
[    0.170478] pci 0000:00:01.0:   MEM window: 0xdc000000-0xdeefffff
[    0.170481] pci 0000:00:01.0:   PREFETCH window: 0x000000c0000000-0x000000cfffffff
[    0.170486] pci 0000:00:02.0: PCI bridge, secondary bus 0000:02
[    0.170488] pci 0000:00:02.0:   IO window: disabled
[    0.170491] pci 0000:00:02.0:   MEM window: disabled
[    0.170494] pci 0000:00:02.0:   PREFETCH window: 0x000000dad00000-0x000000dadfffff
[    0.170499] pci 0000:00:03.0: PCI bridge, secondary bus 0000:03
[    0.170501] pci 0000:00:03.0:   IO window: disabled
[    0.170504] pci 0000:00:03.0:   MEM window: disabled
[    0.170507] pci 0000:00:03.0:   PREFETCH window: 0x000000dae00000-0x000000daefffff
[    0.170512] pci 0000:00:04.0: PCI bridge, secondary bus 0000:04
[    0.170514] pci 0000:00:04.0:   IO window: disabled
[    0.170517] pci 0000:00:04.0:   MEM window: disabled
[    0.170520] pci 0000:00:04.0:   PREFETCH window: 0x000000daf00000-0x000000daffffff
[    0.170525] pci 0000:00:11.0: PCI bridge, secondary bus 0000:05
[    0.170529] pci 0000:00:11.0:   IO window: 0xe000-0xefff
[    0.170533] pci 0000:00:11.0:   MEM window: 0xdef00000-0xdeffffff
[    0.170536] pci 0000:00:11.0:   PREFETCH window: disabled
[    0.170549] pci 0000:00:01.0: PCI INT A -> GSI 29 (level, low) -> IRQ 29
[    0.170553] pci 0000:00:01.0: setting latency timer to 64
[    0.170560] pci 0000:00:02.0: PCI INT A -> GSI 34 (level, low) -> IRQ 34
[    0.170563] pci 0000:00:02.0: setting latency timer to 64
[    0.170569] pci 0000:00:03.0: PCI INT A -> GSI 39 (level, low) -> IRQ 39
[    0.170573] pci 0000:00:03.0: setting latency timer to 64
[    0.170579] pci 0000:00:04.0: PCI INT A -> GSI 44 (level, low) -> IRQ 44
[    0.170582] pci 0000:00:04.0: setting latency timer to 64
[    0.170587] pci 0000:00:11.0: setting latency timer to 64
[    0.170592] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.170595] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.170598] pci_bus 0000:01: resource 0 io:  [0xd000-0xdfff]
[    0.170601] pci_bus 0000:01: resource 1 mem: [0xdc000000-0xdeefffff]
[    0.170604] pci_bus 0000:01: resource 2 pref mem [0xc0000000-0xcfffffff]
[    0.170607] pci_bus 0000:02: resource 2 pref mem [0xdad00000-0xdadfffff]
[    0.170610] pci_bus 0000:03: resource 2 pref mem [0xdae00000-0xdaefffff]
[    0.170613] pci_bus 0000:04: resource 2 pref mem [0xdaf00000-0xdaffffff]
[    0.170617] pci_bus 0000:05: resource 0 io:  [0xe000-0xefff]
[    0.170619] pci_bus 0000:05: resource 1 mem: [0xdef00000-0xdeffffff]
[    0.170655] NET: Registered protocol family 2
[    0.197078] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.198182] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.200817] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.201457] TCP: Hash tables configured (established 262144 bind 65536)
[    0.201460] TCP reno registered
[    0.213099] NET: Registered protocol family 1
[    0.213163] Trying to unpack rootfs image as initramfs...
[    0.384116] Freeing initrd memory: 4603k freed
[    0.391873] VFS: Disk quotas dquot_6.5.2
[    0.391987] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.392455] msgmni has been set to 6037
[    0.392587] io scheduler noop registered
[    0.392599] io scheduler cfq registered (default)
[    0.392621] pci 0000:00:00.0: Enabling HT MSI Mapping
[    0.392644] pci 0000:00:01.0: Enabling HT MSI Mapping
[    0.392663] pci 0000:00:02.0: Enabling HT MSI Mapping
[    0.392682] pci 0000:00:03.0: Enabling HT MSI Mapping
[    0.392700] pci 0000:00:04.0: Enabling HT MSI Mapping
[    0.426057] pci 0000:01:00.0: Boot video device
[    0.426264] pcieport-driver 0000:00:01.0: irq 45 for MSI/MSI-X
[    0.426272] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    0.426480] pcieport-driver 0000:00:02.0: irq 46 for MSI/MSI-X
[    0.426487] pcieport-driver 0000:00:02.0: setting latency timer to 64
[    0.426703] pcieport-driver 0000:00:03.0: irq 47 for MSI/MSI-X
[    0.426711] pcieport-driver 0000:00:03.0: setting latency timer to 64
[    0.426918] pcieport-driver 0000:00:04.0: irq 48 for MSI/MSI-X
[    0.426925] pcieport-driver 0000:00:04.0: setting latency timer to 64
[    0.427379] aer 0000:00:01.0:pcie02: service driver aer loaded
[    0.427409] aer 0000:00:02.0:pcie02: service driver aer loaded
[    0.427438] aer 0000:00:03.0:pcie02: service driver aer loaded
[    0.427467] aer 0000:00:04.0:pcie02: service driver aer loaded
[    0.431710] Linux agpgart interface v0.103
[    0.433882] brd: module loaded
[    0.433934] Driver 'sd' needs updating - please use bus_type methods
[    0.434014] ahci 0000:00:16.1: version 3.0
[    0.434031] ahci 0000:00:16.1: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    0.434127] ahci 0000:00:16.1: AHCI 0001.0000 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[    0.434131] ahci 0000:00:16.1: flags: ncq sntf ilck pm led clo pmp pio slum part 
[    0.434588] scsi0 : ahci
[    0.434777] scsi1 : ahci
[    0.434905] scsi2 : ahci
[    0.435049] scsi3 : ahci
[    0.435222] ata1: SATA max UDMA/133 abar m1024@0xdbfef400 port 0xdbfef500 irq 21
[    0.435226] ata2: SATA max UDMA/133 abar m1024@0xdbfef400 port 0xdbfef580 irq 21
[    0.435230] ata3: SATA max UDMA/133 abar m1024@0xdbfef400 port 0xdbfef600 irq 21
[    0.435233] ata4: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 21
[    0.435358] pata_ali 0000:00:16.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    0.435497] scsi4 : pata_ali
[    0.435640] scsi5 : pata_ali
[    0.437759] ata5: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
[    0.437763] ata6: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
[    0.437933] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.437935] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    0.438490] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.438667] mice: PS/2 mouse device common for all mice
[    0.438795] rtc_cmos 00:02: RTC can wake from S4
[    0.438865] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    0.438897] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
[    0.438938] cpuidle: using governor ladder
[    0.438941] cpuidle: using governor menu
[    0.439399] TCP cubic registered
[    0.439585] registered taskstats version 1
[    0.439780] rtc_cmos 00:02: setting system clock to 2009-08-28 21:04:21 UTC (1251493461)
[    0.465383] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.592453] ata5.01: ATA-7: Maxtor 6Y080L0, YAR41BW0, max UDMA/133
[    0.592456] ata5.01: 160086528 sectors, multi 16: LBA 
[    0.598368] ata5.01: configured for UDMA/133
[    0.740024] ata2: SATA link down (SStatus 0 SControl 300)
[    0.740040] ata3: SATA link down (SStatus 0 SControl 300)
[    0.893022] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    0.933702] ata1.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
[    0.933705] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    0.992029] ata1.00: configured for UDMA/133
[    1.003355] scsi 0:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
[    1.003669] sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
[    1.003684] sd 0:0:0:0: [sda] Write Protect is off
[    1.003687] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.003708] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.003795]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    1.062481] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.311040] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.337871] ata4.00: ATA-8: ST3500418AS, CC34, max UDMA/133
[    1.337874] ata4.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.377260] ata4.00: configured for UDMA/133
[    1.388079] scsi 3:0:0:0: Direct-Access     ATA      ST3500418AS      CC34 PQ: 0 ANSI: 5
[    1.388348] scsi 4:0:1:0: Direct-Access     ATA      Maxtor 6Y080L0   YAR4 PQ: 0 ANSI: 5
[    1.388352] sd 3:0:0:0: [sdb] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
[    1.388367] sd 3:0:0:0: [sdb] Write Protect is off
[    1.388370] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.388390] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.388484]  sdb:<5>sd 4:0:1:0: [sdc] 160086528 512-byte hardware sectors: (81.9 GB/76.3 GiB)
[    1.388745] sd 4:0:1:0: [sdc] Write Protect is off
[    1.388748] sd 4:0:1:0: [sdc] Mode Sense: 00 3a 00 00
[    1.388766] sd 4:0:1:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.388841]  sdc: sdb1 sdb2 sdb3 sdb4 < sdc1 sdc2 sdc3
[    1.396239] sd 4:0:1:0: [sdc] Attached SCSI disk
[    1.402691]  sdb5 sdb6 >
[    1.416862] sd 3:0:0:0: [sdb] Attached SCSI disk
[    1.542306] ata6.00: ATAPI: _NEC DVD_RW ND-3540A, 1.01, max UDMA/33
[    1.542329] ata6.00: WARNING: ATAPI DMA disabled for reliablity issues.  It can be enabled
[    1.542332] ata6.00: WARNING: via pata_ali.atapi_dma modparam or corresponding sysfs node.
[    1.548236] ata6.00: configured for UDMA/33
[    1.549566] scsi 5:0:0:0: CD-ROM            _NEC     DVD_RW ND-3540A  1.01 PQ: 0 ANSI: 5
[    1.549764] Freeing unused kernel memory: 360k freed
[    1.549937] Write protecting the kernel read-only data: 3156k
[    1.654747] fuse init (API version 7.11)
[    1.844933] usbcore: registered new interface driver usbfs
[    1.844972] usbcore: registered new interface driver hub
[    1.845002] usbcore: registered new device driver usb
[    1.846677] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.846714] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.846735] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    1.846791] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 1
[    1.846834] ohci_hcd 0000:00:13.0: irq 17, io mem 0xdbfee000
[    1.850527] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.850530] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    1.895443] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.895476] r8169 0000:05:0b.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.895508] r8169 0000:05:0b.0: no PCI Express capability
[    1.895813] eth0: RTL8110s at 0xffffc20000064c00, 00:4f:63:00:a4:73, XID 04000000 IRQ 19
[    1.899405] usb usb1: configuration #1 chosen from 1 choice
[    1.899442] hub 1-0:1.0: USB hub found
[    1.899453] hub 1-0:1.0: 3 ports detected
[    1.899594] ehci_hcd 0000:00:13.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    1.899608] ehci_hcd 0000:00:13.3: EHCI Host Controller
[    1.899635] ehci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 2
[    1.920276] ehci_hcd 0000:00:13.3: debug port 1
[    1.920318] ehci_hcd 0000:00:13.3: irq 23, io mem 0xdbfef800
[    1.926304] ehci_hcd 0000:00:13.3: USB 2.0 started, EHCI 1.00
[    1.926418] usb usb2: configuration #1 chosen from 1 choice
[    1.926453] hub 2-0:1.0: USB hub found
[    1.926464] hub 2-0:1.0: 8 ports detected
[    1.926615] ohci_hcd 0000:00:13.1: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[    1.926639] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    1.926668] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
[    1.926710] ohci_hcd 0000:00:13.1: irq 18, io mem 0xdbfed000
[    1.930038] ehci_hcd 0000:05:0c.3: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.930063] ehci_hcd 0000:05:0c.3: EHCI Host Controller
[    1.930109] ehci_hcd 0000:05:0c.3: new USB bus registered, assigned bus number 4
[    1.941667] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.941703] sd 3:0:0:0: Attached scsi generic sg1 type 0
[    1.941743] sd 4:0:1:0: Attached scsi generic sg2 type 0
[    1.941774] scsi 5:0:0:0: Attached scsi generic sg3 type 5
[    1.950287] ehci_hcd 0000:05:0c.3: debug port 1
[    1.950329] ehci_hcd 0000:05:0c.3: irq 20, io mem 0xdeffd800
[    1.956279] ehci_hcd 0000:05:0c.3: USB 2.0 started, EHCI 1.00
[    1.956399] usb usb4: configuration #1 chosen from 1 choice
[    1.956436] hub 4-0:1.0: USB hub found
[    1.956446] hub 4-0:1.0: 6 ports detected
[    1.969386] Driver 'sr' needs updating - please use bus_type methods
[    1.972383] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[    1.972388] Uniform CD-ROM driver Revision: 3.20
[    1.972503] sr 5:0:0:0: Attached scsi CD-ROM sr0
[    1.979378] usb usb3: configuration #1 chosen from 1 choice
[    1.979411] hub 3-0:1.0: USB hub found
[    1.979423] hub 3-0:1.0: 3 ports detected
[    1.979542] ohci_hcd 0000:00:13.2: PCI INT C -> GSI 19 (level, low) -> IRQ 19
[    1.979564] ohci_hcd 0000:00:13.2: OHCI Host Controller
[    1.979595] ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 5
[    1.979636] ohci_hcd 0000:00:13.2: irq 19, io mem 0xdbfec000
[    2.032415] usb usb5: configuration #1 chosen from 1 choice
[    2.032454] hub 5-0:1.0: USB hub found
[    2.032465] hub 5-0:1.0: 3 ports detected
[    2.032596] ohci_hcd 0000:05:0c.0: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    2.032622] ohci_hcd 0000:05:0c.0: OHCI Host Controller
[    2.032650] ohci_hcd 0000:05:0c.0: new USB bus registered, assigned bus number 6
[    2.032676] ohci_hcd 0000:05:0c.0: irq 21, io mem 0xdeffc000
[    2.085373] usb usb6: configuration #1 chosen from 1 choice
[    2.085413] hub 6-0:1.0: USB hub found
[    2.085425] hub 6-0:1.0: 2 ports detected
[    2.085561] ohci_hcd 0000:05:0c.1: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    2.085586] ohci_hcd 0000:05:0c.1: OHCI Host Controller
[    2.085615] ohci_hcd 0000:05:0c.1: new USB bus registered, assigned bus number 7
[    2.085661] ohci_hcd 0000:05:0c.1: irq 22, io mem 0xdeff3000
[    2.138377] usb usb7: configuration #1 chosen from 1 choice
[    2.138412] hub 7-0:1.0: USB hub found
[    2.138424] hub 7-0:1.0: 2 ports detected
[    2.138560] ohci_hcd 0000:05:0c.2: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    2.138587] ohci_hcd 0000:05:0c.2: OHCI Host Controller
[    2.138616] ohci_hcd 0000:05:0c.2: new USB bus registered, assigned bus number 8
[    2.138641] ohci_hcd 0000:05:0c.2: irq 23, io mem 0xdeff2000
[    2.191455] usb usb8: configuration #1 chosen from 1 choice
[    2.191490] hub 8-0:1.0: USB hub found
[    2.191502] hub 8-0:1.0: 2 ports detected
[    2.394276] usb 1-2: new low speed USB device using ohci_hcd and address 2
[    2.456553] kjournald starting.  Commit interval 5 seconds
[    2.456563] EXT3-fs: mounted filesystem with writeback data mode.
[    2.540415] usb 1-2: configuration #1 chosen from 1 choice
[    2.652272] usb 4-6: new high speed USB device using ehci_hcd and address 2
[    2.768739] usb 4-6: configuration #1 chosen from 1 choice
[    7.230839] udev: starting version 141
[    7.455690] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    7.455699] ACPI: Power Button [PWRF]
[    7.455794] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[    7.455798] ACPI: Power Button [PWRB]
[    7.514350] ACPI: duty_cycle spans bit 4
[    7.514403] processor ACPI_CPU:00: registered as cooling_device0
[    7.514453] processor ACPI_CPU:01: registered as cooling_device1
[    7.673642] parport_pc 00:05: reported by Plug and Play ACPI
[    7.673696] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
[    7.725688] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[    7.725724] uli526x 0000:00:12.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    7.751681] eth1: ULi M5263 at pci0000:00:12.0, 00:13:8f:b3:14:a4, irq 20.
[    7.782478] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    7.782601] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    7.987380] usblp0: USB Bidirectional printer dev 2 if 0 alt 0 proto 2 vid 0x03F0 pid 0x8904
[    7.987404] usbcore: registered new interface driver usblp
[    8.137922] usbcore: registered new interface driver hiddev
[    8.143629] input: KYE NetScroll+ Traveler as /devices/pci0000:00/0000:00:13.0/usb1/1-2/1-2:1.0/input/input3
[    8.143703] generic-usb 0003:0458:002E.0001: input,hidraw0: USB HID v1.10 Mouse [KYE NetScroll+ Traveler] on usb-0000:00:13.0-2/input0
[    8.143727] usbcore: registered new interface driver usbhid
[    8.143731] usbhid: v2.6:USB HID core driver
[    8.166231] k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
[    8.243343] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    8.302310] 00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    8.423495] ali1535_smbus 0000:00:15.1: ALI1535_smb region uninitialized - upgrade BIOS?
[    8.423499] ali1535_smbus 0000:00:15.1: ALI1535 not detected, module not inserted.
[    8.460417] ali15x3_smbus 0000:00:15.1: ALI15X3_smb region uninitialized - upgrade BIOS or use force_addr=0xaddr
[    8.460422] ali15x3_smbus 0000:00:15.1: ALI15X3 not detected, module not inserted.
[    8.715124] nvidia: module license 'NVIDIA' taints kernel.
[    8.715129] Disabling lock debugging due to kernel taint
[    8.770329] cfg80211: Calling CRDA to update world regulatory domain
[    8.900408] cfg80211: World regulatory domain updated:
[    8.900413] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    8.900416] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.900419] 	(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    8.900422] 	(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    8.900425] 	(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.900428] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.961417] HDA Intel 0000:00:14.0: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    8.990841] rt2500pci 0000:05:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    9.018168] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
[    9.055995] nvidia 0000:01:00.0: PCI INT A -> GSI 25 (level, low) -> IRQ 25
[    9.056005] nvidia 0000:01:00.0: setting latency timer to 64
[    9.056592] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  185.18.31  Tue Jul 28 17:52:27 PDT 2009
[    9.158078] phy0: Selected rate control algorithm 'minstrel'
[    9.158438] Registered led device: rt2500pci-phy0::radio
[    9.158459] Registered led device: rt2500pci-phy0::quality
[    9.272189] lp0: using parport0 (interrupt-driven).
[    9.303038] w83627ehf: Found W83627EHG chip at 0x290
[    9.513034] Adding 1020116k swap on /dev/sdc2.  Priority:1 extents:1 across:1020116k 
[   10.055334] EXT3 FS on sda3, internal journal
[   10.969296] kjournald starting.  Commit interval 5 seconds
[   10.969602] EXT3 FS on sda2, internal journal
[   10.969607] EXT3-fs: mounted filesystem with writeback data mode.
[   11.002078] JFS: nTxBlock = 8192, nTxLock = 65536
[   11.202868] EXT4-fs: barriers enabled
[   11.203072] kjournald2 starting: pid 2589, dev sdb6:8, commit interval 5 seconds
[   11.203265] EXT4 FS on sdb6, internal journal on sdb6:8
[   11.203268] EXT4-fs: delayed allocation enabled
[   11.203270] EXT4-fs: file extents enabled
[   11.241457] EXT4-fs: mballoc enabled
[   11.241475] EXT4-fs: mounted filesystem sdb6 with ordered data mode
[   11.335074] Btrfs loaded
[   11.350767] device label btrfs devid 1 transid 1010 /dev/sdc1
[   12.235460] ip_tables: (C) 2000-2006 Netfilter Core Team
[   12.890156] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   12.891117] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[   12.891121] nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
[   12.891124] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   13.772240] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ processors (2 cpu cores) (version 2.20.00)
[   13.772317] powernow-k8:    0 : fid 0xc (2000 MHz), vid 0xa
[   13.772321] powernow-k8:    1 : fid 0xa (1800 MHz), vid 0xc
[   13.772324] powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
[   15.016217] NET: Registered protocol family 10
[   15.016964] lo: Disabled Privacy Extensions
[   15.500022] Clocksource tsc unstable (delta = -86440539 ns)
[   15.871867] virbr0: starting userspace STP failed, starting kernel STP
[   18.994570] Bluetooth: Core ver 2.15
[   18.996485] NET: Registered protocol family 31
[   18.996492] Bluetooth: HCI device and connection manager initialized
[   18.996499] Bluetooth: HCI socket layer initialized
[   19.011652] Bluetooth: L2CAP ver 2.13
[   19.011658] Bluetooth: L2CAP socket layer initialized
[   19.030709] Bluetooth: RFCOMM socket layer initialized
[   19.030728] Bluetooth: RFCOMM TTY layer initialized
[   19.030732] Bluetooth: RFCOMM ver 1.11
[   24.945703] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   24.957057] r8169: eth0: link down
[   24.957089] r8169: eth0: link down
[   24.958578] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   24.980298] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   25.028221] NET: Registered protocol family 17
[   26.070022] virbr0: no IPv6 routers present
[   27.943725] uli526x: eth1 NIC Link is Down
[  203.046491] wlan0: authenticate with AP 00:80:5a:31:90:db
[  203.047719] wlan0: authenticated
[  203.047724] wlan0: associate with AP 00:80:5a:31:90:db
[  203.050813] wlan0: RX AssocResp from 00:80:5a:31:90:db (capab=0x471 status=0 aid=1)
[  203.050820] wlan0: associated
[  203.052920] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  213.286258] wlan0: no IPv6 routers present


 
> 			Linus
> 

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
