Return-Path: <linux-kernel-owner+w=401wt.eu-S1031977AbXFHU46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031977AbXFHU46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 16:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968436AbXFHU4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 16:56:49 -0400
Received: from iucha.net ([209.98.146.184]:43256 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968941AbXFHU4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 16:56:43 -0400
Date: Fri, 8 Jun 2007 15:56:41 -0500
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: networking busted in current -git ???
Message-ID: <20070608205640.GI30661@iucha.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hD6P3ib1XCFtz2ni"
Content-Disposition: inline
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.13 (2006-08-11)
From: florin@iucha.net (Florin Iucha)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--hD6P3ib1XCFtz2ni
Content-Type: multipart/mixed; boundary="JlJsEFsx9RQyiX4C"
Content-Disposition: inline


--JlJsEFsx9RQyiX4C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I am using the current git tree: 85f6038f2170e3335dda09c3dfb0f83110e87019 .=
=20
Git tree from two days ago (with the same config) works fine.

Attempting to acquire an IP address via DHCP fails with:

SIOCSIFADDR: No buffer space available
Listening on LPF/eth0/00:19:b9:0c:9a:43
Sending on   LPF/eth0/00:19:b9:0c:9a:43
Sending on   Socket/fallback
DHCPREQUEST on eth0 to 255.255.255.255 port 67
DHCPACK from xxx.xxx.xxx.xxx
SIOCSIFADDR: No buffer space available
SIOCSIFNETMASK: Cannot assign requested address
SIOCSIFBRDADDR: Cannot assign requested address
SIOCADDRT: Network is unreachable
bound to xxx.xxx.xxx.xxx -- renewal in 98610 seconds.

This is on a Dell 490 with tg3 network driver running Ubuntu 7.04 .
=2Econfig and dmesg are appended.

florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--JlJsEFsx9RQyiX4C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg
Content-Transfer-Encoding: quoted-printable

[    0.000000] Linux version 2.6.22-rc4-2-kvm (root@foo.bar) (gcc version 4=
=2E1.2 (Ubuntu 4.1.2-0ubuntu4)) #1 SMP PREEMPT Fri Jun 8 15:14:53 CDT 2007
[    0.000000] Command line: root=3D/dev/sda2 ro nosplash=20
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fe0ac00 (usable)
[    0.000000]  BIOS-e820: 000000007fe0ac00 - 000000007fe0cc00 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007fe0ec00 - 000000007fe5cc00 (reserved)
[    0.000000]  BIOS-e820: 000000007fe5cc00 - 000000007fe5ec00 (ACPI data)
[    0.000000]  BIOS-e820: 000000007fe5ec00 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fe000000 - 00000000ff000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 158) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 523786) 1 entries of 256 u=
sed
[    0.000000] end_pfn_map =3D 1048576
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000FEBF0, 0024 (r2 DELL  )
[    0.000000] ACPI: XSDT 000FCE5C, 0084 (r1 DELL    B8K            D ASL  =
      61)
[    0.000000] ACPI: FACP 000FCF84, 00F4 (r3 DELL    B8K            D ASL  =
      61)
[    0.000000] ACPI: DSDT FFF5E102, 37E9 (r1   DELL    dt_ex     1000 INTL =
20050624)
[    0.000000] ACPI: FACS 7FE0AC00, 0040
[    0.000000] ACPI: SSDT FFF61A0C, 00AC (r1   DELL    st_ex     1000 INTL =
20050624)
[    0.000000] ACPI: APIC 000FD078, 009E (r1 DELL    B8K            D ASL  =
      61)
[    0.000000] ACPI: BOOT 000FD116, 0028 (r1 DELL    B8K            D ASL  =
      61)
[    0.000000] ACPI: ASF! 000FD13E, 0067 (r16 DELL    B8K            D ASL =
       61)
[    0.000000] ACPI: MCFG 000FD1A5, 003E (r1 DELL    B8K            D ASL  =
      61)
[    0.000000] ACPI: HPET 000FD1E3, 0038 (r1 DELL    B8K            D ASL  =
      61)
[    0.000000] ACPI: TCPA 000FD43F, 0032 (r1 DELL    B8K            D ASL  =
      61)
[    0.000000] ACPI: SLIC 000FD21B, 0176 (r1 DELL    B8K            D ASL  =
      61)
[    0.000000] ACPI: SSDT 7FE0AC40, 0175 (r1 DpgPmm  Cpu0Ist       11 INTL =
20050624)
[    0.000000] ACPI: SSDT 7FE0B049, 0175 (r1 DpgPmm  Cpu1Ist       11 INTL =
20050624)
[    0.000000] ACPI: SSDT 7FE0B452, 0244 (r1 DpgPmm    CpuPm       10 INTL =
20050624)
[    0.000000] Entering add_active_range(0, 0, 158) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 523786) 1 entries of 256 u=
sed
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      158
[    0.000000]     0:      256 ->   523786
[    0.000000] On node 0 totalpages: 523688
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1248 pages reserved
[    0.000000]   DMA zone: 2694 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7105 pages used for memmap
[    0.000000]   DMA32 zone: 512585 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x07] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec80000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, address 0xfec80000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000=
:60000000)
[    0.000000] PERCPU: Allocating 33288 bytes of per cpu data
[    0.000000] Built 1 zonelists.  Total pages: 515279
[    0.000000] Kernel command line: root=3D/dev/sda2 ro nosplash=20
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[   16.602855] time.c: Detected 2327.498 MHz processor.
[   16.604869] Console: colour VGA+ 80x25
[   16.609670] Dentry cache hash table entries: 262144 (order: 9, 2097152 b=
ytes)
[   16.610720] Inode-cache hash table entries: 131072 (order: 8, 1048576 by=
tes)
[   16.610958] Checking aperture...
[   16.629755] Memory: 2044928k/2095144k available (2761k kernel code, 4949=
2k reserved, 1432k data, 252k init)
[   16.707663] Calibrating delay using timer specific routine.. 4658.42 Bog=
oMIPS (lpj=3D9316847)
[   16.707825] Mount-cache hash table entries: 256
[   16.707980] CPU: L1 I cache: 32K, L1 D cache: 32K
[   16.708078] CPU: L3 cache: 4096K
[   16.708133] using mwait in idle threads.
[   16.708189] CPU: Physical Processor ID: 0
[   16.708244] CPU: Processor Core ID: 0
[   16.708303] CPU0: Thermal monitoring enabled (TM2)
[   16.708367] Freeing SMP alternatives: 23k freed
[   16.708441] ACPI: Core revision 20070126
[   16.807189] Using local APIC timer interrupts.
[   16.850118] result 20781221
[   16.850173] Detected 20.781 MHz APIC timer.
[   16.851462] Booting processor 1/2 APIC 0x1
[   16.862108] Initializing CPU#1
[   16.939155] Calibrating delay using timer specific routine.. 4655.16 Bog=
oMIPS (lpj=3D9310333)
[   16.939162] CPU: L1 I cache: 32K, L1 D cache: 32K
[   16.939164] CPU: L3 cache: 4096K
[   16.939166] CPU: Physical Processor ID: 0
[   16.939167] CPU: Processor Core ID: 0
[   16.939173] CPU1: Thermal monitoring enabled (TM2)
[   16.939624] Intel(R) Xeon(R) CPU            5140  @ 2.33GHz stepping 06
[   16.939638] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[   16.963115] Brought up 2 CPUs
[   17.022735] migration_cost=3D10
[   17.022949] PM: Adding info for No Bus:platform
[   17.023059] NET: Registered protocol family 16
[   17.023147] PM: Adding info for No Bus:vtcon0
[   17.023195] ACPI: bus type pci registered
[   17.025136] PCI: Using MMCONFIG at e0000000 - efffffff
[   17.045203] ACPI: System BIOS is requesting _OSI(Linux)
[   17.045261] ACPI: Please test with "acpi_osi=3D!Linux"
[   17.045262] Please send dmidecode to linux-acpi@vger.kernel.org
[   17.054719] ACPI: Interpreter enabled
[   17.054775] ACPI: Using IOAPIC for interrupt routing
[   17.054905] PM: Adding info for acpi:acpi_system:00
[   17.054940] PM: Adding info for acpi:button_power:00
[   17.054972] PM: Adding info for acpi:ACPI0007:00
[   17.055005] PM: Adding info for acpi:ACPI0007:01
[   17.055035] PM: Adding info for acpi:ACPI0007:02
[   17.055066] PM: Adding info for acpi:ACPI0007:03
[   17.055097] PM: Adding info for acpi:ACPI0007:04
[   17.055125] PM: Adding info for acpi:ACPI0007:05
[   17.055154] PM: Adding info for acpi:ACPI0007:06
[   17.055185] PM: Adding info for acpi:ACPI0007:07
[   17.055222] PM: Adding info for acpi:device:00
[   17.055260] PM: Adding info for acpi:PNP0C0C:00
[   17.057373] PM: Adding info for acpi:PNP0A03:00
[   17.061559] PM: Adding info for acpi:device:01
[   17.065757] PM: Adding info for acpi:device:02
[   17.069952] PM: Adding info for acpi:device:03
[   17.074136] PM: Adding info for acpi:device:04
[   17.078323] PM: Adding info for acpi:device:05
[   17.082508] PM: Adding info for acpi:device:06
[   17.088924] PM: Adding info for acpi:device:07
[   17.095627] PM: Adding info for acpi:device:08
[   17.102319] PM: Adding info for acpi:device:09
[   17.109023] PM: Adding info for acpi:device:0a
[   17.115721] PM: Adding info for acpi:device:0b
[   17.115756] PM: Adding info for acpi:device:0c
[   17.115789] PM: Adding info for acpi:PNP0C01:00
[   17.115820] PM: Adding info for acpi:PNP0200:00
[   17.115849] PM: Adding info for acpi:PNP0C04:00
[   17.115881] PM: Adding info for acpi:PNP0000:00
[   17.115912] PM: Adding info for acpi:PNP0800:00
[   17.115941] PM: Adding info for acpi:PNP0B00:00
[   17.115974] PM: Adding info for acpi:PNP0100:00
[   17.120334] PM: Adding info for acpi:PNP0700:00
[   17.129811] PM: Adding info for acpi:PNP0401:00
[   17.134160] PM: Adding info for acpi:PNP0501:00
[   17.138517] PM: Adding info for acpi:PNP0501:01
[   17.146899] PM: Adding info for acpi:device:0d
[   17.153605] PM: Adding info for acpi:device:0e
[   17.160316] PM: Adding info for acpi:device:0f
[   17.167023] PM: Adding info for acpi:device:10
[   17.167259] PM: Adding info for acpi:PNP0C0F:00
[   17.167431] PM: Adding info for acpi:PNP0C0F:01
[   17.167605] PM: Adding info for acpi:PNP0C0F:02
[   17.167799] PM: Adding info for acpi:PNP0C0F:03
[   17.167975] PM: Adding info for acpi:PNP0C0F:04
[   17.168147] PM: Adding info for acpi:PNP0C0F:05
[   17.168324] PM: Adding info for acpi:PNP0C0F:06
[   17.168498] PM: Adding info for acpi:PNP0C0F:07
[   17.168531] PM: Adding info for acpi:PNP0103:00
[   17.168561] PM: Adding info for acpi:thermal:00
[   17.168644] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   17.168713] PCI: Probing PCI hardware (bus 00)
[   17.168720] PM: Adding info for No Bus:pci0000:00
[   17.169831] PCI: Transparent bridge - 0000:00:1e.0
[   17.169927] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   17.170717] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
[   17.170954] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2.PCI3._PRT]
[   17.171248] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2.PCI3.PCIF=
=2E_PRT]
[   17.171484] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2.PCI5._PRT]
[   17.171804] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI6._PRT]
[   17.172039] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI7._PRT]
[   17.172283] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI8._PRT]
[   17.172476] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI9._PRT]
[   17.246029] PM: Adding info for pci:0000:00:00.0
[   17.319346] PM: Adding info for pci:0000:00:02.0
[   17.392646] PM: Adding info for pci:0000:00:03.0
[   17.465964] PM: Adding info for pci:0000:00:04.0
[   17.539260] PM: Adding info for pci:0000:00:05.0
[   17.612688] PM: Adding info for pci:0000:00:06.0
[   17.685992] PM: Adding info for pci:0000:00:07.0
[   17.759269] PM: Adding info for pci:0000:00:10.0
[   17.832572] PM: Adding info for pci:0000:00:10.1
[   17.905889] PM: Adding info for pci:0000:00:10.2
[   17.979208] PM: Adding info for pci:0000:00:11.0
[   18.052516] PM: Adding info for pci:0000:00:13.0
[   18.125818] PM: Adding info for pci:0000:00:15.0
[   18.199117] PM: Adding info for pci:0000:00:16.0
[   18.272424] PM: Adding info for pci:0000:00:1b.0
[   18.345722] PM: Adding info for pci:0000:00:1c.0
[   18.419038] PM: Adding info for pci:0000:00:1d.0
[   18.492361] PM: Adding info for pci:0000:00:1d.1
[   18.565669] PM: Adding info for pci:0000:00:1d.2
[   18.639379] PM: Adding info for pci:0000:00:1d.3
[   18.712684] PM: Adding info for pci:0000:00:1d.7
[   18.785997] PM: Adding info for pci:0000:00:1e.0
[   18.859296] PM: Adding info for pci:0000:00:1f.0
[   18.932605] PM: Adding info for pci:0000:00:1f.1
[   19.005910] PM: Adding info for pci:0000:00:1f.2
[   19.079212] PM: Adding info for pci:0000:00:1f.3
[   19.092558] PM: Adding info for pci:0000:01:00.0
[   19.105899] PM: Adding info for pci:0000:01:00.3
[   19.112595] PM: Adding info for pci:0000:02:00.0
[   19.119285] PM: Adding info for pci:0000:02:01.0
[   19.119317] PM: Adding info for pci:0000:07:00.0
[   19.119346] PM: Adding info for pci:0000:0b:00.0
[   19.119638] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 =
15)
[   19.120490] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 9 10 11 12 =
15)
[   19.121338] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 =
15)
[   19.122181] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 1=
5) *0, disabled.
[   19.123122] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *9 10 11 12 =
15)
[   19.123968] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11 12 =
15)
[   19.124816] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 =
15)
[   19.125660] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 =
15)
[   19.126319] Linux Plug and Play Support v0.97 (c) Adam Belay
[   19.126385] pnp: PnP ACPI init
[   19.126443] PM: Adding info for No Bus:pnp0
[   19.126446] ACPI: bus type pnp registered
[   19.131699] PM: Adding info for pnp:00:00
[   19.135303] PM: Adding info for pnp:00:01
[   19.135445] PM: Adding info for pnp:00:02
[   19.135570] PM: Adding info for pnp:00:03
[   19.135685] PM: Adding info for pnp:00:04
[   19.135802] PM: Adding info for pnp:00:05
[   19.139886] PM: Adding info for pnp:00:06
[   19.149729] PM: Adding info for pnp:00:07
[   19.153144] PM: Adding info for pnp:00:08
[   19.156563] PM: Adding info for pnp:00:09
[   19.165678] PM: Adding info for pnp:00:0a
[   19.165701] pnp: PnP ACPI: found 11 devices
[   19.165757] ACPI: ACPI bus type pnp unregistered
[   19.165898] SCSI subsystem initialized
[   19.165983] libata version 2.21 loaded.
[   19.166028] usbcore: registered new interface driver usbfs
[   19.166105] usbcore: registered new interface driver hub
[   19.166185] usbcore: registered new device driver usb
[   19.166280] PCI: Using ACPI for IRQ routing
[   19.166336] PCI: If a device doesn't work, try "pci=3Drouteirq".  If it =
helps, post a report
[   19.166480] PCI-GART: No AMD northbridge found.
[   19.166539] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[   19.166757] hpet0: 3 64-bit timers, 14318180 Hz
[   19.167840] ACPI: RTC can wake from S4
[   19.167917] pnp: 00:01: ioport range 0x800-0x85f has been reserved
[   19.167977] pnp: 00:01: ioport range 0xc00-0xc7f has been reserved
[   19.168036] pnp: 00:01: ioport range 0x860-0x8ff has been reserved
[   19.168112] PM: Adding info for No Bus:mem
[   19.168132] PM: Adding info for No Bus:kmem
[   19.168151] PM: Adding info for No Bus:null
[   19.168172] PM: Adding info for No Bus:port
[   19.168191] PM: Adding info for No Bus:zero
[   19.168210] PM: Adding info for No Bus:full
[   19.168232] PM: Adding info for No Bus:random
[   19.168251] PM: Adding info for No Bus:urandom
[   19.168271] PM: Adding info for No Bus:kmsg
[   19.168291] PM: Adding info for No Bus:oldmem
[   19.168335] PCI: Bridge: 0000:02:00.0
[   19.168391]   IO window: disabled.
[   19.168447]   MEM window: disabled.
[   19.168503]   PREFETCH window: disabled.
[   19.168560] PCI: Bridge: 0000:02:01.0
[   19.168615]   IO window: disabled.
[   19.168671]   MEM window: disabled.
[   19.168727]   PREFETCH window: disabled.
[   19.168783] PCI: Bridge: 0000:01:00.0
[   19.168838]   IO window: disabled.
[   19.168895]   MEM window: disabled.
[   19.168950]   PREFETCH window: disabled.
[   19.169007] PCI: Bridge: 0000:01:00.3
[   19.169062]   IO window: disabled.
[   19.169118]   MEM window: disabled.
[   19.169173]   PREFETCH window: disabled.
[   19.169230] PCI: Bridge: 0000:00:02.0
[   19.169285]   IO window: disabled.
[   19.169340]   MEM window: dfe00000-dfefffff
[   19.169397]   PREFETCH window: disabled.
[   19.169452] PCI: Bridge: 0000:00:03.0
[   19.169507]   IO window: disabled.
[   19.169563]   MEM window: dfd00000-dfdfffff
[   19.169619]   PREFETCH window: disabled.
[   19.169675] PCI: Bridge: 0000:00:04.0
[   19.169730]   IO window: disabled.
[   19.169786]   MEM window: dd000000-dfcfffff
[   19.169842]   PREFETCH window: c0000000-cfffffff
[   19.169899] PCI: Bridge: 0000:00:05.0
[   19.169954]   IO window: disabled.
[   19.170010]   MEM window: dcf00000-dcffffff
[   19.170066]   PREFETCH window: disabled.
[   19.170122] PCI: Bridge: 0000:00:06.0
[   19.170177]   IO window: disabled.
[   19.170233]   MEM window: dce00000-dcefffff
[   19.170291]   PREFETCH window: disabled.
[   19.170348] Time: tsc clocksource has been installed.
[   19.170406] PCI: Bridge: 0000:00:07.0
[   19.170461]   IO window: disabled.
[   19.170516]   MEM window: dcd00000-dcdfffff
[   19.170572]   PREFETCH window: disabled.
[   19.170628] PCI: Bridge: 0000:00:1c.0
[   19.170683]   IO window: disabled.
[   19.170740]   MEM window: dcc00000-dccfffff
[   19.170796]   PREFETCH window: disabled.
[   19.170853] PCI: Bridge: 0000:00:1e.0
[   19.170908]   IO window: disabled.
[   19.172320]   MEM window: disabled.
[   19.172376]   PREFETCH window: disabled.
[   19.172439] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -=
> IRQ 16
[   19.172551] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   19.172558] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -=
> IRQ 16
[   19.172670] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   19.172678] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -=
> IRQ 16
[   19.172790] PCI: Setting latency timer of device 0000:02:00.0 to 64
[   19.172798] ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 16 (level, low) -=
> IRQ 16
[   19.172909] PCI: Setting latency timer of device 0000:02:01.0 to 64
[   19.172917] PCI: Setting latency timer of device 0000:01:00.3 to 64
[   19.172921] ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 16 (level, low) -=
> IRQ 16
[   19.173031] PCI: Setting latency timer of device 0000:00:03.0 to 64
[   19.173035] ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 16 (level, low) -=
> IRQ 16
[   19.173146] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   19.173150] ACPI: PCI Interrupt 0000:00:05.0[A] -> GSI 16 (level, low) -=
> IRQ 16
[   19.173261] PCI: Setting latency timer of device 0000:00:05.0 to 64
[   19.173264] ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 16 (level, low) -=
> IRQ 16
[   19.173375] PCI: Setting latency timer of device 0000:00:06.0 to 64
[   19.173379] ACPI: PCI Interrupt 0000:00:07.0[A] -> GSI 16 (level, low) -=
> IRQ 16
[   19.173490] PCI: Setting latency timer of device 0000:00:07.0 to 64
[   19.173499] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -=
> IRQ 16
[   19.173610] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   19.173616] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[   19.173639] NET: Registered protocol family 2
[   19.210393] IP route cache hash table entries: 65536 (order: 7, 524288 b=
ytes)
[   19.210660] TCP established hash table entries: 131072 (order: 9, 314572=
8 bytes)
[   19.212141] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   19.212740] TCP: Hash tables configured (established 131072 bind 65536)
[   19.212800] TCP reno registered
[   19.222538] checking if image is initramfs... it is
[   20.291869] Freeing initrd memory: 12585k freed
[   20.296913] Simple Boot Flag at 0x7a set to 0x80
[   20.297051] PM: Adding info for No Bus:mcelog
[   20.297146] PM: Adding info for platform:pcspkr
[   20.297241] audit: initializing netlink socket (disabled)
[   20.297308] audit(1181335139.648:1): initialized
[   20.297497] VFS: Disk quotas dquot_6.5.1
[   20.297559] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   20.297746] io scheduler noop registered
[   20.297802] io scheduler anticipatory registered
[   20.297859] io scheduler deadline registered
[   20.297925] io scheduler cfq registered (default)
[   20.312134] Boot video device is 0000:07:00.0
[   20.312216] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   20.312230] assign_interrupt_mode Found MSI capability
[   20.312301] Allocate Port Service[0000:00:02.0:pcie00]
[   20.312307] PM: Adding info for pci_express:0000:00:02.0:pcie00
[   20.312329] Allocate Port Service[0000:00:02.0:pcie01]
[   20.312333] PM: Adding info for pci_express:0000:00:02.0:pcie01
[   20.312375] PCI: Setting latency timer of device 0000:00:03.0 to 64
[   20.312390] assign_interrupt_mode Found MSI capability
[   20.312458] Allocate Port Service[0000:00:03.0:pcie00]
[   20.312463] PM: Adding info for pci_express:0000:00:03.0:pcie00
[   20.312484] Allocate Port Service[0000:00:03.0:pcie01]
[   20.312488] PM: Adding info for pci_express:0000:00:03.0:pcie01
[   20.312526] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   20.312540] assign_interrupt_mode Found MSI capability
[   20.312608] Allocate Port Service[0000:00:04.0:pcie00]
[   20.312613] PM: Adding info for pci_express:0000:00:04.0:pcie00
[   20.312644] Allocate Port Service[0000:00:04.0:pcie01]
[   20.312648] PM: Adding info for pci_express:0000:00:04.0:pcie01
[   20.312684] PCI: Setting latency timer of device 0000:00:05.0 to 64
[   20.312696] assign_interrupt_mode Found MSI capability
[   20.312763] Allocate Port Service[0000:00:05.0:pcie00]
[   20.312767] PM: Adding info for pci_express:0000:00:05.0:pcie00
[   20.312785] Allocate Port Service[0000:00:05.0:pcie01]
[   20.312790] PM: Adding info for pci_express:0000:00:05.0:pcie01
[   20.312826] PCI: Setting latency timer of device 0000:00:06.0 to 64
[   20.312839] assign_interrupt_mode Found MSI capability
[   20.312905] Allocate Port Service[0000:00:06.0:pcie00]
[   20.312910] PM: Adding info for pci_express:0000:00:06.0:pcie00
[   20.312928] Allocate Port Service[0000:00:06.0:pcie01]
[   20.312931] PM: Adding info for pci_express:0000:00:06.0:pcie01
[   20.312966] PCI: Setting latency timer of device 0000:00:07.0 to 64
[   20.312978] assign_interrupt_mode Found MSI capability
[   20.313045] Allocate Port Service[0000:00:07.0:pcie00]
[   20.313049] PM: Adding info for pci_express:0000:00:07.0:pcie00
[   20.313069] Allocate Port Service[0000:00:07.0:pcie01]
[   20.313073] PM: Adding info for pci_express:0000:00:07.0:pcie01
[   20.313114] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   20.313137] assign_interrupt_mode Found MSI capability
[   20.313212] Allocate Port Service[0000:00:1c.0:pcie00]
[   20.313216] PM: Adding info for pci_express:0000:00:1c.0:pcie00
[   20.313235] Allocate Port Service[0000:00:1c.0:pcie03]
[   20.313239] PM: Adding info for pci_express:0000:00:1c.0:pcie03
[   20.313292] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   20.313313] Allocate Port Service[0000:01:00.0:pcie10]
[   20.313318] PM: Adding info for pci_express:0000:01:00.0:pcie10
[   20.313337] Allocate Port Service[0000:01:00.0:pcie11]
[   20.313342] PM: Adding info for pci_express:0000:01:00.0:pcie11
[   20.313394] PCI: Setting latency timer of device 0000:02:00.0 to 64
[   20.313416] assign_interrupt_mode Found MSI capability
[   20.313492] Allocate Port Service[0000:02:00.0:pcie20]
[   20.313496] PM: Adding info for pci_express:0000:02:00.0:pcie20
[   20.313517] Allocate Port Service[0000:02:00.0:pcie21]
[   20.313521] PM: Adding info for pci_express:0000:02:00.0:pcie21
[   20.313569] PCI: Setting latency timer of device 0000:02:01.0 to 64
[   20.313591] assign_interrupt_mode Found MSI capability
[   20.313665] Allocate Port Service[0000:02:01.0:pcie20]
[   20.313670] PM: Adding info for pci_express:0000:02:01.0:pcie20
[   20.313689] Allocate Port Service[0000:02:01.0:pcie21]
[   20.313693] PM: Adding info for pci_express:0000:02:01.0:pcie21
[   20.313784] Evaluate _OSC Set fails. Status =3D 0x0005
[   20.313788] Evaluate _OSC Set fails. Status =3D 0x0005
[   20.313790] aer_init: AER service init fails - Run ACPI _OSC fails
[   20.313792] aer: probe of 0000:00:02.0:pcie01 failed with error 2
[   20.313859] Evaluate _OSC Set fails. Status =3D 0x0005
[   20.313862] Evaluate _OSC Set fails. Status =3D 0x0005
[   20.313863] aer_init: AER service init fails - Run ACPI _OSC fails
[   20.313866] aer: probe of 0000:00:03.0:pcie01 failed with error 2
[   20.313931] Evaluate _OSC Set fails. Status =3D 0x0005
[   20.313935] Evaluate _OSC Set fails. Status =3D 0x0005
[   20.313936] aer_init: AER service init fails - Run ACPI _OSC fails
[   20.313938] aer: probe of 0000:00:04.0:pcie01 failed with error 2
[   20.314004] Evaluate _OSC Set fails. Status =3D 0x0005
[   20.314007] Evaluate _OSC Set fails. Status =3D 0x0005
[   20.314009] aer_init: AER service init fails - Run ACPI _OSC fails
[   20.314011] aer: probe of 0000:00:05.0:pcie01 failed with error 2
[   20.314077] Evaluate _OSC Set fails. Status =3D 0x0005
[   20.314079] Evaluate _OSC Set fails. Status =3D 0x0005
[   20.314081] aer_init: AER service init fails - Run ACPI _OSC fails
[   20.314083] aer: probe of 0000:00:06.0:pcie01 failed with error 2
[   20.314149] Evaluate _OSC Set fails. Status =3D 0x0005
[   20.314152] Evaluate _OSC Set fails. Status =3D 0x0005
[   20.314153] aer_init: AER service init fails - Run ACPI _OSC fails
[   20.314155] aer: probe of 0000:00:07.0:pcie01 failed with error 2
[   20.314257] ACPI: PCI Interrupt 0000:07:00.0[A] -> GSI 16 (level, low) -=
> IRQ 16
[   20.314385] nvidiafb: Device ID: 10de016a=20
[   20.314486] PM: Adding info for No Bus:i2c-0
[   20.314533] PM: Adding info for No Bus:i2c-1
[   20.314577] PM: Adding info for No Bus:i2c-2
[   20.328182] nvidiafb: CRTC0 analog found
[   20.344227] nvidiafb: CRTC1 analog not found
[   20.479558] i2c-adapter i2c-0: unable to read EDID block.
[   20.655177] i2c-adapter i2c-0: unable to read EDID block.
[   20.966638] nvidiafb: EDID found from BUS1
[   21.066897] i2c-adapter i2c-1: unable to read EDID block.
[   21.224086] i2c-adapter i2c-1: unable to read EDID block.
[   21.381011] i2c-adapter i2c-1: unable to read EDID block.
[   21.433386] nvidiafb: CRTC 0 appears to have a CRT attached
[   21.433445] nvidiafb: Using CRT on CRTC 0
[   21.433557] mtrr: type mismatch for c0000000,8000000 old: write-back new=
: write-combining
[   21.433629] nvidiafb: unable to setup MTRR
[   21.433811] PM: Adding info for No Bus:fb0
[   21.433838] nvidiafb: PCI nVidia NV16 framebuffer (64MB @ 0xC0000000)
[   21.433920] PM: Adding info for platform:vesafb.0
[   21.433964] PM: Adding info for No Bus:tty
[   21.433985] PM: Adding info for No Bus:console
[   21.434005] PM: Adding info for No Bus:ptmx
[   21.434026] PM: Adding info for No Bus:tty0
[   21.434053] PM: Adding info for No Bus:vcs
[   21.434075] PM: Adding info for No Bus:vcsa
[   21.434098] PM: Adding info for No Bus:tty1
[   21.434119] PM: Adding info for No Bus:tty2
[   21.434141] PM: Adding info for No Bus:tty3
[   21.434161] PM: Adding info for No Bus:tty4
[   21.434180] PM: Adding info for No Bus:tty5
[   21.434201] PM: Adding info for No Bus:tty6
[   21.434222] PM: Adding info for No Bus:tty7
[   21.434242] PM: Adding info for No Bus:tty8
[   21.434263] PM: Adding info for No Bus:tty9
[   21.434283] PM: Adding info for No Bus:tty10
[   21.434303] PM: Adding info for No Bus:tty11
[   21.434325] PM: Adding info for No Bus:tty12
[   21.434346] PM: Adding info for No Bus:tty13
[   21.434366] PM: Adding info for No Bus:tty14
[   21.434386] PM: Adding info for No Bus:tty15
[   21.434407] PM: Adding info for No Bus:tty16
[   21.434427] PM: Adding info for No Bus:tty17
[   21.434448] PM: Adding info for No Bus:tty18
[   21.434470] PM: Adding info for No Bus:tty19
[   21.434491] PM: Adding info for No Bus:tty20
[   21.434514] PM: Adding info for No Bus:tty21
[   21.434535] PM: Adding info for No Bus:tty22
[   21.434556] PM: Adding info for No Bus:tty23
[   21.434580] PM: Adding info for No Bus:tty24
[   21.434603] PM: Adding info for No Bus:tty25
[   21.434624] PM: Adding info for No Bus:tty26
[   21.434647] PM: Adding info for No Bus:tty27
[   21.434670] PM: Adding info for No Bus:tty28
[   21.434691] PM: Adding info for No Bus:tty29
[   21.434714] PM: Adding info for No Bus:tty30
[   21.434737] PM: Adding info for No Bus:tty31
[   21.434761] PM: Adding info for No Bus:tty32
[   21.434784] PM: Adding info for No Bus:tty33
[   21.434807] PM: Adding info for No Bus:tty34
[   21.434829] PM: Adding info for No Bus:tty35
[   21.434854] PM: Adding info for No Bus:tty36
[   21.434877] PM: Adding info for No Bus:tty37
[   21.434900] PM: Adding info for No Bus:tty38
[   21.434927] PM: Adding info for No Bus:tty39
[   21.434951] PM: Adding info for No Bus:tty40
[   21.434974] PM: Adding info for No Bus:tty41
[   21.434999] PM: Adding info for No Bus:tty42
[   21.435023] PM: Adding info for No Bus:tty43
[   21.435048] PM: Adding info for No Bus:tty44
[   21.435074] PM: Adding info for No Bus:tty45
[   21.435098] PM: Adding info for No Bus:tty46
[   21.435121] PM: Adding info for No Bus:tty47
[   21.435147] PM: Adding info for No Bus:tty48
[   21.435173] PM: Adding info for No Bus:tty49
[   21.435196] PM: Adding info for No Bus:tty50
[   21.435222] PM: Adding info for No Bus:tty51
[   21.435247] PM: Adding info for No Bus:tty52
[   21.435271] PM: Adding info for No Bus:tty53
[   21.435297] PM: Adding info for No Bus:tty54
[   21.435322] PM: Adding info for No Bus:tty55
[   21.435347] PM: Adding info for No Bus:tty56
[   21.435376] PM: Adding info for No Bus:tty57
[   21.435400] PM: Adding info for No Bus:tty58
[   21.435424] PM: Adding info for No Bus:tty59
[   21.435452] PM: Adding info for No Bus:tty60
[   21.435477] PM: Adding info for No Bus:tty61
[   21.435502] PM: Adding info for No Bus:tty62
[   21.435529] PM: Adding info for No Bus:tty63
[   21.435579] PM: Adding info for No Bus:ptyp0
[   21.435604] PM: Adding info for No Bus:ptyp1
[   21.435629] PM: Adding info for No Bus:ptyp2
[   21.435653] PM: Adding info for No Bus:ptyp3
[   21.435677] PM: Adding info for No Bus:ptyp4
[   21.435703] PM: Adding info for No Bus:ptyp5
[   21.435725] PM: Adding info for No Bus:ptyp6
[   21.435748] PM: Adding info for No Bus:ptyp7
[   21.435776] PM: Adding info for No Bus:ptyp8
[   21.435800] PM: Adding info for No Bus:ptyp9
[   21.435823] PM: Adding info for No Bus:ptypa
[   21.435848] PM: Adding info for No Bus:ptypb
[   21.435873] PM: Adding info for No Bus:ptypc
[   21.435898] PM: Adding info for No Bus:ptypd
[   21.435923] PM: Adding info for No Bus:ptype
[   21.435948] PM: Adding info for No Bus:ptypf
[   21.435972] PM: Adding info for No Bus:ptyq0
[   21.435998] PM: Adding info for No Bus:ptyq1
[   21.436022] PM: Adding info for No Bus:ptyq2
[   21.436046] PM: Adding info for No Bus:ptyq3
[   21.436073] PM: Adding info for No Bus:ptyq4
[   21.436097] PM: Adding info for No Bus:ptyq5
[   21.436120] PM: Adding info for No Bus:ptyq6
[   21.436146] PM: Adding info for No Bus:ptyq7
[   21.436171] PM: Adding info for No Bus:ptyq8
[   21.436194] PM: Adding info for No Bus:ptyq9
[   21.436221] PM: Adding info for No Bus:ptyqa
[   21.436247] PM: Adding info for No Bus:ptyqb
[   21.436272] PM: Adding info for No Bus:ptyqc
[   21.436299] PM: Adding info for No Bus:ptyqd
[   21.436323] PM: Adding info for No Bus:ptyqe
[   21.436348] PM: Adding info for No Bus:ptyqf
[   21.436376] PM: Adding info for No Bus:ptyr0
[   21.436400] PM: Adding info for No Bus:ptyr1
[   21.436424] PM: Adding info for No Bus:ptyr2
[   21.436450] PM: Adding info for No Bus:ptyr3
[   21.436476] PM: Adding info for No Bus:ptyr4
[   21.436501] PM: Adding info for No Bus:ptyr5
[   21.436528] PM: Adding info for No Bus:ptyr6
[   21.436554] PM: Adding info for No Bus:ptyr7
[   21.436580] PM: Adding info for No Bus:ptyr8
[   21.436606] PM: Adding info for No Bus:ptyr9
[   21.436630] PM: Adding info for No Bus:ptyra
[   21.436654] PM: Adding info for No Bus:ptyrb
[   21.436683] PM: Adding info for No Bus:ptyrc
[   21.436708] PM: Adding info for No Bus:ptyrd
[   21.436734] PM: Adding info for No Bus:ptyre
[   21.436760] PM: Adding info for No Bus:ptyrf
[   21.436787] PM: Adding info for No Bus:ptys0
[   21.436812] PM: Adding info for No Bus:ptys1
[   21.436839] PM: Adding info for No Bus:ptys2
[   21.436865] PM: Adding info for No Bus:ptys3
[   21.436892] PM: Adding info for No Bus:ptys4
[   21.436918] PM: Adding info for No Bus:ptys5
[   21.436944] PM: Adding info for No Bus:ptys6
[   21.436969] PM: Adding info for No Bus:ptys7
[   21.436998] PM: Adding info for No Bus:ptys8
[   21.437024] PM: Adding info for No Bus:ptys9
[   21.437049] PM: Adding info for No Bus:ptysa
[   21.437077] PM: Adding info for No Bus:ptysb
[   21.437104] PM: Adding info for No Bus:ptysc
[   21.437129] PM: Adding info for No Bus:ptysd
[   21.437156] PM: Adding info for No Bus:ptyse
[   21.437182] PM: Adding info for No Bus:ptysf
[   21.437209] PM: Adding info for No Bus:ptyt0
[   21.437237] PM: Adding info for No Bus:ptyt1
[   21.437263] PM: Adding info for No Bus:ptyt2
[   21.437289] PM: Adding info for No Bus:ptyt3
[   21.437318] PM: Adding info for No Bus:ptyt4
[   21.437345] PM: Adding info for No Bus:ptyt5
[   21.437374] PM: Adding info for No Bus:ptyt6
[   21.437405] PM: Adding info for No Bus:ptyt7
[   21.437432] PM: Adding info for No Bus:ptyt8
[   21.437458] PM: Adding info for No Bus:ptyt9
[   21.437486] PM: Adding info for No Bus:ptyta
[   21.437513] PM: Adding info for No Bus:ptytb
[   21.437541] PM: Adding info for No Bus:ptytc
[   21.437573] PM: Adding info for No Bus:ptytd
[   21.437601] PM: Adding info for No Bus:ptyte
[   21.437628] PM: Adding info for No Bus:ptytf
[   21.437659] PM: Adding info for No Bus:ptyu0
[   21.437688] PM: Adding info for No Bus:ptyu1
[   21.437716] PM: Adding info for No Bus:ptyu2
[   21.437747] PM: Adding info for No Bus:ptyu3
[   21.437776] PM: Adding info for No Bus:ptyu4
[   21.437803] PM: Adding info for No Bus:ptyu5
[   21.437834] PM: Adding info for No Bus:ptyu6
[   21.437863] PM: Adding info for No Bus:ptyu7
[   21.437893] PM: Adding info for No Bus:ptyu8
[   21.437923] PM: Adding info for No Bus:ptyu9
[   21.437951] PM: Adding info for No Bus:ptyua
[   21.437979] PM: Adding info for No Bus:ptyub
[   21.438011] PM: Adding info for No Bus:ptyuc
[   21.438041] PM: Adding info for No Bus:ptyud
[   21.438070] PM: Adding info for No Bus:ptyue
[   21.438101] PM: Adding info for No Bus:ptyuf
[   21.438130] PM: Adding info for No Bus:ptyv0
[   21.438159] PM: Adding info for No Bus:ptyv1
[   21.438189] PM: Adding info for No Bus:ptyv2
[   21.438219] PM: Adding info for No Bus:ptyv3
[   21.438248] PM: Adding info for No Bus:ptyv4
[   21.438279] PM: Adding info for No Bus:ptyv5
[   21.438307] PM: Adding info for No Bus:ptyv6
[   21.438337] PM: Adding info for No Bus:ptyv7
[   21.438370] PM: Adding info for No Bus:ptyv8
[   21.438399] PM: Adding info for No Bus:ptyv9
[   21.438428] PM: Adding info for No Bus:ptyva
[   21.438460] PM: Adding info for No Bus:ptyvb
[   21.438490] PM: Adding info for No Bus:ptyvc
[   21.438519] PM: Adding info for No Bus:ptyvd
[   21.438552] PM: Adding info for No Bus:ptyve
[   21.438584] PM: Adding info for No Bus:ptyvf
[   21.438615] PM: Adding info for No Bus:ptyw0
[   21.438646] PM: Adding info for No Bus:ptyw1
[   21.438676] PM: Adding info for No Bus:ptyw2
[   21.438705] PM: Adding info for No Bus:ptyw3
[   21.438738] PM: Adding info for No Bus:ptyw4
[   21.438768] PM: Adding info for No Bus:ptyw5
[   21.438797] PM: Adding info for No Bus:ptyw6
[   21.438829] PM: Adding info for No Bus:ptyw7
[   21.438859] PM: Adding info for No Bus:ptyw8
[   21.438888] PM: Adding info for No Bus:ptyw9
[   21.438920] PM: Adding info for No Bus:ptywa
[   21.438950] PM: Adding info for No Bus:ptywb
[   21.438981] PM: Adding info for No Bus:ptywc
[   21.439015] PM: Adding info for No Bus:ptywd
[   21.439045] PM: Adding info for No Bus:ptywe
[   21.439075] PM: Adding info for No Bus:ptywf
[   21.439108] PM: Adding info for No Bus:ptyx0
[   21.439139] PM: Adding info for No Bus:ptyx1
[   21.439168] PM: Adding info for No Bus:ptyx2
[   21.439202] PM: Adding info for No Bus:ptyx3
[   21.439233] PM: Adding info for No Bus:ptyx4
[   21.439263] PM: Adding info for No Bus:ptyx5
[   21.439295] PM: Adding info for No Bus:ptyx6
[   21.439326] PM: Adding info for No Bus:ptyx7
[   21.439358] PM: Adding info for No Bus:ptyx8
[   21.439393] PM: Adding info for No Bus:ptyx9
[   21.439424] PM: Adding info for No Bus:ptyxa
[   21.439456] PM: Adding info for No Bus:ptyxb
[   21.439490] PM: Adding info for No Bus:ptyxc
[   21.439522] PM: Adding info for No Bus:ptyxd
[   21.439552] PM: Adding info for No Bus:ptyxe
[   21.439586] PM: Adding info for No Bus:ptyxf
[   21.439620] PM: Adding info for No Bus:ptyy0
[   21.439650] PM: Adding info for No Bus:ptyy1
[   21.439683] PM: Adding info for No Bus:ptyy2
[   21.439715] PM: Adding info for No Bus:ptyy3
[   21.439746] PM: Adding info for No Bus:ptyy4
[   21.439779] PM: Adding info for No Bus:ptyy5
[   21.439809] PM: Adding info for No Bus:ptyy6
[   21.439840] PM: Adding info for No Bus:ptyy7
[   21.439874] PM: Adding info for No Bus:ptyy8
[   21.439905] PM: Adding info for No Bus:ptyy9
[   21.439939] PM: Adding info for No Bus:ptyya
[   21.439971] PM: Adding info for No Bus:ptyyb
[   21.440003] PM: Adding info for No Bus:ptyyc
[   21.440032] PM: Adding info for No Bus:ptyyd
[   21.440065] PM: Adding info for No Bus:ptyye
[   21.440096] PM: Adding info for No Bus:ptyyf
[   21.440129] PM: Adding info for No Bus:ptyz0
[   21.440162] PM: Adding info for No Bus:ptyz1
[   21.440193] PM: Adding info for No Bus:ptyz2
[   21.440223] PM: Adding info for No Bus:ptyz3
[   21.440258] PM: Adding info for No Bus:ptyz4
[   21.440289] PM: Adding info for No Bus:ptyz5
[   21.440321] PM: Adding info for No Bus:ptyz6
[   21.440354] PM: Adding info for No Bus:ptyz7
[   21.440386] PM: Adding info for No Bus:ptyz8
[   21.440418] PM: Adding info for No Bus:ptyz9
[   21.440452] PM: Adding info for No Bus:ptyza
[   21.440483] PM: Adding info for No Bus:ptyzb
[   21.440516] PM: Adding info for No Bus:ptyzc
[   21.440549] PM: Adding info for No Bus:ptyzd
[   21.440580] PM: Adding info for No Bus:ptyze
[   21.440611] PM: Adding info for No Bus:ptyzf
[   21.440645] PM: Adding info for No Bus:ptya0
[   21.440676] PM: Adding info for No Bus:ptya1
[   21.440708] PM: Adding info for No Bus:ptya2
[   21.440743] PM: Adding info for No Bus:ptya3
[   21.440778] PM: Adding info for No Bus:ptya4
[   21.440810] PM: Adding info for No Bus:ptya5
[   21.440844] PM: Adding info for No Bus:ptya6
[   21.440877] PM: Adding info for No Bus:ptya7
[   21.440912] PM: Adding info for No Bus:ptya8
[   21.440946] PM: Adding info for No Bus:ptya9
[   21.440978] PM: Adding info for No Bus:ptyaa
[   21.441009] PM: Adding info for No Bus:ptyab
[   21.441045] PM: Adding info for No Bus:ptyac
[   21.441077] PM: Adding info for No Bus:ptyad
[   21.441110] PM: Adding info for No Bus:ptyae
[   21.441145] PM: Adding info for No Bus:ptyaf
[   21.441178] PM: Adding info for No Bus:ptyb0
[   21.441210] PM: Adding info for No Bus:ptyb1
[   21.441246] PM: Adding info for No Bus:ptyb2
[   21.441278] PM: Adding info for No Bus:ptyb3
[   21.441314] PM: Adding info for No Bus:ptyb4
[   21.441348] PM: Adding info for No Bus:ptyb5
[   21.441387] PM: Adding info for No Bus:ptyb6
[   21.441422] PM: Adding info for No Bus:ptyb7
[   21.441458] PM: Adding info for No Bus:ptyb8
[   21.441491] PM: Adding info for No Bus:ptyb9
[   21.441525] PM: Adding info for No Bus:ptyba
[   21.441559] PM: Adding info for No Bus:ptybb
[   21.441594] PM: Adding info for No Bus:ptybc
[   21.441627] PM: Adding info for No Bus:ptybd
[   21.441661] PM: Adding info for No Bus:ptybe
[   21.441696] PM: Adding info for No Bus:ptybf
[   21.441730] PM: Adding info for No Bus:ptyc0
[   21.441765] PM: Adding info for No Bus:ptyc1
[   21.441797] PM: Adding info for No Bus:ptyc2
[   21.441830] PM: Adding info for No Bus:ptyc3
[   21.441866] PM: Adding info for No Bus:ptyc4
[   21.441902] PM: Adding info for No Bus:ptyc5
[   21.441935] PM: Adding info for No Bus:ptyc6
[   21.441971] PM: Adding info for No Bus:ptyc7
[   21.442005] PM: Adding info for No Bus:ptyc8
[   21.442040] PM: Adding info for No Bus:ptyc9
[   21.442075] PM: Adding info for No Bus:ptyca
[   21.442110] PM: Adding info for No Bus:ptycb
[   21.442145] PM: Adding info for No Bus:ptycc
[   21.442180] PM: Adding info for No Bus:ptycd
[   21.442215] PM: Adding info for No Bus:ptyce
[   21.442248] PM: Adding info for No Bus:ptycf
[   21.442286] PM: Adding info for No Bus:ptyd0
[   21.442320] PM: Adding info for No Bus:ptyd1
[   21.442354] PM: Adding info for No Bus:ptyd2
[   21.442389] PM: Adding info for No Bus:ptyd3
[   21.442426] PM: Adding info for No Bus:ptyd4
[   21.442460] PM: Adding info for No Bus:ptyd5
[   21.442495] PM: Adding info for No Bus:ptyd6
[   21.442530] PM: Adding info for No Bus:ptyd7
[   21.442565] PM: Adding info for No Bus:ptyd8
[   21.442601] PM: Adding info for No Bus:ptyd9
[   21.442634] PM: Adding info for No Bus:ptyda
[   21.442668] PM: Adding info for No Bus:ptydb
[   21.442706] PM: Adding info for No Bus:ptydc
[   21.442741] PM: Adding info for No Bus:ptydd
[   21.442776] PM: Adding info for No Bus:ptyde
[   21.442813] PM: Adding info for No Bus:ptydf
[   21.442849] PM: Adding info for No Bus:ptye0
[   21.442883] PM: Adding info for No Bus:ptye1
[   21.442919] PM: Adding info for No Bus:ptye2
[   21.442955] PM: Adding info for No Bus:ptye3
[   21.442991] PM: Adding info for No Bus:ptye4
[   21.443028] PM: Adding info for No Bus:ptye5
[   21.443064] PM: Adding info for No Bus:ptye6
[   21.443098] PM: Adding info for No Bus:ptye7
[   21.443138] PM: Adding info for No Bus:ptye8
[   21.443174] PM: Adding info for No Bus:ptye9
[   21.443210] PM: Adding info for No Bus:ptyea
[   21.443246] PM: Adding info for No Bus:ptyeb
[   21.443282] PM: Adding info for No Bus:ptyec
[   21.443317] PM: Adding info for No Bus:ptyed
[   21.443354] PM: Adding info for No Bus:ptyee
[   21.443392] PM: Adding info for No Bus:ptyef
[   21.443431] PM: Adding info for No Bus:ttyp0
[   21.443466] PM: Adding info for No Bus:ttyp1
[   21.443498] PM: Adding info for No Bus:ttyp2
[   21.443530] PM: Adding info for No Bus:ttyp3
[   21.443566] PM: Adding info for No Bus:ttyp4
[   21.443599] PM: Adding info for No Bus:ttyp5
[   21.443631] PM: Adding info for No Bus:ttyp6
[   21.443666] PM: Adding info for No Bus:ttyp7
[   21.443700] PM: Adding info for No Bus:ttyp8
[   21.443732] PM: Adding info for No Bus:ttyp9
[   21.443767] PM: Adding info for No Bus:ttypa
[   21.443800] PM: Adding info for No Bus:ttypb
[   21.443835] PM: Adding info for No Bus:ttypc
[   21.443869] PM: Adding info for No Bus:ttypd
[   21.443902] PM: Adding info for No Bus:ttype
[   21.443934] PM: Adding info for No Bus:ttypf
[   21.443969] PM: Adding info for No Bus:ttyq0
[   21.444004] PM: Adding info for No Bus:ttyq1
[   21.444039] PM: Adding info for No Bus:ttyq2
[   21.444073] PM: Adding info for No Bus:ttyq3
[   21.444108] PM: Adding info for No Bus:ttyq4
[   21.444141] PM: Adding info for No Bus:ttyq5
[   21.444177] PM: Adding info for No Bus:ttyq6
[   21.444213] PM: Adding info for No Bus:ttyq7
[   21.444249] PM: Adding info for No Bus:ttyq8
[   21.444285] PM: Adding info for No Bus:ttyq9
[   21.444317] PM: Adding info for No Bus:ttyqa
[   21.444351] PM: Adding info for No Bus:ttyqb
[   21.444388] PM: Adding info for No Bus:ttyqc
[   21.444422] PM: Adding info for No Bus:ttyqd
[   21.444456] PM: Adding info for No Bus:ttyqe
[   21.444492] PM: Adding info for No Bus:ttyqf
[   21.444526] PM: Adding info for No Bus:ttyr0
[   21.444560] PM: Adding info for No Bus:ttyr1
[   21.444597] PM: Adding info for No Bus:ttyr2
[   21.444631] PM: Adding info for No Bus:ttyr3
[   21.444666] PM: Adding info for No Bus:ttyr4
[   21.444703] PM: Adding info for No Bus:ttyr5
[   21.444737] PM: Adding info for No Bus:ttyr6
[   21.444770] PM: Adding info for No Bus:ttyr7
[   21.444807] PM: Adding info for No Bus:ttyr8
[   21.444842] PM: Adding info for No Bus:ttyr9
[   21.444877] PM: Adding info for No Bus:ttyra
[   21.444914] PM: Adding info for No Bus:ttyrb
[   21.444950] PM: Adding info for No Bus:ttyrc
[   21.444985] PM: Adding info for No Bus:ttyrd
[   21.445023] PM: Adding info for No Bus:ttyre
[   21.445058] PM: Adding info for No Bus:ttyrf
[   21.445094] PM: Adding info for No Bus:ttys0
[   21.445131] PM: Adding info for No Bus:ttys1
[   21.445166] PM: Adding info for No Bus:ttys2
[   21.445201] PM: Adding info for No Bus:ttys3
[   21.445240] PM: Adding info for No Bus:ttys4
[   21.445274] PM: Adding info for No Bus:ttys5
[   21.445309] PM: Adding info for No Bus:ttys6
[   21.445346] PM: Adding info for No Bus:ttys7
[   21.445416] PM: Adding info for No Bus:ttys8
[   21.445452] PM: Adding info for No Bus:ttys9
[   21.445491] PM: Adding info for No Bus:ttysa
[   21.445529] PM: Adding info for No Bus:ttysb
[   21.445567] PM: Adding info for No Bus:ttysc
[   21.445605] PM: Adding info for No Bus:ttysd
[   21.445639] PM: Adding info for No Bus:ttyse
[   21.445675] PM: Adding info for No Bus:ttysf
[   21.445714] PM: Adding info for No Bus:ttyt0
[   21.445752] PM: Adding info for No Bus:ttyt1
[   21.445787] PM: Adding info for No Bus:ttyt2
[   21.445825] PM: Adding info for No Bus:ttyt3
[   21.445861] PM: Adding info for No Bus:ttyt4
[   21.445896] PM: Adding info for No Bus:ttyt5
[   21.445933] PM: Adding info for No Bus:ttyt6
[   21.445969] PM: Adding info for No Bus:ttyt7
[   21.446006] PM: Adding info for No Bus:ttyt8
[   21.446043] PM: Adding info for No Bus:ttyt9
[   21.446078] PM: Adding info for No Bus:ttyta
[   21.446114] PM: Adding info for No Bus:ttytb
[   21.446153] PM: Adding info for No Bus:ttytc
[   21.446190] PM: Adding info for No Bus:ttytd
[   21.446228] PM: Adding info for No Bus:ttyte
[   21.446267] PM: Adding info for No Bus:ttytf
[   21.446305] PM: Adding info for No Bus:ttyu0
[   21.446341] PM: Adding info for No Bus:ttyu1
[   21.446379] PM: Adding info for No Bus:ttyu2
[   21.446416] PM: Adding info for No Bus:ttyu3
[   21.446455] PM: Adding info for No Bus:ttyu4
[   21.446494] PM: Adding info for No Bus:ttyu5
[   21.446530] PM: Adding info for No Bus:ttyu6
[   21.446566] PM: Adding info for No Bus:ttyu7
[   21.446606] PM: Adding info for No Bus:ttyu8
[   21.446644] PM: Adding info for No Bus:ttyu9
[   21.446681] PM: Adding info for No Bus:ttyua
[   21.446720] PM: Adding info for No Bus:ttyub
[   21.446759] PM: Adding info for No Bus:ttyuc
[   21.446796] PM: Adding info for No Bus:ttyud
[   21.446838] PM: Adding info for No Bus:ttyue
[   21.446876] PM: Adding info for No Bus:ttyuf
[   21.446914] PM: Adding info for No Bus:ttyv0
[   21.446953] PM: Adding info for No Bus:ttyv1
[   21.446990] PM: Adding info for No Bus:ttyv2
[   21.447027] PM: Adding info for No Bus:ttyv3
[   21.447068] PM: Adding info for No Bus:ttyv4
[   21.447106] PM: Adding info for No Bus:ttyv5
[   21.447143] PM: Adding info for No Bus:ttyv6
[   21.447183] PM: Adding info for No Bus:ttyv7
[   21.447221] PM: Adding info for No Bus:ttyv8
[   21.447258] PM: Adding info for No Bus:ttyv9
[   21.447298] PM: Adding info for No Bus:ttyva
[   21.447336] PM: Adding info for No Bus:ttyvb
[   21.447375] PM: Adding info for No Bus:ttyvc
[   21.447414] PM: Adding info for No Bus:ttyvd
[   21.447451] PM: Adding info for No Bus:ttyve
[   21.447488] PM: Adding info for No Bus:ttyvf
[   21.447530] PM: Adding info for No Bus:ttyw0
[   21.447569] PM: Adding info for No Bus:ttyw1
[   21.447607] PM: Adding info for No Bus:ttyw2
[   21.447647] PM: Adding info for No Bus:ttyw3
[   21.447685] PM: Adding info for No Bus:ttyw4
[   21.447725] PM: Adding info for No Bus:ttyw5
[   21.447765] PM: Adding info for No Bus:ttyw6
[   21.447804] PM: Adding info for No Bus:ttyw7
[   21.447842] PM: Adding info for No Bus:ttyw8
[   21.447883] PM: Adding info for No Bus:ttyw9
[   21.447922] PM: Adding info for No Bus:ttywa
[   21.447963] PM: Adding info for No Bus:ttywb
[   21.448006] PM: Adding info for No Bus:ttywc
[   21.448045] PM: Adding info for No Bus:ttywd
[   21.448083] PM: Adding info for No Bus:ttywe
[   21.448127] PM: Adding info for No Bus:ttywf
[   21.448166] PM: Adding info for No Bus:ttyx0
[   21.448204] PM: Adding info for No Bus:ttyx1
[   21.448244] PM: Adding info for No Bus:ttyx2
[   21.448283] PM: Adding info for No Bus:ttyx3
[   21.448324] PM: Adding info for No Bus:ttyx4
[   21.448366] PM: Adding info for No Bus:ttyx5
[   21.448405] PM: Adding info for No Bus:ttyx6
[   21.448443] PM: Adding info for No Bus:ttyx7
[   21.448487] PM: Adding info for No Bus:ttyx8
[   21.448527] PM: Adding info for No Bus:ttyx9
[   21.448566] PM: Adding info for No Bus:ttyxa
[   21.448608] PM: Adding info for No Bus:ttyxb
[   21.448648] PM: Adding info for No Bus:ttyxc
[   21.448687] PM: Adding info for No Bus:ttyxd
[   21.448728] PM: Adding info for No Bus:ttyxe
[   21.448768] PM: Adding info for No Bus:ttyxf
[   21.448809] PM: Adding info for No Bus:ttyy0
[   21.448851] PM: Adding info for No Bus:ttyy1
[   21.448890] PM: Adding info for No Bus:ttyy2
[   21.448929] PM: Adding info for No Bus:ttyy3
[   21.448971] PM: Adding info for No Bus:ttyy4
[   21.449013] PM: Adding info for No Bus:ttyy5
[   21.449053] PM: Adding info for No Bus:ttyy6
[   21.449096] PM: Adding info for No Bus:ttyy7
[   21.449136] PM: Adding info for No Bus:ttyy8
[   21.449176] PM: Adding info for No Bus:ttyy9
[   21.449218] PM: Adding info for No Bus:ttyya
[   21.449260] PM: Adding info for No Bus:ttyyb
[   21.449302] PM: Adding info for No Bus:ttyyc
[   21.449343] PM: Adding info for No Bus:ttyyd
[   21.449413] PM: Adding info for No Bus:ttyye
[   21.449533] PM: Adding info for No Bus:ttyyf
[   21.449574] PM: Adding info for No Bus:ttyz0
[   21.449614] PM: Adding info for No Bus:ttyz1
[   21.449653] PM: Adding info for No Bus:ttyz2
[   21.449694] PM: Adding info for No Bus:ttyz3
[   21.449732] PM: Adding info for No Bus:ttyz4
[   21.449771] PM: Adding info for No Bus:ttyz5
[   21.449812] PM: Adding info for No Bus:ttyz6
[   21.449852] PM: Adding info for No Bus:ttyz7
[   21.449891] PM: Adding info for No Bus:ttyz8
[   21.449933] PM: Adding info for No Bus:ttyz9
[   21.449971] PM: Adding info for No Bus:ttyza
[   21.450011] PM: Adding info for No Bus:ttyzb
[   21.450052] PM: Adding info for No Bus:ttyzc
[   21.450093] PM: Adding info for No Bus:ttyzd
[   21.450132] PM: Adding info for No Bus:ttyze
[   21.450173] PM: Adding info for No Bus:ttyzf
[   21.450212] PM: Adding info for No Bus:ttya0
[   21.450251] PM: Adding info for No Bus:ttya1
[   21.450292] PM: Adding info for No Bus:ttya2
[   21.450332] PM: Adding info for No Bus:ttya3
[   21.450372] PM: Adding info for No Bus:ttya4
[   21.450414] PM: Adding info for No Bus:ttya5
[   21.450453] PM: Adding info for No Bus:ttya6
[   21.450493] PM: Adding info for No Bus:ttya7
[   21.450535] PM: Adding info for No Bus:ttya8
[   21.450577] PM: Adding info for No Bus:ttya9
[   21.450616] PM: Adding info for No Bus:ttyaa
[   21.450657] PM: Adding info for No Bus:ttyab
[   21.450697] PM: Adding info for No Bus:ttyac
[   21.450736] PM: Adding info for No Bus:ttyad
[   21.450779] PM: Adding info for No Bus:ttyae
[   21.450820] PM: Adding info for No Bus:ttyaf
[   21.450861] PM: Adding info for No Bus:ttyb0
[   21.450904] PM: Adding info for No Bus:ttyb1
[   21.450944] PM: Adding info for No Bus:ttyb2
[   21.450984] PM: Adding info for No Bus:ttyb3
[   21.451027] PM: Adding info for No Bus:ttyb4
[   21.451068] PM: Adding info for No Bus:ttyb5
[   21.451108] PM: Adding info for No Bus:ttyb6
[   21.451151] PM: Adding info for No Bus:ttyb7
[   21.451194] PM: Adding info for No Bus:ttyb8
[   21.451234] PM: Adding info for No Bus:ttyb9
[   21.451277] PM: Adding info for No Bus:ttyba
[   21.451318] PM: Adding info for No Bus:ttybb
[   21.451359] PM: Adding info for No Bus:ttybc
[   21.451402] PM: Adding info for No Bus:ttybd
[   21.451444] PM: Adding info for No Bus:ttybe
[   21.451485] PM: Adding info for No Bus:ttybf
[   21.451528] PM: Adding info for No Bus:ttyc0
[   21.451570] PM: Adding info for No Bus:ttyc1
[   21.451611] PM: Adding info for No Bus:ttyc2
[   21.451653] PM: Adding info for No Bus:ttyc3
[   21.451695] PM: Adding info for No Bus:ttyc4
[   21.451736] PM: Adding info for No Bus:ttyc5
[   21.451779] PM: Adding info for No Bus:ttyc6
[   21.451821] PM: Adding info for No Bus:ttyc7
[   21.451863] PM: Adding info for No Bus:ttyc8
[   21.451906] PM: Adding info for No Bus:ttyc9
[   21.451949] PM: Adding info for No Bus:ttyca
[   21.451993] PM: Adding info for No Bus:ttycb
[   21.452037] PM: Adding info for No Bus:ttycc
[   21.452080] PM: Adding info for No Bus:ttycd
[   21.452121] PM: Adding info for No Bus:ttyce
[   21.452166] PM: Adding info for No Bus:ttycf
[   21.452207] PM: Adding info for No Bus:ttyd0
[   21.452249] PM: Adding info for No Bus:ttyd1
[   21.452293] PM: Adding info for No Bus:ttyd2
[   21.452335] PM: Adding info for No Bus:ttyd3
[   21.452378] PM: Adding info for No Bus:ttyd4
[   21.452422] PM: Adding info for No Bus:ttyd5
[   21.452464] PM: Adding info for No Bus:ttyd6
[   21.452505] PM: Adding info for No Bus:ttyd7
[   21.452551] PM: Adding info for No Bus:ttyd8
[   21.452594] PM: Adding info for No Bus:ttyd9
[   21.452636] PM: Adding info for No Bus:ttyda
[   21.452680] PM: Adding info for No Bus:ttydb
[   21.452724] PM: Adding info for No Bus:ttydc
[   21.452766] PM: Adding info for No Bus:ttydd
[   21.452811] PM: Adding info for No Bus:ttyde
[   21.452855] PM: Adding info for No Bus:ttydf
[   21.452898] PM: Adding info for No Bus:ttye0
[   21.452944] PM: Adding info for No Bus:ttye1
[   21.452987] PM: Adding info for No Bus:ttye2
[   21.453030] PM: Adding info for No Bus:ttye3
[   21.453076] PM: Adding info for No Bus:ttye4
[   21.453120] PM: Adding info for No Bus:ttye5
[   21.453164] PM: Adding info for No Bus:ttye6
[   21.453209] PM: Adding info for No Bus:ttye7
[   21.453253] PM: Adding info for No Bus:ttye8
[   21.453297] PM: Adding info for No Bus:ttye9
[   21.453346] PM: Adding info for No Bus:ttyea
[   21.453393] PM: Adding info for No Bus:ttyeb
[   21.453436] PM: Adding info for No Bus:ttyec
[   21.453482] PM: Adding info for No Bus:ttyed
[   21.453526] PM: Adding info for No Bus:ttyee
[   21.453570] PM: Adding info for No Bus:ttyef
[   21.453611] PM: Adding info for No Bus:rtc
[   21.453645] Real Time Clock Driver v1.12ac
[   21.453707] PM: Adding info for No Bus:hpet
[   21.453902] hpet_resources: 0xfed00000 is busy
[   21.453914] Linux agpgart interface v0.102 (c) Dave Jones
[   21.453972] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sha=
ring enabled
[   21.454059] PM: Adding info for platform:serial8250
[   21.454089] PM: Adding info for No Bus:ttyS0
[   21.454125] PM: Adding info for No Bus:ttyS1
[   21.454160] PM: Adding info for No Bus:ttyS2
[   21.454194] PM: Adding info for No Bus:ttyS3
[   21.454426] PM: Removing info for No Bus:ttyS0
[   21.454523] 00:08: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   21.454605] PM: Adding info for No Bus:ttyS0
[   21.454650] PM: Removing info for No Bus:ttyS1
[   21.454739] 00:09: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
[   21.454814] PM: Adding info for No Bus:ttyS1
[   21.455280] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024=
 blocksize
[   21.455382] PM: Adding info for No Bus:lo
[   21.455417] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   21.455477] ide: Assuming 33MHz system bus speed for PIO modes; override=
 with idebus=3Dxx
[   21.455691] PM: Adding info for No Bus:tgt
[   21.455772] ahci 0000:00:1f.2: version 2.2
[   21.455789] ACPI: PCI Interrupt 0000:00:1f.2[C] -> GSI 20 (level, low) -=
> IRQ 20
[   22.459164] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x=
3f impl SATA mode
[   22.459237] ahci 0000:00:1f.2: flags: 64bit ncq pm led slum part=20
[   22.459298] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[   22.459542] scsi0 : ahci
[   22.459602] PM: Adding info for No Bus:host0
[   22.459643] scsi1 : ahci
[   22.459699] PM: Adding info for No Bus:host1
[   22.459731] scsi2 : ahci
[   22.459788] PM: Adding info for No Bus:host2
[   22.459819] scsi3 : ahci
[   22.459876] PM: Adding info for No Bus:host3
[   22.459909] scsi4 : ahci
[   22.459965] PM: Adding info for No Bus:host4
[   22.459995] scsi5 : ahci
[   22.460051] PM: Adding info for No Bus:host5
[   22.460079] ata1: SATA max UDMA/133 cmd 0xffffc20000010100 ctl 0x0000000=
000000000 bmdma 0x0000000000000000 irq 0
[   22.460153] ata2: SATA max UDMA/133 cmd 0xffffc20000010180 ctl 0x0000000=
000000000 bmdma 0x0000000000000000 irq 0
[   22.460228] ata3: SATA max UDMA/133 cmd 0xffffc20000010200 ctl 0x0000000=
000000000 bmdma 0x0000000000000000 irq 0
[   22.460302] ata4: SATA max UDMA/133 cmd 0xffffc20000010280 ctl 0x0000000=
000000000 bmdma 0x0000000000000000 irq 0
[   22.460377] ata5: SATA max UDMA/133 cmd 0xffffc20000010300 ctl 0x0000000=
000000000 bmdma 0x0000000000000000 irq 0
[   22.460451] ata6: SATA max UDMA/133 cmd 0xffffc20000010380 ctl 0x0000000=
000000000 bmdma 0x0000000000000000 irq 0
[   22.946008] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   22.946621] ata1.00: ata_hpa_resize 1: sectors =3D 488281250, hpa_sector=
s =3D 488281250
[   22.946695] ata1.00: ATA-7: WDC WD2500JS-75NCB3, 10.02E04, max UDMA/133
[   22.946755] ata1.00: 488281250 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   22.947412] ata1.00: ata_hpa_resize 1: sectors =3D 488281250, hpa_sector=
s =3D 488281250
[   22.947486] ata1.00: configured for UDMA/133
[   23.259940] ata2: SATA link down (SStatus 0 SControl 300)
[   23.569300] ata3: SATA link down (SStatus 0 SControl 300)
[   23.883635] ata4: SATA link down (SStatus 0 SControl 300)
[   24.193135] ata5: SATA link down (SStatus 4 SControl 300)
[   24.506888] ata6: SATA link down (SStatus 0 SControl 0)
[   24.506966] PM: Adding info for No Bus:target0:0:0
[   24.507036] scsi 0:0:0:0: Direct-Access     ATA      WDC WD2500JS-75N 10=
=2E0 PQ: 0 ANSI: 5
[   24.507112] PM: Adding info for scsi:0:0:0:0
[   24.507176] sd 0:0:0:0: [sda] 488281250 512-byte hardware sectors (25000=
0 MB)
[   24.507244] sd 0:0:0:0: [sda] Write Protect is off
[   24.507301] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   24.507314] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[   24.507419] sd 0:0:0:0: [sda] 488281250 512-byte hardware sectors (25000=
0 MB)
[   24.507485] sd 0:0:0:0: [sda] Write Protect is off
[   24.507542] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   24.507553] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[   24.507626]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
[   24.575377] sd 0:0:0:0: [sda] Attached SCSI disk
[   24.575500] ata_piix 0000:00:1f.1: version 2.11
[   24.575513] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -=
> IRQ 16
[   24.575644] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[   24.575678] scsi6 : ata_piix
[   24.575738] PM: Adding info for No Bus:host6
[   24.575772] scsi7 : ata_piix
[   24.575828] PM: Adding info for No Bus:host7
[   24.575851] ata7: PATA max UDMA/100 cmd 0x00000000000101f0 ctl 0x0000000=
0000103f6 bmdma 0x000000000001ffa0 irq 14
[   24.575926] ata8: PATA max UDMA/100 cmd 0x0000000000010170 ctl 0x0000000=
000010376 bmdma 0x000000000001ffa8 irq 15
[   24.897874] ata7.00: ATAPI, max UDMA/33
[   25.070421] ata7.00: configured for UDMA/33
[   25.070490] ata8: port disabled. ignoring.
[   25.070515] PM: Adding info for No Bus:target6:0:0
[   25.071984] scsi 6:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GSA-H21N A1=
05 PQ: 0 ANSI: 5
[   25.072059] PM: Adding info for scsi:6:0:0:0
[   25.072154] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 21 (level, low) -=
> IRQ 21
[   25.072284] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   25.072287] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   25.072379] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus =
number 1
[   25.072470] ehci_hcd 0000:00:1d.7: debug port 1
[   25.072529] PCI: cache line size of 32 is not supported by device 0000:0=
0:1d.7
[   25.072536] ehci_hcd 0000:00:1d.7: irq 21, io mem 0xff980800
[   25.076477] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10=
 Dec 2004
[   25.076568] PM: Adding info for usb:usb1
[   25.076622] PM: Adding info for No Bus:usbdev1.1_ep00
[   25.076644] usb usb1: configuration #1 chosen from 1 choice
[   25.076708] PM: Adding info for usb:1-0:1.0
[   25.076732] hub 1-0:1.0: USB hub found
[   25.076792] hub 1-0:1.0: 8 ports detected
[   25.178977] PM: Adding info for No Bus:usbdev1.1_ep81
[   25.179017] USB Universal Host Controller Interface driver v3.0
[   25.179111] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 21 (level, low) -=
> IRQ 21
[   25.179236] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   25.179238] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   25.179318] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 2
[   25.179405] uhci_hcd 0000:00:1d.0: irq 21, io base 0x0000ff80
[   25.179494] PM: Adding info for usb:usb2
[   25.179534] PM: Adding info for No Bus:usbdev2.1_ep00
[   25.179559] usb usb2: configuration #1 chosen from 1 choice
[   25.179621] PM: Adding info for usb:2-0:1.0
[   25.179643] hub 2-0:1.0: USB hub found
[   25.179702] hub 2-0:1.0: 2 ports detected
[   25.283792] PM: Adding info for No Bus:usbdev2.1_ep81
[   25.283836] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 22 (level, low) -=
> IRQ 22
[   25.283951] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   25.283953] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   25.284035] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus =
number 3
[   25.284134] uhci_hcd 0000:00:1d.1: irq 22, io base 0x0000ff60
[   25.284222] PM: Adding info for usb:usb3
[   25.284259] PM: Adding info for No Bus:usbdev3.1_ep00
[   25.284281] usb usb3: configuration #1 chosen from 1 choice
[   25.284344] PM: Adding info for usb:3-0:1.0
[   25.284365] hub 3-0:1.0: USB hub found
[   25.284423] hub 3-0:1.0: 2 ports detected
[   25.388430] PM: Adding info for No Bus:usbdev3.1_ep81
[   25.388474] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -=
> IRQ 18
[   25.388589] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   25.388591] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   25.388684] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus =
number 4
[   25.388773] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ff40
[   25.390223] PM: Adding info for usb:usb4
[   25.390261] PM: Adding info for No Bus:usbdev4.1_ep00
[   25.390283] usb usb4: configuration #1 chosen from 1 choice
[   25.390345] PM: Adding info for usb:4-0:1.0
[   25.390367] hub 4-0:1.0: USB hub found
[   25.390427] hub 4-0:1.0: 2 ports detected
[   25.492726] PM: Adding info for No Bus:usbdev4.1_ep81
[   25.492772] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 23 (level, low) -=
> IRQ 23
[   25.492896] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[   25.492898] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   25.492976] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus =
number 5
[   25.493065] uhci_hcd 0000:00:1d.3: irq 23, io base 0x0000ff20
[   25.493155] PM: Adding info for usb:usb5
[   25.493195] PM: Adding info for No Bus:usbdev5.1_ep00
[   25.493216] usb usb5: configuration #1 chosen from 1 choice
[   25.493279] PM: Adding info for usb:5-0:1.0
[   25.493302] hub 5-0:1.0: USB hub found
[   25.493359] hub 5-0:1.0: 2 ports detected
[   25.597185] PM: Adding info for No Bus:usbdev5.1_ep81
[   25.597230] Initializing USB Mass Storage driver...
[   25.657643] usb 2-1: new full speed USB device using uhci_hcd and addres=
s 2
[   25.812126] PM: Adding info for usb:2-1
[   25.812165] PM: Adding info for No Bus:usbdev2.2_ep00
[   25.812186] usb 2-1: configuration #1 chosen from 1 choice
[   25.815108] PM: Adding info for usb:2-1:1.0
[   25.815134] hub 2-1:1.0: USB hub found
[   25.818100] hub 2-1:1.0: 4 ports detected
[   25.931564] PM: Adding info for No Bus:usbdev2.2_ep81
[   25.931613] usbcore: registered new interface driver usb-storage
[   25.931673] USB Mass Storage support registered.
[   26.134410] usb 2-1.1: new low speed USB device using uhci_hcd and addre=
ss 3
[   26.310029] PM: Adding info for usb:2-1.1
[   26.310075] PM: Adding info for No Bus:usbdev2.3_ep00
[   26.310102] usb 2-1.1: configuration #1 chosen from 1 choice
[   26.324997] PM: Adding info for usb:2-1.1:1.0
[   26.340966] PM: Adding info for No Bus:usbdev2.3_ep81
[   26.340998] PM: Adding info for usb:2-1.1:1.1
[   26.356931] PM: Adding info for No Bus:usbdev2.3_ep82
[   26.566469] usb 2-1.2: new low speed USB device using uhci_hcd and addre=
ss 4
[   26.713152] PM: Adding info for usb:2-1.2
[   26.713198] PM: Adding info for No Bus:usbdev2.4_ep00
[   26.713228] usb 2-1.2: configuration #1 chosen from 1 choice
[   26.716147] PM: Adding info for usb:2-1.2:1.0
[   26.716187] PM: Adding info for No Bus:usbdev2.4_ep81
[   26.720150] usbcore: registered new interface driver libusual
[   26.720302] PNP: No PS/2 controller found. Probing ports directly.
[   26.720399] PM: Adding info for platform:i8042
[   26.722835] serio: i8042 KBD port at 0x60,0x64 irq 1
[   26.722901] PM: Adding info for serio:serio0
[   26.722912] serio: i8042 AUX port at 0x60,0x64 irq 12
[   26.722997] PM: Adding info for serio:serio1
[   26.723025] PM: Adding info for No Bus:psaux
[   26.723058] mice: PS/2 mouse device common for all mice
[   26.723222] TCP cubic registered
[   26.723283] NET: Registered protocol family 1
[   26.723342] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[   26.723441] DECnet: Routing cache hash table of 1024 buckets, 16Kbytes
[   26.723507] NET: Registered protocol family 12
[   26.723718] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[   26.723780] Freeing unused kernel memory: 252k freed
[   26.723964] PM: Adding info for No Bus:vcs1
[   26.723991] PM: Adding info for No Bus:vcsa1
[   26.770118] PM: Adding info for No Bus:vcs2
[   26.770159] PM: Adding info for No Bus:vcsa2
[   26.770397] PM: Removing info for No Bus:vcs2
[   26.770426] PM: Removing info for No Bus:vcsa2
[   26.771334] PM: Adding info for No Bus:vcs2
[   26.771370] PM: Adding info for No Bus:vcsa2
[   26.773175] PM: Removing info for No Bus:vcs2
[   26.773202] PM: Removing info for No Bus:vcsa2
[   26.773862] PM: Adding info for No Bus:vcs2
[   26.773888] PM: Adding info for No Bus:vcsa2
[   26.774391] PM: Removing info for No Bus:vcs2
[   26.774415] PM: Removing info for No Bus:vcsa2
[   26.774851] PM: Adding info for No Bus:vcs3
[   26.774874] PM: Adding info for No Bus:vcsa3
[   26.775105] PM: Removing info for No Bus:vcs3
[   26.775126] PM: Removing info for No Bus:vcsa3
[   26.776026] PM: Adding info for No Bus:vcs3
[   26.776050] PM: Adding info for No Bus:vcsa3
[   26.777841] PM: Removing info for No Bus:vcs3
[   26.777864] PM: Removing info for No Bus:vcsa3
[   26.778523] PM: Adding info for No Bus:vcs3
[   26.778547] PM: Adding info for No Bus:vcsa3
[   26.779038] PM: Removing info for No Bus:vcs3
[   26.779061] PM: Removing info for No Bus:vcsa3
[   26.779481] PM: Adding info for No Bus:vcs4
[   26.779504] PM: Adding info for No Bus:vcsa4
[   26.779729] PM: Removing info for No Bus:vcs4
[   26.779750] PM: Removing info for No Bus:vcsa4
[   26.780653] PM: Adding info for No Bus:vcs4
[   26.780682] PM: Adding info for No Bus:vcsa4
[   26.782460] PM: Removing info for No Bus:vcs4
[   26.782487] PM: Removing info for No Bus:vcsa4
[   26.783145] PM: Adding info for No Bus:vcs4
[   26.783169] PM: Adding info for No Bus:vcsa4
[   26.783673] PM: Removing info for No Bus:vcs4
[   26.783695] PM: Removing info for No Bus:vcsa4
[   26.784130] PM: Adding info for No Bus:vcs5
[   26.784153] PM: Adding info for No Bus:vcsa5
[   26.784382] PM: Removing info for No Bus:vcs5
[   26.784403] PM: Removing info for No Bus:vcsa5
[   26.785300] PM: Adding info for No Bus:vcs5
[   26.785324] PM: Adding info for No Bus:vcsa5
[   26.787265] PM: Removing info for No Bus:vcs5
[   26.787454] PM: Removing info for No Bus:vcsa5
[   26.787795] PM: Adding info for No Bus:vcs5
[   26.787818] PM: Adding info for No Bus:vcsa5
[   26.788315] PM: Removing info for No Bus:vcs5
[   26.788337] PM: Removing info for No Bus:vcsa5
[   26.788755] PM: Adding info for No Bus:vcs6
[   26.788778] PM: Adding info for No Bus:vcsa6
[   26.789021] PM: Removing info for No Bus:vcs6
[   26.789043] PM: Removing info for No Bus:vcsa6
[   26.789949] PM: Adding info for No Bus:vcs6
[   26.789976] PM: Adding info for No Bus:vcsa6
[   26.791709] PM: Removing info for No Bus:vcs6
[   26.791735] PM: Removing info for No Bus:vcsa6
[   26.792390] PM: Adding info for No Bus:vcs6
[   26.792412] PM: Adding info for No Bus:vcsa6
[   26.792905] PM: Removing info for No Bus:vcs6
[   26.792928] PM: Removing info for No Bus:vcsa6
[   26.937002] tg3.c:v3.77 (May 31, 2007)
[   26.937084] ACPI: PCI Interrupt 0000:0b:00.0[A] -> GSI 16 (level, low) -=
> IRQ 16
[   26.937203] PCI: Setting latency timer of device 0000:0b:00.0 to 64
[   26.957813] PM: Adding info for No Bus:eth0
[   26.957905] eth0: Tigon3 [partno(BCM5752KFBG) rev 6002 PHY(5752)] (PCI E=
xpress) 10/100/1000Base-T Ethernet 00:19:b9:0c:9a:43
[   26.958231] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] =
TSOcap[1]
[   26.958301] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[   26.964498] usbcore: registered new interface driver hiddev
[   26.972515] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   26.972591] scsi 6:0:0:0: Attached scsi generic sg1 type 5
[   26.993028] input: Dell Dell USB Keyboard Hub as /class/input/input0
[   26.993101] input: USB HID v1.10 Keyboard [Dell Dell USB Keyboard Hub] o=
n usb-0000:00:1d.0-1.1
[   26.995014] Floppy drive(s): fd0 is 1.44M
[   26.996854] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[   26.996916] Uniform CD-ROM driver Revision: 3.20
[   26.997011] sr 6:0:0:0: Attached scsi CD-ROM sr0
[   27.012874] FDC 0 is a post-1991 82077
[   27.013831] PM: Adding info for platform:floppy.0
[   27.053369] input: Dell Dell USB Keyboard Hub as /class/input/input1
[   27.053455] input: USB HID v1.10 Device [Dell Dell USB Keyboard Hub] on =
usb-0000:00:1d.0-1.1
[   27.071815] input: Dell Premium USB Optical Mouse as /class/input/input2
[   27.071888] input: USB HID v1.11 Mouse [Dell Premium USB Optical Mouse] =
on usb-0000:00:1d.0-1.2
[   27.072051] usbcore: registered new interface driver usbhid
[   27.072110] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   27.313388] kjournald starting.  Commit interval 5 seconds
[   27.313457] EXT3-fs: mounted filesystem with ordered data mode.
[   27.653373] PM: Removing info for No Bus:vcs1
[   27.653398] PM: Removing info for No Bus:vcsa1
[   27.653431] PM: Adding info for No Bus:vcs1
[   27.653442] PM: Adding info for No Bus:vcsa1
[   32.052979] PM: Adding info for No Bus:vcs2
[   32.053002] PM: Adding info for No Bus:vcsa2
[   32.053529] PM: Removing info for No Bus:vcs2
[   32.053541] PM: Removing info for No Bus:vcsa2
[   32.053600] PM: Adding info for No Bus:vcs3
[   32.053610] PM: Adding info for No Bus:vcsa3
[   32.054124] PM: Removing info for No Bus:vcs3
[   32.054133] PM: Removing info for No Bus:vcsa3
[   32.054190] PM: Adding info for No Bus:vcs4
[   32.054200] PM: Adding info for No Bus:vcsa4
[   32.054713] PM: Removing info for No Bus:vcs4
[   32.054723] PM: Removing info for No Bus:vcsa4
[   32.054780] PM: Adding info for No Bus:vcs5
[   32.054789] PM: Adding info for No Bus:vcsa5
[   32.055300] PM: Removing info for No Bus:vcs5
[   32.055313] PM: Removing info for No Bus:vcsa5
[   32.055370] PM: Adding info for No Bus:vcs6
[   32.055380] PM: Adding info for No Bus:vcsa6
[   32.055915] PM: Removing info for No Bus:vcs6
[   32.055925] PM: Removing info for No Bus:vcsa6
[   33.129939] parport_pc 00:07: reported by Plug and Play ACPI
[   33.130078] parport0: PC-style at 0x378 (0x778), irq 7, using FIFO [PCSP=
P,TRISTATE,COMPAT,ECP]
[   33.133529] intel_rng: Firmware space is locked read-only. <4>intel_rng:=
 If you can't or
[   33.133531]  don't want to <4>intel_rng: disable this in firmware setup,=
 and <4>intel_rng: if
[   33.133532]  you are certain that your <4>intel_rng: system has a functi=
onal
[   33.133533]  RNG, try<4>intel_rng: using the 'no_fwh_detect' option.
[   33.148954] PM: Writing back config space on device 0000:0b:00.0 at offs=
et 1 (was 100406, writing 100006)
[   33.228109] PM: Adding info for platform:parport_pc.956
[   33.228152] PM: Removing info for platform:parport_pc.956
[   33.228162] PM: Adding info for platform:parport_pc.888
[   33.228172] PM: Removing info for platform:parport_pc.888
[   33.228178] PM: Adding info for platform:parport_pc.632
[   33.228209] PM: Removing info for platform:parport_pc.632
[   34.427211] PM: Adding info for No Bus:timer
[   34.453754] PM: Adding info for No Bus:seq
[   34.501123] PM: Adding info for No Bus:sequencer
[   34.501349] PM: Adding info for No Bus:sequencer2
[   34.566480] NET: Registered protocol family 17
[   34.641963] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -=
> IRQ 16
[   34.642098] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   34.782777] tg3: eth0: Link is up at 100 Mbps, full duplex.
[   34.782837] tg3: eth0: Flow control is on for TX and on for RX.
[   34.933359] PM: Adding info for No Bus:card0
[   34.933380] PM: Adding info for No Bus:pcmC0D0p
[   34.933404] PM: Adding info for No Bus:pcmC0D0c
[   34.933426] PM: Adding info for No Bus:dsp
[   34.933441] PM: Adding info for No Bus:audio
[   34.933461] PM: Adding info for No Bus:controlC0
[   34.933481] PM: Adding info for No Bus:mixer
[   35.069829] lp0: using parport0 (interrupt-driven).
[   35.140112] Adding 4192924k swap on /dev/disk/by-uuid/98d72f78-d682-4d58=
-bfbf-070e75b2d869.  Priority:-1 extents:1 across:4192924k
[   35.333445] EXT3 FS on sda2, internal journal
[   35.769690] kjournald starting.  Commit interval 5 seconds
[   35.769827] EXT3 FS on sda6, internal journal
[   35.769832] EXT3-fs: mounted filesystem with ordered data mode.
[   35.865064] kjournald starting.  Commit interval 5 seconds
[   35.865213] EXT3 FS on sda8, internal journal
[   35.865217] EXT3-fs: mounted filesystem with ordered data mode.
[   35.894983] kjournald starting.  Commit interval 5 seconds
[   35.895142] EXT3 FS on sda9, internal journal
[   35.895145] EXT3-fs: mounted filesystem with ordered data mode.
[   35.943170] kjournald starting.  Commit interval 5 seconds
[   35.943369] EXT3 FS on sda7, internal journal
[   35.943372] EXT3-fs: mounted filesystem with ordered data mode.
[   36.129792] PM: Adding info for No Bus:vcs2
[   36.129887] PM: Adding info for No Bus:vcsa2
[   36.132346] PM: Removing info for No Bus:vcs2
[   36.132365] PM: Removing info for No Bus:vcsa2
[   36.133029] PM: Adding info for No Bus:vcs2
[   36.133094] PM: Adding info for No Bus:vcsa2
[   36.136909] PM: Removing info for No Bus:vcs2
[   36.136969] PM: Removing info for No Bus:vcsa2
[   36.138349] PM: Adding info for No Bus:vcs3
[   36.138399] PM: Adding info for No Bus:vcsa3
[   36.140273] PM: Removing info for No Bus:vcs3
[   36.140287] PM: Removing info for No Bus:vcsa3
[   36.140947] PM: Adding info for No Bus:vcs3
[   36.141007] PM: Adding info for No Bus:vcsa3
[   36.144776] PM: Removing info for No Bus:vcs3
[   36.144836] PM: Removing info for No Bus:vcsa3
[   36.146223] PM: Adding info for No Bus:vcs4
[   36.146272] PM: Adding info for No Bus:vcsa4
[   36.148142] PM: Removing info for No Bus:vcs4
[   36.148155] PM: Removing info for No Bus:vcsa4
[   36.148775] PM: Adding info for No Bus:vcs4
[   36.148836] PM: Adding info for No Bus:vcsa4
[   36.152718] PM: Removing info for No Bus:vcs4
[   36.152775] PM: Removing info for No Bus:vcsa4
[   36.154106] PM: Adding info for No Bus:vcs5
[   36.154156] PM: Adding info for No Bus:vcsa5
[   36.156591] PM: Removing info for No Bus:vcs5
[   36.156607] PM: Removing info for No Bus:vcsa5
[   36.157264] PM: Adding info for No Bus:vcs5
[   36.157279] PM: Adding info for No Bus:vcsa5
[   36.159477] PM: Removing info for No Bus:vcs5
[   36.159493] PM: Removing info for No Bus:vcsa5
[   36.159634] PM: Adding info for No Bus:vcs6
[   36.159645] PM: Adding info for No Bus:vcsa6
[   36.160152] PM: Removing info for No Bus:vcs6
[   36.160164] PM: Removing info for No Bus:vcsa6
[   36.160798] PM: Adding info for No Bus:vcs6
[   36.160810] PM: Adding info for No Bus:vcsa6
[   36.163029] PM: Removing info for No Bus:vcs6
[   36.163127] PM: Removing info for No Bus:vcsa6
[   36.167368] PM: Adding info for No Bus:vcs2
[   36.167386] PM: Adding info for No Bus:vcsa2
[   36.167938] PM: Removing info for No Bus:vcs2
[   36.167995] PM: Removing info for No Bus:vcsa2
[   36.168171] PM: Adding info for No Bus:vcs3
[   36.168213] PM: Adding info for No Bus:vcsa3
[   36.171864] PM: Removing info for No Bus:vcs3
[   36.171926] PM: Removing info for No Bus:vcsa3
[   36.172872] PM: Adding info for No Bus:vcs4
[   36.172934] PM: Adding info for No Bus:vcsa4
[   36.174944] PM: Removing info for No Bus:vcs4
[   36.174995] PM: Removing info for No Bus:vcsa4
[   36.176304] PM: Adding info for No Bus:vcs5
[   36.176352] PM: Adding info for No Bus:vcsa5
[   36.177022] PM: Removing info for No Bus:vcs5
[   36.177080] PM: Removing info for No Bus:vcsa5
[   36.178522] PM: Adding info for No Bus:vcs6
[   36.178570] PM: Adding info for No Bus:vcsa6
[   36.180770] PM: Removing info for No Bus:vcs6
[   36.180824] PM: Removing info for No Bus:vcsa6
[   38.117008] PM: Adding info for No Bus:vcs4
[   38.117034] PM: Adding info for No Bus:vcsa4
[   38.117133] PM: Adding info for No Bus:vcs5
[   38.117144] PM: Adding info for No Bus:vcsa5
[   38.121181] PM: Adding info for No Bus:vcs2
[   38.121253] PM: Adding info for No Bus:vcsa2
[   38.122798] PM: Adding info for No Bus:vcs3
[   38.122855] PM: Adding info for No Bus:vcsa3
[   38.125199] PM: Adding info for No Bus:vcs6
[   38.125221] PM: Adding info for No Bus:vcsa6
[   38.190048] input: Power Button (FF) as /class/input/input3
[   38.190063] ACPI: Power Button (FF) [PWRF]
[   38.190097] input: Power Button (CM) as /class/input/input4
[   38.190110] ACPI: Power Button (CM) [VBTN]
[   39.702047] tsdev (compaq touchscreen emulation) is scheduled for remova=
l.
[   39.702049] See Documentation/feature-removal-schedule.txt for details.
[   41.246648] PM: Adding info for No Bus:vcs7
[   41.246845] PM: Adding info for No Bus:vcsa7
[   41.420543] PM: Removing info for No Bus:vcs7
[   41.420730] PM: Removing info for No Bus:vcsa7
[   41.469305] PM: Adding info for No Bus:vcs7
[   41.469330] PM: Adding info for No Bus:vcsa7
[   41.833806] mtrr: type mismatch for c0000000,8000000 old: write-back new=
: write-combining
[   42.836712] Bluetooth: Core ver 2.11
[   42.836728] PM: Adding info for platform:bluetooth
[   42.836769] NET: Registered protocol family 31
[   42.836771] Bluetooth: HCI device and connection manager initialized
[   42.836774] Bluetooth: HCI socket layer initialized
[   42.853355] Bluetooth: L2CAP ver 2.8
[   42.853359] Bluetooth: L2CAP socket layer initialized
[   42.871359] Bluetooth: RFCOMM socket layer initialized
[   42.871373] Bluetooth: RFCOMM TTY layer initialized
[   42.871376] Bluetooth: RFCOMM ver 1.8
[   42.951918] PM: Adding info for No Bus:parport0
[   42.953443] ppdev: user-space parallel port driver

--JlJsEFsx9RQyiX4C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-2.6.22-rc4-2-kvm"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.22-rc4-2-kvm
# Fri Jun  8 15:10:24 2007
#
CONFIG_X86_64=y
CONFIG_64BIT=y
CONFIG_X86=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ZONE_DMA32=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_CMPXCHG=y
CONFIG_EARLY_PRINTK=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_DMI=y
CONFIG_AUDIT_ARCH=y
CONFIG_GENERIC_BUG=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# Code maturity level options
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32

#
# General setup
#
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
# CONFIG_IPC_NS is not set
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set
# CONFIG_UTS_NS is not set
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
# CONFIG_CPUSETS is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0

#
# Loadable module support
#
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y

#
# Block layer
#
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_IO_TRACE is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"

#
# Processor type and features
#
CONFIG_X86_PC=y
# CONFIG_X86_VSMP is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_TSC=y
CONFIG_X86_GOOD_APIC=y
CONFIG_MICROCODE=m
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_X86_HT=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_MTRR=y
CONFIG_SMP=y
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_BKL=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_NR_CPUS=4
# CONFIG_HOTPLUG_CPU is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_HPET_TIMER=y
# CONFIG_HPET_EMULATE_RTC is not set
CONFIG_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_START=0x200000
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_K8_NB=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_ISA_DMA_API=y
CONFIG_GENERIC_PENDING_IRQ=y

#
# Power management options
#
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
CONFIG_PM_DEBUG=y
# CONFIG_DISABLE_CONSOLE_SUSPEND is not set
CONFIG_PM_SYSFS_DEPRECATED=y

#
# ACPI (Advanced Configuration and Power Interface) Support
#
CONFIG_ACPI=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_AC=m
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_THERMAL=m
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_ACPI_CPUFREQ=m

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
# CONFIG_X86_SPEEDSTEP_LIB is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_HT_IRQ=y

#
# PCCARD (PCMCIA/CardBus) support
#
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=y
CONFIG_SYSVIPC_COMPAT=y

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=m
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m
CONFIG_IP_DCCP_ACKVEC=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
CONFIG_IP_DCCP_CCID2=m
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=m
CONFIG_IP_DCCP_TFRC_LIB=m
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_CCID3_RTO=100

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_NET_DCCPPROBE=m
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
CONFIG_TIPC=m
# CONFIG_TIPC_ADVANCED is not set
# CONFIG_TIPC_DEBUG is not set
# CONFIG_ATM is not set
CONFIG_BRIDGE=m
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set

#
# QoS and/or fair queueing
#
# CONFIG_NET_SCHED is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_HAMRADIO is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUSB=m
CONFIG_BT_HCIUSB_SCO=y
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIVHCI=m
# CONFIG_AF_RXRPC is not set

#
# Wireless
#
# CONFIG_CFG80211 is not set
# CONFIG_WIRELESS_EXT is not set
# CONFIG_MAC80211 is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set

#
# Connector - unified userspace <-> kernelspace linker
#
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set

#
# Parallel port support
#
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y

#
# Plug and Play support
#
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Block devices
#
CONFIG_BLK_DEV_FD=m
# CONFIG_PARIDE is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
CONFIG_BLK_DEV_DAC960=m
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=65536
CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set

#
# Misc devices
#
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=m
# CONFIG_TIFM_7XX1 is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_BLINK is not set
CONFIG_IDE=y
CONFIG_BLK_DEV_IDE=y

#
# Please see Documentation/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_BLK_DEV_HD_IDE is not set
# CONFIG_BLK_DEV_IDEDISK is not set
# CONFIG_IDEDISK_MULTI_MODE is not set
CONFIG_BLK_DEV_IDECD=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
# CONFIG_BLK_DEV_IDESCSI is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_SHARE_IRQ=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=m
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_IDEDMA_FORCED is not set
# CONFIG_IDEDMA_ONLYDISK is not set
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CY82C693 is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT34X is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=m
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
# CONFIG_IDE_ARM is not set
CONFIG_BLK_DEV_IDEDMA=y
# CONFIG_IDEDMA_IVB is not set
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
# CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set

#
# SCSI low-level drivers
#
CONFIG_ISCSI_TCP=m
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
CONFIG_SATA_MV=m
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# Multi-device support (RAID and LVM)
#
# CONFIG_MD is not set

#
# Fusion MPT device support
#
# CONFIG_FUSION is not set
# CONFIG_FUSION_SPI is not set
# CONFIG_FUSION_FC is not set
# CONFIG_FUSION_SAS is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set

#
# I2O device support
#
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set

#
# Network device support
#
CONFIG_NETDEVICES=y
CONFIG_DUMMY=m
# CONFIG_BONDING is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set

#
# Ethernet (10 or 100Mbit)
#
# CONFIG_NET_ETHERNET is not set
CONFIG_MII=m
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
CONFIG_E1000=m
CONFIG_E1000_NAPI=y
# CONFIG_E1000_DISABLE_PACKET_SPLIT is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_SK98LIN is not set
CONFIG_VIA_VELOCITY=m
CONFIG_TIGON3=m
CONFIG_BNX2=m
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET_MII is not set
# CONFIG_USB_USBNET is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PLIP is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
# CONFIG_SHAPER is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set

#
# ISDN subsystem
#
# CONFIG_ISDN is not set

#
# Telephony Support
#
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_TSDEV=m
CONFIG_INPUT_TSDEV_SCREEN_X=240
CONFIG_INPUT_TSDEV_SCREEN_Y=320
CONFIG_INPUT_EVDEV=m
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PARKBD=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=48
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
# CONFIG_TIPAR is not set

#
# IPMI
#
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
# CONFIG_WATCHDOG is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_GEODE is not set
CONFIG_NVRAM=m
CONFIG_RTC=y
CONFIG_R3964=m
# CONFIG_APPLICOM is not set
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=m
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_DRM=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
# CONFIG_HPET_RTC_IRQ is not set
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m

#
# TPM devices
#
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_I810 is not set
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_ISA=m
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PARPORT is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_PROSAVAGE is not set
# CONFIG_I2C_SAVAGE4 is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set
# CONFIG_I2C_VOODOO3 is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_SENSORS_DS1337 is not set
# CONFIG_SENSORS_DS1374 is not set
# CONFIG_SENSORS_EEPROM is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set

#
# Dallas's 1-wire bus
#
# CONFIG_W1 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_FSCHER=m
CONFIG_SENSORS_FSCPOS=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_MAX1619=m
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_HDAPS=m
CONFIG_SENSORS_APPLESMC=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_CAPTURE_DRIVERS is not set
# CONFIG_RADIO_ADAPTERS is not set
# CONFIG_DVB_CORE is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_BACKLIGHT_PROGEAR is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set
CONFIG_VGASTATE=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_SYS_FOPS is not set
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
CONFIG_FB_VGA16=m
CONFIG_FB_VESA=y
# CONFIG_FB_HECUBA is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=y
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=m
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y

#
# Sound
#
CONFIG_SOUND=m

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_RTCTIMER=m
CONFIG_SND_SEQ_RTCTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
# CONFIG_SND_PORTMAN2X4 is not set

#
# PCI devices
#
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_AC97_POWER_SAVE is not set

#
# USB devices
#
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set

#
# System on Chip audio support
#
# CONFIG_SND_SOC is not set

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m

#
# HID Devices
#
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set

#
# USB Input Devices
#
CONFIG_USB_HID=m
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
CONFIG_USB_HIDDEV=y

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set

#
# USB support
#
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_SPLIT_ISO=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_EHCI_BIG_ENDIAN_MMIO is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_DPCM=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_MON is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set

#
# USB Serial Converter support
#
CONFIG_USB_SERIAL=m
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_AIRPRIME=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP2101=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_FUNSOFT=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KEYSPAN_MPR=y
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XA=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XB=y
CONFIG_USB_SERIAL_KEYSPAN_USA19=y
CONFIG_USB_SERIAL_KEYSPAN_USA18X=y
CONFIG_USB_SERIAL_KEYSPAN_USA19W=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QI=y
CONFIG_USB_SERIAL_KEYSPAN_USA49W=y
CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=y
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_DEBUG=m
CONFIG_USB_EZUSB=y

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_AUERSWALD is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set

#
# USB DSL modem support
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set

#
# LED devices
#
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set

#
# InfiniBand support
#
# CONFIG_INFINIBAND is not set

#
# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
#
# CONFIG_EDAC is not set

#
# Real Time Clock
#
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#

#
# DMA Engine support
#
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y

#
# DMA Devices
#
CONFIG_INTEL_IOATDMA=y

#
# Auxiliary Display support
#
# CONFIG_KS0108 is not set
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=m

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_SECURITY=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_DNOTIFY=y
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_RAMFS=y
CONFIG_CONFIGFS_FS=y

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=m
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set

#
# Network File Systems
#
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=y
CONFIG_NFS_DIRECTIO=y
CONFIG_NFSD=m
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
CONFIG_NFSD_V4=y
CONFIG_NFSD_TCP=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
# CONFIG_SUNRPC_BIND34 is not set
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_RPCSEC_GSS_SPKM3=m
# CONFIG_SMB_FS is not set
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
CONFIG_CIFS_XATTR=y
# CONFIG_CIFS_POSIX is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=m

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y

#
# Native Language Support
#
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="cp437"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y

#
# Distributed Lock Manager
#
# CONFIG_DLM is not set

#
# Instrumentation Support
#
CONFIG_PROFILING=y
CONFIG_OPROFILE=m
CONFIG_KPROBES=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_SLAB is not set
CONFIG_DEBUG_PREEMPT=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_FRAME_POINTER is not set
# CONFIG_FORCED_INLINING is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY is not set

#
# Cryptographic options
#
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_LRW=m
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_TEST is not set

#
# Hardware crypto devices
#

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=m
CONFIG_ZLIB_DEFLATE=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--JlJsEFsx9RQyiX4C--

--hD6P3ib1XCFtz2ni
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGacKIND0rFCN2b1sRApQfAKCbQfTqTsNZF38MsisIshbWYJsjswCeI5pV
aNAUIP34ls5IPxsYwe1/qdk=
=Zs81
-----END PGP SIGNATURE-----

--hD6P3ib1XCFtz2ni--
