Return-Path: <linux-kernel-owner+w=401wt.eu-S1759989AbZCRSOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989AbZCRSOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 14:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758214AbZCRSNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 14:13:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:59313 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759897AbZCRSNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 14:13:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,385,1233561600"; 
   d="scan'208";a="395583174"
Subject: Re: Error: freeing invalid memtype
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <49C03208.6050603@gmail.com>
References: <49C03208.6050603@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Mar 2009 11:12:18 -0700
Message-Id: <1237399938.4529.208.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Kevin,

Can you please send me the output of
# cat /debug/x86/pat_memtype_list

(with debugfs mounted at /debug) as soon as you login into X and also
when you start seeing these errors with etracer and glxinfo.

Thanks,
Venki

On Tue, 2009-03-17 at 16:28 -0700, Kevin Winchester wrote:
> (I am not sure if this is an graphics or a memory mapping problem, so
> I am sending it to both maintainers)
> 
> For some reason, I get many of the above messages in my dmesg whenever
> I try to do anything graphical on my workstation.
> 
> My full dmesg is below.  As well, tuxracer only gives 4 fps, which I
> assume is not as high as it should be.
> 
> Any ideas?  Should I try linux-next? or tip?
> 
> --
> Kevin Winchester
> 
> 
> [    0.000000] Linux version 2.6.29-rc8-00124-g5bee17f (kevin@winchester) (gcc version 4.1.2 (Gentoo 4.1.2 p1.1)) #259 Mon Mar 16 15:34:42 ADT 2009
> [    0.000000] Command line: root=/dev/sda1 hpet=force fastboot
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   AMD AuthenticAMD
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000ce000 - 00000000000d8000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 000000004fff0000 (usable)
> [    0.000000]  BIOS-e820: 000000004fff0000 - 000000004fff8000 (ACPI data)
> [    0.000000]  BIOS-e820: 000000004fff8000 - 0000000050000000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
> [    0.000000] DMI 2.3 present.
> [    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
> [    0.000000] last_pfn = 0x4fff0 max_arch_pfn = 0x100000000
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] init_memory_mapping: 0000000000000000-000000004fff0000
> [    0.000000]  0000000000 - 004fe00000 page 2M
> [    0.000000]  004fe00000 - 004fff0000 page 4k
> [    0.000000] kernel direct mapping tables up to 4fff0000 @ 10000-14000
> [    0.000000] last_map_addr: 4fff0000 end: 4fff0000
> [    0.000000] ACPI: RSDP 000FA0C0, 0014 (r0 AMI   )
> [    0.000000] ACPI: RSDT 4FFF0000, 002C (r1 AMIINT VIA_K8         10 MSFT       97)
> [    0.000000] ACPI: FACP 4FFF0030, 0081 (r1 AMIINT VIA_K8         11 MSFT       97)
> [    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
> [    0.000000] ACPI: DSDT 4FFF0120, 36C5 (r1    VIA   VIA_K8     1000 MSFT  100000D)
> [    0.000000] ACPI: FACS 4FFF8000, 0040
> [    0.000000] ACPI: APIC 4FFF00C0, 0054 (r1 AMIINT VIA_K8          9 MSFT       97)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] (5 early reservations) ==> bootmem [0000000000 - 004fff0000]
> [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
> [    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
> [    0.000000]   #2 [0000200000 - 000072cc10]    TEXT DATA BSS ==> [0000200000 - 000072cc10]
> [    0.000000]   #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
> [    0.000000]   #4 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
> [    0.000000] found SMP MP-table at [ffff8800000fba70] 000fba70
> [    0.000000]  [ffffe20000000000-ffffe200011fffff] PMD -> [ffff880001200000-ffff8800023fffff] on node 0
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000010 -> 0x00001000
> [    0.000000]   DMA32    0x00001000 -> 0x00100000
> [    0.000000]   Normal   0x00100000 -> 0x00100000
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[2] active PFN ranges
> [    0.000000]     0: 0x00000010 -> 0x0000009f
> [    0.000000]     0: 0x00000100 -> 0x0004fff0
> [    0.000000] On node 0 totalpages: 327551
> [    0.000000]   DMA zone: 56 pages used for memmap
> [    0.000000]   DMA zone: 1427 pages reserved
> [    0.000000]   DMA zone: 2500 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 4424 pages used for memmap
> [    0.000000]   DMA32 zone: 319144 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x808
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] nr_irqs_gsi: 24
> [    0.000000] Allocating PCI resources starting at 60000000 (gap: 50000000:aec00000)
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 321644
> [    0.000000] Kernel command line: root=/dev/sda1 hpet=force fastboot
> [    0.000000] Initializing CPU#0
> [    0.000000] Experimental hierarchical RCU implementation.
> [    0.000000] Experimental hierarchical RCU init done.
> [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 1800.042 MHz processor.
> [    0.000999] Console: colour VGA+ 80x25
> [    0.000999] console [tty0] enabled
> [    0.000999] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
> [    0.000999] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.000999] Checking aperture...
> [    0.000999] AGP bridge at 00:00:00
> [    0.000999] Aperture from AGP @ d0000000 old size 32 MB
> [    0.000999] Aperture from AGP @ d0000000 size 128 MB (APSIZE f20)
> [    0.000999] Node 0: aperture @ d0000000 size 128 MB
> [    0.000999] Memory: 1282672k/1310656k available (2571k kernel code, 452k absent, 26924k reserved, 1743k data, 260k init)
> [    0.000999] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
> [    0.001022] Calibrating delay loop (skipped), value calculated using timer frequency.. 3600.08 BogoMIPS (lpj=1800042)
> [    0.001164] Mount-cache hash table entries: 256
> [    0.001508] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> [    0.001559] CPU: L2 Cache: 512K (64 bytes/line)
> [    0.001607] tseg: 0000000000
> [    0.001643] CPU: AMD Athlon(tm) 64 Processor 2800+ stepping 0a
> [    0.001771] ACPI: Core revision 20081204
> [    0.009509] ftrace: converting mcount calls to 0f 1f 44 00 00
> [    0.009568] ftrace: allocating 15314 entries in 121 pages
> [    0.013283] Setting APIC routing to flat
> [    0.014197] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
> [    0.024996] net_namespace: 576 bytes
> [    0.024996] NET: Registered protocol family 16
> [    0.024996] node 0 link 0: io port [0, ffffff]
> [    0.024996] TOM: 0000000050000000 aka 1280M
> [    0.024996] node 0 link 0: mmio [a0000, bffff]
> [    0.024996] node 0 link 0: mmio [50000000, ffffffff]
> [    0.024996] bus: [00,ff] on node 0 link 0
> [    0.024996] bus: 00 index 0 io port: [0, ffff]
> [    0.024996] bus: 00 index 1 mmio: [a0000, bffff]
> [    0.024996] bus: 00 index 2 mmio: [50000000, fcffffffff]
> [    0.024996] ACPI: bus type pci registered
> [    0.025017] PCI: Using configuration type 1 for base access
> [    0.028343] bio: create slab <bio-0> at 0
> [    0.028886] ACPI: EC: Look up EC in DSDT
> [    0.030957] ACPI Warning (dsobject-0502): Package List length (65) larger than NumElements count (2), truncated
> [    0.031063]  [20081204]
> [    0.034925] ACPI: Interpreter enabled
> [    0.034973] ACPI: (supports S0 S1 S3 S5)
> [    0.035141] ACPI: Using IOAPIC for interrupt routing
> [    0.039138] ACPI: No dock devices found.
> [    0.039203] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [    0.039349] pci 0000:00:00.0: reg 10 32bit mmio: [0xd0000000-0xd7ffffff]
> [    0.039435] pci 0000:00:01.0: supports D1
> [    0.039465] pci 0000:00:06.0: reg 10 io port: [0xec00-0xecff]
> [    0.039471] pci 0000:00:06.0: reg 14 32bit mmio: [0xcfffff00-0xcfffffff]
> [    0.039490] pci 0000:00:06.0: reg 30 32bit mmio: [0xcff80000-0xcffbffff]
> [    0.039504] pci 0000:00:06.0: supports D1 D2
> [    0.039507] pci 0000:00:06.0: PME# supported from D1 D2 D3hot D3cold
> [    0.039559] pci 0000:00:06.0: PME# disabled
> [    0.039634] pci 0000:00:0b.0: reg 10 io port: [0xe800-0xe8ff]
> [    0.039640] pci 0000:00:0b.0: reg 14 32bit mmio: [0xcffffe00-0xcffffeff]
> [    0.039658] pci 0000:00:0b.0: reg 30 32bit mmio: [0xcffc0000-0xcffdffff]
> [    0.039673] pci 0000:00:0b.0: supports D1 D2
> [    0.039676] pci 0000:00:0b.0: PME# supported from D1 D2 D3hot D3cold
> [    0.039726] pci 0000:00:0b.0: PME# disabled
> [    0.039812] pci 0000:00:0f.0: reg 20 io port: [0xfc00-0xfc0f]
> [    0.039871] pci 0000:00:10.0: reg 20 io port: [0xd800-0xd81f]
> [    0.039892] pci 0000:00:10.0: supports D1 D2
> [    0.039894] pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.039945] pci 0000:00:10.0: PME# disabled
> [    0.040044] pci 0000:00:10.1: reg 20 io port: [0xdc00-0xdc1f]
> [    0.040065] pci 0000:00:10.1: supports D1 D2
> [    0.040067] pci 0000:00:10.1: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.040118] pci 0000:00:10.1: PME# disabled
> [    0.040200] pci 0000:00:10.2: reg 20 io port: [0xe000-0xe01f]
> [    0.040220] pci 0000:00:10.2: supports D1 D2
> [    0.040222] pci 0000:00:10.2: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.040273] pci 0000:00:10.2: PME# disabled
> [    0.040354] pci 0000:00:10.3: reg 20 io port: [0xe400-0xe41f]
> [    0.040375] pci 0000:00:10.3: supports D1 D2
> [    0.040377] pci 0000:00:10.3: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.040428] pci 0000:00:10.3: PME# disabled
> [    0.040803] pci 0000:00:10.4: reg 10 32bit mmio: [0xcffffc00-0xcffffcff]
> [    0.040836] pci 0000:00:10.4: supports D1 D2
> [    0.040838] pci 0000:00:10.4: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.040889] pci 0000:00:10.4: PME# disabled
> [    0.040987] pci 0000:00:11.0: Force enabled HPET at 0xfed00000
> [    0.041036] pci 0000:00:11.5: reg 10 io port: [0xd400-0xd4ff]
> [    0.041071] pci 0000:00:11.5: supports D1 D2
> [    0.041158] pci 0000:01:00.0: reg 10 32bit mmio: [0xb0000000-0xbfffffff]
> [    0.041163] pci 0000:01:00.0: reg 14 io port: [0xc800-0xc8ff]
> [    0.041167] pci 0000:01:00.0: reg 18 32bit mmio: [0xcfef0000-0xcfefffff]
> [    0.041177] pci 0000:01:00.0: reg 30 32bit mmio: [0xcfec0000-0xcfedffff]
> [    0.041188] pci 0000:01:00.0: supports D1 D2
> [    0.041209] pci 0000:00:01.0: bridge io port: [0xc000-0xcfff]
> [    0.041213] pci 0000:00:01.0: bridge 32bit mmio: [0xcfe00000-0xcfefffff]
> [    0.041217] pci 0000:00:01.0: bridge 32bit mmio pref: [0xafd00000-0xcfcfffff]
> [    0.041224] pci_bus 0000:00: on NUMA node 0
> [    0.041232] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.057559] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> [    0.058093] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
> [    0.058618] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 10 11 12 14 15)
> [    0.059144] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 12 14 15)
> [    0.059669] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> [    0.060247] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> [    0.060842] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> [    0.061460] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> [    0.062059] ACPI: Power Resource [URP1] (off)
> [    0.062142] ACPI: Power Resource [URP2] (off)
> [    0.062225] ACPI: Power Resource [FDDP] (off)
> [    0.062307] ACPI: Power Resource [LPTP] (off)
> [    0.062718] SCSI subsystem initialized
> [    0.062805] libata version 3.00 loaded.
> [    0.062927] usbcore: registered new interface driver usbfs
> [    0.063022] usbcore: registered new interface driver hub
> [    0.063117] usbcore: registered new device driver usb
> [    0.063336] PCI: Using ACPI for IRQ routing
> [    0.063395] pci 0000:00:00.0: BAR 0: can't allocate resource
> [    0.063704] agpgart-amd64 0000:00:00.0: AGP bridge [1106/3188]
> [    0.073863] agpgart-amd64 0000:00:00.0: AGP aperture is 128M @ 0xd0000000
> [    0.074149] hpet clockevent registered
> [    0.074157] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> [    0.074325] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
> [    0.075076] pnp: PnP ACPI init
> [    0.075129] ACPI: bus type pnp registered
> [    0.077906] pnp: PnP ACPI: found 6 devices
> [    0.077953] ACPI: ACPI bus type pnp unregistered
> [    0.078020] system 00:01: ioport range 0x290-0x297 has been reserved
> [    0.078070] system 00:01: ioport range 0x3f0-0x3f1 has been reserved
> [    0.078121] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
> [    0.078171] system 00:01: ioport range 0x400-0x40f has been reserved
> [    0.078221] system 00:01: ioport range 0x820-0x821 has been reserved
> [    0.078272] system 00:01: iomem range 0xfee00000-0xfee00fff has been reserved
> [    0.083472] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
> [    0.083522] pci 0000:00:01.0:   IO window: 0xc000-0xcfff
> [    0.083572] pci 0000:00:01.0:   MEM window: 0xcfe00000-0xcfefffff
> [    0.083623] pci 0000:00:01.0:   PREFETCH window: 0x000000afd00000-0x000000cfcfffff
> [    0.083697] pci 0000:00:01.0: setting latency timer to 64
> [    0.083702] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
> [    0.083705] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
> [    0.083708] pci_bus 0000:01: resource 0 io:  [0xc000-0xcfff]
> [    0.083711] pci_bus 0000:01: resource 1 mem: [0xcfe00000-0xcfefffff]
> [    0.083713] pci_bus 0000:01: resource 2 mem: [0xafd00000-0xcfcfffff]
> [    0.083716] pci_bus 0000:01: resource 3 mem: [0x0-0x0]
> [    0.083743] NET: Registered protocol family 2
> [    0.083843] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.084904] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
> [    0.092651] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.093749] TCP: Hash tables configured (established 262144 bind 65536)
> [    0.093800] TCP reno registered
> [    0.093966] NET: Registered protocol family 1
> [    0.098397] msgmni has been set to 2506
> [    0.098598] alg: No test for stdrng (krng)
> [    0.098743] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> [    0.098806] io scheduler noop registered
> [    0.098913] io scheduler cfq registered (default)
> [    0.098975] PCI: VIA PCI bridge detected. Disabling DAC.
> [    0.099137] pci 0000:01:00.0: Boot video device
> [    0.099321] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [    0.099383] ACPI: Power Button (FF) [PWRF]
> [    0.099537] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
> [    0.099600] ACPI: Power Button (CM) [PWRB]
> [    0.099764] input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
> [    0.099832] ACPI: Sleep Button (CM) [SLPB]
> [    0.100143] processor ACPI_CPU:00: registered as cooling_device0
> [    0.103175] Linux agpgart interface v0.103
> [    0.103262] [drm] Initialized drm 1.1.0 20060810
> [    0.103501] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    0.103748] [drm] Initialized radeon 1.29.0 20080528 on minor 0
> [    0.104143] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> [    0.104213] r8169 0000:00:0b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    0.104277] r8169 0000:00:0b.0: PCI: Disallowing DAC for device
> [    0.106377] r8169 0000:00:0b.0: no PCI Express capability
> [    0.106637] r8169 0000:00:0b.0: MAC address found in EEPROM: 00:11:09:e8:d8:73
> [    0.106838] eth0: RTL8110s at 0xffffc2000001ee00, 00:11:09:e8:d8:73, XID 04000000 IRQ 16
> [    0.110194] Driver 'sd' needs updating - please use bus_type methods
> [    0.110275] Driver 'sr' needs updating - please use bus_type methods
> [    0.110394] pata_via 0000:00:0f.0: version 0.3.3
> [    0.110411] pata_via 0000:00:0f.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> [    0.110676] scsi0 : pata_via
> [    0.110900] scsi1 : pata_via
> [    0.113859] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 irq 14
> [    0.113911] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xfc08 irq 15
> [    0.114023] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    0.114093] ehci_hcd 0000:00:10.4: PCI INT C -> GSI 21 (level, low) -> IRQ 21
> [    0.114170] ehci_hcd 0000:00:10.4: EHCI Host Controller
> [    0.114399] ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 1
> [    0.114543] ehci_hcd 0000:00:10.4: irq 21, io mem 0xcffffc00
> [    0.119985] ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00
> [    0.120176] usb usb1: configuration #1 chosen from 1 choice
> [    0.120284] hub 1-0:1.0: USB hub found
> [    0.120342] hub 1-0:1.0: 8 ports detected
> [    0.120593] uhci_hcd: USB Universal Host Controller Interface driver
> [    0.120733] uhci_hcd 0000:00:10.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
> [    0.120790] uhci_hcd 0000:00:10.0: UHCI Host Controller
> [    0.120877] uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
> [    0.120958] uhci_hcd 0000:00:10.0: irq 21, io base 0x0000d800
> [    0.121138] usb usb2: configuration #1 chosen from 1 choice
> [    0.121235] hub 2-0:1.0: USB hub found
> [    0.121309] hub 2-0:1.0: 2 ports detected
> [    0.121485] uhci_hcd 0000:00:10.1: PCI INT A -> GSI 21 (level, low) -> IRQ 21
> [    0.121539] uhci_hcd 0000:00:10.1: UHCI Host Controller
> [    0.121626] uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
> [    0.121706] uhci_hcd 0000:00:10.1: irq 21, io base 0x0000dc00
> [    0.121877] usb usb3: configuration #1 chosen from 1 choice
> [    0.121971] hub 3-0:1.0: USB hub found
> [    0.122046] hub 3-0:1.0: 2 ports detected
> [    0.122212] uhci_hcd 0000:00:10.2: PCI INT B -> GSI 21 (level, low) -> IRQ 21
> [    0.122267] uhci_hcd 0000:00:10.2: UHCI Host Controller
> [    0.122353] uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
> [    0.122431] uhci_hcd 0000:00:10.2: irq 21, io base 0x0000e000
> [    0.122595] usb usb4: configuration #1 chosen from 1 choice
> [    0.122688] hub 4-0:1.0: USB hub found
> [    0.122745] hub 4-0:1.0: 2 ports detected
> [    0.122910] uhci_hcd 0000:00:10.3: PCI INT B -> GSI 21 (level, low) -> IRQ 21
> [    0.122964] uhci_hcd 0000:00:10.3: UHCI Host Controller
> [    0.123066] uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 5
> [    0.123145] uhci_hcd 0000:00:10.3: irq 21, io base 0x0000e400
> [    0.123305] usb usb5: configuration #1 chosen from 1 choice
> [    0.123397] hub 5-0:1.0: USB hub found
> [    0.123451] hub 5-0:1.0: 2 ports detected
> [    0.123677] usbcore: registered new interface driver usblp
> [    0.123727] Initializing USB Mass Storage driver...
> [    0.123830] usbcore: registered new interface driver usb-storage
> [    0.123880] USB Mass Storage support registered.
> [    0.124117] rtc_cmos 00:03: RTC can wake from S4
> [    0.124220] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
> [    0.124305] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
> [    0.124382] i2c /dev entries driver
> [    0.124508] ACPI: I/O resource vt596_smbus [0x400-0x407] conflicts with ACPI region SMOV [0x400-0x406]
> [    0.124572] ACPI: Device needs an ACPI driver
> [    0.124754] WDT driver for the Winbond(TM) W83627HF/THF/HG Super I/O chip initialising.
> [    0.124840] w83627hf/thf/hg WDT: Watchdog already running. Resetting timeout to 60 sec
> [    0.124964] w83627hf/thf/hg WDT: initialized. timeout=60 sec (nowayout=0)
> [    0.125036] cpuidle: using governor ladder
> [    0.125083] cpuidle: using governor menu
> [    0.125224] usbcore: registered new interface driver usbhid
> [    0.125274] usbhid: v2.6:USB HID core driver
> [    0.125385] Advanced Linux Sound Architecture Driver Version 1.0.18a.
> [    0.125769] VIA 82xx Audio 0000:00:11.5: PCI INT C -> GSI 22 (level, low) -> IRQ 22
> [    0.126011] VIA 82xx Audio 0000:00:11.5: setting latency timer to 64
> [    0.271435] ata1.00: HPA detected: current 156299375, native 156301488
> [    0.271490] ata1.00: ATA-6: WDC WD800JB-00JJC0, 05.01C05, max UDMA/100
> [    0.271541] ata1.00: 156299375 sectors, multi 16: LBA
> [    0.271734] ata1.01: ATA-6: WDC WD800JB-00JJA0, 05.01C05, max UDMA/100
> [    0.271784] ata1.01: 156301488 sectors, multi 16: LBA
> [    0.275303] ata1.00: configured for UDMA/100
> [    0.278299] ata1.01: configured for UDMA/100
> [    0.278413] isa bounce pool size: 16 pages
> [    0.278608] scsi 0:0:0:0: Direct-Access     ATA      WDC WD800JB-00JJ 05.0 PQ: 0 ANSI: 5
> [    0.278963] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    0.279126] sd 0:0:0:0: [sda] 156299375 512-byte hardware sectors: (80.0 GB/74.5 GiB)
> [    0.279204] sd 0:0:0:0: [sda] Write Protect is off
> [    0.279252] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    0.279273] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    0.279401] sd 0:0:0:0: [sda] 156299375 512-byte hardware sectors: (80.0 GB/74.5 GiB)
> [    0.279472] sd 0:0:0:0: [sda] Write Protect is off
> [    0.279520] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    0.279538] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    0.279603]  sda: sda1 sda2 sda3
> [    0.290488] scsi 0:0:1:0: Direct-Access     ATA      WDC WD800JB-00JJ 05.0 PQ: 0 ANSI: 5
> [    0.290903] sd 0:0:1:0: Attached scsi generic sg1 type 0
> [    0.291024] sd 0:0:1:0: [sdb] 156301488 512-byte hardware sectors: (80.0 GB/74.5 GiB)
> [    0.291097] sd 0:0:1:0: [sdb] Write Protect is off
> [    0.291144] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
> [    0.291164] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    0.291268] sd 0:0:1:0: [sdb] 156301488 512-byte hardware sectors: (80.0 GB/74.5 GiB)
> [    0.291339] sd 0:0:1:0: [sdb] Write Protect is off
> [    0.291386] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
> [    0.291406] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    0.291469]  sdb:<5>sd 0:0:0:0: [sda] Attached SCSI disk
> [    0.304934]  sdb1 sdb2 < sdb5 sdb6 >
> [    0.332213] sd 0:0:1:0: [sdb] Attached SCSI disk
> [    0.464288] ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-4163B, A104, max UDMA/33
> [    0.464369] ata2.01: ATAPI: HL-DT-STDVD-ROM GDR8163B, 0L23, max UDMA/33
> [    0.486162] ata2.00: configured for UDMA/33
> [    0.508157] ata2.01: configured for UDMA/33
> [    0.514639] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4163B A104 PQ: 0 ANSI: 5
> [    0.527229] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
> [    0.527291] Uniform CD-ROM driver Revision: 3.20
> [    0.527440] sr 1:0:0:0: Attached scsi CD-ROM sr0
> [    0.527532] sr 1:0:0:0: Attached scsi generic sg2 type 5
> [    0.530806] scsi 1:0:1:0: CD-ROM            HL-DT-ST DVD-ROM GDR8163B 0L23 PQ: 0 ANSI: 5
> [    0.538601] sr1: scsi3-mmc drive: 52x/52x cd/rw xa/form2 cdda tray
> [    0.538763] sr 1:0:1:0: Attached scsi CD-ROM sr1
> [    0.538846] sr 1:0:1:0: Attached scsi generic sg3 type 5
> [    0.575911] Switched to high resolution mode on CPU 0
> [    0.638893] usb 5-1: new low speed USB device using uhci_hcd and address 2
> [    0.640047] ALSA device list:
> [    0.640092]   #0: VIA 8237 with ALC655 at 0xd400, irq 22
> [    0.640182] TCP cubic registered
> [    0.640229] NET: Registered protocol family 17
> [    0.640296] powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 2800+ processors (1 cpu cores) (version 2.20.00)
> [    0.640432] powernow-k8:    0 : fid 0xa (1800 MHz), vid 0x2
> [    0.640481] powernow-k8:    1 : fid 0x2 (1000 MHz), vid 0x12
> [    0.640981] rtc_cmos 00:03: setting system clock to 2009-03-17 13:00:51 UTC (1237294851)
> [    0.650535] kjournald starting.  Commit interval 5 seconds
> [    0.650593] EXT3-fs: mounted filesystem with ordered data mode.
> [    0.650655] VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
> [    0.650720] Freeing unused kernel memory: 260k freed
> [    0.651161] Write protecting the kernel read-only data: 1400k
> [    0.696192] Marking TSC unstable due to cpufreq changes
> [    0.799717] usb 5-1: configuration #1 chosen from 1 choice
> [    0.818464] input: Logitech USB Mouse as /devices/pci0000:00/0000:00:10.3/usb5/5-1/5-1:1.0/input/input3
> [    0.818617] generic-usb 0003:046D:C00C.0001: input: USB HID v1.10 Mouse [Logitech USB Mouse] on usb-0000:00:10.3-1/input0
> [    1.024035] usb 5-2: new low speed USB device using uhci_hcd and address 3
> [    1.074016] Clocksource tsc unstable (delta = -169592809 ns)
> [    1.194732] usb 5-2: configuration #1 chosen from 1 choice
> [    1.212273] input: Microsoft Microsoft® Digital Media Pro Keyboard as /devices/pci0000:00/0000:00:10.3/usb5/5-2/5-2:1.0/input/input4
> [    1.212455] generic-usb 0003:045E:00B0.0002: input: USB HID v1.11 Keyboard [Microsoft Microsoft® Digital Media Pro Keyboard] on usb-0000:00:10.3-2/input0
> [    1.243816] input: Microsoft Microsoft® Digital Media Pro Keyboard as /devices/pci0000:00/0000:00:10.3/usb5/5-2/5-2:1.1/input/input5
> [    1.244015] generic-usb 0003:045E:00B0.0003: input: USB HID v1.11 Device [Microsoft Microsoft® Digital Media Pro Keyboard] on usb-0000:00:10.3-2/input1
> [    5.669504] udev: starting version 140
> [    8.138639] EXT3 FS on sda1, internal journal
> [    8.288010] kjournald starting.  Commit interval 5 seconds
> [    8.288257] EXT3 FS on sda3, internal journal
> [    8.288263] EXT3-fs: mounted filesystem with ordered data mode.
> [    8.711552] Adding 987988k swap on /dev/sda2.  Priority:-1 extents:1 across:987988k
> [   10.700862] r8169: eth0: link up
> [   10.814128] w83627hf: Found W83697HF chip at 0x290
> [   63.696862] agpgart-amd64 0000:00:00.0: AGP 3.0 bridge
> [   63.696892] agpgart-amd64 0000:00:00.0: putting AGP V3 device into 8x mode
> [   63.696960] pci 0000:01:00.0: putting AGP V3 device into 8x mode
> [   63.923788] [drm] Setting GART location based on new memory map
> [   63.923803] [drm] Loading R200 Microcode
> [   63.923872] [drm] writeback test succeeded in 1 usecs
> [21702.386623] X:5055 freeing invalid memtype d0102000-d0112000
> [21702.386635] X:5055 freeing invalid memtype d0112000-d0122000
> [21702.386648] X:5055 freeing invalid memtype d0122000-d0132000
> [21702.386656] X:5055 freeing invalid memtype d0132000-d0142000
> [21702.386663] X:5055 freeing invalid memtype d0142000-d0152000
> [21702.386670] X:5055 freeing invalid memtype d0152000-d0162000
> [21702.386677] X:5055 freeing invalid memtype d0162000-d0172000
> [21702.386684] X:5055 freeing invalid memtype d0172000-d0182000
> [21702.386691] X:5055 freeing invalid memtype d0182000-d0192000
> [21702.386698] X:5055 freeing invalid memtype d0192000-d01a2000
> [21702.386705] X:5055 freeing invalid memtype d01a2000-d01b2000
> [21702.386712] X:5055 freeing invalid memtype d01b2000-d01c2000
> [21702.386719] X:5055 freeing invalid memtype d01c2000-d01d2000
> [21702.386726] X:5055 freeing invalid memtype d01d2000-d01e2000
> [21702.386733] X:5055 freeing invalid memtype d01e2000-d01f2000
> [21702.386740] X:5055 freeing invalid memtype d01f2000-d0202000
> [21702.386747] X:5055 freeing invalid memtype d0202000-d0212000
> [21702.386754] X:5055 freeing invalid memtype d0212000-d0222000
> [21702.386761] X:5055 freeing invalid memtype d0222000-d0232000
> [21702.386768] X:5055 freeing invalid memtype d0232000-d0242000
> [21702.386775] X:5055 freeing invalid memtype d0242000-d0252000
> [21702.386782] X:5055 freeing invalid memtype d0252000-d0262000
> [21702.386790] X:5055 freeing invalid memtype d0262000-d0272000
> [21702.386797] X:5055 freeing invalid memtype d0272000-d0282000
> [21702.386804] X:5055 freeing invalid memtype d0282000-d0292000
> [21702.386811] X:5055 freeing invalid memtype d0292000-d02a2000
> [21702.386818] X:5055 freeing invalid memtype d02a2000-d02b2000
> [21702.386825] X:5055 freeing invalid memtype d02b2000-d02c2000
> [21702.386833] X:5055 freeing invalid memtype d02c2000-d02d2000
> [21702.386840] X:5055 freeing invalid memtype d02d2000-d02e2000
> [21702.386847] X:5055 freeing invalid memtype d02e2000-d02f2000
> [21702.386854] X:5055 freeing invalid memtype d02f2000-d0302000
> [21702.501589] mtrr: no MTRR for b0000000,8000000 found
> [21702.501798] X:5055 freeing invalid memtype d0102000-d0112000
> [21702.501809] X:5055 freeing invalid memtype d0112000-d0122000
> [21702.501817] X:5055 freeing invalid memtype d0122000-d0132000
> [21702.501824] X:5055 freeing invalid memtype d0132000-d0142000
> [21702.501831] X:5055 freeing invalid memtype d0142000-d0152000
> [21702.501837] X:5055 freeing invalid memtype d0152000-d0162000
> [21702.501844] X:5055 freeing invalid memtype d0162000-d0172000
> [21702.501851] X:5055 freeing invalid memtype d0172000-d0182000
> [21702.501858] X:5055 freeing invalid memtype d0182000-d0192000
> [21702.501865] X:5055 freeing invalid memtype d0192000-d01a2000
> [21702.501872] X:5055 freeing invalid memtype d01a2000-d01b2000
> [21702.501879] X:5055 freeing invalid memtype d01b2000-d01c2000
> [21702.501886] X:5055 freeing invalid memtype d01c2000-d01d2000
> [21702.501893] X:5055 freeing invalid memtype d01d2000-d01e2000
> [21702.501900] X:5055 freeing invalid memtype d01e2000-d01f2000
> [21702.501907] X:5055 freeing invalid memtype d01f2000-d0202000
> [21702.501914] X:5055 freeing invalid memtype d0202000-d0212000
> [21702.501921] X:5055 freeing invalid memtype d0212000-d0222000
> [21702.501928] X:5055 freeing invalid memtype d0222000-d0232000
> [21702.501935] X:5055 freeing invalid memtype d0232000-d0242000
> [21702.501942] X:5055 freeing invalid memtype d0242000-d0252000
> [21702.501949] X:5055 freeing invalid memtype d0252000-d0262000
> [21702.501956] X:5055 freeing invalid memtype d0262000-d0272000
> [21702.501963] X:5055 freeing invalid memtype d0272000-d0282000
> [21702.501970] X:5055 freeing invalid memtype d0282000-d0292000
> [21702.501977] X:5055 freeing invalid memtype d0292000-d02a2000
> [21702.501984] X:5055 freeing invalid memtype d02a2000-d02b2000
> [21702.501991] X:5055 freeing invalid memtype d02b2000-d02c2000
> [21702.501998] X:5055 freeing invalid memtype d02c2000-d02d2000
> [21702.503485] X:5055 freeing invalid memtype d02d2000-d02e2000
> [21702.503493] X:5055 freeing invalid memtype d02e2000-d02f2000
> [21702.503500] X:5055 freeing invalid memtype d02f2000-d0302000
> [21713.110462] agpgart-amd64 0000:00:00.0: AGP 3.0 bridge
> [21713.110487] agpgart-amd64 0000:00:00.0: putting AGP V3 device into 8x mode
> [21713.110540] pci 0000:01:00.0: putting AGP V3 device into 8x mode
> [21713.314630] [drm] Setting GART location based on new memory map
> [21713.314645] [drm] Loading R200 Microcode
> [21713.314714] [drm] writeback test succeeded in 1 usecs
> [21718.047718] xfce4-settings-[6617]: segfault at 8 ip 00007fec5f6f08ba sp 00007fff6cfb6040 error 4 in libSM.so.6.0.0[7fec5f6ee000+7000]
> [24730.578147] etracer:7105 freeing invalid memtype d0102000-d0112000
> [24730.578158] etracer:7105 freeing invalid memtype d0112000-d0122000
> [24730.578166] etracer:7105 freeing invalid memtype d0122000-d0132000
> [24730.578173] etracer:7105 freeing invalid memtype d0132000-d0142000
> [24730.578180] etracer:7105 freeing invalid memtype d0142000-d0152000
> [24730.578187] etracer:7105 freeing invalid memtype d0152000-d0162000
> [24730.578194] etracer:7105 freeing invalid memtype d0162000-d0172000
> [24730.578201] etracer:7105 freeing invalid memtype d0172000-d0182000
> [24730.578208] etracer:7105 freeing invalid memtype d0182000-d0192000
> [24730.578215] etracer:7105 freeing invalid memtype d0192000-d01a2000
> [24730.578222] etracer:7105 freeing invalid memtype d01a2000-d01b2000
> [24730.578229] etracer:7105 freeing invalid memtype d01b2000-d01c2000
> [24730.578236] etracer:7105 freeing invalid memtype d01c2000-d01d2000
> [24730.578243] etracer:7105 freeing invalid memtype d01d2000-d01e2000
> [24730.578250] etracer:7105 freeing invalid memtype d01e2000-d01f2000
> [24730.578257] etracer:7105 freeing invalid memtype d01f2000-d0202000
> [24730.578264] etracer:7105 freeing invalid memtype d0202000-d0212000
> [24730.578271] etracer:7105 freeing invalid memtype d0212000-d0222000
> [24730.578278] etracer:7105 freeing invalid memtype d0222000-d0232000
> [24730.578285] etracer:7105 freeing invalid memtype d0232000-d0242000
> [24730.578292] etracer:7105 freeing invalid memtype d0242000-d0252000
> [24730.578299] etracer:7105 freeing invalid memtype d0252000-d0262000
> [24730.578306] etracer:7105 freeing invalid memtype d0262000-d0272000
> [24730.578313] etracer:7105 freeing invalid memtype d0272000-d0282000
> [24730.578320] etracer:7105 freeing invalid memtype d0282000-d0292000
> [24730.578328] etracer:7105 freeing invalid memtype d0292000-d02a2000
> [24730.578335] etracer:7105 freeing invalid memtype d02a2000-d02b2000
> [24730.578342] etracer:7105 freeing invalid memtype d02b2000-d02c2000
> [24730.578349] etracer:7105 freeing invalid memtype d02c2000-d02d2000
> [24730.578356] etracer:7105 freeing invalid memtype d02d2000-d02e2000
> [24730.578363] etracer:7105 freeing invalid memtype d02e2000-d02f2000
> [24730.578370] etracer:7105 freeing invalid memtype d02f2000-d0302000
> [25385.291824] etracer:7697 freeing invalid memtype d0102000-d0112000
> [25385.291835] etracer:7697 freeing invalid memtype d0112000-d0122000
> [25385.291843] etracer:7697 freeing invalid memtype d0122000-d0132000
> [25385.291850] etracer:7697 freeing invalid memtype d0132000-d0142000
> [25385.291857] etracer:7697 freeing invalid memtype d0142000-d0152000
> [25385.291864] etracer:7697 freeing invalid memtype d0152000-d0162000
> [25385.291871] etracer:7697 freeing invalid memtype d0162000-d0172000
> [25385.291879] etracer:7697 freeing invalid memtype d0172000-d0182000
> [25385.291886] etracer:7697 freeing invalid memtype d0182000-d0192000
> [25385.291893] etracer:7697 freeing invalid memtype d0192000-d01a2000
> [25385.291901] etracer:7697 freeing invalid memtype d01a2000-d01b2000
> [25385.291908] etracer:7697 freeing invalid memtype d01b2000-d01c2000
> [25385.291915] etracer:7697 freeing invalid memtype d01c2000-d01d2000
> [25385.291922] etracer:7697 freeing invalid memtype d01d2000-d01e2000
> [25385.291929] etracer:7697 freeing invalid memtype d01e2000-d01f2000
> [25385.291936] etracer:7697 freeing invalid memtype d01f2000-d0202000
> [25385.291943] etracer:7697 freeing invalid memtype d0202000-d0212000
> [25385.291950] etracer:7697 freeing invalid memtype d0212000-d0222000
> [25385.291957] etracer:7697 freeing invalid memtype d0222000-d0232000
> [25385.291964] etracer:7697 freeing invalid memtype d0232000-d0242000
> [25385.291971] etracer:7697 freeing invalid memtype d0242000-d0252000
> [25385.291978] etracer:7697 freeing invalid memtype d0252000-d0262000
> [25385.291985] etracer:7697 freeing invalid memtype d0262000-d0272000
> [25385.291992] etracer:7697 freeing invalid memtype d0272000-d0282000
> [25385.292014] etracer:7697 freeing invalid memtype d0282000-d0292000
> [25385.293211] etracer:7697 freeing invalid memtype d0292000-d02a2000
> [25385.293220] etracer:7697 freeing invalid memtype d02a2000-d02b2000
> [25385.293227] etracer:7697 freeing invalid memtype d02b2000-d02c2000
> [25385.293235] etracer:7697 freeing invalid memtype d02c2000-d02d2000
> [25385.293242] etracer:7697 freeing invalid memtype d02d2000-d02e2000
> [25385.293249] etracer:7697 freeing invalid memtype d02e2000-d02f2000
> [25385.293256] etracer:7697 freeing invalid memtype d02f2000-d0302000
> [25401.705955] glxinfo:9418 freeing invalid memtype d0102000-d0112000
> [25401.705973] glxinfo:9418 freeing invalid memtype d0112000-d0122000
> [25401.705987] glxinfo:9418 freeing invalid memtype d0122000-d0132000
> [25401.706000] glxinfo:9418 freeing invalid memtype d0132000-d0142000
> [25401.706549] glxinfo:9418 freeing invalid memtype d0142000-d0152000
> [25401.706563] glxinfo:9418 freeing invalid memtype d0152000-d0162000
> [25401.706576] glxinfo:9418 freeing invalid memtype d0162000-d0172000
> [25401.706589] glxinfo:9418 freeing invalid memtype d0172000-d0182000
> [25401.706602] glxinfo:9418 freeing invalid memtype d0182000-d0192000
> [25401.706614] glxinfo:9418 freeing invalid memtype d0192000-d01a2000
> [25401.706627] glxinfo:9418 freeing invalid memtype d01a2000-d01b2000
> [25401.706640] glxinfo:9418 freeing invalid memtype d01b2000-d01c2000
> [25401.706653] glxinfo:9418 freeing invalid memtype d01c2000-d01d2000
> [25401.706666] glxinfo:9418 freeing invalid memtype d01d2000-d01e2000
> [25401.706679] glxinfo:9418 freeing invalid memtype d01e2000-d01f2000
> [25401.706692] glxinfo:9418 freeing invalid memtype d01f2000-d0202000
> [25401.706708] glxinfo:9418 freeing invalid memtype d0202000-d0212000
> [25401.706721] glxinfo:9418 freeing invalid memtype d0212000-d0222000
> [25401.706734] glxinfo:9418 freeing invalid memtype d0222000-d0232000
> [25401.706747] glxinfo:9418 freeing invalid memtype d0232000-d0242000
> [25401.706759] glxinfo:9418 freeing invalid memtype d0242000-d0252000
> [25401.706772] glxinfo:9418 freeing invalid memtype d0252000-d0262000
> [25401.706785] glxinfo:9418 freeing invalid memtype d0262000-d0272000
> [25401.706798] glxinfo:9418 freeing invalid memtype d0272000-d0282000
> [25401.706811] glxinfo:9418 freeing invalid memtype d0282000-d0292000
> [25401.706824] glxinfo:9418 freeing invalid memtype d0292000-d02a2000
> [25401.706837] glxinfo:9418 freeing invalid memtype d02a2000-d02b2000
> [25401.706850] glxinfo:9418 freeing invalid memtype d02b2000-d02c2000
> [25401.706863] glxinfo:9418 freeing invalid memtype d02c2000-d02d2000
> [25401.706876] glxinfo:9418 freeing invalid memtype d02d2000-d02e2000
> [25401.706889] glxinfo:9418 freeing invalid memtype d02e2000-d02f2000
> [25401.706900] glxinfo:9418 freeing invalid memtype d02f2000-d0302000
> [25736.887445] etracer:9735 freeing invalid memtype d0102000-d0112000
> [25736.887463] etracer:9735 freeing invalid memtype d0112000-d0122000
> [25736.887477] etracer:9735 freeing invalid memtype d0122000-d0132000
> [25736.887490] etracer:9735 freeing invalid memtype d0132000-d0142000
> [25736.887503] etracer:9735 freeing invalid memtype d0142000-d0152000
> [25736.887516] etracer:9735 freeing invalid memtype d0152000-d0162000
> [25736.887529] etracer:9735 freeing invalid memtype d0162000-d0172000
> [25736.887542] etracer:9735 freeing invalid memtype d0172000-d0182000
> [25736.887554] etracer:9735 freeing invalid memtype d0182000-d0192000
> [25736.887567] etracer:9735 freeing invalid memtype d0192000-d01a2000
> [25736.887581] etracer:9735 freeing invalid memtype d01a2000-d01b2000
> [25736.887594] etracer:9735 freeing invalid memtype d01b2000-d01c2000
> [25736.887607] etracer:9735 freeing invalid memtype d01c2000-d01d2000
> [25736.887620] etracer:9735 freeing invalid memtype d01d2000-d01e2000
> [25736.887633] etracer:9735 freeing invalid memtype d01e2000-d01f2000
> [25736.887645] etracer:9735 freeing invalid memtype d01f2000-d0202000
> [25736.887658] etracer:9735 freeing invalid memtype d0202000-d0212000
> [25736.887671] etracer:9735 freeing invalid memtype d0212000-d0222000
> [25736.887684] etracer:9735 freeing invalid memtype d0222000-d0232000
> [25736.887696] etracer:9735 freeing invalid memtype d0232000-d0242000
> [25736.887709] etracer:9735 freeing invalid memtype d0242000-d0252000
> [25736.887722] etracer:9735 freeing invalid memtype d0252000-d0262000
> [25736.887735] etracer:9735 freeing invalid memtype d0262000-d0272000
> [25736.887747] etracer:9735 freeing invalid memtype d0272000-d0282000
> [25736.887760] etracer:9735 freeing invalid memtype d0282000-d0292000
> [25736.887773] etracer:9735 freeing invalid memtype d0292000-d02a2000
> [25736.887786] etracer:9735 freeing invalid memtype d02a2000-d02b2000
> [25736.887799] etracer:9735 freeing invalid memtype d02b2000-d02c2000
> [25736.887812] etracer:9735 freeing invalid memtype d02c2000-d02d2000
> [25736.887824] etracer:9735 freeing invalid memtype d02d2000-d02e2000
> [25736.887837] etracer:9735 freeing invalid memtype d02e2000-d02f2000
> [25736.887850] etracer:9735 freeing invalid memtype d02f2000-d0302000
> [25745.853809] glxinfo:9737 freeing invalid memtype d0102000-d0112000
> [25745.853827] glxinfo:9737 freeing invalid memtype d0112000-d0122000
> [25745.853841] glxinfo:9737 freeing invalid memtype d0122000-d0132000
> [25745.853855] glxinfo:9737 freeing invalid memtype d0132000-d0142000
> [25745.853867] glxinfo:9737 freeing invalid memtype d0142000-d0152000
> [25745.853880] glxinfo:9737 freeing invalid memtype d0152000-d0162000
> [25745.853892] glxinfo:9737 freeing invalid memtype d0162000-d0172000
> [25745.853905] glxinfo:9737 freeing invalid memtype d0172000-d0182000
> [25745.853918] glxinfo:9737 freeing invalid memtype d0182000-d0192000
> [25745.853930] glxinfo:9737 freeing invalid memtype d0192000-d01a2000
> [25745.853943] glxinfo:9737 freeing invalid memtype d01a2000-d01b2000
> [25745.853956] glxinfo:9737 freeing invalid memtype d01b2000-d01c2000
> [25745.853968] glxinfo:9737 freeing invalid memtype d01c2000-d01d2000
> [25745.853981] glxinfo:9737 freeing invalid memtype d01d2000-d01e2000
> [25745.853994] glxinfo:9737 freeing invalid memtype d01e2000-d01f2000
> [25745.861141] glxinfo:9737 freeing invalid memtype d01f2000-d0202000
> [25745.861162] glxinfo:9737 freeing invalid memtype d0202000-d0212000
> [25745.861169] glxinfo:9737 freeing invalid memtype d0212000-d0222000
> [25745.861176] glxinfo:9737 freeing invalid memtype d0222000-d0232000
> [25745.861183] glxinfo:9737 freeing invalid memtype d0232000-d0242000
> [25745.861190] glxinfo:9737 freeing invalid memtype d0242000-d0252000
> [25745.861203] glxinfo:9737 freeing invalid memtype d0252000-d0262000
> [25745.861210] glxinfo:9737 freeing invalid memtype d0262000-d0272000
> [25745.861217] glxinfo:9737 freeing invalid memtype d0272000-d0282000
> [25745.861224] glxinfo:9737 freeing invalid memtype d0282000-d0292000
> [25745.861231] glxinfo:9737 freeing invalid memtype d0292000-d02a2000
> [25745.861238] glxinfo:9737 freeing invalid memtype d02a2000-d02b2000
> [25745.861246] glxinfo:9737 freeing invalid memtype d02b2000-d02c2000
> [25745.861253] glxinfo:9737 freeing invalid memtype d02c2000-d02d2000
> [25745.861260] glxinfo:9737 freeing invalid memtype d02d2000-d02e2000
> [25745.861267] glxinfo:9737 freeing invalid memtype d02e2000-d02f2000
> [25745.861274] glxinfo:9737 freeing invalid memtype d02f2000-d0302000
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

