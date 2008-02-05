Return-Path: <linux-kernel-owner+w=401wt.eu-S1760126AbYBETaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760126AbYBETaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 14:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755474AbYBETaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 14:30:21 -0500
Received: from mail.chilan.com ([82.160.213.101]:40581 "EHLO mail.chilan.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755365AbYBETaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 14:30:17 -0500
From: Grzegorz Chwesewicz <ceho@chilan.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [BUG] Problem with recording on hda-intel (sata_sil or hda-intel bug) - HP nx6325
Date: Tue, 5 Feb 2008 20:29:18 +0100
User-Agent: KMail/1.9.7
Cc: chilek@chilan.com
References: <200802052015.23170.ceho@chilan.com>
In-Reply-To: <200802052015.23170.ceho@chilan.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_OkLqHgQlrF4tMfq"
Message-Id: <200802052029.18774.ceho@chilan.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_OkLqHgQlrF4tMfq
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Attached dmesg.txt. 

PS. I'm loading hda-intel with "model=hp position_fix=1 enable=1" options.

-- 
Greetings
Grzegorz Chwesewicz, Chilan 
mailto:grzegorz.chwesewicz@chilan.com

--Boundary-00=_OkLqHgQlrF4tMfq
Content-Type: text/plain;
  charset="iso-8859-2";
  name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg.txt"

Linux version 2.6.24 (root@ensima-hp) (gcc version 4.1.2 (Gentoo 4.1.2)) #8 SMP PREEMPT Tue Feb 5 13:08:16 CET 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000077fd0000 (usable)
 BIOS-e820: 0000000077fd0000 - 0000000077fe5600 (reserved)
 BIOS-e820: 0000000077fe5600 - 0000000077ff8000 (ACPI NVS)
 BIOS-e820: 0000000077ff8000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec02000 (reserved)
 BIOS-e820: 00000000ffbc0000 - 00000000ffcc0000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
1023MB HIGHMEM available.
896MB LOWMEM available.
Entering add_active_range(0, 0, 491472) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   491472
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   491472
On node 0 totalpages: 491472
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 2047 pages used for memmap
  HighMem zone: 260049 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI 2.4 present.
ACPI: RSDP 000F7A90, 0024 (r2 HP    )
ACPI: XSDT 77FE57B8, 005C (r1 HPQOEM SLIC-MPC        1 HP          1)
ACPI: FACP 77FE5684, 00F4 (r4 HP     0944            3 HP          1)
ACPI: DSDT 77FE5A60, F6D3 (r1 HP        SB400    10000 MSFT  100000E)
ACPI: FACS 77FF7E80, 0040
ACPI: SLIC 77FE5814, 0176 (r1 HPQOEM SLIC-MPC        1 HP          1)
ACPI: APIC 77FE598C, 0062 (r1 HP     0944            1 HP          1)
ACPI: MCFG 77FE59F0, 003C (r1 HP     0944            1 HP          1)
ACPI: TCPA 77FE5A2C, 0032 (r2 HP     0944            1 HP          1)
ACPI: SSDT 77FF5133, 0059 (r1 HP       HPQNLP        1 MSFT  100000E)
ACPI: SSDT 77FF518C, 01C4 (r1 HP     PSSTBLID        1 HP          1)
ACPI: DMI detected: Hewlett-Packard
ATI board detected. Disabling timer routing over 8254.
ACPI: PM-Timer IO Port: 0x8008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:8 APIC version 16
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:8 APIC version 16
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 21 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000e0000
swsusp: Registered nosave memory region: 00000000000e0000 - 0000000000100000
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 487633
Kernel command line: root=/dev/sda5 ro reboot=warm resume=/dev/sda8 video=vesafb:nomtrr:3,ywrap vga=0x341
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1795.531 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1944528k/1965888k available (2693k kernel code, 20264k reserved, 791k data, 208k init, 1048384k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4d000 - 0xfffff000   ( 712 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc046d000 - 0xc04a1000   ( 208 kB)
      .data : 0xc03a1536 - 0xc0467184   ( 791 kB)
      .text : 0xc0100000 - 0xc03a1536   (2693 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 3593.36 BogoMIPS (lpj=1796684)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 178bfbff ebd3fbff 00000000 00000000 00002001 00000000 0000001f 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0(2) -> Core 0
CPU: After all inits, caps: 178bfbff ebd3fbff 00000000 00000410 00002001 00000000 0000001f 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
CPU0: AMD Turion(tm) 64 X2 Mobile Technology TL-56 stepping 02
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3590.46 BogoMIPS (lpj=1795232)
CPU: After generic identify, caps: 178bfbff ebd3fbff 00000000 00000000 00002001 00000000 0000001f 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1(2) -> Core 1
AMD C1E detected late. 	Force timer broadcast.
CPU: After all inits, caps: 178bfbff ebd3fbff 00000000 00000410 00002001 00000000 0000001f 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: AMD Turion(tm) 64 X2 Mobile Technology TL-56 stepping 02
Total of 2 processors activated (7183.83 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
..MP-BIOS bug: 8254 timer not connected to IO-APIC
...trying to set up timer (IRQ0) through the 8259A ...  failed.
...trying to set up timer as Virtual Wire IRQ... works.
Brought up 2 CPUs
CPU0 attaching sched-domain:
 domain 0: span 03
  groups: 01 02
CPU1 attaching sched-domain:
 domain 0: span 03
  groups: 02 01
net_namespace: 64 bytes
HP Compaq Laptop series board detected. Selecting BIOS-method for reboots.
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG
PCI: No mmconfig possible on device 00:18
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: PCI Root Bridge [C079] (0000:00)
PCI: Transparent bridge - 0000:00:14.4
ACPI: PCI Interrupt Routing Table [\_SB_.C079._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C079.C07A._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C079.C0E5._PRT]
ACPI: PCI Interrupt Link [C12B] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C12C] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C12D] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C12E] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C12F] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C130] (IRQs 9) *0, disabled.
ACPI: PCI Interrupt Link [C131] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C132] (IRQs 10 11) *5
ACPI: Power Resource [C22D] (off)
ACPI: Power Resource [C204] (off)
ACPI: Power Resource [C221] (on)
ACPI: Power Resource [C360] (off)
ACPI: Power Resource [C361] (off)
ACPI: Power Resource [C362] (off)
ACPI: Power Resource [C363] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI: Cannot allocate resource region 0 of device 0000:00:14.2
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xe0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x77ffffff could not be reserved
system 00:0a: ioport range 0x40b-0x40b has been reserved
system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
system 00:0a: ioport range 0x4d6-0x4d6 has been reserved
system 00:0a: ioport range 0x500-0x51f has been reserved
system 00:0a: ioport range 0xc00-0xc01 has been reserved
system 00:0a: ioport range 0xc14-0xc14 has been reserved
system 00:0a: ioport range 0xc50-0xc51 has been reserved
system 00:0a: ioport range 0xc52-0xc52 has been reserved
system 00:0a: ioport range 0xc6c-0xc6c has been reserved
system 00:0a: ioport range 0xc6f-0xc6f has been reserved
system 00:0a: ioport range 0xcd4-0xcdf has been reserved
system 00:0a: iomem range 0xffb00000-0xffbfffff could not be reserved
system 00:0a: iomem range 0xfff00000-0xffffffff could not be reserved
system 00:0b: ioport range 0x8000-0x802f has been reserved
system 00:0b: ioport range 0x8100-0x811f has been reserved
system 00:0b: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:0b: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:0c: iomem range 0x78000000-0x7fffffff could not be reserved
system 00:0c: iomem range 0xfee00000-0xfee00fff has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: 6000-6fff
  MEM window: d4300000-d43fffff
  PREFETCH window: c0000000-c7ffffff
PCI: Bridge: 0000:00:04.0
  IO window: 4000-5fff
  MEM window: d0000000-d3ffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:05.0
  IO window: 2000-3fff
  MEM window: cc000000-cfffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:06.0
  IO window: disabled.
  MEM window: c8000000-c80fffff
  PREFETCH window: disabled.
PCI: Bus 3, cardbus bridge: 0000:02:04.0
  IO window: 00001000-000010ff
  IO window: 00001400-000014ff
  PREFETCH window: 8c000000-8fffffff
  MEM window: 90000000-93ffffff
PCI: Bridge: 0000:00:14.4
  IO window: disabled.
  MEM window: d4000000-d42fffff
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:04.0 to 64
PCI: Setting latency timer of device 0000:00:05.0 to 64
PCI: Setting latency timer of device 0000:00:06.0 to 64
ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 20 (level, low) -> IRQ 16
NET: Registered protocol family 2
Time: acpi_pm clocksource has been installed.
Clockevents: could not switch to one-shot mode:<6>Clockevents: could not switch to one-shot mode: lapic is not functional.
Could not switch to high resolution mode on CPU 1
 lapic is not functional.
Could not switch to high resolution mode on CPU 0
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 786432 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Machine check exception polling timer started.
highmem bounce pool size: 64 pages
JFS: nTxBlock = 8192, nTxLock = 65536
SGI XFS with no debug enabled
SGI XFS Quota Management subsystem
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
PCI: MSI quirk detected. MSI deactivated, because of 0000:00:00.0 device.
Boot video device is 0000:01:05.0
PCI: Setting latency timer of device 0000:00:04.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:04.0:pcie00]
PCI: Setting latency timer of device 0000:00:05.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:05.0:pcie00]
PCI: Setting latency timer of device 0000:00:06.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:06.0:pcie00]
vesafb: framebuffer at 0xc0000000, mapped to 0xf8d00000, using 5742k, total 16384k
vesafb: mode is 1400x1050x16, linelength=2800, pages=4
vesafb: protected mode interface info at c000:546f
vesafb: pmi: set display start = c00c54dd, set palette = c00c5517
vesafb: pmi: ports = 6010 6016 6054 6038 603c 605c 6000 6004 60b0 60b2 60b4 
vesafb: scrolling: ywrap using protected mode interface, yres_virtual=2100
vesafb: Truecolor: size=0:5:5:5, shift=0:10:5:0
Console: switching to colour frame buffer device 175x65
fb0: VESA VGA frame buffer device
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
tg3.c:v3.86 (November 9, 2007)
ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 23 (level, low) -> IRQ 17
eth0: Tigon3 [partno(BCM95788A50) rev 3003 PHY(5705)] (PCI:33MHz:32-bit) 10/100/1000Base-T Ethernet 00:17:08:32:44:24
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[0] TSOcap[1]
eth0: dma_rwctrl[763f0000] dma_mask[32-bit]
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ATIIXP: IDE controller (0x1002:0x4376 rev 0x80) at  PCI slot 0000:00:14.1
ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 18
ATIIXP: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x7040-0x7047, BIOS settings: hda:DMA, hdb:pio
ATIIXP: simplex device: DMA disabled
ide1: ATIIXP Bus-Master DMA disabled (BIOS)
Probing IDE interface ide0...
hda: HL-DT-ST DVDRAM GMA-4082N, ATAPI CD/DVD-ROM drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: MWDMA2 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
Probing IDE interface ide1...
Driver 'sd' needs updating - please use bus_type methods
sata_sil 0000:00:12.0: version 2.3
ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 16 (level, low) -> IRQ 18
scsi0 : sata_sil
scsi1 : sata_sil
ata1: SATA max UDMA/100 mmio m512@0xd4409000 tf 0xd4409080 irq 18
ata2: SATA max UDMA/100 mmio m512@0xd4409000 tf 0xd44090c0 irq 18
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: FUJITSU MHV2100BH, 892C, max UDMA/100
ata1.00: 195371568 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHV2100B 892C PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 > sda4
sd 0:0:0:0: [sda] Attached SCSI disk
PNP: PS/2 Controller [PNP0303:C21E,PNP0f13:C21F] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
input: AT Translated Set 2 keyboard as /class/input/input0
cpuidle: using governor menu
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Starting balanced_irq
Using IPI No-Shortcut mode
XFS mounting filesystem sda5
Ending clean XFS mount for filesystem: sda5
VFS: Mounted root (xfs filesystem) readonly.
Freeing unused kernel memory: 208k freed
tpm_inf_pnp 00:03: Found C206 with ID IFX0102
tpm_inf_pnp 00:03: TPM found: config base 0x520, data base 0x530, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
ACPI: PCI Interrupt 0000:30:00.0[A] -> GSI 18 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:30:00.0 to 64
ssb: Sonics Silicon Backplane found on PCI device 0000:30:00.0
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci: SDHCI controller found at 0000:02:04.3 [104c:803c] (rev 0)
ACPI: PCI Interrupt 0000:02:04.3[A] -> GSI 20 (level, low) -> IRQ 16
mmc0: SDHCI at 0xd4019000 irq 16 PIO
input: Power Button (FF) as /class/input/input1
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [C266]
input: Lid Switch as /class/input/input3
ACPI: Lid Switch [C267]
ACPI: Processor [C000] (supports 8 throttling states)
ACPI: Processor [C001] (supports 8 throttling states)
Linux agpgart interface v0.102
ACPI: Thermal Zone [TZ1] (71 C)
ACPI: Thermal Zone [TZ2] (63 C)
input: Video Bus as /class/input/input4
ACPI: Video Device [C07B] (multi-head: yes  rom: no  post: no)
ACPI: Thermal Zone [TZ3] (31 C)
ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level, low) -> IRQ 18
ALSA sound/pci/hda/hda_intel.c:727: codec_mask = 0x3
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ALSA sound/pci/hda/hda_codec.c:2140: hda_codec: model 'hp' is selected
Yenta: CardBus bridge found at 0000:02:04.0 [103c:30b0]
Yenta: Enabling burst memory read transactions
Yenta: Using INTVAL to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:02:04.0, mfunc 0x01a11002, devctl 0x64
ACPI: Transitioning device [C364] to D3
ACPI: Transitioning device [C364] to D3
ACPI: Fan [C364] (off)
ACPI: Fan [C365] (on)
ACPI: Fan [C366] (on)
ACPI: Fan [C367] (on)
Yenta: ISA IRQ mask 0x0ef8, PCI irq 16
Socket status: 30000006
Yenta: Raising subordinate bus# of parent bus (#02) from #03 to #06
pcmcia: parent PCI bridge Memory window: 0xd4000000 - 0xd42fffff
ACPI: PCI Interrupt 0000:00:13.2[A] -> GSI 19 (level, low) -> IRQ 20
ehci_hcd 0000:00:13.2: EHCI Host Controller
ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:13.2: irq 20, io mem 0xd4403000
ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
powernow-k8: Found 1 AMD Turion(tm) 64 X2 Mobile Technology TL-56 processors (2 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0xa (1800 MHz), vid 0x13
powernow-k8:    1 : fid 0x8 (1600 MHz), vid 0x15
powernow-k8:    2 : fid 0x0 (800 MHz), vid 0x1e
powernow-k8: ph2 null fid transition 0xa
ACPI: AC Adapter [C1C3] (on-line)
ACPI: Battery Slot [C1C5] (battery present)
ACPI: Battery Slot [C1C4] (battery absent)
hda: ATAPI 63X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
loop: module loaded
input: PC Speaker as /class/input/input5
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 19 (level, low) -> IRQ 20
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:13.0: irq 20, io mem 0xd4401000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 4 ports detected
ACPI: PCI Interrupt 0000:00:13.1[A] -> GSI 19 (level, low) -> IRQ 20
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:13.1: irq 20, io mem 0xd4402000
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x25a0b1, caps: 0xa04793/0x300000
serio: Synaptics pass-through port at isa0060/serio4/input0
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 4 ports detected
input: SynPS/2 Synaptics TouchPad as /class/input/input6
piix4_smbus 0000:00:14.0: Found 0000:00:14.0 device
XFS mounting filesystem sda2
Ending clean XFS mount for filesystem: sda2
XFS mounting filesystem sda6
usb 3-1: new full speed USB device using ohci_hcd and address 2
Ending clean XFS mount for filesystem: sda6
usb 3-1: configuration #1 chosen from 1 choice
fuse init (API version 7.9)
usb 3-4: new low speed USB device using ohci_hcd and address 3
usb 3-4: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
input: Logitech USB-PS/2 Optical Mouse as /class/input/input7
input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:13.1-4
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Adding 4173080k swap on /dev/sda8.  Priority:-1 extents:1 across:4173080k
tg3: eth0: Link is up at 100 Mbps, full duplex.
tg3: eth0: Flow control is off for TX and off for RX.

--Boundary-00=_OkLqHgQlrF4tMfq--
