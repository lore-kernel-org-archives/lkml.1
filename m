Return-Path: <linux-kernel-owner+w=401wt.eu-S1758847AbXEWXR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847AbXEWXR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 19:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756633AbXEWXRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 19:17:18 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:33475 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755287AbXEWXRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 19:17:15 -0400
Subject: Re: 2.6.22-rc2-mm1
From: Zan Lynx <zlynx@acm.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-L0f96yUoHGCiIraEQU3d"
Date: Wed, 23 May 2007 17:17:09 -0600
Message-Id: <1179962229.8575.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-Envelope-From: zlynx@acm.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-L0f96yUoHGCiIraEQU3d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-05-23 at 00:42 -0700, Andrew Morton wrote:=20
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc2/=
2.6.22-rc2-mm1/
>=20
> - A new readahead patch series.  This needs serious review and performanc=
e
>   testing please.
>=20
> - Added Ingo's CFS CPU scheduler
>=20
> - Xen dom-U support is now in the x86 tree.

I am having weird problems with USB keyboard and mouse.  The USB
keyboard will drop keystrokes, but not all of them.  The mouse seems to
move fine but drops clicks.  Could be that an occasional missed move
event isn't noticeable.  Nothing is logged when a key is dropped.

However, I did have some of this when it was first booting:

BUG: at drivers/hid/hid-core.c:778 implement()

Call Trace:
[<ffffffff880bb5ac>] :hid:hid_output_report+0x1dc/0x270
[<ffffffff880c651a>] :usbhid:hid_submit_ctrl+0x7a/0x260
[<ffffffff880c68ee>] :usbhid:usbhid_submit_report+0x11e/0x200
[<ffffffff880c9312>] :usbhid:hiddev_ioctl+0x3e2/0xae0
[<ffffffff8053523e>] do_page_fault+0x42e/0x880
[<ffffffff802b486d>] do_ioctl+0x7d/0xa0
[<ffffffff802b4ab1>] vfs_ioctl+0x221/0x2d0
[<ffffffff8025a711>] trace_hardirqs_on+0xc1/0x160
[<ffffffff802b4ba9>] sys_ioctl+0x49/0x80
[<ffffffff8020a16e>] system_call+0x7e/0x83

Here's the entire dmesg:
Linux version 2.6.22-rc2-mm1 (root@zephyr) (gcc version 4.2.0 (Gentoo 4.2.0=
)) #1 SMP PREEMPT Wed May 23 14:06:56 MDT 2007
Command line: root=3D/dev/sda2 rootfstype=3Dreiser4 ro i8042.nomux elevator=
=3Dcfq resume=3D/dev/sda3 panic=3D5 nmi_watchdog=3D1,panic debug kernelcore=
=3D512M
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
  Node 0: 132096
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   262000
On node 0 totalpages: 261903
Node 0 memmap at 0xffff810001000000 size 23068672 first pfn 0xffff810001000=
000
  DMA zone: 88 pages used for memmap
  DMA zone: 2778 pages reserved
  DMA zone: 1133 pages, LIFO batch:0
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
PERCPU: Allocating 32392 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 253497
Kernel command line: root=3D/dev/sda2 rootfstype=3Dreiser4 ro i8042.nomux e=
levator=3Dcfq resume=3D/dev/sda3 panic=3D5 nmi_watchdog=3D1,panic debug ker=
nelcore=3D512M
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
time.c: Detected 2194.363 MHz processor.
Console: colour VGA+ 80x25
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
Memory: 1011976k/1048000k available (3300k kernel code, 35344k reserved, 21=
76k data, 1100k init)
SLUB: Genslabs=3D23, HWalign=3D64, Order=3D0-3, MinObjects=3D16, Processors=
=3D1, Nodes=3D1
Calibrating delay using timer specific routine.. 4390.50 BogoMIPS (lpj=3D21=
95251)
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
 tbxface-0587 [02] tb_load_namespace     : ACPI Tables successfully acquire=
d
evxfevnt-0091 [02] enable                : Transition to ACPI mode successf=
ul
activating NMI Watchdog ... done.
Using local APIC timer interrupts.
result 12467973
Detected 12.467 MHz APIC timer.
Brought up 1 CPUs
testing NMI watchdog ... CPU#0: NMI appears to be stuck (0->0)!
PM: Adding info for No Bus:platform
NET: Registered protocol family 16
No dock devices found.
PM: Adding info for No Bus:vtcon0
ACPI: bus type pci registered
PM: Adding info for No Bus:id
BUG: at include/linux/slub_def.h:83 kmalloc_index()

Call Trace:
 [<ffffffff802a2e09>] get_slab+0xb9/0x180
 [<ffffffff802a2965>] kfree+0xc5/0x110
 [<ffffffff802a2fd4>] __kmalloc+0x24/0xc0
 [<ffffffff8049ab18>] get_modalias+0x68/0x120
 [<ffffffff8049ac07>] dmi_dev_uevent+0x37/0x60
 [<ffffffff80443b63>] dev_uevent+0x163/0x220
 [<ffffffff803bcc97>] kobject_uevent_env+0x2b7/0x500
 [<ffffffff80444f50>] bus_add_device+0x20/0x140
 [<ffffffff804438d2>] device_add+0x4a2/0x5b0
 [<ffffffff807a0a1b>] dmi_id_init+0x2cb/0x2f0
 [<ffffffff807866e6>] kernel_init+0x156/0x330
 [<ffffffff80531f5c>] trace_hardirqs_on_thunk+0x35/0x37
 [<ffffffff8025a711>] trace_hardirqs_on+0xc1/0x160
 [<ffffffff8020b028>] child_rip+0xa/0x12
 [<ffffffff8020a710>] restore_args+0x0/0x30
 [<ffffffff803e6c10>] vgacon_cursor+0x0/0x1f0
 [<ffffffff8023ad5b>] release_console_sem+0x4b/0x230
 [<ffffffff80786590>] kernel_init+0x0/0x330
 [<ffffffff8020b01e>] child_rip+0x0/0x12

PCI: Using configuration type 1
evgpeblk-0952 [04] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on in=
t 0x9
PM: Adding info for acpi:device:0e
PM: Adding info for acpi:device:10
PM: Adding info for acpi:device:11
PM: Adding info for acpi:device:12
PM: Adding info for acpi:device:13
PM: Adding info for acpi:device:14
PM: Adding info for acpi:device:15
PM: Adding info for acpi:ACPI0003:00
PM: Adding info for acpi:PNP0C02:00
PM: Adding info for acpi:PNP0C01:00
PM: Adding info for acpi:PNP0C09:00
PM: Adding info for acpi:PNP0C0A:00
PM: Adding info for acpi:PNP0C02:01
PM: Adding info for acpi:PNP0000:00
PM: Adding info for acpi:PNP0100:00
PM: Adding info for acpi:PNP0200:00
PM: Adding info for acpi:PNP0800:00
PM: Adding info for acpi:PNP0B00:00
PM: Adding info for acpi:PNP0C04:00
PM: Adding info for acpi:PNP0303:00
PM: Adding info for acpi:PNP0F13:00
PM: Adding info for acpi:PNP0A05:00
PM: Adding info for acpi:PNP0700:00
PM: Adding info for acpi:PNP0401:00
PM: Adding info for acpi:device:16
PM: Adding info for acpi:device:17
PM: Adding info for acpi:device:18
PM: Adding info for acpi:video:00
PM: Adding info for acpi:device:19
PM: Adding info for acpi:device:1a
PM: Adding info for acpi:device:1b
PM: Adding info for acpi:PNP0C0F:00
PM: Adding info for acpi:PNP0C0F:01
PM: Adding info for acpi:PNP0C0F:02
PM: Adding info for acpi:PNP0C0F:03
PM: Adding info for acpi:PNP0C0F:04
PM: Adding info for acpi:PNP0C0F:05
PM: Adding info for acpi:PNP0C0F:06
PM: Adding info for acpi:PNP0C0F:07
PM: Adding info for acpi:PNP0C0F:08
PM: Adding info for acpi:PNP0C0F:09
PM: Adding info for acpi:PNP0C0F:0a
PM: Adding info for acpi:PNP0C0F:0b
PM: Adding info for acpi:PNP0C0F:0c
PM: Adding info for acpi:PNP0C0F:0d
PM: Adding info for acpi:thermal:00
PM: Adding info for acpi:thermal:01
ACPI: PCI Root Bridge [PCI0] (0000:00)
PM: Adding info for No Bus:pci0000:00
PCI: Bus #03 (-#06) is hidden behind  bridge #02 (-#02) (try 'pci=3Dassign-=
busses')
Please report the result to linux-kernel to fix this permanently
PCI: Bus #07 (-#0a) is hidden behind  bridge #02 (-#02) (try 'pci=3Dassign-=
busses')
Please report the result to linux-kernel to fix this permanently
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP0._PRT]
PM: Adding info for pci:0000:00:00.0
PM: Adding info for pci:0000:00:01.0
PM: Adding info for pci:0000:00:01.1
PM: Adding info for pci:0000:00:02.0
PM: Adding info for pci:0000:00:02.1
PM: Adding info for pci:0000:00:02.2
PM: Adding info for pci:0000:00:06.0
PM: Adding info for pci:0000:00:06.1
PM: Adding info for pci:0000:00:08.0
PM: Adding info for pci:0000:00:0a.0
PM: Adding info for pci:0000:00:0b.0
PM: Adding info for pci:0000:00:18.0
PM: Adding info for pci:0000:00:18.1
PM: Adding info for pci:0000:00:18.2
PM: Adding info for pci:0000:00:18.3
PM: Adding info for pci:0000:02:00.0
PM: Adding info for pci:0000:02:01.0
PM: Adding info for pci:0000:02:02.0
PM: Adding info for pci:0000:02:04.0
PM: Adding info for pci:0000:02:04.1
PM: Adding info for pci:0000:02:04.2
PM: Adding info for pci:0000:01:00.0
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
PM: Adding info for No Bus:pnp0
ACPI: bus type pnp registered
PM: Adding info for pnp:00:00
PM: Adding info for pnp:00:01
PM: Adding info for pnp:00:02
PM: Adding info for pnp:00:03
PM: Adding info for pnp:00:04
PM: Adding info for pnp:00:05
PM: Adding info for pnp:00:06
PM: Adding info for pnp:00:07
PM: Adding info for pnp:00:08
PM: Adding info for pnp:00:09
PM: Adding info for pnp:00:0a
PM: Adding info for pnp:00:0b
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
PM: Adding info for No Bus:agpgart
agpgart: AGP aperture is 128M @ 0xe8000000
pnp: 00:01: ioport range 0x8000-0x807f has been reserved
pnp: 00:01: ioport range 0x8080-0x80ff has been reserved
pnp: 00:01: ioport range 0x8400-0x847f has been reserved
pnp: 00:01: ioport range 0x8480-0x84ff has been reserved
pnp: 00:01: ioport range 0x8800-0x887f has been reserved
pnp: 00:01: ioport range 0x8880-0x88ff has been reserved
pnp: 00:01: ioport range 0x2040-0x207f has been reserved
Time: tsc clocksource has been installed.
pnp: 00:01: ioport range 0x2000-0x203f has been reserved
pnp: 00:02: iomem range 0xfff80000-0xffffffff could not be reserved
pnp: 00:02: iomem range 0xfec00000-0xfec00fff has been reserved
pnp: 00:02: iomem range 0xfee00000-0xfeefffff could not be reserved
pnp: 00:02: iomem range 0xfed00000-0xfed00fff has been reserved
PM: Adding info for No Bus:mem
PM: Adding info for No Bus:kmem
PM: Adding info for No Bus:null
PM: Adding info for No Bus:port
PM: Adding info for No Bus:zero
PM: Adding info for No Bus:full
PM: Adding info for No Bus:random
PM: Adding info for No Bus:urandom
PM: Adding info for No Bus:kmsg
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
PM: Adding info for No Bus:mcelog
PM: Adding info for No Bus:msr0
PM: Adding info for No Bus:cpu0
PM: Adding info for No Bus:tty33
PM: Adding info for No Bus:tty34
PM: Adding info for No Bus:tty35
PM: Adding info for No Bus:tty36
PM: Adding info for No Bus:tty37
PM: Adding info for No Bus:tty38
PM: Adding info for No Bus:tty39
PM: Adding info for No Bus:tty40
PM: Adding info for No Bus:tty41
PM: Adding info for No Bus:tty42
PM: Adding info for No Bus:tty43
PM: Adding info for No Bus:tty44
PM: Adding info for No Bus:tty45
PM: Adding info for No Bus:tty46
PM: Adding info for No Bus:tty47
PM: Adding info for No Bus:tty48
PM: Adding info for No Bus:tty49
PM: Adding info for No Bus:tty50
PM: Adding info for No Bus:tty51
PM: Adding info for No Bus:tty52
PM: Adding info for No Bus:tty53
PM: Adding info for No Bus:tty54
PM: Adding info for No Bus:tty55
PM: Adding info for No Bus:tty56
PM: Adding info for No Bus:tty57
PM: Adding info for No Bus:tty58
PM: Adding info for No Bus:tty59
PM: Adding info for No Bus:tty60
PM: Adding info for No Bus:tty61
PM: Adding info for No Bus:tty62
PM: Adding info for No Bus:tty63
PM: Adding info for No Bus:rtc
Real Time Clock Driver v1.12ac
PM: Adding info for No Bus:hpet
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
PM: Adding info for No Bus:lo
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt 0000:02:01.0[A] -> Link [LNK2] -> GSI 18 (level, low) -=
> IRQ 18
PM: Adding info for No Bus:eth0
eth0: RealTek RTL8139 at 0xffffc2000001a800, 00:0f:b0:07:dc:49, IRQ 18
eth0:  Identified 8139 chip type 'RTL-8101'
pata_amd 0000:00:08.0: version 0.3.8
PCI: Setting latency timer of device 0000:00:08.0 to 64
scsi0 : pata_amd
PM: Adding info for No Bus:host0
scsi1 : pata_amd
PM: Adding info for No Bus:host1
ata1: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma=
 0x0000000000012080 irq 14
ata2: PATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma=
 0x0000000000012088 irq 15
ata1.00: ata_hpa_resize: sectors =3D 195371568, hpa_sectors =3D 195371568
ata1.00: ATA-6: HTS721010G9AT00, MCZOA51A, max UDMA/100
ata1.00: 195371568 sectors, multi 16: LBA48=20
ata1.00: ata_hpa_resize: sectors =3D 195371568, hpa_sectors =3D 195371568
ata1.00: configured for UDMA/100
ata2.00: ATAPI, max MWDMA2
ata2.00: configured for MWDMA2
PM: Adding info for No Bus:target0:0:0
scsi 0:0:0:0: Direct-Access     ATA      HTS721010G9AT00  MCZO PQ: 0 ANSI: =
5
PM: Adding info for scsi:0:0:0:0
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
PM: Adding info for No Bus:target1:0:0
scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD+RW GCA-4040N 1.19 PQ: 0 ANSI: =
5
PM: Adding info for scsi:1:0:0:0
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
Socket status: 30000086
Yenta: Raising subordinate bus# of parent bus (#02) from #02 to #06
pcmcia: parent PCI bridge I/O window: 0x3000 - 0x7fff
pcmcia: parent PCI bridge Memory window: 0xe0100000 - 0xe17fffff
pcmcia: parent PCI bridge Memory window: 0x50000000 - 0x57ffffff
PM: Adding info for No Bus:pcmcia_socket0
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
PM: Adding info for No Bus:pcmcia_socket1
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
PM: Adding info for platform:i8042
serio: i8042 KBD port at 0x60,0x64 irq 1
PM: Adding info for serio:serio0
serio: i8042 AUX port at 0x60,0x64 irq 12
PM: Adding info for serio:serio1
PM: Adding info for No Bus:psaux
mice: PS/2 mouse device common for all mice
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
input: AT Translated Set 2 keyboard as /class/input/input3
PM: Resume from disk failed.
Freeing unused kernel memory: 1100k freed
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
reiser4: sda2: found disk format 4.0.0.
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
sd 0:0:0:0: Attached scsi generic sg0 type 0
sr 1:0:0:0: Attached scsi generic sg1 type 5
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
PCI: Enabling device 0000:00:02.0 (0004 -> 0006)
ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUS0] -> GSI 22 (level, low) -=
> IRQ 22
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:02.0: irq 22, io mem 0xe0000000
usb usb1: new device found, idVendor=3D0000, idProduct=3D0000
usb usb1: new device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb1: Product: OHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.22-rc2-mm1 ohci_hcd
usb usb1: SerialNumber: 0000:00:02.0
PM: Adding info for usb:usb1
PM: Adding info for No Bus:usbdev1.1_ep00
usb usb1: configuration #1 chosen from 1 choice
PM: Adding info for usb:1-0:1.0
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
PM: Adding info for No Bus:timer
PM: Adding info for No Bus:usbdev1.1_ep81
PCI: Enabling device 0000:00:02.1 (0004 -> 0006)
ACPI: PCI Interrupt Link [LUS1] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUS1] -> GSI 21 (level, low) -=
> IRQ 21
PCI: Setting latency timer of device 0000:00:02.1 to 64
ohci_hcd 0000:00:02.1: OHCI Host Controller
ohci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.1: irq 21, io mem 0xe0001000
usb usb2: new device found, idVendor=3D0000, idProduct=3D0000
usb usb2: new device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.22-rc2-mm1 ohci_hcd
usb usb2: SerialNumber: 0000:00:02.1
PM: Adding info for usb:usb2
PM: Adding info for No Bus:usbdev2.1_ep00
usb usb2: configuration #1 chosen from 1 choice
PM: Adding info for usb:2-0:1.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
PM: Adding info for No Bus:usbdev2.1_ep81
ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 20
PM: Adding info for usb:3-0:1.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 6 ports detected
PM: Adding info for No Bus:usbdev3.1_ep81
ACPI: PCI Interrupt Link [LACI] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LACI] -> GSI 22 (level, low) -=
> IRQ 22
PCI: Setting latency timer of device 0000:00:06.0 to 64
input: PS/2 Mouse as /class/input/input4
input: AlpsPS/2 ALPS GlidePoint as /class/input/input5
AC'97 0 analog subsections not ready
usb 3-2: new high speed USB device using ehci_hcd and address 2
usb 3-2: new device found, idVendor=3D050d, idProduct=3D0237
usb 3-2: new device strings: Mfr=3D0, Product=3D0, SerialNumber=3D0
PM: Adding info for usb:3-2
PM: Adding info for No Bus:usbdev3.2_ep00
usb 3-2: configuration #1 chosen from 1 choice
PM: Adding info for usb:3-2:1.0
hub 3-2:1.0: USB hub found
hub 3-2:1.0: 7 ports detected
PM: Adding info for No Bus:usbdev3.2_ep81
intel8x0_measure_ac97_clock: measured 50207 usecs
intel8x0: clocking to 47409
PM: Adding info for No Bus:card0
PM: Adding info for No Bus:pcmC0D2p
PM: Adding info for No Bus:pcmC0D1c
PM: Adding info for No Bus:pcmC0D0p
PM: Adding info for No Bus:pcmC0D0c
PM: Adding info for ac97:0-0:AD1981B
PM: Adding info for No Bus:controlC0
usb 3-2.1: new low speed USB device using ehci_hcd and address 4
usb 3-2.1: new device found, idVendor=3D045e, idProduct=3D0059
usb 3-2.1: new device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
usb 3-2.1: Product: Microsoft Wireless Intellimouse Explorer=EF=BF=BD 1.0A
usb 3-2.1: Manufacturer: Microsoft
PM: Adding info for usb:3-2.1
PM: Adding info for No Bus:usbdev3.4_ep00
usb 3-2.1: configuration #1 chosen from 1 choice
PM: Adding info for usb:3-2.1:1.0
PM: Adding info for No Bus:usbdev3.4_ep81
usb 3-2.2: new full speed USB device using ehci_hcd and address 5
usb 3-2.2: new device found, idVendor=3D0451, idProduct=3D2036
usb 3-2.2: new device strings: Mfr=3D0, Product=3D1, SerialNumber=3D0
usb 3-2.2: Product: General Purpose USB Hub
PM: Adding info for usb:3-2.2
PM: Adding info for No Bus:usbdev3.5_ep00
usb 3-2.2: configuration #1 chosen from 1 choice
PM: Adding info for usb:3-2.2:1.0
hub 3-2.2:1.0: USB hub found
hub 3-2.2:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev3.5_ep81
usb 3-2.3: new high speed USB device using ehci_hcd and address 6
usb 3-2.3: new device found, idVendor=3D0781, idProduct=3Db4b5
usb 3-2.3: new device strings: Mfr=3D3, Product=3D4, SerialNumber=3D5
usb 3-2.3: Product: ImageMate 14 in 1 Reader/Writer=20
usb 3-2.3: Manufacturer: SanDisk=20
usb 3-2.3: SerialNumber: 0304237855
PM: Adding info for usb:3-2.3
PM: Adding info for No Bus:usbdev3.6_ep00
usb 3-2.3: configuration #1 chosen from 1 choice
PM: Adding info for usb:3-2.3:1.0
PM: Adding info for No Bus:usbdev3.6_ep81
PM: Adding info for No Bus:usbdev3.6_ep02
usbcore: registered new interface driver hiddev
Initializing USB Mass Storage driver...
usb 2-2: new full speed USB device using ohci_hcd and address 2
usb 2-2: new device found, idVendor=3D049f, idProduct=3D0086
usb 2-2: new device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
usb 2-2: Product: Bluetooth by hp
usb 2-2: Manufacturer: ACTIONTEC
PM: Adding info for usb:2-2
PM: Adding info for No Bus:usbdev2.2_ep00
PM: Adding info for No Bus:usbdev2.2_ep83
PM: Adding info for bluetooth:hci0
input: Logitech USB Receiver as /class/input/input8
PM: Adding info for No Bus:hiddev0
PM: Adding info for No Bus:hidraw2
input,hiddev0,hidraw2: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0=
000:00:02.2-2.2.1
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
usbcore: registered new interface driver hci_usb
NET: Registered protocol family 10
ReiserFS: sda1: found reiserfs format "3.6" with standard journal
ReiserFS: sda1: using ordered data mode
ReiserFS: sda1: journal params: device sda1, size 8192, journal first block=
 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda1: checking transaction log (sda1)
ReiserFS: sda1: Using r5 hash to sort names
Adding 2843496k swap on /dev/disk/by-uuid/fd35277a-8dc7-4afe-8257-fda61b757=
344.  Priority:100 extents:1 across:2843496k
PM: Adding info for No Bus:target2:0:0
scsi 2:0:0:0: Direct-Access     Generic  STORAGE DEVICE   9339 PQ: 0 ANSI: =
0
PM: Adding info for scsi:2:0:0:0
sd 2:0:0:0: [sdb] 8018640 512-byte hardware sectors (4106 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 03 00 00 00
sd 2:0:0:0: [sdb] Assuming drive cache: write through
sd 2:0:0:0: [sdb] 8018640 512-byte hardware sectors (4106 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 03 00 00 00
sd 2:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 2:0:0:0: [sdb] Attached SCSI removable disk
sd 2:0:0:0: Attached scsi generic sg2 type 0
PM: Adding info for No Bus:target2:0:1
PM: Removing info for No Bus:target2:0:1
PM: Adding info for No Bus:target2:0:2
PM: Removing info for No Bus:target2:0:2
PM: Adding info for No Bus:target2:0:3
PM: Removing info for No Bus:target2:0:3
PM: Adding info for No Bus:target2:0:4
PM: Removing info for No Bus:target2:0:4
PM: Adding info for No Bus:target2:0:5
PM: Removing info for No Bus:target2:0:5
PM: Adding info for No Bus:target2:0:6
PM: Removing info for No Bus:target2:0:6
PM: Adding info for No Bus:target2:0:7
PM: Removing info for No Bus:target2:0:7
usb-storage: device scan complete
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Removing info for No Bus:vcs2
PM: Removing info for No Bus:vcsa2
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Removing info for No Bus:vcs3
PM: Removing info for No Bus:vcsa3
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Removing info for No Bus:vcs4
PM: Removing info for No Bus:vcsa4
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Removing info for No Bus:vcs5
PM: Removing info for No Bus:vcsa5
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Removing info for No Bus:vcs6
PM: Removing info for No Bus:vcsa6
PM: Adding info for No Bus:vcs7
PM: Adding info for No Bus:vcsa7
PM: Removing info for No Bus:vcs7
PM: Removing info for No Bus:vcsa7
PM: Adding info for No Bus:vcs8
PM: Adding info for No Bus:vcsa8
PM: Removing info for No Bus:vcs8
PM: Removing info for No Bus:vcsa8
PM: Adding info for No Bus:vcs9
PM: Adding info for No Bus:vcsa9
PM: Removing info for No Bus:vcs9
PM: Removing info for No Bus:vcsa9
PM: Adding info for No Bus:vcs10
PM: Adding info for No Bus:vcsa10
PM: Removing info for No Bus:vcs10
PM: Removing info for No Bus:vcsa10
PM: Adding info for No Bus:vcs11
PM: Adding info for No Bus:vcsa11
PM: Removing info for No Bus:vcs11
PM: Removing info for No Bus:vcsa11
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Removing info for No Bus:vcs2
PM: Removing info for No Bus:vcsa2
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Removing info for No Bus:vcs3
PM: Removing info for No Bus:vcsa3
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Removing info for No Bus:vcs4
PM: Removing info for No Bus:vcsa4
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Removing info for No Bus:vcs5
PM: Removing info for No Bus:vcsa5
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Removing info for No Bus:vcs6
PM: Removing info for No Bus:vcsa6
PM: Adding info for No Bus:vcs7
PM: Adding info for No Bus:vcsa7
PM: Removing info for No Bus:vcs7
PM: Removing info for No Bus:vcsa7
PM: Adding info for No Bus:vcs8
PM: Adding info for No Bus:vcsa8
PM: Removing info for No Bus:vcs8
PM: Removing info for No Bus:vcsa8
PM: Adding info for No Bus:vcs9
PM: Adding info for No Bus:vcsa9
PM: Removing info for No Bus:vcs9
PM: Removing info for No Bus:vcsa9
PM: Adding info for No Bus:vcs10
PM: Adding info for No Bus:vcsa10
PM: Removing info for No Bus:vcs10
PM: Removing info for No Bus:vcsa10
PM: Adding info for No Bus:vcs11
PM: Adding info for No Bus:vcsa11
PM: Removing info for No Bus:vcs11
PM: Removing info for No Bus:vcsa11
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
ata1.00: ata_hpa_resize: sectors =3D 195371568, hpa_sectors =3D 195371568
ata1.00: ata_hpa_resize: sectors =3D 195371568, hpa_sectors =3D 195371568
ata1.00: configured for UDMA/100
ata1: EH complete
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
BUG: at drivers/hid/hid-core.c:778 implement()

Call Trace:
 [<ffffffff880bb5ac>] :hid:hid_output_report+0x1dc/0x270
 [<ffffffff880c651a>] :usbhid:hid_submit_ctrl+0x7a/0x260
 [<ffffffff880c68ee>] :usbhid:usbhid_submit_report+0x11e/0x200
 [<ffffffff880c9312>] :usbhid:hiddev_ioctl+0x3e2/0xae0
 [<ffffffff8053523e>] do_page_fault+0x42e/0x880
 [<ffffffff802b486d>] do_ioctl+0x7d/0xa0
 [<ffffffff802b4ab1>] vfs_ioctl+0x221/0x2d0
 [<ffffffff8025a711>] trace_hardirqs_on+0xc1/0x160
 [<ffffffff802b4ba9>] sys_ioctl+0x49/0x80
 [<ffffffff8020a16e>] system_call+0x7e/0x83

BUG: at drivers/hid/hid-core.c:778 implement()

Call Trace:
 [<ffffffff880bb5ac>] :hid:hid_output_report+0x1dc/0x270
 [<ffffffff880c651a>] :usbhid:hid_submit_ctrl+0x7a/0x260
 [<ffffffff880c68ee>] :usbhid:usbhid_submit_report+0x11e/0x200
 [<ffffffff880c9312>] :usbhid:hiddev_ioctl+0x3e2/0xae0
 [<ffffffff8053523e>] do_page_fault+0x42e/0x880
 [<ffffffff802b486d>] do_ioctl+0x7d/0xa0
 [<ffffffff802b4ab1>] vfs_ioctl+0x221/0x2d0
 [<ffffffff8025a711>] trace_hardirqs_on+0xc1/0x160
 [<ffffffff802b4ba9>] sys_ioctl+0x49/0x80
 [<ffffffff8020a16e>] system_call+0x7e/0x83

BUG: at drivers/hid/hid-core.c:778 implement()

Call Trace:
 [<ffffffff880bb5ac>] :hid:hid_output_report+0x1dc/0x270
 [<ffffffff880c651a>] :usbhid:hid_submit_ctrl+0x7a/0x260
 [<ffffffff880c68ee>] :usbhid:usbhid_submit_report+0x11e/0x200
 [<ffffffff880c9312>] :usbhid:hiddev_ioctl+0x3e2/0xae0
 [<ffffffff8053523e>] do_page_fault+0x42e/0x880
 [<ffffffff802b486d>] do_ioctl+0x7d/0xa0
 [<ffffffff802b4ab1>] vfs_ioctl+0x221/0x2d0
 [<ffffffff8025a711>] trace_hardirqs_on+0xc1/0x160
 [<ffffffff802b4ba9>] sys_ioctl+0x49/0x80
 [<ffffffff8020a16e>] system_call+0x7e/0x83

BUG: at drivers/hid/hid-core.c:778 implement()

Call Trace:
 [<ffffffff880bb5ac>] :hid:hid_output_report+0x1dc/0x270
 [<ffffffff880c651a>] :usbhid:hid_submit_ctrl+0x7a/0x260
 [<ffffffff880c68ee>] :usbhid:usbhid_submit_report+0x11e/0x200
 [<ffffffff880c9312>] :usbhid:hiddev_ioctl+0x3e2/0xae0
 [<ffffffff8053523e>] do_page_fault+0x42e/0x880
 [<ffffffff802b486d>] do_ioctl+0x7d/0xa0
 [<ffffffff802b4ab1>] vfs_ioctl+0x221/0x2d0
 [<ffffffff8025a711>] trace_hardirqs_on+0xc1/0x160
 [<ffffffff802b4ba9>] sys_ioctl+0x49/0x80
 [<ffffffff8020a16e>] system_call+0x7e/0x83

BUG: at drivers/hid/hid-core.c:778 implement()

Call Trace:
 [<ffffffff880bb5ac>] :hid:hid_output_report+0x1dc/0x270
 [<ffffffff880c651a>] :usbhid:hid_submit_ctrl+0x7a/0x260
 [<ffffffff880c68ee>] :usbhid:usbhid_submit_report+0x11e/0x200
 [<ffffffff880c9312>] :usbhid:hiddev_ioctl+0x3e2/0xae0
 [<ffffffff8053523e>] do_page_fault+0x42e/0x880
 [<ffffffff802b486d>] do_ioctl+0x7d/0xa0
 [<ffffffff802b4ab1>] vfs_ioctl+0x221/0x2d0
 [<ffffffff8025a711>] trace_hardirqs_on+0xc1/0x160
 [<ffffffff802b4ba9>] sys_ioctl+0x49/0x80
 [<ffffffff8020a16e>] system_call+0x7e/0x83

BUG: at drivers/hid/hid-core.c:778 implement()

Call Trace:
 [<ffffffff880bb5ac>] :hid:hid_output_report+0x1dc/0x270
 [<ffffffff880c651a>] :usbhid:hid_submit_ctrl+0x7a/0x260
 [<ffffffff880c68ee>] :usbhid:usbhid_submit_report+0x11e/0x200
 [<ffffffff880c9312>] :usbhid:hiddev_ioctl+0x3e2/0xae0
 [<ffffffff8053523e>] do_page_fault+0x42e/0x880
 [<ffffffff802b486d>] do_ioctl+0x7d/0xa0
 [<ffffffff802b4ab1>] vfs_ioctl+0x221/0x2d0
 [<ffffffff8025a711>] trace_hardirqs_on+0xc1/0x160
 [<ffffffff802b4ba9>] sys_ioctl+0x49/0x80
 [<ffffffff8020a16e>] system_call+0x7e/0x83

BUG: at drivers/hid/hid-core.c:778 implement()

Call Trace:
 [<ffffffff880bb5ac>] :hid:hid_output_report+0x1dc/0x270
 [<ffffffff880c651a>] :usbhid:hid_submit_ctrl+0x7a/0x260
 [<ffffffff880c68ee>] :usbhid:usbhid_submit_report+0x11e/0x200
 [<ffffffff880c9312>] :usbhid:hiddev_ioctl+0x3e2/0xae0
 [<ffffffff8053523e>] do_page_fault+0x42e/0x880
 [<ffffffff802b486d>] do_ioctl+0x7d/0xa0
 [<ffffffff802b4ab1>] vfs_ioctl+0x221/0x2d0
 [<ffffffff8025a711>] trace_hardirqs_on+0xc1/0x160
 [<ffffffff802b4ba9>] sys_ioctl+0x49/0x80
 [<ffffffff8020a16e>] system_call+0x7e/0x83

BUG: at drivers/hid/hid-core.c:778 implement()

Call Trace:
 [<ffffffff880bb5ac>] :hid:hid_output_report+0x1dc/0x270
 [<ffffffff880c651a>] :usbhid:hid_submit_ctrl+0x7a/0x260
 [<ffffffff880c68ee>] :usbhid:usbhid_submit_report+0x11e/0x200
 [<ffffffff880c9312>] :usbhid:hiddev_ioctl+0x3e2/0xae0
 [<ffffffff8053523e>] do_page_fault+0x42e/0x880
 [<ffffffff802b486d>] do_ioctl+0x7d/0xa0
 [<ffffffff802b4ab1>] vfs_ioctl+0x221/0x2d0
 [<ffffffff8025a711>] trace_hardirqs_on+0xc1/0x160
 [<ffffffff802b4ba9>] sys_ioctl+0x49/0x80
 [<ffffffff8020a16e>] system_call+0x7e/0x83

eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
[ INFO: possible circular locking dependency detected ]
2.6.22-rc2-mm1 #1
-------------------------------------------------------
rhythmbox/6976 is trying to acquire lock:
 (&mm->mmap_sem){----}, at: [<ffffffff80534f8c>] do_page_fault+0x17c/0x880

but task is already holding lock:
 (&data->latch){----}, at: [<ffffffff8034a701>] get_exclusive_access+0x11/0=
x20

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&data->latch){----}:
       [<ffffffff8025b8bc>] __lock_acquire+0xbfc/0x1030
       [<ffffffff8025bd3b>] lock_acquire+0x4b/0x70
       [<ffffffff8034a701>] get_exclusive_access+0x11/0x20
       [<ffffffff80254c5f>] down_write+0x2f/0x40
       [<ffffffff8034a701>] get_exclusive_access+0x11/0x20
       [<ffffffff803498c8>] mmap_unix_file+0x58/0x140
       [<ffffffff80292125>] mmap_region+0x195/0x540
       [<ffffffff80292b2e>] do_mmap_pgoff+0x2fe/0x390
       [<ffffffff80532b5f>] _spin_unlock_irq+0x2f/0x50
       [<ffffffff802e2bca>] elf_map+0xfa/0x100
       [<ffffffff802e5574>] load_elf_binary+0x1c14/0x2110
       [<ffffffff80258a25>] add_lock_to_list+0x65/0xe0
       [<ffffffff8025b98e>] __lock_acquire+0xcce/0x1030
       [<ffffffff802820fe>] get_page_from_freelist+0x33e/0x520
       [<ffffffff8025a711>] trace_hardirqs_on+0xc1/0x160
       [<ffffffff80281fd5>] get_page_from_freelist+0x215/0x520
       [<ffffffff8022f3d0>] load_aout_binary+0x0/0x980
       [<ffffffff802e3960>] load_elf_binary+0x0/0x2110
       [<ffffffff802ab3d6>] search_binary_handler+0xf6/0x290
       [<ffffffff802ad05f>] do_execve+0x18f/0x250
       [<ffffffff80208ab4>] sys_execve+0x44/0xb0
       [<ffffffff8020a567>] stub_execve+0x67/0xb0
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&mm->mmap_sem){----}:
       [<ffffffff80259b68>] print_circular_bug_header+0xe8/0xf0
       [<ffffffff8025b6f2>] __lock_acquire+0xa32/0x1030
       [<ffffffff80532b15>] _spin_unlock_irqrestore+0x65/0x80
       [<ffffffff8025bd3b>] lock_acquire+0x4b/0x70
       [<ffffffff80534f8c>] do_page_fault+0x17c/0x880
       [<ffffffff80254b82>] down_read+0x32/0x40
       [<ffffffff80534f8c>] do_page_fault+0x17c/0x880
       [<ffffffff80532b54>] _spin_unlock_irq+0x24/0x50
       [<ffffffff8025a711>] trace_hardirqs_on+0xc1/0x160
       [<ffffffff80532b15>] _spin_unlock_irqrestore+0x65/0x80
       [<ffffffff8053318d>] error_exit+0x0/0x96
       [<ffffffff8027c464>] file_read_actor+0x44/0x1a0
       [<ffffffff8027c74f>] __lock_page+0x5f/0x70
       [<ffffffff8027ced3>] do_generic_mapping_read+0x233/0x560
       [<ffffffff8027c420>] file_read_actor+0x0/0x1a0
       [<ffffffff8027f136>] generic_file_aio_read+0x106/0x1a0
       [<ffffffff802a6c09>] do_sync_read+0xd9/0x120
       [<ffffffff80258495>] lockdep_init_map+0x55/0x4e0
       [<ffffffff802515e0>] autoremove_wake_function+0x0/0x30
       [<ffffffff805329e9>] _spin_unlock+0x29/0x50
       [<ffffffff8032caec>] reiser4_grab+0x8c/0xd0
       [<ffffffff80348af4>] read_unix_file+0x454/0x490
       [<ffffffff802a7585>] vfs_read+0xc5/0x180
       [<ffffffff802a7a83>] sys_read+0x53/0x90
       [<ffffffff8020a16e>] system_call+0x7e/0x83
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:
usb 3-2: new high speed USB device using ehci_hcd and address 8
usb 3-2: new device found, idVendor=3D050d, idProduct=3D0237
usb 3-2: new device strings: Mfr=3D0, Product=3D0, SerialNumber=3D0
PM: Adding info for usb:3-2
PM: Adding info for No Bus:usbdev3.8_ep00
usb 3-2: configuration #1 chosen from 1 choice
PM: Adding info for usb:3-2:1.0
hub 3-2:1.0: USB hub found
hub 3-2:1.0: 7 ports detected
PM: Adding info for No Bus:usbdev3.8_ep81
usb 3-2.1: new low speed USB device using ehci_hcd and address 9
usb 3-2.1: new device found, idVendor=3D045e, idProduct=3D0059
usb 3-2.1: new device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
usb 3-2.1: Product: Microsoft Wireless Intellimouse Explorer=EF=BF=BD 1.0A
usb 3-2.1: Manufacturer: Microsoft
PM: Adding info for usb:3-2.1
PM: Adding info for No Bus:usbdev3.9_ep00
usb 3-2.1: configuration #1 chosen from 1 choice
PM: Adding info for usb:3-2.1:1.0
input: Microsoft Microsoft Wireless Intellimouse Explorer=EF=BF=BD 1.0A as =
/class/input/input9
PM: Adding info for No Bus:hidraw0
input,hidraw0: USB HID v1.10 Mouse [Microsoft Microsoft Wireless Intellimou=
se Explorer=EF=BF=BD 1.0A] on usb-0000:00:02.2-2.1
PM: Adding info for No Bus:usbdev3.9_ep81
usb 3-2.2: new full speed USB device using ehci_hcd and address 10
usb 3-2.2: new device found, idVendor=3D0451, idProduct=3D2036
usb 3-2.2: new device strings: Mfr=3D0, Product=3D1, SerialNumber=3D0
usb 3-2.2: Product: General Purpose USB Hub
PM: Adding info for usb:3-2.2
PM: Adding info for No Bus:usbdev3.10_ep00
usb 3-2.2: configuration #1 chosen from 1 choice
PM: Adding info for usb:3-2.2:1.0
hub 3-2.2:1.0: USB hub found
hub 3-2.2:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev3.10_ep81
usb 3-2.3: new high speed USB device using ehci_hcd and address 11
usb 3-2.3: new device found, idVendor=3D0781, idProduct=3Db4b5
usb 3-2.3: new device strings: Mfr=3D3, Product=3D4, SerialNumber=3D5
usb 3-2.3: Product: ImageMate 14 in 1 Reader/Writer=20
usb 3-2.3: Manufacturer: SanDisk=20
usb 3-2.3: SerialNumber: 0304237855
PM: Adding info for usb:3-2.3
PM: Adding info for No Bus:usbdev3.11_ep00
usb 3-2.3: configuration #1 chosen from 1 choice
PM: Adding info for usb:3-2.3:1.0
scsi3 : SCSI emulation for USB Mass Storage devices
PM: Adding info for No Bus:host3
PM: Adding info for No Bus:usbdev3.11_ep81
PM: Adding info for No Bus:usbdev3.11_ep02
usb-storage: device found at 11
usb-storage: waiting for device to settle before scanning
usb 3-2.2.1: new low speed USB device using ehci_hcd and address 12
usb 3-2.2.1: new device found, idVendor=3D046d, idProduct=3Dc704
usb 3-2.2.1: new device strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
usb 3-2.2.1: Product: USB Receiver
usb 3-2.2.1: Manufacturer: Logitech
usb 3-2.2.1: SerialNumber: 04E5EF
PM: Adding info for usb:3-2.2.1
PM: Adding info for No Bus:usbdev3.12_ep00
usb 3-2.2.1: configuration #1 chosen from 1 choice
PM: Adding info for usb:3-2.2.1:1.0
input: Logitech USB Receiver as /class/input/input10
PM: Adding info for No Bus:hidraw1
input,hidraw1: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:0=
0:02.2-2.2.1
PM: Adding info for No Bus:usbdev3.12_ep81
PM: Adding info for usb:3-2.2.1:1.1
input: Logitech USB Receiver as /class/input/input11
PM: Adding info for No Bus:hiddev0
PM: Adding info for No Bus:hidraw2
input,hiddev0,hidraw2: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0=
000:00:02.2-2.2.1
PM: Adding info for No Bus:usbdev3.12_ep82
PM: Adding info for No Bus:target3:0:0
scsi 3:0:0:0: Direct-Access     Generic  STORAGE DEVICE   9339 PQ: 0 ANSI: =
0
PM: Adding info for scsi:3:0:0:0
sd 3:0:0:0: [sdb] 8018640 512-byte hardware sectors (4106 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 03 00 00 00
sd 3:0:0:0: [sdb] Assuming drive cache: write through
sd 3:0:0:0: [sdb] 8018640 512-byte hardware sectors (4106 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 03 00 00 00
sd 3:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 3:0:0:0: [sdb] Attached SCSI removable disk
sd 3:0:0:0: Attached scsi generic sg2 type 0
PM: Adding info for No Bus:target3:0:1
PM: Removing info for No Bus:target3:0:1
PM: Adding info for No Bus:target3:0:2
PM: Removing info for No Bus:target3:0:2
PM: Adding info for No Bus:target3:0:3
PM: Removing info for No Bus:target3:0:3
PM: Adding info for No Bus:target3:0:4
PM: Removing info for No Bus:target3:0:4
PM: Adding info for No Bus:target3:0:5
PM: Removing info for No Bus:target3:0:5
PM: Adding info for No Bus:target3:0:6
PM: Removing info for No Bus:target3:0:6
PM: Adding info for No Bus:target3:0:7
PM: Removing info for No Bus:target3:0:7
usb-storage: device scan complete

--=20
Zan Lynx <zlynx@acm.org>

--=-L0f96yUoHGCiIraEQU3d
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGVMt1G8fHaOLTWwgRAqv1AJ0QBTw+okM98z/lF/CJlV49cbajgACeNhLK
g8PyazjdNGK4dvk2xOurfxM=
=SqXB
-----END PGP SIGNATURE-----

--=-L0f96yUoHGCiIraEQU3d--

