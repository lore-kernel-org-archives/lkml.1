Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbZF2NXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbZF2NXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 09:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbZF2NXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 09:23:06 -0400
Received: from tamriel.snowman.net ([72.66.115.51]:58691 "EHLO
	tamriel.snowman.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbZF2NXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 09:23:01 -0400
Date: Mon, 29 Jun 2009 09:23:02 -0400
From: Stephen Frost <sfrost@snowman.net>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ACPI issues on HP DL585 G2
Message-ID: <20090629132302.GR20436@tamriel.snowman.net>
References: <20090628034038.GK20436@tamriel.snowman.net> <86802c440906272126s7d3b97afh16069280bd297827@mail.gmail.com> <20090628223132.GO20436@tamriel.snowman.net> <86802c440906281849m51ab3c82u84d76a1aaceba2ef@mail.gmail.com> <20090629015738.GQ20436@tamriel.snowman.net> <86802c440906282047h23d45627pacec7a23f871fc2c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p19/OaUkOQckSefz"
Content-Disposition: inline
In-Reply-To: <86802c440906282047h23d45627pacec7a23f871fc2c@mail.gmail.com>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snowman.net
X-Operating-System: Linux/2.6.26-1-amd64 (x86_64)
X-Uptime: 09:22:32 up 18 days, 10:49, 21 users,  load average: 0.03, 0.05,
	0.02
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p19/OaUkOQckSefz
Content-Type: multipart/mixed; boundary="AaroDtM9M79Ffl67"
Content-Disposition: inline


--AaroDtM9M79Ffl67
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Yinghai,

* Yinghai Lu (yhlu.kernel@gmail.com) wrote:
> On Sun, Jun 28, 2009 at 6:57 PM, Stephen Frost<sfrost@snowman.net> wrote:
> > They might not.. =A0I did upgrade the BIOS to the latest revision and I
> > don't recall if the last 2.6.22 boot was before or after the BIOS
> > upgrade. =A0The 2.6.29 and 2.6.30 boots (both w/o APIC) are from the sa=
me
> > BIOS. =A0Would it help to try booting under 2.6.22 with the BIOS that's=
 on
> > there now?
>=20
> that would help

attached.

> >
> > Is there some other information I could provide while the machine is
> > running? =A0Unfortunately, this is a rather important box for us.
>=20
> put debug in /boot/grub/grub.conf for the kernel
> and boot with serial console enabled...
> to capture all.

attached.

	Thanks,

		Stephen

--AaroDtM9M79Ffl67
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="dmesg-2.6.22-apic"
Content-Transfer-Encoding: quoted-printable

Linux version 2.6.22-3-amd64 (Debian 2.6.22-6) (maks@debian.org) (gcc versi=
on 4.1.3 20071019 (prerelease) (Debian 4.1.2-17)) #1 SMP Sun Nov 4 18:18:09=
 UTC 2007
Command line: root=3D/dev/cciss/c0d0p1 ro debug
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fe4e000 (usable)
 BIOS-e820: 000000007fe4e000 - 000000007fe56000 (ACPI data)
 BIOS-e820: 000000007fe56000 - 000000007fe57000 (usable)
 BIOS-e820: 000000007fe57000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 000000047ffff000 (usable)
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 523854) 1 entries of 3200 used
Entering add_active_range(0, 523862, 523863) 2 entries of 3200 used
Entering add_active_range(0, 1048576, 4718591) 3 entries of 3200 used
end_pfn_map =3D 4718591
DMI 2.4 present.
ACPI: RSDP 000F4F00, 0024 (r2 HP    )
ACPI: XSDT 7FE4ED00, 0074 (r1 HP     ProLiant        2   =D2=04     162E)
ACPI: FACP 7FE4ED80, 00F4 (r3 HP     A07             2   =D2=04     162E)
ACPI: DSDT 7FE4EE80, 498A (r1 HP         DSDT        1 INTL 20030228)
ACPI: FACS 7FE4E100, 0040
ACPI: SPCR 7FE4E140, 0050 (r1 HP     SPCRRBSU        1   =D2=04     162E)
ACPI: HPET 7FE4E1C0, 0038 (r1 HP     ProLiant        2   =D2=04     162E)
ACPI: SPMI 7FE4E200, 0040 (r5 HP     ProLiant        1   =D2=04     162E)
ACPI: ERST 7FE4E240, 01D0 (r1 HP     ProLiant        1   =D2=04     162E)
ACPI: APIC 7FE4E440, 00C6 (r1 HP     ProLiant        2             0)
ACPI: SRAT 7FE4E580, 01A0 (r1 AMD    FAM_F_10        2 AMD         1)
ACPI: FFFF 7FE4E980, 0176 (r1 HP     ProLiant        1   =D2=04     162E)
ACPI: BERT 7FE4EB00, 0030 (r1 HP     ProLiant        1   =D2=04     162E)
ACPI: HEST 7FE4EB40, 0170 (r1 HP     ProLiant        1   =D2=04     162E)
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 1 -> APIC 2 -> Node 1
SRAT: PXM 1 -> APIC 3 -> Node 1
SRAT: PXM 2 -> APIC 4 -> Node 2
SRAT: PXM 2 -> APIC 5 -> Node 2
SRAT: PXM 3 -> APIC 6 -> Node 3
SRAT: PXM 3 -> APIC 7 -> Node 3
SRAT: Node 0 PXM 0 0-a0000
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
SRAT: Node 0 PXM 0 0-80000000
Entering add_active_range(0, 0, 159) 1 entries of 3200 used
Entering add_active_range(0, 256, 523854) 1 entries of 3200 used
Entering add_active_range(0, 523862, 523863) 2 entries of 3200 used
SRAT: Node 0 PXM 0 0-180000000
Entering add_active_range(0, 0, 159) 3 entries of 3200 used
Entering add_active_range(0, 256, 523854) 3 entries of 3200 used
Entering add_active_range(0, 523862, 523863) 3 entries of 3200 used
Entering add_active_range(0, 1048576, 1572864) 3 entries of 3200 used
SRAT: Node 1 PXM 1 180000000-280000000
Entering add_active_range(1, 1572864, 2621440) 4 entries of 3200 used
SRAT: Node 2 PXM 2 280000000-380000000
Entering add_active_range(2, 2621440, 3670016) 5 entries of 3200 used
SRAT: Node 3 PXM 3 380000000-480000000
Entering add_active_range(3, 3670016, 4718591) 6 entries of 3200 used
NUMA: Using 31 for the hash shift.
Bootmem setup node 0 0000000000000000-0000000180000000
Bootmem setup node 1 0000000180000000-0000000280000000
Bootmem setup node 2 0000000280000000-0000000380000000
Bootmem setup node 3 0000000380000000-000000047ffff000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  4718591
early_node_map[7] active PFN ranges
    0:        0 ->      159
    0:      256 ->   523854
    0:   523862 ->   523863
    0:  1048576 ->  1572864
    1:  1572864 ->  2621440
    2:  2621440 ->  3670016
    3:  3670016 ->  4718591
On node 0 totalpages: 1048046
  DMA zone: 56 pages used for memmap
  DMA zone: 1034 pages reserved
  DMA zone: 2909 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 505479 pages, LIFO batch:31
  Normal zone: 7168 pages used for memmap
  Normal zone: 517120 pages, LIFO batch:31
On node 1 totalpages: 1048576
  DMA zone: 0 pages used for memmap
  DMA32 zone: 0 pages used for memmap
  Normal zone: 14336 pages used for memmap
  Normal zone: 1034240 pages, LIFO batch:31
On node 2 totalpages: 1048576
  DMA zone: 0 pages used for memmap
  DMA32 zone: 0 pages used for memmap
  Normal zone: 14336 pages used for memmap
  Normal zone: 1034240 pages, LIFO batch:31
On node 3 totalpages: 1048575
  DMA zone: 0 pages used for memmap
  DMA32 zone: 0 pages used for memmap
  Normal zone: 14335 pages used for memmap
  Normal zone: 1034240 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x908
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
Processor #4
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
Processor #6
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
Processor #3
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
Processor #5
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
Processor #7
ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xd9cf0000] gsi_base[0])
IOAPIC[0]: apic_id 8, address 0xd9cf0000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xd9fd0000] gsi_base[24])
IOAPIC[1]: apic_id 9, address 0xd9fd0000, GSI 24-30
ACPI: IOAPIC (id[0x0a] address[0xd9fe0000] gsi_base[31])
IOAPIC[2]: apic_id 10, address 0xd9fe0000, GSI 31-37
ACPI: IOAPIC (id[0x0b] address[0xd9ff0000] gsi_base[38])
IOAPIC[3]: apic_id 11, address 0xd9ff0000, GSI 38-61
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 0 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ9 used by override.
ACPI: NMI_SRC (dfl dfl global_irq 28)
ACPI: NMI_SRC (dfl dfl global_irq 35)
Setting APIC routing to flat
ACPI: HPET id: 0x10228201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000f0000
swsusp: Registered nosave memory region: 00000000000f0000 - 0000000000100000
swsusp: Registered nosave memory region: 000000007fe4e000 - 000000007fe56000
swsusp: Registered nosave memory region: 000000007fe57000 - 0000000080000000
swsusp: Registered nosave memory region: 0000000080000000 - 00000000e0000000
swsusp: Registered nosave memory region: 00000000e0000000 - 00000000f0000000
swsusp: Registered nosave memory region: 00000000f0000000 - 00000000fec00000
swsusp: Registered nosave memory region: 00000000fec00000 - 00000000fed00000
swsusp: Registered nosave memory region: 00000000fed00000 - 00000000fee00000
swsusp: Registered nosave memory region: 00000000fee00000 - 00000000fee10000
swsusp: Registered nosave memory region: 00000000fee10000 - 00000000ffc00000
swsusp: Registered nosave memory region: 00000000ffc00000 - 0000000100000000
Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
SMP: Allowing 8 CPUs, 0 hotplug CPUs
PERCPU: Allocating 37896 bytes of per cpu data
Built 4 zonelists.  Total pages: 4128228
Kernel command line: root=3D/dev/cciss/c0d0p1 ro debug
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 2812.969 MHz processor.
Console: colour VGA+ 80x25
Checking aperture...
CPU 0: aperture @ 20000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 4000000
Memory: 16438936k/18874364k available (2008k kernel code, 336156k reserved,=
 945k data, 296k init)
Calibrating delay using timer specific routine.. 5629.02 BogoMIPS (lpj=3D11=
258051)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 12557905
Detected 12.557 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/8 APIC 0x2
Initializing CPU#1
Calibrating delay using timer specific routine.. 5625.95 BogoMIPS (lpj=3D11=
251916)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/2 -> Node 1
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
SMP alternatives: switching to SMP code
Booting processor 2/8 APIC 0x4
Initializing CPU#2
Calibrating delay using timer specific routine.. 5626.12 BogoMIPS (lpj=3D11=
252243)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 2/4 -> Node 2
CPU: Physical Processor ID: 2
CPU: Processor Core ID: 0
Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
SMP alternatives: switching to SMP code
Booting processor 3/8 APIC 0x6
Initializing CPU#3
Calibrating delay using timer specific routine.. 5626.08 BogoMIPS (lpj=3D11=
252169)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 3/6 -> Node 3
CPU: Physical Processor ID: 3
CPU: Processor Core ID: 0
Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
SMP alternatives: switching to SMP code
Booting processor 4/8 APIC 0x1
Initializing CPU#4
Calibrating delay using timer specific routine.. 5626.05 BogoMIPS (lpj=3D11=
252119)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 4/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
SMP alternatives: switching to SMP code
Booting processor 5/8 APIC 0x3
Initializing CPU#5
Calibrating delay using timer specific routine.. 5625.96 BogoMIPS (lpj=3D11=
251922)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 5/3 -> Node 1
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
SMP alternatives: switching to SMP code
Booting processor 6/8 APIC 0x5
Initializing CPU#6
Calibrating delay using timer specific routine.. 5625.94 BogoMIPS (lpj=3D11=
251896)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 6/5 -> Node 2
CPU: Physical Processor ID: 2
CPU: Processor Core ID: 1
Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
SMP alternatives: switching to SMP code
Booting processor 7/8 APIC 0x7
Initializing CPU#7
Calibrating delay using timer specific routine.. 5625.97 BogoMIPS (lpj=3D11=
251944)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 7/7 -> Node 3
CPU: Physical Processor ID: 3
CPU: Processor Core ID: 1
Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
Brought up 8 CPUs
migration_cost=3D461,611
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: SSDT 7FE58000, 0AC4 (r2 HP     PNOWSSDT        2 HP          1)
ACPI: Interpreter enabled
ACPI: (supports S0 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI: Transparent bridge - 0000:00:09.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IP2P._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE2._PRT]
ACPI: PCI Root Bridge [PCI1] (0000:40)
PCI: Probing PCI hardware (bus 40)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.BRGA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.BRGB._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE3._PRT]
ACPI: PCI Interrupt Link [LNKW] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [LNKX] (IRQs 17) *0, disabled.
ACPI: PCI Interrupt Link [LNKY] (IRQs 18) *0, disabled.
ACPI: PCI Interrupt Link [LNKZ] (IRQs 19) *0, disabled.
ACPI: PCI Interrupt Link [LNU0] (IRQs 22) *5
ACPI: PCI Interrupt Link [LNU2] (IRQs 23) *11
ACPI: PCI Interrupt Link [LNKA] (IRQs 54) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 55) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 56) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 57) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: ACPI device : hid PNP0A03
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid IPI0001
pnp: ACPI device : hid PNP0103
pnp: ACPI device : hid PNP0200
pnp: ACPI device : hid PNP0800
pnp: ACPI device : hid PNP0303
pnp: ACPI device : hid PNP0F13
pnp: ACPI device : hid PNP0A06
pnp: ACPI device : hid PNP0501
pnp: ACPI device : hid PNP0B00
pnp: ACPI device : hid PNP0003
pnp: ACPI device : hid PNP0A03
pnp: ACPI device : hid PNP0003
pnp: ACPI device : hid PNP0003
pnp: ACPI device : hid PNP0003
pnp: PnP ACPI: found 16 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post a r=
eport
NET: Registered protocol family 8
NET: Registered protocol family 20
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 4000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
hpet0: 3 32-bit timers, 25000000 Hz
Time: hpet clocksource has been installed.
ACPI: RTC can wake from S4
pnp: the driver 'system' has been registered
pnp: match found with the PnP device '00:01' and the driver 'system'
pnp: 00:01: ioport range 0x408-0x40f has been reserved
pnp: 00:01: ioport range 0x4d0-0x4d1 has been reserved
pnp: 00:01: ioport range 0x700-0x73f has been reserved
PCI: Bridge: 0000:00:09.0
  IO window: 1000-2fff
  MEM window: d9d00000-d9efffff
  PREFETCH window: d0000000-d7ffffff
PCI: Bridge: 0000:00:0c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0d.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0e.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0c.0 to 64
PCI: Setting latency timer of device 0000:00:0d.0 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
PCI: Bridge: 0000:40:0b.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:40:0c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:40:0d.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:40:0e.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:40:10.0
  IO window: disabled.
  MEM window: da000000-ddffffff
  PREFETCH window: 88000000-880fffff
PCI: Bridge: 0000:40:11.0
  IO window: 3000-3fff
  MEM window: dfe00000-dfefffff
  PREFETCH window: 88100000-881fffff
PCI: Setting latency timer of device 0000:40:0b.0 to 64
PCI: Setting latency timer of device 0000:40:0c.0 to 64
PCI: Setting latency timer of device 0000:40:0d.0 to 64
PCI: Setting latency timer of device 0000:40:0e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
TCP established hash table entries: 2097152 (order: 13, 50331648 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 2097152 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 7574k freed
audit: initializing netlink socket (disabled)
audit(1246277507.840:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Found enabled HT MSI Mapping on 0000:00:0c.0
PCI: Found enabled HT MSI Mapping on 0000:00:0d.0
PCI: Found enabled HT MSI Mapping on 0000:00:0e.0
Boot video device is 0000:01:03.0
pci 0000:01:04.4: HCRESET not completed yet!
PCI: Found enabled HT MSI Mapping on 0000:40:0b.0
PCI: Found enabled HT MSI Mapping on 0000:40:0c.0
PCI: Found enabled HT MSI Mapping on 0000:40:0d.0
PCI: Found enabled HT MSI Mapping on 0000:40:0e.0
PCI: Setting latency timer of device 0000:00:0c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0c.0:pcie00]
PCI: Setting latency timer of device 0000:00:0d.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0d.0:pcie00]
PCI: Setting latency timer of device 0000:00:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0e.0:pcie00]
PCI: Setting latency timer of device 0000:40:0b.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:40:0b.0:pcie00]
PCI: Setting latency timer of device 0000:40:0c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:40:0c.0:pcie00]
PCI: Setting latency timer of device 0000:40:0d.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:40:0d.0:pcie00]
PCI: Setting latency timer of device 0000:40:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:40:0e.0:pcie00]
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Linux agpgart interface v0.102 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
pnp: the driver 'serial' has been registered
pnp: match found with the PnP device '00:09' and the driver 'serial'
00:09: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
pnp: the driver 'i8042 kbd' has been registered
pnp: match found with the PnP device '00:06' and the driver 'i8042 kbd'
pnp: the driver 'i8042 aux' has been registered
pnp: match found with the PnP device '00:07' and the driver 'i8042 aux'
PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Freeing unused kernel memory: 296k freed
ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not=
 present [20070126]
ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not=
 present [20070126]
ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not=
 present [20070126]
ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not=
 present [20070126]
ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not=
 present [20070126]
ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not=
 present [20070126]
ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not=
 present [20070126]
ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not=
 present [20070126]
ACPI: PCI Interrupt Link [LNU2] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LNU2] -> GSI 23 (level, high) =
-> IRQ 23
PCI: Setting latency timer of device 0000:00:02.1 to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.1
ehci_hcd 0000:00:02.1: irq 23, io mem 0xd9cd0000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=3D=
xx
pnp: the driver 'ide' has been registered
SCSI subsystem initialized
HP CISS Driver (v 3.6.14)
NFORCE-CK804: IDE controller at PCI slot 0000:00:06.0
NFORCE-CK804: chipset revision 163
ACPI: PCI Interrupt 0000:42:02.0[A] -> GSI 26 (level, low) -> IRQ 26
Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v1.5.11 (June 4, 2007)
ACPI: PCI Interrupt 0000:41:01.0[A] -> GSI 31 (level, low) -> IRQ 31
NFORCE-CK804: not 100% native mode: will probe irqs later
NFORCE-CK804: 0000:00:06.0 (rev a3) UDMA133 controller
    ide0: BM-DMA at 0x0500-0x0507, BIOS settings: hda:DMA, hdb:pio
Probing IDE interface ide0...
eth0: Broadcom NetXtreme II BCM5706 1000Base-T (A2) PCI-X 64-bit 100MHz fou=
nd at mem dc000000, IRQ 31, node addr 001cc4f094fa
ACPI: PCI Interrupt 0000:41:02.0[A] -> GSI 32 (level, low) -> IRQ 32
eth1: Broadcom NetXtreme II BCM5706 1000Base-T (A2) PCI-X 64-bit 100MHz fou=
nd at mem da000000, IRQ 32, node addr 001cc4f094fc
cciss0: <0x3220> at PCI 0000:42:02.0 IRQ 26 using DAC
      blocks=3D 286677120 block_size=3D 512
      heads=3D255, sectors=3D32, cylinders=3D35132

      blocks=3D 860051248 block_size=3D 512
      heads=3D255, sectors=3D32, cylinders=3D105399

      blocks=3D 286677120 block_size=3D 512
      heads=3D255, sectors=3D32, cylinders=3D35132

 cciss/c0d0: p1 p2
      blocks=3D 860051248 block_size=3D 512
      heads=3D255, sectors=3D32, cylinders=3D105399

 cciss/c0d1: unknown partition table
usb 1-6: new high speed USB device using ehci_hcd and address 3
usb 1-6: configuration #1 chosen from 1 choice
hub 1-6:1.0: USB hub found
hub 1-6:1.0: 4 ports detected
hda: HL-DT-ST DVDRAM GSA-T20L, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
libata version 2.21 loaded.
hda: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LNU0] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNU0] -> GSI 22 (level, high) =
-> IRQ 22
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 22, io mem 0xd9ce0000
USB Universal Host Controller Interface driver v3.0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
ACPI: PCI Interrupt Link [LNKX] enabled at IRQ 17
ACPI: PCI Interrupt 0000:01:04.4[B] -> Link [LNKX] -> GSI 17 (level, high) =
-> IRQ 17
uhci_hcd 0000:01:04.4: UHCI Host Controller
uhci_hcd 0000:01:04.4: new USB bus registered, assigned bus number 3
uhci_hcd 0000:01:04.4: port count misdetected? forcing to 2 ports
uhci_hcd 0000:01:04.4: HCRESET not completed yet!
uhci_hcd 0000:01:04.4: irq 17, io base 0x00001800
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redha=
t.com
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
usb 2-3: new low speed USB device using ohci_hcd and address 2
usb 2-3: configuration #1 chosen from 1 choice
udev: starting version 141
udev: deprecated sysfs layout; update the kernel or disable CONFIG_SYSFS_DE=
PRECATED; some udev features will not work correctly
usb 3-1: new full speed USB device using uhci_hcd and address 2
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
shpchp: HPC vendor_id 1022 device_id 7458 ss_vid 0 ss_did 0
shpchp: shpc_init: cannot reserve MMIO region
shpchp: HPC vendor_id 1022 device_id 7458 ss_vid 0 ss_did 0
shpchp: shpc_init: cannot reserve MMIO region
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
pnp: the driver 'rtc_cmos' has been registered
pnp: match found with the PnP device '00:0a' and the driver 'rtc_cmos'
rtc_cmos 00:0a: rtc core: registered rtc_cmos as rtc0
pnp: Device 00:0a does not support disabling.
rtc_cmos: probe of 00:0a failed with error -16
usb 3-1: configuration #1 chosen from 1 choice
usb 3-2: new full speed USB device using uhci_hcd and address 3
usb 3-2: configuration #1 chosen from 1 choice
hub 3-2:1.0: USB hub found
hub 3-2:1.0: 7 ports detected
usbcore: registered new interface driver hiddev
input: Avocent HP 336047-B21 as /class/input/input0
input: USB HID v1.10 Keyboard [Avocent HP 336047-B21] on usb-0000:00:02.0-3
input: Avocent HP 336047-B21 as /class/input/input1
input: USB HID v1.10 Mouse [Avocent HP 336047-B21] on usb-0000:00:02.0-3
input: HP Virtual Keyboard as /class/input/input2
input: USB HID v1.01 Keyboard [HP Virtual Keyboard] on usb-0000:01:04.4-1
input: HP Virtual Keyboard as /class/input/input3
input: USB HID v1.01 Mouse [HP Virtual Keyboard] on usb-0000:01:04.4-1
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
EXT3 FS on cciss/c0d0p1, internal journal
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
ipmi message handler version 39.1
ipmi device interface
IPMI System Interface driver.
ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca2, sl=
ave address 0x20, irq 0
ipmi: Found new BMC (man_id: 0x00000b,  prod_id: 0x0000, dev_id: 0x11)
 IPMI kcs interface initialized
ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca2, slav=
e address 0x0, irq 0
ipmi_si: duplicate interface
ACPI: PCI Interrupt Link [LNKW] enabled at IRQ 16
ACPI: PCI Interrupt 0000:01:04.6[A] -> Link [LNKW] -> GSI 16 (level, high) =
-> IRQ 16
ipmi_si: Trying PCI-specified kcs state machine at mem address 0xd9df0000, =
slave address 0x0, irq 16
  Using irq 16
ipmi: interfacing existing BMC (man_id: 0x00000b, prod_id: 0x0000, dev_id: =
0x11)
 IPMI kcs interface initialized
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 16777208k swap on /dev/mapper/vg0-swap.  Priority:-1 extents:1 acros=
s:16777208k
NET: Registered protocol family 15
Ethernet Channel Bonding Driver: v3.1.3 (June 13, 2007)
bonding: MII link monitoring set to 100 ms
bonding: bond0: Adding slave eth0.
bonding: bond0: enslaving eth0 as a backup interface with a down link.
bonding: bond0: Adding slave eth1.
bonding: bond0: enslaving eth1 as a backup interface with a down link.
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth0: link is not ready
ADDRCONF(NETDEV_UP): eth1: link is not ready
ADDRCONF(NETDEV_UP): bond0: link is not ready
Initializing XFRM netlink socket
bnx2: eth0 NIC Link is Up, 1000 Mbps full duplex
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
bonding: bond0: link status up for interface eth0, enabling it in 10000 ms.
bnx2: eth1 NIC Link is Up, 1000 Mbps full duplex
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
bonding: bond0: link status up for interface eth1, enabling it in 10000 ms.
bonding: bond0: link status definitely up for interface eth0.
bonding: bond0: making interface eth0 the new active one.
bonding: bond0: first active interface up!
ADDRCONF(NETDEV_CHANGE): bond0: link becomes ready
bonding: bond0: link status definitely up for interface eth1.
eth1: no IPv6 routers present
eth0: no IPv6 routers present
bond0: no IPv6 routers present
Fusion MPT base driver 3.04.04
Copyright (c) 1999-2007 LSI Logic Corporation
Fusion MPT misc device (ioctl) driver 3.04.04
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=3D10,220)
pnp: the driver 'parport_pc' has been registered
lp: driver loaded but no devices found
ppdev: user-space parallel port driver

--AaroDtM9M79Ffl67
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="boot-with-debug-2.6.30"
Content-Transfer-Encoding: quoted-printable

Probing EDD (edd=3Doff to disable)... ok=0D
[    0.000000] Initializing cgroup subsys cpuset=0D
[    0.000000] Initializing cgroup subsys cpu=0D
[    0.000000] Linux version 2.6.30-1-amd64 (Debian 2.6.30-1) (waldi@debian=
=2Eorg) (gcc version 4.3.3 (Debian 4.3.3-10) ) #1 SMP Sun Jun 14 15:00:29 U=
TC 2009=0D
[    0.000000] Command line: root=3D/dev/cciss/c0d0p1 ro debug console=3Dtt=
yS1,115200=0D
[    0.000000] KERNEL supported cpus:=0D
[    0.000000]   Intel GenuineIntel=0D
[    0.000000]   AMD AuthenticAMD=0D
[    0.000000]   Centaur CentaurHauls=0D
[    0.000000] BIOS-provided physical RAM map:=0D
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)=0D
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)=0D
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)=0D
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fe4e000 (usable)=0D
[    0.000000]  BIOS-e820: 000000007fe4e000 - 000000007fe56000 (ACPI data)=
=0D
[    0.000000]  BIOS-e820: 000000007fe56000 - 000000007fe57000 (usable)=0D
[    0.000000]  BIOS-e820: 000000007fe57000 - 0000000080000000 (reserved)=0D
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)=0D
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)=0D
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)=0D
[    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)=0D
[    0.000000]  BIOS-e820: 0000000100000000 - 000000047ffff000 (usable)=0D
[    0.000000] DMI 2.4 present.=0D
[    0.000000] last_pfn =3D 0x47ffff max_arch_pfn =3D 0x100000000=0D
[    0.000000] MTRR default type: uncachable=0D
[    0.000000] MTRR fixed ranges enabled:=0D
[    0.000000]   00000-9FFFF write-back=0D
[    0.000000]   A0000-BFFFF uncachable=0D
[    0.000000]   C0000-FFFFF write-back=0D
[    0.000000] MTRR variable ranges enabled:=0D
[    0.000000]   0 base 0000000000 mask FF80000000 write-back=0D
[    0.000000]   1 disabled=0D
[    0.000000]   2 disabled=0D
[    0.000000]   3 disabled=0D
[    0.000000]   4 disabled=0D
[    0.000000]   5 disabled=0D
[    0.000000]   6 disabled=0D
[    0.000000]   7 disabled=0D
[    0.000000] TOM2: 0000000480000000 aka 18432M=0D
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106=0D
[    0.000000] e820 update range: 0000000080000000 - 0000000100000000 (usab=
le) =3D=3D> (reserved)=0D
[    0.000000] last_pfn =3D 0x7fe57 max_arch_pfn =3D 0x100000000=0D
[    0.000000] init_memory_mapping: 0000000000000000-000000007fe57000=0D
[    0.000000]  0000000000 - 007fe00000 page 2M=0D
[    0.000000]  007fe00000 - 007fe57000 page 4k=0D
[    0.000000] kernel direct mapping tables up to 7fe57000 @ 8000-c000=0D
[    0.000000] init_memory_mapping: 0000000100000000-000000047ffff000=0D
[    0.000000]  0100000000 - 047fe00000 page 2M=0D
[    0.000000]  047fe00000 - 047ffff000 page 4k=0D
[    0.000000] kernel direct mapping tables up to 47ffff000 @ a000-1e000=0D
[    0.000000] RAMDISK: 3772d000 - 37fef723=0D
[    0.000000] ACPI: RSDP 00000000000f4f00 00024 (v02 HP    )=0D
[    0.000000] ACPI: XSDT 000000007fe4ed00 00074 (v01 HP     ProLiant 00000=
002   =D2=04 0000162E)=0D
[    0.000000] ACPI: FACP 000000007fe4ed80 000F4 (v03 HP     A07      00000=
002   =D2=04 0000162E)=0D
[    0.000000] ACPI: DSDT 000000007fe4ee80 0498A (v01 HP         DSDT 00000=
001 INTL 20030228)=0D
[    0.000000] ACPI: FACS 000000007fe4e100 00040=0D
[    0.000000] ACPI: SPCR 000000007fe4e140 00050 (v01 HP     SPCRRBSU 00000=
001   =D2=04 0000162E)=0D
[    0.000000] ACPI: HPET 000000007fe4e1c0 00038 (v01 HP     ProLiant 00000=
002   =D2=04 0000162E)=0D
[    0.000000] ACPI: SPMI 000000007fe4e200 00040 (v05 HP     ProLiant 00000=
001   =D2=04 0000162E)=0D
[    0.000000] ACPI: ERST 000000007fe4e240 001D0 (v01 HP     ProLiant 00000=
001   =D2=04 0000162E)=0D
[    0.000000] ACPI: APIC 000000007fe4e440 000C6 (v01 HP     ProLiant 00000=
002      00000000)=0D
[    0.000000] ACPI: SRAT 000000007fe4e580 001A0 (v01 AMD    FAM_F_10 00000=
002 AMD  00000001)=0D
[    0.000000] ACPI: FFFF 000000007fe4e980 00176 (v01 HP     ProLiant 00000=
001   =D2=04 0000162E)=0D
[    0.000000] ACPI: BERT 000000007fe4eb00 00030 (v01 HP     ProLiant 00000=
001   =D2=04 0000162E)=0D
[    0.000000] ACPI: HEST 000000007fe4eb40 00170 (v01 HP     ProLiant 00000=
001   =D2=04 0000162E)=0D
[    0.000000] ACPI: Local APIC address 0xfee00000=0D
[    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0=0D
[    0.000000] SRAT: PXM 0 -> APIC 1 -> Node 0=0D
[    0.000000] SRAT: PXM 1 -> APIC 2 -> Node 1=0D
[    0.000000] SRAT: PXM 1 -> APIC 3 -> Node 1=0D
[    0.000000] SRAT: PXM 2 -> APIC 4 -> Node 2=0D
[    0.000000] SRAT: PXM 2 -> APIC 5 -> Node 2=0D
[    0.000000] SRAT: PXM 3 -> APIC 6 -> Node 3=0D
[    0.000000] SRAT: PXM 3 -> APIC 7 -> Node 3=0D
[    0.000000] SRAT: Node 0 PXM 0 0-a0000=0D
[    0.000000] SRAT: Node 0 PXM 0 100000-80000000=0D
[    0.000000] SRAT: Node 0 PXM 0 100000000-180000000=0D
[    0.000000] SRAT: Node 1 PXM 1 180000000-280000000=0D
[    0.000000] SRAT: Node 2 PXM 2 280000000-380000000=0D
[    0.000000] SRAT: Node 3 PXM 3 380000000-480000000=0D
[    0.000000] NUMA: Allocated memnodemap from 19000 - 22040=0D
[    0.000000] NUMA: Using 20 for the hash shift.=0D
[    0.000000] Bootmem setup node 0 0000000000000000-0000000180000000=0D
[    0.000000]   NODE_DATA [0000000000022040 - 000000000002a03f]=0D
[    0.000000]   bootmap [000000000002b000 -  000000000005afff] pages 30=0D
[    0.000000] (9 early reservations) =3D=3D> bootmem [0000000000 - 0180000=
000]=0D
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [000=
0000000 - 0000001000]=0D
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE =3D=3D> [000=
0006000 - 0000008000]=0D
[    0.000000]   #2 [0000200000 - 00007d98cc]    TEXT DATA BSS =3D=3D> [000=
0200000 - 00007d98cc]=0D
[    0.000000]   #3 [003772d000 - 0037fef723]          RAMDISK =3D=3D> [003=
772d000 - 0037fef723]=0D
[    0.000000]   #4 [000009f400 - 0000100000]    BIOS reserved =3D=3D> [000=
009f400 - 0000100000]=0D
[    0.000000]   #5 [00007da000 - 00007da114]              BRK =3D=3D> [000=
07da000 - 00007da114]=0D
[    0.000000]   #6 [0000008000 - 000000a000]          PGTABLE =3D=3D> [000=
0008000 - 000000a000]=0D
[    0.000000]   #7 [000000a000 - 0000019000]          PGTABLE =3D=3D> [000=
000a000 - 0000019000]=0D
[    0.000000]   #8 [0000019000 - 0000022040]       MEMNODEMAP =3D=3D> [000=
0019000 - 0000022040]=0D
[    0.000000] Bootmem setup node 1 0000000180000000-0000000280000000=0D
[    0.000000]   NODE_DATA [0000000180000000 - 0000000180007fff]=0D
[    0.000000]   bootmap [0000000180008000 -  0000000180027fff] pages 20=0D
[    0.000000] (9 early reservations) =3D=3D> bootmem [0180000000 - 0280000=
000]=0D
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page=0D
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE=0D
[    0.000000]   #2 [0000200000 - 00007d98cc]    TEXT DATA BSS=0D
[    0.000000]   #3 [003772d000 - 0037fef723]          RAMDISK=0D
[    0.000000]   #4 [000009f400 - 0000100000]    BIOS reserved=0D
[    0.000000]   #5 [00007da000 - 00007da114]              BRK=0D
[    0.000000]   #6 [0000008000 - 000000a000]          PGTABLE=0D
[    0.000000]   #7 [000000a000 - 0000019000]          PGTABLE=0D
[    0.000000]   #8 [0000019000 - 0000022040]       MEMNODEMAP=0D
[    0.000000] Bootmem setup node 2 0000000280000000-0000000380000000=0D
[    0.000000]   NODE_DATA [0000000280000000 - 0000000280007fff]=0D
[    0.000000]   bootmap [0000000280008000 -  0000000280027fff] pages 20=0D
[    0.000000] (9 early reservations) =3D=3D> bootmem [0280000000 - 0380000=
000]=0D
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page=0D
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE=0D
[    0.000000]   #2 [0000200000 - 00007d98cc]    TEXT DATA BSS=0D
[    0.000000]   #3 [003772d000 - 0037fef723]          RAMDISK=0D
[    0.000000]   #4 [000009f400 - 0000100000]    BIOS reserved=0D
[    0.000000]   #5 [00007da000 - 00007da114]              BRK=0D
[    0.000000]   #6 [0000008000 - 000000a000]          PGTABLE=0D
[    0.000000]   #7 [000000a000 - 0000019000]          PGTABLE=0D
[    0.000000]   #8 [0000019000 - 0000022040]       MEMNODEMAP=0D
[    0.000000] Bootmem setup node 3 0000000380000000-000000047ffff000=0D
[    0.000000]   NODE_DATA [0000000380000000 - 0000000380007fff]=0D
[    0.000000]   bootmap [0000000380008000 -  0000000380027fff] pages 20=0D
[    0.000000] (9 early reservations) =3D=3D> bootmem [0380000000 - 047ffff=
000]=0D
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page=0D
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE=0D
[    0.000000]   #2 [0000200000 - 00007d98cc]    TEXT DATA BSS=0D
[    0.000000]   #3 [003772d000 - 0037fef723]          RAMDISK=0D
[    0.000000]   #4 [000009f400 - 0000100000]    BIOS reserved=0D
[    0.000000]   #5 [00007da000 - 00007da114]              BRK=0D
[    0.000000]   #6 [0000008000 - 000000a000]          PGTABLE=0D
[    0.000000]   #7 [000000a000 - 0000019000]          PGTABLE=0D
[    0.000000]   #8 [0000019000 - 0000022040]       MEMNODEMAP=0D
[    0.000000] found SMP MP-table at [ffff8800000f4f80] f4f80=0D
[    0.000000]  [ffffe20000000000-ffffe200053fffff] PMD -> [ffff88002820000=
0-ffff88002b9fffff] on node 0=0D
[    0.000000]  [ffffe20005400000-ffffe20008bfffff] PMD -> [ffff88018020000=
0-ffff8801839fffff] on node 1=0D
[    0.000000]  [ffffe20008c00000-ffffe2000c3fffff] PMD -> [ffff88028020000=
0-ffff8802839fffff] on node 2=0D
[    0.000000]  [ffffe2000c400000-ffffe2000fbfffff] PMD -> [ffff88038020000=
0-ffff8803839fffff] on node 3=0D
[    0.000000] Zone PFN ranges:=0D
[    0.000000]   DMA      0x00000000 -> 0x00001000=0D
[    0.000000]   DMA32    0x00001000 -> 0x00100000=0D
[    0.000000]   Normal   0x00100000 -> 0x0047ffff=0D
[    0.000000] Movable zone start PFN for each node=0D
[    0.000000] early_node_map[7] active PFN ranges=0D
[    0.000000]     0: 0x00000000 -> 0x0000009f=0D
[    0.000000]     0: 0x00000100 -> 0x0007fe4e=0D
[    0.000000]     0: 0x0007fe56 -> 0x0007fe57=0D
[    0.000000]     0: 0x00100000 -> 0x00180000=0D
[    0.000000]     1: 0x00180000 -> 0x00280000=0D
[    0.000000]     2: 0x00280000 -> 0x00380000=0D
[    0.000000]     3: 0x00380000 -> 0x0047ffff=0D
[    0.000000] On node 0 totalpages: 1048046=0D
[    0.000000]   DMA zone: 56 pages used for memmap=0D
[    0.000000]   DMA zone: 1622 pages reserved=0D
[    0.000000]   DMA zone: 2321 pages, LIFO batch:0=0D
[    0.000000]   DMA32 zone: 14280 pages used for memmap=0D
[    0.000000]   DMA32 zone: 505479 pages, LIFO batch:31=0D
[    0.000000]   Normal zone: 7168 pages used for memmap=0D
[    0.000000]   Normal zone: 517120 pages, LIFO batch:31=0D
[    0.000000] On node 1 totalpages: 1048576=0D
[    0.000000]   Normal zone: 14336 pages used for memmap=0D
[    0.000000]   Normal zone: 1034240 pages, LIFO batch:31=0D
[    0.000000] On node 2 totalpages: 1048576=0D
[    0.000000]   Normal zone: 14336 pages used for memmap=0D
[    0.000000]   Normal zone: 1034240 pages, LIFO batch:31=0D
[    0.000000] On node 3 totalpages: 1048575=0D
[    0.000000]   Normal zone: 14336 pages used for memmap=0D
[    0.000000]   Normal zone: 1034239 pages, LIFO batch:31=0D
[    0.000000] Detected use of extended apic ids on hypertransport bus=0D
[    0.000000] Detected use of extended apic ids on hypertransport bus=0D
[    0.000000] Detected use of extended apic ids on hypertransport bus=0D
[    0.000000] Detected use of extended apic ids on hypertransport bus=0D
[    0.000000] ACPI: PM-Timer IO Port: 0x908=0D
[    0.000000] ACPI: Local APIC address 0xfee00000=0D
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)=0D
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)=0D
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)=0D
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)=0D
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)=0D
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)=0D
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)=0D
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)=0D
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])=0D
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xd9cf0000] gsi_base[0])=0D
[    0.000000] IOAPIC[0]: apic_id 8, version 0, address 0xd9cf0000, GSI 0-2=
3=0D
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xd9fd0000] gsi_base[24])=0D
[    0.000000] IOAPIC[1]: apic_id 9, version 0, address 0xd9fd0000, GSI 24-=
30=0D
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xd9fe0000] gsi_base[31])=0D
[    0.000000] IOAPIC[2]: apic_id 10, version 0, address 0xd9fe0000, GSI 31=
-37=0D
[    0.000000] ACPI: IOAPIC (id[0x0b] address[0xd9ff0000] gsi_base[38])=0D
[    0.000000] IOAPIC[3]: apic_id 11, version 0, address 0xd9ff0000, GSI 38=
-61=0D
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 0 high edge)=0D
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)=0D
[    0.000000] ACPI: IRQ0 used by override.=0D
[    0.000000] ACPI: IRQ9 used by override.=0D
[    0.000000] ACPI: NMI_SRC (dfl dfl global_irq 28)=0D
[    0.000000] ACPI: NMI_SRC (dfl dfl global_irq 35)=0D
[    0.000000] Using ACPI (MADT) for SMP configuration information=0D
[    0.000000] ACPI: HPET id: 0x10228201 base: 0xfed00000=0D
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs=0D
[    0.000000] nr_irqs_gsi: 62=0D
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000=0D
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
f0000=0D
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 00000000001=
00000=0D
[    0.000000] PM: Registered nosave memory: 000000007fe4e000 - 000000007fe=
56000=0D
[    0.000000] PM: Registered nosave memory: 000000007fe57000 - 00000000800=
00000=0D
[    0.000000] PM: Registered nosave memory: 0000000080000000 - 00000000e00=
00000=0D
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f00=
00000=0D
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec=
00000=0D
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fed=
00000=0D
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fee=
00000=0D
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee=
10000=0D
[    0.000000] PM: Registered nosave memory: 00000000fee10000 - 00000000ffc=
00000=0D
[    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 00000001000=
00000=0D
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000=
:60000000)=0D
[    0.000000] NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:8 nr_node_ids:4=0D
[    0.000000] PERCPU: Allocated 19 4k pages, static data 76256 bytes=0D
[    0.000000] Built 4 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 4127639=0D
[    0.000000] Policy zone: Normal=0D
[    0.000000] Kernel command line: root=3D/dev/cciss/c0d0p1 ro debug conso=
le=3DttyS1,115200=0D
[    0.000000] Initializing CPU#0=0D
[    0.000000] Experimental hierarchical RCU implementation.=0D
[    0.000000] Experimental hierarchical RCU init done.=0D
[    0.000000] NR_IRQS:4352 nr_irqs:1118=0D
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)=0D
[    0.000000] Extended CMOS year: 2000=0D
[    0.000000] Fast TSC calibration using PIT=0D
[    0.000000] Detected 2813.220 MHz processor.=0D
[    0.004000] spurious 8259A interrupt: IRQ7.=0D
[    0.004000] Console: colour VGA+ 80x25=0D
[    0.004000] console [ttyS1] enabled=0D
[    0.004000] Checking aperture...=0D
[    0.004000] No AGP bridge found=0D
[    0.004000] Node 0: aperture @ 20000000 size 32 MB=0D
[    0.004000] Aperture pointing to e820 RAM. Ignoring.=0D
[    0.004000] Your BIOS doesn't leave a aperture memory hole=0D
[    0.004000] Please enable the IOMMU option in the BIOS setup=0D
[    0.004000] This costs you 64 MB of RAM=0D
[    0.004000] Mapping aperture over 65536 KB of RAM @ 20000000=0D
[    0.004000] PM: Registered nosave memory: 0000000020000000 - 00000000240=
00000=0D
[    0.004000] Memory: 16463796k/18874364k available (2782k kernel code, 20=
99272k absent, 311296k reserved, 1398k data, 560k init)=0D
[    0.004000] hpet clockevent registered=0D
[    0.004000] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer=0D
[    0.004000] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 5626.44 BogoMIPS (lpj=3D11252880)=0D
[    0.004000] Security Framework initialized=0D
[    0.004000] SELinux:  Disabled at boot.=0D
[    0.005448] Dentry cache hash table entries: 2097152 (order: 12, 1677721=
6 bytes)=0D
[    0.019021] Inode-cache hash table entries: 1048576 (order: 11, 8388608 =
bytes)=0D
[    0.025049] Mount-cache hash table entries: 256=0D
[    0.025428] Initializing cgroup subsys ns=0D
[    0.025944] Initializing cgroup subsys cpuacct=0D
[    0.026946] Initializing cgroup subsys devices=0D
[    0.027938] Initializing cgroup subsys freezer=0D
[    0.028004] Initializing cgroup subsys net_cls=0D
[    0.029064] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)=0D
[    0.030050] CPU: L2 Cache: 1024K (64 bytes/line)=0D
[    0.031000] CPU 0/0x0 -> Node 0=0D
[    0.032002] tseg: 0000000000=0D
[    0.032994] CPU: Physical Processor ID: 0=0D
[    0.034006] CPU: Processor Core ID: 0=0D
[    0.035034] using C1E aware idle routine=0D
[    0.036583] ACPI: Core revision 20090320=0D
[    0.046374] Setting APIC routing to flat=0D
[    0.048421] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D0 apic2=3D-1 pin2=3D=
-1=0D
[    0.092558] CPU0: Dual-Core AMD Opteron(tm) Processor 8220 stepping 03=0D
[    0.104001] Booting processor 1 APIC 0x2 ip 0x6000=0D
[    0.004000] Initializing CPU#1=0D
[    0.004000] Calibrating delay using timer specific routine.. 5625.98 Bog=
oMIPS (lpj=3D11251976)=0D
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)=0D
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)=0D
[    0.004000] CPU 1/0x2 -> Node 1=0D
[    0.004000] CPU: Physical Processor ID: 1=0D
[    0.004000] CPU: Processor Core ID: 0=0D
[    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x701060007=
0106=0D
[    0.196646] CPU1: Dual-Core AMD Opteron(tm) Processor 8220 stepping 03=0D
[    0.204110] Booting processor 2 APIC 0x4 ip 0x6000=0D
[    0.004000] Initializing CPU#2=0D
[    0.004000] Calibrating delay using timer specific routine.. 5626.00 Bog=
oMIPS (lpj=3D11252017)=0D
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)=0D
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)=0D
[    0.004000] CPU 2/0x4 -> Node 2=0D
[    0.004000] CPU: Physical Processor ID: 2=0D
[    0.004000] CPU: Processor Core ID: 0=0D
[    0.004000] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x701060007=
0106=0D
[    0.300611] CPU2: Dual-Core AMD Opteron(tm) Processor 8220 stepping 03=0D
[    0.316183] Booting processor 3 APIC 0x6 ip 0x6000=0D
[    0.004000] Initializing CPU#3=0D
[    0.004000] Calibrating delay using timer specific routine.. 5625.99 Bog=
oMIPS (lpj=3D11251993)=0D
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)=0D
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)=0D
[    0.004000] CPU 3/0x6 -> Node 3=0D
[    0.004000] CPU: Physical Processor ID: 3=0D
[    0.004000] CPU: Processor Core ID: 0=0D
[    0.004000] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x701060007=
0106=0D
[    0.408736] CPU3: Dual-Core AMD Opteron(tm) Processor 8220 stepping 03=0D
[    0.416687] Booting processor 4 APIC 0x1 ip 0x6000=0D
[    0.004000] Initializing CPU#4=0D
[    0.004000] Calibrating delay using timer specific routine.. 5625.96 Bog=
oMIPS (lpj=3D11251933)=0D
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)=0D
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)=0D
[    0.004000] CPU 4/0x1 -> Node 0=0D
[    0.004000] CPU: Physical Processor ID: 0=0D
[    0.004000] CPU: Processor Core ID: 1=0D
[    0.004000] x86 PAT enabled: cpu 4, old 0x7040600070406, new 0x701060007=
0106=0D
[    0.512533] CPU4: Dual-Core AMD Opteron(tm) Processor 8220 stepping 03=0D
[    0.528175] Booting processor 5 APIC 0x3 ip 0x6000=0D
[    0.004000] Initializing CPU#5=0D
[    0.004000] Calibrating delay using timer specific routine.. 5626.00 Bog=
oMIPS (lpj=3D11252000)=0D
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)=0D
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)=0D
[    0.004000] CPU 5/0x3 -> Node 1=0D
[    0.004000] CPU: Physical Processor ID: 1=0D
[    0.004000] CPU: Processor Core ID: 1=0D
[    0.004000] x86 PAT enabled: cpu 5, old 0x7040600070406, new 0x701060007=
0106=0D
[    0.620606] CPU5: Dual-Core AMD Opteron(tm) Processor 8220 stepping 03=0D
[    0.628739] Booting processor 6 APIC 0x5 ip 0x6000=0D
[    0.004000] Initializing CPU#6=0D
[    0.004000] Calibrating delay using timer specific routine.. 5626.01 Bog=
oMIPS (lpj=3D11252033)=0D
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)=0D
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)=0D
[    0.004000] CPU 6/0x5 -> Node 2=0D
[    0.004000] CPU: Physical Processor ID: 2=0D
[    0.004000] CPU: Processor Core ID: 1=0D
[    0.004000] x86 PAT enabled: cpu 6, old 0x7040600070406, new 0x701060007=
0106=0D
[    0.724628] CPU6: Dual-Core AMD Opteron(tm) Processor 8220 stepping 03=0D
[    0.736213] Booting processor 7 APIC 0x7 ip 0x6000=0D
[    0.004000] Initializing CPU#7=0D
[    0.004000] Calibrating delay using timer specific routine.. 5625.96 Bog=
oMIPS (lpj=3D11251925)=0D
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)=0D
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)=0D
[    0.004000] CPU 7/0x7 -> Node 3=0D
[    0.004000] CPU: Physical Processor ID: 3=0D
[    0.004000] CPU: Processor Core ID: 1=0D
[    0.004000] x86 PAT enabled: cpu 7, old 0x7040600070406, new 0x701060007=
0106=0D
[    0.832703] CPU7: Dual-Core AMD Opteron(tm) Processor 8220 stepping 03=0D
[    0.840009] Brought up 8 CPUs=0D
[    0.841323] Total of 8 processors activated (45008.37 BogoMIPS).=0D
[    0.844152] CPU0 attaching sched-domain:=0D
[    0.848005]  domain 0: span 0,4 level CPU=0D
[    0.849811]   groups: 0 4=0D
[    0.854015]   domain 1: span 0-7 level NODE=0D
[    0.856840]    groups: 0,4 (__cpu_power =3D 2048) 1,5 (__cpu_power =3D 2=
048) 2,6 (__cpu_power =3D 2048) 3,7 (__cpu_power =3D 2048)=0D
[    0.876005] CPU1 attaching sched-domain:=0D
[    0.880008]  domain 0: span 1,5 level CPU=0D
[    0.888003]   groups: 1 5=0D
[    0.889280]   domain 1: span 0-7 level NODE=0D
[    0.891170]    groups: 1,5 (__cpu_power =3D 2048) 2,6 (__cpu_power =3D 2=
048) 3,7 (__cpu_power =3D 2048) 0,4 (__cpu_power =3D 2048)=0D
[    0.904902] CPU2 attaching sched-domain:=0D
[    0.908005]  domain 0: span 2,6 level CPU=0D
[    0.912003]   groups: 2 6=0D
[    0.920004]   domain 1: span 0-7 level NODE=0D
[    0.924837]    groups: 2,6 (__cpu_power =3D 2048) 3,7 (__cpu_power =3D 2=
048) 0,4 (__cpu_power =3D 2048) 1,5 (__cpu_power =3D 2048)=0D
[    0.952004] CPU3 attaching sched-domain:=0D
[    0.956004]  domain 0: span 3,7 level CPU=0D
[    0.962700]   groups: 3 7=0D
[    0.964255]   domain 1: span 0-7 level NODE=0D
[    0.968003]    groups: 3,7 (__cpu_power =3D 2048) 0,4 (__cpu_power =3D 2=
048) 1,5 (__cpu_power =3D 2048) 2,6 (__cpu_power =3D 2048)=0D
[    0.982117] CPU4 attaching sched-domain:=0D
[    0.984004]  domain 0: span 0,4 level CPU=0D
[    0.992003]   groups: 4 0=0D
[    1.000004]   domain 1: span 0-7 level NODE=0D
[    1.004835]    groups: 0,4 (__cpu_power =3D 2048) 1,5 (__cpu_power =3D 2=
048) 2,6 (__cpu_power =3D 2048) 3,7 (__cpu_power =3D 2048)=0D
[    1.015035] CPU5 attaching sched-domain:=0D
[    1.016004]  domain 0: span 1,5 level CPU=0D
[    1.024003]   groups: 5 1=0D
[    1.032004]   domain 1: span 0-7 level NODE=0D
[    1.036842]    groups: 1,5 (__cpu_power =3D 2048) 2,6 (__cpu_power =3D 2=
048) 3,7 (__cpu_power =3D 2048) 0,4 (__cpu_power =3D 2048)=0D
[    1.060108] CPU6 attaching sched-domain:=0D
[    1.062024]  domain 0: span 2,6 level CPU=0D
[    1.064773]   groups: 6 2=0D
[    1.066034]   domain 1: span 0-7 level NODE=0D
[    1.067910]    groups: 2,6 (__cpu_power =3D 2048) 3,7 (__cpu_power =3D 2=
048) 0,4 (__cpu_power =3D 2048) 1,5 (__cpu_power =3D 2048)=0D
[    1.077805] CPU7 attaching sched-domain:=0D
[    1.080004]  domain 0: span 3,7 level CPU=0D
[    1.082771]   groups: 7 3=0D
[    1.088004]   domain 1: span 0-7 level NODE=0D
[    1.092839]    groups: 3,7 (__cpu_power =3D 2048) 0,4 (__cpu_power =3D 2=
048) 1,5 (__cpu_power =3D 2048) 2,6 (__cpu_power =3D 2048)=0D
[    1.109100] net_namespace: 1936 bytes=0D
[    1.112064] Booting paravirtualized kernel on bare hardware=0D
[    1.116123] regulator: core version 0.5=0D
[    1.120164] NET: Registered protocol family 16=0D
[    1.124041] node 0 link 1: io port [1000, 2fff]=0D
[    1.128005] node 1 link 2: io port [3000, ffff]=0D
[    1.132004] TOM: 0000000080000000 aka 2048M=0D
[    1.136004] node 0 link 1: mmio [d0000000, d9efffff]=0D
[    1.140079] node 1 link 2: mmio [d9f00000, dfefffff]=0D
[    1.145009] node 0 link 1: mmio [e0000000, e3ffffff]=0D
[    1.148105] node 1 link 2: mmio [e4000000, e7ffffff]=0D
[    1.152109] node 0 link 1: mmio [a0000, bffff]=0D
[    1.155937] TOM2: 0000000480000000 aka 18432M=0D
[    1.156005] bus: [00,3f] on node 0 link 1=0D
[    1.160004] bus: 00 index 0 io port: [0, 2fff]=0D
[    1.164004] bus: 00 index 1 mmio: [80000000, d9efffff]=0D
[    1.168004] bus: 00 index 2 mmio: [dff00000, e3ffffff]=0D
[    1.172004] bus: 00 index 3 mmio: [a0000, bffff]=0D
[    1.176004] bus: 00 index 4 mmio: [e8000000, ffffffff]=0D
[    1.180004] bus: 00 index 5 mmio: [480000000, fcffffffff]=0D
[    1.184004] bus: [40,7f] on node 1 link 2=0D
[    1.188004] bus: 40 index 0 io port: [3000, ffff]=0D
[    1.192004] bus: 40 index 1 mmio: [d9f00000, dfefffff]=0D
[    1.196004] bus: 40 index 2 mmio: [e4000000, e7ffffff]=0D
[    1.200013] ACPI: bus type pci registered=0D
[    1.204039] PCI: Using configuration type 1 for base access=0D
[    1.208010] PCI: HP ProLiant DL585 G2 detected, enabling pci=3Dbfsort.=0D
[    1.212268] bio: create slab <bio-0> at 0=0D
[    1.216390] ACPI: EC: Look up EC in DSDT=0D
[    1.227390] ACPI: SSDT 000000007fe58000 00AC4 (v02 HP     PNOWSSDT 00000=
002 HP   00000001)=0D
[    1.232517] ACPI: Interpreter enabled=0D
[    1.236005] ACPI: (supports S0 S4 S5)=0D
[    1.240379] ACPI: Using IOAPIC for interrupt routing=0D
[    1.248824] ACPI: No dock devices found.=0D
[    1.252018] ACPI: PCI Root Bridge [PCI0] (0000:00)=0D
[    1.256091] pci 0000:00:02.0: reg 10 32bit mmio: [0xd9ce0000-0xd9ce0fff]=
=0D
[    1.260016] pci 0000:00:02.0: supports D1 D2=0D
[    1.264004] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold=
=0D
[    1.268005] pci 0000:00:02.0: PME# disabled=0D
[    1.269905] pci 0000:00:02.1: reg 10 32bit mmio: [0xd9cd0000-0xd9cd00ff]=
=0D
[    1.272018] pci 0000:00:02.1: supports D1 D2=0D
[    1.276006] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold=
=0D
[    1.280005] pci 0000:00:02.1: PME# disabled=0D
[    1.284027] pci 0000:00:06.0: reg 20 io port: [0x500-0x50f]=0D
[    1.288042] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold=
=0D
[    1.292010] pci 0000:00:0c.0: PME# disabled=0D
[    1.296025] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold=
=0D
[    1.300004] pci 0000:00:0d.0: PME# disabled=0D
[    1.304023] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold=
=0D
[    1.308005] pci 0000:00:0e.0: PME# disabled=0D
[    1.312245] pci 0000:01:03.0: reg 10 32bit mmio: [0xd0000000-0xd7ffffff]=
=0D
[    1.316007] pci 0000:01:03.0: reg 14 io port: [0x1000-0x10ff]=0D
[    1.320007] pci 0000:01:03.0: reg 18 32bit mmio: [0xd9ef0000-0xd9efffff]=
=0D
[    1.324016] pci 0000:01:03.0: reg 30 32bit mmio: [0x000000-0x01ffff]=0D
[    1.328017] pci 0000:01:03.0: supports D1 D2=0D
[    1.332026] pci 0000:01:04.0: reg 10 io port: [0x2800-0x28ff]=0D
[    1.336007] pci 0000:01:04.0: reg 14 32bit mmio: [0xd9ee0000-0xd9ee01ff]=
=0D
[    1.340027] pci 0000:01:04.0: PME# supported from D0 D3hot D3cold=0D
[    1.344005] pci 0000:01:04.0: PME# disabled=0D
[    1.348031] pci 0000:01:04.2: reg 10 io port: [0x1400-0x14ff]=0D
[    1.352008] pci 0000:01:04.2: reg 14 32bit mmio: [0xd9ed0000-0xd9ed07ff]=
=0D
[    1.356008] pci 0000:01:04.2: reg 18 32bit mmio: [0xd9ec0000-0xd9ec3fff]=
=0D
[    1.360008] pci 0000:01:04.2: reg 1c 32bit mmio: [0xd9e00000-0xd9e7ffff]=
=0D
[    1.364014] pci 0000:01:04.2: reg 30 32bit mmio: [0x000000-0x00ffff]=0D
[    1.368016] pci 0000:01:04.2: PME# supported from D0 D3hot D3cold=0D
[    1.372006] pci 0000:01:04.2: PME# disabled=0D
[    1.376041] pci 0000:01:04.4: reg 20 io port: [0x1800-0x181f]=0D
[    1.380023] pci 0000:01:04.4: PME# supported from D0 D3hot D3cold=0D
[    1.384006] pci 0000:01:04.4: PME# disabled=0D
[    1.388026] pci 0000:01:04.6: reg 10 32bit mmio: [0xd9df0000-0xd9df00ff]=
=0D
[    1.392032] pci 0000:01:04.6: PME# supported from D0 D3hot D3cold=0D
[    1.396006] pci 0000:01:04.6: PME# disabled=0D
[    1.400029] pci 0000:00:09.0: transparent bridge=0D
[    1.404005] pci 0000:00:09.0: bridge io port: [0x1000-0x2fff]=0D
[    1.408005] pci 0000:00:09.0: bridge 32bit mmio: [0xd9d00000-0xd9efffff]=
=0D
[    1.412005] pci 0000:00:09.0: bridge 32bit mmio pref: [0xd0000000-0xd7ff=
ffff]=0D
[    1.416106] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]=0D
[    1.420084] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IP2P._PRT]=0D
[    1.424111] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE0._PRT]=0D
[    1.428106] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE1._PRT]=0D
[    1.432103] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE2._PRT]=0D
[    1.440145] ACPI: PCI Root Bridge [PCI1] (0000:40)=0D
[    1.444130] pci 0000:40:0b.0: PME# supported from D0 D1 D2 D3hot D3cold=
=0D
[    1.448006] pci 0000:40:0b.0: PME# disabled=0D
[    1.452035] pci 0000:40:0c.0: PME# supported from D0 D1 D2 D3hot D3cold=
=0D
[    1.456005] pci 0000:40:0c.0: PME# disabled=0D
[    1.460034] pci 0000:40:0d.0: PME# supported from D0 D1 D2 D3hot D3cold=
=0D
[    1.464006] pci 0000:40:0d.0: PME# disabled=0D
[    1.465912] pci 0000:40:0e.0: PME# supported from D0 D1 D2 D3hot D3cold=
=0D
[    1.468005] pci 0000:40:0e.0: PME# disabled=0D
[    1.470000] pci 0000:40:10.0: Enabling HT MSI Mapping=0D
[    1.472067] pci 0000:40:11.0: Enabling HT MSI Mapping=0D
[    1.476209] pci 0000:41:01.0: reg 10 64bit mmio: [0xdc000000-0xddffffff]=
=0D
[    1.480016] pci 0000:41:01.0: reg 30 32bit mmio: [0x000000-0x01ffff]=0D
[    1.484016] pci 0000:41:01.0: PME# supported from D3hot D3cold=0D
[    1.488005] pci 0000:41:01.0: PME# disabled=0D
[    1.489914] pci 0000:41:02.0: reg 10 64bit mmio: [0xda000000-0xdbffffff]=
=0D
[    1.492015] pci 0000:41:02.0: reg 30 32bit mmio: [0x000000-0x01ffff]=0D
[    1.496016] pci 0000:41:02.0: PME# supported from D3hot D3cold=0D
[    1.500005] pci 0000:41:02.0: PME# disabled=0D
[    1.504027] pci 0000:40:10.0: bridge 32bit mmio: [0xda000000-0xddffffff]=
=0D
[    1.508035] pci 0000:42:02.0: reg 10 64bit mmio: [0xdfef0000-0xdfef1fff]=
=0D
[    1.512007] pci 0000:42:02.0: reg 18 io port: [0x3000-0x30ff]=0D
[    1.516009] pci 0000:42:02.0: reg 1c 64bit mmio: [0xdfe80000-0xdfebffff]=
=0D
[    1.520009] pci 0000:42:02.0: reg 30 32bit mmio: [0x000000-0x03ffff]=0D
[    1.524015] pci 0000:42:02.0: supports D1=0D
[    1.528027] pci 0000:40:11.0: bridge io port: [0x3000-0x3fff]=0D
[    1.532006] pci 0000:40:11.0: bridge 32bit mmio: [0xdfe00000-0xdfefffff]=
=0D
[    1.536022] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.BRGA._PRT]=0D
[    1.540070] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.BRGB._PRT]=0D
[    1.544161] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE0._PRT]=0D
[    1.548116] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE1._PRT]=0D
[    1.552112] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE2._PRT]=0D
[    1.556111] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE3._PRT]=0D
[    1.560238] ACPI: PCI Interrupt Link [LNKW] (IRQs 16) *0, disabled.=0D
[    1.566832] ACPI: PCI Interrupt Link [LNKX] (IRQs 17) *0, disabled.=0D
[    1.570622] ACPI: PCI Interrupt Link [LNKY] (IRQs 18) *0, disabled.=0D
[    1.575267] ACPI: PCI Interrupt Link [LNKZ] (IRQs 19) *0, disabled.=0D
[    1.578851] ACPI: PCI Interrupt Link [LNU0] (IRQs 22) *5=0D
[    1.582271] ACPI: PCI Interrupt Link [LNU2] (IRQs 23) *11=0D
[    1.584571] ACPI: PCI Interrupt Link [LNKA] (IRQs 54) *0, disabled.=0D
[    1.592869] ACPI: PCI Interrupt Link [LNKB] (IRQs 55) *0, disabled.=0D
[    1.600881] ACPI: PCI Interrupt Link [LNKC] (IRQs 56) *0, disabled.=0D
[    1.608885] ACPI: PCI Interrupt Link [LNKD] (IRQs 57) *0, disabled.=0D
[    1.616736] usbcore: registered new interface driver usbfs=0D
[    1.620026] usbcore: registered new interface driver hub=0D
[    1.624022] usbcore: registered new device driver usb=0D
[    1.628024] PCI: Using ACPI for IRQ routing=0D
[    1.632125] Expanded resource reserved due to conflict with PCI Bus #00=
=0D
[    1.636005] Expanded resource reserved due to conflict with PCI Bus #00=
=0D
[    1.652117] PCI-DMA: Disabling AGP.=0D
[    1.656125] PCI-DMA: aperture base @ 20000000 size 65536 KB=0D
[    1.660006] PCI-DMA: using GART IOMMU.=0D
[    1.664007] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture=0D
[    1.668708] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31=0D
[    1.678342] hpet0: 3 comparators, 32-bit 25.000000 MHz counter=0D
[    1.700014] Switched to high resolution mode on CPU 0=0D
[    1.700509] Switched to high resolution mode on CPU 4=0D
[    1.700590] Switched to high resolution mode on CPU 2=0D
[    1.700595] Switched to high resolution mode on CPU 6=0D
[    1.700614] Switched to high resolution mode on CPU 1=0D
[    1.700622] Switched to high resolution mode on CPU 5=0D
[    1.700728] Switched to high resolution mode on CPU 3=0D
[    1.700734] Switched to high resolution mode on CPU 7=0D
[    1.940009] pnp: PnP ACPI init=0D
[    1.957524] ACPI: bus type pnp registered=0D
[    1.967669] pnp: PnP ACPI: found 16 devices=0D
[    1.990145] ACPI: ACPI bus type pnp unregistered=0D
[    2.017455] system 00:01: ioport range 0x408-0x40f has been reserved=0D
[    2.046150] system 00:01: ioport range 0x4d0-0x4d1 has been reserved=0D
[    2.083139] system 00:01: ioport range 0x700-0x73f has been reserved=0D
[    2.086009] system 00:01: ioport range 0x800-0x8fe has been reserved=0D
[    2.110157] system 00:01: ioport range 0x900-0x9fe has been reserved=0D
[    2.124136] system 00:01: ioport range 0x9ff-0x9ff has been reserved=0D
[    2.149160] system 00:01: ioport range 0xa00-0xafe has been reserved=0D
[    2.186185] system 00:01: ioport range 0xaff-0xaff has been reserved=0D
[    2.212150] system 00:01: ioport range 0xb00-0xbfe has been reserved=0D
[    2.249156] system 00:01: ioport range 0xbff-0xbff has been reserved=0D
[    2.275152] system 00:01: ioport range 0xc80-0xc83 has been reserved=0D
[    2.311161] system 00:01: ioport range 0xcd4-0xcd7 has been reserved=0D
[    2.347167] system 00:01: ioport range 0xcf9-0xcf9 could not be reserved=
=0D
[    2.375057] system 00:01: ioport range 0xf50-0xf58 has been reserved=0D
[    2.411166] system 00:01: ioport range 0xca0-0xca1 has been reserved=0D
[    2.425452] system 00:01: ioport range 0xca4-0xca5 has been reserved=0D
[    2.443744] system 00:01: ioport range 0xc00-0xc03 has been reserved=0D
[    2.464192] system 00:01: ioport range 0x2f8-0x2ff has been reserved=0D
[    2.506582] pci 0000:00:09.0: PCI bridge, secondary bus 0000:01=0D
[    2.539152] pci 0000:00:09.0:   IO window: 0x1000-0x2fff=0D
[    2.570472] pci 0000:00:09.0:   MEM window: 0xd9d00000-0xd9efffff=0D
[    2.574146] pci 0000:00:09.0:   PREFETCH window: 0x000000d0000000-0x0000=
00d7ffffff=0D
[    2.618165] pci 0000:00:0c.0: PCI bridge, secondary bus 0000:08=0D
[    2.641147] pci 0000:00:0c.0:   IO window: disabled=0D
[    2.669373] pci 0000:00:0c.0:   MEM window: disabled=0D
[    2.698239] pci 0000:00:0c.0:   PREFETCH window: disabled=0D
[    2.700685] pci 0000:00:0d.0: PCI bridge, secondary bus 0000:05=0D
[    2.729181] pci 0000:00:0d.0:   IO window: disabled=0D
[    2.757167] pci 0000:00:0d.0:   MEM window: disabled=0D
[    2.786181] pci 0000:00:0d.0:   PREFETCH window: disabled=0D
[    2.788628] pci 0000:00:0e.0: PCI bridge, secondary bus 0000:02=0D
[    2.791277] pci 0000:00:0e.0:   IO window: disabled=0D
[    2.809490] pci 0000:00:0e.0:   MEM window: disabled=0D
[    2.838163] pci 0000:00:0e.0:   PREFETCH window: disabled=0D
[    2.840610] pci 0000:00:09.0: setting latency timer to 64=0D
[    2.843016] pci 0000:00:0c.0: setting latency timer to 64=0D
[    2.873151] pci 0000:00:0d.0: setting latency timer to 64=0D
[    2.881135] pci 0000:00:0e.0: setting latency timer to 64=0D
[    2.912200] pci 0000:40:0b.0: PCI bridge, secondary bus 0000:4f=0D
[    2.946172] pci 0000:40:0b.0:   IO window: disabled=0D
[    2.963206] pci 0000:40:0b.0:   MEM window: disabled=0D
[    2.981201] pci 0000:40:0b.0:   PREFETCH window: disabled=0D
[    2.983638] pci 0000:40:0c.0: PCI bridge, secondary bus 0000:4c=0D
[    3.012182] pci 0000:40:0c.0:   IO window: disabled=0D
[    3.039516] pci 0000:40:0c.0:   MEM window: disabled=0D
[    3.047943] pci 0000:40:0c.0:   PREFETCH window: disabled=0D
[    3.077157] pci 0000:40:0d.0: PCI bridge, secondary bus 0000:49=0D
[    3.079815] pci 0000:40:0d.0:   IO window: disabled=0D
[    3.104195] pci 0000:40:0d.0:   MEM window: disabled=0D
[    3.130465] pci 0000:40:0d.0:   PREFETCH window: disabled=0D
[    3.153179] pci 0000:40:0e.0: PCI bridge, secondary bus 0000:46=0D
[    3.187165] pci 0000:40:0e.0:   IO window: disabled=0D
[    3.215256] pci 0000:40:0e.0:   MEM window: disabled=0D
[    3.244170] pci 0000:40:0e.0:   PREFETCH window: disabled=0D
[    3.274221] pci 0000:40:10.0: PCI bridge, secondary bus 0000:41=0D
[    3.308178] pci 0000:40:10.0:   IO window: disabled=0D
[    3.336189] pci 0000:40:10.0:   MEM window: 0xda000000-0xddffffff=0D
[    3.371211] pci 0000:40:10.0:   PREFETCH window: 0x000000d9f00000-0x0000=
00d9ffffff=0D
[    3.415171] pci 0000:40:11.0: PCI bridge, secondary bus 0000:42=0D
[    3.418746] pci 0000:40:11.0:   IO window: 0x3000-0x3fff=0D
[    3.421189] pci 0000:40:11.0:   MEM window: 0xdfe00000-0xdfefffff=0D
[    3.445169] pci 0000:40:11.0:   PREFETCH window: 0x000000de000000-0x0000=
00de0fffff=0D
[    3.468981] pci 0000:40:0b.0: setting latency timer to 64=0D
[    3.498222] pci 0000:40:0c.0: setting latency timer to 64=0D
[    3.500669] pci 0000:40:0d.0: setting latency timer to 64=0D
[    3.526170] pci 0000:40:0e.0: setting latency timer to 64=0D
[    3.546183] pci_bus 0000:00: resource 0 io:  [0x00-0x2fff]=0D
[    3.566494] pci_bus 0000:00: resource 1 mem: [0x80000000-0xd9efffff]=0D
[    3.603196] pci_bus 0000:00: resource 2 mem: [0xdff00000-0xe3ffffff]=0D
[    3.628197] pci_bus 0000:00: resource 3 mem: [0x0a0000-0x0bffff]=0D
[    3.651265] pci_bus 0000:00: resource 4 mem: [0xe8000000-0xffffffff]=0D
[    3.670843] pci_bus 0000:00: resource 5 mem: [0x480000000-0xfcffffffff]=
=0D
[    3.673813] pci_bus 0000:01: resource 0 io:  [0x1000-0x2fff]=0D
[    3.676354] pci_bus 0000:01: resource 1 mem: [0xd9d00000-0xd9efffff]=0D
[    3.703416] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xd7ffffff]=
=0D
[    3.742370] pci_bus 0000:01: resource 3 io:  [0x00-0x2fff]=0D
[    3.753214] pci_bus 0000:01: resource 4 mem: [0x80000000-0xd9efffff]=0D
[    3.779205] pci_bus 0000:01: resource 5 mem: [0xdff00000-0xe3ffffff]=0D
[    3.815204] pci_bus 0000:01: resource 6 mem: [0x0a0000-0x0bffff]=0D
[    3.827199] pci_bus 0000:01: resource 7 mem: [0xe8000000-0xffffffff]=0D
[    3.853497] pci_bus 0000:01: resource 8 mem: [0x480000000-0xfcffffffff]=
=0D
[    3.884189] pci_bus 0000:40: resource 0 io:  [0x3000-0xffff]=0D
[    3.905203] pci_bus 0000:40: resource 1 mem: [0xd9f00000-0xdfefffff]=0D
[    3.913677] pci_bus 0000:40: resource 2 mem: [0xe4000000-0xe7ffffff]=0D
[    3.934225] pci_bus 0000:41: resource 1 mem: [0xda000000-0xddffffff]=0D
[    3.971546] pci_bus 0000:41: resource 2 pref mem [0xd9f00000-0xd9ffffff]=
=0D
[    3.974579] pci_bus 0000:42: resource 0 io:  [0x3000-0x3fff]=0D
[    4.000243] pci_bus 0000:42: resource 1 mem: [0xdfe00000-0xdfefffff]=0D
[    4.037538] pci_bus 0000:42: resource 2 pref mem [0xde000000-0xde0fffff]=
=0D
[    4.040775] NET: Registered protocol family 2=0D
[    4.116540] IP route cache hash table entries: 524288 (order: 10, 419430=
4 bytes)=0D
[    4.162713] TCP established hash table entries: 524288 (order: 11, 83886=
08 bytes)=0D
[    4.200152] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)=
=0D
[    4.239278] TCP: Hash tables configured (established 524288 bind 65536)=
=0D
[    4.276228] TCP reno registered=0D
[    4.312283] NET: Registered protocol family 1=0D
[    4.336325] Trying to unpack rootfs image as initramfs...=0D
[    4.624886] Freeing initrd memory: 8969k freed=0D
[    4.657805] audit: initializing netlink socket (disabled)=0D
[    4.687272] type=3D2000 audit(1246278158.687:1): initialized=0D
[    4.720954] HugeTLB registered 2 MB page size, pre-allocated 0 pages=0D
[    4.756685] VFS: Disk quotas dquot_6.5.2=0D
[    4.778321] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)=0D
[    4.814913] msgmni has been set to 32173=0D
[    4.837641] alg: No test for stdrng (krng)=0D
[    4.860377] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)=0D
[    4.892210] io scheduler noop registered=0D
[    4.893971] io scheduler anticipatory registered=0D
[    4.896038] io scheduler deadline registered=0D
[    4.919312] io scheduler cfq registered (default)=0D
[    4.976024] pci 0000:00:0c.0: Found enabled HT MSI Mapping=0D
[    5.007663] pci 0000:00:0d.0: Found enabled HT MSI Mapping=0D
[    5.021253] pci 0000:00:0e.0: Found enabled HT MSI Mapping=0D
[    5.027515] pci 0000:01:03.0: Boot video device=0D
[    5.052257] pci 0000:01:04.4: HCRESET not completed yet!=0D
[    5.083283] pci 0000:40:0b.0: Found enabled HT MSI Mapping=0D
[    5.114281] pci 0000:40:0c.0: Found enabled HT MSI Mapping=0D
[    5.145240] pci 0000:40:0d.0: Found enabled HT MSI Mapping=0D
[    5.165247] pci 0000:40:0e.0: Found enabled HT MSI Mapping=0D
[    5.197482]   alloc irq_desc for 62 on cpu 0 node 0=0D
[    5.201454]   alloc kstat_irqs on cpu 0 node 0=0D
[    5.228248] pcieport-driver 0000:00:0c.0: irq 62 for MSI/MSI-X=0D
[    5.251251] pcieport-driver 0000:00:0c.0: setting latency timer to 64=0D
[    5.287406]   alloc irq_desc for 63 on cpu 0 node 0=0D
[    5.291383]   alloc kstat_irqs on cpu 0 node 0=0D
[    5.341232] pcieport-driver 0000:00:0d.0: irq 63 for MSI/MSI-X=0D
[    5.352289] pcieport-driver 0000:00:0d.0: setting latency timer to 64=0D
[    5.367374]   alloc irq_desc for 64 on cpu 0 node 0=0D
[    5.371351]   alloc kstat_irqs on cpu 0 node 0=0D
[    5.420258] pcieport-driver 0000:00:0e.0: irq 64 for MSI/MSI-X=0D
[    5.443244] pcieport-driver 0000:00:0e.0: setting latency timer to 64=0D
[    5.469462]   alloc irq_desc for 65 on cpu 0 node 0=0D
[    5.473414]   alloc kstat_irqs on cpu 0 node 0=0D
[    5.523272] pcieport-driver 0000:40:0b.0: irq 65 for MSI/MSI-X=0D
[    5.546260] pcieport-driver 0000:40:0b.0: setting latency timer to 64=0D
[    5.580680]   alloc irq_desc for 66 on cpu 0 node 0=0D
[    5.584652]   alloc kstat_irqs on cpu 0 node 0=0D
[    5.633290] pcieport-driver 0000:40:0c.0: irq 66 for MSI/MSI-X=0D
[    5.635925] pcieport-driver 0000:40:0c.0: setting latency timer to 64=0D
[    5.669437]   alloc irq_desc for 67 on cpu 0 node 0=0D
[    5.673408]   alloc kstat_irqs on cpu 0 node 0=0D
[    5.723247] pcieport-driver 0000:40:0d.0: irq 67 for MSI/MSI-X=0D
[    5.745270] pcieport-driver 0000:40:0d.0: setting latency timer to 64=0D
[    5.782390]   alloc irq_desc for 68 on cpu 0 node 0=0D
[    5.786362]   alloc kstat_irqs on cpu 0 node 0=0D
[    5.836269] pcieport-driver 0000:40:0e.0: irq 68 for MSI/MSI-X=0D
[    5.859301] pcieport-driver 0000:40:0e.0: setting latency timer to 64=0D
[    5.891293] Linux agpgart interface v0.103=0D
[    5.914267] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled=0D
[    5.927833] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A=0D
[    5.962398] serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A=0D
[    5.996727] 00:09: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A=0D
[    6.029795] brd: module loaded=0D
[    6.046372] input: Macintosh mouse button emulation as /devices/virtual/=
input/input0=0D
[    6.090544] PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64=
 irq 1,12=0D
[    6.133907] serio: i8042 KBD port at 0x60,0x64 irq 1=0D
[    6.161286] serio: i8042 AUX port at 0x60,0x64 irq 12=0D
[    6.189546] mice: PS/2 mouse device common for all mice=0D
[    6.219412] rtc_cmos 00:0a: RTC can wake from S4=0D
[    6.246395] rtc_cmos 00:0a: rtc core: registered rtc_cmos as rtc0=0D
[    6.280302] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs=
=0D
[    6.319331] cpuidle: using governor ladder=0D
[    6.342304] cpuidle: using governor menu=0D
[    6.344081] No iBFT detected.=0D
[    6.359679] TCP cubic registered=0D
[    6.378510] NET: Registered protocol family 10=0D
[    6.403987] lo: Disabled Privacy Extensions=0D
[    6.415737] Mobile IPv6=0D
[    6.429491] NET: Registered protocol family 17=0D
[    6.455522] registered taskstats version 1=0D
[    6.478963] rtc_cmos 00:0a: setting system clock to 2009-06-29 12:22:45 =
UTC (1246278165)=0D
[    6.524723] Freeing unused kernel memory: 560k freed=0D
[    6.552719] Write protecting the kernel read-only data: 3792k=0D
Loading, please wait...=0D
[    6.714798] Uniform Multi-Platform E-IDE driver=0D
[    6.716253] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver=0D
[    6.718659] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver=0D
[    6.807693] ACPI: PCI Interrupt Link [LNU2] enabled at IRQ 23=0D
[    6.839316]   alloc irq_desc for 23 on cpu 0 node 0=0D
[    6.843279]   alloc kstat_irqs on cpu 0 node 0=0D
[    6.893319] ehci_hcd 0000:00:02.1: PCI INT B -> Link[LNU2] -> GSI 23 (le=
vel, high) -> IRQ 23=0D
[    6.897178] ehci_hcd 0000:00:02.1: setting latency timer to 64=0D
[    6.913406] Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v2.0.1 (M=
ay 6, 2009)=0D
[    6.913439]   alloc irq_desc for 31 on cpu 0 node 0=0D
[    6.913442]   alloc kstat_irqs on cpu 0 node 0=0D
[    6.913458] bnx2 0000:41:01.0: PCI INT A -> GSI 31 (level, low) -> IRQ 3=
1=0D
[    7.060694] ehci_hcd 0000:00:02.1: EHCI Host Controller=0D
[    7.063192] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus =
number 1=0D
[    7.063307] SCSI subsystem initialized=0D
[    7.107049] ehci_hcd 0000:00:02.1: debug port 1=0D
[    7.131294] ehci_hcd 0000:00:02.1: cache line size of 64 is not supporte=
d=0D
[    7.170326] ehci_hcd 0000:00:02.1: irq 23, io mem 0xd9cd0000=0D
[    7.205670] HP CISS Driver (v 3.6.20)=0D
[    7.216011] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00=0D
[    7.216038] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002=0D
[    7.216040] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1=0D
[    7.216042] usb usb1: Product: EHCI Host Controller=0D
[    7.216043] usb usb1: Manufacturer: Linux 2.6.30-1-amd64 ehci_hcd=0D
[    7.216045] usb usb1: SerialNumber: 0000:00:02.1=0D
[    7.216115] usb usb1: configuration #1 chosen from 1 choice=0D
[    7.216143] hub 1-0:1.0: USB hub found=0D
[    7.216152] hub 1-0:1.0: 10 ports detected=0D
[    7.416946] ACPI: PCI Interrupt Link [LNU0] enabled at IRQ 22=0D
[    7.417379]   alloc irq_desc for 26 on cpu 0 node 0=0D
[    7.417383]   alloc kstat_irqs on cpu 0 node 0=0D
[    7.417397] cciss 0000:42:02.0: PCI INT A -> GSI 26 (level, low) -> IRQ =
26=0D
[    7.532512]   alloc irq_desc for 22 on cpu 0 node 0=0D
[    7.534343] uhci_hcd: USB Universal Host Controller Interface driver=0D
[    7.584509]   alloc kstat_irqs on cpu 0 node 0=0D
[    7.612264] IRQ 26/cciss0: IRQF_DISABLED is not guaranteed on shared IRQ=
s=0D
[    7.612288] cciss0: <0x3220> at PCI 0000:42:02.0 IRQ 26 using DAC=0D
[    7.645263] usb 1-6: new high speed USB device using ehci_hcd and addres=
s 3=0D
[    7.716471] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNU0] -> GSI 22 (le=
vel, high) -> IRQ 22=0D
[    7.765763] ohci_hcd 0000:00:02.0: setting latency timer to 64=0D
[    7.774088] usb 1-6: New USB device found, idVendor=3D04b4, idProduct=3D=
6560=0D
[    7.774091] usb 1-6: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0=0D
[    7.774188] usb 1-6: configuration #1 chosen from 1 choice=0D
[    7.774358] hub 1-6:1.0: USB hub found=0D
[    7.774454] hub 1-6:1.0: 4 ports detected=0D
[    7.899333] ohci_hcd 0000:00:02.0: OHCI Host Controller=0D
[    7.929391] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus =
number 2=0D
[    7.932286] bnx2 0000:41:01.0: firmware: requesting bnx2/bnx2-mips-06-4.=
6.16.fw=0D
[    7.937068] bnx2 0000:41:01.0: firmware: requesting bnx2/bnx2-rv2p-06-4.=
6.16.fw=0D
[    7.941190] eth0: Broadcom NetXtreme II BCM5706 1000Base-T (A2) PCI-X 64=
-bit 100MHz found at mem dc000000, IRQ 31, node addr 00:1c:c4:f0:94:fa=0D
[    7.941290]   alloc irq_desc for 32 on cpu 0 node 0=0D
[    7.941292]   alloc kstat_irqs on cpu 0 node 0=0D
[    7.941302] bnx2 0000:41:02.0: PCI INT A -> GSI 32 (level, low) -> IRQ 3=
2=0D
[    8.154356] ohci_hcd 0000:00:02.0: irq 22, io mem 0xd9ce0000=0D
[    8.164594] ACPI: PCI Interrupt Link [LNKX] enabled at IRQ 17=0D
[    8.196362]   alloc irq_desc for 17 on cpu 0 node 0=0D
[    8.200350]   alloc kstat_irqs on cpu 0 node 0=0D
[    8.250368] uhci_hcd 0000:01:04.4: PCI INT B -> Link[LNKX] -> GSI 17 (le=
vel, high) -> IRQ 17=0D
[    8.276389] uhci_hcd 0000:01:04.4: UHCI Host Controller=0D
[    8.306431] uhci_hcd 0000:01:04.4: new USB bus registered, assigned bus =
number 3=0D
[    8.349350] uhci_hcd 0000:01:04.4: port count misdetected? forcing to 2 =
ports=0D
[    8.356320] uhci_hcd 0000:01:04.4: HCRESET not completed yet!=0D
[    8.388361] uhci_hcd 0000:01:04.4: irq 17, io base 0x00001800=0D
[    8.421398] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001=0D
[    8.460435] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1=0D
[    8.502322] usb usb3: Product: UHCI Host Controller=0D
[    8.508363] usb usb3: Manufacturer: Linux 2.6.30-1-amd64 uhci_hcd=0D
[    8.543335] usb usb3: SerialNumber: 0000:01:04.4=0D
[    8.570386] usb usb3: configuration #1 chosen from 1 choice=0D
[    8.601398] hub 3-0:1.0: USB hub found=0D
[    8.603183] hub 3-0:1.0: 2 ports detected=0D
[    8.607130] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001=0D
[    8.625375] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1=0D
[    8.636264] bnx2 0000:41:02.0: firmware: requesting bnx2/bnx2-mips-06-4.=
6.16.fw=0D
[    8.641072] bnx2 0000:41:02.0: firmware: requesting bnx2/bnx2-rv2p-06-4.=
6.16.fw=0D
[    8.645176] eth1: Broadcom NetXtreme II BCM5706 1000Base-T (A2) PCI-X 64=
-bit 100MHz found at mem da000000, IRQ 32, node addr 00:1c:c4:f0:94:fc=0D
[    8.805389] usb usb2: Product: OHCI Host Controller=0D
[    8.812333] usb usb2: Manufacturer: Linux 2.6.30-1-amd64 ohci_hcd=0D
[    8.847786] usb usb2: SerialNumber: 0000:00:02.0=0D
[    8.874426] usb usb2: configuration #1 chosen from 1 choice=0D
[    8.877051] hub 2-0:1.0: USB hub found=0D
[    8.886360] hub 2-0:1.0: 10 ports detected=0D
[    8.910980] amd74xx 0000:00:06.0: UDMA133 controller=0D
[    8.938379] amd74xx 0000:00:06.0: IDE controller (0x10de:0x0053 rev 0xa3=
)=0D
[    8.960110] amd74xx 0000:00:06.0: IDE port disabled=0D
[    8.985450] amd74xx 0000:00:06.0: not 100% native mode: will probe irqs =
later=0D
[    9.026428]     ide0: BM-DMA at 0x0500-0x0507=0D
[    9.051405] Probing IDE interface ide0...=0D
[    9.192017] usb 3-1: new full speed USB device using uhci_hcd and addres=
s 2=0D
[    9.375201] usb 3-1: New USB device found, idVendor=3D03f0, idProduct=3D=
1027=0D
[    9.413398] usb 3-1: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0=0D
[    9.422346] usb 3-1: Product: Virtual Keyboard=0D
[    9.437788] usb 3-1: Manufacturer: HP=0D
[    9.442454] usb 3-1: configuration #1 chosen from 1 choice=0D
[    9.486596] usbcore: registered new interface driver hiddev=0D
[    9.521509] input: HP Virtual Keyboard as /devices/pci0000:00/0000:00:09=
=2E0/0000:01:04.4/usb3/3-1/3-1:1.0/input/input1=0D
[    9.561484] generic-usb 0003:03F0:1027.0001: input,hidraw0: USB HID v1.0=
1 Keyboard [HP Virtual Keyboard] on usb-0000:01:04.4-1/input0=0D
[    9.591571] input: HP Virtual Keyboard as /devices/pci0000:00/0000:00:09=
=2E0/0000:01:04.4/usb3/3-1/3-1:1.1/input/input2=0D
[    9.621540] generic-usb 0003:03F0:1027.0002: input,hidraw1: USB HID v1.0=
1 Mouse [HP Virtual Keyboard] on usb-0000:01:04.4-1/input1=0D
[    9.648886] usbcore: registered new interface driver usbhid=0D
[    9.680681] usbhid: v2.6:USB HID core driver=0D
[    9.796016] usb 3-2: new full speed USB device using uhci_hcd and addres=
s 3=0D
[    9.812130] hda: HL-DT-ST DVDRAM GSA-T20L, ATAPI CD/DVD-ROM drive=0D
[   10.007035] usb 3-2: New USB device found, idVendor=3D03f0, idProduct=3D=
1327=0D
[   10.044421] usb 3-2: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0=0D
[   10.066465] usb 3-2: Product: Virtual Hub=0D
[   10.068375] usb 3-2: Manufacturer: HP=0D
[   10.070200] usb 3-2: configuration #1 chosen from 1 choice=0D
[   10.105448] hub 3-2:1.0: USB hub found=0D
[   10.128174] hub 3-2:1.0: 7 ports detected=0D
[   10.148060] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4=0D
[   10.148839] hda: UDMA/33 mode selected=0D
[   10.149279] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14=0D
[   10.163218] libata version 3.00 loaded.=0D
[   10.170479] ide-cd driver 5.00=0D
[   10.172036] ide-cd: hda: ATAPI 24X DVD-ROM DVD-R/RAM CD-R/RW drive, 2048=
kB Cache=0D
[   10.172041] Uniform CD-ROM driver Revision: 3.20=0D
[   10.464011] usb 2-3: new low speed USB device using ohci_hcd and address=
 2=0D
[   10.720152] usb 2-3: New USB device found, idVendor=3D0624, idProduct=3D=
0341=0D
[   10.747414] usb 2-3: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0=0D
[   10.774710] usb 2-3: Product: HP 336047-B21=0D
[   10.791406] usb 2-3: Manufacturer: Avocent=0D
[   10.793456] usb 2-3: configuration #1 chosen from 1 choice=0D
[   10.842417] input: Avocent HP 336047-B21 as /devices/pci0000:00/0000:00:=
02.0/usb2/2-3/2-3:1.0/input/input3=0D
[   10.882848] generic-usb 0003:0624:0341.0003: input,hidraw2: USB HID v1.1=
0 Keyboard [Avocent HP 336047-B21] on usb-0000:00:02.0-3/input0=0D
[   10.948470] input: Avocent HP 336047-B21 as /devices/pci0000:00/0000:00:=
02.0/usb2/2-3/2-3:1.1/input/input4=0D
[   11.003649] generic-usb 0003:0624:0341.0004: input,hidraw3: USB HID v1.1=
0 Mouse [Avocent HP 336047-B21] on usb-0000:00:02.0-3/input1=0D
[   20.501306] uhci_hcd 0000:01:04.4: HCRESET not completed yet!=0D
[   20.533029] Restarting system.=0D
[   20.550720] machine restart=0D

--AaroDtM9M79Ffl67--

--p19/OaUkOQckSefz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpIwDYACgkQrzgMPqB3kijM9ACfQMfjH6ZpsmOtdCyMFatLnj+M
XXcAnicFINzBH+tcxjkAs0mw7GLxwtzP
=O32U
-----END PGP SIGNATURE-----

--p19/OaUkOQckSefz--
