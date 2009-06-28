Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbZF1RVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbZF1RVH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 13:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbZF1RU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 13:20:56 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:30223 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbZF1RUu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 13:20:50 -0400
Date: Sun, 28 Jun 2009 11:20:52 -0600
From: Alex Chiang <achiang@hp.com>
To: Stephen Frost <sfrost@snowman.net>
Cc: linux-kernel@vger.kernel.org, Daniel Frazier <daniel_frazier@hp.com>,
       David Altobelli <david.altobelli@hp.com>, nagananda.chumbalkar@hp.com
Subject: Re: ACPI issues on HP DL585 G2
Message-ID: <20090628172052.GA13957@ldl.fc.hp.com>
References: <20090628034038.GK20436@tamriel.snowman.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20090628034038.GK20436@tamriel.snowman.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm just scanning mail on the weekend, but what version of the
BIOS are you on? Do you have the latest?

Thanks.

/ac

* Stephen Frost <sfrost@snowman.net>:
> Greetings,
> 
>   When running pretty much anything newer than 2.6.22, both the cciss
>   module and the bnx2 module get stuck in a "Loading" state in
>   /proc/modules.  As cciss contains my root partition, I get dropped
>   into an initrd after a while because root can't be found.  After some
>   googleing, etc, I saw a bunch of recommendations to add
>   "pci=noapic noapic" to the command-line.  After I did that, the box
>   booted fine under 2.6.29.  I figured people might like to hear about
>   this issue though.  Attached are a dmesg from 2.6.22 and a dmesg from
>   2.6.29 (w/ the noapic options).  I've also included the output of
>   hpasmcli -s "show server".  If there's anything else that would be
>   useful to help figure this out, please let me know.
> 
>   	Thanks,
> 
> 		Stephen

> Linux version 2.6.22-3-amd64 (Debian 2.6.22-6) (maks@debian.org) (gcc version 4.1.3 20071019 (prerelease) (Debian 4.1.2-17)) #1 SMP Sun Nov 4 18:18:09 UTC 2007
> Command line: root=/dev/cciss/c0d0p1 ro 
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
>  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 000000007fe50000 (usable)
>  BIOS-e820: 000000007fe50000 - 000000007fe58000 (ACPI data)
>  BIOS-e820: 000000007fe58000 - 0000000080000000 (reserved)
>  BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
>  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
>  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
>  BIOS-e820: 0000000100000000 - 000000047ffff000 (usable)
> Entering add_active_range(0, 0, 159) 0 entries of 3200 used
> Entering add_active_range(0, 256, 523856) 1 entries of 3200 used
> Entering add_active_range(0, 1048576, 4718591) 2 entries of 3200 used
> end_pfn_map = 4718591
> DMI 2.3 present.
> ACPI: RSDP 000F4F00, 0024 (r2 HP    )
> ACPI: XSDT 7FE50780, 005C (r1 HP     A07             2   ?     162E)
> ACPI: FACP 7FE50800, 00F4 (r3 HP     A07             2   ?     162E)
> ACPI: DSDT 7FE50900, 42FF (r1 HP         DSDT        1 INTL 20030228)
> ACPI: FACS 7FE500C0, 0040
> ACPI: SPCR 7FE50100, 0050 (r1 HP     SPCRRBSU        1   ?     162E)
> ACPI: MCFG 7FE50180, 003C (r1 HP     ProLiant        1             0)
> ACPI: HPET 7FE501C0, 0038 (r1 HP     A07             2   ?     162E)
> ACPI: SPMI 7FE50200, 0040 (r5 HP     ProLiant        1   ?     162E)
> ACPI: APIC 7FE50240, 0106 (r1 HP     00000083        2             0)
> ACPI: SRAT 7FE50380, 01A0 (r1 AMD    HAMMER          1 AMD         1)
> SRAT: PXM 0 -> APIC 0 -> Node 0
> SRAT: PXM 0 -> APIC 1 -> Node 0
> SRAT: PXM 1 -> APIC 2 -> Node 1
> SRAT: PXM 1 -> APIC 3 -> Node 1
> SRAT: PXM 2 -> APIC 4 -> Node 2
> SRAT: PXM 2 -> APIC 5 -> Node 2
> SRAT: PXM 3 -> APIC 6 -> Node 3
> SRAT: PXM 3 -> APIC 7 -> Node 3
> SRAT: Node 0 PXM 0 0-a0000
> Entering add_active_range(0, 0, 159) 0 entries of 3200 used
> SRAT: Node 0 PXM 0 0-80000000
> Entering add_active_range(0, 0, 159) 1 entries of 3200 used
> Entering add_active_range(0, 256, 523856) 1 entries of 3200 used
> SRAT: Node 0 PXM 0 0-180000000
> Entering add_active_range(0, 0, 159) 2 entries of 3200 used
> Entering add_active_range(0, 256, 523856) 2 entries of 3200 used
> Entering add_active_range(0, 1048576, 1572864) 2 entries of 3200 used
> SRAT: Node 1 PXM 1 180000000-280000000
> Entering add_active_range(1, 1572864, 2621440) 3 entries of 3200 used
> SRAT: Node 2 PXM 2 280000000-380000000
> Entering add_active_range(2, 2621440, 3670016) 4 entries of 3200 used
> SRAT: Node 3 PXM 3 380000000-480000000
> Entering add_active_range(3, 3670016, 4718591) 5 entries of 3200 used
> NUMA: Using 31 for the hash shift.
> Bootmem setup node 0 0000000000000000-0000000180000000
> Bootmem setup node 1 0000000180000000-0000000280000000
> Bootmem setup node 2 0000000280000000-0000000380000000
> Bootmem setup node 3 0000000380000000-000000047ffff000
> Zone PFN ranges:
>   DMA             0 ->     4096
>   DMA32        4096 ->  1048576
>   Normal    1048576 ->  4718591
> early_node_map[6] active PFN ranges
>     0:        0 ->      159
>     0:      256 ->   523856
>     0:  1048576 ->  1572864
>     1:  1572864 ->  2621440
>     2:  2621440 ->  3670016
>     3:  3670016 ->  4718591
> On node 0 totalpages: 1048047
>   DMA zone: 56 pages used for memmap
>   DMA zone: 1034 pages reserved
>   DMA zone: 2909 pages, LIFO batch:0
>   DMA32 zone: 14280 pages used for memmap
>   DMA32 zone: 505480 pages, LIFO batch:31
>   Normal zone: 7168 pages used for memmap
>   Normal zone: 517120 pages, LIFO batch:31
> On node 1 totalpages: 1048576
>   DMA zone: 0 pages used for memmap
>   DMA32 zone: 0 pages used for memmap
>   Normal zone: 14336 pages used for memmap
>   Normal zone: 1034240 pages, LIFO batch:31
> On node 2 totalpages: 1048576
>   DMA zone: 0 pages used for memmap
>   DMA32 zone: 0 pages used for memmap
>   Normal zone: 14336 pages used for memmap
>   Normal zone: 1034240 pages, LIFO batch:31
> On node 3 totalpages: 1048575
>   DMA zone: 0 pages used for memmap
>   DMA32 zone: 0 pages used for memmap
>   Normal zone: 14335 pages used for memmap
>   Normal zone: 1034240 pages, LIFO batch:31
> ACPI: PM-Timer IO Port: 0x908
> ACPI: Local APIC address 0xfee00000
> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> Processor #0 (Bootup-CPU)
> ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
> Processor #2
> ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
> Processor #4
> ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
> Processor #6
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> Processor #1
> ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
> Processor #3
> ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
> Processor #5
> ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
> Processor #7
> ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
> ACPI: IOAPIC (id[0x08] address[0xf7cf0000] gsi_base[0])
> IOAPIC[0]: apic_id 8, address 0xf7cf0000, GSI 0-23
> ACPI: IOAPIC (id[0x09] address[0xf7fd0000] gsi_base[24])
> IOAPIC[1]: apic_id 9, address 0xf7fd0000, GSI 24-30
> ACPI: IOAPIC (id[0x0a] address[0xf7fe0000] gsi_base[31])
> IOAPIC[2]: apic_id 10, address 0xf7fe0000, GSI 31-37
> ACPI: IOAPIC (id[0x0b] address[0xf7ff0000] gsi_base[38])
> IOAPIC[3]: apic_id 11, address 0xf7ff0000, GSI 38-61
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 0 high edge)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
> ACPI: IRQ0 used by override.
> ACPI: IRQ9 used by override.
> ACPI: NMI_SRC (dfl dfl global_irq 28)
> ACPI: NMI_SRC (dfl dfl global_irq 35)
> Setting APIC routing to flat
> ACPI: HPET id: 0x10228201 base: 0xfed00000
> Using ACPI (MADT) for SMP configuration information
> swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
> swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000f0000
> swsusp: Registered nosave memory region: 00000000000f0000 - 0000000000100000
> swsusp: Registered nosave memory region: 000000007fe50000 - 000000007fe58000
> swsusp: Registered nosave memory region: 000000007fe58000 - 0000000080000000
> swsusp: Registered nosave memory region: 0000000080000000 - 00000000fec00000
> swsusp: Registered nosave memory region: 00000000fec00000 - 00000000fed00000
> swsusp: Registered nosave memory region: 00000000fed00000 - 00000000fee00000
> swsusp: Registered nosave memory region: 00000000fee00000 - 00000000fee10000
> swsusp: Registered nosave memory region: 00000000fee10000 - 00000000ffc00000
> swsusp: Registered nosave memory region: 00000000ffc00000 - 0000000100000000
> Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
> SMP: Allowing 8 CPUs, 0 hotplug CPUs
> PERCPU: Allocating 37896 bytes of per cpu data
> Built 4 zonelists.  Total pages: 4128229
> Kernel command line: root=/dev/cciss/c0d0p1 ro 
> Initializing CPU#0
> PID hash table entries: 4096 (order: 12, 32768 bytes)
> Extended CMOS year: 2000
> Marking TSC unstable due to TSCs unsynchronized
> time.c: Detected 2812.961 MHz processor.
> Console: colour VGA+ 80x25
> Checking aperture...
> CPU 0: aperture @ bde2000000 size 32 MB
> Aperture too small (32 MB)
> No AGP bridge found
> Your BIOS doesn't leave a aperture memory hole
> Please enable the IOMMU option in the BIOS setup
> This costs you 64 MB of RAM
> Mapping aperture over 65536 KB of RAM @ 4000000
> Memory: 16438940k/18874364k available (2008k kernel code, 336156k reserved, 945k data, 296k init)
> Calibrating delay using timer specific routine.. 5628.99 BogoMIPS (lpj=11257985)
> Security Framework v1.0.0 initialized
> SELinux:  Disabled at boot.
> Capability LSM initialized
> Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
> Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
> Mount-cache hash table entries: 256
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 1024K (64 bytes/line)
> CPU 0/0 -> Node 0
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> SMP alternatives: switching to UP code
> ACPI: Core revision 20070126
> Using local APIC timer interrupts.
> result 12557870
> Detected 12.557 MHz APIC timer.
> SMP alternatives: switching to SMP code
> Booting processor 1/8 APIC 0x2
> Initializing CPU#1
> Calibrating delay using timer specific routine.. 5625.95 BogoMIPS (lpj=11251900)
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 1024K (64 bytes/line)
> CPU 1/2 -> Node 1
> CPU: Physical Processor ID: 1
> CPU: Processor Core ID: 0
> Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
> SMP alternatives: switching to SMP code
> Booting processor 2/8 APIC 0x4
> Initializing CPU#2
> Calibrating delay using timer specific routine.. 5625.94 BogoMIPS (lpj=11251888)
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 1024K (64 bytes/line)
> CPU 2/4 -> Node 2
> CPU: Physical Processor ID: 2
> CPU: Processor Core ID: 0
> Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
> SMP alternatives: switching to SMP code
> Booting processor 3/8 APIC 0x6
> Initializing CPU#3
> Calibrating delay using timer specific routine.. 5626.04 BogoMIPS (lpj=11252096)
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 1024K (64 bytes/line)
> CPU 3/6 -> Node 3
> CPU: Physical Processor ID: 3
> CPU: Processor Core ID: 0
> Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
> SMP alternatives: switching to SMP code
> Booting processor 4/8 APIC 0x1
> Initializing CPU#4
> Calibrating delay using timer specific routine.. 5626.08 BogoMIPS (lpj=11252170)
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 1024K (64 bytes/line)
> CPU 4/1 -> Node 0
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 1
> Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
> SMP alternatives: switching to SMP code
> Booting processor 5/8 APIC 0x3
> Initializing CPU#5
> Calibrating delay using timer specific routine.. 5626.16 BogoMIPS (lpj=11252324)
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 1024K (64 bytes/line)
> CPU 5/3 -> Node 1
> CPU: Physical Processor ID: 1
> CPU: Processor Core ID: 1
> Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
> SMP alternatives: switching to SMP code
> Booting processor 6/8 APIC 0x5
> Initializing CPU#6
> Calibrating delay using timer specific routine.. 5626.18 BogoMIPS (lpj=11252370)
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 1024K (64 bytes/line)
> CPU 6/5 -> Node 2
> CPU: Physical Processor ID: 2
> CPU: Processor Core ID: 1
> Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
> SMP alternatives: switching to SMP code
> Booting processor 7/8 APIC 0x7
> Initializing CPU#7
> Calibrating delay using timer specific routine.. 5625.97 BogoMIPS (lpj=11251943)
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 1024K (64 bytes/line)
> CPU 7/7 -> Node 3
> CPU: Physical Processor ID: 3
> CPU: Processor Core ID: 1
> Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
> Brought up 8 CPUs
> migration_cost=458,599
> NET: Registered protocol family 16
> ACPI: bus type pci registered
> PCI: BIOS Bug: MCFG area at 80000000 is not E820-reserved
> PCI: Not using MMCONFIG.
> PCI: Using configuration type 1
> ACPI: SSDT 7FE58000, 0AC4 (r2 HP     PNOWSSDT        2 HP          1)
> ACPI: Interpreter enabled
> ACPI: (supports S0 S4 S5)
> ACPI: Using IOAPIC for interrupt routing
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> PCI: Probing PCI hardware (bus 00)
> PCI: Transparent bridge - 0000:00:09.0
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IP2P._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE0._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE1._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE2._PRT]
> ACPI: PCI Root Bridge [PCI1] (0000:40)
> PCI: Probing PCI hardware (bus 40)
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.BRGA._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.BRGB._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE0._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE1._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE2._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE3._PRT]
> ACPI: PCI Interrupt Link [LNKW] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [LNKX] (IRQs 17) *0, disabled.
> ACPI: PCI Interrupt Link [LNKY] (IRQs 18) *0, disabled.
> ACPI: PCI Interrupt Link [LNKZ] (IRQs 19) *0, disabled.
> ACPI: PCI Interrupt Link [LNU0] (IRQs 22) *5
> ACPI: PCI Interrupt Link [LNU2] (IRQs 23) *10
> ACPI: PCI Interrupt Link [LNKA] (IRQs 54) *0, disabled.
> ACPI: PCI Interrupt Link [LNKB] (IRQs 55) *0, disabled.
> ACPI: PCI Interrupt Link [LNKC] (IRQs 56) *0, disabled.
> ACPI: PCI Interrupt Link [LNKD] (IRQs 57) *0, disabled.
> Linux Plug and Play Support v0.97 (c) Adam Belay
> pnp: PnP ACPI init
> ACPI: bus type pnp registered
> pnp: ACPI device : hid PNP0A03
> pnp: ACPI device : hid PNP0C02
> pnp: ACPI device : hid IPI0001
> pnp: ACPI device : hid PNP0103
> pnp: ACPI device : hid PNP0200
> pnp: ACPI device : hid PNP0800
> pnp: ACPI device : hid PNP0303
> pnp: ACPI device : hid PNP0F13
> pnp: ACPI device : hid PNP0A06
> pnp: ACPI device : hid PNP0501
> pnp: ACPI device : hid PNP0003
> pnp: ACPI device : hid PNP0A03
> pnp: ACPI device : hid PNP0003
> pnp: ACPI device : hid PNP0003
> pnp: ACPI device : hid PNP0003
> pnp: PnP ACPI: found 15 devices
> ACPI: ACPI bus type pnp unregistered
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> PCI: Using ACPI for IRQ routing
> PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
> NET: Registered protocol family 8
> NET: Registered protocol family 20
> PCI-DMA: Disabling AGP.
> PCI-DMA: aperture base @ 4000000 size 65536 KB
> PCI-DMA: using GART IOMMU.
> PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
> hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
> hpet0: 3 32-bit timers, 25000000 Hz
> pnp: the driver 'system' has been registered
> pnp: match found with the PnP device '00:01' and the driver 'system'
> pnp: 00:01: ioport range 0x408-0x40f has been reserved
> pnp: 00:01: ioport range 0x4d0-0x4d1 has been reserved
> pnp: 00:01: ioport range 0x700-0x73f has been reserved
> pnp: 00:01: iomem range 0x80000000-0x8fffffff has been reserved
> PCI: Bridge: 0000:00:09.0
>   IO window: 2000-3fff
>   MEM window: f7d00000-f7efffff
>   PREFETCH window: e8000000-efffffff
> PCI: Bridge: 0000:00:0c.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:0d.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:0e.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Setting latency timer of device 0000:00:09.0 to 64
> PCI: Setting latency timer of device 0000:00:0c.0 to 64
> PCI: Setting latency timer of device 0000:00:0d.0 to 64
> PCI: Setting latency timer of device 0000:00:0e.0 to 64
> PCI: Bridge: 0000:40:0b.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:40:0c.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:40:0d.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:40:0e.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:40:10.0
>   IO window: disabled.
>   MEM window: f8000000-fbffffff
>   PREFETCH window: 90000000-900fffff
> PCI: Bridge: 0000:40:11.0
>   IO window: 4000-4fff
>   MEM window: fdf00000-fdffffff
>   PREFETCH window: 90100000-901fffff
> PCI: Setting latency timer of device 0000:40:0b.0 to 64
> PCI: Setting latency timer of device 0000:40:0c.0 to 64
> PCI: Setting latency timer of device 0000:40:0d.0 to 64
> PCI: Setting latency timer of device 0000:40:0e.0 to 64
> NET: Registered protocol family 2
> Time: hpet clocksource has been installed.
> IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
> TCP established hash table entries: 2097152 (order: 13, 50331648 bytes)
> TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> TCP: Hash tables configured (established 2097152 bind 65536)
> TCP reno registered
> checking if image is initramfs... it is
> Freeing initrd memory: 7574k freed
> audit: initializing netlink socket (disabled)
> audit(1246055003.828:1): initialized
> VFS: Disk quotas dquot_6.5.1
> Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> io scheduler noop registered
> io scheduler anticipatory registered
> io scheduler deadline registered
> io scheduler cfq registered (default)
> PCI: Found enabled HT MSI Mapping on 0000:00:0c.0
> PCI: Found enabled HT MSI Mapping on 0000:00:0d.0
> PCI: Found enabled HT MSI Mapping on 0000:00:0e.0
> Boot video device is 0000:01:03.0
> pci 0000:01:04.4: HCRESET not completed yet!
> PCI: Found enabled HT MSI Mapping on 0000:40:0b.0
> PCI: Found enabled HT MSI Mapping on 0000:40:0c.0
> PCI: Found enabled HT MSI Mapping on 0000:40:0d.0
> PCI: Found enabled HT MSI Mapping on 0000:40:0e.0
> PCI: Setting latency timer of device 0000:00:0c.0 to 64
> assign_interrupt_mode Found MSI capability
> Allocate Port Service[0000:00:0c.0:pcie00]
> PCI: Setting latency timer of device 0000:00:0d.0 to 64
> assign_interrupt_mode Found MSI capability
> Allocate Port Service[0000:00:0d.0:pcie00]
> PCI: Setting latency timer of device 0000:00:0e.0 to 64
> assign_interrupt_mode Found MSI capability
> Allocate Port Service[0000:00:0e.0:pcie00]
> PCI: Setting latency timer of device 0000:40:0b.0 to 64
> assign_interrupt_mode Found MSI capability
> Allocate Port Service[0000:40:0b.0:pcie00]
> PCI: Setting latency timer of device 0000:40:0c.0 to 64
> assign_interrupt_mode Found MSI capability
> Allocate Port Service[0000:40:0c.0:pcie00]
> PCI: Setting latency timer of device 0000:40:0d.0 to 64
> assign_interrupt_mode Found MSI capability
> Allocate Port Service[0000:40:0d.0:pcie00]
> PCI: Setting latency timer of device 0000:40:0e.0 to 64
> assign_interrupt_mode Found MSI capability
> Allocate Port Service[0000:40:0e.0:pcie00]
> Real Time Clock Driver v1.12ac
> hpet_resources: 0xfed00000 is busy
> Linux agpgart interface v0.102 (c) Dave Jones
> Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
> serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> pnp: the driver 'serial' has been registered
> pnp: match found with the PnP device '00:09' and the driver 'serial'
> 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
> pnp: the driver 'i8042 kbd' has been registered
> pnp: match found with the PnP device '00:06' and the driver 'i8042 kbd'
> pnp: the driver 'i8042 aux' has been registered
> pnp: match found with the PnP device '00:07' and the driver 'i8042 aux'
> PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: i8042 AUX port at 0x60,0x64 irq 12
> mice: PS/2 mouse device common for all mice
> TCP bic registered
> NET: Registered protocol family 1
> NET: Registered protocol family 17
> Freeing unused kernel memory: 296k freed
> ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
> ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
> ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
> ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
> ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
> ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
> ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
> ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
> ACPI: PCI Interrupt Link [LNU2] enabled at IRQ 23
> ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LNU2] -> GSI 23 (level, high) -> IRQ 23
> PCI: Setting latency timer of device 0000:00:02.1 to 64
> ehci_hcd 0000:00:02.1: EHCI Host Controller
> ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
> ehci_hcd 0000:00:02.1: debug port 1
> PCI: cache line size of 64 is not supported by device 0000:00:02.1
> ehci_hcd 0000:00:02.1: irq 23, io mem 0xf7cd0000
> ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> usb usb1: configuration #1 chosen from 1 choice
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 10 ports detected
> Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
> ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> pnp: the driver 'ide' has been registered
> SCSI subsystem initialized
> HP CISS Driver (v 3.6.14)
> NFORCE-CK804: IDE controller at PCI slot 0000:00:06.0
> NFORCE-CK804: chipset revision 163
> NFORCE-CK804: not 100% native mode: will probe irqs later
> NFORCE-CK804: 0000:00:06.0 (rev a3) UDMA133 controller
>     ide0: BM-DMA at 0x1000-0x1007, BIOS settings: hda:pio, hdb:pio
> Probing IDE interface ide0...
> usb 1-6: new high speed USB device using ehci_hcd and address 3
> usb 1-6: configuration #1 chosen from 1 choice
> hub 1-6:1.0: USB hub found
> hub 1-6:1.0: 4 ports detected
> hda: HL-DT-ST DVDRAM GSA-T20L, ATAPI CD/DVD-ROM drive
> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v1.5.11 (June 4, 2007)
> ACPI: PCI Interrupt 0000:41:01.0[A] -> GSI 31 (level, low) -> IRQ 31
> eth0: Broadcom NetXtreme II BCM5706 1000Base-T (A2) PCI-X 64-bit 100MHz found at mem fa000000, IRQ 31, node addr 001cc4f094fa
> ACPI: PCI Interrupt 0000:41:02.0[A] -> GSI 32 (level, low) -> IRQ 32
> eth1: Broadcom NetXtreme II BCM5706 1000Base-T (A2) PCI-X 64-bit 100MHz found at mem f8000000, IRQ 32, node addr 001cc4f094fc
> ACPI: PCI Interrupt 0000:42:02.0[A] -> GSI 26 (level, low) -> IRQ 26
> USB Universal Host Controller Interface driver v3.0
> ACPI: PCI Interrupt Link [LNKX] enabled at IRQ 17
> ACPI: PCI Interrupt 0000:01:04.4[B] -> Link [LNKX] -> GSI 17 (level, high) -> IRQ 17
> uhci_hcd 0000:01:04.4: UHCI Host Controller
> uhci_hcd 0000:01:04.4: new USB bus registered, assigned bus number 2
> uhci_hcd 0000:01:04.4: port count misdetected? forcing to 2 ports
> uhci_hcd 0000:01:04.4: HCRESET not completed yet!
> uhci_hcd 0000:01:04.4: irq 17, io base 0x00003800
> usb usb2: configuration #1 chosen from 1 choice
> hub 2-0:1.0: USB hub found
> hub 2-0:1.0: 2 ports detected
> ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
> ACPI: PCI Interrupt Link [LNU0] enabled at IRQ 22
> ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNU0] -> GSI 22 (level, high) -> IRQ 22
> PCI: Setting latency timer of device 0000:00:02.0 to 64
> ohci_hcd 0000:00:02.0: OHCI Host Controller
> cciss0: <0x3220> at PCI 0000:42:02.0 IRQ 26 using DAC
>       blocks= 286677120 block_size= 512
>       heads=255, sectors=32, cylinders=35132
> 
>       blocks= 860051248 block_size= 512
>       heads=255, sectors=32, cylinders=105399
> 
>       blocks= 286677120 block_size= 512
>       heads=255, sectors=32, cylinders=35132
> 
>  cciss/c0d0: p1 p2
>       blocks= 860051248 block_size= 512
>       heads=255, sectors=32, cylinders=105399
> 
>  cciss/c0d1: unknown partition table
> ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 3
> ohci_hcd 0000:00:02.0: irq 22, io mem 0xf7ce0000
> usb usb3: configuration #1 chosen from 1 choice
> hub 3-0:1.0: USB hub found
> hub 3-0:1.0: 10 ports detected
> libata version 2.21 loaded.
> hda: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, UDMA(33)
> Uniform CD-ROM driver Revision: 3.20
> usb 2-1: new full speed USB device using uhci_hcd and address 2
> device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
> EXT3-fs: INFO: recovery required on readonly filesystem.
> EXT3-fs: write access will be enabled during recovery.
> usb 2-1: configuration #1 chosen from 1 choice
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs: recovery complete.
> EXT3-fs: mounted filesystem with ordered data mode.
> usb 2-2: new full speed USB device using uhci_hcd and address 3
> usb 2-2: configuration #1 chosen from 1 choice
> hub 2-2:1.0: USB hub found
> hub 2-2:1.0: 7 ports detected
> usb 3-3: new low speed USB device using ohci_hcd and address 2
> udev: starting version 141
> udev: deprecated sysfs layout; update the kernel or disable CONFIG_SYSFS_DEPRECATED; some udev features will not work correctly
> pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> shpchp: HPC vendor_id 1022 device_id 7458 ss_vid 0 ss_did 0
> shpchp: shpc_init: cannot reserve MMIO region
> shpchp: HPC vendor_id 1022 device_id 7458 ss_vid 0 ss_did 0
> shpchp: shpc_init: cannot reserve MMIO region
> shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
> usb 3-3: configuration #1 chosen from 1 choice
> usbcore: registered new interface driver hiddev
> input: HP Virtual Keyboard as /class/input/input0
> input: USB HID v1.01 Keyboard [HP Virtual Keyboard] on usb-0000:01:04.4-1
> input: HP Virtual Keyboard as /class/input/input1
> input: USB HID v1.01 Mouse [HP Virtual Keyboard] on usb-0000:01:04.4-1
> input: Avocent HP 336047-B21 as /class/input/input2
> input: USB HID v1.10 Keyboard [Avocent HP 336047-B21] on usb-0000:00:02.0-3
> input: Avocent HP 336047-B21 as /class/input/input3
> input: USB HID v1.10 Mouse [Avocent HP 336047-B21] on usb-0000:00:02.0-3
> usbcore: registered new interface driver usbhid
> drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
> EXT3 FS on cciss/c0d0p1, internal journal
> 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
> All bugs added by David S. Miller <davem@redhat.com>
> ipmi message handler version 39.1
> ipmi device interface
> IPMI System Interface driver.
> ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca2, slave address 0x20, irq 0
> ipmi: Found new BMC (man_id: 0x00000b,  prod_id: 0x0000, dev_id: 0x11)
>  IPMI kcs interface initialized
> ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
> ipmi_si: duplicate interface
> ACPI: PCI Interrupt Link [LNKW] enabled at IRQ 16
> ACPI: PCI Interrupt 0000:01:04.6[A] -> Link [LNKW] -> GSI 16 (level, high) -> IRQ 16
> ipmi_si: Trying PCI-specified kcs state machine at mem address 0xf7df0000, slave address 0x0, irq 16
>   Using irq 16
> ipmi: interfacing existing BMC (man_id: 0x00000b, prod_id: 0x0000, dev_id: 0x11)
>  IPMI kcs interface initialized
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on dm-1, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on dm-2, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on dm-4, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on dm-0, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> Adding 16777208k swap on /dev/mapper/vg0-swap.  Priority:-1 extents:1 across:16777208k
> NET: Registered protocol family 15
> Ethernet Channel Bonding Driver: v3.1.3 (June 13, 2007)
> bonding: MII link monitoring set to 100 ms
> bonding: bond0: Adding slave eth0.
> bonding: bond0: enslaving eth0 as a backup interface with a down link.
> bonding: bond0: Adding slave eth1.
> bonding: bond0: enslaving eth1 as a backup interface with a down link.
> NET: Registered protocol family 10
> lo: Disabled Privacy Extensions
> ADDRCONF(NETDEV_UP): eth0: link is not ready
> ADDRCONF(NETDEV_UP): eth1: link is not ready
> ADDRCONF(NETDEV_UP): bond0: link is not ready
> Initializing XFRM netlink socket

> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 2.6.29-2-amd64 (Debian 2.6.29-4) (waldi@debian.org) (gcc version 4.3.3 (Debian 4.3.3-8) ) #1 SMP Sun May 3 11:38:27 UTC 2009
> [    0.000000] Command line: root=/dev/cciss/c0d0p1 ro pci=noapic noapic 
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   Centaur CentaurHauls
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
> [    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 000000007fe4e000 (usable)
> [    0.000000]  BIOS-e820: 000000007fe4e000 - 000000007fe56000 (ACPI data)
> [    0.000000]  BIOS-e820: 000000007fe56000 - 000000007fe57000 (usable)
> [    0.000000]  BIOS-e820: 000000007fe57000 - 0000000080000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 000000047ffff000 (usable)
> [    0.000000] PCI: Unknown option `noapic'
> [    0.000000] DMI 2.4 present.
> [    0.000000] last_pfn = 0x47ffff max_arch_pfn = 0x100000000
> [    0.000000] last_pfn = 0x7fe57 max_arch_pfn = 0x100000000
> [    0.000000] init_memory_mapping: 0000000000000000-000000007fe57000
> [    0.000000]  0000000000 - 007fe00000 page 2M
> [    0.000000]  007fe00000 - 007fe57000 page 4k
> [    0.000000] kernel direct mapping tables up to 7fe57000 @ 8000-c000
> [    0.000000] last_map_addr: 7fe57000 end: 7fe57000
> [    0.000000] init_memory_mapping: 0000000100000000-000000047ffff000
> [    0.000000]  0100000000 - 047fe00000 page 2M
> [    0.000000]  047fe00000 - 047ffff000 page 4k
> [    0.000000] kernel direct mapping tables up to 47ffff000 @ a000-1e000
> [    0.000000] last_map_addr: 47ffff000 end: 47ffff000
> [    0.000000] RAMDISK: 37783000 - 37fef87c
> [    0.000000] ACPI: RSDP 000F4F00, 0024 (r2 HP    )
> [    0.000000] ACPI: XSDT 7FE4ED00, 0074 (r1 HP     ProLiant        2   ?     162E)
> [    0.000000] ACPI: FACP 7FE4ED80, 00F4 (r3 HP     A07             2   ?     162E)
> [    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
> [    0.000000] ACPI: DSDT 7FE4EE80, 498A (r1 HP         DSDT        1 INTL 20030228)
> [    0.000000] ACPI: FACS 7FE4E100, 0040
> [    0.000000] ACPI: SPCR 7FE4E140, 0050 (r1 HP     SPCRRBSU        1   ?     162E)
> [    0.000000] ACPI: HPET 7FE4E1C0, 0038 (r1 HP     ProLiant        2   ?     162E)
> [    0.000000] ACPI: SPMI 7FE4E200, 0040 (r5 HP     ProLiant        1   ?     162E)
> [    0.000000] ACPI: ERST 7FE4E240, 01D0 (r1 HP     ProLiant        1   ?     162E)
> [    0.000000] ACPI: APIC 7FE4E440, 00C6 (r1 HP     ProLiant        2             0)
> [    0.000000] ACPI: SRAT 7FE4E580, 01A0 (r1 AMD    FAM_F_10        2 AMD         1)
> [    0.000000] ACPI: FFFF 7FE4E980, 0176 (r1 HP     ProLiant        1   ?     162E)
> [    0.000000] ACPI: BERT 7FE4EB00, 0030 (r1 HP     ProLiant        1   ?     162E)
> [    0.000000] ACPI: HEST 7FE4EB40, 0170 (r1 HP     ProLiant        1   ?     162E)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 1 -> Node 0
> [    0.000000] SRAT: PXM 1 -> APIC 2 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 3 -> Node 1
> [    0.000000] SRAT: PXM 2 -> APIC 4 -> Node 2
> [    0.000000] SRAT: PXM 2 -> APIC 5 -> Node 2
> [    0.000000] SRAT: PXM 3 -> APIC 6 -> Node 3
> [    0.000000] SRAT: PXM 3 -> APIC 7 -> Node 3
> [    0.000000] SRAT: Node 0 PXM 0 0-a0000
> [    0.000000] SRAT: Node 0 PXM 0 100000-80000000
> [    0.000000] SRAT: Node 0 PXM 0 100000000-180000000
> [    0.000000] SRAT: Node 1 PXM 1 180000000-280000000
> [    0.000000] SRAT: Node 2 PXM 2 280000000-380000000
> [    0.000000] SRAT: Node 3 PXM 3 380000000-480000000
> [    0.000000] NUMA: Allocated memnodemap from 19000 - 22080
> [    0.000000] NUMA: Using 20 for the hash shift.
> [    0.000000] Bootmem setup node 0 0000000000000000-0000000180000000
> [    0.000000]   NODE_DATA [0000000000022080 - 000000000002a07f]
> [    0.000000]   bootmap [000000000002b000 -  000000000005afff] pages 30
> [    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0180000000]
> [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
> [    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
> [    0.000000]   #2 [0000200000 - 00007ed74c]    TEXT DATA BSS ==> [0000200000 - 00007ed74c]
> [    0.000000]   #3 [0037783000 - 0037fef87c]          RAMDISK ==> [0037783000 - 0037fef87c]
> [    0.000000]   #4 [000009f400 - 0000100000]    BIOS reserved ==> [000009f400 - 0000100000]
> [    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
> [    0.000000]   #6 [000000a000 - 0000019000]          PGTABLE ==> [000000a000 - 0000019000]
> [    0.000000]   #7 [0000019000 - 0000022080]       MEMNODEMAP ==> [0000019000 - 0000022080]
> [    0.000000] Bootmem setup node 1 0000000180000000-0000000280000000
> [    0.000000]   NODE_DATA [0000000180000000 - 0000000180007fff]
> [    0.000000]   bootmap [0000000180008000 -  0000000180027fff] pages 20
> [    0.000000] (8 early reservations) ==> bootmem [0180000000 - 0280000000]
> [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page
> [    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE
> [    0.000000]   #2 [0000200000 - 00007ed74c]    TEXT DATA BSS
> [    0.000000]   #3 [0037783000 - 0037fef87c]          RAMDISK
> [    0.000000]   #4 [000009f400 - 0000100000]    BIOS reserved
> [    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE
> [    0.000000]   #6 [000000a000 - 0000019000]          PGTABLE
> [    0.000000]   #7 [0000019000 - 0000022080]       MEMNODEMAP
> [    0.000000] Bootmem setup node 2 0000000280000000-0000000380000000
> [    0.000000]   NODE_DATA [0000000280000000 - 0000000280007fff]
> [    0.000000]   bootmap [0000000280008000 -  0000000280027fff] pages 20
> [    0.000000] (8 early reservations) ==> bootmem [0280000000 - 0380000000]
> [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page
> [    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE
> [    0.000000]   #2 [0000200000 - 00007ed74c]    TEXT DATA BSS
> [    0.000000]   #3 [0037783000 - 0037fef87c]          RAMDISK
> [    0.000000]   #4 [000009f400 - 0000100000]    BIOS reserved
> [    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE
> [    0.000000]   #6 [000000a000 - 0000019000]          PGTABLE
> [    0.000000]   #7 [0000019000 - 0000022080]       MEMNODEMAP
> [    0.000000] Bootmem setup node 3 0000000380000000-000000047ffff000
> [    0.000000]   NODE_DATA [0000000380000000 - 0000000380007fff]
> [    0.000000]   bootmap [0000000380008000 -  0000000380027fff] pages 20
> [    0.000000] (8 early reservations) ==> bootmem [0380000000 - 047ffff000]
> [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page
> [    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE
> [    0.000000]   #2 [0000200000 - 00007ed74c]    TEXT DATA BSS
> [    0.000000]   #3 [0037783000 - 0037fef87c]          RAMDISK
> [    0.000000]   #4 [000009f400 - 0000100000]    BIOS reserved
> [    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE
> [    0.000000]   #6 [000000a000 - 0000019000]          PGTABLE
> [    0.000000]   #7 [0000019000 - 0000022080]       MEMNODEMAP
> [    0.000000] found SMP MP-table at [ffff8800000f4f80] 000f4f80
> [    0.000000]  [ffffe20000000000-ffffe200053fffff] PMD -> [ffff880028200000-ffff88002b9fffff] on node 0
> [    0.000000]  [ffffe20005400000-ffffe20008bfffff] PMD -> [ffff880180200000-ffff8801839fffff] on node 1
> [    0.000000]  [ffffe20008c00000-ffffe2000c3fffff] PMD -> [ffff880280200000-ffff8802839fffff] on node 2
> [    0.000000]  [ffffe2000c400000-ffffe2000fbfffff] PMD -> [ffff880380200000-ffff8803839fffff] on node 3
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000000 -> 0x00001000
> [    0.000000]   DMA32    0x00001000 -> 0x00100000
> [    0.000000]   Normal   0x00100000 -> 0x0047ffff
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[7] active PFN ranges
> [    0.000000]     0: 0x00000000 -> 0x0000009f
> [    0.000000]     0: 0x00000100 -> 0x0007fe4e
> [    0.000000]     0: 0x0007fe56 -> 0x0007fe57
> [    0.000000]     0: 0x00100000 -> 0x00180000
> [    0.000000]     1: 0x00180000 -> 0x00280000
> [    0.000000]     2: 0x00280000 -> 0x00380000
> [    0.000000]     3: 0x00380000 -> 0x0047ffff
> [    0.000000] On node 0 totalpages: 1048046
> [    0.000000]   DMA zone: 56 pages used for memmap
> [    0.000000]   DMA zone: 1644 pages reserved
> [    0.000000]   DMA zone: 2299 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 14280 pages used for memmap
> [    0.000000]   DMA32 zone: 505479 pages, LIFO batch:31
> [    0.000000]   Normal zone: 7168 pages used for memmap
> [    0.000000]   Normal zone: 517120 pages, LIFO batch:31
> [    0.000000] On node 1 totalpages: 1048576
> [    0.000000]   Normal zone: 14336 pages used for memmap
> [    0.000000]   Normal zone: 1034240 pages, LIFO batch:31
> [    0.000000] On node 2 totalpages: 1048576
> [    0.000000]   Normal zone: 14336 pages used for memmap
> [    0.000000]   Normal zone: 1034240 pages, LIFO batch:31
> [    0.000000] On node 3 totalpages: 1048575
> [    0.000000]   Normal zone: 14336 pages used for memmap
> [    0.000000]   Normal zone: 1034239 pages, LIFO batch:31
> [    0.000000] Detected use of extended apic ids on hypertransport bus
> [    0.000000] Detected use of extended apic ids on hypertransport bus
> [    0.000000] Detected use of extended apic ids on hypertransport bus
> [    0.000000] Detected use of extended apic ids on hypertransport bus
> [    0.000000] ACPI: PM-Timer IO Port: 0x908
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
> [    0.000000] ACPI: Skipping IOAPIC probe due to 'noapic' option.
> [    0.000000] Using ACPI for processor (LAPIC) configuration information
> [    0.000000] ACPI: HPET id: 0x10228201 base: 0xfed00000
> [    0.000000] Intel MultiProcessor Specification v1.4
> [    0.000000] MPTABLE: OEM ID: HP      
> [    0.000000] MPTABLE: Product ID: PROLIANT    
> [    0.000000] MPTABLE: APIC at: 0xFEE00000
> [    0.000000] I/O APIC #8 Version 32 at 0xD9CF0000.
> [    0.000000] I/O APIC #9 Version 32 at 0xD9FD0000.
> [    0.000000] I/O APIC #10 Version 32 at 0xD9FE0000.
> [    0.000000] Processors: 8
> [    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 38
> [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
> [    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
> [    0.000000] PM: Registered nosave memory: 000000007fe4e000 - 000000007fe56000
> [    0.000000] PM: Registered nosave memory: 000000007fe57000 - 0000000080000000
> [    0.000000] PM: Registered nosave memory: 0000000080000000 - 00000000e0000000
> [    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
> [    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
> [    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fed00000
> [    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fee00000
> [    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee10000
> [    0.000000] PM: Registered nosave memory: 00000000fee10000 - 00000000ffc00000
> [    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 0000000100000000
> [    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
> [    0.000000] NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:8 nr_node_ids:4
> [    0.000000] PERCPU: Allocating 53248 bytes of per cpu data
> [    0.000000] Built 4 zonelists in Zone order, mobility grouping on.  Total pages: 4127617
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line: root=/dev/cciss/c0d0p1 ro pci=noapic noapic 
> [    0.000000] Initializing CPU#0
> [    0.000000] Experimental hierarchical RCU implementation.
> [    0.000000] Experimental hierarchical RCU init done.
> [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
> [    0.000000] Extended CMOS year: 2000
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 2813.240 MHz processor.
> [    0.004000] spurious 8259A interrupt: IRQ7.
> [    0.004000] Console: colour VGA+ 80x25
> [    0.004000] console [tty0] enabled
> [    0.004000] Checking aperture...
> [    0.004000] No AGP bridge found
> [    0.004000] Node 0: aperture @ 20000000 size 32 MB
> [    0.004000] Aperture pointing to e820 RAM. Ignoring.
> [    0.004000] Your BIOS doesn't leave a aperture memory hole
> [    0.004000] Please enable the IOMMU option in the BIOS setup
> [    0.004000] This costs you 64 MB of RAM
> [    0.004000] Mapping aperture over 65536 KB of RAM @ 20000000
> [    0.004000] PM: Registered nosave memory: 0000000020000000 - 0000000024000000
> [    0.004000] Memory: 16464280k/18874364k available (2546k kernel code, 2099272k absent, 310812k reserved, 1320k data, 552k init)
> [    0.004000] hpet clockevent registered
> [    0.004000] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 5626.48 BogoMIPS (lpj=11252960)
> [    0.004000] Security Framework initialized
> [    0.004000] SELinux:  Disabled at boot.
> [    0.004000] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
> [    0.014230] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
> [    0.020141] Mount-cache hash table entries: 256
> [    0.020510] Initializing cgroup subsys ns
> [    0.020573] Initializing cgroup subsys cpuacct
> [    0.020639] Initializing cgroup subsys devices
> [    0.020702] Initializing cgroup subsys freezer
> [    0.020766] Initializing cgroup subsys net_cls
> [    0.020873] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> [    0.020945] CPU: L2 Cache: 1024K (64 bytes/line)
> [    0.021009] CPU 0/0x0 -> Node 0
> [    0.021068] tseg: 0000000000
> [    0.021081] CPU: Physical Processor ID: 0
> [    0.021142] CPU: Processor Core ID: 0
> [    0.021208] using C1E aware idle routine
> [    0.022533] ACPI: Core revision 20081204
> [    0.030729] ACPI: setting ELCR to 0200 (from 8c20)
> [    0.031017] Setting APIC routing to flat
> [    0.031082] CPU0: Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
> [    0.032001] Booting processor 1 APIC 0x2 ip 0x6000
> [    0.004000] Initializing CPU#1
> [    0.004000] Calibrating delay using timer specific routine.. 5625.85 BogoMIPS (lpj=11251710)
> [    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> [    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
> [    0.004000] CPU 1/0x2 -> Node 1
> [    0.004000] CPU: Physical Processor ID: 1
> [    0.004000] CPU: Processor Core ID: 0
> [    0.120174] CPU1: Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
> [    0.120985] Booting processor 2 APIC 0x4 ip 0x6000
> [    0.004000] Initializing CPU#2
> [    0.004000] Calibrating delay using timer specific routine.. 5625.89 BogoMIPS (lpj=11251797)
> [    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> [    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
> [    0.004000] CPU 2/0x4 -> Node 2
> [    0.004000] CPU: Physical Processor ID: 2
> [    0.004000] CPU: Processor Core ID: 0
> [    0.208210] CPU2: Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
> [    0.209028] Booting processor 3 APIC 0x6 ip 0x6000
> [    0.004000] Initializing CPU#3
> [    0.004000] Calibrating delay using timer specific routine.. 5625.92 BogoMIPS (lpj=11251857)
> [    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> [    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
> [    0.004000] CPU 3/0x6 -> Node 3
> [    0.004000] CPU: Physical Processor ID: 3
> [    0.004000] CPU: Processor Core ID: 0
> [    0.300192] CPU3: Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
> [    0.300903] Booting processor 4 APIC 0x1 ip 0x6000
> [    0.004000] Initializing CPU#4
> [    0.004000] Calibrating delay using timer specific routine.. 5625.88 BogoMIPS (lpj=11251766)
> [    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> [    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
> [    0.004000] CPU 4/0x1 -> Node 0
> [    0.004000] CPU: Physical Processor ID: 0
> [    0.004000] CPU: Processor Core ID: 1
> [    0.388198] CPU4: Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
> [    0.388778] Booting processor 5 APIC 0x3 ip 0x6000
> [    0.004000] Initializing CPU#5
> [    0.004000] Calibrating delay using timer specific routine.. 5625.90 BogoMIPS (lpj=11251806)
> [    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> [    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
> [    0.004000] CPU 5/0x3 -> Node 1
> [    0.004000] CPU: Physical Processor ID: 1
> [    0.004000] CPU: Processor Core ID: 1
> [    0.476249] CPU5: Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
> [    0.477037] Booting processor 6 APIC 0x5 ip 0x6000
> [    0.004000] Initializing CPU#6
> [    0.004000] Calibrating delay using timer specific routine.. 5625.88 BogoMIPS (lpj=11251772)
> [    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> [    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
> [    0.004000] CPU 6/0x5 -> Node 2
> [    0.004000] CPU: Physical Processor ID: 2
> [    0.004000] CPU: Processor Core ID: 1
> [    0.568202] CPU6: Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
> [    0.569002] Booting processor 7 APIC 0x7 ip 0x6000
> [    0.004000] Initializing CPU#7
> [    0.004000] Calibrating delay using timer specific routine.. 5625.87 BogoMIPS (lpj=11251745)
> [    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> [    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
> [    0.004000] CPU 7/0x7 -> Node 3
> [    0.004000] CPU: Physical Processor ID: 3
> [    0.004000] CPU: Processor Core ID: 1
> [    0.656199] CPU7: Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
> [    0.656784] Brought up 8 CPUs
> [    0.656845] Total of 8 processors activated (45007.70 BogoMIPS).
> [    0.657027] CPU0 attaching sched-domain:
> [    0.657029]  domain 0: span 0,4 level CPU
> [    0.657031]   groups: 0 4
> [    0.657034]   domain 1: span 0-7 level NODE
> [    0.657036]    groups: 0,4 1,5 2,6 3,7
> [    0.657042] CPU1 attaching sched-domain:
> [    0.657043]  domain 0: span 1,5 level CPU
> [    0.657044]   groups: 1 5
> [    0.657047]   domain 1: span 0-7 level NODE
> [    0.657048]    groups: 1,5 2,6 3,7 0,4
> [    0.657054] CPU2 attaching sched-domain:
> [    0.657055]  domain 0: span 2,6 level CPU
> [    0.657056]   groups: 2 6
> [    0.657059]   domain 1: span 0-7 level NODE
> [    0.657060]    groups: 2,6 3,7 0,4 1,5
> [    0.657065] CPU3 attaching sched-domain:
> [    0.657067]  domain 0: span 3,7 level CPU
> [    0.657068]   groups: 3 7
> [    0.657071]   domain 1: span 0-7 level NODE
> [    0.657072]    groups: 3,7 0,4 1,5 2,6
> [    0.657077] CPU4 attaching sched-domain:
> [    0.657078]  domain 0: span 0,4 level CPU
> [    0.657080]   groups: 4 0
> [    0.657082]   domain 1: span 0-7 level NODE
> [    0.657084]    groups: 0,4 1,5 2,6 3,7
> [    0.657089] CPU5 attaching sched-domain:
> [    0.657090]  domain 0: span 1,5 level CPU
> [    0.657092]   groups: 5 1
> [    0.657094]   domain 1: span 0-7 level NODE
> [    0.657095]    groups: 1,5 2,6 3,7 0,4
> [    0.657100] CPU6 attaching sched-domain:
> [    0.657102]  domain 0: span 2,6 level CPU
> [    0.657103]   groups: 6 2
> [    0.657106]   domain 1: span 0-7 level NODE
> [    0.657107]    groups: 2,6 3,7 0,4 1,5
> [    0.657112] CPU7 attaching sched-domain:
> [    0.657114]  domain 0: span 3,7 level CPU
> [    0.657115]   groups: 7 3
> [    0.657118]   domain 1: span 0-7 level NODE
> [    0.657119]    groups: 3,7 0,4 1,5 2,6
> [    0.657335] net_namespace: 1888 bytes
> [    0.657335] Booting paravirtualized kernel on bare hardware
> [    0.657335] regulator: core version 0.5
> [    0.657335] NET: Registered protocol family 16
> [    0.657335] node 0 link 1: io port [1000, 2fff]
> [    0.657335] node 1 link 2: io port [3000, ffff]
> [    0.657335] TOM: 0000000080000000 aka 2048M
> [    0.657335] node 0 link 1: mmio [d0000000, d9efffff]
> [    0.657335] node 1 link 2: mmio [d9f00000, dfefffff]
> [    0.657335] node 0 link 1: mmio [e0000000, e3ffffff]
> [    0.657335] node 1 link 2: mmio [e4000000, e7ffffff]
> [    0.657335] node 0 link 1: mmio [a0000, bffff]
> [    0.657335] TOM2: 0000000480000000 aka 18432M
> [    0.657335] bus: [00,3f] on node 0 link 1
> [    0.657335] bus: 00 index 0 io port: [0, 2fff]
> [    0.657335] bus: 00 index 1 mmio: [80000000, d9efffff]
> [    0.657335] bus: 00 index 2 mmio: [dff00000, e3ffffff]
> [    0.657335] bus: 00 index 3 mmio: [a0000, bffff]
> [    0.657335] bus: 00 index 4 mmio: [e8000000, ffffffff]
> [    0.657335] bus: 00 index 5 mmio: [480000000, fcffffffff]
> [    0.657335] bus: [40,7f] on node 1 link 2
> [    0.657335] bus: 40 index 0 io port: [3000, ffff]
> [    0.657335] bus: 40 index 1 mmio: [d9f00000, dfefffff]
> [    0.657335] bus: 40 index 2 mmio: [e4000000, e7ffffff]
> [    0.657335] ACPI: bus type pci registered
> [    0.657335] PCI: Using configuration type 1 for base access
> [    0.657335] PCI: HP ProLiant DL585 G2 detected, enabling pci=bfsort.
> [    0.660277] bio: create slab <bio-0> at 0
> [    0.660435] ACPI: EC: Look up EC in DSDT
> [    0.668759] ACPI: SSDT 7FE58000, 0AC4 (r2 HP     PNOWSSDT        2 HP          1)
> [    0.669531] ACPI: Interpreter enabled
> [    0.669592] ACPI: (supports S0 S4 S5)
> [    0.669741] ACPI: Using PIC for interrupt routing
> [    0.676178] ACPI: No dock devices found.
> [    0.676256] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [    0.676358] pci 0000:00:02.0: reg 10 32bit mmio: [0xd9ce0000-0xd9ce0fff]
> [    0.676358] pci 0000:00:02.0: supports D1 D2
> [    0.676358] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.676358] pci 0000:00:02.0: PME# disabled
> [    0.676358] pci 0000:00:02.1: reg 10 32bit mmio: [0xd9cd0000-0xd9cd00ff]
> [    0.676358] pci 0000:00:02.1: supports D1 D2
> [    0.676358] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.676358] pci 0000:00:02.1: PME# disabled
> [    0.676422] pci 0000:00:06.0: reg 20 io port: [0x500-0x50f]
> [    0.676464] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.676535] pci 0000:00:0c.0: PME# disabled
> [    0.676621] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.676691] pci 0000:00:0d.0: PME# disabled
> [    0.676772] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.676842] pci 0000:00:0e.0: PME# disabled
> [    0.677135] pci 0000:01:03.0: reg 10 32bit mmio: [0xd0000000-0xd7ffffff]
> [    0.677140] pci 0000:01:03.0: reg 14 io port: [0x1000-0x10ff]
> [    0.677145] pci 0000:01:03.0: reg 18 32bit mmio: [0xd9ef0000-0xd9efffff]
> [    0.677160] pci 0000:01:03.0: reg 30 32bit mmio: [0x000000-0x01ffff]
> [    0.677179] pci 0000:01:03.0: supports D1 D2
> [    0.677195] pci 0000:01:04.0: reg 10 io port: [0x2800-0x28ff]
> [    0.677200] pci 0000:01:04.0: reg 14 32bit mmio: [0xd9ee0000-0xd9ee01ff]
> [    0.677232] pci 0000:01:04.0: PME# supported from D0 D3hot D3cold
> [    0.677302] pci 0000:01:04.0: PME# disabled
> [    0.677382] pci 0000:01:04.2: reg 10 io port: [0x1400-0x14ff]
> [    0.677387] pci 0000:01:04.2: reg 14 32bit mmio: [0xd9ed0000-0xd9ed07ff]
> [    0.677392] pci 0000:01:04.2: reg 18 32bit mmio: [0xd9ec0000-0xd9ec3fff]
> [    0.677397] pci 0000:01:04.2: reg 1c 32bit mmio: [0xd9e00000-0xd9e7ffff]
> [    0.677409] pci 0000:01:04.2: reg 30 32bit mmio: [0x000000-0x00ffff]
> [    0.677431] pci 0000:01:04.2: PME# supported from D0 D3hot D3cold
> [    0.677501] pci 0000:01:04.2: PME# disabled
> [    0.677594] pci 0000:01:04.4: reg 20 io port: [0x1800-0x181f]
> [    0.677622] pci 0000:01:04.4: PME# supported from D0 D3hot D3cold
> [    0.677692] pci 0000:01:04.4: PME# disabled
> [    0.680022] pci 0000:01:04.6: reg 10 32bit mmio: [0xd9df0000-0xd9df00ff]
> [    0.680058] pci 0000:01:04.6: PME# supported from D0 D3hot D3cold
> [    0.680128] pci 0000:01:04.6: PME# disabled
> [    0.680216] pci 0000:00:09.0: transparent bridge
> [    0.680279] pci 0000:00:09.0: bridge io port: [0x1000-0x2fff]
> [    0.680282] pci 0000:00:09.0: bridge 32bit mmio: [0xd9d00000-0xd9efffff]
> [    0.680284] pci 0000:00:09.0: bridge 32bit mmio pref: [0xd0000000-0xd7ffffff]
> [    0.680387] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.680478] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IP2P._PRT]
> [    0.680598] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE0._PRT]
> [    0.680716] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE1._PRT]
> [    0.680830] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE2._PRT]
> [    0.684265] ACPI: PCI Root Bridge [PCI1] (0000:40)
> [    0.684313] pci 0000:40:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.684313] pci 0000:40:0b.0: PME# disabled
> [    0.684313] pci 0000:40:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.684359] pci 0000:40:0c.0: PME# disabled
> [    0.684451] pci 0000:40:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.684522] pci 0000:40:0d.0: PME# disabled
> [    0.684613] pci 0000:40:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.684684] pci 0000:40:0e.0: PME# disabled
> [    0.684776] pci 0000:40:10.0: Enabling HT MSI Mapping
> [    0.684905] pci 0000:40:11.0: Enabling HT MSI Mapping
> [    0.685156] pci 0000:41:01.0: reg 10 64bit mmio: [0xdc000000-0xddffffff]
> [    0.685169] pci 0000:41:01.0: reg 30 32bit mmio: [0x000000-0x01ffff]
> [    0.685189] pci 0000:41:01.0: PME# supported from D3hot D3cold
> [    0.685258] pci 0000:41:01.0: PME# disabled
> [    0.685338] pci 0000:41:02.0: reg 10 64bit mmio: [0xda000000-0xdbffffff]
> [    0.685351] pci 0000:41:02.0: reg 30 32bit mmio: [0x000000-0x01ffff]
> [    0.685371] pci 0000:41:02.0: PME# supported from D3hot D3cold
> [    0.685439] pci 0000:41:02.0: PME# disabled
> [    0.685523] pci 0000:40:10.0: bridge 32bit mmio: [0xda000000-0xddffffff]
> [    0.685546] pci 0000:42:02.0: reg 10 64bit mmio: [0xdfef0000-0xdfef1fff]
> [    0.685550] pci 0000:42:02.0: reg 18 io port: [0x3000-0x30ff]
> [    0.685556] pci 0000:42:02.0: reg 1c 64bit mmio: [0xdfe80000-0xdfebffff]
> [    0.685563] pci 0000:42:02.0: reg 30 32bit mmio: [0x000000-0x03ffff]
> [    0.685583] pci 0000:42:02.0: supports D1
> [    0.685606] pci 0000:40:11.0: bridge io port: [0x3000-0x3fff]
> [    0.685608] pci 0000:40:11.0: bridge 32bit mmio: [0xdfe00000-0xdfefffff]
> [    0.685629] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.BRGA._PRT]
> [    0.685710] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.BRGB._PRT]
> [    0.685921] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE0._PRT]
> [    0.686049] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE1._PRT]
> [    0.686172] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE2._PRT]
> [    0.688045] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE3._PRT]
> [    0.688308] ACPI: PCI Interrupt Link [LNKW] (IRQs 5 7 10 11) *0, disabled.
> [    0.688600] ACPI: PCI Interrupt Link [LNKX] (IRQs 5 7 10 11) *0, disabled.
> [    0.689025] ACPI: PCI Interrupt Link [LNKY] (IRQs 5 7 10 11) *0, disabled.
> [    0.692017] ACPI: PCI Interrupt Link [LNKZ] (IRQs 5 7 10 11) *0, disabled.
> [    0.692443] ACPI: PCI Interrupt Link [LNU0] (IRQs *5 7 10 11)
> [    0.692816] ACPI: PCI Interrupt Link [LNU2] (IRQs 5 7 10 *11)
> [    0.693191] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 7 10 11) *0, disabled.
> [    0.693615] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7 10 11) *0, disabled.
> [    0.694042] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 7 10 11) *0, disabled.
> [    0.694462] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 10 11) *0, disabled.
> [    0.694764] usbcore: registered new interface driver usbfs
> [    0.694764] usbcore: registered new interface driver hub
> [    0.696023] usbcore: registered new device driver usb
> [    0.696081] PCI: Using ACPI for IRQ routing
> [    0.696184] Expanded resource reserved due to conflict with PCI Bus #00
> [    0.696254] Expanded resource reserved due to conflict with PCI Bus #00
> [    0.716121] PCI-DMA: Disabling AGP.
> [    0.716292] PCI-DMA: aperture base @ 20000000 size 65536 KB
> [    0.716292] PCI-DMA: using GART IOMMU.
> [    0.716292] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
> [    0.716911] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
> [    0.717072] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
> [    0.740013] Switched to high resolution mode on CPU 0
> [    0.740185] Switched to high resolution mode on CPU 4
> [    0.740200] Switched to high resolution mode on CPU 2
> [    0.740204] Switched to high resolution mode on CPU 6
> [    0.740212] Switched to high resolution mode on CPU 5
> [    0.740220] Switched to high resolution mode on CPU 1
> [    0.740234] Switched to high resolution mode on CPU 3
> [    0.740239] Switched to high resolution mode on CPU 7
> [    0.748011] pnp: PnP ACPI init
> [    0.748069] ACPI: bus type pnp registered
> [    0.754229] pnp: PnP ACPI: found 16 devices
> [    0.754292] ACPI: ACPI bus type pnp unregistered
> [    0.754366] system 00:01: ioport range 0x408-0x40f has been reserved
> [    0.754435] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
> [    0.754505] system 00:01: ioport range 0x700-0x73f has been reserved
> [    0.754575] system 00:01: ioport range 0x800-0x8fe has been reserved
> [    0.754645] system 00:01: ioport range 0x900-0x9fe has been reserved
> [    0.754714] system 00:01: ioport range 0x9ff-0x9ff has been reserved
> [    0.754784] system 00:01: ioport range 0xa00-0xafe has been reserved
> [    0.754854] system 00:01: ioport range 0xaff-0xaff has been reserved
> [    0.754923] system 00:01: ioport range 0xb00-0xbfe has been reserved
> [    0.754993] system 00:01: ioport range 0xbff-0xbff has been reserved
> [    0.755063] system 00:01: ioport range 0xc80-0xc83 has been reserved
> [    0.755133] system 00:01: ioport range 0xcd4-0xcd7 has been reserved
> [    0.755202] system 00:01: ioport range 0xcf9-0xcf9 could not be reserved
> [    0.755273] system 00:01: ioport range 0xf50-0xf58 has been reserved
> [    0.755343] system 00:01: ioport range 0xca0-0xca1 has been reserved
> [    0.755413] system 00:01: ioport range 0xca4-0xca5 has been reserved
> [    0.755483] system 00:01: ioport range 0xc00-0xc03 has been reserved
> [    0.755552] system 00:01: ioport range 0x2f8-0x2ff has been reserved
> [    0.761161] pci 0000:00:09.0: PCI bridge, secondary bus 0000:01
> [    0.761230] pci 0000:00:09.0:   IO window: 0x1000-0x2fff
> [    0.761297] pci 0000:00:09.0:   MEM window: 0xd9d00000-0xd9efffff
> [    0.761366] pci 0000:00:09.0:   PREFETCH window: 0x000000d0000000-0x000000d7ffffff
> [    0.761465] pci 0000:00:0c.0: PCI bridge, secondary bus 0000:08
> [    0.761534] pci 0000:00:0c.0:   IO window: disabled
> [    0.761598] pci 0000:00:0c.0:   MEM window: disabled
> [    0.761663] pci 0000:00:0c.0:   PREFETCH window: disabled
> [    0.761730] pci 0000:00:0d.0: PCI bridge, secondary bus 0000:05
> [    0.761797] pci 0000:00:0d.0:   IO window: disabled
> [    0.761862] pci 0000:00:0d.0:   MEM window: disabled
> [    0.761926] pci 0000:00:0d.0:   PREFETCH window: disabled
> [    0.761993] pci 0000:00:0e.0: PCI bridge, secondary bus 0000:02
> [    0.762061] pci 0000:00:0e.0:   IO window: disabled
> [    0.762125] pci 0000:00:0e.0:   MEM window: disabled
> [    0.762189] pci 0000:00:0e.0:   PREFETCH window: disabled
> [    0.762261] pci 0000:00:09.0: setting latency timer to 64
> [    0.762264] pci 0000:00:0c.0: setting latency timer to 64
> [    0.762267] pci 0000:00:0d.0: setting latency timer to 64
> [    0.762271] pci 0000:00:0e.0: setting latency timer to 64
> [    0.762276] pci 0000:40:0b.0: PCI bridge, secondary bus 0000:4f
> [    0.762343] pci 0000:40:0b.0:   IO window: disabled
> [    0.762408] pci 0000:40:0b.0:   MEM window: disabled
> [    0.762473] pci 0000:40:0b.0:   PREFETCH window: disabled
> [    0.762541] pci 0000:40:0c.0: PCI bridge, secondary bus 0000:4c
> [    0.762608] pci 0000:40:0c.0:   IO window: disabled
> [    0.762673] pci 0000:40:0c.0:   MEM window: disabled
> [    0.762738] pci 0000:40:0c.0:   PREFETCH window: disabled
> [    0.762806] pci 0000:40:0d.0: PCI bridge, secondary bus 0000:49
> [    0.762873] pci 0000:40:0d.0:   IO window: disabled
> [    0.762938] pci 0000:40:0d.0:   MEM window: disabled
> [    0.763003] pci 0000:40:0d.0:   PREFETCH window: disabled
> [    0.763071] pci 0000:40:0e.0: PCI bridge, secondary bus 0000:46
> [    0.763138] pci 0000:40:0e.0:   IO window: disabled
> [    0.763203] pci 0000:40:0e.0:   MEM window: disabled
> [    0.763268] pci 0000:40:0e.0:   PREFETCH window: disabled
> [    0.763336] pci 0000:40:10.0: PCI bridge, secondary bus 0000:41
> [    0.763404] pci 0000:40:10.0:   IO window: disabled
> [    0.763469] pci 0000:40:10.0:   MEM window: 0xda000000-0xddffffff
> [    0.763538] pci 0000:40:10.0:   PREFETCH window: 0x000000d9f00000-0x000000d9ffffff
> [    0.763639] pci 0000:40:11.0: PCI bridge, secondary bus 0000:42
> [    0.763707] pci 0000:40:11.0:   IO window: 0x3000-0x3fff
> [    0.763774] pci 0000:40:11.0:   MEM window: 0xdfe00000-0xdfefffff
> [    0.763842] pci 0000:40:11.0:   PREFETCH window: 0x000000de000000-0x000000de0fffff
> [    0.763944] pci 0000:40:0b.0: setting latency timer to 64
> [    0.763949] pci 0000:40:0c.0: setting latency timer to 64
> [    0.763953] pci 0000:40:0d.0: setting latency timer to 64
> [    0.763957] pci 0000:40:0e.0: setting latency timer to 64
> [    0.763964] pci_bus 0000:00: resource 0 io:  [0x00-0x2fff]
> [    0.763965] pci_bus 0000:00: resource 1 mem: [0x80000000-0xd9efffff]
> [    0.763967] pci_bus 0000:00: resource 2 mem: [0xdff00000-0xe3ffffff]
> [    0.763968] pci_bus 0000:00: resource 3 mem: [0x0a0000-0x0bffff]
> [    0.763970] pci_bus 0000:00: resource 4 mem: [0xe8000000-0xffffffff]
> [    0.763972] pci_bus 0000:00: resource 5 mem: [0x480000000-0xfcffffffff]
> [    0.763974] pci_bus 0000:01: resource 0 io:  [0x1000-0x2fff]
> [    0.763975] pci_bus 0000:01: resource 1 mem: [0xd9d00000-0xd9efffff]
> [    0.763977] pci_bus 0000:01: resource 2 mem: [0xd0000000-0xd7ffffff]
> [    0.763978] pci_bus 0000:01: resource 3 io:  [0x00-0x2fff]
> [    0.763980] pci_bus 0000:01: resource 4 mem: [0x80000000-0xd9efffff]
> [    0.763982] pci_bus 0000:01: resource 5 mem: [0xdff00000-0xe3ffffff]
> [    0.763983] pci_bus 0000:01: resource 6 mem: [0x0a0000-0x0bffff]
> [    0.763985] pci_bus 0000:01: resource 7 mem: [0xe8000000-0xffffffff]
> [    0.763986] pci_bus 0000:01: resource 8 mem: [0x480000000-0xfcffffffff]
> [    0.763988] pci_bus 0000:08: resource 0 mem: [0x0-0x0]
> [    0.764005] pci_bus 0000:08: resource 1 mem: [0x0-0x0]
> [    0.764006] pci_bus 0000:08: resource 2 mem: [0x0-0x0]
> [    0.764008] pci_bus 0000:08: resource 3 mem: [0x0-0x0]
> [    0.764009] pci_bus 0000:05: resource 0 mem: [0x0-0x0]
> [    0.764010] pci_bus 0000:05: resource 1 mem: [0x0-0x0]
> [    0.764012] pci_bus 0000:05: resource 2 mem: [0x0-0x0]
> [    0.764013] pci_bus 0000:05: resource 3 mem: [0x0-0x0]
> [    0.764015] pci_bus 0000:02: resource 0 mem: [0x0-0x0]
> [    0.764016] pci_bus 0000:02: resource 1 mem: [0x0-0x0]
> [    0.764018] pci_bus 0000:02: resource 2 mem: [0x0-0x0]
> [    0.764019] pci_bus 0000:02: resource 3 mem: [0x0-0x0]
> [    0.764021] pci_bus 0000:40: resource 0 io:  [0x3000-0xffff]
> [    0.764023] pci_bus 0000:40: resource 1 mem: [0xd9f00000-0xdfefffff]
> [    0.764024] pci_bus 0000:40: resource 2 mem: [0xe4000000-0xe7ffffff]
> [    0.764026] pci_bus 0000:4f: resource 0 mem: [0x0-0x0]
> [    0.764027] pci_bus 0000:4f: resource 1 mem: [0x0-0x0]
> [    0.764029] pci_bus 0000:4f: resource 2 mem: [0x0-0x0]
> [    0.764030] pci_bus 0000:4f: resource 3 mem: [0x0-0x0]
> [    0.764032] pci_bus 0000:4c: resource 0 mem: [0x0-0x0]
> [    0.764033] pci_bus 0000:4c: resource 1 mem: [0x0-0x0]
> [    0.764034] pci_bus 0000:4c: resource 2 mem: [0x0-0x0]
> [    0.764036] pci_bus 0000:4c: resource 3 mem: [0x0-0x0]
> [    0.764037] pci_bus 0000:49: resource 0 mem: [0x0-0x0]
> [    0.764039] pci_bus 0000:49: resource 1 mem: [0x0-0x0]
> [    0.764040] pci_bus 0000:49: resource 2 mem: [0x0-0x0]
> [    0.764042] pci_bus 0000:49: resource 3 mem: [0x0-0x0]
> [    0.764043] pci_bus 0000:46: resource 0 mem: [0x0-0x0]
> [    0.764045] pci_bus 0000:46: resource 1 mem: [0x0-0x0]
> [    0.764046] pci_bus 0000:46: resource 2 mem: [0x0-0x0]
> [    0.764047] pci_bus 0000:46: resource 3 mem: [0x0-0x0]
> [    0.764049] pci_bus 0000:41: resource 0 mem: [0x0-0x0]
> [    0.764050] pci_bus 0000:41: resource 1 mem: [0xda000000-0xddffffff]
> [    0.764052] pci_bus 0000:41: resource 2 mem: [0xd9f00000-0xd9ffffff]
> [    0.764053] pci_bus 0000:41: resource 3 mem: [0x0-0x0]
> [    0.764055] pci_bus 0000:42: resource 0 io:  [0x3000-0x3fff]
> [    0.764057] pci_bus 0000:42: resource 1 mem: [0xdfe00000-0xdfefffff]
> [    0.764058] pci_bus 0000:42: resource 2 mem: [0xde000000-0xde0fffff]
> [    0.764060] pci_bus 0000:42: resource 3 mem: [0x0-0x0]
> [    0.764271] NET: Registered protocol family 2
> [    0.836568] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
> [    0.840992] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
> [    0.846583] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> [    0.847318] TCP: Hash tables configured (established 524288 bind 65536)
> [    0.847389] TCP reno registered
> [    0.856310] NET: Registered protocol family 1
> [    0.856533] checking if image is initramfs... it is
> [    1.431615] Freeing initrd memory: 8626k freed
> [    1.440313] audit: initializing netlink socket (disabled)
> [    1.440394] type=2000 audit(1246157873.440:1): initialized
> [    1.441867] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    1.442386] VFS: Disk quotas dquot_6.5.2
> [    1.442506] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    1.442683] msgmni has been set to 32173
> [    1.442938] alg: No test for stdrng (krng)
> [    1.443118] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> [    1.443217] io scheduler noop registered
> [    1.443278] io scheduler anticipatory registered
> [    1.443341] io scheduler deadline registered
> [    1.443475] io scheduler cfq registered (default)
> [    1.476024] pci 0000:00:0c.0: Found enabled HT MSI Mapping
> [    1.476101] pci 0000:00:0d.0: Found enabled HT MSI Mapping
> [    1.476175] pci 0000:00:0e.0: Found enabled HT MSI Mapping
> [    1.476270] pci 0000:01:03.0: Boot video device
> [    1.476286] pci 0000:01:04.4: HCRESET not completed yet!
> [    1.476379] pci 0000:40:0b.0: Found enabled HT MSI Mapping
> [    1.476457] pci 0000:40:0c.0: Found enabled HT MSI Mapping
> [    1.476535] pci 0000:40:0d.0: Found enabled HT MSI Mapping
> [    1.476613] pci 0000:40:0e.0: Found enabled HT MSI Mapping
> [    1.476907] pcieport-driver 0000:00:0c.0: setting latency timer to 64
> [    1.476928]   alloc irq_desc for 38 on cpu 0 node 0
> [    1.476930]   alloc kstat_irqs on cpu 0 node 0
> [    1.476941] pcieport-driver 0000:00:0c.0: irq 38 for MSI/MSI-X
> [    1.477028] pcieport-driver 0000:00:0d.0: setting latency timer to 64
> [    1.477046]   alloc irq_desc for 39 on cpu 0 node 0
> [    1.477048]   alloc kstat_irqs on cpu 0 node 0
> [    1.477053] pcieport-driver 0000:00:0d.0: irq 39 for MSI/MSI-X
> [    1.477133] pcieport-driver 0000:00:0e.0: setting latency timer to 64
> [    1.477151]   alloc irq_desc for 40 on cpu 0 node 0
> [    1.477152]   alloc kstat_irqs on cpu 0 node 0
> [    1.477156] pcieport-driver 0000:00:0e.0: irq 40 for MSI/MSI-X
> [    1.477251] pcieport-driver 0000:40:0b.0: setting latency timer to 64
> [    1.477288]   alloc irq_desc for 41 on cpu 0 node 0
> [    1.477291]   alloc kstat_irqs on cpu 0 node 0
> [    1.477302] pcieport-driver 0000:40:0b.0: irq 41 for MSI/MSI-X
> [    1.477439] pcieport-driver 0000:40:0c.0: setting latency timer to 64
> [    1.477467]   alloc irq_desc for 42 on cpu 0 node 0
> [    1.477468]   alloc kstat_irqs on cpu 0 node 0
> [    1.477473] pcieport-driver 0000:40:0c.0: irq 42 for MSI/MSI-X
> [    1.477576] pcieport-driver 0000:40:0d.0: setting latency timer to 64
> [    1.477603]   alloc irq_desc for 43 on cpu 0 node 0
> [    1.477605]   alloc kstat_irqs on cpu 0 node 0
> [    1.477610] pcieport-driver 0000:40:0d.0: irq 43 for MSI/MSI-X
> [    1.477709] pcieport-driver 0000:40:0e.0: setting latency timer to 64
> [    1.477736]   alloc irq_desc for 44 on cpu 0 node 0
> [    1.477738]   alloc kstat_irqs on cpu 0 node 0
> [    1.477742] pcieport-driver 0000:40:0e.0: irq 44 for MSI/MSI-X
> [    1.482998] Linux agpgart interface v0.103
> [    1.483040] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    1.483223] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    1.483368] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> [    1.483877] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    1.486606] brd: module loaded
> [    1.486743] input: Macintosh mouse button emulation as /devices/virtual/input/input0
> [    1.487067] PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
> [    1.488782] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    1.488828] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    1.512152] mice: PS/2 mouse device common for all mice
> [    1.512303] rtc_cmos 00:0a: RTC can wake from S4
> [    1.512438] rtc_cmos 00:0a: rtc core: registered rtc_cmos as rtc0
> [    1.512500] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
> [    1.512603] cpuidle: using governor ladder
> [    1.512644] cpuidle: using governor menu
> [    1.512689] No iBFT detected.
> [    1.513078] TCP cubic registered
> [    1.513118] NET: Registered protocol family 17
> [    1.513377] registered taskstats version 1
> [    1.513698] rtc_cmos 00:0a: setting system clock to 2009-06-28 02:57:54 UTC (1246157874)
> [    1.513822] Freeing unused kernel memory: 552k freed
> [    1.614405] processor ACPI_CPU:00: registered as cooling_device0
> [    1.614551] processor ACPI_CPU:01: registered as cooling_device1
> [    1.614678] processor ACPI_CPU:02: registered as cooling_device2
> [    1.614812] processor ACPI_CPU:03: registered as cooling_device3
> [    1.614938] processor ACPI_CPU:04: registered as cooling_device4
> [    1.615065] processor ACPI_CPU:05: registered as cooling_device5
> [    1.615193] processor ACPI_CPU:06: registered as cooling_device6
> [    1.615324] processor ACPI_CPU:07: registered as cooling_device7
> [    1.657949] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    1.658286] ACPI: PCI Interrupt Link [LNU2] enabled at IRQ 11
> [    1.658334] PCI: setting IRQ 11 as level-triggered
> [    1.658338] ehci_hcd 0000:00:02.1: PCI INT B -> Link[LNU2] -> GSI 11 (level, low) -> IRQ 11
> [    1.658443] ehci_hcd 0000:00:02.1: setting latency timer to 64
> [    1.658446] ehci_hcd 0000:00:02.1: EHCI Host Controller
> [    1.658612] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
> [    1.658709] ehci_hcd 0000:00:02.1: debug port 1
> [    1.658751] ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
> [    1.658759] ehci_hcd 0000:00:02.1: irq 11, io mem 0xd9cd0000
> [    1.665613] Uniform Multi-Platform E-IDE driver
> [    1.670705] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    1.672039] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
> [    1.672137] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    1.672186] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.672245] usb usb1: Product: EHCI Host Controller
> [    1.672287] usb usb1: Manufacturer: Linux 2.6.29-2-amd64 ehci_hcd
> [    1.672330] usb usb1: SerialNumber: 0000:00:02.1
> [    1.672440] usb usb1: configuration #1 chosen from 1 choice
> [    1.672508] hub 1-0:1.0: USB hub found
> [    1.672557] hub 1-0:1.0: 10 ports detected
> [    1.672750] amd74xx 0000:00:06.0: UDMA133 controller
> [    1.672794] amd74xx 0000:00:06.0: IDE controller (0x10de:0x0053 rev 0xa3)
> [    1.672851] amd74xx 0000:00:06.0: IDE port disabled
> [    1.672901] amd74xx 0000:00:06.0: not 100% native mode: will probe irqs later
> [    1.672950]     ide0: BM-DMA at 0x0500-0x0507
> [    1.672996] Probing IDE interface ide0...
> [    1.682210] Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v1.9.3 (March 17, 2009)
> [    1.682567] ACPI: PCI Interrupt Link [LNKW] enabled at IRQ 10
> [    1.682613] PCI: setting IRQ 10 as level-triggered
> [    1.682617] bnx2 0000:41:01.0: PCI INT A -> Link[LNKW] -> GSI 10 (level, low) -> IRQ 10
> [    1.694019] SCSI subsystem initialized
> [    1.698233] HP CISS Driver (v 3.6.20)
> [    1.762381] uhci_hcd: USB Universal Host Controller Interface driver
> [    2.036014] usb 1-6: new high speed USB device using ehci_hcd and address 3
> [    2.160042] bnx2 0000:41:01.0: firmware: requesting bnx2-06-4.6.16.fw
> [    2.165414] eth0: Broadcom NetXtreme II BCM5706 1000Base-T (A2) PCI-X 64-bit 100MHz found at mem dc000000, IRQ 10, node addr 00:1c:c4:f0:94:fa
> [    2.170717] ACPI: PCI Interrupt Link [LNKY] enabled at IRQ 11
> [    2.170764] cciss 0000:42:02.0: PCI INT A -> Link[LNKY] -> GSI 11 (level, low) -> IRQ 11
> [    2.171216] usb 1-6: New USB device found, idVendor=04b4, idProduct=6560
> [    2.171275] usb 1-6: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    2.171399] usb 1-6: configuration #1 chosen from 1 choice
> [    2.171617] hub 1-6:1.0: USB hub found
> [    2.171735] hub 1-6:1.0: 4 ports detected
> [    2.288015] IRQ 11/cciss0: IRQF_DISABLED is not guaranteed on shared IRQs
> [    2.288077] cciss0: <0x3220> at PCI 0000:42:02.0 IRQ 11 using DAC
> [    2.289014]       blocks= 286677120 block_size= 512
> [    2.289141]       heads=255, sectors=32, cylinders=35132
> [    2.289142] 
> [    2.289463]       blocks= 286677120 block_size= 512
> [    2.289584]       heads=255, sectors=32, cylinders=35132
> [    2.289585] 
> [    2.289675]  cciss/c0d0: p1 p2
> [    2.290205]       blocks= 860051248 block_size= 512
> [    2.290310]       heads=255, sectors=32, cylinders=105399
> [    2.290311] 
> [    2.290568]       blocks= 860051248 block_size= 512
> [    2.290684]       heads=255, sectors=32, cylinders=105399
> [    2.290685] 
> [    2.290776]  cciss/c0d1: unknown partition table
> [    2.303181] ACPI: PCI Interrupt Link [LNKX] enabled at IRQ 10
> [    2.303228] bnx2 0000:41:02.0: PCI INT A -> Link[LNKX] -> GSI 10 (level, low) -> IRQ 10
> [    2.416129] hda: HL-DT-ST DVDRAM GSA-T20L, ATAPI CD/DVD-ROM drive
> [    2.748059] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
> [    2.748840] hda: UDMA/33 mode selected
> [    2.749272] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> [    2.749407] uhci_hcd 0000:01:04.4: PCI INT B -> Link[LNKX] -> GSI 10 (level, low) -> IRQ 10
> [    2.749478] uhci_hcd 0000:01:04.4: UHCI Host Controller
> [    2.749617] uhci_hcd 0000:01:04.4: new USB bus registered, assigned bus number 2
> [    2.749684] uhci_hcd 0000:01:04.4: port count misdetected? forcing to 2 ports
> [    2.749740] uhci_hcd 0000:01:04.4: HCRESET not completed yet!
> [    2.749797] uhci_hcd 0000:01:04.4: irq 10, io base 0x00001800
> [    2.749888] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
> [    2.749941] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    2.750004] usb usb2: Product: UHCI Host Controller
> [    2.750046] usb usb2: Manufacturer: Linux 2.6.29-2-amd64 uhci_hcd
> [    2.750089] usb usb2: SerialNumber: 0000:01:04.4
> [    2.750174] usb usb2: configuration #1 chosen from 1 choice
> [    2.750243] hub 2-0:1.0: USB hub found
> [    2.750288] hub 2-0:1.0: 2 ports detected
> [    2.750700] ACPI: PCI Interrupt Link [LNU0] enabled at IRQ 5
> [    2.750743] PCI: setting IRQ 5 as level-triggered
> [    2.750747] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNU0] -> GSI 5 (level, low) -> IRQ 5
> [    2.750845] ohci_hcd 0000:00:02.0: setting latency timer to 64
> [    2.750847] ohci_hcd 0000:00:02.0: OHCI Host Controller
> [    2.750948] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 3
> [    2.751023] ohci_hcd 0000:00:02.0: irq 5, io mem 0xd9ce0000
> [    2.780274] bnx2 0000:41:02.0: firmware: requesting bnx2-06-4.6.16.fw
> [    2.785730] eth1: Broadcom NetXtreme II BCM5706 1000Base-T (A2) PCI-X 64-bit 100MHz found at mem da000000, IRQ 10, node addr 00:1c:c4:f0:94:fc
> [    2.806032] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> [    2.806086] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    2.806145] usb usb3: Product: OHCI Host Controller
> [    2.806186] usb usb3: Manufacturer: Linux 2.6.29-2-amd64 ohci_hcd
> [    2.806229] usb usb3: SerialNumber: 0000:00:02.0
> [    2.806352] usb usb3: configuration #1 chosen from 1 choice
> [    2.806420] hub 3-0:1.0: USB hub found
> [    2.806468] hub 3-0:1.0: 10 ports detected
> [    2.819166] libata version 3.00 loaded.
> [    2.827113] ide-cd driver 5.00
> [    2.829247] ide-cd: hda: ATAPI 24X DVD-ROM DVD-R/RAM CD-R/RW drive, 2048kB Cache
> [    2.829435] Uniform CD-ROM driver Revision: 3.20
> [    2.910065] device-mapper: uevent: version 1.0.3
> [    2.910249] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
> [    2.943632] kjournald starting.  Commit interval 5 seconds
> [    2.943642] EXT3-fs: mounted filesystem with ordered data mode.
> [    3.060014] usb 2-1: new full speed USB device using uhci_hcd and address 2
> [    3.206861] usb 2-1: New USB device found, idVendor=03f0, idProduct=1027
> [    3.206921] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    3.206967] usb 2-1: Product: Virtual Keyboard
> [    3.207007] usb 2-1: Manufacturer: HP
> [    3.207126] usb 2-1: configuration #1 chosen from 1 choice
> [    3.324023] usb 2-2: new full speed USB device using uhci_hcd and address 3
> [    3.471454] usb 2-2: New USB device found, idVendor=03f0, idProduct=1327
> [    3.471514] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    3.471560] usb 2-2: Product: Virtual Hub
> [    3.471600] usb 2-2: Manufacturer: HP
> [    3.471716] usb 2-2: configuration #1 chosen from 1 choice
> [    3.476940] hub 2-2:1.0: USB hub found
> [    3.479146] hub 2-2:1.0: 7 ports detected
> [    3.660188] udev: starting version 141
> [    3.672022] usb 3-3: new low speed USB device using ohci_hcd and address 2
> [    3.717779] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
> [    3.733288] ACPI: Power Button (FF) [PWRF]
> [    3.756072] input: PC Speaker as /devices/platform/pcspkr/input/input2
> [    3.764269] hpilo 0000:01:04.2: PCI INT B -> Link[LNKX] -> GSI 10 (level, low) -> IRQ 10
> [    3.786787] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    3.803472] ipmi message handler version 39.2
> [    3.810775] k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
> [    3.810913] k8temp 0000:00:19.3: Temperature readouts might be wrong - check erratum #141
> [    3.811017] k8temp 0000:00:1a.3: Temperature readouts might be wrong - check erratum #141
> [    3.811127] k8temp 0000:00:1b.3: Temperature readouts might be wrong - check erratum #141
> [    3.827837] shpchp 0000:40:10.0: HPC vendor_id 1022 device_id 7458 ss_vid 0 ss_did 0
> [    3.827905] shpchp 0000:40:10.0: Cannot reserve MMIO region
> [    3.827975] shpchp 0000:40:11.0: HPC vendor_id 1022 device_id 7458 ss_vid 0 ss_did 0
> [    3.828037] shpchp 0000:40:11.0: Cannot reserve MMIO region
> [    3.828108] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
> [    3.843713] IPMI System Interface driver.
> [    3.843761] ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca2, slave address 0x20, irq 0
> [    3.849065] usbcore: registered new interface driver hiddev
> [    3.853184] input: HP Virtual Keyboard as /devices/pci0000:00/0000:00:09.0/0000:01:04.4/usb2/2-1/2-1:1.0/input/input3
> [    3.888172] generic-usb 0003:03F0:1027.0001: input,hidraw0: USB HID v1.01 Keyboard [HP Virtual Keyboard] on usb-0000:01:04.4-1/input0
> [    3.891045] usb 3-3: New USB device found, idVendor=0624, idProduct=0341
> [    3.891103] usb 3-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    3.891149] usb 3-3: Product: HP 336047-B21
> [    3.891188] usb 3-3: Manufacturer: Avocent
> [    3.891316] usb 3-3: configuration #1 chosen from 1 choice
> [    3.901667] input: HP Virtual Keyboard as /devices/pci0000:00/0000:00:09.0/0000:01:04.4/usb2/2-1/2-1:1.1/input/input4
> [    3.937388] Error: Driver 'pcspkr' is already registered, aborting...
> [    3.940117] generic-usb 0003:03F0:1027.0002: input,hidraw1: USB HID v1.01 Mouse [HP Virtual Keyboard] on usb-0000:01:04.4-1/input1
> [    3.946242] ipmi: Found new BMC (man_id: 0x00000b,  prod_id: 0x0000, dev_id: 0x11)
> [    3.946310] IPMI kcs interface initialized
> [    3.946360] ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
> [    3.946423] ipmi_si: duplicate interface
> [    3.947321] input: Avocent HP 336047-B21 as /devices/pci0000:00/0000:00:02.0/usb3/3-3/3-3:1.0/input/input5
> [    3.960092] ipmi_si 0000:01:04.6: PCI INT A -> Link[LNKW] -> GSI 10 (level, low) -> IRQ 10
> [    3.960158] ipmi_si: Trying PCI-specified kcs state machine at mem address 0xd9df0000, slave address 0x0, irq 10
> [    3.976097] generic-usb 0003:0624:0341.0003: input,hidraw2: USB HID v1.10 Keyboard [Avocent HP 336047-B21] on usb-0000:00:02.0-3/input0
> [    3.984450] input: Avocent HP 336047-B21 as /devices/pci0000:00/0000:00:02.0/usb3/3-3/3-3:1.1/input/input6
> [    4.037055] generic-usb 0003:0624:0341.0004: input,hidraw3: USB HID v1.10 Mouse [Avocent HP 336047-B21] on usb-0000:00:02.0-3/input1
> [    4.037144] usbcore: registered new interface driver usbhid
> [    4.037188] usbhid: v2.6:USB HID core driver
> [    4.044016] IRQ 10/ipmi_si: IRQF_DISABLED is not guaranteed on shared IRQs
> [    4.044067]   Using irq 10
> [    4.244525] ipmi: interfacing existing BMC (man_id: 0x00000b, prod_id: 0x0000, dev_id: 0x11)
> [    4.244614] IPMI kcs interface initialized
> [    5.541780] EXT3 FS on cciss/c0d0p1, internal journal
> [    6.490708] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
> [    6.490770] All bugs added by David S. Miller <davem@redhat.com>
> [    6.501484] ipmi device interface
> [    7.581197] kjournald starting.  Commit interval 5 seconds
> [    7.581313] EXT3 FS on dm-1, internal journal
> [    7.581393] EXT3-fs: mounted filesystem with ordered data mode.
> [    7.601860] kjournald starting.  Commit interval 5 seconds
> [    7.601977] EXT3 FS on dm-2, internal journal
> [    7.602055] EXT3-fs: mounted filesystem with ordered data mode.
> [    7.633870] kjournald starting.  Commit interval 5 seconds
> [    7.634010] EXT3 FS on dm-4, internal journal
> [    7.634084] EXT3-fs: mounted filesystem with ordered data mode.
> [    7.641979] kjournald starting.  Commit interval 5 seconds
> [    7.652121] EXT3 FS on dm-0, internal journal
> [    7.652201] EXT3-fs: mounted filesystem with ordered data mode.
> [    7.752963] Adding 16777208k swap on /dev/mapper/vg0-swap.  Priority:-1 extents:1 across:16777208k 
> [    8.216114] NET: Registered protocol family 15
> [    8.231384] alg: No test for cipher_null (cipher_null-generic)
> [    8.231512] alg: No test for digest_null (digest_null-generic)
> [    8.231595] alg: No test for compress_null (compress_null-generic)
> [    8.615567] NET: Registered protocol family 10
> [    8.616350] lo: Disabled Privacy Extensions
> [    8.633924] Ethernet Channel Bonding Driver: v3.5.0 (November 4, 2008)
> [    8.633975] bonding: MII link monitoring set to 100 ms
> [    8.672186] ADDRCONF(NETDEV_UP): bond0: link is not ready
> [    8.675086] bonding: bond0: Adding slave eth0.
> [    8.812032] bonding: bond0: enslaving eth0 as a backup interface with a down link.
> [    8.814592] bonding: bond0: Adding slave eth1.
> [    8.944136] bonding: bond0: enslaving eth1 as a backup interface with a down link.
> [    9.368629] Initializing XFRM netlink socket
> [   11.880402] bnx2: eth0 NIC Copper Link is Up, 1000 Mbps full duplex
> [   11.964017] bonding: bond0: link status up for interface eth0, enabling it in 10000 ms.
> [   12.067990] bnx2: eth1 NIC Copper Link is Up, 1000 Mbps full duplex
> [   12.164013] bonding: bond0: link status up for interface eth1, enabling it in 10000 ms.
> [   21.964014] bonding: bond0: link status definitely up for interface eth0.
> [   21.964064] bonding: bond0: making interface eth0 the new active one.
> [   21.964159] bonding: bond0: first active interface up!
> [   21.967154] ADDRCONF(NETDEV_CHANGE): bond0: link becomes ready
> [   22.164014] bonding: bond0: link status definitely up for interface eth1.
> [   32.348014] bond0: no IPv6 routers present
> [   34.821259] Fusion MPT base driver 3.04.07
> [   34.821434] Copyright (c) 1999-2008 LSI Corporation
> [   34.823818] Fusion MPT misc device (ioctl) driver 3.04.07
> [   34.824041] mptctl: Registered with Fusion MPT base driver
> [   34.824219] mptctl: /dev/mptctl @ (major,minor=10,220)
> [   37.029775] lp: driver loaded but no devices found
> [   37.041141] ppdev: user-space parallel port driver

> 00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev a4)
> 00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev b1)
> 00:02.0 USB Controller: nVidia Corporation CK804 USB Controller (rev a2)
> 00:02.1 USB Controller: nVidia Corporation CK804 USB Controller (rev a4)
> 00:06.0 IDE interface: nVidia Corporation CK804 IDE (rev a3)
> 00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev a2)
> 00:0c.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
> 00:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
> 00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
> 00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
> 00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
> 00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
> 00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
> 00:19.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
> 00:19.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
> 00:19.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
> 00:19.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
> 00:1a.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
> 00:1a.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
> 00:1a.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
> 00:1a.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
> 00:1b.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
> 00:1b.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
> 00:1b.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
> 00:1b.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
> 01:03.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)
> 01:04.0 System peripheral: Compaq Computer Corporation Integrated Lights Out Controller (rev 03)
> 01:04.2 System peripheral: Compaq Computer Corporation Integrated Lights Out  Processor (rev 03)
> 01:04.4 USB Controller: Hewlett-Packard Company Proliant iLO2 virtual USB controller
> 01:04.6 IPMI SMIC interface: Hewlett-Packard Company Proliant iLO2 virtual UART
> 40:00.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev a4)
> 40:01.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev b1)
> 40:0b.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
> 40:0c.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
> 40:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
> 40:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
> 40:10.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8132 PCI-X Bridge (rev 12)
> 40:10.1 PIC: Advanced Micro Devices [AMD] AMD-8132 PCI-X IOAPIC (rev 12)
> 40:11.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8132 PCI-X Bridge (rev 12)
> 40:11.1 PIC: Advanced Micro Devices [AMD] AMD-8132 PCI-X IOAPIC (rev 12)
> 41:01.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5706 Gigabit Ethernet (rev 02)
> 41:02.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5706 Gigabit Ethernet (rev 02)
> 42:02.0 RAID bus controller: Hewlett-Packard Company Smart Array P600

>            CPU0       CPU1       CPU2       CPU3       CPU4       CPU5       CPU6       CPU7       
>   0:         45          1          0          0          1          0          0          0    XT-PIC-XT        timer
>   1:          2          0          0          0          0          0          0          0    XT-PIC-XT        i8042
>   2:          0          0          0          0          0          0          0          0    XT-PIC-XT        cascade
>   3:          4          0          1          0          2          0          1          0    XT-PIC-XT        serial
>   4:          4          0          0          0          2          0          0          0    XT-PIC-XT      
>   5:         20          1          5          0         10          0          1          0    XT-PIC-XT        ohci_hcd:usb3
>   7:      10336      96993     100292     100678      98680     100812     100704     101045    XT-PIC-XT      
>   8:          1          0          0          0          0          0          0          0    XT-PIC-XT        rtc0
>   9:          0          0          0          0          0          0          0          0    XT-PIC-XT        acpi
>  10:      59622       2604        485        547       1719        324        278        251    XT-PIC-XT        uhci_hcd:usb2, ipmi_si, eth0, eth1
>  11:      23514       1731        541        100        978        200        395         24    XT-PIC-XT        ehci_hcd:usb1, cciss0
>  12:          3          1          0          0          0          0          0          0    XT-PIC-XT        i8042
>  14:       7924         65         58          2         29         10         20          1    XT-PIC-XT        ide0
> NMI:          0          0          0          0          0          0          0          0   Non-maskable interrupts
> LOC:     336945     208438     267680     138102      30869      39594     481144      70316   Local timer interrupts
> RES:      13214       6855       9075       4379      12955      13070      23612      13817   Rescheduling interrupts
> CAL:         91        212        217        230        218        217        223        223   Function call interrupts
> TLB:       1986        613        559        447       2931       4132       3842       3516   TLB shootdowns
> TRM:          0          0          0          0          0          0          0          0   Thermal event interrupts
> THR:          0          0          0          0          0          0          0          0   Threshold APIC interrupts
> SPU:          0          0          0          0          0          0          0          0   Spurious interrupts
> ERR:     709540
> MIS:          0

> 
> System        : ProLiant DL585 G2   
> Serial No.    : XXXXXXXXXXXXXX
> ROM version   : A07 03/11/2009
> iLo present   : Yes
> Embedded NICs : 2
> 	NIC1 MAC: XXXXXXXXXXXXXXXXX
> 	NIC2 MAC: XXXXXXXXXXXXXXXXX
> 
> Processor: 0
> 	Name         : AMD Opteron
> 	Stepping     : 3
> 	Speed        : 2800 MHz
> 	Bus          : 0 MHz
> 	Core         : 2
> 	Thread       : 2
> 	Socket       : 1
> 	Level2 Cache : 2048 KBytes
> 	Status       : Ok
> 
> Processor: 1
> 	Name         : AMD Opteron
> 	Stepping     : 3
> 	Speed        : 2800 MHz
> 	Bus          : 0 MHz
> 	Core         : 2
> 	Thread       : 2
> 	Socket       : 2
> 	Level2 Cache : 2048 KBytes
> 	Status       : Ok
> 
> Processor: 2
> 	Name         : AMD Opteron
> 	Stepping     : 3
> 	Speed        : 2800 MHz
> 	Bus          : 0 MHz
> 	Core         : 2
> 	Thread       : 2
> 	Socket       : 3
> 	Level2 Cache : 2048 KBytes
> 	Status       : Ok
> 
> Processor: 3
> 	Name         : AMD Opteron
> 	Stepping     : 3
> 	Speed        : 2800 MHz
> 	Bus          : 0 MHz
> 	Core         : 2
> 	Thread       : 2
> 	Socket       : 4
> 	Level2 Cache : 2048 KBytes
> 	Status       : Ok
> 
> Processor total  : 4
> 
> Memory installed : 16384 MBytes
> ECC supported    : Yes
> 

