Return-Path: <linux-kernel-owner+w=401wt.eu-S1756870AbYDRAI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbYDRAI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 20:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755711AbYDRAIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 20:08:18 -0400
Received: from main.gmane.org ([80.91.229.2]:47817 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755493AbYDRAIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 20:08:14 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Marcus Furlong <furlongm@hotmail.com>
Subject: Re: [BUG] 2.6.25-rc9 Oops (keyboard/mouse related)
Date: Fri, 18 Apr 2008 01:08:23 +0100
Message-ID: <fu8op2$shk$1@ger.gmane.org>
References: <fu66a8$flv$1@ger.gmane.org> <200804162116.14712.dtor@insightbb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 84-203-37-37.mysmart.ie
User-Agent: KNode/0.10.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 April 2008 02:16 in <200804162116.14712.dtor@insightbb.com>,
Dmitry Torokhov wrote:

> Hi Marcus,
> 
> On Wednesday 16 April 2008, Marcus Furlong wrote:
>> Hi,
>> 
>> I got the following oops on 2.6.25-rc9. The mouse/keyboard are
>> consistently "jerky" and unresponsive, and between 1 and 15 minutes after
>> booting the machine hangs.
>> 
>> Possibly the same on 2.6.24.*, I only tried it once and it hung and I had
>> no more time for testing until now. No problem on 2.6.23.17.
>> 
>> [ 854.789883] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>> [ 854.792850] Modules linked in: i915 drm iwl3945 mac80211 cfg80211
>> intel_agp agpgart scsi_wait_scan
>> [ 854.792850]
> 
> Hmm, it looks like the very first line or two are missing... Could I
> get the whole dmesg (so I can see exactly what kind of ALPS touchpad
> you have) please?
> 
> Thanks!
> 

Here's another one, with dmesg:


[    0.000000] Linux version 2.6.25-rc9 (root@griffith) (gcc version 4.1.2
(Gentoo 4.1.2 p1.0.2)) #2 SMP PREEMPT Wed Apr 16 22:28:08 IST 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000005f65b800 (usable)
[    0.000000]  BIOS-e820: 000000005f65b800 - 0000000060000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] 630MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] Scan SMP from c009f000 for 1024 bytes.
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   390747
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   390747
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000FBB00, 0024 (r2 DELL  )
[    0.000000] ACPI: XSDT 5F65D200, 0064 (r1 DELL    M08     27D8021C ASL       
61)
[    0.000000] ACPI: FACP 5F65D09C, 00F4 (r4 DELL    M08     27D8021C ASL       
61)
[    0.000000] ACPI: DSDT 5F65D800, 63F7 (r2 INT430 SYSFexxx     1001 INTL
20050624)
[    0.000000] ACPI: FACS 5F66C000, 0040
[    0.000000] ACPI: HPET 5F65D300, 0038 (r1 DELL    M08            1 ASL       
61)
[    0.000000] ACPI: APIC 5F65D400, 0068 (r1 DELL    M08     27D8021C ASL       
47)
[    0.000000] ACPI: ASF! 5F65D000, 007E (r32 DELL    M08     27D8021C ASL       
61)
[    0.000000] ACPI: MCFG 5F65D3C0, 003E (r16 DELL    M08     27D8021C ASL       
61)
[    0.000000] ACPI: SLIC 5F65D49C, 0176 (r1 DELL    M08     27D8021C ASL       
61)
[    0.000000] ACPI: TCPA 5F65D700, 0032 (r1                        0 ASL        
0)
[    0.000000] ACPI: SSDT 5F65B9C0, 04CC (r1  PmRef    CpuPm     3000 INTL
20050624)
[    0.000000] ACPI: DMI detected: Dell Latitude D830
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:15 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] Processor #1 6:15 APIC version 20
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 70000000 (gap:
60000000:98000000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total
pages: 387695
[    0.000000] Kernel command line: root=/dev/ram0 real_root=/dev/sda3
init=/linuxrc vga=0x31B video=vesafb:mtrr,ywrap
netconsole=eth0,514@192.168.1.100/00:12:3F:94:14:0E console=ttyS0
console=tty0
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Preemptible RCU implementation.
[    0.000000] CPU 0 irqstacks, hard=c0652000 soft=c0650000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2194.557 MHz processor.
[    0.003333] Console: colour dummy device 80x25
[    0.003333] console [tty0] enabled
[    0.003333] console [ttyS0] enabled
[    0.003333] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,
Ingo Molnar
[    0.003333] ... MAX_LOCKDEP_SUBCLASSES:    8
[    0.003333] ... MAX_LOCK_DEPTH:          48
[    0.003333] ... MAX_LOCKDEP_KEYS:        2048
[    0.003333] ... CLASSHASH_SIZE:           1024
[    0.003333] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.003333] ... MAX_LOCKDEP_CHAINS:      16384
[    0.003333] ... CHAINHASH_SIZE:          8192
[    0.003333]  memory used by lock dependency info: 992 kB
[    0.003333]  per task-struct memory footprint: 1920 bytes
[    0.003333] Dentry cache hash table entries: 131072 (order: 7, 524288
bytes)
[    0.003333] Inode-cache hash table entries: 65536 (order: 6, 262144
bytes)
[    0.003333] Memory: 1540072k/1562988k available (3565k kernel code,
21724k reserved, 1567k data, 272k init, 645484k highmem)
[    0.003333] virtual kernel memory layout:
[    0.003333]     fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
[    0.003333]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.003333]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    0.003333]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.003333]       .init : 0xc0609000 - 0xc064d000   ( 272 kB)
[    0.003333]       .data : 0xc047b4ce - 0xc0603128   (1567 kB)
[    0.003333]       .text : 0xc0100000 - 0xc047b4ce   (3565 kB)
[    0.003333] Checking if this processor honours the WP bit even in
supervisor mode...Ok.
[    0.003333] SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4,
CPUs=2, Nodes=1
[    0.083332] Calibrating delay using timer specific routine.. 4396.54
BogoMIPS (lpj=7324079)
[    0.090058] Mount-cache hash table entries: 512
[    0.093992] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.099998] CPU: L2 cache: 4096K
[    0.103331] CPU: Physical Processor ID: 0
[    0.106664] CPU: Processor Core ID: 0
[    0.109998] Intel machine check architecture supported.
[    0.113331] Intel machine check reporting enabled on CPU#0.
[    0.116663] using mwait in idle threads.
[    0.120000] Compat vDSO mapped to ffffe000.
[    0.123333] Checking 'hlt' instruction... OK.
[    0.143702] ACPI: Core revision 20070126
[    0.160107] CPU0: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz
stepping 0a
[    0.170037] lockdep: fixing up alternatives.
[    0.173327] Booting processor 1/1 ip 4000
[    0.176660] CPU 1 irqstacks, hard=c0653000 soft=c0651000
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 4390.90
BogoMIPS (lpj=7315050)
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 4096K
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] Intel machine check architecture supported.
[    0.003333] Intel machine check reporting enabled on CPU#1.
[    0.277228] CPU1: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz
stepping 0a
[    0.286662] Total of 2 processors activated (8786.45 BogoMIPS).
[    0.290197] ENABLING IO-APIC IRQs
[    0.293546] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.333311] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.333339] Brought up 2 CPUs
[    0.340239] net_namespace: 220 bytes
[    0.343711] NET: Registered protocol family 16
[    0.350150] ACPI: ACPI Dock Station Driver 
[    0.353515] ACPI: bus type pci registered
[    0.356691] PCI: Using MMCONFIG for extended config space
[    0.359994] PCI: Using configuration type 1
[    0.363327] Setting up standard PCI resources
[    0.380156] ACPI: BIOS _OSI(Linux) query ignored via DMI
[    0.383331] ACPI: If "acpi_osi=Linux" works better, please notify
linux-acpi@vger.kernel.org
[    0.416687] ACPI: SSDT 5F66C080, 0043 (r1  LMPWR  DELLLOM     1001 INTL
20050624)
[    0.425597] ACPI: Interpreter enabled
[    0.426657] ACPI: (supports S0 S3 S5)
[    0.439988] ACPI: Using IOAPIC for interrupt routing
[    0.506309] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.508177] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6
ACPI/GPIO/TCO
[    0.509987] pci 0000:00:1f.0: quirk: region 1080-10bf claimed by ICH6
GPIO
[    0.514724] PCI: Transparent bridge - 0000:00:1e.0
[    0.543664] ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 *11)
[    0.556813] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *10
[    0.568878] ACPI: PCI Interrupt Link [LNKC] (IRQs 9 10 11) *0, disabled.
[    0.585563] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 9 10 11) *3
[    0.605565] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11 12
14 15)
[    0.635561] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *9 10 11 12
14 15)
[    0.668892] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 9 10 11 12
14 15)
[    0.702201] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14
15) *0, disabled.
[    0.742331] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.743364] pnp: PnP ACPI init
[    0.746657] ACPI: bus type pnp registered
[    0.828475] pnp: PnP ACPI: found 14 devices
[    0.829964] ACPI: ACPI bus type pnp unregistered
[    0.833593] SCSI subsystem initialized
[    0.836992] usbcore: registered new interface driver usbfs
[    0.840032] usbcore: registered new interface driver hub
[    0.843385] usbcore: registered new device driver usb
[    0.846948] PCI: Using ACPI for IRQ routing
[    0.849962] PCI: If a device doesn't work, try "pci=routeirq".  If it
helps, post a report
[    0.866703] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.879960] hpet0: 3 64-bit timers, 14318180 Hz
[    0.906665] system 00:05: ioport range 0xc80-0xcaf has been reserved
[    0.909964] system 00:05: ioport range 0xcc0-0xcff could not be reserved
[    0.913305] system 00:08: iomem range 0xfed00000-0xfed003ff has been
reserved
[    0.916633] system 00:0a: ioport range 0xcb0-0xcbb has been reserved
[    0.919960] system 00:0a: iomem range 0xfed40000-0xfed44fff could not be
reserved
[    0.923299] system 00:0b: ioport range 0x900-0x97f has been reserved
[    0.926625] system 00:0b: ioport range 0x4d0-0x4d1 has been reserved
[    0.929958] system 00:0b: ioport range 0x1000-0x1005 has been reserved
[    0.933293] system 00:0b: ioport range 0x1008-0x100f has been reserved
[    0.936631] system 00:0c: ioport range 0xf400-0xf4fe has been reserved
[    0.939958] system 00:0c: ioport range 0x1006-0x1007 has been reserved
[    0.943291] system 00:0c: ioport range 0x100a-0x1059 could not be
reserved
[    0.946623] system 00:0c: ioport range 0x1060-0x107f has been reserved
[    0.949957] system 00:0c: ioport range 0x1080-0x10bf has been reserved
[    0.953292] system 00:0c: ioport range 0x10c0-0x10df has been reserved
[    0.956623] system 00:0c: ioport range 0x1010-0x102f has been reserved
[    0.959956] system 00:0c: ioport range 0x809-0x809 has been reserved
[    0.963297] system 00:0d: iomem range 0x0-0x9efff could not be reserved
[    0.966623] system 00:0d: iomem range 0x9f000-0x9ffff could not be
reserved
[    0.969956] system 00:0d: iomem range 0xc0000-0xcffff could not be
reserved
[    0.973288] system 00:0d: iomem range 0xe0000-0xfffff could not be
reserved
[    0.976624] system 00:0d: iomem range 0x100000-0x5f65b7ff could not be
reserved
[    0.979955] system 00:0d: iomem range 0x5f65b800-0x5f6fffff could not be
reserved
[    0.983288] system 00:0d: iomem range 0x5f700000-0x5f7fffff could not be
reserved
[    0.986621] system 00:0d: iomem range 0x5f700000-0x5fefffff could not be
reserved
[    0.989955] system 00:0d: iomem range 0xffe00000-0xffffffff could not be
reserved
[    0.993289] system 00:0d: iomem range 0xffa00000-0xffbfffff has been
reserved
[    0.996621] system 00:0d: iomem range 0xfec00000-0xfec0ffff could not be
reserved
[    0.999954] system 00:0d: iomem range 0xfee00000-0xfee0ffff could not be
reserved
[    1.003287] system 00:0d: iomem range 0xfed20000-0xfed3ffff could not be
reserved
[    1.006620] system 00:0d: iomem range 0xfed45000-0xfed8ffff could not be
reserved
[    1.009953] system 00:0d: iomem range 0xfeda0000-0xfeda3fff could not be
reserved
[    1.013288] system 00:0d: iomem range 0xfeda4000-0xfeda4fff could not be
reserved
[    1.016619] system 00:0d: iomem range 0xfeda5000-0xfeda5fff could not be
reserved
[    1.019952] system 00:0d: iomem range 0xfeda6000-0xfeda6fff has been
reserved
[    1.023285] system 00:0d: iomem range 0xfed18000-0xfed1bfff could not be
reserved
[    1.026618] system 00:0d: iomem range 0xf8000000-0xfbffffff could not be
reserved
[    1.061281] PCI: Bridge: 0000:00:1c.0
[    1.063281]   IO window: disabled.
[    1.066621]   MEM window: disabled.
[    1.069952]   PREFETCH window: disabled.
[    1.073290] PCI: Bridge: 0000:00:1c.1
[    1.076613]   IO window: disabled.
[    1.079953]   MEM window: 0xfe800000-0xfe8fffff
[    1.083284]   PREFETCH window: disabled.
[    1.086621] PCI: Bridge: 0000:00:1c.3
[    1.089949]   IO window: d000-dfff
[    1.093286]   MEM window: 0xfe600000-0xfe7fffff
[    1.096619]   PREFETCH window: 0x00000000f0000000-0x00000000f01fffff
[    1.099954] PCI: Bridge: 0000:00:1c.5
[    1.103279]   IO window: disabled.
[    1.106618]   MEM window: 0xfe500000-0xfe5fffff
[    1.109949]   PREFETCH window: disabled.
[    1.113297] PCI: Bus 4, cardbus bridge: 0000:03:01.0
[    1.116612]   IO window: 0x00002000-0x000020ff
[    1.119949]   IO window: 0x00002400-0x000024ff
[    1.123282]   PREFETCH window: 0x70000000-0x73ffffff
[    1.126617]   MEM window: 0x74000000-0x77ffffff
[    1.129948] PCI: Bridge: 0000:00:1e.0
[    1.133288]   IO window: 2000-2fff
[    1.136616]   MEM window: 0xfe400000-0xfe4fffff
[    1.139947]   PREFETCH window: 0x0000000070000000-0x0000000073ffffff
[    1.143318] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) ->
IRQ 16
[    1.149982] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) ->
IRQ 17
[    1.156647] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) ->
IRQ 19
[    1.163312] ACPI: PCI Interrupt 0000:00:1c.5[B] -> GSI 17 (level, low) ->
IRQ 17
[    1.169987] PCI: Enabling device 0000:03:01.0 (0000 -> 0003)
[    1.173277] ACPI: PCI Interrupt 0000:03:01.0[A] -> GSI 19 (level, low) ->
IRQ 19
[    1.179957] NET: Registered protocol family 2
[    1.243386] IP route cache hash table entries: 32768 (order: 5, 131072
bytes)
[    1.247052] TCP established hash table entries: 131072 (order: 8, 1048576
bytes)
[    1.250298] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    1.261612] TCP: Hash tables configured (established 131072 bind 65536)
[    1.263290] TCP reno registered
[    1.286929] checking if image is initramfs... it is
[    1.338171] debug: unmapping init memory f7f4a000..f7ff0000
[    8.277548] Machine check exception polling timer started.
[    8.279862] IA-32 Microcode Update Driver: v1.14a
<tigran@aivazian.fsnet.co.uk>
[    8.283729] highmem bounce pool size: 64 pages
[    8.294429] fuse init (API version 7.9)
[    8.297019] Block layer SCSI generic (bsg) driver version 0.4 loaded
(major 254)
[    8.299488] io scheduler noop registered
[    8.302824] io scheduler cfq registered (default)
[    8.306613] vesafb: framebuffer at 0xe0000000, mapped to 0xf8880000,
using 7616k, total 7616k
[    8.309476] vesafb: mode is 1280x1024x32, linelength=5120, pages=0
[    8.312808] vesafb: scrolling: redraw
[    8.316143] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    8.363364] Console: switching to colour frame buffer device 160x64
[    8.402805] fb0: VESA VGA frame buffer device
[    8.406525] ACPI: AC Adapter [AC] (off-line)
[    8.443472] ACPI: Battery Slot [BAT0] (battery present)
[    8.446200] ACPI: Battery Slot [BAT1] (battery absent)
[    8.449729] input: Lid Switch
as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    8.453371] ACPI: Lid Switch [LID]
[    8.456286] input: Power Button (CM)
as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    8.459489] ACPI: Power Button (CM) [PBTN]
[    8.462927] input: Sleep Button (CM)
as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    8.466134] ACPI: Sleep Button (CM) [SBTN]
[    8.470257] ACPI: SSDT 5F65C4F6, 0286 (r1  PmRef  Cpu0Ist     3000 INTL
20050624)
[    8.479878] ACPI: SSDT 5F65BE8C, 05E5 (r1  PmRef  Cpu0Cst     3001 INTL
20050624)
[    3.056094] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    3.069772] ACPI: ACPI0007:00 is registered as cooling_device0
[    3.069822] ACPI: Processor [CPU0] (supports 8 throttling states)
[    3.083169] ACPI: SSDT 5F65C77C, 00C4 (r1  PmRef  Cpu1Ist     3000 INTL
20050624)
[    3.093208] ACPI: SSDT 5F65C471, 0085 (r1  PmRef  Cpu1Cst     3000 INTL
20050624)
[    8.842550] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    8.856186] ACPI: ACPI0007:01 is registered as cooling_device1
[    8.859457] ACPI: Processor [CPU1] (supports 8 throttling states)
[    8.900381] ACPI: LNXTHERM:01 is registered as thermal_zone0
[    8.906902] ACPI: Thermal Zone [THM] (64 C)
[    8.943014] Real Time Clock Driver v1.12ac
[    8.946384] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ
sharing disabled
[    8.949696] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    8.956249] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    8.961189] brd: module loaded
[    8.963526] loop: module loaded
[    8.966277] tg3.c:v3.89 (April 03, 2008)
[    8.969462] ACPI: PCI Interrupt 0000:09:00.0[A] -> GSI 17 (level, low) ->
IRQ 17
[    8.997057] eth0: Tigon3 [partno(BCM95755m) rev a002 PHY(5755)] (PCI
Express) 10/100/1000Base-T Ethernet 00:1c:23:97:5c:3e
[    8.999435] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1]
TSOcap[1]
[    9.002781] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    9.006183] tun: Universal TUN/TAP device driver, 1.6
[    9.009433] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    9.012852] netconsole: couldn't parse config at 00:12:3F:94:14:0E!
[    9.016099] netconsole: cleaning up
[    9.019615] Driver 'sd' needs updating - please use bus_type methods
[    9.022842] Driver 'sr' needs updating - please use bus_type methods
[    9.026339] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) ->
IRQ 16
[    9.032996] scsi0 : ata_piix
[    9.036238] scsi1 : ata_piix
[    9.044592] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x6fa0 irq
14
[    9.046098] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x6fa8 irq
15
[    5.136861] ata1.00: ATAPI: HL-DT-ST DVD+/-RW GSA-T11N, A103, max UDMA/33
[    5.150080] ata1.00: configured for UDMA/33
[    9.116087] scsi 0:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GSA-T11N
A103 PQ: 0 ANSI: 5
[    9.125227] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    9.126107] Uniform CD-ROM driver Revision: 3.20
[    9.129945] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    9.133125] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, low) ->
IRQ 17
[    9.139426] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    9.166170] scsi2 : ata_piix
[    9.172828] scsi3 : ata_piix
[    9.178561] ata3: SATA max UDMA/133 cmd 0x6eb0 ctl 0x6eb8 bmdma 0x6ee0
irq 17
[    9.179442] ata4: SATA max UDMA/133 cmd 0x6ec0 ctl 0x6ec8 bmdma 0x6ee8
irq 17
[    5.933038] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    9.252745] ata3.00: ATA-7: ST9160823AS, 3.AAB, max UDMA/133
[    9.252749] ata3.00: 312581808 sectors, multi 8: LBA48 NCQ (depth 0/32)
[    6.036288] ata3.00: configured for UDMA/133
[    6.079667] ata4: SATA link down (SStatus 0 SControl 0)
[    9.343972] scsi 2:0:0:0: Direct-Access     ATA      ST9160823AS     
3.AA PQ: 0 ANSI: 5
[    9.346423] sd 2:0:0:0: [sda] 312581808 512-byte hardware sectors (160042
MB)
[    9.349454] sd 2:0:0:0: [sda] Write Protect is off
[    9.352795] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[    9.356517] sd 2:0:0:0: [sda] 312581808 512-byte hardware sectors (160042
MB)
[    9.359448] sd 2:0:0:0: [sda] Write Protect is off
[    9.362788] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[    9.366075]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
[    9.410423] sd 2:0:0:0: [sda] Attached SCSI disk
[    9.412883] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    9.416384] ACPI: PCI Interrupt 0000:03:01.4[A] -> GSI 19 (level, low) ->
IRQ 19
[    9.432744] firewire_ohci: Added fw-ohci device 0000:03:01.4, OHCI
version 1.10
[    9.436407] Yenta: CardBus bridge found at 0000:03:01.0 [1028:01fe]
[    9.439443] Yenta O2: res at 0x94/0xD4: 00/ea
[    9.442736] Yenta O2: enabling read prefetch/write burst
[    9.456293] Yenta: ISA IRQ mask 0x0cb8, PCI irq 19
[    9.459403] Socket status: 30000006
[    9.462750] Yenta: Raising subordinate bus# of parent bus (#03) from #04
to #07
[    9.466413] pcmcia: parent PCI bridge I/O window: 0x2000 - 0x2fff
[    9.469438] firewire_core: created device fw0: GUID 4a4fc00025927850,
S400
[    7.642888] pcmcia: parent PCI bridge Memory window: 0xfe400000 -
0xfe4fffff
[    7.646189] pcmcia: parent PCI bridge Memory window: 0x70000000 -
0x73ffffff
[    7.659516] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 22 (level, low) ->
IRQ 22
[    7.662864] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    7.666859] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus
number 1
[    7.675519] ehci_hcd 0000:00:1a.7: debug port 1
[    7.676204] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
[    7.686191] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10
Dec 2004
[    7.690032] usb usb1: configuration #1 chosen from 1 choice
[    7.693008] hub 1-0:1.0: USB hub found
[    7.696237] hub 1-0:1.0: 4 ports detected
[    7.703092] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    7.706189] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    7.709516] usb usb1: Product: EHCI Host Controller
[    7.709517] usb usb1: Manufacturer: Linux 2.6.25-rc9 ehci_hcd
[    7.709519] usb usb1: SerialNumber: 0000:00:1a.7
[    7.709564] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) ->
IRQ 20
[    7.709578] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    7.709681] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus
number 2
[    7.715942] ehci_hcd 0000:00:1d.7: debug port 1
[    7.715962] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
[   10.549395] usb 1-1: new high speed USB device using ehci_hcd and address
2
[    8.452806] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10
Dec 2004
[    8.456435] usb usb2: configuration #1 chosen from 1 choice
[    8.459562] hub 2-0:1.0: USB hub found
[    8.462824] hub 2-0:1.0: 6 ports detected
[   10.862640] usb 1-1: configuration #1 chosen from 1 choice
[   10.867238] usb 1-1: New USB device found, idVendor=0bda, idProduct=0158
[   10.869314] usb 1-1: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[    8.562953] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    8.562955] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    8.562957] usb usb2: Product: EHCI Host Controller
[    8.562959] usb usb2: Manufacturer: Linux 2.6.25-rc9 ehci_hcd
[    8.562960] usb usb2: SerialNumber: 0000:00:1d.7
[    8.563045] USB Universal Host Controller Interface driver v3.0
[    8.563079] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 20 (level, low) ->
IRQ 20
[    8.563093] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    8.563210] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus
number 3
[    8.563242] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f20
[    8.563536] usb usb3: configuration #1 chosen from 1 choice
[    8.563632] hub 3-0:1.0: USB hub found
[    8.563682] hub 3-0:1.0: 2 ports detected
[   10.872659] usb 1-1: Product: USB2.0-CRW
[    9.709546] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    9.709548] usb usb3: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    9.709550] usb usb3: Product: UHCI Host Controller
[    9.709552] usb usb3: Manufacturer: Linux 2.6.25-rc9 uhci_hcd
[    9.709553] usb usb3: SerialNumber: 0000:00:1a.0
[    9.709588] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) ->
IRQ 21
[    9.709601] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    9.709697] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus
number 4
[    9.709735] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f00
[    9.710081] usb usb4: configuration #1 chosen from 1 choice
[    9.710182] hub 4-0:1.0: USB hub found
[    9.710193] hub 4-0:1.0: 2 ports detected
[   10.875991] usb 1-1: Manufacturer: Generic
[   10.729513] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   10.729516] usb usb4: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[   10.729518] usb usb4: Product: UHCI Host Controller
[   10.729519] usb usb4: Manufacturer: Linux 2.6.25-rc9 uhci_hcd
[   10.729521] usb usb4: SerialNumber: 0000:00:1a.1
[   10.729555] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) ->
IRQ 20
[   10.729568] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   10.729664] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus
number 5
[   10.729697] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f80
[   10.729990] usb usb5: configuration #1 chosen from 1 choice
[   10.730079] hub 5-0:1.0: USB hub found
[   10.730092] hub 5-0:1.0: 2 ports detected
[   10.879317] usb 1-1: SerialNumber: 20060413092100000
[   11.742785] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   11.742787] usb usb5: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[   11.742789] usb usb5: Product: UHCI Host Controller
[   11.742790] usb usb5: Manufacturer: Linux 2.6.25-rc9 uhci_hcd
[   11.742792] usb usb5: SerialNumber: 0000:00:1d.0
[   11.742821] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 21 (level, low) ->
IRQ 21
[   11.742835] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   11.742929] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus
number 6
[   11.742961] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f60
[   11.743254] usb usb6: configuration #1 chosen from 1 choice
[   11.743342] hub 6-0:1.0: USB hub found
[   11.743353] hub 6-0:1.0: 2 ports detected
[   12.769402] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[   12.772536] usb usb6: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[   12.775889] usb usb6: Product: UHCI Host Controller
[   12.779186] usb usb6: Manufacturer: Linux 2.6.25-rc9 uhci_hcd
[   12.779188] usb usb6: SerialNumber: 0000:00:1d.1
[   12.779219] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 22 (level, low) ->
IRQ 22
[   12.779232] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   13.102374] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus
number 7
[   13.102558] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
[   13.109192] usb usb7: configuration #1 chosen from 1 choice
[   13.112605] hub 7-0:1.0: USB hub found
[   13.115840] hub 7-0:1.0: 2 ports detected
[   13.129296] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[   13.132500] usb usb7: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[   13.135829] usb usb7: Product: UHCI Host Controller
[   13.135830] usb usb7: Manufacturer: Linux 2.6.25-rc9 uhci_hcd
[   13.135832] usb usb7: SerialNumber: 0000:00:1d.2
[   11.735943] usb 7-1: new full speed USB device using uhci_hcd and address
2
[   13.475803] usb 7-1: configuration #1 chosen from 1 choice
[   11.845575] hub 7-1:1.0: USB hub found
[   13.537568] hub 7-1:1.0: 4 ports detected
[   13.552619] usb 7-1: New USB device found, idVendor=0b97, idProduct=7761
[   13.555843] usb 7-1: New USB device strings: Mfr=0, Product=0,
SerialNumber=0
[   13.595808] usb 7-2: new full speed USB device using uhci_hcd and address
3
[   12.129224] usb 7-2: configuration #1 chosen from 1 choice
[   13.695211] usb 7-2: New USB device found, idVendor=0483, idProduct=2016
[   13.695815] usb 7-2: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[   13.699136] usb 7-2: Product: Biometric Coprocessor
[   13.702489] usb 7-2: Manufacturer: STMicroelectronics
[   13.705881] usbcore: registered new interface driver usblp
[   13.709153] Initializing USB Mass Storage driver...
[   13.712555] scsi4 : SCSI emulation for USB Mass Storage devices
[   13.739119] usb 7-1.2: new full speed USB device using uhci_hcd and
address 4
[   13.749119] usb 7-1.2: configuration #1 chosen from 1 choice
[   12.774411] usb 7-1.2: New USB device found, idVendor=0b97,
idProduct=7772
[   12.775856] usb 7-1.2: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[   12.779189] usb 7-1.2: Product: O2Micro CCID SC Reader
[   12.782519] usb 7-1.2: Manufacturer: O2
[   14.081881] usbcore: registered new interface driver usb-storage
[   14.082448] USB Mass Storage support registered.
[   14.085861] usbcore: registered new interface driver libusual
[   14.092593] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64
irq 1,12
[   14.099096] serio: i8042 KBD port at 0x60,0x64 irq 1
[   14.099130] serio: i8042 AUX port at 0x60,0x64 irq 12
[   14.102562] mice: PS/2 mouse device common for all mice
[   14.161474] input: AT Translated Set 2 keyboard
as /devices/platform/i8042/serio0/input/input3
[   14.203635] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   13.656067] input: PS/2 Mouse
as /devices/platform/i8042/serio1/input/input5
[   14.451574] input: AlpsPS/2 ALPS GlidePoint
as /devices/platform/i8042/serio1/input/input6
[   14.487697] cpuidle: using governor ladder
[   14.493107] cpuidle: using governor menu
[   13.954537] Marking TSC unstable due to: TSC halts in idle.
[   14.577322] usbcore: registered new interface driver usbhid
[   14.579096] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   14.582542] Advanced Linux Sound Architecture Driver Version 1.0.16rc2
(Thu Jan 31 16:40:16 2008 UTC).
[   14.586110] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 21 (level, low) ->
IRQ 21
[   14.684469] ALSA device list:
[   14.685396]   #0: HDA Intel at 0xfe9fc000 irq 21
[   14.689545] TCP cubic registered
[   14.692078] NET: Registered protocol family 1
[   14.695413] NET: Registered protocol family 17
[   14.699211] RPC: Registered udp transport module.
[   14.702063] RPC: Registered tcp transport module.
[   14.709440] Starting balanced_irq
[   14.712132] Using IPI No-Shortcut mode
[   14.716595] debug: unmapping init memory c0609000..c064d000

[  244.984267] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  244.985108] Modules linked in: i915 drm iwl3945 mac80211 cfg80211
intel_agp agpgart scsi_wait_scan
[  244.985108] 
[  244.985108] Pid: 0, comm: swapper Not tainted (2.6.25-rc9 #2)
[  244.985108] EIP: 0060:[<c039e62f>] EFLAGS: 00010093 CPU: 0
[  244.985108] EIP is at alps_process_byte+0x1f/0x80
[  244.985108] EAX: 00000000 EBX: f6c93880 ECX: f6a75a00 EDX: 00000000
[  244.985108] ESI: f6a75a00 EDI: f7ba8000 EBP: c0652f2c ESP: c0652f28
[  244.985108]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  244.985108] Process swapper (pid: 0, ti=c0652000 task=c05a33c0
task.ti=c0604000)
[  244.985108] Stack: f6a75a00 c0652f48 c039baef 00000000 00000002 00000001
c0391d71 00000000 
[  244.985108]        c0652f70 c039c378 00000000 c0652f70 c047a00a 00000000
00000002 f7ba8000 
[  244.985108]        c05c8560 00000000 c0652f90 c0391d89 00000092 f7ba804c
00000096 00000000 
[  244.985108] Call Trace:
[  244.985108]  [<c039baef>] ? psmouse_handle_byte+0xf/0x110
[  244.985108]  [<c0391d71>] ? serio_interrupt+0x21/0x80
[  244.985108]  [<c039c378>] ? psmouse_interrupt+0xc8/0x2a0
[  244.985108]  [<c047a00a>] ? _spin_lock_irqsave+0x4a/0x60
[  244.985108]  [<c0391d89>] ? serio_interrupt+0x39/0x80
[  244.985108]  [<c0392a69>] ? i8042_interrupt+0x109/0x250
[  244.985108]  [<c0157c78>] ? handle_IRQ_event+0x28/0x60
[  244.985108]  [<c01590d3>] ? handle_edge_irq+0xb3/0x140
[  244.985108]  [<c0159020>] ? handle_edge_irq+0x0/0x140
[  244.985108]  [<c010738b>] ? do_IRQ+0x8b/0xf0
[  244.985108]  [<c011e37a>] ? update_rq_clock+0x1a/0x20
[  244.985108]  [<c0104c12>] ? common_interrupt+0x2e/0x34
[  244.985108]  [<c01400d8>] ? posix_cpu_timer_set+0x368/0x430
[  244.985108]  [<c02e9271>] ? acpi_idle_enter_simple+0x18c/0x1fb
[  244.985108]  [<c02e8e9c>] ? acpi_idle_enter_bm+0xbf/0x308
[  244.985108]  [<c03a6fe5>] ? menu_select+0x85/0xa0
[  244.985108]  [<c03a623b>] ? cpuidle_idle_call+0x6b/0xc0
[  244.985108]  [<c03a61d0>] ? cpuidle_idle_call+0x0/0xc0
[  244.985108]  [<c0102b6e>] ? cpu_idle+0x5e/0xf0
[  244.985108]  [<c046384d>] ? rest_init+0x5d/0x60
[  244.985108]  =======================
[  244.985108] Code: b6 00 00 00 00 8d bc 27 00 00 00 00 55 89 c1 89 e5 53
0f b6 90 a0 00 00 00 8b 18 0f b6 c2 25 c8 00 00 00 83 f8 08 74 37 8b 43 24
<22> 50 04 3a 50 03 74 09 5b 31 c0 5d c3 8d 74 26 00 0f b6 91 a9 
[  244.985108] EIP: [<c039e62f>] alps_process_byte+0x1f/0x80 SS:ESP
0068:c0652f28
[  244.985108] Kernel panic - not syncing: Fatal exception in interrupt
[  244.985108] BUG: unable to handle kernel NULL pointer dereference at
00000000
[  244.985108] IP: [<00000000>]
[  244.985108] *pde = 00000000 
[  244.985108] Oops: 0000 [#2] PREEMPT SMP DEBUG_PAGEALLOC
[  244.985108] Modules linked in: i915 drm iwl3945 mac80211 cfg80211
intel_agp agpgart scsi_wait_scan
[  244.985108] 
[  244.985108] Pid: 0, comm: swapper Tainted: G      D  (2.6.25-rc9 #2)
[  244.985108] EIP: 0060:[<00000000>] EFLAGS: 00010046 CPU: 0
[  244.985108] EIP is at 0x0
[  244.985108] EAX: ffffffff EBX: c064c2c0 ECX: 00000000 EDX: c064c3c0
[  244.985108] ESI: 00000000 EDI: ffff007b EBP: c0652e30 ESP: c0652e20
[  244.985108]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  244.985108] Process swapper (pid: 0, ti=c0652000 task=c05a33c0
task.ti=c0604000)
[  244.985108] Stack: c011353a 00000006 00000000 ffffffff c0652e84 c0104cbb
00000006 015bf000 
[  244.985108]        c05a33c0 00000000 ffffffff c0652e85 00000000 ffff007b
c065007b c01400d8 
[  244.985108]        ffffff04 c012a754 00000060 00000246 c0539588 c06632a0
c0652e90 00000006 
[  244.985108] Call Trace:
[  244.985108]  [<c011353a>] ? smp_call_function_interrupt+0x4a/0x90
[  244.985108]  [<c0104cbb>] ? call_function_interrupt+0x33/0x38
[  244.985108]  [<c01400d8>] ? posix_cpu_timer_set+0x368/0x430
[  244.985108]  [<c012a754>] ? panic+0xe4/0x120
[  244.985108]  [<c01058b4>] ? die+0x134/0x150
[  244.985108]  [<c0118f8f>] ? do_page_fault+0x27f/0x630
[  244.985108]  [<c014c7da>] ? __lock_acquire+0x34a/0x1000
[  244.985108]  [<c0118d10>] ? do_page_fault+0x0/0x630
[  244.985108]  [<c047a6ca>] ? error_code+0x72/0x78
[  244.985108]  [<c039e62f>] ? alps_process_byte+0x1f/0x80
[  244.985108]  [<c039baef>] ? psmouse_handle_byte+0xf/0x110
[  244.985108]  [<c0391d71>] ? serio_interrupt+0x21/0x80
[  244.985108]  [<c039c378>] ? psmouse_interrupt+0xc8/0x2a0
[  244.985108]  [<c047a00a>] ? _spin_lock_irqsave+0x4a/0x60
[  244.985108]  [<c0391d89>] ? serio_interrupt+0x39/0x80
[  244.985108]  [<c0392a69>] ? i8042_interrupt+0x109/0x250
[  244.985109]  [<c0157c78>] ? handle_IRQ_event+0x28/0x60
[  244.985109]  [<c01590d3>] ? handle_edge_irq+0xb3/0x140
[  244.985109]  [<c0159020>] ? handle_edge_irq+0x0/0x140
[  244.985109]  [<c010738b>] ? do_IRQ+0x8b/0xf0
[  244.985109]  [<c011e37a>] ? update_rq_clock+0x1a/0x20
[  244.985109]  [<c0104c12>] ? common_interrupt+0x2e/0x34
[  244.985109]  [<c01400d8>] ? posix_cpu_timer_set+0x368/0x430
[  244.985109]  [<c02e9271>] ? acpi_idle_enter_simple+0x18c/0x1fb
[  244.985109]  [<c02e8e9c>] ? acpi_idle_enter_bm+0xbf/0x308
[  244.985109]  [<c03a6fe5>] ? menu_select+0x85/0xa0
[  244.985109]  [<c03a623b>] ? cpuidle_idle_call+0x6b/0xc0
[  244.985109]  [<c03a61d0>] ? cpuidle_idle_call+0x0/0xc0
[  244.985109]  [<c0102b6e>] ? cpu_idle+0x5e/0xf0
[  244.985109]  [<c046384d>] ? rest_init+0x5d/0x60
[  244.985109]  =======================
[  244.985109] Code:  Bad EIP value.
[  244.985109] EIP: [<00000000>] 0x0 SS:ESP 0068:c0652e20
[  244.985109] Kernel panic - not syncing: Fatal exception in interrupt

