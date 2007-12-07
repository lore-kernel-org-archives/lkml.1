Return-Path: <linux-kernel-owner+w=401wt.eu-S1757224AbXLGUij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224AbXLGUij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 15:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbXLGUib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 15:38:31 -0500
Received: from threatwall.zlynx.org ([199.45.143.218]:34507 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752053AbXLGUi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 15:38:28 -0500
Subject: 2.6.24-rc4-mm1 and Very Slow PCMCIA Compact Flash
From: Zan Lynx <zlynx@acm.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-pcmcia@lists.infradead.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DWyxZK42HvbOby9x65V2"
Date: Fri, 07 Dec 2007 20:38:24 +0000
Message-Id: <1197059904.15428.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20071207/1J0jxp-0000VB-Fs-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DWyxZK42HvbOby9x65V2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

While I'm reporting problems I'll get this one out there.

I normally use a USB-2 memory card reader but I also have a PCMCIA
CompactFlash adapter that I use occasionally.  During the MM series
kernels 2.6.22 and 23 (I am pretty sure) this didn't work at all.  I
don't know about vanilla since I don't run that.

Now with MM kernels 2.6.24 rc1-4 the PCMCIA adapter works again, but I
only get read rates of 1.6 MB/s.  When it used to work in 2.6.20 I got
at least 16 MB/s.  The card itself is capable of 30+ in the USB-2
reader.

It might be that it auto-configures for PIO-0.  I have no idea why it
does that.

Another interesting thing is that doing a dd to or from the card brings
the rest of the system to a nearly complete halt.  Interrupt problem?

Here is dmesg:
Linux version 2.6.24-rc4-mm1 (root@zephyr) (gcc version 4.2.2 (Gentoo 4.2.2=
 p1.0)) #1 SMP Thu Dec 6 14:05:21 MST 2007
Command line: root=3D/dev/sda2 rootfstype=3Dreiser4 rootflags=3Dno_write_ba=
rrier,tmgr.atom_max_size=3D8000 ro i8042.nomux elevator=3Dcfq resume=3D/dev=
/sda3 panic=3D5 nmi_watchdog=3D0,panic debug kernelcore=3D512M
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
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001400000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001800000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001c00000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff810001e00000 on node 0
 [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002200000 on node 0
 [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002600000 on node 0
 [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002a00000 on node 0
 [ffffe20001000000-ffffe200011fffff] PMD ->ffff810002c00000 on node 0
 [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003000000 on node 0
 [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003400000 on node 0
sizeof(struct page) =3D 88
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
  Node 0: 132096
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   262000
On node 0 totalpages: 261903
  DMA zone: 88 pages used for memmap
  DMA zone: 2673 pages reserved
  DMA zone: 1238 pages, LIFO batch:0
  DMA32 zone: 2750 pages used for memmap
  DMA32 zone: 125250 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 2790 pages used for memmap
  Movable zone: 127114 pages, LIFO batch:31
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
PERCPU: Allocating 35008 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 253602
Kernel command line: root=3D/dev/sda2 rootfstype=3Dreiser4 rootflags=3Dno_w=
rite_barrier,tmgr.atom_max_size=3D8000 ro i8042.nomux elevator=3Dcfq resume=
=3D/dev/sda3 panic=3D5 nmi_watchdog=3D0,panic debug kernelcore=3D512M
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
time.c: Detected 797.941 MHz processor.
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
Memory: 1011836k/1048000k available (3418k kernel code, 34952k reserved, 16=
05k data, 1124k init)
SLUB: Genslabs=3D11, HWalign=3D64, Order=3D0-1, MinObjects=3D4, CPUs=3D1, N=
odes=3D1
Calibrating delay using timer specific routine.. 1597.27 BogoMIPS (lpj=3D79=
8637)
Security Framework initialized
Capability LSM initialized
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
 tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquire=
d
evxfevnt-0091 [00] enable                : Transition to ACPI mode successf=
ul
Using local APIC timer interrupts.
APIC timer calibration result 12467833
Detected 12.467 MHz APIC timer.
Brought up 1 CPUs
CPU0 attaching NULL sched-domain.
net_namespace: 240 bytes
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
ACPI: EC: Look up EC in DSDT
Completing Region/Field/Buffer/Package initialization:.....................=
...............................................
Initialized 24/24 Regions 2/2 Fields 28/29 Buffers 14/21 Packages (662 node=
s)
Initializing Device/Processor/Thermal objects by executing _INI methods:.
Executed 1 _INI methods requiring 0 _STA executions (examined 70 objects)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE =3D 0x21, I/O: command/status =3D 0x66, data =3D 0x62
ACPI: EC: driver started in poll mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
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
ACPI: EC: non-query interrupt received, switching to interrupt mode
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post a r=
eport
PCI: Cannot allocate resource region 0 of device 0000:00:00.0
PCI: Cannot allocate resource region 4 of device 0000:00:01.1
PCI: Cannot allocate resource region 5 of device 0000:00:01.1
agpgart: Detected AGP bridge 0
agpgart: Setting up Nforce3 AGP.
agpgart: AGP aperture is 128M @ 0xe8000000
Time: tsc clocksource has been installed.
system 00:01: ioport range 0x8000-0x807f has been reserved
system 00:01: ioport range 0x8080-0x80ff has been reserved
system 00:01: ioport range 0x8400-0x847f has been reserved
system 00:01: ioport range 0x8480-0x84ff has been reserved
system 00:01: ioport range 0x8800-0x887f has been reserved
system 00:01: ioport range 0x8880-0x88ff has been reserved
system 00:01: ioport range 0x2040-0x207f has been reserved
system 00:01: ioport range 0x2000-0x203f has been reserved
system 00:02: iomem range 0xfff80000-0xffffffff could not be reserved
system 00:02: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:02: iomem range 0xfee00000-0xfeefffff could not be reserved
system 00:02: iomem range 0xfed00000-0xfed00fff has been reserved
system 00:03: ioport range 0x200-0x20f has been reserved
system 00:03: ioport range 0x680-0x6ff has been reserved
system 00:03: ioport range 0x4d0-0x4d1 has been reserved
system 00:03: ioport range 0xfe00-0xfe01 has been reserved
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
PCI: Failed to allocate mem resource #6:20000@e3000000 for 0000:01:00.0
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
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Simple Boot Flag at 0x37 set to 0x1
audit: initializing netlink socket (disabled)
audit(1197044649.870:1): initialized
Total HugeTLB memory allocated, 0
Loading Reiser4. See www.namesys.com for a description of Reiser4.
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:01:00.0
ACPI: AC Adapter [ACAD] (on-line)
Switched to high resolution mode on CPU 0
ACPI: Battery Slot [BAT1] (battery present)
input: Power Button (FF) as /devices/virtual/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /devices/virtual/input/input1
ACPI: Power Button (CM) [PWRB]
input: Lid Switch as /devices/virtual/input/input2
ACPI: Lid Switch [LID]
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:18/LNX=
VIDEO:00/input/input3
ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI Exception (thermal-0471): AE_NOT_FOUND, Invalid active threshold [0] [=
20070126]
ACPI: Thermal Zone [THRM] (25 C)
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.103
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 6=
0 seconds).
Hangcheck: Using get_cycles().
loop: module loaded
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt 0000:02:01.0[A] -> Link [LNK2] -> GSI 18 (level, low) -=
> IRQ 18
eth0: RealTek RTL8139 at 0xffffc2000001e800, 00:0f:b0:07:dc:49, IRQ 18
eth0:  Identified 8139 chip type 'RTL-8101'
pata_amd 0000:00:08.0: version 0.3.10
PCI: Setting latency timer of device 0000:00:08.0 to 64
scsi0 : pata_amd
scsi1 : pata_amd
ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x2080 irq 14
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x2088 irq 15
ata1.00: ATA-6: HTS721010G9AT00, MCZOA51A, max UDMA/100
ata1.00: 195371568 sectors, multi 16: LBA48=20
ata1: nv_mode_filter: 0x3f39f&0x3f01f->0x3f01f, BIOS=3D0x3f000 (0xc6000000)=
 ACPI=3D0x3f01f (20:600:0x13)
ata1.00: configured for UDMA/100
ata2.00: ATAPI: HL-DT-ST DVD+RW GCA-4040N, 1.19, max MWDMA2
ata2: nv_mode_filter: 0x39f&0x39f->0x39f, BIOS=3D0x0 (0xc6000000) ACPI=3D0x=
39f (120:600:0x12)
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
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
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
Socket status: 30000051
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
/input4
pccard: PCMCIA card inserted into slot 0
cs: memory probe 0x50000000-0x57ffffff: excluding 0x50000000-0x57ffffff
cs: memory probe 0xe0100000-0xe17fffff: excluding 0xe0100000-0xe026ffff 0xe=
03e0000-0xe082ffff 0xe0b10000-0xe10cffff
pcmcia: registering new device pcmcia0.0
scsi2 : pata_pcmcia
ata3: PATA max PIO0 cmd 0x3100 ctl 0x310e irq 19
ata3.00: CFA: LEXAR ATA FLASH, V2.00, max PIO6
ata3.00: 8018640 sectors, multi 0: LBA=20
ata3.00: configured for PIO0
ata3.00: configured for PIO0
ata3: EH complete
isa bounce pool size: 16 pages
scsi 2:0:0:0: Direct-Access     ATA      LEXAR ATA FLASH  V2.0 PQ: 0 ANSI: =
5
sd 2:0:0:0: [sdb] 8018640 512-byte hardware sectors (4106 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't suppo=
rt DPO or FUA
sd 2:0:0:0: [sdb] 8018640 512-byte hardware sectors (4106 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't suppo=
rt DPO or FUA
 sdb: sdb1
sd 2:0:0:0: [sdb] Attached SCSI removable disk
cpuidle: using governor menu
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3400+ processors (1 cpu co=
res) (version 2.20.00)
powernow-k8:    0 : fid 0xe (2200 MHz), vid 0x2
powernow-k8:    1 : fid 0xa (1800 MHz), vid 0xa
powernow-k8:    2 : fid 0x0 (800 MHz), vid 0x12
Marking TSC unstable due to TSC halts in idle
Time: acpi_pm clocksource has been installed.
swsusp: Resume From Partition /dev/sda3
PM: Checking swsusp image.
PM: Resume from disk failed.
registered taskstats version 1
Freeing unused kernel memory: 1124k freed
reiser4: sda2: found disk format 4.0.0.
sd 0:0:0:0: Attached scsi generic sg0 type 0
sr 1:0:0:0: Attached scsi generic sg1 type 5
sd 2:0:0:0: Attached scsi generic sg2 type 0
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Clocksource tsc unstable (delta =3D 463491454 ns)
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 80 td 96
PCI: Enabling device 0000:00:02.0 (0004 -> 0006)
ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUS0] -> GSI 22 (level, low) -=
> IRQ 22
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
drivers/usb/core/inode.c: creating file 'devices'
drivers/usb/core/inode.c: creating file '001'
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:02.0: USB HC TakeOver from BIOS/SMM
ohci_hcd 0000:00:02.0: created debug files
ohci_hcd 0000:00:02.0: irq 22, io mem 0xe0000000
ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
ohci_hcd 0000:00:02.0: OHCI controller state
ohci_hcd 0000:00:02.0: OHCI 1.0, NO legacy support registers
ohci_hcd 0000:00:02.0: control 0x683 RWE RWC HCFS=3Doperational CBSR=3D3
ohci_hcd 0000:00:02.0: cmdstatus 0x00000 SOC=3D0
ohci_hcd 0000:00:02.0: intrstatus 0x00000044 RHSC SF
ohci_hcd 0000:00:02.0: intrenable 0x8000000a MIE RD WDH
ohci_hcd 0000:00:02.0: hcca frame #0003
ohci_hcd 0000:00:02.0: roothub.a 01000203 POTPGT=3D1 NPS NDP=3D3(3)
ohci_hcd 0000:00:02.0: roothub.b 00000000 PPCM=3D0000 DR=3D0000
ohci_hcd 0000:00:02.0: roothub.status 00008000 DRWE
ohci_hcd 0000:00:02.0: roothub.portstatus [0] 0x00010101 CSC PPS CCS
ohci_hcd 0000:00:02.0: roothub.portstatus [1] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [2] 0x00000100 PPS
usb usb1: default language 0x0409
usb usb1: uevent
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: global over-current protection
hub 1-0:1.0: power on to power good time: 2ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: no over-current condition exists
hub 1-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
usb usb1: New USB device found, idVendor=3D0000, idProduct=3D0000
usb usb1: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb1: Product: OHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.24-rc4-mm1 ohci_hcd
usb usb1: SerialNumber: 0000:00:02.0
PCI: Enabling device 0000:00:02.1 (0004 -> 0006)
ACPI: PCI Interrupt Link [LUS1] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUS1] -> GSI 21 (level, low) -=
> IRQ 21
PCI: Setting latency timer of device 0000:00:02.1 to 64
ohci_hcd 0000:00:02.1: OHCI Host Controller
drivers/usb/core/inode.c: creating file '002'
ohci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.1: USB HC TakeOver from BIOS/SMM
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0002
ohci_hcd 0000:00:02.0: GetStatus roothub.portstatus [0] =3D 0x00010101 CSC =
PPS CCS
hub 1-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
ohci_hcd 0000:00:02.1: created debug files
ohci_hcd 0000:00:02.1: irq 21, io mem 0xe0001000
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
ohci_hcd 0000:00:02.1: roothub.portstatus [0] 0x00000100 PPS
ohci_hcd 0000:00:02.1: roothub.portstatus [1] 0x00010101 CSC PPS CCS
ohci_hcd 0000:00:02.1: roothub.portstatus [2] 0x00000100 PPS
usb usb2: default language 0x0409
usb usb2: uevent
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
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
hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
drivers/usb/core/inode.c: creating file '001'
usb usb2: New USB device found, idVendor=3D0000, idProduct=3D0000
usb usb2: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.24-rc4-mm1 ohci_hcd
usb usb2: SerialNumber: 0000:00:02.1
ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:02.2[C] -> Link [LUS2] -> GSI 20 (level, low) -=
> IRQ 20
PCI: Setting latency timer of device 0000:00:02.2 to 64
ehci_hcd 0000:00:02.2: EHCI Host Controller
drivers/usb/core/inode.c: creating file '003'
ehci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 3
ehci_hcd 0000:00:02.2: reset hcs_params 0x102486 dbg=3D1 cc=3D2 pcc=3D4 !pp=
c ports=3D6
ehci_hcd 0000:00:02.2: reset portroute 0 0 1 1 1 0=20
ehci_hcd 0000:00:02.2: reset hcc_params a086 caching frame 256/512/1024 par=
k
ehci_hcd 0000:00:02.2: park 0
ehci_hcd 0000:00:02.2: reset command 080b02 park=3D3 ithresh=3D8 period=3D1=
024 Reset HALT
PCI: cache line size of 64 is not supported by device 0000:00:02.2
ehci_hcd 0000:00:02.2: supports USB remote wakeup
ehci_hcd 0000:00:02.2: irq 20, io mem 0xe0004000
ehci_hcd 0000:00:02.2: reset command 080b02 park=3D3 ithresh=3D8 period=3D1=
024 Reset HALT
ehci_hcd 0000:00:02.2: init command 010009 (park)=3D0 ithresh=3D1 period=3D=
256 RUN
ohci_hcd 0000:00:02.0: GetStatus roothub.portstatus [0] =3D 0x00100103 PRSC=
 PPS PES CCS
input: PS/2 Mouse as /devices/virtual/input/input5
usb 1-1: new full speed USB device using ohci_hcd and address 2
ohci_hcd 0000:00:02.0: urb ffff81001e1d3630 path 1 ep0in 5ec20000 cc 5 --> =
status -62
ohci_hcd 0000:00:02.0: urb ffff81001e1d3630 path 1 ep0in 5ec20000 cc 5 --> =
status -62
ehci_hcd 0000:00:02.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb3: default language 0x0409
usb usb3: uevent
usb usb3: usb_probe_device
usb usb3: configuration #1 chosen from 1 choice
usb usb3: adding 3-0:1.0 (config #1, interface 0)
usb 3-0:1.0: uevent
hub 3-0:1.0: usb_probe_interface
hub 3-0:1.0: usb_probe_interface - got id
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 6 ports detected
hub 3-0:1.0: standalone hub
hub 3-0:1.0: no power switching (usb 1.0)
hub 3-0:1.0: individual port over-current protection
hub 3-0:1.0: Single TT
hub 3-0:1.0: TT requires at most 8 FS bit times (666 ns)
hub 3-0:1.0: power on to power good time: 20ms
hub 3-0:1.0: local power source is good
hub 3-0:1.0: trying to enable port power on non-switchable hub
ohci_hcd 0000:00:02.0: urb ffff81001e1d3630 path 1 ep0in 5ec20000 cc 5 --> =
status -62
input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio1/input/inp=
ut6
ohci_hcd 0000:00:02.0: GetStatus roothub.portstatus [0] =3D 0x00030100 PESC=
 CSC PPS
hub 2-0:1.0: state 7 ports 3 chg 0000 evt 0004
ohci_hcd 0000:00:02.1: GetStatus roothub.portstatus [1] =3D 0x00010100 CSC =
PPS
hub 2-0:1.0: port 2, status 0100, change 0001, 12 Mb/s
drivers/usb/core/inode.c: creating file '001'
usb usb3: New USB device found, idVendor=3D0000, idProduct=3D0000
usb usb3: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb3: Product: EHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.24-rc4-mm1 ehci_hcd
usb usb3: SerialNumber: 0000:00:02.2
ACPI: PCI Interrupt Link [LACI] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LACI] -> GSI 22 (level, low) -=
> IRQ 22
PCI: Setting latency timer of device 0000:00:06.0 to 64
hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0002
ohci_hcd 0000:00:02.0: GetStatus roothub.portstatus [0] =3D 0x00030100 PESC=
 CSC PPS
hub 1-0:1.0: port 1, status 0100, change 0003, 12 Mb/s
AC'97 0 analog subsections not ready
hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100
hub 3-0:1.0: state 7 ports 6 chg 0000 evt 0000
ehci_hcd 0000:00:02.2: GetStatus port 1 status 001803 POWER sig=3Dj CSC CON=
NECT
hub 3-0:1.0: port 1, status 0501, change 0001, 480 Mb/s
hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:02.2: port 1 high speed
ehci_hcd 0000:00:02.2: GetStatus port 1 status 001005 POWER sig=3Dse0 PE CO=
NNECT
usb 3-1: new high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:02.2: port 1 high speed
ehci_hcd 0000:00:02.2: GetStatus port 1 status 001005 POWER sig=3Dse0 PE CO=
NNECT
usb 3-1: default language 0x0409
usb 3-1: uevent
usb 3-1: usb_probe_device
usb 3-1: configuration #1 chosen from 1 choice
usb 3-1: adding 3-1:1.0 (config #1, interface 0)
usb 3-1:1.0: uevent
hub 3-1:1.0: usb_probe_interface
hub 3-1:1.0: usb_probe_interface - got id
hub 3-1:1.0: USB hub found
hub 3-1:1.0: 4 ports detected
hub 3-1:1.0: standalone hub
hub 3-1:1.0: ganged power switching
hub 3-1:1.0: global over-current protection
hub 3-1:1.0: Single TT
hub 3-1:1.0: TT requires at most 32 FS bit times (2664 ns)
hub 3-1:1.0: Port indicators are supported
hub 3-1:1.0: power on to power good time: 100ms
hub 3-1:1.0: local power source is good
hub 3-1:1.0: no over-current condition exists
hub 3-1:1.0: enabling power on all ports
usb 3-1: link qh256-0001/ffff81001e180140 start 255 [1/0 us]
drivers/usb/core/inode.c: creating file '002'
usb 3-1: New USB device found, idVendor=3D05e3, idProduct=3D0608
usb 3-1: New USB device strings: Mfr=3D0, Product=3D1, SerialNumber=3D0
usb 3-1: Product: USB2.0 Hub
ehci_hcd 0000:00:02.2: GetStatus port 4 status 001803 POWER sig=3Dj CSC CON=
NECT
hub 3-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
intel8x0_measure_ac97_clock: measured 50861 usecs
intel8x0: measured clock 629 rejected
intel8x0: clocking to 48000
ACPI: PCI Interrupt Link [LNK5] enabled at IRQ 16
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNK5] -> GSI 16 (level, low) -=
> IRQ 16
nvidiafb: Device ID: 10de0179=20
nvidiafb: CRTC0 analog not found
nvidiafb: CRTC1 analog not found
hub 3-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:02.2: port 4 full speed --> companion
ehci_hcd 0000:00:02.2: GetStatus port 4 status 003001 POWER OWNER sig=3Dse0=
 CONNECT
hub 3-0:1.0: port 4 not reset yet, waiting 50ms
i2c-adapter i2c-0: unable to read EDID block.
ehci_hcd 0000:00:02.2: GetStatus port 4 status 003802 POWER OWNER sig=3Dj C=
SC
hub 3-1:1.0: state 7 ports 4 chg 0000 evt 0000
hub 3-1:1.0: port 1, status 0101, change 0001, 12 Mb/s
i2c-adapter i2c-0: unable to read EDID block.
hub 3-1:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
hub 3-1:1.0: port 1 not reset yet, waiting 10ms
usb 3-1.1: new full speed USB device using ehci_hcd and address 4
hub 3-1:1.0: port 1 not reset yet, waiting 10ms
i2c-adapter i2c-0: unable to read EDID block.
usb 3-1.1: ep0 maxpacket =3D 8
usb 3-1.1: default language 0x0409
usb 3-1.1: uevent
usb 3-1.1: usb_probe_device
usb 3-1.1: configuration #1 chosen from 1 choice
usb 3-1.1: adding 3-1.1:1.0 (config #1, interface 0)
usb 3-1.1:1.0: uevent
hub 3-1.1:1.0: usb_probe_interface
hub 3-1.1:1.0: usb_probe_interface - got id
hub 3-1.1:1.0: USB hub found
hub 3-1.1:1.0: 2 ports detected
hub 3-1.1:1.0: compound device; port removable status: FF
hub 3-1.1:1.0: ganged power switching
hub 3-1.1:1.0: no over-current protection
hub 3-1.1:1.0: power on to power good time: 100ms
hub 3-1.1:1.0: hub controller current requirement: 100mA
hub 3-1.1:1.0: 100mA bus power budget for each child
hub 3-1.1:1.0: enabling power on all ports
i2c-adapter i2c-1: unable to read EDID block.
usb 3-1.1: link qh128-0e01/ffff81001e180280 start 127 [1/2 us]
drivers/usb/core/inode.c: creating file '004'
usb 3-1.1: New USB device found, idVendor=3D0451, idProduct=3D2036
usb 3-1.1: New USB device strings: Mfr=3D0, Product=3D1, SerialNumber=3D0
usb 3-1.1: Product: General Purpose USB Hub
hub 3-1:1.0: port 3, status 0101, change 0001, 12 Mb/s
hub 3-1:1.0: debounce: port 3: total 100ms stable 100ms status 0x101
hub 3-1:1.0: port 3 not reset yet, waiting 10ms
i2c-adapter i2c-1: unable to read EDID block.
usb 3-1.3: new high speed USB device using ehci_hcd and address 5
hub 3-1:1.0: port 3 not reset yet, waiting 10ms
usb 3-1.3: default language 0x0409
usb 3-1.3: uevent
usb 3-1.3: usb_probe_device
usb 3-1.3: configuration #1 chosen from 1 choice
usb 3-1.3: adding 3-1.3:1.0 (config #1, interface 0)
usb 3-1.3:1.0: uevent
drivers/usb/core/inode.c: creating file '005'
usb 3-1.3: New USB device found, idVendor=3D0781, idProduct=3Db4b5
usb 3-1.3: New USB device strings: Mfr=3D3, Product=3D4, SerialNumber=3D5
usb 3-1.3: Product: ImageMate 14 in 1 Reader/Writer=20
usb 3-1.3: Manufacturer: SanDisk=20
usb 3-1.3: SerialNumber: 0304237855
hub 3-1:1.0: port 4, status 0101, change 0001, 12 Mb/s
i2c-adapter i2c-1: unable to read EDID block.
nvidiafb: CRTC 1 is currently programmed for DFP
nvidiafb: Using DFP on CRTC 1
nvidiafb: Panel size is 1920 x 1200
nvidiafb: Panel is LVDS
nvidiafb: MTRR set to ON
fbcvt: 1920x1200@60: CVT Name - 2.304MA-R
nvidiafb: PCI nVidia NV17 framebuffer (64MB @ 0xF0000000)
hub 3-1:1.0: debounce: port 4: total 100ms stable 100ms status 0x101
usb 3-1.4: new full speed USB device using ehci_hcd and address 6
usb 3-1.4: ep0 maxpacket =3D 8
usb 3-1.4: default language 0x0409
usb 3-1.4: uevent
usb 3-1.4: usb_probe_device
usb 3-1.4: configuration #1 chosen from 1 choice
usb 3-1.4: adding 3-1.4:1.0 (config #1, interface 0)
usb 3-1.4:1.0: uevent
hub 3-1.4:1.0: usb_probe_interface
hub 3-1.4:1.0: usb_probe_interface - got id
hub 3-1.4:1.0: USB hub found
hub 3-1.4:1.0: 3 ports detected
hub 3-1.4:1.0: compound device; port removable status: FFF
hub 3-1.4:1.0: ganged power switching
hub 3-1.4:1.0: global over-current protection
hub 3-1.4:1.0: power on to power good time: 100ms
hub 3-1.4:1.0: local power source is good
hub 3-1.4:1.0: no over-current condition exists
hub 3-1.4:1.0: enabling power on all ports
usb 3-1.4: link qh128-0e01/ffff81001e180460 start 127 [1/2 us]
drivers/usb/core/inode.c: creating file '006'
usb 3-1.4: New USB device found, idVendor=3D045e, idProduct=3D0707
usb 3-1.4: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
usb 3-1.4: Product: Microsoft  USB Hub
usb 3-1.4: Manufacturer: Microsoft
hub 3-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 2-0:1.0: state 7 ports 3 chg 0000 evt 0004
ohci_hcd 0000:00:02.1: GetStatus roothub.portstatus [1] =3D 0x00010101 CSC =
PPS CCS
hub 2-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
libusual 3-1.3:1.0: usb_probe_interface
libusual 3-1.3:1.0: usb_probe_interface - got id
usbcore: registered new interface driver libusual
Initializing USB Mass Storage driver...
hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
ohci_hcd 0000:00:02.1: GetStatus roothub.portstatus [1] =3D 0x00100103 PRSC=
 PPS PES CCS
usb 2-2: new full speed USB device using ohci_hcd and address 2
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend
ohci_hcd 0000:00:02.0: suspend root hub
ohci_hcd 0000:00:02.1: GetStatus roothub.portstatus [1] =3D 0x00100103 PRSC=
 PPS PES CCS
usb 2-2: skipped 1 descriptor after interface
usb 2-2: default language 0x0409
usb 2-2: uevent
usb 2-2: usb_probe_device
usb 2-2: configuration #1 chosen from 1 choice
usb 2-2: adding 2-2:1.0 (config #1, interface 0)
usb 2-2:1.0: uevent
usb 2-2: adding 2-2:1.1 (config #1, interface 1)
usb 2-2:1.1: uevent
usb 2-2: adding 2-2:1.2 (config #1, interface 2)
usb 2-2:1.2: uevent
drivers/usb/core/inode.c: creating file '002'
usb 2-2: New USB device found, idVendor=3D049f, idProduct=3D0086
usb 2-2: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
usb 2-2: Product: Bluetooth by hp
usb 2-2: Manufacturer: ACTIONTEC
hub 3-1:1.0: state 7 ports 4 chg 0000 evt 0010
hub 3-1.1:1.0: state 7 ports 2 chg 0000 evt 0002
hub 3-1.1:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: HCI USB driver ver 2.9
hub 3-1.1:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
hub 3-1.1:1.0: port 1 not reset yet, waiting 10ms
usb 3-1.1.1: new low speed USB device using ehci_hcd and address 7
usb 3-1.1.1: skipped 1 descriptor after interface
usb 3-1.1.1: skipped 1 descriptor after interface
usb 3-1.1.1: default language 0x0409
usb 3-1.1.1: uevent
usb 3-1.1.1: usb_probe_device
usb 3-1.1.1: configuration #1 chosen from 1 choice
usb 3-1.1.1: adding 3-1.1.1:1.0 (config #1, interface 0)
usb 3-1.1.1:1.0: uevent
usb 3-1.1.1: adding 3-1.1.1:1.1 (config #1, interface 1)
usb 3-1.1.1:1.1: uevent
drivers/usb/core/inode.c: creating file '007'
usb 3-1.1.1: New USB device found, idVendor=3D046d, idProduct=3Dc704
usb 3-1.1.1: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
usb 3-1.1.1: Product: USB Receiver
usb 3-1.1.1: Manufacturer: Logitech
usb 3-1.1.1: SerialNumber: 04E5EF
hub 3-1.1:1.0: 302mA power budget left
hub 3-1.4:1.0: state 7 ports 3 chg 0000 evt 0008
usb-storage 3-1.3:1.0: usb_probe_interface
usb-storage 3-1.3:1.0: usb_probe_interface - got id
hub 3-1.4:1.0: port 3, status 0101, change 0001, 12 Mb/s
scsi3 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 5
usb-storage: waiting for device to settle before scanning
hub 3-1.4:1.0: debounce: port 3: total 100ms stable 100ms status 0x101
usb 3-1.4.3: new full speed USB device using ehci_hcd and address 8
usb 3-1.4.3: ep0 maxpacket =3D 8
usb 3-1.4.3: skipped 1 descriptor after interface
usb 3-1.4.3: default language 0x0409
usb 3-1.4.3: uevent
usb 3-1.4.3: usb_probe_device
usb 3-1.4.3: configuration #1 chosen from 1 choice
usb 3-1.4.3: adding 3-1.4.3:1.0 (config #1, interface 0)
usb 3-1.4.3:1.0: uevent
drivers/usb/core/inode.c: creating file '008'
usb 3-1.4.3: New USB device found, idVendor=3D045e, idProduct=3D0714
usb 3-1.4.3: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
usb 3-1.4.3: Product: Microsoft  Wireless Laser Mouse 8000
usb 3-1.4.3: Manufacturer: Microsoft
usb 3-1.4.3: SerialNumber: 00125A5F14F3
hub 2-0:1.0: state 7 ports 3 chg 0000 evt 0004
hub 3-1.4:1.0: state 7 ports 3 chg 0000 evt 0008
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
hci_usb 2-2:1.0: usb_probe_interface
hci_usb 2-2:1.0: usb_probe_interface - got id
hci_usb 2-2:1.2: usb_probe_interface
hci_usb 2-2:1.2: usb_probe_interface - got id
usbcore: registered new interface driver hci_usb
usbhid 3-1.1.1:1.0: usb_probe_interface
usbhid 3-1.1.1:1.0: usb_probe_interface - got id
input: Logitech USB Receiver as /devices/pci0000:00/0000:00:02.2/usb3/3-1/3=
-1.1/3-1.1.1/3-1.1.1:1.0/input/input7
usb 3-1.1.1: link qh8-0e01/ffff81001e180640 start 7 [1/2 us]
input: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:02.2-1=
.1.1
usbhid 3-1.1.1:1.1: usb_probe_interface
usbhid 3-1.1.1:1.1: usb_probe_interface - got id
input: Logitech USB Receiver as /devices/pci0000:00/0000:00:02.2/usb3/3-1/3=
-1.1/3-1.1.1/3-1.1.1:1.1/input/input8
usb 3-1.1.1: link qh8-1c02/ffff81001e1806e0 start 7 [1/2 us]
input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:02.2-1.1.=
1
usbhid 3-1.4.3:1.0: usb_probe_interface
usbhid 3-1.4.3:1.0: usb_probe_interface - got id
input: Microsoft Microsoft  Wireless Laser Mouse 8000 as /devices/pci0000:0=
0/0000:00:02.2/usb3/3-1/3-1.4/3-1.4.3/3-1.4.3:1.0/input/input9
input: USB HID v1.11 Mouse [Microsoft Microsoft  Wireless Laser Mouse 8000]=
 on usb-0000:00:02.2-1.4.3
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
NET: Registered protocol family 10
ReiserFS: sda1: found reiserfs format "3.6" with standard journal
ReiserFS: sda1: using ordered data mode
ReiserFS: sda1: journal params: device sda1, size 8192, journal first block=
 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda1: checking transaction log (sda1)
usb-storage: device scan complete
scsi 3:0:0:0: Direct-Access     Generic  STORAGE DEVICE   9339 PQ: 0 ANSI: =
0
scsi 3:0:0:1: Direct-Access     Generic  STORAGE DEVICE   9339 PQ: 0 ANSI: =
0
scsi 3:0:0:2: Direct-Access     Generic  STORAGE DEVICE   9339 PQ: 0 ANSI: =
0
scsi 3:0:0:3: Direct-Access     Generic  STORAGE DEVICE   9339 PQ: 0 ANSI: =
0
sd 3:0:0:0: [sdc] Attached SCSI removable disk
sd 3:0:0:0: Attached scsi generic sg3 type 0
sd 3:0:0:1: [sdd] Attached SCSI removable disk
sd 3:0:0:1: Attached scsi generic sg4 type 0
sd 3:0:0:2: [sde] Attached SCSI removable disk
sd 3:0:0:2: Attached scsi generic sg5 type 0
sd 3:0:0:3: [sdf] Attached SCSI removable disk
sd 3:0:0:3: Attached scsi generic sg6 type 0
ReiserFS: sda1: replayed 120 transactions in 1 seconds
ReiserFS: sda1: Using r5 hash to sort names
Adding 2843496k swap on /dev/sda3.  Priority:100 extents:1 across:2843496k
Bluetooth: L2CAP ver 2.9
Bluetooth: L2CAP socket layer initialized
usb usb1: usb auto-resume
ohci_hcd 0000:00:02.0: resume root hub
hub 1-0:1.0: hub_resume
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
ohci_hcd 0000:00:02.0: auto-stop root hub
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend
ohci_hcd 0000:00:02.0: suspend root hub
eth0: link up, 100Mbps, full-duplex, lpa 0xC1E1
warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
eth0: no IPv6 routers present
[drm] Initialized drm 1.1.0 20060810
[drm] Detected an NV17 generation card (0x017900a5)
[drm] Initialized nouveau 0.0.10 20060213 on minor 0
[drm] Used old pci detect: framebuffer loaded
agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V2 device at 0000:00:00.0 into 4x mode
agpgart: Putting AGP V2 device at 0000:01:00.0 into 4x mode
[drm] Allocating FIFO number 0
[drm] nouveau_fifo_alloc: initialised FIFO 0
[drm] Allocating FIFO number 1
[drm] nouveau_fifo_alloc: initialised FIFO 1
usb 3-1.4.3: link qh4-3804/ffff81001e1808c0 start 3 [1/2 us]
usb 3-1.4.3: unlink qh4-3804/ffff81001e1808c0 start 3 [1/2 us]
ehci_hcd 0000:00:02.2: reused qh ffff81001e1808c0 schedule
usb 3-1.4.3: link qh4-3804/ffff81001e1808c0 start 3 [1/2 us]
Hangcheck: hangcheck value past margin!

--=20
Zan Lynx <zlynx@acm.org>

--=-DWyxZK42HvbOby9x65V2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHWa9AG8fHaOLTWwgRAt6YAKCSfyFj+iOadELputq6fthB7SVVOACeOw9X
Ox+Ow7Dlxo+SsJZOgOpIGp0=
=eAjs
-----END PGP SIGNATURE-----

--=-DWyxZK42HvbOby9x65V2--

