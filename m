Return-Path: <linux-kernel-owner+w=401wt.eu-S1758510AbXLPAGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510AbXLPAGW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 19:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbXLPAGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 19:06:11 -0500
Received: from hades.rz.tu-clausthal.de ([139.174.2.20]:64297 "EHLO
	hades.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbXLPAGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 19:06:07 -0500
From: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
To: linux-kernel@vger.kernel.org
Subject: almost daily Kernel oops with 2.6.23.9
Date: Sun, 16 Dec 2007 01:06:00 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ovGZHcC5JBYVmHO"
Message-Id: <200712160106.00464.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_ovGZHcC5JBYVmHO
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

for some time I experience almost daily kernel oops.

At first I suspected the nvidia driver, but today I got it without the driv=
er=20
loaded (kernel modul removed from harddisk, nv set in config).
This is a pretty much 'vanilla' kernel.org kernel. Only patch added is for=
=20
reiser4 support.

When this happens, ps aux is stuck. The process mentioned in the oops is st=
uck=20
too. This happens completly unrelated to the load or temperature of the=20
system.

It is a little bit hard to reproduce. Some days I don't get the oops, on ot=
her=20
days I get two. The only thing I can say for sure: with 2.6.21 this did not=
=20
happen and I can not remember any problems with 2.6.22.
 If the oops happens the system usually has had run for several hours.
Sometimes it is kmail which triggers it, sometimes kio_http, emerge... Kern=
el=20
is 'freshly' built to add  CONFIG_KALLSYM which I have usually disabled.


[ 8763.521595] Unable to handle kernel paging request at ffff910073e22db0 R=
IP:
[ 8763.521600]  [<ffffffff8044246a>] _spin_lock+0x0/0xf
[ 8763.521606] PGD 0
[ 8763.521608] Oops: 0002 [1] SMP
[ 8763.521610] CPU 1
[ 8763.521611] Modules linked in: isofs snd_usb_audio snd_usb_lib k8temp=20
w83627ehf hwmon_vid hwmon i2c_core snd_seq_midi snd_emu10k1_synth=20
snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_pcm_oss snd_mixer_oss=
=20
snd_seq_oss snd_seq_midi_event snd_seq snd_emu10k1 snd_rawmidi snd_ac97_cod=
ec=20
ac97_bus snd_pcm snd_seq_device snd_timer snd_page_alloc snd_util_mem=20
snd_hwdep snd r8169
[ 8763.521626] Pid: 10497, comm: emerge Not tainted 2.6.23.9reiser4 #4
[ 8763.521628] RIP: 0010:[<ffffffff8044246a>]  [<ffffffff8044246a>]=20
_spin_lock+0x0/0xf
[ 8763.521631] RSP: 0018:ffff81005e185e10  EFLAGS: 00010282
[ 8763.521632] RAX: ffff81005e485f00 RBX: ffff910073e22db0 RCX:=20
0000000000000000
[ 8763.521634] RDX: 0000000000000000 RSI: ffff810040aeb3d8 RDI:=20
ffff910073e22db0
[ 8763.521635] RBP: ffff81005e485f00 R08: 800000007f3c2005 R09:=20
000000000003ccd0
[ 8763.521637] R10: ffff81000250d820 R11: 0000000000000001 R12:=20
ffff81003a3b3820
[ 8763.521638] R13: ffff81007e610f00 R14: ffff810040aeb330 R15:=20
ffff81007e610f00
[ 8763.521640] FS:  00002b2dce7a9140(0000) GS:ffff81007ff3bec0(0000)=20
knlGS:00000000f7b83b80
[ 8763.521642] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8763.521644] CR2: ffff910073e22db0 CR3: 000000003ba69000 CR4:=20
00000000000006e0
[ 8763.521645] DR0: 0000000000000000 DR1: 0000000000000000 DR2:=20
0000000000000000
[ 8763.521647] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:=20
0000000000000400
[ 8763.521649] Process emerge (pid: 10497, threadinfo ffff81005e184000, tas=
k=20
ffff8100580bb080)
[ 8763.521650] Stack:  ffffffff8026b048 0000000000000001 ffff81005e485f00=20
0000000000000001
[ 8763.521654]  ffffffff80230d0c 00002b2dce7a91d0 0000000000000000=20
ffff81005e185f58
[ 8763.521656]  00007fffdc32be90 0000000001200011 0000000000000000=20
ffff81003a3b3820
[ 8763.521658] Call Trace:
[ 8763.521662]  [<ffffffff8026b048>] anon_vma_link+0x1a/0x40
[ 8763.521666]  [<ffffffff80230d0c>] copy_process+0xb03/0x1301
[ 8763.521671]  [<ffffffff80231670>] do_fork+0xb1/0x1fc
[ 8763.521675]  [<ffffffff8020b66e>] system_call+0x7e/0x83
[ 8763.521677]  [<ffffffff8020b987>] ptregscall_common+0x67/0xb0
[ 8763.521681]
[ 8763.521682]
[ 8763.521682] Code: f0 ff 0f 79 09 f3 90 83 3f 00 7e f9 eb f2 c3 f0 81 2f =
00=20
00
[ 8763.521688] RIP  [<ffffffff8044246a>] _spin_lock+0x0/0xf
[ 8763.521690]  RSP <ffff81005e185e10>
[ 8763.521691] CR2: ffff910073e22db0

dmesg:
[    0.000000] Linux version 2.6.23.9reiser4 (root@energy) (gcc version 4.2=
=2E2=20
(Gentoo 4.2.2 p1.0)) #4 SMP Sat Dec 15 20:06:33 CET 2007
[    0.000000] Command line: root=3D/dev/sda3 nmi_watchdog=3D0
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007ffb0000 (usable)
[    0.000000]  BIOS-e820: 000000007ffb0000 - 000000007ffc0000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007ffc0000 - 000000007fff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007fff0000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff380000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 524208) 1 entries of 256 u=
sed
[    0.000000] end_pfn_map =3D 1048576
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000FA530, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT 7FFB0000, 003C (r1 A M I  OEMRSDT   9000720 MSFT =
     =20
97)
[    0.000000] ACPI: FACP 7FFB0200, 0084 (r2 A_M_I  OEMFACP  12000601 MSFT =
     =20
97)
[    0.000000] ACPI: DSDT 7FFB0450, 4FFA (r1  ASR19 ASR1915A      15A INTL=
=20
20051117)
[    0.000000] ACPI: FACS 7FFC0000, 0040
[    0.000000] ACPI: APIC 7FFB0390, 0080 (r1 A M I  OEMAPIC   9000720 MSFT =
     =20
97)
[    0.000000] ACPI: MCFG 7FFB0410, 003C (r1 A M I  OEMMCFG   9000720 MSFT =
     =20
97)
[    0.000000] ACPI: OEMB 7FFC0040, 0060 (r1 A M I  AMI_OEM   9000720 MSFT =
     =20
97)
[    0.000000] ACPI: HPET 7FFB5450, 0038 (r1 A M I  OEMHPET0  9000720 MSFT =
     =20
97)
[    0.000000] ACPI: SSDT 7FFB5490, 030E (r1 A M I  POWERNOW        1 AMD  =
      =20
1)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 524208) 1 entries of 256 u=
sed
[    0.000000] No mptable found.
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   524208
[    0.000000] On node 0 totalpages: 524111
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1038 pages reserved
[    0.000000]   DMA zone: 2905 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7110 pages used for memmap
[    0.000000]   DMA32 zone: 513002 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x2008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] swsusp: Registered nosave memory region: 000000000009f000 -=
=20
00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 -=
=20
00000000000e6000
[    0.000000] swsusp: Registered nosave memory region: 00000000000e6000 -=
=20
0000000000100000
[    0.000000] Allocating PCI resources starting at 88000000 (gap:=20
80000000:7ec00000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 29608 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order.  Total pages: 515907
[    0.000000] Kernel command line: root=3D/dev/sda3 nmi_watchdog=3D0
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[   30.860942] time.c: Detected 3013.887 MHz processor.
[   30.865131] Console: colour VGA+ 80x25
[   30.865134] console [tty0] enabled
[   30.876134] Dentry cache hash table entries: 262144 (order: 9, 2097152=20
bytes)
[   30.877449] Inode-cache hash table entries: 131072 (order: 8, 1048576=20
bytes)
[   30.877821] Checking aperture...
[   30.877980] CPU 0: aperture @ e888000000 size 32 MB
[   30.878137] Aperture too small (32 MB)
[   30.883953] No AGP bridge found
[   30.895855] Memory: 2059832k/2096832k available (2324k kernel code, 3632=
0k=20
reserved, 950k data, 180k init)
[   30.977505] Calibrating delay using timer specific routine.. 6034.61=20
BogoMIPS (lpj=3D10053777)
[   30.977857] Mount-cache hash table entries: 256
[   30.978095] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64=20
bytes/line)
[   30.978256] CPU: L2 Cache: 1024K (64 bytes/line)
[   30.978415] CPU: Physical Processor ID: 0
[   30.978573] CPU: Processor Core ID: 0
[   30.978747] SMP alternatives: switching to UP code
[   30.979293] ACPI: Core revision 20070126
[   31.014735] Using local APIC timer interrupts.
[   31.048000] result 12557871
[   31.048155] Detected 12.557 MHz APIC timer.
[   31.050745] SMP alternatives: switching to SMP code
[   31.051103] Booting processor 1/2 APIC 0x1
[   31.061408] Initializing CPU#1
[   31.143888] Calibrating delay using timer specific routine.. 6030.02=20
BogoMIPS (lpj=3D10046434)
[   31.143893] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64=20
bytes/line)
[   31.143894] CPU: L2 Cache: 1024K (64 bytes/line)
[   31.143896] CPU: Physical Processor ID: 0
[   31.143897] CPU: Processor Core ID: 1
[   31.143979] AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[   31.147126] Brought up 2 CPUs
[   31.148720] NET: Registered protocol family 16
[   31.148962] ACPI: bus type pci registered
[   31.149170] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[   31.149331] PCI: Not using MMCONFIG.
[   31.149488] PCI: Using configuration type 1
[   31.152045] ACPI: EC: Look up EC in DSDT
[   31.155660] ACPI: Interpreter enabled
[   31.155818] ACPI: (supports S0 S1 S3 S4 S5)
[   31.156106] ACPI: Using IOAPIC for interrupt routing
[   31.156447] Error attaching device data
[   31.156608] Error attaching device data
[   31.156768] Error attaching device data
[   31.156929] Error attaching device data
[   31.162533] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   31.163163] PCI: Transparent bridge - 0000:00:08.0
[   31.163591] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   31.163732] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[   31.163838] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[   31.163898] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[   31.163957] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[   31.164016] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[   31.168099] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *5
[   31.168556] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *10
[   31.169011] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0,=20
disabled.
[   31.169491] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *11
[   31.169946] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0,=20
disabled.
[   31.170427] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[   31.170883] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0,=20
disabled.
[   31.171363] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
[   31.171819] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
[   31.172274] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0,=20
disabled.
[   31.172755] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[   31.173210] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0,=20
disabled.
[   31.173691] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0,=20
disabled.
[   31.174186] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[   31.174642] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0,=20
disabled.
[   31.175122] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *15
[   31.175577] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0,=20
disabled.
[   31.176082] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0,=20
disabled.
[   31.176563] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *0,=20
disabled.
[   31.177044] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *0,=20
disabled.
[   31.177501] Linux Plug and Play Support v0.97 (c) Adam Belay
[   31.177674] pnp: PnP ACPI init
[   31.177835] ACPI: bus type pnp registered
[   31.180623] pnp: PnP ACPI: found 13 devices
[   31.180782] ACPI: ACPI bus type pnp unregistered
[   31.181044] SCSI subsystem initialized
[   31.181223] libata version 2.21 loaded.
[   31.181275] usbcore: registered new interface driver usbfs
[   31.181453] usbcore: registered new interface driver hub
[   31.181631] usbcore: registered new device driver usb
[   31.181825] PCI: Using ACPI for IRQ routing
[   31.181984] PCI: If a device doesn't work, try "pci=3Drouteirq".  If it=
=20
helps, post a report
[   31.193725] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[   31.193982] hpet0: 3 32-bit timers, 25000000 Hz
[   31.197104] Time: hpet clocksource has been installed.
[   31.203675] pnp: 00:05: iomem range 0x0-0x0 could not be reserved
[   31.203837] pnp: 00:05: iomem range 0xfee01000-0xfeefffff has been reser=
ved
[   31.204001] pnp: 00:07: iomem range 0xfec00000-0xfec00fff could not be=20
reserved
[   31.204291] pnp: 00:07: iomem range 0xfee00000-0xfee00fff could not be=20
reserved
[   31.204585] pnp: 00:0a: ioport range 0x290-0x29f has been reserved
[   31.204747] pnp: 00:0b: iomem range 0xe0000000-0xefffffff has been reser=
ved
[   31.204909] pnp: 00:0c: iomem range 0x0-0x9ffff could not be reserved
[   31.205069] pnp: 00:0c: iomem range 0xc0000-0xcffff has been reserved
[   31.205230] pnp: 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[   31.205391] pnp: 00:0c: iomem range 0x100000-0x7fffffff could not be=20
reserved
[   31.205724] PCI: Bridge: 0000:00:08.0
[   31.205882]   IO window: d000-dfff
[   31.206041]   MEM window: f9f00000-f9ffffff
[   31.206200]   PREFETCH window: 88000000-880fffff
[   31.206359] PCI: Bridge: 0000:00:0b.0
[   31.206517]   IO window: c000-cfff
[   31.206675]   MEM window: f9e00000-f9efffff
[   31.206833]   PREFETCH window: disabled.
[   31.206993] PCI: Bridge: 0000:00:0c.0
[   31.207150]   IO window: disabled.
[   31.207308]   MEM window: disabled.
[   31.207466]   PREFETCH window: disabled.
[   31.207624] PCI: Bridge: 0000:00:0d.0
[   31.207782]   IO window: e000-efff
[   31.207939]   MEM window: fa000000-febfffff
[   31.208097]   PREFETCH window: d0000000-dfffffff
[   31.208255] PCI: Bridge: 0000:00:0e.0
[   31.208413]   IO window: disabled.
[   31.208570]   MEM window: disabled.
[   31.208728]   PREFETCH window: disabled.
[   31.208891] PCI: Setting latency timer of device 0000:00:08.0 to 64
[   31.208897] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   31.208902] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   31.208907] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   31.208911] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   31.208930] NET: Registered protocol family 2
[   31.246914] IP route cache hash table entries: 65536 (order: 7, 524288=20
bytes)
[   31.247469] TCP established hash table entries: 131072 (order: 9, 314572=
8=20
bytes)
[   31.248924] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   31.252802] TCP: Hash tables configured (established 131072 bind 65536)
[   31.252963] TCP reno registered
[   31.264399] Total HugeTLB memory allocated, 0
[   31.264639] Loading Reiser4. See www.namesys.com for a description of=20
Reiser4.
[   31.264998] io scheduler noop registered
[   31.265165] io scheduler cfq registered (default)
[   31.266123] Boot video device is 0000:04:00.0
[   31.266243] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   31.266259] assign_interrupt_mode Found MSI capability
[   31.266434] Allocate Port Service[0000:00:0b.0:pcie00]
[   31.266477] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   31.266492] assign_interrupt_mode Found MSI capability
[   31.266660] Allocate Port Service[0000:00:0c.0:pcie00]
[   31.266698] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   31.266712] assign_interrupt_mode Found MSI capability
[   31.266880] Allocate Port Service[0000:00:0d.0:pcie00]
[   31.266917] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   31.266932] assign_interrupt_mode Found MSI capability
[   31.267106] Allocate Port Service[0000:00:0e.0:pcie00]
[   31.267273] input: Power Button (FF) as /class/input/input0
[   31.267433] ACPI: Power Button (FF) [PWRF]
[   31.267644] input: Power Button (CM) as /class/input/input1
[   31.267804] ACPI: Power Button (CM) [PWRB]
[   31.268072] ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processo=
r=20
Device is not present [20070126]
[   31.268419] ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processo=
r=20
Device is not present [20070126]
[   31.272588] Real Time Clock Driver v1.12ac
[   31.272827] hpet_resources: 0xfed00000 is busy
[   31.272838] Linux agpgart interface v0.102
[   31.272997] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 secon=
ds,=20
margin is 60 seconds).
[   31.273288] Hangcheck: Using get_cycles().
[   31.273505] tun: Universal TUN/TAP device driver, 1.6
[   31.273667] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   31.273847] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   31.274008] ide: Assuming 33MHz system bus speed for PIO modes; override=
=20
with idebus=3Dxx
[   31.274322] NFORCE-MCP65: IDE controller at PCI slot 0000:00:09.0
[   31.274490] NFORCE-MCP65: chipset revision 161
[   31.274647] NFORCE-MCP65: not 100% native mode: will probe irqs later
[   31.274810] NFORCE-MCP65: 0000:00:09.0 (rev a1) UDMA133 controller
[   31.274973]     ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA,=20
hdb:pio
[   31.275318] Probing IDE interface ide0...
[   31.563038] hda: SAMSUNG SP1213N, ATA DISK drive
[   32.204893] hda: selected mode 0x45
[   32.204959] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   32.207566] hda: max request size: 512KiB
[   32.207776] hda: 234493056 sectors (120060 MB) w/8192KiB Cache,=20
CHS=3D16383/255/63, UDMA(100)
[   32.208548] hda: cache flushes supported
[   32.208724]  hda: hda1 hda2 hda3 < hda5 hda6 hda7 >
[   32.252230] ahci 0000:00:0a.0: version 2.3
[   32.252405] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[   32.252569] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23=
=20
(level, low) -> IRQ 23
[   33.255804] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0x=
f=20
impl IDE mode
[   33.256100] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio=20
[   33.256261] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   33.256475] scsi0 : ahci
[   33.256700] scsi1 : ahci
[   33.256891] scsi2 : ahci
[   33.257083] scsi3 : ahci
[   33.257265] ata1: SATA max UDMA/133 cmd 0xffffc20000020100 ctl=20
0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   33.257558] ata2: SATA max UDMA/133 cmd 0xffffc20000020180 ctl=20
0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   33.257851] ata3: SATA max UDMA/133 cmd 0xffffc20000020200 ctl=20
0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   33.258144] ata4: SATA max UDMA/133 cmd 0xffffc20000020280 ctl=20
0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   38.733347] ata1: port is slow to respond, please be patient (Status 0xd=
0)
[   43.579086] ata1: softreset failed (device not ready)
[   44.054683] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   44.055482] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   44.055643] ata1.00: 312581808 sectors, multi 16: LBA48=20
[   44.056388] ata1.00: configured for UDMA/133
[   44.370635] ata2: SATA link down (SStatus 0 SControl 300)
[   44.686590] ata3: SATA link down (SStatus 0 SControl 300)
[   45.002543] ata4: SATA link down (SStatus 0 SControl 300)
[   45.002855] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10=
=2E0=20
PQ: 0 ANSI: 5
[   45.003212] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2=20
MB)
[   45.003378] sd 0:0:0:0: [sda] Write Protect is off
[   45.003537] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   45.003546] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   45.003860] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2=20
MB)
[   45.004025] sd 0:0:0:0: [sda] Write Protect is off
[   45.004183] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   45.004191] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   45.004484]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   45.046817] sd 0:0:0:0: [sda] Attached SCSI disk
[   45.047020] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   45.047202] usbmon: debugfs is not available
[   45.047600] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[   45.047765] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 22=
=20
(level, low) -> IRQ 22
[   45.048343] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   45.048347] ehci_hcd 0000:00:02.1: EHCI Host Controller
[   45.048599] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus=
=20
number 1
[   45.048910] ehci_hcd 0000:00:02.1: debug port 1
[   45.049070] PCI: cache line size of 64 is not supported by device=20
0000:00:02.1
[   45.049078] ehci_hcd 0000:00:02.1: irq 22, io mem 0xf9dfec00
[   45.049249] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10=
=20
Dec 2004
[   45.049647] usb usb1: configuration #1 chosen from 1 choice
[   45.049834] hub 1-0:1.0: USB hub found
[   45.049995] hub 1-0:1.0: 10 ports detected
[   45.155677] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHC=
I)=20
Driver
[   45.155904] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 21
[   45.156070] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUB0] -> GSI 21=
=20
(level, low) -> IRQ 21
[   45.156551] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   45.156555] ohci_hcd 0000:00:02.0: OHCI Host Controller
[   45.156796] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus=
=20
number 2
[   45.157101] ohci_hcd 0000:00:02.0: irq 21, io mem 0xf9dff000
[   45.214253] usb usb2: configuration #1 chosen from 1 choice
[   45.214440] hub 2-0:1.0: USB hub found
[   45.214602] hub 2-0:1.0: 10 ports detected
[   45.318648] Initializing USB Mass Storage driver...
[   45.385017] usb 1-3: new high speed USB device using ehci_hcd and addres=
s 2
[   45.519386] usb 1-3: configuration #1 chosen from 1 choice
[   45.519849] hub 1-3:1.0: USB hub found
[   45.520326] hub 1-3:1.0: 4 ports detected
[   46.083539] usb 1-5: new high speed USB device using ehci_hcd and addres=
s 4
[   46.219320] usb 1-5: configuration #1 chosen from 1 choice
[   46.459366] usb 2-4: new full speed USB device using ohci_hcd and addres=
s 2
[   46.616086] usb 2-4: configuration #1 chosen from 1 choice
[   46.622040] hub 2-4:1.0: USB hub found
[   46.625010] hub 2-4:1.0: 4 ports detected
[   46.966245] usb 2-4.1: new full speed USB device using ohci_hcd and addr=
ess=20
3
[   47.101005] usb 2-4.1: configuration #1 chosen from 1 choice
[   47.325442] usb 2-4.4: new low speed USB device using ohci_hcd and addre=
ss=20
4
[   47.439245] usb 2-4.4: configuration #1 chosen from 1 choice
[   47.446182] usbcore: registered new interface driver usb-storage
[   47.446342] USB Mass Storage support registered.
[   47.446545] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x6=
4=20
irq 1,12
[   47.449605] serio: i8042 KBD port at 0x60,0x64 irq 1
[   47.449766] serio: i8042 AUX port at 0x60,0x64 irq 12
[   47.450011] mice: PS/2 mouse device common for all mice
[   47.457273] input: Logitech USB-PS/2 Optical Mouse as /class/input/input2
[   47.457473] input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse]=
 on=20
usb-0000:00:02.0-4.4
[   47.457820] usbcore: registered new interface driver usbhid
[   47.457979] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   47.458164] TCP cubic registered
[   47.458329] NET: Registered protocol family 1
[   47.458488] NET: Registered protocol family 17
[   47.458661] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processo=
r=20
6000+ processors (2 cpu cores) (version 2.00.00)
[   47.458896] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[   47.459057] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[   47.459217] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[   47.459385] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[   47.459545] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[   47.459705] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[   47.459864] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[   47.460023] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[   47.473477] input: AT Translated Set 2 keyboard as /class/input/input3
[   47.585999] ReiserFS: sda3: found reiserfs format "3.6" with standard=20
journal
[   47.586163] ReiserFS: sda3: using ordered data mode
[   47.595573] ReiserFS: sda3: journal params: device sda3, size 8192, jour=
nal=20
first block 18, max trans len 1024, max batch 900, max commit age 30, max=20
trans age 30
[   47.597024] ReiserFS: sda3: checking transaction log (sda3)
[   47.639879] ReiserFS: sda3: Using r5 hash to sort names
[   47.640052] VFS: Mounted root (reiserfs filesystem) readonly.
[   47.640224] Freeing unused kernel memory: 180k freed
[   52.296004] ReiserFS: sda3: switching to journaled data mode
[   52.661837] r8169 Gigabit Ethernet driver 2.2LK loaded
[   52.662119] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[   52.662127] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI 19=
=20
(level, low) -> IRQ 19
[   52.662143] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   52.662318] eth0: RTL8168b/8111b at 0xffffc20000176000, 00:19:66:47:f3:c=
b,=20
XID 38000000 IRQ 19
[   53.079405] reiser4: sda5: found disk format 4.0.0.
[   58.429182] reiser4: sda6: found disk format 4.0.0.
[   59.790443] reiser4: hda7: found disk format 4.0.0.
[   60.459639] Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1=20
across:1951888k
[   63.394904] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 18
[   63.394914] ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKB] -> GSI 18=
=20
(level, low) -> IRQ 18
[   63.397618] Audigy2 value: Special config.
[   64.938749] hda: selected mode 0x45
[   65.739980] w83627ehf: Found W83627EHG chip at 0x290
[   66.375065] r8169: eth0: link up
[   66.375207] r8169: eth0: link up
[  115.015710] kio_http_cache_[4201] general protection rip:3919ff1fe9=20
rsp:7fffa32dd7f0 error:0
[  555.532998] usb 1-3.2: new full speed USB device using ehci_hcd and addr=
ess=20
5
[  555.601070] usb 1-3.2: configuration #1 chosen from 2 choices
[  555.603656] scsi4 : SCSI emulation for USB Mass Storage devices
[  555.603308] usb-storage: device found at 5
[  555.603312] usb-storage: waiting for device to settle before scanning
[  559.174754] scsi 4:0:0:0: Direct-Access     Motorola Motorola Phone   2.=
31=20
PQ: 0 ANSI: 2
[  559.190122] sd 4:0:0:0: [sdb] 979456 512-byte hardware sectors (501 MB)
[  559.198183] sd 4:0:0:0: [sdb] Write Protect is off
[  559.198186] sd 4:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[  559.198187] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  559.228047] sd 4:0:0:0: [sdb] 979456 512-byte hardware sectors (501 MB)
[  559.235932] sd 4:0:0:0: [sdb] Write Protect is off
[  559.235935] sd 4:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[  559.235936] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  559.235945]  sdb: sdb1
[  559.257659] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[  559.257695] sd 4:0:0:0: Attached scsi generic sg1 type 0
[  559.257897] usb-storage: device scan complete
[ 3348.892721] kio_http_cache_[5911] general protection rip:3919ff1fe9=20
rsp:7fffab797ca0 error:0
[ 4584.408120] kio_http_cache_[7020] general protection rip:3919ff1fe9=20
rsp:7ffff44b69c0 error:0
[ 5799.546999] kio_http_cache_[7826] general protection rip:3919ff1fe9=20
rsp:7fff0551ca30 error:0
[ 6372.520336] usb 1-5: USB disconnect, address 4
[ 6372.689352] usb 1-5: new high speed USB device using ehci_hcd and addres=
s 6
[ 6372.775552] usb 1-5: configuration #1 chosen from 1 choice
[ 6372.836210] usbcore: registered new interface driver snd-usb-audio
[ 6373.438681] usb 1-5: USB disconnect, address 6
[ 6373.617312] usb 1-5: new high speed USB device using ehci_hcd and addres=
s 7
[ 6373.695645] usb 1-5: configuration #1 chosen from 1 choice
[ 7005.779226] kio_http_cache_[8829] general protection rip:3919ff1fe9=20
rsp:7fffa7ca71b0 error:0
[ 8257.197220] kio_http_cache_[10032] general protection rip:3919ff1fe9=20
rsp:7fff3d69dbb0 error:0
[ 8540.395721] usb 1-3.4: new high speed USB device using ehci_hcd and addr=
ess=20
8
[ 8540.457758] usb 1-3.4: configuration #1 chosen from 1 choice
[ 8540.458096] scsi5 : SCSI emulation for USB Mass Storage devices
[ 8540.458304] usb-storage: device found at 8
[ 8540.458306] usb-storage: waiting for device to settle before scanning
[ 8543.784201] scsi 5:0:0:0: CD-ROM            _NEC     DVD_RW ND-3500AG 2.=
19=20
PQ: 0 ANSI: 0
[ 8543.802196] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[ 8543.802199] Uniform CD-ROM driver Revision: 3.20
[ 8543.793153] sr 5:0:0:0: Attached scsi CD-ROM sr0
[ 8543.793206] sr 5:0:0:0: Attached scsi generic sg2 type 5
[ 8543.793374] usb-storage: device scan complete
[ 8572.123753] ISO 9660 Extensions: RRIP_1991A
[ 8605.798506] ISO 9660 Extensions: RRIP_1991A
[ 8763.521595] Unable to handle kernel paging request at ffff910073e22db0 R=
IP:=20
[ 8763.521600]  [<ffffffff8044246a>] _spin_lock+0x0/0xf
[ 8763.521606] PGD 0=20
[ 8763.521608] Oops: 0002 [1] SMP=20
[ 8763.521610] CPU 1=20
[ 8763.521611] Modules linked in: isofs snd_usb_audio snd_usb_lib k8temp=20
w83627ehf hwmon_vid hwmon i2c_core snd_seq_midi snd_emu10k1_synth=20
snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_pcm_oss snd_mixer_oss=
=20
snd_seq_oss snd_seq_midi_event snd_seq snd_emu10k1 snd_rawmidi snd_ac97_cod=
ec=20
ac97_bus snd_pcm snd_seq_device snd_timer snd_page_alloc snd_util_mem=20
snd_hwdep snd r8169
[ 8763.521626] Pid: 10497, comm: emerge Not tainted 2.6.23.9reiser4 #4
[ 8763.521628] RIP: 0010:[<ffffffff8044246a>]  [<ffffffff8044246a>]=20
_spin_lock+0x0/0xf
[ 8763.521631] RSP: 0018:ffff81005e185e10  EFLAGS: 00010282
[ 8763.521632] RAX: ffff81005e485f00 RBX: ffff910073e22db0 RCX:=20
0000000000000000
[ 8763.521634] RDX: 0000000000000000 RSI: ffff810040aeb3d8 RDI:=20
ffff910073e22db0
[ 8763.521635] RBP: ffff81005e485f00 R08: 800000007f3c2005 R09:=20
000000000003ccd0
[ 8763.521637] R10: ffff81000250d820 R11: 0000000000000001 R12:=20
ffff81003a3b3820
[ 8763.521638] R13: ffff81007e610f00 R14: ffff810040aeb330 R15:=20
ffff81007e610f00
[ 8763.521640] FS:  00002b2dce7a9140(0000) GS:ffff81007ff3bec0(0000)=20
knlGS:00000000f7b83b80
[ 8763.521642] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8763.521644] CR2: ffff910073e22db0 CR3: 000000003ba69000 CR4:=20
00000000000006e0
[ 8763.521645] DR0: 0000000000000000 DR1: 0000000000000000 DR2:=20
0000000000000000
[ 8763.521647] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:=20
0000000000000400
[ 8763.521649] Process emerge (pid: 10497, threadinfo ffff81005e184000, tas=
k=20
ffff8100580bb080)
[ 8763.521650] Stack:  ffffffff8026b048 0000000000000001 ffff81005e485f00=20
0000000000000001
[ 8763.521654]  ffffffff80230d0c 00002b2dce7a91d0 0000000000000000=20
ffff81005e185f58
[ 8763.521656]  00007fffdc32be90 0000000001200011 0000000000000000=20
ffff81003a3b3820
[ 8763.521658] Call Trace:
[ 8763.521662]  [<ffffffff8026b048>] anon_vma_link+0x1a/0x40
[ 8763.521666]  [<ffffffff80230d0c>] copy_process+0xb03/0x1301
[ 8763.521671]  [<ffffffff80231670>] do_fork+0xb1/0x1fc
[ 8763.521675]  [<ffffffff8020b66e>] system_call+0x7e/0x83
[ 8763.521677]  [<ffffffff8020b987>] ptregscall_common+0x67/0xb0
[ 8763.521681]=20
[ 8763.521682]=20
[ 8763.521682] Code: f0 ff 0f 79 09 f3 90 83 3f 00 7e f9 eb f2 c3 f0 81 2f =
00=20
00=20
[ 8763.521688] RIP  [<ffffffff8044246a>] _spin_lock+0x0/0xf
[ 8763.521690]  RSP <ffff81005e185e10>
[ 8763.521691] CR2: ffff910073e22db0

sh ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux energy 2.6.23.9reiser4 #4 SMP Sat Dec 15 20:06:33 CET 2007 x86_64 AMD=
=20
Athlon(tm) 64 X2 Dual Core Processor 6000+ AuthenticAMD GNU/Linux

Gnu C                  4.2.2
Gnu make               3.81
binutils               Binutils
util-linux             2.13
mount                  2.13
module-init-tools      3.4
e2fsprogs              1.40.3
reiserfsprogs          3.6.19
reiser4progs           1.0.6
PPP                    2.4.4
Linux C Library        2.7
Dynamic linker (ldd)   2.7
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.13
Sh-utils               6.9
udev                   117
Modules Loaded         isofs snd_usb_audio snd_usb_lib k8temp w83627ehf=20
hwmon_vid hwmon i2c_core snd_seq_midi snd_emu10k1_synth snd_emux_synth=20
snd_seq_virmidi snd_seq_midi_emul snd_pcm_oss snd_mixer_oss snd_seq_oss=20
snd_seq_midi_event snd_seq snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus=
=20
snd_pcm snd_seq_device snd_timer snd_page_alloc snd_util_mem snd_hwdep snd=
=20
r8169

If you need more info, please tell me so. Config is attached because of its=
=20
size.=20

Gl=FCck Auf,
Volker

--Boundary-00=_ovGZHcC5JBYVmHO
Content-Type: text/plain;
  charset="us-ascii";
  name=".config"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=".config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.23.9
# Sat Dec 15 20:05:44 2007
#
CONFIG_X86_64=y
CONFIG_64BIT=y
CONFIG_X86=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CMOS_UPDATE=y
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
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION="reiser4"
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_USER_NS is not set
# CONFIG_AUDIT is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=18
# CONFIG_CPUSETS is not set
CONFIG_SYSFS_DEPRECATED=y
# CONFIG_RELAY is not set
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
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
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_BLK_DEV_BSG is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
# CONFIG_IOSCHED_DEADLINE is not set
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
CONFIG_MK8=y
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_TSC=y
CONFIG_X86_GOOD_APIC=y
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_MTRR=y
CONFIG_SMP=y
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
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
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_NR_CPUS=2
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_START=0x200000
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
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
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND_SMP_POSSIBLE=y
CONFIG_SUSPEND=y
CONFIG_HIBERNATION_SMP_POSSIBLE=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_POWERNOW_K8_ACPI=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_ACPI_CPUFREQ=y

#
# shared options
#
CONFIG_X86_ACPI_CPUFREQ_PROC_INTF=y
# CONFIG_X86_P4_CLOCKMOD is not set
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
# CONFIG_HT_IRQ is not set

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
CONFIG_IA32_AOUT=m
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
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
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
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
# CONFIG_HAMRADIO is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
# CONFIG_BT_BNEP_MC_FILTER is not set
# CONFIG_BT_BNEP_PROTO_FILTER is not set
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUSB=m
CONFIG_BT_HCIUSB_SCO=y
CONFIG_BT_HCIUART=m
# CONFIG_BT_HCIUART_H4 is not set
# CONFIG_BT_HCIUART_BCSP is not set
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
# CONFIG_NET_9P is not set

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
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_IDE=y
CONFIG_IDE_MAX_HWIFS=2
CONFIG_BLK_DEV_IDE=y

#
# Please see Documentation/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_BLK_DEV_HD_IDE is not set
CONFIG_BLK_DEV_IDEDISK=y
# CONFIG_IDEDISK_MULTI_MODE is not set
# CONFIG_BLK_DEV_IDECD is not set
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
# CONFIG_BLK_DEV_IDESCSI is not set
CONFIG_BLK_DEV_IDEACPI=y
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_SHARE_IRQ is not set
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_IDEDMA_FORCED is not set
# CONFIG_IDEDMA_ONLYDISK is not set
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
CONFIG_BLK_DEV_AMD74XX=y
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
# CONFIG_BLK_DEV_PIIX is not set
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
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=m

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
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
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_MV is not set
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
# CONFIG_PATA_PLATFORM is not set
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
CONFIG_IEEE1394=m

#
# Subsystem Options
#
# CONFIG_IEEE1394_VERBOSEDEBUG is not set

#
# Controllers
#
# CONFIG_IEEE1394_PCILYNX is not set
CONFIG_IEEE1394_OHCI1394=m

#
# Protocols
#
# CONFIG_IEEE1394_VIDEO1394 is not set
# CONFIG_IEEE1394_SBP2 is not set
# CONFIG_IEEE1394_ETH1394_ROM_ENTRY is not set
# CONFIG_IEEE1394_ETH1394 is not set
# CONFIG_IEEE1394_DV1394 is not set
CONFIG_IEEE1394_RAWIO=m
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NETDEVICES_MULTIQUEUE=y
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=y
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=m
# CONFIG_R8169_NAPI is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_SK98LIN is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
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
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
# CONFIG_SHAPER is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1680
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=1050
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_TSDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

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
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_WATCHDOG is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_RTC=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_DRM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
# CONFIG_HPET_RTC_IRQ is not set
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
# CONFIG_I2C_AMD756_S4882 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_I810 is not set
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=m
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_PROSAVAGE is not set
# CONFIG_I2C_SAVAGE4 is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_TAOS_EVM is not set
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
# CONFIG_DS1682 is not set
CONFIG_SENSORS_EEPROM=m
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
# CONFIG_W1 is not set
# CONFIG_POWER_SUPPLY is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_K8TEMP=m
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set
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
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
# CONFIG_VIDEO_VIVI is not set
# CONFIG_VIDEO_BT848 is not set
# CONFIG_VIDEO_CPIA is not set
# CONFIG_VIDEO_CPIA2 is not set
# CONFIG_VIDEO_SAA5246A is not set
# CONFIG_VIDEO_SAA5249 is not set
# CONFIG_TUNER_3036 is not set
# CONFIG_TUNER_TEA5761 is not set
# CONFIG_VIDEO_STRADIS is not set
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_DPC is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_CX88 is not set
# CONFIG_VIDEO_IVTV is not set
# CONFIG_VIDEO_CAFE_CCIC is not set
CONFIG_V4L_USB_DRIVERS=y
# CONFIG_VIDEO_PVRUSB2 is not set
# CONFIG_VIDEO_EM28XX is not set
# CONFIG_VIDEO_USBVISION is not set
# CONFIG_USB_VICAM is not set
# CONFIG_USB_IBMCAM is not set
# CONFIG_USB_KONICAWC is not set
# CONFIG_USB_QUICKCAM_MESSENGER is not set
# CONFIG_USB_ET61X251 is not set
# CONFIG_VIDEO_OVCAMCHIP is not set
# CONFIG_USB_W9968CF is not set
# CONFIG_USB_OV511 is not set
# CONFIG_USB_SE401 is not set
# CONFIG_USB_SN9C102 is not set
# CONFIG_USB_STV680 is not set
# CONFIG_USB_ZC0301 is not set
# CONFIG_USB_PWC is not set
# CONFIG_USB_ZR364XX is not set
# CONFIG_RADIO_ADAPTERS is not set
CONFIG_DVB_CORE=m
# CONFIG_DVB_CORE_ATTACH is not set
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
# CONFIG_DVB_AV7110 is not set
# CONFIG_DVB_BUDGET is not set
# CONFIG_DVB_BUDGET_CI is not set
# CONFIG_DVB_BUDGET_AV is not set

#
# Supported USB Adapters
#
# CONFIG_DVB_USB is not set
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set
# CONFIG_DVB_CINERGYT2 is not set

#
# Supported FlexCopII (B2C2) Adapters
#
# CONFIG_DVB_B2C2_FLEXCOP is not set

#
# Supported BT878 Adapters
#

#
# Supported Pluto2 Adapters
#
# CONFIG_DVB_PLUTO2 is not set

#
# Supported DVB Frontends
#

#
# Customise DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set

#
# DVB-S (satellite) frontends
#
# CONFIG_DVB_STV0299 is not set
# CONFIG_DVB_CX24110 is not set
# CONFIG_DVB_CX24123 is not set
# CONFIG_DVB_TDA8083 is not set
# CONFIG_DVB_MT312 is not set
# CONFIG_DVB_VES1X93 is not set
# CONFIG_DVB_S5H1420 is not set
# CONFIG_DVB_TDA10086 is not set

#
# DVB-T (terrestrial) frontends
#
# CONFIG_DVB_SP8870 is not set
# CONFIG_DVB_SP887X is not set
# CONFIG_DVB_CX22700 is not set
# CONFIG_DVB_CX22702 is not set
# CONFIG_DVB_L64781 is not set
# CONFIG_DVB_TDA1004X is not set
# CONFIG_DVB_NXT6000 is not set
# CONFIG_DVB_MT352 is not set
# CONFIG_DVB_ZL10353 is not set
# CONFIG_DVB_DIB3000MB is not set
# CONFIG_DVB_DIB3000MC is not set
# CONFIG_DVB_DIB7000M is not set
# CONFIG_DVB_DIB7000P is not set

#
# DVB-C (cable) frontends
#
# CONFIG_DVB_VES1820 is not set
# CONFIG_DVB_TDA10021 is not set
# CONFIG_DVB_TDA10023 is not set
# CONFIG_DVB_STV0297 is not set

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
# CONFIG_DVB_NXT200X is not set
# CONFIG_DVB_OR51211 is not set
# CONFIG_DVB_OR51132 is not set
# CONFIG_DVB_BCM3510 is not set
# CONFIG_DVB_LGDT330X is not set

#
# Tuners/PLL support
#
# CONFIG_DVB_PLL is not set
# CONFIG_DVB_TDA826X is not set
# CONFIG_DVB_TDA827X is not set
# CONFIG_DVB_TUNER_QT1010 is not set
# CONFIG_DVB_TUNER_MT2060 is not set

#
# Miscellaneous devices
#
# CONFIG_DVB_LNBP21 is not set
# CONFIG_DVB_ISL6421 is not set
# CONFIG_DVB_TUA6100 is not set
# CONFIG_DAB is not set

#
# Graphics support
#
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=256
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y

#
# Sound
#
CONFIG_SOUND=y

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_RTCTIMER=m
CONFIG_SND_SEQ_RTCTIMER_DEFAULT=y
# CONFIG_SND_DYNAMIC_MINORS is not set
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
CONFIG_SND_MPU401_UART=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m

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
# CONFIG_SND_CS5530 is not set
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
CONFIG_SND_EMU10K1=m
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
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
CONFIG_SND_USB_AUDIO=m
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set

#
# System on Chip audio support
#
# CONFIG_SND_SOC is not set

#
# SoC Audio support for SuperH
#

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
# CONFIG_USB_HIDDEV is not set
CONFIG_USB_SUPPORT=y
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
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_PERSIST is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_SPLIT_ISO is not set
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_DPCM is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
CONFIG_USB_MON=y

#
# USB port drivers
#

#
# USB Serial Converter support
#
# CONFIG_USB_SERIAL is not set

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
# CONFIG_NEW_LEDS is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set

#
# DMA Engine support
#
# CONFIG_DMA_ENGINE is not set

#
# DMA Clients
#

#
# DMA Devices
#
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
# CONFIG_KVM_INTEL is not set
CONFIG_KVM_AMD=m

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
# CONFIG_EXT2_FS_XIP is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4DEV_FS is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISER4_FS=y
# CONFIG_REISER4_DEBUG is not set
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
CONFIG_DNOTIFY=y
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

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
CONFIG_FAT_DEFAULT_CODEPAGE=850
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-15"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_RAMFS=y
# CONFIG_CONFIGFS_FS is not set

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set

#
# Network File Systems
#
# CONFIG_NFS_FS is not set
# CONFIG_NFSD is not set
# CONFIG_SMB_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y

#
# Native Language Support
#
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-15"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=m
# CONFIG_NLS_CODEPAGE_852 is not set
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
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=m

#
# Distributed Lock Manager
#
# CONFIG_DLM is not set

#
# Instrumentation Support
#
# CONFIG_PROFILING is not set
# CONFIG_KPROBES is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_SLAB is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_BUGVERBOSE is not set
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_FRAME_POINTER is not set
# CONFIG_FORCED_INLINING is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=m
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_MANAGER=m
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_GF128MUL is not set
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_PCBC=m
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_AES is not set
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_HW=y

#
# Library routines
#
CONFIG_BITREVERSE=y
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--Boundary-00=_ovGZHcC5JBYVmHO--
