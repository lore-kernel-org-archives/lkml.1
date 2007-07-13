Return-Path: <linux-kernel-owner+w=401wt.eu-S1761644AbXGMQmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761644AbXGMQmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 12:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbXGMQmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 12:42:05 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:33101 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752426AbXGMQmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 12:42:00 -0400
Subject: Re: 2.6.22-rc6-mm1 reiser4_tree_by_page NULL pointer
From: Zan Lynx <zlynx@acm.org>
To: Edward Shishkin <edward@namesys.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>,
       "Vladimir V. Saveliev" <vs@namesys.com>
In-Reply-To: <46968F88.7070300@acm.org>
References: <1184090582.6933.20.camel@localhost>
	 <469523FA.7010308@namesys.com>  <46968F88.7070300@acm.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-R9kFVlrp3TEaBCr9sBFX"
Date: Fri, 13 Jul 2007 10:41:53 -0600
Message-Id: <1184344914.468943.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-Envelope-From: zlynx@acm.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-R9kFVlrp3TEaBCr9sBFX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-07-12 at 14:31 -0600, Zan Lynx wrote:
> Edward Shishkin wrote:
> >=20
> > I have found the bug, which kills data
> > when booting after crash, power loss, etc.
> > The patch is attached.
> > Please, ping me, if it doesn't help..
>=20
> It appears to be holding up well so far.  About 5 hours of Gentoo=20
> updating and compiling.

Maybe it isn't fixed so well at that.
I got one of these today, here is the dmesg (at the bottom):

Linux version 2.6.22-rc6-mm1 (root@zephyr) (gcc version 4.2.0 (Gentoo 4.2.0=
)) #4 SMP PREEMPT Wed Jul 11 23:22:08 MDT 2007
Command line: root=3D/dev/sda2 rootfstype=3Dreiser4 ro i8042.nomux elevator=
=3Danticipatory resume=3D/dev/sda3 panic=3D5 nmi_watchdog=3D2,panic debug k=
ernelcore=3D384M
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003ff70000 (usable)
 BIOS-e820: 000000003ff70000 - 000000003ff7f000 (ACPI data)
 BIOS-e820: 000000003ff7f000 - 000000003ff80000 (ACPI NVS)
 BIOS-e820: 000000003ff80000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 262000) 1 entries of 256 used
end_pfn_map =3D 1048576
DMI present.
ACPI: RSDP 000F7240, 0014 (r0 PTLTD )
ACPI: RSDT 3FF7A87E, 0034 (r1 PTLTD    RSDT    6040000  LTP        0)
ACPI: FACP 3FF7EE13, 0074 (r1 NVIDIA CK8       6040000 PTL_    F4240)
ACPI: DSDT 3FF7A8B2, 4561 (r1 NVIDIA      CK8  6040000 MSFT  100000E)
ACPI: FACS 3FF7FFC0, 0040
ACPI: APIC 3FF7EE87, 005A (r1 NVIDIA NV_APIC_  6040000  LTP        0)
ACPI: BOOT 3FF7EEE1, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: SSDT 3FF7EF09, 00F7 (r1 PTLTD  POWERNOW  6040000  LTP        1)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 262000) 1 entries of 256 used
No mptable found.
sizeof(struct page) =3D 88
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
  Node 0: 99328
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   262000
On node 0 totalpages: 261903
Node 0 memmap at 0xffff810001000000 size 23068672 first pfn 0xffff810001000=
000
  DMA zone: 88 pages used for memmap
  DMA zone: 2784 pages reserved
  DMA zone: 1127 pages, LIFO batch:0
  DMA32 zone: 2046 pages used for memmap
  DMA32 zone: 93186 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 3494 pages used for memmap
  Movable zone: 159178 pages, LIFO batch:31
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x8008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: BIOS IRQ0 pin2 override ignored.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a000=
0
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000d000=
0
swsusp: Registered nosave memory region: 00000000000d0000 - 000000000010000=
0
Allocating PCI resources starting at 50000000 (gap: 40000000:bff80000)
SMP: Allowing 1 CPUs, 0 hotplug CPUs
PERCPU: Allocating 33144 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 253491
Kernel command line: root=3D/dev/sda2 rootfstype=3Dreiser4 ro i8042.nomux e=
levator=3Danticipatory resume=3D/dev/sda3 panic=3D5 nmi_watchdog=3D2,panic =
debug kernelcore=3D384M
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
time.c: Detected 797.942 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          30
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1648 kB
 per task-struct memory footprint: 1680 bytes
------------------------
| Locking API testsuite:
---------------------------------------------------------------------------=
-
                                 | spin |wlock |rlock |mutex | wsem | rsem =
|
  -------------------------------------------------------------------------=
-
                     A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  =
|
                 A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  =
|
             A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  =
|
             A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  =
|
         A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  =
|
         A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  =
|
         A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  =
|
                    double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  =
|
                  initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  =
|
                 bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  =
|
  -------------------------------------------------------------------------=
-
              recursive read-lock:             |  ok  |             |  ok  =
|
           recursive read-lock #2:             |  ok  |             |  ok  =
|
            mixed read-write-lock:             |  ok  |             |  ok  =
|
            mixed write-read-lock:             |  ok  |             |  ok  =
|
  -------------------------------------------------------------------------=
-
     hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
       sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
       sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
      hard-irq read-recursion/123:  ok  |
      soft-irq read-recursion/123:  ok  |
      hard-irq read-recursion/132:  ok  |
      soft-irq read-recursion/132:  ok  |
      hard-irq read-recursion/213:  ok  |
      soft-irq read-recursion/213:  ok  |
      hard-irq read-recursion/231:  ok  |
      soft-irq read-recursion/231:  ok  |
      hard-irq read-recursion/312:  ok  |
      soft-irq read-recursion/312:  ok  |
      hard-irq read-recursion/321:  ok  |
      soft-irq read-recursion/321:  ok  |
-------------------------------------------------------
Good, all 218 testcases passed! |
---------------------------------
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Checking aperture...
CPU 0: aperture @ e8000000 size 128 MB
Memory: 1011952k/1048000k available (3284k kernel code, 35388k reserved, 21=
98k data, 1108k init)
SLUB: Genslabs=3D22, HWalign=3D64, Order=3D0-3, MinObjects=3D16, CPUs=3D1, =
Nodes=3D1
Calibrating delay using timer specific routine.. 1597.32 BogoMIPS (lpj=3D79=
8660)
kswapd reclaim order set to 3
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
SMP alternatives: switching to UP code
Freeing SMP alternatives: 25k freed
ACPI: Core revision 20070126
Parsing all Control Methods:
Table [DSDT](id 0001) - 650 Objects with 66 Devices 205 Methods 24 Regions
Parsing all Control Methods:
Table [SSDT](id 0002) - 3 Objects with 0 Devices 1 Methods 0 Regions
 tbxface-0587 [00] tb_load_namespace     : ACPI Tables successfully acquire=
d
evxfevnt-0091 [00] enable                : Transition to ACPI mode successf=
ul
Using local APIC timer interrupts.
Brought up 1 CPUs
testing NMI watchdog ... OK.
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: Using configuration type 1
evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on in=
t 0x9
evgpeblk-0956 [00] ev_create_gpe_block   : GPE 20 to 5F [_GPE] 8 regs on in=
t 0x9
evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 5 Wake, Enabled 1 Runtime =
GPEs in this block
evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 0 Wake, Enabled 1 Runtime =
GPEs in this block
Completing Region/Field/Buffer/Package initialization:.....................=
................................................
Initialized 24/24 Regions 2/2 Fields 29/29 Buffers 14/21 Packages (662 node=
s)
Initializing Device/Processor/Thermal objects by executing _INI methods:.
Executed 1 _INI methods requiring 0 _STA executions (examined 70 objects)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE =3D 0x21, I/O: command/status =3D 0x66, data =3D 0x62<6>ACPI:=
 PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI: Bus #03 (-#06) is hidden behind  bridge #02 (-#02) (try 'pci=3Dassign-=
busses')
Please report the result to <bk@suse.de> to fix this permanently
PCI: Bus #07 (-#0a) is hidden behind  bridge #02 (-#02) (try 'pci=3Dassign-=
busses')
Please report the result to <bk@suse.de> to fix this permanently
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP0._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 16 18 19) *0
ACPI: PCI Interrupt Link [LNK2] (IRQs 16 18 19) *0
ACPI: PCI Interrupt Link [LNK3] (IRQs 17) *0
ACPI: PCI Interrupt Link [LNK4] (IRQs 16 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 16 18 19) *0
ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [LUS1] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [LMCI] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [LPID] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
Generic PHY: Registered new driver
SCSI subsystem initialized
libata version 2.21 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post a r=
eport
PCI: Cannot allocate resource region 0 of device 0000:00:00.0
agpgart: Detected AGP bridge 0
agpgart: Setting up Nforce3 AGP.
agpgart: AGP aperture is 128M @ 0xe8000000
Time: tsc clocksource has been installed.
Switched to high resolution mode on CPU 0
pnp: 00:01: ioport range 0x8000-0x807f has been reserved
pnp: 00:01: ioport range 0x8080-0x80ff has been reserved
pnp: 00:01: ioport range 0x8400-0x847f has been reserved
pnp: 00:01: ioport range 0x8480-0x84ff has been reserved
pnp: 00:01: ioport range 0x8800-0x887f has been reserved
pnp: 00:01: ioport range 0x8880-0x88ff has been reserved
pnp: 00:01: ioport range 0x2040-0x207f has been reserved
pnp: 00:01: ioport range 0x2000-0x203f has been reserved
pnp: 00:02: iomem range 0xfff80000-0xffffffff could not be reserved
pnp: 00:02: iomem range 0xfec00000-0xfec00fff has been reserved
pnp: 00:02: iomem range 0xfee00000-0xfeefffff could not be reserved
pnp: 00:02: iomem range 0xfed00000-0xfed00fff has been reserved
PCI: Failed to allocate mem resource #10:4000000@e4000000 for 0000:02:04.0
PCI: Failed to allocate mem resource #10:4000000@e4000000 for 0000:02:04.1
PCI: Bus 3, cardbus bridge: 0000:02:04.0
  IO window: 00003000-000030ff
  IO window: 00003400-000034ff
  PREFETCH window: 50000000-53ffffff
PCI: Bus 7, cardbus bridge: 0000:02:04.1
  IO window: 00003800-000038ff
  IO window: 00003c00-00003cff
  PREFETCH window: 54000000-57ffffff
PCI: Bridge: 0000:00:0a.0
  IO window: 3000-7fff
  MEM window: e0100000-e17fffff
  PREFETCH window: 50000000-57ffffff
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: e2000000-e2ffffff
  PREFETCH window: f0000000-f80fffff
PCI: Setting latency timer of device 0000:00:0a.0 to 64
ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 19
ACPI: PCI Interrupt 0000:02:04.0[A] -> Link [LNK1] -> GSI 19 (level, low) -=
> IRQ 19
ACPI: PCI Interrupt Link [LNK2] enabled at IRQ 18
ACPI: PCI Interrupt 0000:02:04.1[B] -> Link [LNK2] -> GSI 18 (level, low) -=
> IRQ 18
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 65536 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
TCP: Hash tables configured (established 65536 bind 65536)
TCP reno registered
Simple Boot Flag at 0x37 set to 0x1
audit: initializing netlink socket (disabled)
audit(1184218128.567:1): initialized
Total HugeTLB memory allocated, 0
Loading Reiser4. See www.namesys.com for a description of Reiser4.
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
Boot video device is 0000:01:00.0
ACPI: AC Adapter [ACAD] (on-line)
ACPI: Battery Slot [BAT1] (battery present)
input: Power Button (FF) as /devices/virtual/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /devices/virtual/input/input1
ACPI: Power Button (CM) [PWRB]
input: Lid Switch as /devices/virtual/input/input2
ACPI: Lid Switch [LID]
ACPI Exception (processor_throttling-0084): AE_NOT_FOUND, Evaluating _PTC [=
20070126]
ACPI Exception (processor_throttling-0147): AE_NOT_FOUND, Evaluating _TSS [=
20070126]
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI Exception (thermal-0400): AE_NOT_FOUND, Invalid active threshold [0] [=
20070126]
ACPI: Thermal Zone [THRM] (52 C)
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.102 (c) Dave Jones
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 6=
0 seconds).
Hangcheck: Using get_cycles().
loop: module loaded
Marvell 88E1101: Registered new driver
Marvell 88E1111: Registered new driver
Marvell 88E1145: Registered new driver
Davicom DM9161E: Registered new driver
Davicom DM9161A: Registered new driver
Davicom DM9131: Registered new driver
Cicada Cis8204: Registered new driver
Cicada Cis8201: Registered new driver
LXT970: Registered new driver
LXT971: Registered new driver
QS6612: Registered new driver
SMSC LAN83C185: Registered new driver
Vitesse VSC8244: Registered new driver
Broadcom BCM5411: Registered new driver
Broadcom BCM5421: Registered new driver
Broadcom BCM5461: Registered new driver
ICPlus IP175C: Registered new driver
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt 0000:02:01.0[A] -> Link [LNK2] -> GSI 18 (level, low) -=
> IRQ 18
eth0: RealTek RTL8139 at 0xffffc2000001e800, 00:0f:b0:07:dc:49, IRQ 18
eth0:  Identified 8139 chip type 'RTL-8101'
pata_amd 0000:00:08.0: version 0.3.8
PCI: Setting latency timer of device 0000:00:08.0 to 64
scsi0 : pata_amd
scsi1 : pata_amd
ata1: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma=
 0x0000000000012080 irq 14
ata2: PATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma=
 0x0000000000012088 irq 15
ata1.00: ATA-6: HTS721010G9AT00, MCZOA51A, max UDMA/100
ata1.00: 195371568 sectors, multi 16: LBA48=20
ata1.00: configured for UDMA/100
ata2.00: ATAPI: HL-DT-ST DVD+RW GCA-4040N, 1.19, max MWDMA2
ata2.00: configured for MWDMA2
scsi 0:0:0:0: Direct-Access     ATA      HTS721010G9AT00  MCZO PQ: 0 ANSI: =
5
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD+RW GCA-4040N 1.19 PQ: 0 ANSI: =
5
sr0: scsi3-mmc drive: 40x/24x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
Yenta: CardBus bridge found at 0000:02:04.0 [103c:006d]
PCI: Bus 3, cardbus bridge: 0000:02:04.0
  IO window: 00003000-000030ff
  IO window: 00003400-000034ff
  PREFETCH window: 50000000-53ffffff
  MEM window: e0400000-e07fffff
Yenta: Enabling burst memory read transactions
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:02:04.0, mfunc 0x01111d22, devctl 0x64
Yenta: ISA IRQ mask 0x0cf8, PCI irq 19
Socket status: 30000086
Yenta: Raising subordinate bus# of parent bus (#02) from #02 to #06
pcmcia: parent PCI bridge I/O window: 0x3000 - 0x7fff
pcmcia: parent PCI bridge Memory window: 0xe0100000 - 0xe17fffff
pcmcia: parent PCI bridge Memory window: 0x50000000 - 0x57ffffff
Yenta: CardBus bridge found at 0000:02:04.1 [103c:006d]
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:02:04.1, mfunc 0x01111d22, devctl 0x64
Yenta: ISA IRQ mask 0x0cf8, PCI irq 18
Socket status: 30000006
Yenta: Raising subordinate bus# of parent bus (#02) from #06 to #0a
pcmcia: parent PCI bridge I/O window: 0x3000 - 0x7fff
pcmcia: parent PCI bridge Memory window: 0xe0100000 - 0xe17fffff
pcmcia: parent PCI bridge Memory window: 0x50000000 - 0x57ffffff
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input=
/input3
cpuidle: using governor menu
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3400+ processors (1 cpu co=
res) (version 2.00.00)
powernow-k8:    0 : fid 0xe (2200 MHz), vid 0x2
powernow-k8:    1 : fid 0xa (1800 MHz), vid 0xa
powernow-k8:    2 : fid 0x0 (800 MHz), vid 0x12
swsusp: Resume From Partition /dev/sda3
PM: Checking swsusp image.
Marking TSC unstable due to possible TSC halt in C2
Time: acpi_pm clocksource has been installed.
PM: Resume from disk failed.
registered taskstats version 1
Freeing unused kernel memory: 1108k freed
reiser4: sda2: found disk format 4.0.0.
sd 0:0:0:0: Attached scsi generic sg0 type 0
sr 1:0:0:0: Attached scsi generic sg1 type 5
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ehci_hcd: block sizes: qh 192 qtd 96 itd 192 sitd 96
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 80 td 96
ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:02.2[C] -> Link [LUS2] -> GSI 22 (level, low) -=
> IRQ 22
PCI: Setting latency timer of device 0000:00:02.2 to 64
ehci_hcd 0000:00:02.2: EHCI Host Controller
drivers/usb/core/inode.c: creating file 'devices'
drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.2: reset hcs_params 0x102486 dbg=3D1 cc=3D2 pcc=3D4 !pp=
c ports=3D6
ehci_hcd 0000:00:02.2: reset portroute 0 0 1 1 1 0=20
ehci_hcd 0000:00:02.2: reset hcc_params a086 caching frame 256/512/1024 par=
k
ehci_hcd 0000:00:02.2: park 0
PCI: cache line size of 64 is not supported by device 0000:00:02.2
ehci_hcd 0000:00:02.2: supports USB remote wakeup
ehci_hcd 0000:00:02.2: irq 22, io mem 0xe0004000
ehci_hcd 0000:00:02.2: reset command 080b02 park=3D3 ithresh=3D8 period=3D1=
024 Reset HALT
ehci_hcd 0000:00:02.2: init command 010009 (park)=3D0 ithresh=3D1 period=3D=
256 RUN
ehci_hcd 0000:00:02.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: default language 0x0409
usb usb1: new device found, idVendor=3D0000, idProduct=3D0000
usb usb1: new device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.22-rc6-mm1 ehci_hcd
usb usb1: SerialNumber: 0000:00:02.2
usb usb1: uevent
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
usb 1-0:1.0: uevent
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: Single TT
hub 1-0:1.0: TT requires at most 8 FS bit times (666 ns)
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0000
drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:02.2: GetStatus port 3 status 001803 POWER sig=3Dj CSC CON=
NECT
hub 1-0:1.0: port 3, status 0501, change 0001, 480 Mb/s
PCI: Enabling device 0000:00:02.0 (0004 -> 0006)
ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUS0] -> GSI 21 (level, low) -=
> IRQ 21
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
drivers/usb/core/inode.c: creating file '002'
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: USB HC TakeOver from BIOS/SMM
ohci_hcd 0000:00:02.0: created debug files
ohci_hcd 0000:00:02.0: irq 21, io mem 0xe0000000
hub 1-0:1.0: debounce: port 3: total 100ms stable 100ms status 0x501
ohci_hcd 0000:00:02.0: OHCI controller state
ohci_hcd 0000:00:02.0: OHCI 1.0, NO legacy support registers
ohci_hcd 0000:00:02.0: control 0x683 RWE RWC HCFS=3Doperational CBSR=3D3
ohci_hcd 0000:00:02.0: cmdstatus 0x00000 SOC=3D0
ohci_hcd 0000:00:02.0: intrstatus 0x00000004 SF
ohci_hcd 0000:00:02.0: intrenable 0x8000004a MIE RHSC RD WDH
ohci_hcd 0000:00:02.0: hcca frame #0003
ohci_hcd 0000:00:02.0: roothub.a 01000203 POTPGT=3D1 NPS NDP=3D3(3)
ohci_hcd 0000:00:02.0: roothub.b 00000000 PPCM=3D0000 DR=3D0000
ohci_hcd 0000:00:02.0: roothub.status 00008000 DRWE
ohci_hcd 0000:00:02.0: roothub.portstatus [0] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [1] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [2] 0x00000100 PPS
usb usb2: default language 0x0409
usb usb2: new device found, idVendor=3D0000, idProduct=3D0000
usb usb2: new device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.22-rc6-mm1 ohci_hcd
usb usb2: SerialNumber: 0000:00:02.0
usb usb2: uevent
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
usb 2-0:1.0: uevent
usb 2-0:1.0: uevent
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: global over-current protection
hub 2-0:1.0: power on to power good time: 2ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: no over-current condition exists
hub 2-0:1.0: trying to enable port power on non-switchable hub
input: PS/2 Mouse as /devices/virtual/input/input4
ehci_hcd 0000:00:02.2: port 3 full speed --> companion
ehci_hcd 0000:00:02.2: GetStatus port 3 status 003001 POWER OWNER sig=3Dse0=
 CONNECT
hub 1-0:1.0: port 3 not reset yet, waiting 50ms
input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio1/input/inp=
ut5
ehci_hcd 0000:00:02.2: GetStatus port 3 status 003802 POWER OWNER sig=3Dj C=
SC
hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0008
hub 2-0:1.0: state 7 ports 3 chg 0000 evt 0000
drivers/usb/core/inode.c: creating file '001'
PCI: Enabling device 0000:00:02.1 (0004 -> 0006)
ACPI: PCI Interrupt Link [LUS1] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUS1] -> GSI 20 (level, low) -=
> IRQ 20
PCI: Setting latency timer of device 0000:00:02.1 to 64
ohci_hcd 0000:00:02.1: OHCI Host Controller
drivers/usb/core/inode.c: creating file '003'
ohci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:02.1: USB HC TakeOver from BIOS/SMM
ohci_hcd 0000:00:02.1: created debug files
ohci_hcd 0000:00:02.1: irq 20, io mem 0xe0001000
ohci_hcd 0000:00:02.1: OHCI controller state
ohci_hcd 0000:00:02.1: OHCI 1.0, NO legacy support registers
ohci_hcd 0000:00:02.1: control 0x683 RWE RWC HCFS=3Doperational CBSR=3D3
ohci_hcd 0000:00:02.1: cmdstatus 0x00000 SOC=3D0
ohci_hcd 0000:00:02.1: intrstatus 0x00000044 RHSC SF
ohci_hcd 0000:00:02.1: intrenable 0x8000000a MIE RD WDH
ohci_hcd 0000:00:02.1: hcca frame #0003
ohci_hcd 0000:00:02.1: roothub.a 01000203 POTPGT=3D1 NPS NDP=3D3(3)
ohci_hcd 0000:00:02.1: roothub.b 00000000 PPCM=3D0000 DR=3D0000
ohci_hcd 0000:00:02.1: roothub.status 00008000 DRWE
ohci_hcd 0000:00:02.1: roothub.portstatus [0] 0x00010101 CSC PPS CCS
ohci_hcd 0000:00:02.1: roothub.portstatus [1] 0x00000100 PPS
ohci_hcd 0000:00:02.1: roothub.portstatus [2] 0x00000100 PPS
usb usb3: default language 0x0409
usb usb3: new device found, idVendor=3D0000, idProduct=3D0000
usb usb3: new device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.22-rc6-mm1 ohci_hcd
usb usb3: SerialNumber: 0000:00:02.1
usb usb3: uevent
usb usb3: usb_probe_device
usb usb3: configuration #1 chosen from 1 choice
usb usb3: adding 3-0:1.0 (config #1, interface 0)
usb 3-0:1.0: uevent
usb 3-0:1.0: uevent
hub 3-0:1.0: usb_probe_interface
hub 3-0:1.0: usb_probe_interface - got id
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 3 ports detected
hub 3-0:1.0: standalone hub
hub 3-0:1.0: no power switching (usb 1.0)
hub 3-0:1.0: global over-current protection
hub 3-0:1.0: power on to power good time: 2ms
hub 3-0:1.0: local power source is good
hub 3-0:1.0: no over-current condition exists
hub 3-0:1.0: trying to enable port power on non-switchable hub
hub 3-0:1.0: state 7 ports 3 chg 0000 evt 0000
drivers/usb/core/inode.c: creating file '001'
ohci_hcd 0000:00:02.1: GetStatus roothub.portstatus [0] =3D 0x00010101 CSC =
PPS CCS
hub 3-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
ohci_hcd 0000:00:02.1: GetStatus roothub.portstatus [0] =3D 0x00100103 PRSC=
 PPS PES CCS
usb 3-1: new full speed USB device using ohci_hcd and address 2
ACPI: PCI Interrupt Link [LACI] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LACI] -> GSI 22 (level, low) -=
> IRQ 22
PCI: Setting latency timer of device 0000:00:06.0 to 64
ohci_hcd 0000:00:02.1: GetStatus roothub.portstatus [0] =3D 0x00100103 PRSC=
 PPS PES CCS
usb 3-1: ep0 maxpacket =3D 8
usb 3-1: default language 0x0409
usb 3-1: new device found, idVendor=3D0451, idProduct=3D2036
usb 3-1: new device strings: Mfr=3D0, Product=3D1, SerialNumber=3D0
usb 3-1: Product: General Purpose USB Hub
usb 3-1: uevent
usb 3-1: usb_probe_device
usb 3-1: configuration #1 chosen from 1 choice
usb 3-1: adding 3-1:1.0 (config #1, interface 0)
usb 3-1:1.0: uevent
usb 3-1:1.0: uevent
hub 3-1:1.0: usb_probe_interface
hub 3-1:1.0: usb_probe_interface - got id
hub 3-1:1.0: USB hub found
hub 3-1:1.0: 2 ports detected
hub 3-1:1.0: compound device; port removable status: FF
hub 3-1:1.0: ganged power switching
hub 3-1:1.0: no over-current protection
hub 3-1:1.0: power on to power good time: 100ms
hub 3-1:1.0: hub controller current requirement: 100mA
hub 3-1:1.0: 100mA bus power budget for each child
hub 3-1:1.0: enabling power on all ports
AC'97 0 analog subsections not ready
drivers/usb/core/inode.c: creating file '002'
hub 3-0:1.0: state 7 ports 3 chg 0000 evt 0002
hub 3-1:1.0: state 7 ports 2 chg 0000 evt 0000
hub 3-1:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
hub 3-1:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
usb 3-1.1: new low speed USB device using ohci_hcd and address 3
ohci_hcd 0000:00:02.0: auto-stop root hub
usb 3-1.1: skipped 1 descriptor after interface
usb 3-1.1: skipped 1 descriptor after interface
usb 3-1.1: default language 0x0409
usb 3-1.1: new device found, idVendor=3D046d, idProduct=3Dc704
usb 3-1.1: new device strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
usb 3-1.1: Product: USB Receiver
usb 3-1.1: Manufacturer: Logitech
usb 3-1.1: SerialNumber: 04E5EF
usb 3-1.1: uevent
usb 3-1.1: usb_probe_device
usb 3-1.1: configuration #1 chosen from 1 choice
usb 3-1.1: adding 3-1.1:1.0 (config #1, interface 0)
usb 3-1.1:1.0: uevent
usb 3-1.1:1.0: uevent
usb 3-1.1: adding 3-1.1:1.1 (config #1, interface 1)
usb 3-1.1:1.1: uevent
usb 3-1.1:1.1: uevent
drivers/usb/core/inode.c: creating file '003'
hub 3-1:1.0: 302mA power budget left
hub 3-1:1.0: state 7 ports 2 chg 0000 evt 0002
intel8x0_measure_ac97_clock: measured 50428 usecs
intel8x0: measured clock 634 rejected
intel8x0: clocking to 48000
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend
ehci_hcd 0000:00:02.2: suspend root hub
hub 2-0:1.0: hub_suspend
usb usb2: bus auto-suspend
ohci_hcd 0000:00:02.0: suspend root hub
usbhid 3-1.1:1.0: usb_probe_interface
usbhid 3-1.1:1.0: usb_probe_interface - got id
input: Logitech USB Receiver as /devices/pci0000:00/0000:00:02.1/usb3/3-1/3=
-1.1/3-1.1:1.0/input/input6
input: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:02.1-1=
.1
usbhid 3-1.1:1.1: usb_probe_interface
usbhid 3-1.1:1.1: usb_probe_interface - got id
input: Logitech USB Receiver as /devices/pci0000:00/0000:00:02.1/usb3/3-1/3=
-1.1/3-1.1:1.1/input/input7
input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:02.1-1.1
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
NET: Registered protocol family 10
ReiserFS: sda1: found reiserfs format "3.6" with standard journal
ReiserFS: sda1: using ordered data mode
ReiserFS: sda1: journal params: device sda1, size 8192, journal first block=
 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda1: checking transaction log (sda1)
ReiserFS: sda1: Using r5 hash to sort names
Adding 2843496k swap on /dev/disk/by-uuid/fd35277a-8dc7-4afe-8257-fda61b757=
344.  Priority:100 extents:1 across:2843496k
eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
netconsole: local port 6665
netconsole: interface eth0
netconsole: remote port 6666
netconsole: remote IP 192.168.100.113
netconsole: remote ethernet address 00:0a:e6:a7:29:60
netconsole: local IP 192.168.100.213
console [netcon0] enabled
netconsole: network logging started
eth0: no IPv6 routers present
Hangcheck: hangcheck value past margin!

[snip many hangchecks]

ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A
Hangcheck: hangcheck value past margin!

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
[ INFO: possible circular locking dependency detected ]
2.6.22-rc6-mm1 #4
-------------------------------------------------------
evolution-data-/469063 is trying to acquire lock:
 (&mm->mmap_sem){----}, at: [<ffffffff80530d4c>] do_page_fault+0x17c/0x8c0

but task is already holding lock:
 (&data->latch){----}, at: [<ffffffff8034ebb1>] get_exclusive_access+0x11/0=
x20

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&data->latch){----}:
       [<ffffffff80261bab>] __lock_acquire+0xc8b/0x1180
       [<ffffffff802620f3>] lock_acquire+0x53/0x70
       [<ffffffff8034ebb1>] get_exclusive_access+0x11/0x20
       [<ffffffff802583af>] down_write+0x2f/0x40
       [<ffffffff8034ebb1>] get_exclusive_access+0x11/0x20
       [<ffffffff8034dd58>] mmap_unix_file+0x58/0x140
       [<ffffffff802981c5>] mmap_region+0x195/0x540
       [<ffffffff80298bce>] do_mmap_pgoff+0x2fe/0x390
       [<ffffffff8052e7df>] _spin_unlock_irq+0x2f/0x50
       [<ffffffff802e928e>] elf_map+0x11e/0x180
       [<ffffffff802ea9ba>] load_elf_binary+0x6ea/0x2050
       [<ffffffff802614a3>] __lock_acquire+0x583/0x1180
       [<ffffffff8052e669>] _spin_unlock+0x29/0x50
       [<ffffffff80291871>] follow_page+0x241/0x270
       [<ffffffff80293598>] get_user_pages+0x2e8/0x430
       [<ffffffff802614a3>] __lock_acquire+0x583/0x1180
       [<ffffffff80231380>] load_aout_binary+0x0/0x980
       [<ffffffff802ea2d0>] load_elf_binary+0x0/0x2050
       [<ffffffff802b1846>] search_binary_handler+0xf6/0x290
       [<ffffffff802b36f1>] do_execve+0x1b1/0x1f0
       [<ffffffff8020aae4>] sys_execve+0x44/0xb0
       [<ffffffff8020c5d7>] stub_execve+0x67/0xb0
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&mm->mmap_sem){----}:
       [<ffffffff8025fd98>] print_circular_bug_header+0xe8/0xf0
       [<ffffffff802619e0>] __lock_acquire+0xac0/0x1180
       [<ffffffff802620f3>] lock_acquire+0x53/0x70
       [<ffffffff80530d4c>] do_page_fault+0x17c/0x8c0
       [<ffffffff80258472>] down_read+0x32/0x40
       [<ffffffff80530d4c>] do_page_fault+0x17c/0x8c0
       [<ffffffff802a7704>] check_object+0x224/0x260
       [<ffffffff8052ee0d>] error_exit+0x0/0x96
       [<ffffffff8034ccbb>] read_unix_file+0x1bb/0x4c0
       [<ffffffff8034cc5b>] read_unix_file+0x15b/0x4c0
       [<ffffffff802352fb>] try_to_wake_up+0x6b/0x3e0
       [<ffffffff802ad995>] vfs_read+0xc5/0x180
       [<ffffffff802ade93>] sys_read+0x53/0x90
       [<ffffffff8020c1de>] system_call+0x7e/0x83
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

1 lock held by evolution-data-/469063:
 #0:  (&data->latch){----}, at: [<ffffffff8034ebb1>] get_exclusive_access+0=
x11/0x20

stack backtrace:

Call Trace:
 [<ffffffff8025f8e3>] print_circular_bug_tail+0x83/0x90
 [<ffffffff8025fd98>] print_circular_bug_header+0xe8/0xf0
 [<ffffffff802619e0>] __lock_acquire+0xac0/0x1180
 [<ffffffff802620f3>] lock_acquire+0x53/0x70
 [<ffffffff80530d4c>] do_page_fault+0x17c/0x8c0
 [<ffffffff80258472>] down_read+0x32/0x40
 [<ffffffff80530d4c>] do_page_fault+0x17c/0x8c0
 [<ffffffff802a7704>] check_object+0x224/0x260
 [<ffffffff8052ee0d>] error_exit+0x0/0x96
 [<ffffffff8034ccbb>] read_unix_file+0x1bb/0x4c0
 [<ffffffff8034cc5b>] read_unix_file+0x15b/0x4c0
 [<ffffffff802352fb>] try_to_wake_up+0x6b/0x3e0
 [<ffffffff802ad995>] vfs_read+0xc5/0x180
 [<ffffffff802ade93>] sys_read+0x53/0x90
 [<ffffffff8020c1de>] system_call+0x7e/0x83

INFO: lockdep is turned off.
Hangcheck: hangcheck value past margin!
Hangcheck: hangcheck value past margin!
Hangcheck: hangcheck value past margin!
Hangcheck: hangcheck value past margin!
Hangcheck: hangcheck value past margin!
Hangcheck: hangcheck value past margin!
Hangcheck: hangcheck value past margin!
Hangcheck: hangcheck value past margin!
Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP:=20
 [<ffffffff8033d324>] reiser4_tree_by_page+0x4/0x20
PGD 17594067 PUD d025067 PMD 0=20
Oops: 0000 [1] PREEMPT SMP=20
CPU 0=20
Modules linked in: nls_iso8859_1 isofs nls_base snd_pcm_oss snd_mixer_oss n=
etconsole ipv6 usbhid hid snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_=
timer psmouse serio_raw evdev snd snd_page_alloc ohci_hcd ehci_hcd usbcore =
sg
Pid: 469720, comm: rhythmbox Not tainted 2.6.22-rc6-mm1 #4
RIP: 0010:[<ffffffff8033d324>]  [<ffffffff8033d324>] reiser4_tree_by_page+0=
x4/0x20
RSP: 0018:ffff81000ba03940  EFLAGS: 00010296
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000000000c
RDX: 0000000000000559 RSI: 0000000000000000 RDI: ffff810001433a88
RBP: ffff810001433a88 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: ffffffff8035a350 R12: ffff810001433a88
R13: ffff81000ba03a90 R14: ffff8100125e0224 R15: ffff8100125e0224
FS:  0000000043806940(0063) GS:ffffffff8075b000(0000) knlGS:00000000f7cd76b=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000004b9e000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rhythmbox (pid: 469720, threadinfo ffff81000ba02000, task ffff81001=
3c4edd0)
Stack:  ffffffff8032649a ffff81000ba03a90 0000000000000000 ffff810001433a88
 ffff81000ba03a58 ffff81000ba03a90 ffff8100125e0224 ffff8100125e0224
 ffffffff8034db75 ffff810000000002 ffff810000000002 ffff810000000002
Call Trace:
 [<ffffffff8032649a>] jnode_of_page+0x2a/0x2c0
 [<ffffffff8034db75>] uf_readpages_filler+0x235/0x300
 [<ffffffff8034d940>] uf_readpages_filler+0x0/0x300
 [<ffffffff8028a586>] read_cache_pages+0x96/0xc0
 [<ffffffff8034dc96>] readpages_unix_file+0x56/0xc0
 [<ffffffff8028a381>] __do_page_cache_readahead+0x1e1/0x2c0
 [<ffffffff8028a66b>] ondemand_readahead+0xbb/0x120
 [<ffffffff80282bc6>] do_generic_mapping_read+0x1b6/0x4b0
 [<ffffffff80281fb0>] file_read_actor+0x0/0x1b0
 [<ffffffff80284f46>] generic_file_aio_read+0x106/0x1c0
 [<ffffffff802ad019>] do_sync_read+0xd9/0x120
 [<ffffffff802a723b>] check_bytes_and_report+0x4b/0x100
 [<ffffffff802a7704>] check_object+0x224/0x260
 [<ffffffff80254580>] autoremove_wake_function+0x0/0x30
 [<ffffffff8052e669>] _spin_unlock+0x29/0x50
 [<ffffffff80330e2c>] reiser4_grab+0x8c/0xd0
 [<ffffffff8034cf9f>] read_unix_file+0x49f/0x4c0
 [<ffffffff802ad995>] vfs_read+0xc5/0x180
 [<ffffffff802ade93>] sys_read+0x53/0x90
 [<ffffffff8020c1de>] system_call+0x7e/0x83

INFO: lockdep is turned off.

Code: 48 8b 00 48 8b 80 d0 01 00 00 48 8b 80 18 04 00 00 48 83 c0=20
RIP  [<ffffffff8033d324>] reiser4_tree_by_page+0x4/0x20
 RSP <ffff81000ba03940>
CR2: 0000000000000000

--=20
Zan Lynx <zlynx@acm.org>

--=-R9kFVlrp3TEaBCr9sBFX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.5 (GNU/Linux)

iD8DBQBGl6tRG8fHaOLTWwgRAhhfAJ4p8ZNTiPtrZ0SRRvtD7KHb2tN0bQCdGLSx
l8OfFmEmfavztRIJtfNWQMY=
=8VvW
-----END PGP SIGNATURE-----

--=-R9kFVlrp3TEaBCr9sBFX--

