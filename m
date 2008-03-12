Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbYCLTd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbYCLTd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 15:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbYCLTdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 15:33:15 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:32245 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520AbYCLTdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 15:33:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=I43yykLAJsUuYl8tCTEZsn3vFnuYgQRjLMKFOkUeWBeNvSl5jJnD129ufuXCCqO3We5GTl4tAykAvqieMB66Tz7h/VbyMWXyQxAIdkjJ5i76eaQ0mJyvKYxb0n95QQ5Ut5XuJnyjcAUekaPCSi8ouTfeHQd+gWGT5NPpXpl9L64=
Message-ID: <64bb37e0803121233v30d12a58i77a1e23fd02ea6f2@mail.gmail.com>
Date: Wed, 12 Mar 2008 20:33:02 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.25-rc5-mm1
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080311133920.68dc410b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
	 <20080311202300.GA8957@vino.hallyn.com>
	 <20080311133920.68dc410b.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 9:39 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>  > Quoting Andrew Morton (akpm@linux-foundation.org):
>  > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc5/2.6.25-rc5-mm1/
>  I suspect that fewer people are testing linux-next and -mm nowadays.  We
>  should encourage them to do so, although given the general
>  trainwreckishness of current mainline, this isn't really where our effort
>  should be expended.

2.6.25-rc3-mm1 worked nicely for me, but 2.6.25-rc5-mm1 does not boot.

dmesg:
[    0.000000] Linux version 2.6.25-rc5-mm1 (root@treogen) (gcc
version 4.2.3 (Gentoo 4.2.3 p1.0)) #1 SMP Wed Mar 12 19:51:41 CET 2008
[    0.000000] Command line: earlyprintk=serial,ttyS0,115200
console=ttyS0,115200 console=tty1 crypt_root=/dev/md1 sata_nv.swncq=1
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000dffd0000 (usable)
[    0.000000]  BIOS-e820: 00000000dffd0000 - 00000000dffde000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000dffde000 - 00000000e0000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] console [earlyser0] enabled
[    0.000000] end_pfn_map = 1179648
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000FB080, 0024 (r2 ACPIAM)
[    0.000000] ACPI: XSDT DFFD0100, 0064 (r1 A_M_I_ OEMXSDT   4000713
MSFT       97)
[    0.000000] ACPI: FACP DFFD0290, 00F4 (r3 A_M_I_ OEMFACP   4000713
MSFT       97)
[    0.000000] ACPI: DSDT DFFD0450, 4FC5 (r1  S0027 S0027000        0
INTL 20051117)
[    0.000000] ACPI: FACS DFFDE000, 0040
[    0.000000] ACPI: APIC DFFD0390, 0080 (r1 A_M_I_ OEMAPIC   4000713
MSFT       97)
[    0.000000] ACPI: MCFG DFFD0410, 003C (r1 A_M_I_ OEMMCFG   4000713
MSFT       97)
[    0.000000] ACPI: OEMB DFFDE040, 0060 (r1 A_M_I_ AMI_OEM   4000713
MSFT       97)
[    0.000000] ACPI: HPET DFFD5420, 0038 (r1 A_M_I_ OEMHPET0  4000713
MSFT       97)
[    0.000000] ACPI: MCFG DFFD5460, 003C (r1 A_M_I_ OEMMCFG   4000713
MSFT       97)
[    0.000000] ACPI: SRAT DFFD54A0, 0110 (r1 AMD    HAMMER          1
AMD         1)
[    0.000000] ACPI: SSDT DFFD55B0, 04F0 (r1 A_M_I_ POWERNOW        1
AMD         1)
[    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 1 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 2 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 3 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 0-a0000
[    0.000000] SRAT: Node 0 PXM 0 0-80000000
[    0.000000] SRAT: Node 1 PXM 1 80000000-e0000000
[    0.000000] SRAT: Node 1 PXM 1 80000000-120000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000080000000
[    0.000000]   NODE_DATA [0000000000001000 - 0000000000004fff]
[    0.000000]   bootmap [000000000000e000 -  000000000001dfff] pages 10
[    0.000000] Bootmem setup node 1 0000000080000000-0000000120000000
[    0.000000]   NODE_DATA [0000000080000000 - 0000000080003fff]
[    0.000000]   bootmap [0000000080004000 -  0000000080017fff] pages 14
[    0.000000] early res: 0 [0-fff] BIOS data page
[    0.000000] early res: 1 [6000-7fff] TRAMPOLINE
[    0.000000] early res: 2 [200000-8e5a9b] TEXT DATA BSS
[    0.000000] early res: 3 [37ec8000-37fefc27] RAMDISK
[    0.000000] early res: 4 [9fc00-fffff] BIOS reserved
[    0.000000] early res: 5 [8000-dfff] PGTABLE
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1179648
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   524288
[    0.000000]     1:   524288 ->   917456
[    0.000000]     1:  1048576 ->  1179648
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x2008
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] Processor #2
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] Processor #3
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at e2000000 (gap:
e0000000:1ec00000)
[    0.000000] PERCPU: Allocating 35080 bytes of per cpu data
[    0.000000] Built 2 zonelists in Node order, mobility grouping on.
Total pages: 1030431
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: earlyprintk=serial,ttyS0,115200
console=ttyS0,115200 console=tty1 crypt_root=/dev/md1 sata_nv.swncq=1
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC calibrated against PM_TIMER
[    0.000001] Marking TSC unstable due to TSCs unsynchronized
[    0.005534] time.c: Detected 2599.995 MHz processor.
[    0.010000] Console: colour VGA+ 80x25
[    0.010000] console handover: boot [earlyser0] -> real [tty1]
[    0.010000] console [ttyS0] enabled
[    0.010000] Checking aperture...
[    0.010000] Node 0: aperture @ 8000000 size 32 MB
[    0.010000] Aperture pointing to e820 RAM. Ignoring.
[    0.010000] No AGP bridge found
[    0.010000] Your BIOS doesn't leave a aperture memory hole
[    0.010000] Please enable the IOMMU option in the BIOS setup
[    0.010000] This costs you 64 MB of RAM
[    0.010000] Mapping aperture over 65536 KB of RAM @ 8000000
[    0.010000] Memory: 4060040k/4718592k available (3884k kernel code,
133684k reserved, 2036k data, 372k init)
[    0.010000] SLUB: Genslabs=13, HWalign=64, Order=0-4,
MinObjects=60, CPUs=4, Nodes=2
[    0.150001] Calibrating delay using timer specific routine..
5203.20 BogoMIPS (lpj=26016027)
[    0.158478] Security Framework initialized
[    0.160005] Capability LSM initialized
[    0.164042] Dentry cache hash table entries: 524288 (order: 10,
4194304 bytes)
[    0.172635] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.181133] Mount-cache hash table entries: 256
[    0.185923] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.190003] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.200002] CPU 0/0 -> Node 0
[    0.202979] CPU: Physical Processor ID: 0
[    0.206990] CPU: Processor Core ID: 0
[    0.210015] Freeing SMP alternatives: 30k freed
[    0.214561] ACPI: Core revision 20070126
[    0.329978] Using local APIC timer interrupts.
[    0.340002] Detected 12.499 MHz APIC timer.
[    0.344305] Booting processor 1/4 APIC 0x1
[    0.350000] Initializing CPU#1
[    0.499978] Calibrating delay using timer specific routine..
5200.06 BogoMIPS (lpj=26000325)
[    0.499978] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.499978] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.499978] CPU 1/1 -> Node 0
[    0.499978] CPU: Physical Processor ID: 0
[    0.499978] CPU: Processor Core ID: 1
[    0.499978] Dual-Core AMD Opteron(tm) Processor 2218 stepping 02
[    0.500225] Booting processor 2/4 APIC 0x2
[    0.543283] Initializing CPU#2
[    0.693305] Calibrating delay using timer specific routine..
5200.08 BogoMIPS (lpj=26000447)
[    0.693305] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.693305] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.693305] CPU 2/2 -> Node 1
[    0.693305] CPU: Physical Processor ID: 1
[    0.693305] CPU: Processor Core ID: 0
[    0.703305] Dual-Core AMD Opteron(tm) Processor 2218 stepping 02
[    0.703305] Booting processor 3/4 APIC 0x3
[    0.753292] Initializing CPU#3
[    0.903314] Calibrating delay using timer specific routine..
5200.09 BogoMIPS (lpj=26000470)
[    0.903314] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.903314] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.903314] CPU 3/3 -> Node 1
[    0.903314] CPU: Physical Processor ID: 1
[    0.903314] CPU: Processor Core ID: 1
[    0.913305] Dual-Core AMD Opteron(tm) Processor 2218 stepping 02
[    0.913314] Brought up 4 CPUs
[    0.953672] net_namespace: 1008 bytes
[    0.957438] xor: automatically using best checksumming function: generic_sse
[    1.013347]    generic_sse:  8023.600 MB/sec
[    1.023323] xor: using function: generic_sse (8023.600 MB/sec)
[    1.033323] NET: Registered protocol family 16
[    1.037852] ACPI: bus type pci registered
[    1.041915] PCI: BIOS Bug: MCFG area at f0000000 is not E820-reserved
[    1.043325] PCI: Not using MMCONFIG.
[    1.046902] PCI: Using configuration type 1
[    1.073324] ACPI: Interpreter enabled
[    1.076994] ACPI: (supports S0 S5)
[    1.083919] ACPI: Using IOAPIC for interrupt routing
[    1.089159] ACPI: Error attaching device data
[    1.093328] ACPI: Error attaching device data
[    1.097693] ACPI: Error attaching device data
[    1.104575] ACPI: Error attaching device data
[    1.123338] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.134180] PCI: Transparent bridge - 0000:00:06.0
[    1.153607] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *11
[    1.165483] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *0, disabled.
[    1.180555] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *10
[    1.187169] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
[    1.193460] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *10
[    1.203096] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[    1.209720] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, disabled.
[    1.213986] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *5
[    1.224227] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *10
[    1.230850] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0, disabled.
[    1.235203] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *11
[    1.245440] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disabled.
[    1.254749] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *11
[    1.261373] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[    1.275451] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *5
[    1.286979] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *5
[    1.293515] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *10
[    1.297993] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disabled.
[    1.307670] ACPI: PCI Interrupt Link [LSA2] (IRQs 20 21 22 23) *10
[    1.314222] ACPI Warning (tbutils-0217): Incorrect checksum in
table [OEMB] -  EC, should be E7 [20070126]
[    1.329475] Linux Plug and Play Support v0.97 (c) Adam Belay
[    1.333563] pnp: PnP ACPI init
[    1.336626] ACPI: bus type pnp registered
[    1.361729] pnp: PnP ACPI: found 14 devices
[    1.366468] ACPI: ACPI bus type pnp unregistered
[    1.371171] SCSI subsystem initialized
[    1.386467] usbcore: registered new interface driver usbfs
[    1.391745] usbcore: registered new interface driver hub
[    1.401747] usbcore: registered new device driver usb
[    1.406887] PCI: Using ACPI for IRQ routing
[    1.467808] NetLabel: Initializing
[    1.467808] NetLabel:  domain hash size = 128
[    1.467808] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.477819] NetLabel:  unlabeled traffic allowed by default
[    1.483441] PCI-DMA: Disabling AGP.
[    1.488846] PCI-DMA: aperture base @ 8000000 size 65536 KB
[    1.494336] PCI-DMA: using GART IOMMU.
[    1.508403] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    1.515665] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    1.519492] hpet0: 3 32-bit timers, 25000000 Hz
[    1.525708] Time: hpet clocksource has been installed.
[    1.621408] system 00:06: ioport range 0x4d0-0x4d1 has been reserved
[    1.627759] system 00:06: ioport range 0x7b0-0x7df has been reserved
[    1.641403] system 00:06: ioport range 0x800-0x80f has been reserved
[    1.647757] system 00:06: ioport range 0xbb0-0xbdf has been reserved
[    1.671377] system 00:06: ioport range 0x2000-0x207f has been reserved
[    1.684811] system 00:06: ioport range 0x2080-0x20ff has been reserved
[    1.694820] system 00:06: ioport range 0x2400-0x247f has been reserved
[    1.701346] system 00:06: ioport range 0x2480-0x24ff has been reserved
[    1.724752] system 00:06: ioport range 0x2800-0x287f has been reserved
[    1.731277] system 00:06: ioport range 0x2880-0x28ff has been reserved
[    1.741253] system 00:06: ioport range 0x2c00-0x2c7f has been reserved
[    1.764694] system 00:06: ioport range 0x2c80-0x2cff has been reserved
[    1.771364] system 00:06: iomem range 0x0-0x0 could not be reserved
[    1.781197] system 00:06: iomem range 0xfee01000-0xfeefffff could
not be reserved
[    1.803686] system 00:06: iomem range 0xefa80000-0xefabffff has been reserved
[    1.810817] system 00:06: iomem range 0xffb00000-0xffbfffff could
not be reserved
[    1.821138] system 00:06: iomem range 0xfff00000-0xffffffff could
not be reserved
[    1.843635] system 00:08: iomem range 0xfec00000-0xfec00fff could
not be reserved
[    1.863590] system 00:08: iomem range 0xfee00000-0xfee00fff could
not be reserved
[    1.871071] system 00:0c: ioport range 0x290-0x297 has been reserved
[    1.881056] system 00:0d: iomem range 0x0-0x9ffff could not be reserved
[    1.904232] system 00:0d: iomem range 0xc0000-0xcffff has been reserved
[    1.910842] system 00:0d: iomem range 0xe0000-0xfffff could not be reserved
[    1.920992] system 00:0d: iomem range 0x100000-0xdfffffff could not
be reserved
[    1.943656] system 00:0d: iomem range 0xfec00000-0xffffffff could
not be reserved
[    1.961251] PCI: Bridge: 0000:00:06.0
[    1.964921]   IO window: disabled.
[    1.968331]   MEM window: 0xeff00000-0xefffffff
[    1.980903]   PREFETCH window: 0x00000000eef00000-0x00000000eeffffff
[    1.987254] PCI: Bridge: 0000:00:0b.0
[    2.000871]   IO window: e000-efff
[    2.004283]   MEM window: 0xefe00000-0xefefffff
[    2.022569]   PREFETCH window: disabled.
[    2.026646] PCI: Bridge: 0000:00:0c.0
[    2.030312]   IO window: disabled.
[    2.040486]   MEM window: 0xefd00000-0xefdfffff
[    2.045020]   PREFETCH window: disabled.
[    2.050486] PCI: Bridge: 0000:00:0d.0
[    2.062526]   IO window: disabled.
[    2.065935]   MEM window: 0xefc00000-0xefcfffff
[    2.082499]   PREFETCH window: disabled.
[    2.086432] PCI: Bridge: 0000:00:0f.0
[    2.092499]   IO window: d000-dfff
[    2.102467]   MEM window: 0xefb00000-0xefbfffff
[    2.107000]   PREFETCH window: 0x00000000e0000000-0x00000000e7ffffff
[    2.122526] NET: Registered protocol family 2
-> System hang, no reaction to the SysRq keys.

>From 2.6.25-rc3-mm1:
[    1.505990] PCI: Bridge: 0000:00:06.0
[    1.509654]   IO window: disabled.
[    1.513064]   MEM window: 0xeff00000-0xefffffff
[    1.515228]   PREFETCH window: 0x00000000eef00000-0x00000000eeffffff
[    1.521579] PCI: Bridge: 0000:00:0b.0
[    1.525226]   IO window: e000-efff
[    1.528638]   MEM window: 0xefe00000-0xefefffff
[    1.535226]   PREFETCH window: disabled.
[    1.539295] PCI: Bridge: 0000:00:0c.0
[    1.542960]   IO window: disabled.
[    1.545226]   MEM window: 0xefd00000-0xefdfffff
[    1.549763]   PREFETCH window: disabled.
[    1.555227] PCI: Bridge: 0000:00:0d.0
[    1.558897]   IO window: disabled.
[    1.562304]   MEM window: 0xefc00000-0xefcfffff
[    1.565226]   PREFETCH window: disabled.
[    1.569159] PCI: Bridge: 0000:00:0f.0
[    1.575226]   IO window: d000-dfff
[    1.578632]   MEM window: 0xefb00000-0xefbfffff
[    1.583162]   PREFETCH window: 0x00000000e0000000-0x00000000e7ffffff
[    1.585317] NET: Registered protocol family 2
[    1.695224] IP route cache hash table entries: 131072 (order: 8,
1048576 bytes)
[    1.695224] TCP established hash table entries: 524288 (order: 11,
8388608 bytes)
[    1.705988] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.713229] TCP: Hash tables configured (established 524288 bind 65536)
[    1.715227] TCP reno registered
[    1.755225] Unpacking initramfs... done
[    1.782287] Freeing initrd memory: 1183k freed
[    1.275858] Total HugeTLB memory allocated, 0
[    1.282821] VFS: Disk quotas dquot_6.5.1
[    1.283955] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.294007] SGI XFS with ACLs, security attributes, large
block/inode numbers, no debug enabled
[    1.303487] SGI XFS Quota Management subsystem

Torsten
