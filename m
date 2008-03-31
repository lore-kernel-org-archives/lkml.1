Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbYCaJ5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbYCaJ5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 05:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755621AbYCaJ5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 05:57:05 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:3761 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721AbYCaJ4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 05:56:46 -0400
Date: Mon, 31 Mar 2008 11:57:30 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: nobody cared about IRQ 19 (firewire, on a HP 2510p notebook)
Message-ID: <20080331095729.GI28821@deprecation.cyrius.com>
References: <20080321153952.GA26354@deprecation.cyrius.com> <47E3E2CF.5070408@s5r6.in-berlin.de> <47EF757F.9080501@s5r6.in-berlin.de> <20080330161339.GC28821@deprecation.cyrius.com> <47EFD09D.3020906@s5r6.in-berlin.de> <alpine.LFD.1.10.0803302201110.3219@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1UWUbFP1cBYEclgG"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0803302201110.3219@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1UWUbFP1cBYEclgG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Thomas Gleixner <tglx@linutronix.de> [2008-03-30 22:10]:
> Can we please have a full boot log (dmesg) and the output of /proc/interrupts and "lspci -vvv"

I've attached all of that information.
-- 
Martin Michlmayr
http://www.cyrius.com/

--1UWUbFP1cBYEclgG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.25-rc7-amd64 (Debian 2.6.25~rc7-1~experimental.1~snapshot.11011) (waldi@debian.org) (gcc version 4.1.3 20080114 (prerelease) (Debian 4.1.2-19)) #1 SMP Sun Mar 30 17:36:02 CEST 2008
[    0.000000] Command line: root=/dev/mapper/lucky-root ro vga=791
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f7b0000 (usable)
[    0.000000]  BIOS-e820: 000000007f7b0000 - 000000007f7c5400 (reserved)
[    0.000000]  BIOS-e820: 000000007f7c5400 - 000000007f7e7fb8 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007f7e7fb8 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed9a000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000fedc0000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 522160) 1 entries of 3200 used
[    0.000000] end_pfn_map = 1048576
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000F77A0, 0024 (r2 HP    )
[    0.000000] ACPI: XSDT 7F7C81C4, 0074 (r1 HPQOEM SLIC-MPC        1 HP          1)
[    0.000000] ACPI: FACP 7F7C8084, 00F4 (r4 HP     30C9            3 HP          1)
[    0.000000] ACPI: DSDT 7F7C84C0, 13484 (r1 HP       nc2500    10000 MSFT  3000001)
[    0.000000] ACPI: FACS 7F7E7D80, 0040
[    0.000000] ACPI: SLIC 7F7C8238, 0176 (r1 HPQOEM SLIC-MPC        1 HP          1)
[    0.000000] ACPI: HPET 7F7C83B0, 0038 (r1 HP     30C9            1 HP          1)
[    0.000000] ACPI: APIC 7F7C83E8, 0068 (r1 HP     30C9            1 HP          1)
[    0.000000] ACPI: MCFG 7F7C8450, 003C (r1 HP     30C9            1 HP          1)
[    0.000000] ACPI: TCPA 7F7C848C, 0032 (r2 HP     30C9            1 HP          1)
[    0.000000] ACPI: SSDT 7F7DB944, 02BE (r1 HP       HPQPAT        1 MSFT  3000001)
[    0.000000] ACPI: SSDT 7F7DC586, 025F (r1 HP      Cpu0Tst     3000 INTL 20060317)
[    0.000000] ACPI: SSDT 7F7DC7E5, 00A6 (r1 HP      Cpu1Tst     3000 INTL 20060317)
[    0.000000] ACPI: SSDT 7F7DC88B, 04D7 (r1 HP        CpuPm     3000 INTL 20060317)
[    0.000000] ACPI: DMI detected: Hewlett-Packard
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007f7b0000
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 522160) 1 entries of 3200 used
[    0.000000] Bootmem setup node 0 0000000000000000-000000007f7b0000
[    0.000000]   NODE_DATA [000000000000c000 - 0000000000012fff]
[    0.000000]   bootmap [0000000000013000 -  0000000000022ef7] pages 10
[    0.000000] early res: 0 [0-fff] BIOS data page
[    0.000000] early res: 1 [6000-7fff] SMP_TRAMPOLINE
[    0.000000] early res: 2 [200000-6464a7] TEXT DATA BSS
[    0.000000] early res: 3 [37909000-37fef295] RAMDISK
[    0.000000] early res: 4 [9fc00-a0bff] EBDA
[    0.000000] early res: 5 [8000-bfff] PGTABLE
[    0.000000] No mptable found.
[    0.000000]  [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
[    0.000000]  [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
[    0.000000]  [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
[    0.000000]  [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
[    0.000000]  [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
[    0.000000]  [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
[    0.000000]  [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
[    0.000000]  [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 on node 0
[    0.000000]  [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 on node 0
[    0.000000]  [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 on node 0
[    0.000000]  [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 on node 0
[    0.000000]  [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 on node 0
[    0.000000]  [ffffe20001800000-ffffe200019fffff] PMD ->ffff810004200000 on node 0
[    0.000000]  [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810004600000 on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   522160
[    0.000000] On node 0 totalpages: 522063
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1102 pages reserved
[    0.000000]   DMA zone: 2841 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7082 pages used for memmap
[    0.000000]   DMA32 zone: 510982 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 35224 bytes of per cpu data
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 513823
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/mapper/lucky-root ro vga=791
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC calibrated against PM_TIMER
[    0.000002] time.c: Detected 1196.998 MHz processor.
[    0.000033] Console: colour dummy device 80x25
[    0.000037] console [tty0] enabled
[    0.000312] Checking aperture...
[    0.000331] Calgary: detecting Calgary via BIOS EBDA area
[    0.000334] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.004000] Memory: 2047828k/2088640k available (2205k kernel code, 40424k reserved, 1027k data, 372k init)
[    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.004000] hpet clockevent registered
[    0.080009] Calibrating delay using timer specific routine.. 2397.27 BogoMIPS (lpj=4794551)
[    0.080086] Security Framework initialized
[    0.080096] SELinux:  Disabled at boot.
[    0.080103] Capability LSM initialized
[    0.080473] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.082281] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.083199] Mount-cache hash table entries: 256
[    0.083436] Initializing cgroup subsys ns
[    0.083445] Initializing cgroup subsys cpuacct
[    0.083478] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.083485] CPU: L2 cache: 2048K
[    0.083492] CPU 0/0 -> Node 0
[    0.083496] CPU: Physical Processor ID: 0
[    0.083501] CPU: Processor Core ID: 0
[    0.083514] CPU0: Thermal monitoring handled by SMI
[    0.083516] using mwait in idle threads.
[    0.084014] ACPI: Core revision 20070126
[    0.159849] Using local APIC timer interrupts.
[    0.160012] APIC timer calibration result 8312498
[    0.160015] Detected 8.312 MHz APIC timer.
[    0.160257] Booting processor 1/2 APIC 0x1
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 2394.01 BogoMIPS (lpj=4788021)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 2048K
[    0.004000] CPU 1/1 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.004000] Intel(R) Core(TM)2 Duo CPU     U7600  @ 1.20GHz stepping 0d
[    0.248605] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.252053] Brought up 2 CPUs
[    0.252179] CPU0 attaching sched-domain:
[    0.252183]  domain 0: span 00000003
[    0.252186]   groups: 00000001 00000002
[    0.252191]   domain 1: span 00000003
[    0.252194]    groups: 00000003
[    0.252198] CPU1 attaching sched-domain:
[    0.252201]  domain 0: span 00000003
[    0.252203]   groups: 00000002 00000001
[    0.252208]   domain 1: span 00000003
[    0.252210]    groups: 00000003
[    0.252623] net_namespace: 1016 bytes
[    0.252633] Booting paravirtualized kernel on bare hardware
[    0.252958] NET: Registered protocol family 16
[    0.253267] ACPI: bus type pci registered
[    0.253402] PCI: BIOS Bug: MCFG area at f8000000 is not E820-reserved
[    0.253409] PCI: Not using MMCONFIG.
[    0.253414] PCI: Using configuration type 1
[    0.256981] ACPI: EC: Look up EC in DSDT
[    0.006529] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.352927] ACPI: Interpreter enabled
[    0.352935] ACPI: (supports S0 S3 S4 S5)
[    0.352961] ACPI: Using IOAPIC for interrupt routing
[    0.373140] ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
[    0.373149] ACPI: EC: driver started in interrupt mode
[    0.373254] ACPI: PCI Root Bridge [C003] (0000:00)
[    0.374568] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[    0.374580] pci 0000:00:1f.0: quirk: region 1100-113f claimed by ICH6 GPIO
[    0.375467] PCI: Transparent bridge - 0000:00:1e.0
[    0.375547] ACPI: PCI Interrupt Routing Table [\_SB_.C003._PRT]
[    0.376539] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C0B2._PRT]
[    0.376876] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C11F._PRT]
[    0.377174] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C133._PRT]
[    0.457624] ACPI: PCI Interrupt Link [C12F] (IRQs *10 11)
[    0.458064] ACPI: PCI Interrupt Link [C130] (IRQs *10 11)
[    0.458499] ACPI: PCI Interrupt Link [C131] (IRQs 10 *11)
[    0.458932] ACPI: PCI Interrupt Link [C132] (IRQs 10 11) *5
[    0.459369] ACPI: PCI Interrupt Link [C142] (IRQs *10 11)
[    0.459788] ACPI: PCI Interrupt Link [C143] (IRQs 10 11) *0, disabled.
[    0.460232] ACPI: PCI Interrupt Link [C144] (IRQs 10 *11)
[    0.460437] ACPI Exception (pci_link-0184): AE_NOT_FOUND, Evaluating _PRS [20070126]
[    0.460798] ACPI: Power Resource [C29F] (on)
[    0.460907] ACPI: Power Resource [C1C7] (off)
[    0.461123] ACPI: Power Resource [C3AD] (off)
[    0.461329] ACPI: Power Resource [C3B0] (off)
[    0.461535] ACPI: Power Resource [C3C3] (off)
[    0.461741] ACPI: Power Resource [C3C4] (off)
[    0.461945] ACPI: Power Resource [C3C5] (off)
[    0.462148] ACPI: Power Resource [C3C6] (off)
[    0.462352] ACPI: Power Resource [C3C7] (off)
[    0.462616] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.462672] pnp: PnP ACPI init
[    0.462686] ACPI: bus type pnp registered
[    0.462990]  00:00: calling quirk 0xffffffff8035b6ca: quirk_system_pci_resources+0x0/0x173()
[    0.463069] pnp 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.470412] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.471723] pnp 00:02: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
[    0.471808] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.471891] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.471970] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.472054] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.472449] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.472543] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.472638] pnp 00:09: Plug and Play ACPI device, IDs SYN0130 SYN0100 SYN0002 PNP0f13 (active)
[    0.473563]  00:0a: calling quirk 0xffffffff8035b6ca: quirk_system_pci_resources+0x0/0x173()
[    0.473649] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.477980] pnp 00:0b: Plug and Play ACPI device, IDs HPQ0004 (active)
[    0.478106]  00:0c: calling quirk 0xffffffff8035b6ca: quirk_system_pci_resources+0x0/0x173()
[    0.478202] pnp 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.480866]  00:0d: calling quirk 0xffffffff8035b6ca: quirk_system_pci_resources+0x0/0x173()
[    0.480975] pnp 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.481004] pnp: PnP ACPI: found 14 devices
[    0.481011] ACPI: ACPI bus type pnp unregistered
[    0.481290] usbcore: registered new interface driver usbfs
[    0.481382] usbcore: registered new interface driver hub
[    0.481448] usbcore: registered new device driver usb
[    0.481654] PCI: Using ACPI for IRQ routing
[    0.481661] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.508048] NET: Registered protocol family 8
[    0.508054] NET: Registered protocol family 20
[    0.508116] PCI-GART: No AMD northbridge found.
[    0.508130] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 11
[    0.508139] hpet0: 3 64-bit timers, 14318180 Hz
[    0.509204] ACPI: RTC can wake from S4
[    0.512044] Switched to high resolution mode on CPU 0
[    0.260027] Switched to high resolution mode on CPU 1
[    0.524049] pnp: the driver 'system' has been registered
[    0.524065] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.524074] system 00:00: iomem range 0xe0000-0xfffff could not be reserved
[    0.524082] system 00:00: iomem range 0x100000-0x7f7fffff could not be reserved
[    0.524090] system 00:00: driver attached
[    0.524104] system 00:0a: ioport range 0x500-0x55f has been reserved
[    0.524114] system 00:0a: ioport range 0x800-0x80f has been reserved
[    0.524122] system 00:0a: iomem range 0xffb00000-0xffbfffff could not be reserved
[    0.524132] system 00:0a: iomem range 0xfff00000-0xffffffff could not be reserved
[    0.524139] system 00:0a: driver attached
[    0.524148] system 00:0c: ioport range 0x4d0-0x4d1 has been reserved
[    0.524156] system 00:0c: ioport range 0x2f8-0x2ff has been reserved
[    0.524163] system 00:0c: ioport range 0x3f8-0x3ff has been reserved
[    0.524170] system 00:0c: ioport range 0x1000-0x107f has been reserved
[    0.524178] system 00:0c: ioport range 0x1100-0x113f has been reserved
[    0.524185] system 00:0c: ioport range 0x1200-0x121f has been reserved
[    0.524193] system 00:0c: iomem range 0xf8000000-0xfbffffff has been reserved
[    0.524201] system 00:0c: iomem range 0xfec00000-0xfec000ff could not be reserved
[    0.524210] system 00:0c: iomem range 0xfed20000-0xfed3ffff could not be reserved
[    0.524219] system 00:0c: iomem range 0xfed45000-0xfed8ffff could not be reserved
[    0.524228] system 00:0c: iomem range 0xfed90000-0xfed99fff could not be reserved
[    0.524236] system 00:0c: driver attached
[    0.524244] system 00:0d: iomem range 0xcee00-0xcffff has been reserved
[    0.524251] system 00:0d: iomem range 0xd2000-0xd3fff has been reserved
[    0.524259] system 00:0d: iomem range 0xfeda0000-0xfedbffff could not be reserved
[    0.524268] system 00:0d: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.524276] system 00:0d: driver attached
[    0.524915] PCI: Bridge: 0000:00:1c.0
[    0.524921]   IO window: disabled.
[    0.524930]   MEM window: disabled.
[    0.524938]   PREFETCH window: disabled.
[    0.524950] PCI: Bridge: 0000:00:1c.1
[    0.524954]   IO window: disabled.
[    0.524964]   MEM window: 0xe0000000-0xe00fffff
[    0.524973]   PREFETCH window: disabled.
[    0.524990] PCI: Bus 3, cardbus bridge: 0000:02:06.0
[    0.524995]   IO window: 0x00003000-0x000030ff
[    0.525005]   IO window: 0x00003400-0x000034ff
[    0.525014]   PREFETCH window: 0x88000000-0x8bffffff
[    0.525024]   MEM window: 0x8c000000-0x8fffffff
[    0.525033] PCI: Bridge: 0000:00:1e.0
[    0.525040]   IO window: 3000-3fff
[    0.525050]   MEM window: 0xe0100000-0xe03fffff
[    0.525059]   PREFETCH window: 0x0000000088000000-0x000000008bffffff
[    0.525103] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.525117] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.525149] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
[    0.525162] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.525180] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.525204] ACPI: PCI Interrupt 0000:02:06.0[A] -> GSI 18 (level, low) -> IRQ 18
[    0.525269] NET: Registered protocol family 2
[    0.560220] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.561439] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.564750] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.565650] TCP: Hash tables configured (established 262144 bind 65536)
[    0.565658] TCP reno registered
[    0.576334] checking if image is initramfs... it is
[    1.544147] Freeing initrd memory: 7064k freed
[    1.302450] audit: initializing netlink socket (disabled)
[    1.302486] type=2000 audit(1206956948.549:1): initialized
[    1.302799] Total HugeTLB memory allocated, 0
[    1.302957] VFS: Disk quotas dquot_6.5.1
[    1.303003] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.303140] io scheduler noop registered
[    1.303146] io scheduler anticipatory registered
[    1.303152] io scheduler deadline registered
[    1.303174] io scheduler cfq registered (default)
[    1.303191] pci 0000:00:02.0: Boot video device
[    1.303490] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    1.303546] assign_interrupt_mode Found MSI capability
[    1.303612] Allocate Port Service[0000:00:1c.0:pcie00]
[    1.303758] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    1.303812] assign_interrupt_mode Found MSI capability
[    1.303873] Allocate Port Service[0000:00:1c.1:pcie00]
[    1.304567] vesafb: framebuffer at 0xd0000000, mapped to 0xffffc20000900000, using 3072k, total 7616k
[    1.304577] vesafb: mode is 1024x768x16, linelength=2048, pages=3
[    1.304584] vesafb: scrolling: redraw
[    1.304590] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    1.324650] Console: switching to colour frame buffer device 128x48
[    1.344940] fb0: VESA VGA frame buffer device
[    1.348618] Real Time Clock Driver v1.12ac
[    1.349161] hpet_resources: 0xfed00000 is busy
[    1.349279] Linux agpgart interface v0.103
[    1.349441] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[    1.350145] pnp: the driver 'serial' has been registered
[    1.350483] isa bounce pool size: 16 pages
[    1.351884] brd: module loaded
[    1.352111] input: Macintosh mouse button emulation as /class/input/input0
[    1.352520] pnp: the driver 'i8042 kbd' has been registered
[    1.352538] i8042 kbd 00:08: driver attached
[    1.352584] pnp: the driver 'i8042 aux' has been registered
[    1.352611] i8042 aux 00:09: driver attached
[    1.352659] PNP: PS/2 Controller [PNP0303:C29C,PNP0f13:C29D] at 0x60,0x64 irq 1,12
[    1.354957] i8042.c: Detected active multiplexing controller, rev 1.1.
[    1.355932] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.356099] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.356298] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.356497] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.356696] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.384202] mice: PS/2 mouse device common for all mice
[    1.384446] cpuidle: using governor ladder
[    1.384593] cpuidle: using governor menu
[    1.385299] TCP bic registered
[    1.385430] NET: Registered protocol family 1
[    1.385615] NET: Registered protocol family 17
[    1.385990] registered taskstats version 1
[    1.386283] Freeing unused kernel memory: 372k freed
[    1.408034] input: AT Translated Set 2 keyboard as /class/input/input1
[    1.667455] ACPI: Transitioning device [C3B1] to D3
[    1.668216] ACPI: PNP0C0B:00 is registered as cooling_device0
[    1.672120] ACPI: Fan [C3B1] (off)
[    1.676533] ACPI: Transitioning device [C3B2] to D3
[    1.680180] ACPI: PNP0C0B:01 is registered as cooling_device1
[    1.684120] ACPI: Fan [C3B2] (off)
[    1.692275] ACPI: Transitioning device [C3C8] to D3
[    1.696170] ACPI: PNP0C0B:02 is registered as cooling_device2
[    1.700124] ACPI: Fan [C3C8] (off)
[    1.708448] ACPI: Transitioning device [C3C9] to D3
[    1.712171] ACPI: PNP0C0B:03 is registered as cooling_device3
[    1.716124] ACPI: Fan [C3C9] (off)
[    1.720504] ACPI: Transitioning device [C3CA] to D3
[    1.724169] ACPI: PNP0C0B:04 is registered as cooling_device4
[    1.728123] ACPI: Fan [C3CA] (off)
[    1.736384] ACPI: Transitioning device [C3CB] to D3
[    1.740170] ACPI: PNP0C0B:05 is registered as cooling_device5
[    1.744124] ACPI: Fan [C3CB] (off)
[    1.752169] ACPI: Transitioning device [C3CC] to D3
[    1.756174] ACPI: PNP0C0B:06 is registered as cooling_device6
[    1.760125] ACPI: Fan [C3CC] (off)
[    2.044889] ACPI: SSDT 7F7DBCCA, 023D (r1 HP      Cpu0Ist     3000 INTL 20060317)
[    2.052394] ACPI: SSDT 7F7DBF8C, 05FA (r1 HP      Cpu0Cst     3001 INTL 20060317)
[    2.071031] Monitor-Mwait will be used to enter C-1 state
[    2.071036] Monitor-Mwait will be used to enter C-2 state
[    2.071234] ACPI: CPU0 (power states: C1[C1] C2[C2])
[    2.072200] ACPI: ACPI0007:00 is registered as cooling_device7
[    2.076141] ACPI: Processor [CPU0] (supports 8 throttling states)
[    2.080649] ACPI: SSDT 7F7DBC02, 00C8 (r1 HP      Cpu1Ist     3000 INTL 20060317)
[    2.084599] ACPI: SSDT 7F7DBF07, 0085 (r1 HP      Cpu1Cst     3000 INTL 20060317)
[    1.834505] ACPI: CPU1 (power states: C1[C1] C2[C2])
[    2.091059] Marking TSC unstable due to TSC halts in idle
[    1.836206] ACPI: ACPI0007:01 is registered as cooling_device8
[    1.840129] ACPI: Processor [CPU1] (supports 8 throttling states)
[    1.848840] ACPI: LNXTHERM:01 is registered as thermal_zone0
[    1.852468] ACPI: Thermal Zone [TZ6] (25 C)
[    1.877151] ACPI: LNXTHERM:02 is registered as thermal_zone1
[    1.884428] ACPI: Thermal Zone [TZ0] (36 C)
[    1.895862] ACPI: LNXTHERM:03 is registered as thermal_zone2
[    1.897449] ACPI: Thermal Zone [TZ1] (40 C)
[    1.907944] ACPI: LNXTHERM:04 is registered as thermal_zone3
[    1.912265] ACPI: Thermal Zone [TZ3] (29 C)
[    1.928287] ACPI: LNXTHERM:05 is registered as thermal_zone4
[    2.249594] ACPI: Thermal Zone [TZ4] (28 C)
[    1.950447] ACPI: LNXTHERM:06 is registered as thermal_zone5
[    2.266800] ACPI: Thermal Zone [TZ5] (66 C)
[    2.440785] USB Universal Host Controller Interface driver v3.0
[    2.444629] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
[    2.448589] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[    2.448595] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    2.452815] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    2.456629] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00002040
[    2.460795] usb usb1: configuration #1 chosen from 1 choice
[    2.464628] hub 1-0:1.0: USB hub found
[    2.468597] hub 1-0:1.0: 2 ports detected
[    2.845333] Uniform Multi-Platform E-IDE driver
[    2.847531] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[    2.584987] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    2.588605] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.592585] usb usb1: Product: UHCI Host Controller
[    2.596585] usb usb1: Manufacturer: Linux 2.6.25-rc7-amd64 uhci_hcd
[    2.600585] usb usb1: SerialNumber: 0000:00:1a.0
[    2.604634] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 17 (level, low) -> IRQ 17
[    2.608595] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[    2.608601] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    2.612657] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[    2.616629] uhci_hcd 0000:00:1a.1: irq 17, io base 0x00002060
[    2.620739] usb usb2: configuration #1 chosen from 1 choice
[    2.624621] hub 2-0:1.0: USB hub found
[    2.628594] hub 2-0:1.0: 2 ports detected
[    2.736748] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.740629] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.744631] usb usb2: Product: UHCI Host Controller
[    2.748620] usb usb2: Manufacturer: Linux 2.6.25-rc7-amd64 uhci_hcd
[    2.752618] usb usb2: SerialNumber: 0000:00:1a.1
[    2.756672] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20
[    2.760631] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    2.760638] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.764688] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
[    2.768657] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00002080
[    2.772775] usb usb3: configuration #1 chosen from 1 choice
[    2.776656] hub 3-0:1.0: USB hub found
[    2.780629] hub 3-0:1.0: 2 ports detected
[    3.263285] usb 1-1: new full speed USB device using uhci_hcd and address 2
[    2.891436] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.895350] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.899352] usb usb3: Product: UHCI Host Controller
[    2.903351] usb usb3: Manufacturer: Linux 2.6.25-rc7-amd64 uhci_hcd
[    2.907353] usb usb3: SerialNumber: 0000:00:1d.0
[    2.911392] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 22 (level, low) -> IRQ 22
[    2.915359] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    2.915366] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.919430] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 4
[    2.923428] uhci_hcd 0000:00:1d.1: irq 22, io base 0x000020a0
[    2.927508] usb usb4: configuration #1 chosen from 1 choice
[    2.931388] hub 4-0:1.0: USB hub found
[    2.935361] hub 4-0:1.0: 2 ports detected
[    2.987664] usb 1-1: configuration #1 chosen from 1 choice
[    2.991767] usb 1-1: New USB device found, idVendor=03f0, idProduct=171d
[    2.995679] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.999671] usb 1-1: Product: HP Integrated Module
[    3.003671] usb 1-1: Manufacturer: Broadcom Corp
[    3.502026] Clocksource tsc unstable (delta = -156435253 ns)
[    3.027480] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    3.031401] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.035394] usb usb4: Product: UHCI Host Controller
[    3.039396] usb usb4: Manufacturer: Linux 2.6.25-rc7-amd64 uhci_hcd
[    3.043393] usb usb4: SerialNumber: 0000:00:1d.1
[    3.051411] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[    3.059400] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    3.059406] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.063461] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 5
[    3.067438] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000020c0
[    3.075550] usb usb5: configuration #1 chosen from 1 choice
[    3.079431] hub 5-0:1.0: USB hub found
[    3.083404] hub 5-0:1.0: 2 ports detected
[    3.194227] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    3.198135] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.202136] usb usb5: Product: UHCI Host Controller
[    3.206133] usb usb5: Manufacturer: Linux 2.6.25-rc7-amd64 uhci_hcd
[    3.210136] usb usb5: SerialNumber: 0000:00:1d.2
[    3.763670] ACPI: PCI Interrupt 0000:02:06.1[B] -> GSI 19 (level, low) -> IRQ 19
[    3.821243] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[e0101000-e01017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
[    3.831070] usb 3-2: new full speed USB device using uhci_hcd and address 2
[    3.833944] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
[    3.837893] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[    3.837899] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    3.841950] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 6
[    3.853775] ehci_hcd 0000:00:1a.7: debug port 1
[    3.853858] PCI: cache line size of 32 is not supported by device 0000:00:1a.7
[    3.853870] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe0621000
[    3.873881] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    3.878039] usb usb6: configuration #1 chosen from 1 choice
[    3.881897] hub 6-0:1.0: USB hub found
[    3.885875] hub 6-0:1.0: 4 ports detected
[    3.993988] usb usb6: New USB device found, idVendor=1d6b, idProduct=0002
[    3.997860] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.001859] usb usb6: Product: EHCI Host Controller
[    4.005859] usb usb6: Manufacturer: Linux 2.6.25-rc7-amd64 ehci_hcd
[    4.009866] usb usb6: SerialNumber: 0000:00:1a.7
[    4.013910] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 20
[    4.017888] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    4.017894] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.021954] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
[    4.033342] ehci_hcd 0000:00:1d.7: debug port 1
[    4.033879] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[    4.033888] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xe0628000
[    3.607254] usb 3-2: configuration #1 chosen from 1 choice
[    3.615143] usb 3-2: can't set config #1, error -71
[    4.055920] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    4.056084] usb usb7: configuration #1 chosen from 1 choice
[    4.056123] hub 7-0:1.0: USB hub found
[    4.056132] hub 7-0:1.0: 6 ports detected
[    3.619109] usb 3-2: New USB device found, idVendor=08ff, idProduct=2580
[    3.623026] usb 3-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    3.627025] usb 3-2: Product: Fingerprint Sensor
[    4.162421] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
[    4.166295] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.170295] usb usb7: Product: EHCI Host Controller
[    4.174295] usb usb7: Manufacturer: Linux 2.6.25-rc7-amd64 ehci_hcd
[    4.178295] usb usb7: SerialNumber: 0000:00:1d.7
[    4.182792] ICH8M: IDE controller (0x8086:0x2850 rev 0x03) at  PCI slot 0000:00:1f.1
[    4.186306] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
[    4.190306] ICH8M: not 100% native mode: will probe irqs later
[    4.194305] ICH8M: IDE port disabled
[    4.198301]     ide0: BM-DMA at 0x20e0-0x20e7, BIOS settings: hda:DMA, hdb:DMA
[    4.202302] Probing IDE interface ide0...
[    3.881561] usb 1-1: USB disconnect, address 2
[    4.130786] usb 1-1: new full speed USB device using uhci_hcd and address 3
[    4.662531] hdb: MATSHITADVD-RAM UJ-842S, ATAPI CD/DVD-ROM drive
[    4.308545] usb 1-1: configuration #1 chosen from 1 choice
[    4.311185] usb 1-1: New USB device found, idVendor=03f0, idProduct=171d
[    4.312555] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.316553] usb 1-1: Product: HP Integrated Module
[    4.320552] usb 1-1: Manufacturer: Broadcom Corp
[    5.006232] hda: TOSHIBA MK8009GAH, ATA DISK drive
[    5.009808] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    5.009875] hda: UDMA/100 mode selected
[    5.013854] hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    5.014144] hdb: MWDMA2 mode selected
[    4.564497] usb 3-2: USB disconnect, address 2
[    5.018100] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    5.032577] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[001b249929010210]
[    4.599311] No dock devices found.
[    4.610772] SCSI subsystem initialized
[    4.624147] libata version 3.00 loaded.
[    5.119647] hda: max request size: 128KiB
[    5.120275] hda: 156301488 sectors (80026 MB), CHS=65535/16/63
[    5.124426] hda: cache flushes supported
[    5.128334]  hda: hda1 hda2 hda3
[    4.685600] hdb: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
[    4.688413] Uniform CD-ROM driver Revision: 3.20
[    4.807443] usb 3-2: new full speed USB device using uhci_hcd and address 3
[    5.446132] usb 3-2: configuration #1 chosen from 1 choice
[    5.453185] usb 3-2: New USB device found, idVendor=08ff, idProduct=2580
[    5.456923] usb 3-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    5.460918] usb 3-2: Product: Fingerprint Sensor
[    5.687875] device-mapper: uevent: version 1.0.3
[    5.689072] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
[   77.449099] PM: Starting manual resume from disk
[   77.216432] kjournald starting.  Commit interval 5 seconds
[   77.599693] EXT3-fs: mounted filesystem with ordered data mode.
[   81.817874] input: Power Button (FF) as /class/input/input2
[   81.876808] ACPI: Power Button (FF) [PWRF]
[   81.880947] input: Sleep Button (CM) as /class/input/input3
[   81.934673] ACPI: Sleep Button (CM) [C2BF]
[   81.936839] input: Lid Switch as /class/input/input4
[   81.970287] ACPI: Lid Switch [C155]
[   81.973476] ACPI: AC Adapter [C23B] (on-line)
[   82.137608] e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
[   82.140790] e1000e: Copyright (c) 1999-2007 Intel Corporation.
[   82.144822] ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 22 (level, low) -> IRQ 22
[   82.148768] PCI: Setting latency timer of device 0000:00:19.0 to 64
[   82.000153] ACPI: Battery Slot [C23D] (battery present)
[   82.365653] eth0: (PCI Express:2.5GB/s:Width x1) 00:1e:68:06:12:ee
[   82.365657] eth0: Intel(R) PRO/1000 Network Connection
[   82.365696] eth0: MAC: 4, PHY: 6, PBA No: ffffff-0ff
[   82.365775] agpgart: Detected an Intel 965GM Chipset.
[   82.001910] ACPI: WMI: Mapper loaded
[   82.403700] agpgart: Detected 7676K stolen memory.
[   82.424832] agpgart: AGP aperture is 256M @ 0xd0000000
[   82.707289] ACPI: device:02 is registered as cooling_device9
[   82.710253] input: Video Bus as /class/input/input5
[   82.784809] ACPI: Video Device [C09A] (multi-head: yes  rom: no  post: no)
[   82.697069] Bluetooth: Core ver 2.11
[   82.744260] NET: Registered protocol family 31
[   82.745456] Bluetooth: HCI device and connection manager initialized
[   82.749397] Bluetooth: HCI socket layer initialized
[   83.245523] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
[   83.248928] iTCO_wdt: Found a ICH8M-E TCO device (Version=2, TCOBASE=0x1060)
[   83.252890] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   82.887798] input: PC Speaker as /class/input/input6
[   83.486815] Yenta: CardBus bridge found at 0000:02:06.0 [103c:30c9]
[   83.595018] ricoh-mmc: Ricoh MMC Controller disabling driver
[   83.595025] ricoh-mmc: Copyright(c) Philip Langdale
[   83.608017] Bluetooth: HCI USB driver ver 2.9
[   83.612151] Yenta: ISA IRQ mask 0x04b8, PCI irq 18
[   83.615053] Socket status: 30000006
[   83.619041] Yenta: Raising subordinate bus# of parent bus (#02) from #03 to #06
[   83.239173] usbcore: registered new interface driver hci_usb
[   83.623042] pcmcia: parent PCI bridge I/O window: 0x3000 - 0x3fff
[   83.627028] pcmcia: parent PCI bridge Memory window: 0xe0100000 - 0xe03fffff
[   83.631027] pcmcia: parent PCI bridge Memory window: 0x88000000 - 0x8bffffff
[   83.635396] ricoh-mmc: Ricoh MMC controller found at 0000:02:06.3 [1180:0843] (rev 11)
[   83.639049] ricoh-mmc: Controller is now disabled.
[   83.807538] sdhci: Secure Digital Host Controller Interface driver
[   83.810237] sdhci: Copyright(c) Pierre Ossman
[   83.814275] sdhci: SDHCI controller found at 0000:02:06.2 [1180:0822] (rev 21)
[   83.818247] ACPI: PCI Interrupt 0000:02:06.2[C] -> GSI 20 (level, low) -> IRQ 20
[   83.822258] sdhc0:slot0: Will use DMA mode even though HW doesn't fully claim to support it.
[   83.830231] mmc0: SDHCI at 0xe0102000 irq 20 DMA
[   83.561362] pnp: the driver 'tpm_inf_pnp' has been registered
[   83.561745] tpm_inf_pnp 00:02: Found C284 with ID IFX0102
[   83.565798] tpm_inf_pnp 00:02: TPM found: config base 0x560, data base 0x570, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
[   83.570037] tpm_inf_pnp 00:02: driver attached
[   84.051552] iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 1.2.23ks
[   84.054282] iwl4965: Copyright(c) 2003-2007 Intel Corporation
[   84.058376] ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[   84.062287] PCI: Setting latency timer of device 0000:10:00.0 to 64
[   84.066299] iwl4965: Detected Intel Wireless WiFi Link 4965AGN
[   84.118656] iwl4965: Tunable channels: 13 802.11bg, 19 802.11a channels
[   84.123101] phy0: Selected rate control algorithm 'iwl-4965-rs'
[   84.339785] ACPI: PCI interrupt for device 0000:10:00.0 disabled
[   84.164081] input: PS/2 Generic Mouse as /class/input/input7
[   84.220160] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 17 (level, low) -> IRQ 17
[   84.224143] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   84.805893] Synaptics Touchpad, model: 1, fw: 6.3, id: 0x1a0b1, caps: 0xa04713/0x200000
[   84.844060] input: SynPS/2 Synaptics TouchPad as /class/input/input8
[   86.605978] hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x006ba000
[   87.270261] EXT3 FS on dm-1, internal journal
[   88.670658] loop: module loaded
[   88.786193] tun: Universal TUN/TAP device driver, 1.6
[   88.786406] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   91.314501] kjournald starting.  Commit interval 5 seconds
[   91.317416] EXT3 FS on hda1, internal journal
[   91.321095] EXT3-fs: mounted filesystem with ordered data mode.
[   91.362657] kjournald starting.  Commit interval 5 seconds
[   91.364863] EXT3 FS on dm-3, internal journal
[   91.368449] EXT3-fs: mounted filesystem with ordered data mode.
[   91.071837] Adding 1048568k swap on /dev/mapper/lucky-swap.  Priority:-1 extents:1 across:1048568k
[   92.858817] Bridge firewalling registered
[   93.215772] br0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
[   92.876596] device eth0 entered promiscuous mode
[   94.897320] eth0: Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[   94.900894] eth0: 10/100 speed: disabling TSO
[   94.905430] br0: port 1(eth0) entering learning state
[  103.880556] br0: topology change detected, propagating
[  103.884547] br0: port 1(eth0) entering forwarding state
[  105.552042] NET: Registered protocol family 10
[  105.555411] lo: Disabled Privacy Extensions
[  112.922474] pnp: the driver 'parport_pc' has been registered
[  112.664432] lp: driver loaded but no devices found
[  112.778585] ppdev: user-space parallel port driver
[  115.797086] eth0: no IPv6 routers present
[  116.287256] br0: no IPv6 routers present
[  119.053997] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
[  121.707099] Bluetooth: L2CAP ver 2.9
[  121.710270] Bluetooth: L2CAP socket layer initialized
[  121.850732] Bluetooth: RFCOMM socket layer initialized
[  121.854078] Bluetooth: RFCOMM TTY layer initialized
[  121.858023] Bluetooth: RFCOMM ver 1.8
[  122.418172] ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[  122.419231] PM: Writing back config space on device 0000:10:00.0 at offset 1 (was 100002, writing 100006)
[  122.417622] iwl4965: iwlwifi-4965-1.ucode firmware file req failed: Reason -2
[  122.417898] iwl4965: Could not read microcode: -2
[  122.425981] ACPI: PCI interrupt for device 0000:10:00.0 disabled
[  125.489416] ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[  125.493348] PM: Writing back config space on device 0000:10:00.0 at offset 1 (was 100002, writing 100006)
[  125.509783] iwl4965: iwlwifi-4965-1.ucode firmware file req failed: Reason -2
[  125.513236] iwl4965: Could not read microcode: -2
[  125.517315] ACPI: PCI interrupt for device 0000:10:00.0 disabled
[  126.367749] hdb: task_no_data_intr: status=0x51 { DriveReady SeekComplete Error }
[  126.369671] hdb: task_no_data_intr: error=0x04 { AbortedCommand }
[  126.369671] ide: failed opcode was: 0xef
[  130.641477] [drm] Initialized drm 1.1.0 20060810
[  130.666634] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[  130.666652] PCI: Setting latency timer of device 0000:00:02.0 to 64
[  130.666902] [drm] Initialized i915 1.6.0 20060119 on minor 0
[  142.804354] eth0: no IPv6 routers present
[  147.382170] ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[  147.382286] PM: Writing back config space on device 0000:10:00.0 at offset 1 (was 100002, writing 100006)
[  147.393959] iwl4965: iwlwifi-4965-1.ucode firmware file req failed: Reason -2
[  147.393971] iwl4965: Could not read microcode: -2

--1UWUbFP1cBYEclgG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=interrupts

           CPU0       CPU1       
  0:      22082      23036   IO-APIC-edge      timer
  1:         23         12   IO-APIC-edge      i8042
  8:          0          1   IO-APIC-edge      rtc
  9:        116        119   IO-APIC-fasteoi   acpi
 12:        129        114   IO-APIC-edge      i8042
 14:       5053       4013   IO-APIC-edge      ide0
 16:      15965       7536   IO-APIC-fasteoi   uhci_hcd:usb1, i915@pci:0000:00:02.0
 17:         60         63   IO-APIC-fasteoi   uhci_hcd:usb2, HDA Intel
 18:          0          2   IO-APIC-fasteoi   uhci_hcd:usb5, ehci_hcd:usb6, yenta
 19:      11425      19979   IO-APIC-fasteoi   ohci1394
 20:         25         20   IO-APIC-fasteoi   uhci_hcd:usb3, ehci_hcd:usb7, sdhc0:slot0
 22:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
1277:        574        516   PCI-MSI-edge      eth0
NMI:          0          0   Non-maskable interrupts
LOC:       8375      13897   Local timer interrupts
RES:       4901       4903   Rescheduling interrupts
CAL:        189      18289   function call interrupts
TLB:        503        588   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:          0

--1UWUbFP1cBYEclgG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=lspci-vvv

00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory Controller Hub (rev 0c)
	Subsystem: Hewlett-Packard Company Unknown device 30c9
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information <?>
	Kernel driver in use: agpgart-intel
	Kernel modules: intel-agp

00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c) (prog-if 00 [VGA controller])
	Subsystem: Hewlett-Packard Company Unknown device 30c9
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at e0400000 (64-bit, non-prefetchable) [size=1M]
	Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 4: I/O ports at 2000 [size=8]
	Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [d0] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+

00:02.1 Display controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c)
	Subsystem: Hewlett-Packard Company Unknown device 30c9
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: Memory at e0500000 (64-bit, non-prefetchable) [size=1M]
	Capabilities: [d0] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+

00:19.0 Ethernet controller: Intel Corporation 82566MM Gigabit Network Connection (rev 03)
	Subsystem: Hewlett-Packard Company Unknown device 30c9
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 1277
	Region 0: Memory at e0600000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at e0620000 (32-bit, non-prefetchable) [size=4K]
	Region 2: I/O ports at 2020 [size=32]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee0300c  Data: 4191
	Kernel driver in use: e1000e
	Kernel modules: e1000e

00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Contoller #4 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Unknown device 30c9
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at 2040 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #5 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Unknown device 30c9
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 17
	Region 4: I/O ports at 2060 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 (rev 03) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Unknown device 30c9
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at e0621000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 03)
	Subsystem: Hewlett-Packard Company Unknown device 30c9
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at e0624000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=08, subordinate=08, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
		Address: fee0300c  Data: 4169
	Capabilities: [90] Subsystem: Gammagraphx, Inc. Unknown device 0000
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=10, subordinate=10, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: e0000000-e00fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
		Address: fee0300c  Data: 4171
	Capabilities: [90] Subsystem: Hewlett-Packard Company Unknown device 30c9
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Unknown device 30c9
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 20
	Region 4: I/O ports at 2080 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Unknown device 30c9
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 22
	Region 4: I/O ports at 20a0 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #3 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Unknown device 30c9
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at 20c0 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 03) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Unknown device 30c9
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at e0628000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=02, subordinate=06, sec-latency=32
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: e0100000-e03fffff
	Prefetchable memory behind bridge: 0000000088000000-000000008bffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Hewlett-Packard Company Unknown device 30c9

00:1f.0 ISA bridge: Intel Corporation 82801HBM (ICH8M-E) LPC Interface Controller (rev 03)
	Subsystem: Hewlett-Packard Company Unknown device 30c9
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information <?>
	Kernel modules: iTCO_wdt

00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller (rev 03) (prog-if 8a [Master SecP PriP])
	Subsystem: Hewlett-Packard Company Unknown device 30c9
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at 20e0 [size=16]
	Kernel driver in use: PIIX_IDE
	Kernel modules: ide-pci-generic, piix, ata_generic

02:06.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev ba)
	Subsystem: Hewlett-Packard Company Unknown device 30c9
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 168
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at e0100000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=02, secondary=03, subordinate=06, sec-latency=176
	Memory window 0: 88000000-8bfff000 (prefetchable)
	Memory window 1: 8c000000-8ffff000
	I/O window 0: 00003000-000030ff
	I/O window 1: 00003400-000034ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001
	Kernel driver in use: yenta_cardbus
	Kernel modules: yenta_socket

02:06.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev 04) (prog-if 10 [OHCI])
	Subsystem: Hewlett-Packard Company Unknown device 30c9
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (500ns min, 1000ns max), Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 19
	Region 0: Memory at e0101000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME+
	Kernel driver in use: ohci1394
	Kernel modules: ohci1394

02:06.2 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 21)
	Subsystem: Hewlett-Packard Company Unknown device 30c9
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 20
	Region 0: Memory at e0102000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-
	Kernel driver in use: sdhci
	Kernel modules: sdhci

02:06.3 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev ff) (prog-if ff)
	!!! Unknown header type 7f
	Kernel driver in use: ricoh-mmc
	Kernel modules: ricoh_mmc

10:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or AGN Network Connection (rev 61)
	Subsystem: Intel Corporation Unknown device 1001
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at e0000000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: [c8] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 00000000fee0300c  Data: 41d9
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <128ns, L1 <64us
			ClockPM+ Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Kernel driver in use: iwl4965
	Kernel modules: iwl4965


--1UWUbFP1cBYEclgG--
