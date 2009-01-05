Return-Path: <linux-kernel-owner+w=401wt.eu-S1753229AbZAEDyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbZAEDyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 22:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbZAEDyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 22:54:08 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:4447 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbZAEDyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 22:54:01 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=uDmze_Wz5yV7QNL7il0A:9 a=LDhjf4J1JQa4OMBF5FgA:7 a=V4r2PbaLZ6_TenJVpPVJszrbBBYA:4 a=jEp0ucaQiEUA:10
Message-ID: <4961764B.306@shaw.ca>
Date: Sun, 04 Jan 2009 19:54:03 -0700
From: David Kyle <d-kyle1@shaw.ca>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: problem with linux-2.6.28
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, i have not written concerning a kernel bug as of yet, so there is 
always a first time. my kernel version is:  sh scripts/ver_linux:

######################################################################################################################
                                                                                   

Linux davesbox 2.6.28-beta #1 PREEMPT Sun Jan 4 15:57:02 MST 2009 i686 
Intel(R) Pentium(R) 4 CPU 3.20GHz GenuineIntel GNU/Linux

Gnu C                  4.2.4
Gnu make               3.81
binutils               2.18.50.0.9.20080822
util-linux             2.14.1
mount                  support
module-init-tools      3.5
e2fsprogs              1.41.3
jfsutils               1.1.12
reiserfsprogs          3.6.20
xfsprogs               2.10.1
pcmciautils            015
quota-tools            3.13.
PPP                    2.4.4
Linux C Library        2.7
Dynamic linker (ldd)   2.7
Linux C++ Library      6.0.9
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
oprofile               0.9.2
Sh-utils               6.12
wireless-tools         29
Modules Loaded         ipv6 nvidia snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss cifs ntfs 
ide_cd_mod agpgart ppdev lp parport_pc parport hid_dell hid_pl 
hid_cypress hid_zpff hid_gyration hid_bright hid_sony hid_samsung 
hid_microsoft hid_tmff hid_monterey hid_ezkey hid_apple hid_a4tech 
hid_logitech tuner_simple tuner_types hid_cherry hid_sunplus 
hid_petalynx hid_belkin hid_chicony wm8775 usbhid hid cx25840 tuner ivtv 
compat_ioctl32 i2c_algo_bit cx2341x snd_ca0106 v4l2_common videodev 
snd_rawmidi snd_seq_device snd_ac97_codec v4l1_compat thermal tveeprom 
processor snd_pcm uhci_hcd snd_timer thermal_sys i2c_i801 ehci_hcd sky2 
i2c_core psmouse snd soundcore serio_raw ac97_bus snd_page_alloc hwmon 
button evdev
 
   
###################################################################################################################

my dmesg output is as follows:

 ####################################################################################################################

 zone: 3951 pages, LIFO batch:0
  Normal zone: 1748 pages used for memmap
  Normal zone: 221994 pages, LIFO batch:31
  HighMem zone: 4620 pages used for memmap
  HighMem zone: 586662 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
WARNING: NR_CPUS limit of 1 reached.  Processor ignored.
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
Allocating PCI resources starting at cc000000 (gap: c8000000:37b00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 812607
Kernel command line: BOOT_IMAGE=Linux-2.6.28 ro root=803
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Fast TSC calibration using PIT
Detected 3235.931 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 3243604k/3276480k available (3222k kernel code, 31608k reserved, 
1142k data, 312k init, 23
65128k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffac000 - 0xfffff000   ( 332 kB)
    pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
    vmalloc : 0xf81fe000 - 0xff9fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf79fe000   ( 889 MB)
      .init : 0xc0546000 - 0xc0594000   ( 312 kB)
      .data : 0xc0425bb8 - 0xc054355c   (1142 kB)
      .text : 0xc0100000 - 0xc0425bb8   (3222 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=12, HWalign=128, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Calibrating delay loop (skipped), value calculated using timer 
frequency.. 6471.86 BogoMIPS (lpj=3
235931)
Security Framework initialized
Mount-cache hash table entries: 512
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
using mwait in idle threads.
CPU: Intel(R) Pentium(R) 4 CPU 3.20GHz stepping 04
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20080926
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
net_namespace: 700 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: Not using MMCONFIG.
PCI: PCI BIOS revision 2.10 entry at 0xf0031, last bus=4
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG for extended config space
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0xa000-0xa01f]
pci 0000:00:1d.1: reg 20 io port: [0xa080-0xa09f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xc9dff800-0xc9dffbff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
pci 0000:00:1f.1: reg 20 io port: [0xffa0-0xffaf]
pci 0000:00:1f.2: reg 10 io port: [0xac00-0xac07]
pci 0000:00:1f.2: reg 14 io port: [0xa880-0xa883]
pci 0000:00:1f.2: reg 18 io port: [0xa800-0xa807]
pci 0000:00:1f.2: reg 1c io port: [0xa480-0xa483]
pci 0000:00:1f.2: reg 20 io port: [0xa400-0xa40f]
pci 0000:00:1f.2: reg 24 32bit mmio: [0xc9dffc00-0xc9dfffff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
pci 0000:04:00.0: reg 10 32bit mmio: [0xcb000000-0xcbffffff]
pci 0000:04:00.0: reg 14 64bit mmio: [0xd0000000-0xdfffffff]
pci 0000:04:00.0: reg 1c 64bit mmio: [0xca000000-0xcaffffff]
pci 0000:04:00.0: reg 24 io port: [0xec00-0xec7f]
pci 0000:04:00.0: reg 30 32bit mmio: [0xc9fe0000-0xc9ffffff]
pci 0000:00:01.0: bridge io port: [0xe000-0xefff]
pci 0000:00:01.0: bridge 32bit mmio: [0xc9f00000-0xcbffffff]
pci 0000:00:01.0: bridge 32bit mmio pref: [0xd0000000-0xdfffffff]
pci 0000:00:1c.0: bridge io port: [0xd000-0xdfff]
pci 0000:02:00.0: reg 10 64bit mmio: [0xc9efc000-0xc9efffff]
pci 0000:02:00.0: reg 18 io port: [0xc800-0xc8ff]
pci 0000:02:00.0: reg 30 32bit mmio: [0xc9ec0000-0xc9edffff]
pci 0000:02:00.0: supports D1 D2
pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:00:1c.1: bridge io port: [0xc000-0xcfff]
pci 0000:00:1c.1: bridge 32bit mmio: [0xc9e00000-0xc9efffff]
pci 0000:01:09.0: reg 10 io port: [0xbc00-0xbc1f]
pci 0000:01:09.0: supports D1 D2
pci 0000:01:0a.0: reg 10 32bit mmio: [0xcc000000-0xcfffffff]
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0xb000-0xbfff]
pci 0000:00:1e.0: bridge 64bit mmio pref: [0xcc000000-0xcfffffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, 
disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, 
disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 *7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, 
disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] - 6F, 
should be 67 [20080926]
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
hpet clockevent registered
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
system 00:07: ioport range 0x290-0x297 has been reserved
system 00:08: ioport range 0x4d0-0x4d1 has been reserved
system 00:08: ioport range 0x800-0x87f has been reserved
system 00:08: ioport range 0x400-0x41f has been reserved
system 00:08: ioport range 0x480-0x4bf has been reserved
system 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:08: iomem range 0xfed20000-0xfed8ffff has been reserved
system 00:08: iomem range 0xffb00000-0xffbfffff has been reserved
system 00:08: iomem range 0xfff00000-0xffffffff has been reserved
system 00:0a: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:0a: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
system 00:0d: iomem range 0x0-0x9ffff could not be reserved
system 00:0d: iomem range 0xe0000-0xfffff could not be reserved
system 00:0d: iomem range 0x100000-0xc7ffffff could not be reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:04
pci 0000:00:01.0:   IO window: 0xe000-0xefff
pci 0000:00:01.0:   MEM window: 0xc9f00000-0xcbffffff
pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.0:   IO window: 0xd000-0xdfff
pci 0000:00:1c.0:   MEM window: disabled
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.1:   IO window: 0xc000-0xcfff
pci 0000:00:1c.1:   MEM window: 0xc9e00000-0xc9efffff
pci 0000:00:1c.1:   PREFETCH window: disabled
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:01
pci 0000:00:1e.0:   IO window: 0xb000-0xbfff
pci 0000:00:1e.0:   MEM window: disabled
pci 0000:00:1e.0:   PREFETCH window: 0x000000cc000000-0x000000cfffffff
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
bus: 00 index 0 io port: [0x00-0xffff]
bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
bus: 04 index 0 io port: [0xe000-0xefff]
bus: 04 index 1 mmio: [0xc9f00000-0xcbffffff]
bus: 04 index 2 mmio: [0xd0000000-0xdfffffff]
bus: 04 index 3 mmio: [0x0-0x0]
bus: 03 index 0 io port: [0xd000-0xdfff]
bus: 03 index 1 mmio: [0x0-0x0]
bus: 03 index 2 mmio: [0x0-0x0]
bus: 03 index 3 mmio: [0x0-0x0]
bus: 02 index 0 io port: [0xc000-0xcfff]
bus: 02 index 1 mmio: [0xc9e00000-0xc9efffff]
bus: 02 index 2 mmio: [0x0-0x0]
bus: 02 index 3 mmio: [0x0-0x0]
bus: 01 index 0 io port: [0xb000-0xbfff]
bus: 01 index 1 mmio: [0x0-0x0]
bus: 01 index 2 mmio: [0xcc000000-0xcfffffff]
bus: 01 index 3 io port: [0x00-0xffff]
bus: 01 index 4 mmio: [0x000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
alg: cipher: Test 1 failed on encryption for aes-asm
00000000: 00 01 02 03 04 05 06 07 08 08 08 08 08 08 08 08
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
SGI XFS with ACLs, security attributes, large block numbers, no debug 
enabled
SGI XFS Quota Management subsystem
msgmni has been set to 1717
alg: No test for cipher_null (cipher_null-generic)
alg: No test for digest_null (digest_null-generic)
alg: No test for compress_null (compress_null-generic)
alg: No test for fcrypt (fcrypt-generic)
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:04:00.0: Boot video device
pcieport-driver 0000:00:01.0: setting latency timer to 64
pcieport-driver 0000:00:01.0: found MSI capability
pci_express 0000:00:01.0:pcie00: allocate port service
pci_express 0000:00:01.0:pcie03: allocate port service
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie02: allocate port service
pci_express 0000:00:1c.0:pcie03: allocate port service
pcieport-driver 0000:00:1c.1: setting latency timer to 64
pcieport-driver 0000:00:1c.1: found MSI capability
pci_express 0000:00:1c.1:pcie00: allocate port service
pci_express 0000:00:1c.1:pcie02: allocate port service
pci_express 0000:00:1c.1:pcie03: allocate port service
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
brd: module loaded
loop: module loaded
input: Macintosh mouse button emulation as /devices/virtual/input/input0
Uniform Multi-Platform E-IDE driver
piix 0000:00:1f.1: IDE controller (0x8086:0x266f rev 0x03)
PIIX_IDE 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
piix 0000:00:1f.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xffa0-0xffa7
    ide1: BM-DMA at 0xffa8-0xffaf
Probing IDE interface ide0...
Switched to high resolution mode on CPU 0
hda: HL-DT-ST GCE-8320B, ATAPI CD/DVD-ROM drive
hdb: HL-DT-ST DVDRAM GSA-4163B, ATAPI CD/DVD-ROM drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: MWDMA2 mode selected
hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdb: UDMA/33 mode selected
Probing IDE interface ide1...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide-gd driver 1.18
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: AHCI 0001.0000 32 slots 4 ports 1.5 Gbps 0xf impl IDE 
mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led slum part
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 irq_stat 0x00000040, connection status changed 
irq 19
ata2: SATA max UDMA/133 irq_stat 0x00400040, connection status changed 
irq 19
ata3: SATA max UDMA/133 abar m1024@0xc9dffc00 port 0xc9dffe00 irq 19
ata4: SATA max UDMA/133 irq_stat 0x00400040, connection status changed 
irq 19
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: SAMSUNG SP1614C, SW100-30, max UDMA7
ata1.00: 312581808 sectors, multi 16: LBA48
ata1.00: configured for UDMA/133
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-6: ST3120026AS, 3.18, max UDMA/133
ata2.00: 234441648 sectors, multi 16: LBA48
ata2.00: configured for UDMA/133
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ATA-7: WDC WD2500KS-00MJB0, 02.01C03, max UDMA/133
ata4.00: 488397168 sectors, multi 16: LBA48
ata4.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG SP1614C  SW10 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: Direct-Access     ATA      ST3120026AS      3.18 PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 1:0:0:0: [sdb] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
 sdb: sdb1
sd 1:0:0:0: [sdb] Attached SCSI disk
scsi 3:0:0:0: Direct-Access     ATA      WDC WD2500KS-00M 02.0 PQ: 0 ANSI: 5
sd 3:0:0:0: [sdc] 488397168 512-byte hardware sectors: (250 GB/232 GiB)
sd 3:0:0:0: [sdc] Write Protect is off
sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 3:0:0:0: [sdc] 488397168 512-byte hardware sectors: (250 GB/232 GiB)
sd 3:0:0:0: [sdc] Write Protect is off
sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
 sdc: sdc1 sdc2 sdc3
sd 3:0:0:0: [sdc] Attached SCSI disk
PNP: PS/2 Controller [PNP0f03:PS2M] at 0x60,0x64 irq 12
PNP: PS/2 controller doesn't have KBD irq; using default 1
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: 
dm-devel@redhat.com
EDAC MC: Ver: 2.1.0 Jan  4 2009
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
Using IPI Shortcut mode
ReiserFS: sda3: found reiserfs format "3.6" with standard journal
ReiserFS: sda3: using ordered data mode
ReiserFS: sda3: journal params: device sda3, size 8192, journal first 
block 18, max trans len 1024
, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda3: checking transaction log (sda3)
ReiserFS: sda3: Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem) readonly.
Freeing unused kernel memory: 312k freed
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as 
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
ACPI: Power Button (CM) [PWRB]
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:0:0: Attached scsi generic sg1 type 0
sd 3:0:0:0: Attached scsi generic sg2 type 0
sky2 driver version 1.22
sky2 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
sky2 0000:02:00.0: setting latency timer to 64
sky2 0000:02:00.0: Yukon-2 EC chip revision 1
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 128 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xc9dff800
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.28-beta ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
intel_rng: FWH not detected
sky2 0000:02:00.0: Yukon Gigabit Ethernet 10/100/1000Base-T Adapter
 Part Number: Yukon 88E8052
 Engineering Level: Rev. 1.5
 Manufacturer: Marvell
sky2 eth0: addr 00:11:2f:3f:2d:44
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ACPI: I/O resource 0000:00:1f.3 [0x400-0x41f] conflicts with ACPI region 
SMRG [0x400-0x40f]
ACPI: Device needs an ACPI driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000a000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.28-beta uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000a080
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.28-beta uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
processor ACPI_CPU:00: registered as cooling_device0
ACPI: Processor [CPU1] (supports 8 throttling states)
Linux video capture interface: v2.00
CA0106 0000:01:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
snd-ca0106: Model 100a Rev 00000000 Serial 100a1102
input: ImPS/2 Generic Wheel Mouse as 
/devices/platform/i8042/serio1/input/input3
usb 2-2: new low speed USB device using uhci_hcd and address 2
ivtv:  Start initialization, version 1.4.0
ivtv0: Initializing card #0
ivtv0: Autodetected Hauppauge card (cx23416 based)
ivtv 0000:01:0a.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
ivtv0: Unreasonably low latency timer, setting to 64 (was 32)
tveeprom 1-0050: Hauppauge model 26582, rev F0B2, serial# 9623216
tveeprom 1-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)
tveeprom 1-0050: TV standards NTSC(M) (eeprom 0x08)
tveeprom 1-0050: audio processor is CX25843 (idx 37)
tveeprom 1-0050: decoder processor is CX25843 (idx 30)
tveeprom 1-0050: has no radio
ivtv0: Autodetected Hauppauge WinTV PVR-150
usb 2-2: configuration #1 chosen from 1 choice
usb 2-2: New USB device found, idVendor=06a3, idProduct=8021
usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-2: Product: Saitek Eclipse II Keyboard
usb 2-2: Manufacturer: Chicony
usb 3-1: new full speed USB device using uhci_hcd and address 2
usbcore: registered new interface driver hiddev
cx25840 1-0044: cx25843-24 found @ 0x88 (ivtv i2c driver #0)
tuner 1-0061: chip found @ 0xc2 (ivtv i2c driver #0)
wm8775 1-001b: chip found @ 0x36 (ivtv i2c driver #0)
tuner-simple 1-0061: creating new instance
tuner-simple 1-0061: type set to 50 (TCL 2002N)
ivtv0: Registered device video0 for encoder MPG (4096 kB)
ivtv0: Registered device video32 for encoder YUV (2048 kB)
ivtv0: Registered device vbi0 for encoder VBI (1024 kB)
ivtv0: Registered device video24 for encoder PCM (320 kB)
ivtv0: Initialized card #0: Hauppauge WinTV PVR-150
ivtv:  End initialization
input: Chicony Saitek Eclipse II Keyboard as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/inp
ut/input4
generic-usb 0003:06A3:8021.0001: input,hidraw0: USB HID v1.11 Keyboard 
[Chicony Saitek Eclipse II
Keyboard] on usb-0000:00:1d.0-2/input0
usb 3-1: configuration #1 chosen from 1 choice
usb 3-1: New USB device found, idVendor=0609, idProduct=031d
usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 3-1: Product: eHome Infrared Transceiver
usb 3-1: Manufacturer: SMK
usb 3-1: SerialNumber: SM006MCV
input: Chicony Saitek Eclipse II Keyboard as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.1/inp
ut/input5
generic-usb 0003:06A3:8021.0002: input,hiddev96,hidraw1: USB HID v1.11 
Device [Chicony Saitek Ecli
pse II Keyboard] on usb-0000:00:1d.0-2/input1
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
Adding 2000084k swap on /dev/sda2.  Priority:-1 extents:1 across:2000084k
lp: driver loaded but no devices found
Linux agpgart interface v0.103
ppdev: user-space parallel port driver
ide-cd driver 5.00
ide-cd: hda: ATAPI 40X CD-ROM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
ide-cd: hdb: ATAPI 40X DVD-ROM DVD-R/RAM CD-R/RW drive, 2048kB Cache
NTFS driver 2.1.29 [Flags: R/W MODULE].
NTFS volume version 3.1.
NTFS-fs warning (device sdb1): load_system_files(): Unsupported volume 
flags 0x4000 encountered.
NTFS-fs error (device sdb1): load_system_files(): Volume has unsupported 
flags set.  Mounting read
-only.  Run chkdsk and mount in Windows.
sky2 eth0: enabling interface
sky2 eth0: Link is up at 1000 Mbps, full duplex, flow control both
ivtv 0000:01:0a.0: firmware: requesting v4l-cx2341x-enc.fw
ivtv0: Loaded v4l-cx2341x-enc.fw firmware (376836 bytes)
ivtv0: Encoder revision: 0x02060039
cx25840 1-0044: firmware: requesting v4l-cx25840.fw
cx25840 1-0044: loaded v4l-cx25840.fw firmware (16382 bytes)
nvidia: module license 'NVIDIA' taints kernel.
nvidia 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
nvidia 0000:04:00.0: setting latency timer to 64
NVRM: loading NVIDIA UNIX x86 Kernel Module  180.18  Thu Dec 18 14:29:33 
PST 2008
nvidia 0000:04:00.0: setting latency timer to 64
NVRM: loading NVIDIA UNIX x86 Kernel Module  180.18  Thu Dec 18 14:29:33 
PST 2008
nvidia 0000:04:00.0: setting latency timer to 64
NVRM: loading NVIDIA UNIX x86 Kernel Module  180.18  Thu Dec 18 14:29:33 
PST 2008
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
eth0: no IPv6 routers present
------------[ cut here ]------------
WARNING: at arch/x86/kernel/pci-nommu.c:62 nommu_map_sg+0x26/0xb0()
Modules linked in: ipv6 nvidia(P) snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_pcm_oss
 snd_mixer_oss cifs ntfs ide_cd_mod agpgart ppdev lp parport_pc parport 
hid_dell hid_pl hid_cypres
s hid_zpff hid_gyration hid_bright hid_sony hid_samsung hid_microsoft 
hid_tmff hid_monterey hid_ez
key hid_apple hid_a4tech hid_logitech tuner_simple tuner_types 
hid_cherry hid_sunplus hid_petalynx
 hid_belkin hid_chicony wm8775 usbhid hid cx25840 tuner ivtv 
compat_ioctl32 i2c_algo_bit cx2341x s
nd_ca0106 v4l2_common videodev snd_rawmidi snd_seq_device snd_ac97_codec 
v4l1_compat thermal tveep
rom processor snd_pcm uhci_hcd snd_timer thermal_sys i2c_i801 ehci_hcd 
sky2 i2c_core psmouse snd s
oundcore sg serio_raw ac97_bus snd_page_alloc hwmon button evdev [last 
unloaded: nvidia]
Pid: 0, comm: swapper Tainted: P           2.6.28-beta #1
Call Trace:
 [<c012249f>] warn_on_slowpath+0x5f/0x90
 [<c013b147>] getnstimeofday+0x37/0xe0
 [<c013ce56>] clocksource_get_next+0x56/0x60
 [<c013b530>] update_wall_time+0x2b0/0x810
 [<c0108766>] read_tsc+0x6/0x30
 [<c013b147>] getnstimeofday+0x37/0xe0
 [<c0138fe4>] hrtimer_forward+0x164/0x1b0
 [<c0108766>] read_tsc+0x6/0x30
 [<c013b147>] getnstimeofday+0x37/0xe0
 [<c0111050>] lapic_next_event+0x10/0x20
 [<c013e382>] clockevents_program_event+0xa2/0x140
 [<c013f562>] tick_dev_program_event+0x32/0xa0
 [<c013f800>] tick_sched_timer+0x0/0x1c0
 [<c0108626>] nommu_map_sg+0x26/0xb0
 [<c032d3da>] ide_build_sglist+0x4a/0x60
 [<c032d5b2>] ide_build_dmatable+0x32/0x1b0
 [<c032d87b>] ide_dma_setup+0x3b/0xf0
 [<f8ee9000>] ide_cd_do_request+0x410/0x8c0 [ide_cd_mod]
 [<c011cb87>] activate_task+0x17/0x20
 [<c011eb95>] try_to_wake_up+0x125/0x130
 [<f8ee9b60>] cdrom_do_newpc_cont+0x0/0x20 [ide_cd_mod]
 [<c0325a97>] __ide_wait_stat+0x47/0xd0
 [<c03265ff>] ide_wait_stat+0x5f/0x90
 [<c03244f0>] ide_do_request+0x3f0/0x930
 [<c03240a5>] ide_end_request+0x85/0x90
 [<f8eead04>] cdrom_newpc_intr+0x84/0x730 [ide_cd_mod]
 [<fa5c9998>] rm_isr_bh+0x77/0xa2 [nvidia]
 [<c03253a2>] ide_intr+0x252/0x270
 [<f8eeac80>] cdrom_newpc_intr+0x0/0x730 [ide_cd_mod]
 [<c014c375>] handle_IRQ_event+0x25/0x50
 [<c014e0b3>] handle_edge_irq+0xb3/0x140
 [<c0105606>] do_IRQ+0x66/0x80
 [<c0127125>] irq_exit+0x35/0x40
 [<c01117c1>] smp_apic_timer_interrupt+0x41/0x80
 [<c0103e2f>] common_interrupt+0x23/0x28
 [<c0109a0a>] mwait_idle+0x2a/0x30
 [<c0101d11>] cpu_idle+0x21/0x70
---[ end trace e8a945613a166f8c ]---
------------[ cut here ]------------
WARNING: at arch/x86/kernel/pci-nommu.c:62 nommu_map_sg+0x26/0xb0()
Modules linked in: ipv6 nvidia(P) snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_pcm_oss
 snd_mixer_oss cifs ntfs ide_cd_mod agpgart ppdev lp parport_pc parport 
hid_dell hid_pl hid_cypres
s hid_zpff hid_gyration hid_bright hid_sony hid_samsung hid_microsoft 
hid_tmff hid_monterey hid_ez
key hid_apple hid_a4tech hid_logitech tuner_simple tuner_types 
hid_cherry hid_sunplus hid_petalynx
 hid_belkin hid_chicony wm8775 usbhid hid cx25840 tuner ivtv 
compat_ioctl32 i2c_algo_bit cx2341x s
nd_ca0106 v4l2_common videodev snd_rawmidi snd_seq_device snd_ac97_codec 
v4l1_compat thermal tveep
rom processor snd_pcm uhci_hcd snd_timer thermal_sys i2c_i801 ehci_hcd 
sky2 i2c_core psmouse snd s
oundcore sg serio_raw ac97_bus snd_page_alloc hwmon button evdev [last 
unloaded: nvidia]
Pid: 0, comm: swapper Tainted: P        W  2.6.28-beta #1
Call Trace:
 [<c012249f>] warn_on_slowpath+0x5f/0x90
 [<c013b147>] getnstimeofday+0x37/0xe0
 [<c013ce56>] clocksource_get_next+0x56/0x60
 [<c013b530>] update_wall_time+0x2b0/0x810
 [<c0108766>] read_tsc+0x6/0x30
 [<c013b147>] getnstimeofday+0x37/0xe0
 [<c0138fe4>] hrtimer_forward+0x164/0x1b0
 [<c0108766>] read_tsc+0x6/0x30
 [<c013b147>] getnstimeofday+0x37/0xe0
 [<c0111050>] lapic_next_event+0x10/0x20
 [<c013e382>] clockevents_program_event+0xa2/0x140
 [<c013f562>] tick_dev_program_event+0x32/0xa0
 [<c013f800>] tick_sched_timer+0x0/0x1c0
 [<c0108626>] nommu_map_sg+0x26/0xb0
 [<c032d3da>] ide_build_sglist+0x4a/0x60
 [<c032d5b2>] ide_build_dmatable+0x32/0x1b0
 [<c012b36a>] __mod_timer+0xaa/0xc0
 [<c032d87b>] ide_dma_setup+0x3b/0xf0
 [<f8ee9000>] ide_cd_do_request+0x410/0x8c0 [ide_cd_mod]
 [<c011d771>] enqueue_task_fair+0xb1/0xd0
 [<f8ee9b60>] cdrom_do_newpc_cont+0x0/0x20 [ide_cd_mod]
 [<c0325a97>] __ide_wait_stat+0x47/0xd0
 [<c03265ff>] ide_wait_stat+0x5f/0x90
 [<c03244f0>] ide_do_request+0x3f0/0x930
 [<c029fa66>] __blk_end_request+0x36/0x50
 [<f8eeae8e>] cdrom_newpc_intr+0x20e/0x730 [ide_cd_mod]
 [<c0108766>] read_tsc+0x6/0x30
 [<c03253a2>] ide_intr+0x252/0x270
 [<f8eeac80>] cdrom_newpc_intr+0x0/0x730 [ide_cd_mod]
 [<c014c375>] handle_IRQ_event+0x25/0x50
 [<c014e0b3>] handle_edge_irq+0xb3/0x140
 [<c0105606>] do_IRQ+0x66/0x80
 [<c0127125>] irq_exit+0x35/0x40
 [<c01117c1>] smp_apic_timer_interrupt+0x41/0x80
 [<c0103e2f>] common_interrupt+0x23/0x28
 [<c0109a0a>] mwait_idle+0x2a/0x30
 [<c0101d11>] cpu_idle+0x21/0x70
---[ end trace e8a945613a166f8c ]---
NVRM: API mismatch: the client has the version 177.82, but
NVRM: this kernel module has the version 180.18.  Please
NVRM: make sure that this kernel module and all NVIDIA driver
NVRM: components have the same version.
NVRM: API mismatch: the client has the version 177.82, but
NVRM: this kernel module has the version 180.18.  Please
NVRM: make sure that this kernel module and all NVIDIA driver
NVRM: components have the same version.
NVRM: API mismatch: the client has the version 177.82, but
NVRM: this kernel module has the version 180.18.  Please
NVRM: make sure that this kernel module and all NVIDIA driver
NVRM: components have the same version.

 #######################################################################################################################

the last part (NVRM) was because i was trying to use mplayer to play a 
dvd  (mplayer -vo xvmc -vc ffmpeg12mc dvd://) which i corrected myself 
by recompiling mplayer, so that can probably be disregarded. However the 
part before it is what concerns me:
Call Trace:
 [<c012249f>] warn_on_slowpath+0x5f/0x90
 [<c013b147>] getnstimeofday+0x37/0xe0
 [<c013ce56>] clocksource_get_next+0x56/0x60
 [<c013b530>] update_wall_time+0x2b0/0x810
 [<c0108766>] read_tsc+0x6/0x30
 [<c013b147>] getnstimeofday+0x37/0xe0
 [<c0138fe4>] hrtimer_forward+0x164/0x1b0
 [<c0108766>] read_tsc+0x6/0x30
 [<c013b147>] getnstimeofday+0x37/0xe0
 [<c0111050>] lapic_next_event+0x10/0x20
 [<c013e382>] clockevents_program_event+0xa2/0x140
 [<c013f562>] tick_dev_program_event+0x32/0xa0
 [<c013f800>] tick_sched_timer+0x0/0x1c0
 [<c0108626>] nommu_map_sg+0x26/0xb0
 [<c032d3da>] ide_build_sglist+0x4a/0x60
 [<c032d5b2>] ide_build_dmatable+0x32/0x1b0
 [<c012b36a>] __mod_timer+0xaa/0xc0
 [<c032d87b>] ide_dma_setup+0x3b/0xf0
 [<f8ee9000>] ide_cd_do_request+0x410/0x8c0 [ide_cd_mod]
 [<c011d771>] enqueue_task_fair+0xb1/0xd0
 [<f8ee9b60>] cdrom_do_newpc_cont+0x0/0x20 [ide_cd_mod]
 [<c0325a97>] __ide_wait_stat+0x47/0xd0
 [<c03265ff>] ide_wait_stat+0x5f/0x90
 [<c03244f0>] ide_do_request+0x3f0/0x930
 [<c029fa66>] __blk_end_request+0x36/0x50
 [<f8eeae8e>] cdrom_newpc_intr+0x20e/0x730 [ide_cd_mod]
 [<c0108766>] read_tsc+0x6/0x30
 [<c03253a2>] ide_intr+0x252/0x270
 [<f8eeac80>] cdrom_newpc_intr+0x0/0x730 [ide_cd_mod]
 [<c014c375>] handle_IRQ_event+0x25/0x50
 [<c014e0b3>] handle_edge_irq+0xb3/0x140
 [<c0105606>] do_IRQ+0x66/0x80
 [<c0127125>] irq_exit+0x35/0x40
 [<c01117c1>] smp_apic_timer_interrupt+0x41/0x80
 [<c0103e2f>] common_interrupt+0x23/0x28
 [<c0109a0a>] mwait_idle+0x2a/0x30
 [<c0101d11>] cpu_idle+0x21/0x70
---[ end trace e8a945613a166f8c ]---

seemed to change when i rmmoded sg.ko from the kernel but i still get 
this trace. Might be because i was accessing my dvd drive, i don't know. 
Just thought i would let someone know about this as i upgraded from 
2.6.27.7 --> 2.6.28 to get away from this sort of thing. Besides this, 
the new kernel seems to run fine as far as i can see, but then again i 
have not really tested it that much but i did give 2.6.27.7 a shot. 
Anyway feel free to email me on this one with any suggestions or 
comments as i am noth on the kernel mailing lists. Besides the funny 
trace looks good so far, keep up the good work kernel developers and 
have a happy new year.
