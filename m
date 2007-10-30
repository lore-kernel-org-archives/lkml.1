Return-Path: <linux-kernel-owner+w=401wt.eu-S1753525AbXJ3A1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbXJ3A1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 20:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbXJ3A1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 20:27:44 -0400
Received: from 170.Red-213-96-222.staticIP.rima-tde.net ([213.96.222.170]:43587
	"EHLO smtp.ferdyx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbXJ3A1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 20:27:41 -0400
Date: Tue, 30 Oct 2007 00:27:27 +0000
From: Ciaran McCreesh <ciaran.mccreesh@blueyonder.co.uk>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Edward Hsu <edward_hsu@realtek.com.tw>
Subject: Re: Abit F-190HD Onboard rlt8169 Ethernet Controller
Message-ID: <20071030002727.279fb508@snowcone>
In-Reply-To: <20071029120007.GA8571@electric-eye.fr.zoreil.com>
References: <20071029061532.5d10dfc6@snowcone>
	<20071029083333.18a4dab7@the-village.bc.nu>
	<47259CFB.2090106@garzik.org>
	<20071029120007.GA8571@electric-eye.fr.zoreil.com>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_ncl/1.wfmKTavi2c3quKoRd"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_ncl/1.wfmKTavi2c3quKoRd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, 29 Oct 2007 13:00:07 +0100
Francois Romieu <romieu@fr.zoreil.com> wrote:
> Jeff Garzik <jeff@garzik.org> :
> [...]
> > Regardless, I agree with your "you...have a return candidate"
> > comment.
> 
> I would welcome a complete lspci -vxx + dmesg before the board is
> eventually returned though.

Attached.

Cheers,
-- 
Ciaran McCreesh
--MP_ncl/1.wfmKTavi2c3quKoRd
Content-Type: text/plain; name=dmesg.txt
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=dmesg.txt

[    0.000000] Linux version 2.6.24-rc1 (ciaranm@snowcone) (gcc version 4.1=
.2 (Gentoo 4.1.2 p1.0.2)) #4 SMP Mon Oct 29 05:54:50 GMT 2007
[    0.000000] Command line: root=3D/dev/sda1
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cfff0000 (usable)
[    0.000000]  BIOS-e820: 00000000cfff0000 - 00000000cfff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfff3000 - 00000000d0000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851952) 1 entries of 256 u=
sed
[    0.000000] Entering add_active_range(0, 1048576, 1179648) 2 entries of =
256 used
[    0.000000] end_pfn_map =3D 1179648
[    0.000000] DMI 2.5 present.
[    0.000000] ACPI: RSDP 000F7C70, 0014 (r0 RS600 )
[    0.000000] ACPI: RSDT CFFF3000, 0038 (r1 RS600  AWRDACPI 42302E31 AWRD =
       0)
[    0.000000] ACPI: FACP CFFF3080, 0074 (r1 RS600  AWRDACPI 42302E31 AWRD =
       0)
[    0.000000] ACPI: DSDT CFFF3100, 5144 (r1 RS600  AWRDACPI     1000 MSFT =
 3000000)
[    0.000000] ACPI: FACS CFFF0000, 0040
[    0.000000] ACPI: HPET CFFF8340, 0038 (r1 RS600  AWRDACPI 42302E31 AWRD =
      98)
[    0.000000] ACPI: MCFG CFFF8380, 003C (r1 RS600  AWRDACPI 42302E31 AWRD =
       0)
[    0.000000] ACPI: APIC CFFF8280, 0084 (r1 RS600  AWRDACPI 42302E31 AWRD =
       0)
[    0.000000] ACPI: SSDT CFFF8CE0, 0380 (r1  PmRef    CpuPm     3000 INTL =
20040311)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851952) 1 entries of 256 u=
sed
[    0.000000] Entering add_active_range(0, 1048576, 1179648) 2 entries of =
256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1179648
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   851952
[    0.000000]     0:  1048576 ->  1179648
[    0.000000] On node 0 totalpages: 982927
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1451 pages reserved
[    0.000000]   DMA zone: 2492 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833576 pages, LIFO batch:31
[    0.000000]   Normal zone: 1792 pages used for memmap
[    0.000000]   Normal zone: 129280 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ATI board detected. Disabling timer routing over 8254.
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x03] enabled)
[    0.000000] Processor #3
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] Processor #2
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at d1000000 (gap: d0000000=
:10000000)
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 29360 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 965348
[    0.000000] Kernel command line: root=3D/dev/sda1
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] hpet clockevent registered
[    0.000000] TSC calibrated against HPET
[   27.688181] time.c: Detected 2392.020 MHz processor.
[   27.688949] Console: colour VGA+ 80x25
[   27.688953] console [tty0] enabled
[   27.694701] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[   27.697973] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[   27.698287] Checking aperture...
[   27.698339] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[   27.759632] Placing software IO TLB between 0x5586000 - 0x9586000
[   27.806069] Memory: 3788520k/4718592k available (3362k kernel code, 1428=
92k reserved, 1478k data, 260k init)
[   27.888126] Calibrating delay using timer specific routine.. 4788.32 Bog=
oMIPS (lpj=3D7978121)
[   27.888255] Mount-cache hash table entries: 256
[   27.888423] CPU: L1 I cache: 32K, L1 D cache: 32K
[   27.888493] CPU: L2 cache: 4096K
[   27.888533] using mwait in idle threads.
[   27.888574] CPU: Physical Processor ID: 0
[   27.888614] CPU: Processor Core ID: 0
[   27.888657] CPU0: Thermal monitoring enabled (TM1)
[   27.888708] SMP alternatives: switching to UP code
[   27.889524] ACPI: Core revision 20070126
[   28.123455] Using local APIC timer interrupts.
[   28.165294] APIC timer calibration result 16611251
[   28.165295] Detected 16.611 MHz APIC timer.
[   28.165418] SMP alternatives: switching to SMP code
[   28.165924] Booting processor 1/4 APIC 0x1
[   28.178137] Initializing CPU#1
[   28.258651] Calibrating delay using timer specific routine.. 4785.34 Bog=
oMIPS (lpj=3D7973345)
[   28.258656] CPU: L1 I cache: 32K, L1 D cache: 32K
[   28.258657] CPU: L2 cache: 4096K
[   28.258659] CPU: Physical Processor ID: 0
[   28.258660] CPU: Processor Core ID: 1
[   28.258665] CPU1: Thermal monitoring enabled (TM2)
[   28.259089] Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[   28.259160] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[   28.279630] SMP alternatives: switching to SMP code
[   28.280375] Booting processor 2/4 APIC 0x3
[   28.290767] Initializing CPU#2
[   28.371959] Calibrating delay using timer specific routine.. 4785.37 Bog=
oMIPS (lpj=3D7973400)
[   28.371964] CPU: L1 I cache: 32K, L1 D cache: 32K
[   28.371966] CPU: L2 cache: 4096K
[   28.371967] CPU: Physical Processor ID: 0
[   28.371968] CPU: Processor Core ID: 3
[   28.371973] CPU2: Thermal monitoring enabled (TM2)
[   28.372398] Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[   28.372411] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[   28.392860] SMP alternatives: switching to SMP code
[   28.393358] Booting processor 3/4 APIC 0x2
[   28.403751] Initializing CPU#3
[   28.485267] Calibrating delay using timer specific routine.. 4785.38 Bog=
oMIPS (lpj=3D7973412)
[   28.485272] CPU: L1 I cache: 32K, L1 D cache: 32K
[   28.485273] CPU: L2 cache: 4096K
[   28.485275] CPU: Physical Processor ID: 0
[   28.485276] CPU: Processor Core ID: 2
[   28.485281] CPU3: Thermal monitoring enabled (TM2)
[   28.485706] Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[   28.485793] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[   28.506185] Brought up 4 CPUs
[   28.506427] net_namespace: 120 bytes
[   28.506769] NET: Registered protocol family 16
[   28.506935] ACPI: bus type pci registered
[   28.511745] PCI: Using MMCONFIG at e0000000 - efffffff
[   28.514122] ACPI: EC: Look up EC in DSDT
[   28.518840] ACPI: Interpreter enabled
[   28.518892] ACPI: (supports S0 S3 S5)
[   28.519025] ACPI: Using IOAPIC for interrupt routing
[   28.522728] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   28.523647] PCI: Transparent bridge - 0000:00:14.4
[   28.523710] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   28.523915] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[   28.524002] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE4._PRT]
[   28.524076] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[   28.540709] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, d=
isabled.
[   28.541160] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, d=
isabled.
[   28.541609] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, d=
isabled.
[   28.542061] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, d=
isabled.
[   28.542510] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, d=
isabled.
[   28.542959] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, d=
isabled.
[   28.543408] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, d=
isabled.
[   28.543896] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, d=
isabled.
[   28.544365] Linux Plug and Play Support v0.97 (c) Adam Belay
[   28.544425] pnp: PnP ACPI init
[   28.544469] ACPI: bus type pnp registered
[   28.546338] pnp: PnP ACPI: found 10 devices
[   28.546379] ACPI: ACPI bus type pnp unregistered
[   28.546607] SCSI subsystem initialized
[   28.546711] libata version 3.00 loaded.
[   28.546779] usbcore: registered new interface driver usbfs
[   28.546859] usbcore: registered new interface driver hub
[   28.546947] usbcore: registered new device driver usb
[   28.547117] PCI: Using ACPI for IRQ routing
[   28.547158] PCI: If a device doesn't work, try "pci=3Drouteirq".  If it =
helps, post a report
[   28.558748] PCI-GART: No AMD northbridge found.
[   28.558798] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[   28.558999] hpet0: 4 32-bit timers, 14318180 Hz
[   28.562069] Time: tsc clocksource has been installed.
[   28.568850] system 00:01: ioport range 0x4100-0x411f has been reserved
[   28.568896] system 00:01: ioport range 0x228-0x22f has been reserved
[   28.568940] system 00:01: ioport range 0x40b-0x40b has been reserved
[   28.568985] system 00:01: ioport range 0x4d6-0x4d6 has been reserved
[   28.569039] system 00:01: ioport range 0xc00-0xc01 has been reserved
[   28.569080] system 00:01: ioport range 0xc14-0xc14 has been reserved
[   28.569122] system 00:01: ioport range 0xc50-0xc52 has been reserved
[   28.569163] system 00:01: ioport range 0xc6c-0xc6d has been reserved
[   28.569210] system 00:08: iomem range 0xe0000000-0xefffffff could not be=
 reserved
[   28.569265] system 00:09: iomem range 0xf0000-0xfffff could not be reser=
ved
[   28.569306] system 00:09: iomem range 0xfed00000-0xfed000ff has been res=
erved
[   28.569348] system 00:09: iomem range 0xcfff0000-0xcfffffff could not be=
 reserved
[   28.569400] system 00:09: iomem range 0xffff0000-0xffffffff has been res=
erved
[   28.569696] PCI: Bridge: 0000:00:01.0
[   28.569737]   IO window: d000-dfff
[   28.569777]   MEM window: fdf00000-fdffffff
[   28.569817]   PREFETCH window: d0000000-dfffffff
[   28.569859] PCI: Bridge: 0000:00:04.0
[   28.569899]   IO window: e000-efff
[   28.570325]   MEM window: fde00000-fdefffff
[   28.570365]   PREFETCH window: fdd00000-fddfffff
[   28.570406] PCI: Bridge: 0000:00:14.4
[   28.570466]   IO window: c000-cfff
[   28.570528]   MEM window: fdc00000-fdcfffff
[   28.570570]   PREFETCH window: fdb00000-fdbfffff
[   28.570620] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   28.570685] NET: Registered protocol family 2
[   28.599218] IP route cache hash table entries: 131072 (order: 8, 1048576=
 bytes)
[   28.599849] TCP established hash table entries: 131072 (order: 9, 314572=
8 bytes)
[   28.601273] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   28.601966] TCP: Hash tables configured (established 131072 bind 65536)
[   28.602008] TCP reno registered
[   28.610793] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet=
.co.uk>
[   28.611888] Total HugeTLB memory allocated, 0
[   28.612257] io scheduler noop registered
[   28.612311] io scheduler deadline registered
[   28.612374] io scheduler cfq registered (default)
[   29.311759] 0000:00:13.1 OHCI: BIOS handoff failed (BIOS bug ?) 00000184
[   29.394246] Boot video device is 0000:01:05.0
[   29.394441] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   29.394453] assign_interrupt_mode Found MSI capability
[   29.394509] Allocate Port Service[0000:00:04.0:pcie00]
[   29.394564] Allocate Port Service[0000:00:04.0:pcie03]
[   29.394997] input: Power Button (FF) as /class/input/input0
[   29.395052] ACPI: Power Button (FF) [PWRF]
[   29.395162] input: Power Button (CM) as /class/input/input1
[   29.395207] ACPI: Power Button (CM) [PWRB]
[   29.395321] ACPI: Fan [FAN] (on)
[   29.395683] ACPI: SSDT CFFF8400, 022A (r1  PmRef  Cpu0Ist     3000 INTL =
20041203)
[   29.395985] ACPI: Processor [CPU0] (supports 8 throttling states)
[   29.396194] ACPI: SSDT CFFF88C0, 0152 (r1  PmRef  Cpu1Ist     3000 INTL =
20041203)
[   29.396414] ACPI: Processor [CPU1] (supports 8 throttling states)
[   29.396622] ACPI: SSDT CFFF8A20, 0152 (r1  PmRef  Cpu2Ist     3000 INTL =
20041203)
[   29.396829] ACPI: Processor [CPU2] (supports 8 throttling states)
[   29.397028] ACPI: SSDT CFFF8B80, 0152 (r1  PmRef  Cpu3Ist     3000 INTL =
20041203)
[   29.397233] ACPI: Processor [CPU3] (supports 8 throttling states)
[   29.801299] ACPI: Thermal Zone [THRM] (44 C)
[   29.854965] Real Time Clock Driver v1.12ac
[   29.855164] hpet_resources: 0xfed00000 is busy
[   29.855197] Linux agpgart interface v0.102
[   29.855247] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sha=
ring disabled
[   29.856689] RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 =
blocksize
[   29.857095] loop: module loaded
[   29.857288] tun: Universal TUN/TAP device driver, 1.6
[   29.857329] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   29.857469] r8169 Gigabit Ethernet driver 2.2LK loaded
[   29.857529] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -=
> IRQ 16
[   29.857619] PCI: Setting latency timer of device 0000:02:00.0 to 64
[   29.857903] eth0: RTL8168b/8111b at 0xffffc20000028000, 00:50:8d:9e:9a:3=
1, XID 38000000 IRQ 382
[   30.534087] console [netcon0] enabled
[   30.543296] netconsole: network logging started
[   30.543338] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   30.543380] ide: Assuming 33MHz system bus speed for PIO modes; override=
 with idebus=3Dxx
[   30.543511] SB600_PATA: IDE controller (0x1002:0x438c rev 0x00) at  PCI =
slot 0000:00:14.1
[   30.543573] ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -=
> IRQ 16
[   30.543661] SB600_PATA: not 100% native mode: will probe irqs later
[   30.543709]     ide0: BM-DMA at 0xf900-0xf907, BIOS settings: hda:DMA, h=
db:DMA
[   30.543929] Probing IDE interface ide0...
[   30.818966] hdb: Maxtor 6E040L0, ATA DISK drive
[   31.140839] hda: SAMSUNG SP1213N, ATA DISK drive
[   31.140915] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[   31.140979] hda: selected mode 0x45
[   31.141043] hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[   31.141136] hdb: selected mode 0x45
[   31.141255] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   31.844123] Probing IDE interface ide1...
[   32.380417] hda: max request size: 512KiB
[   32.380564] hda: 234493056 sectors (120060 MB) w/8192KiB Cache, CHS=3D16=
383/255/63, UDMA(100)
[   32.381107] hda: cache flushes supported
[   32.381177]  hda: hda1
[   32.412089] hdb: max request size: 128KiB
[   32.412243] hdb: 80293248 sectors (41110 MB) w/2048KiB Cache, CHS=3D6553=
5/16/63, UDMA(100)
[   32.412549] hdb: cache flushes supported
[   32.412612]  hdb: hdb1 hdb2
[   32.417111] ahci 0000:00:12.0: version 3.0
[   32.417137] ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 22 (level, low) -=
> IRQ 22
[   32.418595] ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32=
bit
[   32.418640] ahci 0000:00:12.0: controller can't do PMP, turning off CAP_=
PMP
[   33.426582] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0x=
f impl SATA mode
[   33.426639] ahci 0000:00:12.0: flags: ncq sntf ilck led clo pio=20
[   33.426905] scsi0 : ahci
[   33.427011] scsi1 : ahci
[   33.427088] scsi2 : ahci
[   33.427181] scsi3 : ahci
[   33.427304] ata1: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f10=
0 irq 22
[   33.427356] ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f18=
0 irq 22
[   33.427408] ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f20=
0 irq 22
[   33.427460] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f28=
0 irq 22
[   33.902657] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   33.903561] ata1.00: ATA-7: Hitachi HDT725040VLA360, V5COA73A, max UDMA/=
133
[   33.903608] ata1.00: 781422768 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   33.904653] ata1.00: configured for UDMA/133
[   34.217864] ata2: SATA link down (SStatus 0 SControl 300)
[   34.533033] ata3: SATA link down (SStatus 0 SControl 300)
[   34.848200] ata4: SATA link down (SStatus 0 SControl 300)
[   34.848330] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HDT72504 V5=
CO PQ: 0 ANSI: 5
[   34.848471] sd 0:0:0:0: [sda] 781422768 512-byte hardware sectors (40008=
8 MB)
[   34.848520] sd 0:0:0:0: [sda] Write Protect is off
[   34.848561] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   34.848572] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[   34.849079] sd 0:0:0:0: [sda] 781422768 512-byte hardware sectors (40008=
8 MB)
[   34.849126] sd 0:0:0:0: [sda] Write Protect is off
[   34.849167] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   34.849178] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[   34.849230]  sda: sda1 sda2
[   34.861688] sd 0:0:0:0: [sda] Attached SCSI disk
[   34.861777] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   34.861898] usbmon: debugfs is not available
[   34.861974] ACPI: PCI Interrupt 0000:00:13.5[D] -> GSI 19 (level, low) -=
> IRQ 19
[   34.862754] ehci_hcd 0000:00:13.5: EHCI Host Controller
[   34.862874] ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus =
number 1
[   34.862955] ehci_hcd 0000:00:13.5: debug port 1
[   34.863007] ehci_hcd 0000:00:13.5: irq 19, io mem 0xfe029000
[   34.863055] ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00, driver 10=
 Dec 2004
[   34.863238] usb usb1: configuration #1 chosen from 1 choice
[   34.863309] hub 1-0:1.0: USB hub found
[   34.863352] hub 1-0:1.0: 10 ports detected
[   34.965650] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHC=
I) Driver
[   34.965700] ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 16 (level, low) -=
> IRQ 16
[   34.966497] ohci_hcd 0000:00:13.0: OHCI Host Controller
[   34.966611] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus =
number 2
[   34.966679] ohci_hcd 0000:00:13.0: irq 16, io mem 0xfe02e000
[   35.023321] usb usb2: configuration #1 chosen from 1 choice
[   35.023400] hub 2-0:1.0: USB hub found
[   35.023446] hub 2-0:1.0: 2 ports detected
[   35.126606] ACPI: PCI Interrupt 0000:00:13.1[B] -> GSI 17 (level, low) -=
> IRQ 17
[   35.127407] ohci_hcd 0000:00:13.1: OHCI Host Controller
[   35.127519] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus =
number 3
[   35.127585] ohci_hcd 0000:00:13.1: irq 17, io mem 0xfe02d000
[   35.184309] usb usb3: configuration #1 chosen from 1 choice
[   35.184398] hub 3-0:1.0: USB hub found
[   35.184444] hub 3-0:1.0: 2 ports detected
[   35.287563] ACPI: PCI Interrupt 0000:00:13.2[C] -> GSI 18 (level, low) -=
> IRQ 18
[   35.288363] ohci_hcd 0000:00:13.2: OHCI Host Controller
[   35.288477] ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus =
number 4
[   35.288545] ohci_hcd 0000:00:13.2: irq 18, io mem 0xfe02c000
[   35.345207] usb usb4: configuration #1 chosen from 1 choice
[   35.345295] hub 4-0:1.0: USB hub found
[   35.345351] hub 4-0:1.0: 2 ports detected
[   35.421554] usb 1-3: new high speed USB device using ehci_hcd and addres=
s 3
[   35.448481] ACPI: PCI Interrupt 0000:00:13.3[B] -> GSI 17 (level, low) -=
> IRQ 17
[   35.449281] ohci_hcd 0000:00:13.3: OHCI Host Controller
[   35.449413] ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus =
number 5
[   35.449477] ohci_hcd 0000:00:13.3: irq 17, io mem 0xfe02b000
[   35.506126] usb usb5: configuration #1 chosen from 1 choice
[   35.506198] hub 5-0:1.0: USB hub found
[   35.506244] hub 5-0:1.0: 2 ports detected
[   35.548235] usb 1-3: configuration #1 chosen from 1 choice
[   35.609501] ACPI: PCI Interrupt 0000:00:13.4[C] -> GSI 18 (level, low) -=
> IRQ 18
[   35.610301] ohci_hcd 0000:00:13.4: OHCI Host Controller
[   35.610434] ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus =
number 6
[   35.610497] ohci_hcd 0000:00:13.4: irq 18, io mem 0xfe02a000
[   35.667153] usb usb6: configuration #1 chosen from 1 choice
[   35.667226] hub 6-0:1.0: USB hub found
[   35.667272] hub 6-0:1.0: 2 ports detected
[   35.770433] USB Universal Host Controller Interface driver v3.0
[   35.787114] usb 2-1: new full speed USB device using ohci_hcd and addres=
s 2
[   35.935087] usb 2-1: configuration #1 chosen from 1 choice
[   35.937059] hub 2-1:1.0: USB hub found
[   35.939023] hub 2-1:1.0: 4 ports detected
[   36.365933] usb 2-1.1: new low speed USB device using ohci_hcd and addre=
ss 3
[   36.469009] usb 2-1.1: configuration #1 chosen from 1 choice
[   36.665871] usb 2-1.3: new low speed USB device using ohci_hcd and addre=
ss 4
[   36.769948] usb 2-1.3: configuration #1 chosen from 1 choice
[   36.968809] usb 2-1.4: new full speed USB device using ohci_hcd and addr=
ess 5
[   37.075885] usb 2-1.4: configuration #1 chosen from 1 choice
[   37.079800] usbcore: registered new interface driver usblp
[   37.079845] Initializing USB Mass Storage driver...
[   37.079950] scsi4 : SCSI emulation for USB Mass Storage devices
[   37.080055] usbcore: registered new interface driver usb-storage
[   37.080096] USB Mass Storage support registered.
[   37.080142] usb-storage: device found at 3
[   37.080143] usb-storage: waiting for device to settle before scanning
[   37.080223] PNP: No PS/2 controller found. Probing ports directly.
[   37.331385] serio: i8042 KBD port at 0x60,0x64 irq 1
[   37.331500] mice: PS/2 mouse device common for all mice
[   37.351288] input: PC Speaker as /class/input/input2
[   37.372374] i2c /dev entries driver
[   37.372585] piix4_smbus 0000:00:14.0: Found 0000:00:14.0 device
[   37.372735] abituguru: no Abit uGuru found, data =3D 0xFF, cmd =3D 0xFF
[   37.372742] abituguru3: no Abit uGuru3 found, data =3D 0xFF, cmd =3D 0xFF
[   37.372787] coretemp coretemp.0: Using undocumented features, absolute t=
emperature might be wrong!
[   37.372901] coretemp coretemp.1: Using undocumented features, absolute t=
emperature might be wrong!
[   37.373018] coretemp coretemp.2: Using undocumented features, absolute t=
emperature might be wrong!
[   37.373144] coretemp coretemp.3: Using undocumented features, absolute t=
emperature might be wrong!
[   37.373290] device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised:=
 dm-devel@redhat.com
[   37.377980] input: Logitech Logitech Gaming Keyboard as /class/input/inp=
ut3
[   37.398178] input,hidraw0: USB HID v1.10 Keyboard [Logitech Logitech Gam=
ing Keyboard] on usb-0000:00:13.0-1.1
[   37.407780] input: Logitech Logitech Gaming Keyboard as /class/input/inp=
ut4
[   37.425270] input,hidraw1: USB HID v1.10 Device [Logitech Logitech Gamin=
g Keyboard] on usb-0000:00:13.0-1.1
[   37.429901] input: A4Tech PS/2+USB Mouse as /class/input/input5
[   37.452307] input,hidraw2: USB HID v1.10 Mouse [A4Tech PS/2+USB Mouse] o=
n usb-0000:00:13.0-1.3
[   37.458822] input: G15 Keyboard G15 Keyboard as /class/input/input6
[   37.479374] input,hidraw3: USB HID v1.11 Keypad [G15 Keyboard G15 Keyboa=
rd] on usb-0000:00:13.0-1.4
[   37.479566] usbcore: registered new interface driver usbhid
[   37.479608] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   37.479674] Advanced Linux Sound Architecture Driver Version 1.0.15 (Tue=
 Oct 23 06:09:18 2007 UTC).
[   37.479868] ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level, low) -=
> IRQ 16
[   37.647951] hda_codec: Unknown model for ALC883, trying auto-probe from =
BIOS...
[   37.745918] ALSA device list:
[   37.745961]   #0: HDA ATI SB at 0xfe024000 irq 16
[   37.746046] oprofile: using NMI interrupt.
[   37.746096] TCP cubic registered
[   37.746163] NET: Registered protocol family 1
[   37.746298] NET: Registered protocol family 10
[   37.746822] IPv6 over IPv4 tunneling driver
[   37.747164] NET: Registered protocol family 17
[   37.761387] kjournald starting.  Commit interval 5 seconds
[   37.761438] EXT3-fs: mounted filesystem with ordered data mode.
[   37.761493] VFS: Mounted root (ext3 filesystem) readonly.
[   37.761557] Freeing unused kernel memory: 260k freed
[   38.597032] sysfs: duplicate filename 'eth1' can not be created
[   38.597035] WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
[   38.597036]=20
[   38.597036] Call Trace:
[   38.597043]  [<ffffffff802d225f>] sysfs_add_one+0xaf/0xf0
[   38.597045]  [<ffffffff802d3273>] sysfs_create_link+0xa3/0x140
[   38.597048]  [<ffffffff803b1198>] device_rename+0x1d8/0x230
[   38.597052]  [<ffffffff804c2696>] dev_change_name+0xb6/0x230
[   38.597054]  [<ffffffff804c2dc7>] dev_ioctl+0x2b7/0x540
[   38.597057]  [<ffffffff8028783a>] cache_alloc_refill+0x7a/0x550
[   38.597060]  [<ffffffff804b649d>] sock_ioctl+0x7d/0x1f0
[   38.597063]  [<ffffffff80297e8f>] do_ioctl+0x2f/0xa0
[   38.597065]  [<ffffffff80297f74>] vfs_ioctl+0x74/0x2d0
[   38.597066]  [<ffffffff80288f35>] fd_install+0x25/0x60
[   38.597068]  [<ffffffff80298219>] sys_ioctl+0x49/0x80
[   38.597070]  [<ffffffff8020bb7e>] system_call+0x7e/0x83
[   38.597071]=20
[   38.597073] net eth1: device_rename: sysfs_create_symlink failed (-17)
[   38.597363] udev: renamed network interface eth0 to eth1
[   39.261365] EXT3 FS on sda1, internal journal
[   39.474228] kjournald starting.  Commit interval 5 seconds
[   39.474445] EXT3 FS on sda2, internal journal
[   39.474449] EXT3-fs: mounted filesystem with ordered data mode.
[   42.025064] hda: selected mode 0x45
[   42.034758] hdb: selected mode 0x45
[   42.112305] scsi 4:0:0:0: CD-ROM            LITE-ON  DVDRW SHM-165P6S MS=
0N PQ: 0 ANSI: 0
[   42.120801] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 =
cdda tray
[   42.120804] Uniform CD-ROM driver Revision: 3.20
[   42.120838] sr 4:0:0:0: Attached scsi CD-ROM sr0
[   42.120867] sr 4:0:0:0: Attached scsi generic sg1 type 5
[   42.121032] usb-storage: device scan complete
[   42.728646] r8169: eth1: link up
[   43.007730] input: G15 Extra Keys as /class/input/input7
[   46.738152] hda-intel: Invalid position buffer, using LPIB read method i=
nstead.
[   53.772058] eth1: no IPv6 routers present

--MP_ncl/1.wfmKTavi2c3quKoRd
Content-Type: text/plain; name=lspci-vvv.txt
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=lspci-vvv.txt

00:00.0 Host bridge: ATI Technologies Inc Unknown device 7930
	Subsystem: ABIT Computer Corp. Unknown device 2412
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort+ >SERR- <PERR- INTx-
	Latency: 32

00:01.0 PCI bridge: ATI Technologies Inc Unknown device 7932 (prog-if 00 [N=
ormal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 99
	Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D68
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fdf00000-fdffffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [b0] Subsystem: ATI Technologies Inc Unknown device 7932

00:04.0 PCI bridge: ATI Technologies Inc Unknown device 7934 (prog-if 00 [N=
ormal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 4 bytes
	Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=3D0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fde00000-fdefffff
	Prefetchable memory behind bridge: 00000000fdd00000-00000000fddfffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3col=
d+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [58] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <64ns, =
L1 <1us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt-=
 ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd Off, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible+
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=3D0/0 =
Enable+
		Address: fee0f00c  Data: 4149
	Capabilities: [b0] Subsystem: ATI Technologies Inc Unknown device 7930
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100] Virtual Channel

00:12.0 SATA controller: ATI Technologies Inc SB600 Non-Raid-5 SATA (prog-i=
f 01 [AHCI 1.0])
	Subsystem: ATI Technologies Inc SB600 Non-Raid-5 SATA
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Interrupt: pin A routed to IRQ 22
	Region 0: I/O ports at ff00 [size=3D8]
	Region 1: I/O ports at fe00 [size=3D4]
	Region 2: I/O ports at fd00 [size=3D8]
	Region 3: I/O ports at fc00 [size=3D4]
	Region 4: I/O ports at fb00 [size=3D16]
	Region 5: Memory at fe02f000 (32-bit, non-prefetchable) [size=3D1K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3col=
d-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [70] #12 [0010]

00:13.0 USB Controller: ATI Technologies Inc SB600 USB (OHCI0) (prog-if 10 =
[OHCI])
	Subsystem: ABIT Computer Corp. Unknown device 2412
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 4 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fe02e000 (32-bit, non-prefetchable) [size=3D4K]

00:13.1 USB Controller: ATI Technologies Inc SB600 USB (OHCI1) (prog-if 10 =
[OHCI])
	Subsystem: ABIT Computer Corp. Unknown device 2412
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 4 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at fe02d000 (32-bit, non-prefetchable) [size=3D4K]

00:13.2 USB Controller: ATI Technologies Inc SB600 USB (OHCI2) (prog-if 10 =
[OHCI])
	Subsystem: ABIT Computer Corp. Unknown device 2412
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 4 bytes
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at fe02c000 (32-bit, non-prefetchable) [size=3D4K]

00:13.3 USB Controller: ATI Technologies Inc SB600 USB (OHCI3) (prog-if 10 =
[OHCI])
	Subsystem: ABIT Computer Corp. Unknown device 2412
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 4 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at fe02b000 (32-bit, non-prefetchable) [size=3D4K]

00:13.4 USB Controller: ATI Technologies Inc SB600 USB (OHCI4) (prog-if 10 =
[OHCI])
	Subsystem: ABIT Computer Corp. Unknown device 2412
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 4 bytes
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at fe02a000 (32-bit, non-prefetchable) [size=3D4K]

00:13.5 USB Controller: ATI Technologies Inc SB600 USB Controller (EHCI) (p=
rog-if 20 [EHCI])
	Subsystem: ABIT Computer Corp. Unknown device 2412
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 32 bytes
	Interrupt: pin D routed to IRQ 19
	Region 0: Memory at fe029000 (32-bit, non-prefetchable) [size=3D256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D3col=
d-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port

00:14.0 SMBus: ATI Technologies Inc SB600 SMBus (rev 13)
	Subsystem: ABIT Computer Corp. Unknown device 2412
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx+
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Region 0: I/O ports at 0b00 [size=3D16]
	Region 1: Memory at fed00000 (32-bit, non-prefetchable) [size=3D1K]

00:14.1 IDE interface: ATI Technologies Inc SB600 IDE (prog-if 8a [Master S=
ecP PriP])
	Subsystem: ABIT Computer Corp. Unknown device 2412
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at 01f0 [size=3D8]
	Region 1: I/O ports at 03f4 [size=3D1]
	Region 2: I/O ports at 0170 [size=3D8]
	Region 3: I/O ports at 0374 [size=3D1]
	Region 4: I/O ports at f900 [size=3D16]
	Capabilities: [70] Message Signalled Interrupts: Mask- 64bit- Queue=3D0/0 =
Enable-
		Address: 00000000  Data: 0000

00:14.2 Audio device: ATI Technologies Inc SB600 Azalia
	Subsystem: ABIT Computer Corp. Unknown device 2412
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dslow >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 4 bytes
	Interrupt: pin ? routed to IRQ 16
	Region 0: Memory at fe024000 (64-bit, non-prefetchable) [size=3D16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D55mA PME(D0+,D1-,D2-,D3hot+,D3co=
ld+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=3D0/0 =
Enable-
		Address: 0000000000000000  Data: 0000

00:14.3 ISA bridge: ATI Technologies Inc SB600 PCI to LPC Bridge
	Subsystem: ABIT Computer Corp. Unknown device 2412
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:14.4 PCI bridge: ATI Technologies Inc SB600 PCI to PCI Bridge (prog-if 0=
1 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop+ ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Bus: primary=3D00, secondary=3D03, subordinate=3D03, sec-latency=3D64
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: fdc00000-fdcfffff
	Prefetchable memory behind bridge: fdb00000-fdbfffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

01:05.0 VGA compatible controller: ATI Technologies Inc Unknown device 7941=
 (prog-if 00 [VGA])
	Subsystem: ABIT Computer Corp. Unknown device 2412
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 4 bytes
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at d0000000 (64-bit, prefetchable) [size=3D256M]
	Region 2: Memory at fdff0000 (64-bit, non-prefetchable) [size=3D64K]
	Region 4: I/O ports at de00 [size=3D256]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3col=
d-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit+ Queue=3D0/0 =
Enable-
		Address: 0000000000000000  Data: 0000

02:00.0 Ethernet controller: Unknown device 0001:8168 (rev 01)
	Subsystem: ABIT Computer Corp. Unknown device 2410
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 382
	Region 0: I/O ports at ee00 [size=3D256]
	Region 2: Memory at fdeff000 (64-bit, non-prefetchable) [size=3D4K]
	[virtual] Expansion ROM at fde00000 [disabled] [size=3D128K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0-,D1+,D2+,D3hot+,D3c=
old+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [48] Vital Product Data
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=3D0/1 =
Enable+
		Address: 00000000fee0f00c  Data: 4159
	Capabilities: [60] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 1024 bytes, PhantFunc 0, Latency L0s <1us, L1 unlimited
			ExtTag+ AttnBtn+ AttnInd+ PwrInd+ RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 unlimited,=
 L1 unlimited
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt-=
 ABWMgmt-
	Capabilities: [84] Vendor Specific Information
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [12c] Virtual Channel
	Capabilities: [148] Device Serial Number 81-ec-10-00-00-00-4f-04
	Capabilities: [154] Power Budgeting


--MP_ncl/1.wfmKTavi2c3quKoRd--
