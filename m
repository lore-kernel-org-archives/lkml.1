Return-Path: <linux-kernel-owner+w=401wt.eu-S1758062AbXITG0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbXITG0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 02:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbXITG0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 02:26:12 -0400
Received: from smtp1.Vir.com ([199.202.113.40]:57754 "EHLO smtp1.vir.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063AbXITG0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 02:26:10 -0400
Message-ID: <46F21280.6040400@soo.com>
Date: Thu, 20 Sep 2007 02:26:08 -0400
From: ben soo <lnx-kern@soo.com>
Reply-To: lnx-kern@soo.com
User-Agent: Thunderbird 1.5.0.9 (X11/20070111)
MIME-Version: 1.0
To: "Antonino A. Daplas" <adaplas@gmail.com>,
       Kernel Mailing list <linux-kernel@vger.kernel.org>
Subject: Re: VGA text console display problem with kernel 2.6.23-rc5/6
References: <46EF7DAD.3080502@soo.com> <1190105055.6446.2.camel@daplas>
In-Reply-To: <1190105055.6446.2.camel@daplas>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Antonino A. Daplas wrote:
> On Tue, 2007-09-18 at 03:26 -0400, ben soo wrote:
>> i've 2 servers with old PCI VGA cards, one using X86_64 kernel 
>> version 2.6.23-rc5 and one with i386 kernel version 2.6.23-rc6,
>> both wired into the same CRT via a KVM switch.
> 
> Is this new? If yes, what's the version of the last working kernel?

Hi Antonio; i'm very sorry about the delay in answering: been 
pretty ill.

i had upgraded all four servers here to 2.6.23-rc6 and found that 
only one had this console problem.  It runs a very old S3 Virge
PCI vidcard.

Tonight i upgraded it to 2.6.23-rc7 and the console is fine again, 
but, just to be complete i include the requested info:

  > Can you post dmesg and output of stty -a?

stty -a

speed 38400 baud; rows 34; columns 80; line = 0;
intr = ^C; quit = ^\; erase = ^?; kill = ^U; eof = ^D; eol = <undef>;
eol2 = <undef>; start = ^Q; stop = ^S; susp = ^Z; rprnt = ^R; 
werase = ^W;
lnext = ^V; flush = ^O; min = 1; time = 0;
-parenb -parodd cs8 hupcl -cstopb cread -clocal -crtscts
-ignbrk -brkint -ignpar -parmrk -inpck -istrip -inlcr -igncr icrnl 
ixon ixoff
-iuclc -ixany -imaxbel
opost -olcuc -ocrnl onlcr -onocr -onlret -ofill -ofdel nl0 cr0 tab0 
bs0 vt0 ff0
isig icanon -iexten echo echoe echok -echonl -noflsh -xcase -tostop 
-echoprt
echoctl echoke


-------------------------------------------------------------------

dmesg
Linux version 2.6.23-rc6sophia (mason@Sophia) (gcc version 4.2.0) 
#1 SMP Fri Sep 14 12:08:46 EDT 2007
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000007fee0000 (usable)
  BIOS-e820: 000000007fee0000 - 000000007fee3000 (ACPI NVS)
  BIOS-e820: 000000007fee3000 - 000000007fef0000 (ACPI data)
  BIOS-e820: 000000007fef0000 - 000000007ff00000 (reserved)
  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
1150MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f3ef0
Entering add_active_range(0, 0, 524000) 0 entries of 256 used
Zone PFN ranges:
   DMA             0 ->     4096
   Normal       4096 ->   229376
   HighMem    229376 ->   524000
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
     0:        0 ->   524000
On node 0 totalpages: 524000
   DMA zone: 32 pages used for memmap
   DMA zone: 0 pages reserved
   DMA zone: 4064 pages, LIFO batch:0
   Normal zone: 1760 pages used for memmap
   Normal zone: 223520 pages, LIFO batch:31
   HighMem zone: 2301 pages used for memmap
   HighMem zone: 292323 pages, LIFO batch:31
   Movable zone: 0 pages used for memmap
DMI 2.3 present.
ACPI: RSDP 000F7CF0, 0014 (r0 RD580 )
ACPI: RSDT 7FEE3040, 0038 (r1 RD580  AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 7FEE30C0, 0074 (r1 RD580  AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 7FEE3180, 4C56 (r1 RD580  AWRDACPI     1000 MSFT  100000E)
ACPI: FACS 7FEE0000, 0040
ACPI: HPET 7FEE7F00, 0038 (r1 RD580  AWRDACPI 42302E31 AWRD       98)
ACPI: WDRT 7FEE7F80, 0047 (r1 RD580  AWRDACPI 42302E31 AWRD        0)
ACPI: MCFG 7FEE8040, 003C (r1 RD580  AWRDACPI 42302E31 AWRD        0)
ACPI: APIC 7FEE7E40, 0068 (r1 RD580  AWRDACPI 42302E31 AWRD        0)
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:3 APIC version 16
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 15:3 APIC version 16
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x10b9a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 80000000 (gap: 7ff00000:60100000)
Built 1 zonelists in Zone order.  Total pages: 519907
Kernel command line: BOOT_IMAGE=2.6.23-rc6 ro root=302
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2970.093 MHz processor.
Console: colour VGA+ 80x34
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2074112k/2096000k available (2355k kernel code, 20880k 
reserved, 827k data, 184k init, 1178496k highmem)
virtual kernel memory layout:
     fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
       .init : 0xc0422000 - 0xc0450000   ( 184 kB)
       .data : 0xc034cdc0 - 0xc041bda4   ( 827 kB)
       .text : 0xc0100000 - 0xc034cdc0   (2355 kB)
Checking if this processor honours the WP bit even in supervisor 
mode... Ok.
SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
Calibrating delay using timer specific routine.. 5946.27 BogoMIPS 
(lpj=9906047)
Security Framework v1.0.0 initialized
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 178bfbff e3d3fbff 00000000 
00000000 00000001 00000000 00000003 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0(2) -> Core 0
CPU: After all inits, caps: 178bfbff e3d3fbff 00000000 00000410 
00000001 00000000 00000003 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
CPU0: AMD Dual Core AMD Opteron(tm) Processor 165    stepping 02
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5942.50 BogoMIPS 
(lpj=9900003)
CPU: After generic identify, caps: 178bfbff e3d3fbff 00000000 
00000000 00000001 00000000 00000003 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1(2) -> Core 1
CPU: After all inits, caps: 178bfbff e3d3fbff 00000000 00000410 
00000001 00000000 00000003 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: AMD Dual Core AMD Opteron(tm) Processor 165    stepping 02
Total of 2 processors activated (11888.78 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
Brought up 2 CPUs
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG
PCI: No mmconfig possible on device 00:18
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region 4000-403f claimed by ali7101 ACPI
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2PB._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 1 3 4 5 6 7 10 11 12 14 15) 
*0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs 1 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK3] (IRQs 1 *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNK5] (IRQs 1 3 4 5 6 7 10 11 12 14 15) 
*0, disabled.
ACPI: PCI Interrupt Link [LNK6] (IRQs 1 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK7] (IRQs 1 3 4 5 6 7 10 11 12 14 15) 
*0, disabled.
ACPI: PCI Interrupt Link [LNK8] (IRQs 1 3 4 5 6 7 10 11 12 14 15) *9
ACPI: PCI Interrupt Link [LNK9] (IRQs 1 3 4 5 6 *7 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, 
post a report
ACPI: RTC can wake from S4
Time: hpet clocksource has been installed.
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
pnp: 00:0b: iomem range 0xe0000000-0xefffffff could not be reserved
pnp: 00:0c: iomem range 0xf0000-0xf3fff could not be reserved
pnp: 00:0c: iomem range 0xf4000-0xf7fff could not be reserved
pnp: 00:0c: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:0c: iomem range 0xfc000-0xfffff could not be reserved
PCI: Bridge: 0000:00:1a.0
   IO window: e000-efff
   MEM window: d4000000-dbffffff
   PREFETCH window: dfe00000-dfefffff
PCI: Setting latency timer of device 0000:00:1a.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Machine check exception polling timer started.
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
PCI: MSI quirk detected. MSI deactivated.
Boot video device is 0000:01:10.0
ACPI: Invalid PBLK length [7]
ACPI: Thermal Zone [THRM] (41 C)
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Linux agpgart interface v0.102
[drm] Initialized drm 1.1.0 20060810
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, 
margin is 60 seconds).
Hangcheck: Using get_cycles().
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing 
disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
ACPI: PCI Interrupt 0000:01:12.0[A] -> GSI 19 (level, low) -> IRQ 16
eth0: RTL8110s at 0xf8820000, 00:18:e7:08:3a:7f, XID 04000000 IRQ 16
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with 
idebus=xx
ALI15X3: IDE controller at PCI slot 0000:00:1f.0
ACPI: PCI Interrupt 0000:00:1f.0[A] -> GSI 19 (level, low) -> IRQ 16
ALI15X3: chipset revision 200
ALI15X3: not 100% native mode: will probe irqs later
     ide0: BM-DMA at 0xff00-0xff07, BIOS settings: hda:DMA, hdb:pio
     ide1: BM-DMA at 0xff08-0xff0f, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
hda: Maxtor 6E040L0, ATA DISK drive
hda: selected mode 0x46
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: PIONEER DVD-RW DVR-108, ATAPI CD/DVD-ROM drive
hdc: selected mode 0x44
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 80293248 sectors (41110 MB) w/2048KiB Cache, CHS=65535/16/63, 
UDMA(133)
hda: cache flushes supported
  hda: hda1 hda2 hda3 < hda5 hda6 hda7 hda8 hda9 >
hdc: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 2000kB Cache, UDMA(66)
Uniform CD-ROM driver Revision: 3.20
ahci 0000:00:1f.1: version 2.3
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 19 (level, low) -> IRQ 16
ahci 0000:00:1f.1: AHCI 0001.0000 32 slots 4 ports 3 Gbps 0xf impl 
SATA mode
ahci 0000:00:1f.1: flags: ncq sntf ilck pm led clo pmp pio slum part
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 cmd 0xf8822100 ctl 0x00000000 bmdma 
0x00000000 irq 16
ata2: SATA max UDMA/133 cmd 0xf8822180 ctl 0x00000000 bmdma 
0x00000000 irq 16
ata3: SATA max UDMA/133 cmd 0xf8822200 ctl 0x00000000 bmdma 
0x00000000 irq 16
ata4: SATA max UDMA/133 cmd 0xf8822280 ctl 0x00000000 bmdma 
0x00000000 irq 16
ata1: SATA link down (SStatus 0 SControl 300)
ata2: SATA link down (SStatus 0 SControl 300)
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATA-7: WDC WD3200AAKS-00SBA0, 12.01B01, max UDMA/133
ata3.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata3.00: configured for UDMA/133
ata4: SATA link down (SStatus 0 SControl 300)
scsi 2:0:0:0: Direct-Access     ATA      WDC WD3200AAKS-0 12.0 PQ: 
0 ANSI: 5
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
  sda: sda1 sda2
sd 2:0:0:0: [sda] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg0 type 0
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is incorrect 
please boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
EDAC MC: Ver: 2.1.0 Sep 14 2007
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Starting balanced_irq
Using IPI No-Shortcut mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 184k freed
Adding 1048784k swap on /dev/hda8.  Priority:-1 extents:1 
across:1048784k
Adding 987956k swap on /dev/sda1.  Priority:-2 extents:1 across:987956k
EXT3 FS on hda2, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.

