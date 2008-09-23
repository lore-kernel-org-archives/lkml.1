Return-Path: <linux-kernel-owner+w=401wt.eu-S1752215AbYIWM0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbYIWM0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 08:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbYIWM0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 08:26:13 -0400
Received: from keil-draco.com ([216.193.185.50]:54261 "EHLO keil-draco.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbYIWM0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 08:26:07 -0400
X-Greylist: delayed 541 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Sep 2008 08:26:05 EDT
From: Daniel Hazelton <dhazelton@enter.net>
Reply-To: dhazelton@enter.net
To: linux-kernel@vger.kernel.org
Subject: OOPS in vfs_getattr
Date: Tue, 23 Sep 2008 08:16:55 -0400
User-Agent: KMail/1.10.0 (Linux/2.6.26.3-29.fc9.x86_64; KDE/4.1.0; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart48891950.elvEeiUGoC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200809230817.00291.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart48891950.elvEeiUGoC
Content-Type: multipart/mixed;
  boundary="Boundary-01=_34N2IZE+e+h8Ter"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_34N2IZE+e+h8Ter
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

This is the first time this has happened, so it might have been a one-off=20
error. However it triggered a small non-fatal oops cascade.

System is a Dell Inspiron 1420 running Fedora 9 64bit (not pure - has the=20
basic mixed userland that is pretty common, from what I can tell). I've=20
attached the dmesg that contains the oops to get around any line-length=20
limitations I might have in my mailer program.

DRH
=2D-=20
Dialup is like pissing through a pipette. Slow and excruciatingly painful.

--Boundary-01=_34N2IZE+e+h8Ter
Content-Type: text/plain;
  charset="us-ascii";
  name="dmesg.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg.txt"

Initializing cgroup subsys cpuset
Linux version 2.6.26.3-29.fc9.x86_64 (mockbuild@) (gcc version 4.3.0 200804=
28 (Red Hat 4.3.0-8) (GCC) ) #1 SMP Wed Sep 3 03:16:37 EDT 2008
Command line: ro root=3D/dev/VolGroup00/LogVol00 rhgb selinux=3D0
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003f692400 (usable)
 BIOS-e820: 000000003f692400 - 0000000040000000 (reserved)
 BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 25600 used
Entering add_active_range(0, 256, 259730) 1 entries of 25600 used
max_pfn_mapped =3D 1048576
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping
DMI 2.4 present.
ACPI: RSDP 000FBBF0, 0024 (r2 DELL  )
ACPI: XSDT 3F693E00, 005C (r1 DELL    M08     27D7080F ASL        61)
ACPI: FACP 3F693C9C, 00F4 (r4 DELL    M08     27D7080F ASL        61)
ACPI: DSDT 3F694400, 567C (r2 INT430 SYSFexxx     1001 INTL 20050624)
ACPI: FACS 3F6A2C00, 0040
ACPI: HPET 3F693F00, 0038 (r1 DELL    M08            1 ASL        61)
ACPI: APIC 3F694000, 0068 (r1 DELL    M08     27D7080F ASL        47)
ACPI: MCFG 3F693FC0, 003E (r16 DELL    M08     27D7080F ASL        61)
ACPI: SLIC 3F69409C, 0024 (r1 DELL    M08     27D7080F ASL        61)
ACPI: BOOT 3F693BC0, 0028 (r1 DELL    M08     27D7080F ASL        61)
ACPI: SSDT 3F692682, 04CC (r1  PmRef    CpuPm     3000 INTL 20050624)
No NUMA configuration found
=46aking a node at 0000000000000000-000000003f692000
Entering add_active_range(0, 0, 159) 0 entries of 25600 used
Entering add_active_range(0, 256, 259730) 1 entries of 25600 used
Bootmem setup node 0 0000000000000000-000000003f692000
  NODE_DATA [000000000000b000 - 000000000001ffff]
  bootmap [0000000000020000 -  0000000000027ed7] pages 8
  early res: 0 [0-fff] BIOS data page
  early res: 1 [6000-7fff] TRAMPOLINE
  early res: 2 [200000-84a54b] TEXT DATA BSS
  early res: 3 [37c82000-37fef4b6] RAMDISK
  early res: 4 [9f000-fffff] BIOS reserved
  early res: 5 [8000-afff] PGTABLE
 [ffffe20000000000-ffffe20000dfffff] PMD -> [ffff810001200000-ffff810001fff=
fff] on node 0
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   259730
On node 0 totalpages: 259633
  DMA zone: 56 pages used for memmap
  DMA zone: 1713 pages reserved
  DMA zone: 2230 pages, LIFO batch:0
  DMA32 zone: 3495 pages used for memmap
  DMA32 zone: 252139 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
Allocating PCI resources starting at 50000000 (gap: 40000000:b8000000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 45104 bytes of per cpu data
NR_CPUS: 64, nr_cpu_ids: 2
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 254369
Policy zone: DMA32
Kernel command line: ro root=3D/dev/VolGroup00/LogVol00 rhgb selinux=3D0
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC calibrated against PM_TIMER
time.c: Detected 1496.247 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 1013848k/1038920k available (2699k kernel code, 24684k reserved, 14=
85k data, 980k init)
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=3D13, HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
hpet clockevent registered
Calibrating delay using timer specific routine.. 2995.67 BogoMIPS (lpj=3D14=
97836)
Security Framework initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys devices
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20080321
CPU0: Intel(R) Core(TM)2 Duo CPU     T5250  @ 1.50GHz stepping 0d
Using local APIC timer interrupts.
APIC timer calibration result 10390620
Detected 10.390 MHz APIC timer.
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 2992.37 BogoMIPS (lpj=3D14=
96186)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     T5250  @ 1.50GHz stepping 0d
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (5988.04 BogoMIPS).
sizeof(vma)=3D176 bytes
sizeof(page)=3D56 bytes
sizeof(inode)=3D560 bytes
sizeof(dentry)=3D208 bytes
sizeof(ext3inode)=3D760 bytes
sizeof(buffer_head)=3D104 bytes
sizeof(skbuff)=3D232 bytes
sizeof(task_struct)=3D5792 bytes
CPU0 attaching sched-domain:
 domain 0: span 0-1
  groups: 0 1
  domain 1: span 0-1
   groups: 0-1
CPU1 attaching sched-domain:
 domain 0: span 0-1
  groups: 1 0
  domain 1: span 0-1
   groups: 0-1
net_namespace: 1224 bytes
Booting paravirtualized kernel on bare hardware
Time:  5:10:01  Date: 09/23/08
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
PCI: MCFG area at f8000000 reserved in E820
PCI: Using MMCONFIG at f8000000 - fbffffff
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1080-10bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *10
ACPI: PCI Interrupt Link [LNKC] (IRQs 9 10 11) *4
ACPI: PCI Interrupt Link [LNKD] (IRQs *5 7 9 10 11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disab=
led.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size =3D 128
NetLabel:  protocols =3D UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
system 00:05: ioport range 0xc80-0xcff could not be reserved
system 00:08: iomem range 0xfed00000-0xfed003ff has been reserved
system 00:09: ioport range 0x900-0x97f has been reserved
system 00:09: ioport range 0x4d0-0x4d1 has been reserved
system 00:09: ioport range 0x1000-0x1005 has been reserved
system 00:09: ioport range 0x1008-0x100f has been reserved
system 00:0a: ioport range 0xf400-0xf4fe has been reserved
system 00:0a: ioport range 0x1006-0x1007 has been reserved
system 00:0a: ioport range 0x100a-0x1059 could not be reserved
system 00:0a: ioport range 0x1060-0x107f has been reserved
system 00:0a: ioport range 0x1080-0x10bf has been reserved
system 00:0a: ioport range 0x10c0-0x10df has been reserved
system 00:0a: ioport range 0x1010-0x102f has been reserved
system 00:0a: ioport range 0x809-0x809 has been reserved
system 00:0b: iomem range 0x0-0x9efff could not be reserved
system 00:0b: iomem range 0x9f000-0x9ffff could not be reserved
system 00:0b: iomem range 0xc0000-0xcffff has been reserved
system 00:0b: iomem range 0xe0000-0xfffff has been reserved
system 00:0b: iomem range 0x100000-0x3f6923ff could not be reserved
system 00:0b: iomem range 0x3f692400-0x3f6fffff could not be reserved
system 00:0b: iomem range 0x3f700000-0x3f7fffff could not be reserved
system 00:0b: iomem range 0x3f700000-0x3fefffff could not be reserved
system 00:0b: iomem range 0xfff00000-0xffffffff could not be reserved
system 00:0b: iomem range 0xffa00000-0xffafffff has been reserved
system 00:0b: iomem range 0xfec00000-0xfec0ffff could not be reserved
system 00:0b: iomem range 0xfee00000-0xfee0ffff could not be reserved
system 00:0b: iomem range 0xfed20000-0xfed8ffff could not be reserved
system 00:0b: iomem range 0xfeda0000-0xfeda3fff could not be reserved
system 00:0b: iomem range 0xfeda4000-0xfeda4fff could not be reserved
system 00:0b: iomem range 0xfeda5000-0xfeda5fff could not be reserved
system 00:0b: iomem range 0xfeda6000-0xfeda6fff has been reserved
system 00:0b: iomem range 0xfed18000-0xfed1bfff could not be reserved
system 00:0b: iomem range 0xf8000000-0xfbffffff could not be reserved
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.1
  IO window: disabled.
  MEM window: 0xfe800000-0xfe8fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.3
  IO window: d000-dfff
  MEM window: 0xfe600000-0xfe7fffff
  PREFETCH window: 0x00000000f0000000-0x00000000f01fffff
PCI: Bridge: 0000:00:1c.5
  IO window: disabled.
  MEM window: 0xfe500000-0xfe5fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: disabled.
  MEM window: 0xfe400000-0xfe4fffff
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.1 to 64
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1c.3 to 64
ACPI: PCI Interrupt 0000:00:1c.5[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.5 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs...<7>Switched to high resolution mode on CPU=
 1
Switched to high resolution mode on CPU 0
 it is
=46reeing initrd memory: 3509k freed
Simple Boot Flag at 0x79 set to 0x1
audit: initializing netlink socket (disabled)
type=3D2000 audit(1222146601.752:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 1987
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
Allocate Port Service[0000:00:1c.0:pcie03]
PCI: Setting latency timer of device 0000:00:1c.1 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.1:pcie00]
Allocate Port Service[0000:00:1c.1:pcie02]
Allocate Port Service[0000:00:1c.1:pcie03]
PCI: Setting latency timer of device 0000:00:1c.3 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.3:pcie00]
Allocate Port Service[0000:00:1c.3:pcie02]
Allocate Port Service[0000:00:1c.3:pcie03]
PCI: Setting latency timer of device 0000:00:1c.5 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.5:pcie00]
Allocate Port Service[0000:00:1c.5:pcie02]
Allocate Port Service[0000:00:1c.5:pcie03]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
ACPI: Lid Switch [LID]
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input=
/input1
ACPI: Power Button (CM) [PBTN]
input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input=
/input2
ACPI: Sleep Button (CM) [SBTN]
ACPI: SSDT 3F6931B8, 01C0 (r1  PmRef  Cpu0Ist     3000 INTL 20050624)
ACPI: SSDT 3F692B4E, 05E5 (r1  PmRef  Cpu0Cst     3001 INTL 20050624)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 3F693378, 00C4 (r1  PmRef  Cpu1Ist     3000 INTL 20050624)
ACPI: SSDT 3F693133, 0085 (r1  PmRef  Cpu1Cst     3000 INTL 20050624)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: LNXTHERM:01 is registered as thermal_zone0
ACPI: Thermal Zone [THM] (42 C)
hpet_resources: 0xfed00000 is busy
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
agpgart: Detected an Intel 965GM Chipset.
agpgart: Detected 7676K stolen memory.
agpgart: AGP aperture is 256M @ 0xe0000000
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
brd: module loaded
input: Macintosh mouse button emulation as /devices/virtual/input/input3
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input=
/input4
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k
cpuidle: using governor ladder
cpuidle: using governor menu
Marking TSC unstable due to TSC halts in idle
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
  Magic number: 8:889:163
  hash matches drivers/base/power/main.c:113
=46reeing unused kernel memory: 980k freed
Write protecting the kernel read-only data: 3848k
Clocksource tsc unstable (delta =3D -119803754 ns)
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input5
input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio1/input/inp=
ut6
usb usb1: New USB device found, idVendor=3D1d6b, idProduct=3D0002
usb usb1: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.26.3-29.fc9.x86_64 ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
usb usb2: New USB device found, idVendor=3D1d6b, idProduct=3D0002
usb usb2: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.26.3-29.fc9.x86_64 ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f20
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb usb3: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb3: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.26.3-29.fc9.x86_64 uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f00
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb usb4: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb4: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.26.3-29.fc9.x86_64 uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f80
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb usb5: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb5: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.26.3-29.fc9.x86_64 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.0
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f60
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
usb usb6: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb6: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.26.3-29.fc9.x86_64 uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.1
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
usb usb7: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb7: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.26.3-29.fc9.x86_64 uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.2
SCSI subsystem initialized
Driver 'sd' needs updating - please use bus_type methods
libata version 3.00 loaded.
ahci 0000:00:1f.2: version 3.0
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, low) -> IRQ 17
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x5 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part=20
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
ata1: SATA max UDMA/133 abar m2048@0xfe9fb800 port 0xfe9fb900 irq 17
ata2: DUMMY
ata3: SATA max UDMA/133 abar m2048@0xfe9fb800 port 0xfe9fba00 irq 17
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-8: WDC WD1200BEVS-75UST0, 01.01A01, max UDMA/133
ata1.00: 234441648 sectors, multi 8: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata3: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      WDC WD1200BEVS-7 01.0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 >
sd 0:0:0:0: [sda] Attached SCSI disk
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redha=
t.com
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
ACPI: AC Adapter [AC] (off-line)
[drm] Initialized drm 1.1.0 20060810
ACPI: Battery Slot [BAT0] (battery present)
ACPI: WMI: Mapper loaded
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:02.0 to 64
[drm] Initialized i915 1.12.0 20071122 on minor 0
ACPI: device:32 is registered as cooling_device2
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:2e/dev=
ice:2f/input/input7
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
ACPI: device:37 is registered as cooling_device3
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:34/inp=
ut/input8
ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:39/inp=
ut/input9
ACPI: Video Device [VID2] (multi-head: yes  rom: no  post: no)
tg3.c:v3.92.1 (June 9, 2008)
ACPI: PCI Interrupt 0000:09:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:09:00.0 to 64
iTCO_vendor_support: vendor-support=3D0
eth0: Tigon3 [partno(BCM95906) rev c002 PHY(5906)] (PCI Express) 10/100Base=
=2DTX Ethernet 00:1c:23:f7:5e:f5
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[0] TSOcap[0]
eth0: dma_rwctrl[76180000] dma_mask[64-bit]
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
iTCO_wdt: Found a ICH8M TCO device (Version=3D2, TCOBASE=3D0x1060)
iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1f.1 to 64
ACPI: PCI interrupt for device 0000:00:1f.1 disabled
sd 0:0:0:0: Attached scsi generic sg0 type 0
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) -> IRQ 17
ACPI: PCI Interrupt 0000:03:01.0[A] -> GSI 19 (level, low) -> IRQ 19
input: PC Speaker as /devices/platform/pcspkr/input/input10
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Lin=
ux, 1.2.26kds
iwl3945: Copyright(c) 2003-2008 Intel Corporation
firewire_ohci: Added fw-ohci device 0000:03:01.0, OHCI version 1.10
ata_piix 0000:00:1f.1: version 2.12
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi3 : ata_piix
scsi4 : ata_piix
ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x6fa0 irq 14
ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x6fa8 irq 15
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
ata4.00: ATAPI: PBDS DVD+/-RW DS-8W1P, BD1B, max UDMA/33
ata4.00: configured for UDMA/33
ata5: port disabled. ignoring.
isa bounce pool size: 16 pages
scsi 3:0:0:0: CD-ROM            PBDS     DVD+-RW DS-8W1P  BD1B PQ: 0 ANSI: 5
scsi 3:0:0:0: Attached scsi generic sg1 type 5
ACPI: PCI Interrupt 0000:0c:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:0c:00.0 to 64
iwl3945: Detected Intel Wireless WiFi Link 3945ABG
iwl3945: Tunable channels: 11 802.11bg, 13 802.11a channels
phy0: Selected rate control algorithm 'iwl-3945-rs'
firewire_core: created device fw0: GUID 344fc000245b6d81, S400
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 3:0:0:0: Attached scsi CD-ROM sr0
ACPI: PCI interrupt for device 0000:0c:00.0 disabled
sdhci: SDHCI controller found at 0000:03:01.1 [1180:0822] (rev 22)
ACPI: PCI Interrupt 0000:03:01.1[B] -> GSI 18 (level, low) -> IRQ 18
Registered led device: mmc0
mmc0: SDHCI at 0xfe4ff500 irq 18 DMA
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1b.0 to 64
irq 18: nobody cared (try booting with the "irqpoll" option)
Pid: 0, comm: swapper Not tainted 2.6.26.3-29.fc9.x86_64 #1

Call Trace:
 <IRQ>  [<ffffffff8104cbf8>] ? hrtimer_start+0x11f/0x141
 [<ffffffff81076877>] __report_bad_irq+0x38/0x7c
 [<ffffffff81076aa4>] note_interrupt+0x1e9/0x249
 [<ffffffff810771ad>] handle_fasteoi_irq+0xab/0xd0
 [<ffffffff8100ea08>] do_IRQ+0xf7/0x169
 [<ffffffff8100c68d>] ret_from_intr+0x0/0x19
 <EOI>  [<ffffffff81187ac6>] ? acpi_idle_enter_simple+0x1e1/0x25c
 [<ffffffff81187abe>] ? acpi_idle_enter_simple+0x1d9/0x25c
 [<ffffffff811fc1a5>] ? cpuidle_idle_call+0x8d/0xc1
 [<ffffffff811fc118>] ? cpuidle_idle_call+0x0/0xc1
 [<ffffffff8100a000>] ? default_idle+0x0/0x4b
 [<ffffffff8100b1ca>] ? cpu_idle+0x92/0xda
 [<ffffffff8128b55d>] ? rest_init+0x61/0x63

handlers:
[<ffffffffa02b09a6>] (sdhci_irq+0x0/0x635 [sdhci])
Disabling IRQ #18
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
device-mapper: multipath: version 1.0.5 loaded
loop: module loaded
EXT3 FS on dm-0, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 2031608k swap on /dev/mapper/VolGroup00-LogVol01.  Priority:-1 exten=
ts:1 across:2031608k
firmware: requesting intel-ucode/06-0f-0d
firmware: requesting intel-ucode/06-0f-0d
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
ip6_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (8192 buckets, 32768 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
warning: `dbus-daemon' uses deprecated v2 capabilities in a way that may be=
 insecure.
fuse init (API version 7.9)
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.9
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
Bluetooth: BNEP (Ethernet Emulation) ver 1.2
Bluetooth: BNEP filters: protocol multicast
Bridge firewalling registered
pan0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
ADDRCONF(NETDEV_UP): eth0: link is not ready
ACPI: PCI Interrupt 0000:0c:00.0[A] -> GSI 17 (level, low) -> IRQ 17
firmware: requesting iwlwifi-3945-1.ucode
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
wlan0: authenticate with AP 00:17:3f:a9:4c:d9
wlan0: authenticated
wlan0: associate with AP 00:17:3f:a9:4c:d9
wlan0: RX AssocResp from 00:17:3f:a9:4c:d9 (capab=3D0x421 status=3D0 aid=3D=
1)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: disassociating by local choice (reason=3D3)
wlan0: authenticate with AP 00:01:38:b3:b2:7d
wlan0: authenticated
wlan0: associate with AP 00:01:38:b3:b2:7d
wlan0: RX AssocResp from 00:01:38:b3:b2:7d (capab=3D0x431 status=3D0 aid=3D=
3)
wlan0: associated
wlan0: No ProbeResp from current AP 00:01:38:b3:b2:7d - assume out of range
wlan0: no IPv6 routers present
wlan0: authenticate with AP 00:01:38:b3:b2:7d
wlan0: authenticated
wlan0: associate with AP 00:01:38:b3:b2:7d
wlan0: RX ReassocResp from 00:01:38:b3:b2:7d (capab=3D0x431 status=3D0 aid=
=3D3)
wlan0: associated
end_request: I/O error, dev sr0, sector 1397384
Buffer I/O error on device sr0, logical block 349346
Buffer I/O error on device sr0, logical block 349347
end_request: I/O error, dev sr0, sector 1397384
Buffer I/O error on device sr0, logical block 349346
Buffer I/O error on device sr0, logical block 349347
end_request: I/O error, dev sr0, sector 0
Buffer I/O error on device sr0, logical block 0
Buffer I/O error on device sr0, logical block 1
Buffer I/O error on device sr0, logical block 2
Buffer I/O error on device sr0, logical block 3
end_request: I/O error, dev sr0, sector 0
Buffer I/O error on device sr0, logical block 0
Buffer I/O error on device sr0, logical block 1
end_request: I/O error, dev sr0, sector 0
end_request: I/O error, dev sr0, sector 4
end_request: I/O error, dev sr0, sector 0
end_request: I/O error, dev sr0, sector 0
end_request: I/O error, dev sr0, sector 4
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1
  groups: 0 1
  domain 1: span 0-1
   groups: 0-1
   domain 2: span 0-1
    groups: 0-1
CPU1 attaching sched-domain:
 domain 0: span 0-1
  groups: 1 0
  domain 1: span 0-1
   groups: 0-1
   domain 2: span 0-1
    groups: 0-1
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1
  groups: 0 1
  domain 1: span 0-1
   groups: 0-1
CPU1 attaching sched-domain:
 domain 0: span 0-1
  groups: 1 0
  domain 1: span 0-1
   groups: 0-1
wlan0: disassociating by local choice (reason=3D3)
ACPI: PCI interrupt for device 0000:0c:00.0 disabled
PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
=46reezing user space processes ... (elapsed 0.00 seconds) done.
=46reezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Entering mem sleep
Suspending console(s)
drm_sysfs_suspend
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
ACPI handle has no context!
ACPI: PCI interrupt for device 0000:03:01.1 disabled
ACPI handle has no context!
ACPI: PCI interrupt for device 0000:00:1f.2 disabled
ata5: port disabled. ignoring.
ACPI: PCI interrupt for device 0000:00:1f.1 disabled
ACPI: PCI interrupt for device 0000:00:1d.7 disabled
ACPI: PCI interrupt for device 0000:00:1d.2 disabled
ACPI: PCI interrupt for device 0000:00:1d.1 disabled
ACPI: PCI interrupt for device 0000:00:1d.0 disabled
ACPI: PCI interrupt for device 0000:00:1b.0 disabled
ACPI: PCI interrupt for device 0000:00:1a.7 disabled
ACPI: PCI interrupt for device 0000:00:1a.1 disabled
ACPI: PCI interrupt for device 0000:00:1a.0 disabled
ACPI: Preparing to enter system sleep state S3
Disabling non-boot CPUs ...
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
Broke affinity for irq 1
Broke affinity for irq 12
Broke affinity for irq 17
Broke affinity for irq 21
CPU 1 is now offline
SMP alternatives: switching to UP code
CPU0 attaching sched-domain:
 domain 0: span 0
  groups: 0
CPU1 is down
Extended CMOS year: 2000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Back to C!
Extended CMOS year: 2000
Enabling non-boot CPUs ...
CPU0 attaching NULL sched-domain.
SMP alternatives: switching to SMP code
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 2992.38 BogoMIPS (lpj=3D14=
96192)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     T5250  @ 1.50GHz stepping 0d
CPU0 attaching sched-domain:
 domain 0: span 0-1
  groups: 0 1
  domain 1: span 0-1
   groups: 0-1
CPU1 attaching sched-domain:
 domain 0: span 0-1
  groups: 1 0
  domain 1: span 0-1
   groups: 0-1
ACPI Error (psloop-0136): Found unknown opcode 17 at AML address ffffc20000=
1f43c3 offset 0, ignoring [20080321]
ACPI Error (psargs-0358): [DB=FE=FF] Namespace lookup failure, AE_NOT_FOUND
ACPI Error (psparse-0530): Method parse/execution failed [\_PR_.CPU1._PCT] =
(Node ffff81003f1f4c40), AE_NOT_FOUND
Switched to high resolution mode on CPU 1
ACPI Exception (processor_perflib-0202): AE_NOT_FOUND, Evaluating _PCT [200=
80321]
CPU1 is up
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:02.0 to 64
uhci_hcd 0000:00:1a.0: enabling device (0000 -> 0001)
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1a.0 to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1a.1: enabling device (0000 -> 0001)
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1a.1 to 64
usb usb4: root hub lost power or was reset
ehci_hcd 0000:00:1a.7: enabling device (0000 -> 0002)
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1b.0 to 64
PCI: Setting latency timer of device 0000:00:1c.0 to 64
PCI: Setting latency timer of device 0000:00:1c.1 to 64
PCI: Setting latency timer of device 0000:00:1c.3 to 64
PCI: Setting latency timer of device 0000:00:1c.5 to 64
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.0 to 64
usb usb5: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: enabling device (0000 -> 0001)
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.1 to 64
usb usb6: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: enabling device (0000 -> 0001)
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.2 to 64
usb usb7: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.7 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1f.1 to 64
ata5: port disabled. ignoring.
ata4.00: _GTF evaluation failed (AE 0x1001)
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1f.2 to 64
ata4.00: configured for UDMA/33
firewire_core: skipped bus generations, destroying all nodes
ACPI: PCI Interrupt 0000:03:01.1[B] -> GSI 18 (level, low) -> IRQ 18
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3: SATA link down (SStatus 0 SControl 300)
firewire_core: created device fw0: GUID 344fc000245b6d81, S400
ata1.00: configured for UDMA/133
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
sd 0:0:0:0: [sda] Starting disk
PM: Finishing wakeup.
Restarting tasks ... done.
ADDRCONF(NETDEV_UP): eth0: link is not ready
iwl3945 0000:0c:00.0: enabling device (0000 -> 0002)
ACPI: PCI Interrupt 0000:0c:00.0[A] -> GSI 17 (level, low) -> IRQ 17
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
wlan0: authenticate with AP 00:17:3f:a9:4c:d9
ADDRCONF(NETDEV_UP): wlan0: link is not ready
wlan0: authenticate with AP 00:17:3f:a9:4c:d9
wlan0: authenticated
wlan0: associate with AP 00:17:3f:a9:4c:d9
wlan0: deauthenticated
wlan0: authenticate with AP 00:17:3f:a9:4c:d9
wlan0: authenticated
wlan0: associate with AP 00:17:3f:a9:4c:d9
wlan0: deauthenticated
wlan0: authenticate with AP 00:17:3f:a9:4c:d9
wlan0: authenticated
wlan0: associate with AP 00:17:3f:a9:4c:d9
wlan0: RX AssocResp from 00:17:3f:a9:4c:d9 (capab=3D0x421 status=3D0 aid=3D=
1)
wlan0: associated
wlan0: disassociating by local choice (reason=3D3)
wlan0: No ProbeResp from current AP 00:17:3f:a9:4c:d9 - assume out of range
end_request: I/O error, dev sr0, sector 0
__ratelimit: 6 messages suppressed
Buffer I/O error on device sr0, logical block 0
Buffer I/O error on device sr0, logical block 1
Buffer I/O error on device sr0, logical block 2
Buffer I/O error on device sr0, logical block 3
Buffer I/O error on device sr0, logical block 4
Buffer I/O error on device sr0, logical block 5
Buffer I/O error on device sr0, logical block 6
Buffer I/O error on device sr0, logical block 7
end_request: I/O error, dev sr0, sector 0
Buffer I/O error on device sr0, logical block 0
end_request: I/O error, dev sr0, sector 4
Buffer I/O error on device sr0, logical block 1
end_request: I/O error, dev sr0, sector 1397384
end_request: I/O error, dev sr0, sector 1397384
end_request: I/O error, dev sr0, sector 0
end_request: I/O error, dev sr0, sector 0
end_request: I/O error, dev sr0, sector 4
end_request: I/O error, dev sr0, sector 0
wlan0: deauthenticated
wlan0: authenticate with AP 00:01:38:b3:b2:7d
wlan0: authenticated
wlan0: associate with AP 00:01:38:b3:b2:7d
wlan0: RX AssocResp from 00:01:38:b3:b2:7d (capab=3D0x431 status=3D0 aid=3D=
3)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: no IPv6 routers present
usb 2-4: new high speed USB device using ehci_hcd and address 2
usb 2-4: configuration #1 chosen from 1 choice
usb 2-4: New USB device found, idVendor=3D0204, idProduct=3D6025
usb 2-4: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
usb 2-4: Product: Flash Disk
usb 2-4: Manufacturer: CBM
usb 2-4: SerialNumber: 2001390039054A08
Initializing USB Mass Storage driver...
scsi5 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
usb-storage: device scan complete
scsi 5:0:0:0: Direct-Access     CBM      Flash Disk       5.00 PQ: 0 ANSI: 2
sd 5:0:0:0: [sdb] 2068992 512-byte hardware sectors (1059 MB)
sd 5:0:0:0: [sdb] Write Protect is off
sd 5:0:0:0: [sdb] Mode Sense: 0b 00 00 08
sd 5:0:0:0: [sdb] Assuming drive cache: write through
sd 5:0:0:0: [sdb] 2068992 512-byte hardware sectors (1059 MB)
sd 5:0:0:0: [sdb] Write Protect is off
sd 5:0:0:0: [sdb] Mode Sense: 0b 00 00 08
sd 5:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 5:0:0:0: [sdb] Attached SCSI disk
sd 5:0:0:0: Attached scsi generic sg2 type 0
usb 2-4: USB disconnect, address 2
usb 2-4: new high speed USB device using ehci_hcd and address 3
usb 2-4: configuration #1 chosen from 1 choice
scsi6 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
usb 2-4: New USB device found, idVendor=3D0204, idProduct=3D6025
usb 2-4: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
usb 2-4: Product: Flash Disk
usb 2-4: Manufacturer: CBM
usb 2-4: SerialNumber: 2001390039054A08
usb-storage: device scan complete
scsi 6:0:0:0: Direct-Access     CBM      Flash Disk       5.00 PQ: 0 ANSI: 2
sd 6:0:0:0: [sdb] 2068992 512-byte hardware sectors (1059 MB)
sd 6:0:0:0: [sdb] Write Protect is off
sd 6:0:0:0: [sdb] Mode Sense: 0b 00 00 08
sd 6:0:0:0: [sdb] Assuming drive cache: write through
sd 6:0:0:0: [sdb] 2068992 512-byte hardware sectors (1059 MB)
sd 6:0:0:0: [sdb] Write Protect is off
sd 6:0:0:0: [sdb] Mode Sense: 0b 00 00 08
sd 6:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 6:0:0:0: [sdb] Attached SCSI disk
sd 6:0:0:0: Attached scsi generic sg2 type 0
usb 2-4: USB disconnect, address 3
ACPI Error (psargs-0358): [A=FE=FF] Namespace lookup failure, AE_NOT_FOUND
ACPI Error (psparse-0530): Method parse/execution failed [\_PR_.CPU1._PPC] =
(Node ffff81003f1f4c20), AE_NOT_FOUND
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1
  groups: 0 1
  domain 1: span 0-1
   groups: 0-1
   domain 2: span 0-1
    groups: 0-1
CPU1 attaching sched-domain:
 domain 0: span 0-1
  groups: 1 0
  domain 1: span 0-1
   groups: 0-1
   domain 2: span 0-1
    groups: 0-1
ACPI Error (psargs-0358): [A=FE=FF] Namespace lookup failure, AE_NOT_FOUND
ACPI Error (psparse-0530): Method parse/execution failed [\_PR_.CPU1._PPC] =
(Node ffff81003f1f4c20), AE_NOT_FOUND
BUG: unable to handle kernel NULL pointer dereference at 0000000000000078
IP: [<ffffffff810af6ee>] vfs_getattr+0x30/0x61
PGD 23de1067 PUD e9f8067 PMD 33c1d067 PTE 0
Oops: 0000 [1] SMP=20
CPU 0=20
Modules linked in: vfat fat usb_storage bridge bnep rfcomm l2cap bluetooth =
autofs4 fuse sunrpc ipt_REJECT nf_conntrack_ipv4 iptable_filter ip_tables i=
p6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filte=
r ip6_tables x_tables cpufreq_ondemand acpi_cpufreq freq_table loop dm_mult=
ipath ipv6 snd_hda_intel arc4 ecb crypto_blkcipher sr_mod cdrom snd_seq_dum=
my snd_seq_oss snd_seq_midi_event dcdbas sdhci snd_seq iwl3945 joydev ata_p=
iix pcspkr firewire_ohci i2c_i801 firewire_core ata_generic snd_seq_device =
sg mmc_core pata_acpi iTCO_wdt snd_pcm_oss iTCO_vendor_support crc_itu_t rf=
kill mac80211 tg3 snd_mixer_oss snd_pcm cfg80211 snd_timer snd_page_alloc s=
nd_hwdep snd soundcore video output i915 wmi battery drm i2c_algo_bit i2c_c=
ore ac dm_snapshot dm_zero dm_mirror dm_log dm_mod ahci libata sd_mod scsi_=
mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
Pid: 5098, comm: kio_file Not tainted 2.6.26.3-29.fc9.x86_64 #1
RIP: 0010:[<ffffffff810af6ee>]  [<ffffffff810af6ee>] vfs_getattr+0x30/0x61
RSP: 0018:ffff81001a1a5df8  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff81000100fec0
RDX: 0000000000000000 RSI: ffff8100001fe1a0 RDI: ffff81003ebf6d00
RBP: ffff81001a1a5e28 R08: 0000000000000000 R09: 0000000000000011
R10: 0000003acdf67a70 R11: ffff81001a1a5dd8 R12: ffff8100001fe1a0
R13: ffff81000003fcc8 R14: ffff81001a1a5ef8 R15: ffff81003ebf6d00
=46S:  00007fc7e14c3800(0000) GS:ffffffff81417000(0000) knlGS:0000000000000=
000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000078 CR3: 0000000024d2c000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kio_file (pid: 5098, threadinfo ffff81001a1a4000, task ffff81003ddf=
2d40)
Stack:  0000000000001000 0000000000000000 ffff81001a1a5ef8 ffff81001a1a5e38
 0000000000000002 00007fffe950b690 ffff81001a1a5ee8 ffffffff810af810
 ffff81003ebf6d00 ffff8100001fe1a0 ffff81001a1a5e88 ffffffff810c2c99
Call Trace:
 [<ffffffff810af810>] vfs_lstat_fd+0x40/0x5a
 [<ffffffff810c2c99>] ? mntput_no_expire+0x2a/0x134
 [<ffffffff810b34f2>] ? path_put+0x2c/0x30
 [<ffffffff810af84c>] sys_newlstat+0x22/0x3c
 [<ffffffff810134f4>] ? syscall_trace_enter+0xe8/0xfa
 [<ffffffff8100c232>] ? tracesys+0x71/0xd5
 [<ffffffff8100c291>] tracesys+0xd0/0xd5


Code: 57 49 89 ff 41 56 49 89 d6 41 55 41 54 49 89 f4 53 48 83 ec 08 4c 8b =
6e 10 e8 b0 c2 05 00 85 c0 89 c3 75 2a 49 8b 85 e8 00 00 00 <48> 8b 40 78 4=
8 85 c0 74 0f 4c 89 f2 4c 89 e6 4c 89 ff ff d0 89=20
RIP  [<ffffffff810af6ee>] vfs_getattr+0x30/0x61
 RSP <ffff81001a1a5df8>
CR2: 0000000000000078
=2D--[ end trace 6eb8248fc6e8ec1b ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000078
IP: [<ffffffff810af6ee>] vfs_getattr+0x30/0x61
PGD 1fe2c067 PUD 1fe70067 PMD 1fe05067 PTE 0
Oops: 0000 [2] SMP=20
CPU 1=20
Modules linked in: vfat fat usb_storage bridge bnep rfcomm l2cap bluetooth =
autofs4 fuse sunrpc ipt_REJECT nf_conntrack_ipv4 iptable_filter ip_tables i=
p6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filte=
r ip6_tables x_tables cpufreq_ondemand acpi_cpufreq freq_table loop dm_mult=
ipath ipv6 snd_hda_intel arc4 ecb crypto_blkcipher sr_mod cdrom snd_seq_dum=
my snd_seq_oss snd_seq_midi_event dcdbas sdhci snd_seq iwl3945 joydev ata_p=
iix pcspkr firewire_ohci i2c_i801 firewire_core ata_generic snd_seq_device =
sg mmc_core pata_acpi iTCO_wdt snd_pcm_oss iTCO_vendor_support crc_itu_t rf=
kill mac80211 tg3 snd_mixer_oss snd_pcm cfg80211 snd_timer snd_page_alloc s=
nd_hwdep snd soundcore video output i915 wmi battery drm i2c_algo_bit i2c_c=
ore ac dm_snapshot dm_zero dm_mirror dm_log dm_mod ahci libata sd_mod scsi_=
mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
Pid: 5101, comm: kio_file Tainted: G      D   2.6.26.3-29.fc9.x86_64 #1
RIP: 0010:[<ffffffff810af6ee>]  [<ffffffff810af6ee>] vfs_getattr+0x30/0x61
RSP: 0018:ffff81001fe01df8  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff81000101c400
RDX: 0000000000000000 RSI: ffff8100001fe1a0 RDI: ffff81003ebf6d00
RBP: ffff81001fe01e28 R08: 0000000000000000 R09: 0000000000000011
R10: 0000003acdf67a70 R11: ffff81001fe01dd8 R12: ffff8100001fe1a0
R13: ffff81000003fcc8 R14: ffff81001fe01ef8 R15: ffff81003ebf6d00
=46S:  00007fc7e14c3800(0000) GS:ffff81003f004780(0000) knlGS:0000000000000=
000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000078 CR3: 000000000fc11000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kio_file (pid: 5101, threadinfo ffff81001fe00000, task ffff81003dcf=
c3e0)
Stack:  0000000000001000 0000000000000000 ffff81001fe01ef8 ffff81001fe01e38
 0000000000000002 00007fffe950b690 ffff81001fe01ee8 ffffffff810af810
 ffff81003ebf6d00 ffff8100001fe1a0 ffff81001fe01e88 ffffffff810c2c99
Call Trace:
 [<ffffffff810af810>] vfs_lstat_fd+0x40/0x5a
 [<ffffffff810c2c99>] ? mntput_no_expire+0x2a/0x134
 [<ffffffff810b34f2>] ? path_put+0x2c/0x30
 [<ffffffff810af84c>] sys_newlstat+0x22/0x3c
 [<ffffffff810134f4>] ? syscall_trace_enter+0xe8/0xfa
 [<ffffffff8100c232>] ? tracesys+0x71/0xd5
 [<ffffffff8100c291>] tracesys+0xd0/0xd5


Code: 57 49 89 ff 41 56 49 89 d6 41 55 41 54 49 89 f4 53 48 83 ec 08 4c 8b =
6e 10 e8 b0 c2 05 00 85 c0 89 c3 75 2a 49 8b 85 e8 00 00 00 <48> 8b 40 78 4=
8 85 c0 74 0f 4c 89 f2 4c 89 e6 4c 89 ff ff d0 89=20
RIP  [<ffffffff810af6ee>] vfs_getattr+0x30/0x61
 RSP <ffff81001fe01df8>
CR2: 0000000000000078
=2D--[ end trace 6eb8248fc6e8ec1b ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000078
IP: [<ffffffff810af6ee>] vfs_getattr+0x30/0x61
PGD 1feff067 PUD 1ffb2067 PMD 15e1f067 PTE 0
Oops: 0000 [3] SMP=20
CPU 0=20
Modules linked in: vfat fat usb_storage bridge bnep rfcomm l2cap bluetooth =
autofs4 fuse sunrpc ipt_REJECT nf_conntrack_ipv4 iptable_filter ip_tables i=
p6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filte=
r ip6_tables x_tables cpufreq_ondemand acpi_cpufreq freq_table loop dm_mult=
ipath ipv6 snd_hda_intel arc4 ecb crypto_blkcipher sr_mod cdrom snd_seq_dum=
my snd_seq_oss snd_seq_midi_event dcdbas sdhci snd_seq iwl3945 joydev ata_p=
iix pcspkr firewire_ohci i2c_i801 firewire_core ata_generic snd_seq_device =
sg mmc_core pata_acpi iTCO_wdt snd_pcm_oss iTCO_vendor_support crc_itu_t rf=
kill mac80211 tg3 snd_mixer_oss snd_pcm cfg80211 snd_timer snd_page_alloc s=
nd_hwdep snd soundcore video output i915 wmi battery drm i2c_algo_bit i2c_c=
ore ac dm_snapshot dm_zero dm_mirror dm_log dm_mod ahci libata sd_mod scsi_=
mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
Pid: 5107, comm: kio_file Tainted: G      D   2.6.26.3-29.fc9.x86_64 #1
RIP: 0010:[<ffffffff810af6ee>]  [<ffffffff810af6ee>] vfs_getattr+0x30/0x61
RSP: 0018:ffff81001ffd7df8  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff81000100fec0
RDX: 0000000000000000 RSI: ffff8100001fe1a0 RDI: ffff81003ebf6d00
RBP: ffff81001ffd7e28 R08: 0000000000000000 R09: 0000000000000011
R10: 0000003acdf67a70 R11: ffff81001ffd7dd8 R12: ffff8100001fe1a0
R13: ffff81000003fcc8 R14: ffff81001ffd7ef8 R15: ffff81003ebf6d00
=46S:  00007fc7e14c3800(0000) GS:ffffffff81417000(0000) knlGS:0000000000000=
000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000078 CR3: 000000001fefe000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kio_file (pid: 5107, threadinfo ffff81001ffd6000, task ffff81003d82=
da80)
Stack:  0000000000001000 0000000000000000 ffff81001ffd7ef8 ffff81001ffd7e38
 0000000000000002 00007fffe950b690 ffff81001ffd7ee8 ffffffff810af810
 ffff81003ebf6d00 ffff8100001fe1a0 ffff81001ffd7e88 ffffffff810c2c99
Call Trace:
 [<ffffffff810af810>] vfs_lstat_fd+0x40/0x5a
 [<ffffffff810c2c99>] ? mntput_no_expire+0x2a/0x134
 [<ffffffff810b34f2>] ? path_put+0x2c/0x30
 [<ffffffff810af84c>] sys_newlstat+0x22/0x3c
 [<ffffffff810134f4>] ? syscall_trace_enter+0xe8/0xfa
 [<ffffffff8100c232>] ? tracesys+0x71/0xd5
 [<ffffffff8100c291>] tracesys+0xd0/0xd5


Code: 57 49 89 ff 41 56 49 89 d6 41 55 41 54 49 89 f4 53 48 83 ec 08 4c 8b =
6e 10 e8 b0 c2 05 00 85 c0 89 c3 75 2a 49 8b 85 e8 00 00 00 <48> 8b 40 78 4=
8 85 c0 74 0f 4c 89 f2 4c 89 e6 4c 89 ff ff d0 89=20
RIP  [<ffffffff810af6ee>] vfs_getattr+0x30/0x61
 RSP <ffff81001ffd7df8>
CR2: 0000000000000078
=2D--[ end trace 6eb8248fc6e8ec1b ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000078
IP: [<ffffffff810af6ee>] vfs_getattr+0x30/0x61
PGD e9dc067 PUD e9dd067 PMD e9e5067 PTE 0
Oops: 0000 [4] SMP=20
CPU 0=20
Modules linked in: vfat fat usb_storage bridge bnep rfcomm l2cap bluetooth =
autofs4 fuse sunrpc ipt_REJECT nf_conntrack_ipv4 iptable_filter ip_tables i=
p6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filte=
r ip6_tables x_tables cpufreq_ondemand acpi_cpufreq freq_table loop dm_mult=
ipath ipv6 snd_hda_intel arc4 ecb crypto_blkcipher sr_mod cdrom snd_seq_dum=
my snd_seq_oss snd_seq_midi_event dcdbas sdhci snd_seq iwl3945 joydev ata_p=
iix pcspkr firewire_ohci i2c_i801 firewire_core ata_generic snd_seq_device =
sg mmc_core pata_acpi iTCO_wdt snd_pcm_oss iTCO_vendor_support crc_itu_t rf=
kill mac80211 tg3 snd_mixer_oss snd_pcm cfg80211 snd_timer snd_page_alloc s=
nd_hwdep snd soundcore video output i915 wmi battery drm i2c_algo_bit i2c_c=
ore ac dm_snapshot dm_zero dm_mirror dm_log dm_mod ahci libata sd_mod scsi_=
mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
Pid: 3255, comm: kio_file Tainted: G      D   2.6.26.3-29.fc9.x86_64 #1
RIP: 0010:[<ffffffff810af6ee>]  [<ffffffff810af6ee>] vfs_getattr+0x30/0x61
RSP: 0018:ffff81000e93fdf8  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff81000100fec0
RDX: 0000000000000000 RSI: ffff8100001fe1a0 RDI: ffff81003ebf6d00
RBP: ffff81000e93fe28 R08: 0000000000000000 R09: 0000000000000011
R10: 0000003acdf67a70 R11: ffff81000e93fdd8 R12: ffff8100001fe1a0
R13: ffff81000003fcc8 R14: ffff81000e93fef8 R15: ffff81003ebf6d00
=46S:  00007fc7e14c3800(0000) GS:ffffffff81417000(0000) knlGS:0000000000000=
000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000078 CR3: 000000000e9d5000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kio_file (pid: 3255, threadinfo ffff81000e93e000, task ffff81000e85=
96a0)
Stack:  0000000000001000 0000000000000000 ffff81000e93fef8 ffff81000e93fe38
 0000000000000002 00007fffe950b690 ffff81000e93fee8 ffffffff810af810
 ffff81003ebf6d00 ffff8100001fe1a0 ffff81000e93fe88 ffffffff810c2c99
Call Trace:
 [<ffffffff810af810>] vfs_lstat_fd+0x40/0x5a
 [<ffffffff810c2c99>] ? mntput_no_expire+0x2a/0x134
 [<ffffffff810b34f2>] ? path_put+0x2c/0x30
 [<ffffffff810af84c>] sys_newlstat+0x22/0x3c
 [<ffffffff810134f4>] ? syscall_trace_enter+0xe8/0xfa
 [<ffffffff8100c232>] ? tracesys+0x71/0xd5
 [<ffffffff8100c291>] tracesys+0xd0/0xd5


Code: 57 49 89 ff 41 56 49 89 d6 41 55 41 54 49 89 f4 53 48 83 ec 08 4c 8b =
6e 10 e8 b0 c2 05 00 85 c0 89 c3 75 2a 49 8b 85 e8 00 00 00 <48> 8b 40 78 4=
8 85 c0 74 0f 4c 89 f2 4c 89 e6 4c 89 ff ff d0 89=20
RIP  [<ffffffff810af6ee>] vfs_getattr+0x30/0x61
 RSP <ffff81000e93fdf8>
CR2: 0000000000000078
=2D--[ end trace 6eb8248fc6e8ec1b ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000078
IP: [<ffffffff810af6ee>] vfs_getattr+0x30/0x61
PGD 1ff25067 PUD 1a1e9067 PMD 1ff00067 PTE 0
Oops: 0000 [5] SMP=20
CPU 1=20
Modules linked in: vfat fat usb_storage bridge bnep rfcomm l2cap bluetooth =
autofs4 fuse sunrpc ipt_REJECT nf_conntrack_ipv4 iptable_filter ip_tables i=
p6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filte=
r ip6_tables x_tables cpufreq_ondemand acpi_cpufreq freq_table loop dm_mult=
ipath ipv6 snd_hda_intel arc4 ecb crypto_blkcipher sr_mod cdrom snd_seq_dum=
my snd_seq_oss snd_seq_midi_event dcdbas sdhci snd_seq iwl3945 joydev ata_p=
iix pcspkr firewire_ohci i2c_i801 firewire_core ata_generic snd_seq_device =
sg mmc_core pata_acpi iTCO_wdt snd_pcm_oss iTCO_vendor_support crc_itu_t rf=
kill mac80211 tg3 snd_mixer_oss snd_pcm cfg80211 snd_timer snd_page_alloc s=
nd_hwdep snd soundcore video output i915 wmi battery drm i2c_algo_bit i2c_c=
ore ac dm_snapshot dm_zero dm_mirror dm_log dm_mod ahci libata sd_mod scsi_=
mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
Pid: 5104, comm: kio_file Tainted: G      D   2.6.26.3-29.fc9.x86_64 #1
RIP: 0010:[<ffffffff810af6ee>]  [<ffffffff810af6ee>] vfs_getattr+0x30/0x61
RSP: 0018:ffff81001ff03df8  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff81000101c400
RDX: 0000000000000000 RSI: ffff8100001fe1a0 RDI: ffff81003ebf6d00
RBP: ffff81001ff03e28 R08: 0000000000000000 R09: 0000000000000011
R10: 0000003acdf67a70 R11: ffff81001ff03dd8 R12: ffff8100001fe1a0
R13: ffff81000003fcc8 R14: ffff81001ff03ef8 R15: ffff81003ebf6d00
=46S:  00007fc7e14c3800(0000) GS:ffff81003f004780(0000) knlGS:0000000000000=
000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000078 CR3: 000000001fef6000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kio_file (pid: 5104, threadinfo ffff81001ff02000, task ffff81003f25=
c3e0)
Stack:  0000000000001000 0000000000000000 ffff81001ff03ef8 ffff81001ff03e38
 0000000000000002 00007fffe950b690 ffff81001ff03ee8 ffffffff810af810
 ffff81003ebf6d00 ffff8100001fe1a0 ffff81001ff03e88 ffffffff810c2c99
Call Trace:
 [<ffffffff810af810>] vfs_lstat_fd+0x40/0x5a
 [<ffffffff810c2c99>] ? mntput_no_expire+0x2a/0x134
 [<ffffffff810b34f2>] ? path_put+0x2c/0x30
 [<ffffffff810af84c>] sys_newlstat+0x22/0x3c
 [<ffffffff810134f4>] ? syscall_trace_enter+0xe8/0xfa
 [<ffffffff8100c232>] ? tracesys+0x71/0xd5
 [<ffffffff8100c291>] tracesys+0xd0/0xd5


Code: 57 49 89 ff 41 56 49 89 d6 41 55 41 54 49 89 f4 53 48 83 ec 08 4c 8b =
6e 10 e8 b0 c2 05 00 85 c0 89 c3 75 2a 49 8b 85 e8 00 00 00 <48> 8b 40 78 4=
8 85 c0 74 0f 4c 89 f2 4c 89 e6 4c 89 ff ff d0 89=20
RIP  [<ffffffff810af6ee>] vfs_getattr+0x30/0x61
 RSP <ffff81001ff03df8>
CR2: 0000000000000078
=2D--[ end trace 6eb8248fc6e8ec1b ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000078
IP: [<ffffffff810af6ee>] vfs_getattr+0x30/0x61
PGD 1feff067 PUD 1feb8067 PMD 1febb067 PTE 0
Oops: 0000 [6] SMP=20
CPU 1=20
Modules linked in: vfat fat usb_storage bridge bnep rfcomm l2cap bluetooth =
autofs4 fuse sunrpc ipt_REJECT nf_conntrack_ipv4 iptable_filter ip_tables i=
p6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filte=
r ip6_tables x_tables cpufreq_ondemand acpi_cpufreq freq_table loop dm_mult=
ipath ipv6 snd_hda_intel arc4 ecb crypto_blkcipher sr_mod cdrom snd_seq_dum=
my snd_seq_oss snd_seq_midi_event dcdbas sdhci snd_seq iwl3945 joydev ata_p=
iix pcspkr firewire_ohci i2c_i801 firewire_core ata_generic snd_seq_device =
sg mmc_core pata_acpi iTCO_wdt snd_pcm_oss iTCO_vendor_support crc_itu_t rf=
kill mac80211 tg3 snd_mixer_oss snd_pcm cfg80211 snd_timer snd_page_alloc s=
nd_hwdep snd soundcore video output i915 wmi battery drm i2c_algo_bit i2c_c=
ore ac dm_snapshot dm_zero dm_mirror dm_log dm_mod ahci libata sd_mod scsi_=
mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
Pid: 5151, comm: kio_file Tainted: G      D   2.6.26.3-29.fc9.x86_64 #1
RIP: 0010:[<ffffffff810af6ee>]  [<ffffffff810af6ee>] vfs_getattr+0x30/0x61
RSP: 0018:ffff81001feb7df8  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff81000101c400
RDX: 0000000000000000 RSI: ffff8100001fe1a0 RDI: ffff81003ebf6d00
RBP: ffff81001feb7e28 R08: 0000000000000000 R09: 0000000000000011
R10: 0000003acdf67a70 R11: ffff81001feb7dd8 R12: ffff8100001fe1a0
R13: ffff81000003fcc8 R14: ffff81001feb7ef8 R15: ffff81003ebf6d00
=46S:  00007fc7e14c3800(0000) GS:ffff81003f004780(0000) knlGS:0000000000000=
000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000078 CR3: 000000000e90a000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kio_file (pid: 5151, threadinfo ffff81001feb6000, task ffff81003d46=
96a0)
Stack:  0000000000001000 0000000000000000 ffff81001feb7ef8 ffff81001feb7e38
 0000000000000002 00007fffe950b690 ffff81001feb7ee8 ffffffff810af810
 ffff81003ebf6d00 ffff8100001fe1a0 ffff81001feb7e88 ffffffff810c2c99
Call Trace:
 [<ffffffff810af810>] vfs_lstat_fd+0x40/0x5a
 [<ffffffff810c2c99>] ? mntput_no_expire+0x2a/0x134
 [<ffffffff810b34f2>] ? path_put+0x2c/0x30
 [<ffffffff810af84c>] sys_newlstat+0x22/0x3c
 [<ffffffff810134f4>] ? syscall_trace_enter+0xe8/0xfa
 [<ffffffff8100c232>] ? tracesys+0x71/0xd5
 [<ffffffff8100c291>] tracesys+0xd0/0xd5


Code: 57 49 89 ff 41 56 49 89 d6 41 55 41 54 49 89 f4 53 48 83 ec 08 4c 8b =
6e 10 e8 b0 c2 05 00 85 c0 89 c3 75 2a 49 8b 85 e8 00 00 00 <48> 8b 40 78 4=
8 85 c0 74 0f 4c 89 f2 4c 89 e6 4c 89 ff ff d0 89=20
RIP  [<ffffffff810af6ee>] vfs_getattr+0x30/0x61
 RSP <ffff81001feb7df8>
CR2: 0000000000000078
=2D--[ end trace 6eb8248fc6e8ec1b ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000078
IP: [<ffffffff810af6ee>] vfs_getattr+0x30/0x61
PGD 1ff78067 PUD 20c80067 PMD 1ff65067 PTE 0
Oops: 0000 [7] SMP=20
CPU 1=20
Modules linked in: vfat fat usb_storage bridge bnep rfcomm l2cap bluetooth =
autofs4 fuse sunrpc ipt_REJECT nf_conntrack_ipv4 iptable_filter ip_tables i=
p6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filte=
r ip6_tables x_tables cpufreq_ondemand acpi_cpufreq freq_table loop dm_mult=
ipath ipv6 snd_hda_intel arc4 ecb crypto_blkcipher sr_mod cdrom snd_seq_dum=
my snd_seq_oss snd_seq_midi_event dcdbas sdhci snd_seq iwl3945 joydev ata_p=
iix pcspkr firewire_ohci i2c_i801 firewire_core ata_generic snd_seq_device =
sg mmc_core pata_acpi iTCO_wdt snd_pcm_oss iTCO_vendor_support crc_itu_t rf=
kill mac80211 tg3 snd_mixer_oss snd_pcm cfg80211 snd_timer snd_page_alloc s=
nd_hwdep snd soundcore video output i915 wmi battery drm i2c_algo_bit i2c_c=
ore ac dm_snapshot dm_zero dm_mirror dm_log dm_mod ahci libata sd_mod scsi_=
mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
Pid: 5157, comm: kio_file Tainted: G      D   2.6.26.3-29.fc9.x86_64 #1
RIP: 0010:[<ffffffff810af6ee>]  [<ffffffff810af6ee>] vfs_getattr+0x30/0x61
RSP: 0018:ffff81001ff53df8  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff81000101c400
RDX: 0000000000000000 RSI: ffff8100001fe1a0 RDI: ffff81003ebf6d00
RBP: ffff81001ff53e28 R08: 0000000000000000 R09: 0000000000000011
R10: 0000003acdf67a70 R11: ffff81001ff53dd8 R12: ffff8100001fe1a0
R13: ffff81000003fcc8 R14: ffff81001ff53ef8 R15: ffff81003ebf6d00
=46S:  00007fc7e14c3800(0000) GS:ffff81003f004780(0000) knlGS:0000000000000=
000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000078 CR3: 000000000e90a000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kio_file (pid: 5157, threadinfo ffff81001ff52000, task ffff810027cd=
96a0)
Stack:  0000000000001000 0000000000000000 ffff81001ff53ef8 ffff81001ff53e38
 0000000000000002 00007fffe950b690 ffff81001ff53ee8 ffffffff810af810
 ffff81003ebf6d00 ffff8100001fe1a0 ffff81001ff53e88 ffffffff810c2c99
Call Trace:
 [<ffffffff810af810>] vfs_lstat_fd+0x40/0x5a
 [<ffffffff810c2c99>] ? mntput_no_expire+0x2a/0x134
 [<ffffffff810b34f2>] ? path_put+0x2c/0x30
 [<ffffffff810af84c>] sys_newlstat+0x22/0x3c
 [<ffffffff810134f4>] ? syscall_trace_enter+0xe8/0xfa
 [<ffffffff8100c232>] ? tracesys+0x71/0xd5
 [<ffffffff8100c291>] tracesys+0xd0/0xd5


Code: 57 49 89 ff 41 56 49 89 d6 41 55 41 54 49 89 f4 53 48 83 ec 08 4c 8b =
6e 10 e8 b0 c2 05 00 85 c0 89 c3 75 2a 49 8b 85 e8 00 00 00 <48> 8b 40 78 4=
8 85 c0 74 0f 4c 89 f2 4c 89 e6 4c 89 ff ff d0 89=20
RIP  [<ffffffff810af6ee>] vfs_getattr+0x30/0x61
 RSP <ffff81001ff53df8>
CR2: 0000000000000078
=2D--[ end trace 6eb8248fc6e8ec1b ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000078
IP: [<ffffffff810af6ee>] vfs_getattr+0x30/0x61
PGD e90c067 PUD 33c2f067 PMD 1fe05067 PTE 0
Oops: 0000 [8] SMP=20
CPU 0=20
Modules linked in: vfat fat usb_storage bridge bnep rfcomm l2cap bluetooth =
autofs4 fuse sunrpc ipt_REJECT nf_conntrack_ipv4 iptable_filter ip_tables i=
p6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filte=
r ip6_tables x_tables cpufreq_ondemand acpi_cpufreq freq_table loop dm_mult=
ipath ipv6 snd_hda_intel arc4 ecb crypto_blkcipher sr_mod cdrom snd_seq_dum=
my snd_seq_oss snd_seq_midi_event dcdbas sdhci snd_seq iwl3945 joydev ata_p=
iix pcspkr firewire_ohci i2c_i801 firewire_core ata_generic snd_seq_device =
sg mmc_core pata_acpi iTCO_wdt snd_pcm_oss iTCO_vendor_support crc_itu_t rf=
kill mac80211 tg3 snd_mixer_oss snd_pcm cfg80211 snd_timer snd_page_alloc s=
nd_hwdep snd soundcore video output i915 wmi battery drm i2c_algo_bit i2c_c=
ore ac dm_snapshot dm_zero dm_mirror dm_log dm_mod ahci libata sd_mod scsi_=
mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
Pid: 5163, comm: kio_file Tainted: G      D   2.6.26.3-29.fc9.x86_64 #1
RIP: 0010:[<ffffffff810af6ee>]  [<ffffffff810af6ee>] vfs_getattr+0x30/0x61
RSP: 0018:ffff81001ff81df8  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff81000100fec0
RDX: 0000000000000000 RSI: ffff8100001fe1a0 RDI: ffff81003ebf6d00
RBP: ffff81001ff81e28 R08: 0000000000000000 R09: 0000000000000011
R10: 0000003acdf67a70 R11: ffff81001ff81dd8 R12: ffff8100001fe1a0
R13: ffff81000003fcc8 R14: ffff81001ff81ef8 R15: ffff81003ebf6d00
=46S:  00007fc7e14c3800(0000) GS:ffffffff81417000(0000) knlGS:0000000000000=
000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000078 CR3: 000000000e90a000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kio_file (pid: 5163, threadinfo ffff81001ff80000, task ffff81003f22=
16a0)
Stack:  0000000000001000 0000000000000000 ffff81001ff81ef8 ffff81001ff81e38
 0000000000000002 00007fffe950b690 ffff81001ff81ee8 ffffffff810af810
 ffff81003ebf6d00 ffff8100001fe1a0 ffff81001ff81e88 ffffffff810c2c99
Call Trace:
 [<ffffffff810af810>] vfs_lstat_fd+0x40/0x5a
 [<ffffffff810c2c99>] ? mntput_no_expire+0x2a/0x134
 [<ffffffff810b34f2>] ? path_put+0x2c/0x30
 [<ffffffff810af84c>] sys_newlstat+0x22/0x3c
 [<ffffffff810134f4>] ? syscall_trace_enter+0xe8/0xfa
 [<ffffffff8100c232>] ? tracesys+0x71/0xd5
 [<ffffffff8100c291>] tracesys+0xd0/0xd5


Code: 57 49 89 ff 41 56 49 89 d6 41 55 41 54 49 89 f4 53 48 83 ec 08 4c 8b =
6e 10 e8 b0 c2 05 00 85 c0 89 c3 75 2a 49 8b 85 e8 00 00 00 <48> 8b 40 78 4=
8 85 c0 74 0f 4c 89 f2 4c 89 e6 4c 89 ff ff d0 89=20
RIP  [<ffffffff810af6ee>] vfs_getattr+0x30/0x61
 RSP <ffff81001ff81df8>
CR2: 0000000000000078
=2D--[ end trace 6eb8248fc6e8ec1b ]---

--Boundary-01=_34N2IZE+e+h8Ter--

--nextPart48891950.elvEeiUGoC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkjY3jwACgkQyPO+/nOHaTWSgwCghmxenpIYZ/1R0lPFWD2yg8H9
gU8AnRH+9v9sEsrGa+hZGe0oHVF8+vzd
=+wxv
-----END PGP SIGNATURE-----

--nextPart48891950.elvEeiUGoC--
