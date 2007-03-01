Return-Path: <linux-kernel-owner+w=401wt.eu-S932901AbXCABoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901AbXCABoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 20:44:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932909AbXCABoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 20:44:03 -0500
Received: from [201.247.151.73] ([201.247.151.73]:20689 "EHLO
	mail.in.central.ibcinc.com.sv" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932901AbXCABn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 20:43:58 -0500
X-Greylist: delayed 1505 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Feb 2007 20:43:57 EST
From: Xavier Callejas <xavier@central.ibcinc.com.sv>
Organization: International Bonded Couriers
To: linux-smp@vger.kernel.org
Subject: System hanging randomly (SMP Kernel 2.6.20) - ATI chipset+Pentium 4HT
Date: Wed, 28 Feb 2007 19:18:01 -0600
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Jni5FETULzs5Svv"
Message-Id: <200702281918.01928.xavier@central.ibcinc.com.sv>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_Jni5FETULzs5Svv
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline


Hi,

I have a laptop Toshiba A70, I attach a DMESG so you know my system.

The problem is that the system hang randomly and I don't know why, I can se=
=20
nothing on /var/log/message realted to the hang (I have to force a shutdown=
=20
first).

With the NOAPIC option the hang just delay or dismish in frequency. Sometim=
es=20
the mouse still can move.

I can't work in my comp. like this, I have posted many messages to suse for=
um,=20
and other forums but nobody help me. I'm a primary Linux user, I'm a little=
=20
disapointed because I have not been able to find the solution since monts.

I've posted may messages to suse forums, and other forums but with no=20
solution. Here is my most recent post:

http://forums.suselinuxsupport.de/

even writing the middle of this email my laptop get hanged (I booted withou=
t=20
the noapic option).

Thank you in advance.

=2D-=20
Xavier Callejas
International Bonded Couriers
El Salvador
+503 2250-5900

=A1Toda una Organizaci=F3n Mundial a Su Servicio!

=2D-----------------------------------------------------
Open Your Mind, Use Open Source.

--Boundary-00=_Jni5FETULzs5Svv
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg.txt"

Linux version 2.6.20-245-xavier (geeko@buildhost) (gcc version 4.1.2 20061115 (prerelease) (SUSE Linux)) #1 SMP Mon Feb 26 15:00:17 CST 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009f800 end: 000000000009f800 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009f800 size: 0000000000000800 end: 00000000000a0000 type: 2
copy_e820_map() start: 00000000000d0000 size: 0000000000008000 end: 00000000000d8000 type: 2
copy_e820_map() start: 00000000000e4000 size: 000000000001c000 end: 0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000001be70000 end: 000000001bf70000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000001bf70000 size: 000000000000b000 end: 000000001bf7b000 type: 3
copy_e820_map() start: 000000001bf7b000 size: 0000000000005000 end: 000000001bf80000 type: 4
copy_e820_map() start: 000000001bf80000 size: 0000000000080000 end: 000000001c000000 type: 2
copy_e820_map() start: 000000002bf80000 size: 0000000000080000 end: 000000002c000000 type: 2
copy_e820_map() start: 00000000fec00000 size: 0000000000010000 end: 00000000fec10000 type: 2
copy_e820_map() start: 00000000fee00000 size: 0000000000001000 end: 00000000fee01000 type: 2
copy_e820_map() start: 00000000fff80000 size: 0000000000080000 end: 0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d0000 - 00000000000d8000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001bf70000 (usable)
 BIOS-e820: 000000001bf70000 - 000000001bf7b000 (ACPI data)
 BIOS-e820: 000000001bf7b000 - 000000001bf80000 (ACPI NVS)
 BIOS-e820: 000000001bf80000 - 000000001c000000 (reserved)
 BIOS-e820: 000000002bf80000 - 000000002c000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
447MB LOWMEM available.
found SMP MP-table at 000f6ae0
Entering add_active_range(0, 0, 114544) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   114544
  HighMem    114544 ->   114544
early_node_map[1] active PFN ranges
    0:        0 ->   114544
On node 0 totalpages: 114544
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 862 pages used for memmap
  Normal zone: 109586 pages, LIFO batch:31
  HighMem zone: 0 pages used for memmap
DMI present.
ACPI: RSDP (v000 PTLTD                                 ) @ 0x000f6b40
ACPI: RSDT (v001 PTLTD    RSDT   0x06040000  LTP 0x00000000) @ 0x1bf75dd2
ACPI: FADT (v001 TOSCPL Chinook  0x06040000 ATI  0x00000003) @ 0x1bf7af24
ACPI: MADT (v001 PTLTD  	 APIC   0x06040000  LTP 0x00000000) @ 0x1bf7af98
ACPI: SSDT (v001  PmRef    CpuPm 0x00003000 INTL 0x20030224) @ 0x1bf75e02
ACPI: DSDT (v001 TOSCPL    SB200 0x06040000 MSFT 0x0100000e) @ 0x00000000
ATI board detected. Disabling timer routing over 8254.
ACPI: PM-Timer IO Port: 0x8008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:4 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 15:4 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 21 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 30000000 (gap: 2c000000:d2c00000)
Detected 3066.623 MHz processor.
Built 1 zonelists.  Total pages: 113650
Kernel command line: root=/dev/hda3 vga=0x317 resume=/dev/hda2 3
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Console: colour dummy device 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 447488k/458176k available (1696k kernel code, 10140k reserved, 659k data, 180k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xdc800000 - 0xff7fe000   ( 559 MB)
    lowmem  : 0xc0000000 - 0xdbf70000   ( 447 MB)
      .init : 0xc0354000 - 0xc0381000   ( 180 kB)
      .data : 0xc02a81db - 0xc034d054   ( 659 kB)
      .text : 0xc0100000 - 0xc02a81db   (1696 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 6138.10 BogoMIPS (lpj=3069052)
Security Framework v1.0.0 initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 0000459d 00000000 00000000
monitor/mwait feature present.
using mwait in idle threads.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 00000000 00000000 00003180 0000459d 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Early unpacking initramfs... done
ACPI: Core revision 20060707
ACPI: successfully read 16816 bytes from file /DSDT.aml
ACPI: Override [DSDT-   SB200] from initramfs - tainting kernel
ACPI (tbget-0297): Table [DSDT] replaced by host OS [20060707]
CPU0: Intel Mobile Intel(R) Pentium(R) 4 CPU 3.06GHz stepping 01
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
Initializing CPU#1
Calibrating delay using timer specific routine.. 6132.68 BogoMIPS (lpj=3066343)
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 0000459d 00000000 00000000
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 00000000 00000000 00003180 0000459d 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
CPU1: Thermal monitoring enabled
CPU1: Intel Mobile Intel(R) Pentium(R) 4 CPU 3.06GHz stepping 01
Total of 2 processors activated (12270.79 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
..MP-BIOS bug: 8254 timer not connected to IO-APIC
...trying to set up timer (IRQ0) through the 8259A ...  failed.
...trying to set up timer as Virtual Wire IRQ... works.
checking TSC synchronization across 2 CPUs: passed.
Brought up 2 CPUs
migration_cost=156
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd958, last bus=2
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
Boot video device is 0000:01:05.0
PCI: Transparent bridge - 0000:00:14.4
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNK0] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNK1] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNK3] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 9 devices
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
pnp: 00:07: ioport range 0x1080-0x1080 has been reserved
pnp: 00:07: ioport range 0x220-0x22f has been reserved
pnp: 00:07: ioport range 0x40b-0x40b has been reserved
pnp: 00:07: ioport range 0x4d0-0x4d1 has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: 9000-9fff
  MEM window: e8100000-e81fffff
  PREFETCH window: f0000000-f7ffffff
PCI: Bus 3, cardbus bridge: 0000:02:04.0
  IO window: 0000a400-0000a4ff
  IO window: 0000a800-0000a8ff
  PREFETCH window: 30000000-33ffffff
  MEM window: 34000000-37ffffff
PCI: Bridge: 0000:00:14.4
  IO window: a000-afff
  MEM window: e8200000-e82fffff
  PREFETCH window: 30000000-33ffffff
ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 16 (level, low) -> IRQ 16
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 8192)
TCP reno registered
Unpacking initramfs... done
Freeing initrd memory: 3137k freed
Machine check exception polling timer started.
apm: BIOS not found.
audit: initializing netlink socket (disabled)
audit(1172687956.253:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
ACPI Error (evregion-0317): No handler for Region [ECR_] (db73abb4) [EmbeddedControl] [20060707]
ACPI Error (exfldio-0290): Region EmbeddedControl(3) has no handler [20060707]
ACPI Exception (dswexec-0458): AE_NOT_EXIST, While resolving operands for [OpcodeName unavailable] [20060707]
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.EPWR.PCLK] (Node db739c48), AE_NOT_EXIST
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPC0.EC0_._Q1E] (Node db7438ec), AE_NOT_EXIST
vesafb: framebuffer at 0xf0000000, mapped to 0xdc880000, using 6144k, total 65536k
vesafb: mode is 1024x768x16, linelength=2048, pages=41
vesafb: protected mode interface info at c000:52d0
vesafb: pmi: set display start = c00c533e, set palette = c00c5378
vesafb: pmi: ports = 9010 9016 9054 9038 903c 905c 9000 9004 90b0 90b2 90b4 
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
bootsplash 3.1.6-2004/03/31: looking for picture...<6> silentjpeg size 81749 bytes,<6>...found (1024x768, 46202 bytes, v3).
Console: switching to colour frame buffer device 124x44
fb0: VESA VGA frame buffer device
Real Time Clock Driver v1.12ac
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
ACPI: PCI Interrupt 0000:00:14.6[B] -> GSI 17 (level, low) -> IRQ 17
ACPI: PCI interrupt for device 0000:00:14.6 disabled
floppy0: no floppy controllers found
PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /class/input/input0
NET: Registered protocol family 1
Using IPI No-Shortcut mode
ACPI: (supports S0 S3 S4 S5)
Time: tsc clocksource has been installed.
Freeing unused kernel memory: 180k freed
input: PS/2 Mouse as /class/input/input1
input: AlpsPS/2 ALPS GlidePoint as /class/input/input2
input: AT Translated Set 2 keyboard as /class/input/input3
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ATIIXP: IDE controller at PCI slot 0000:00:14.1
ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
ATIIXP: chipset revision 0
ATIIXP: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x8070-0x8077, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0x8078-0x807f, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
hda: IC25N060ATMR04-0, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: max request size: 512KiB
hda: 117210240 sectors (60011 MB) w/7884KiB Cache, CHS=16383/255/63, UDMA(100)
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4 < hda5 hda6 hda7 hda8 hda9 >
Probing IDE interface ide1...
hdc: HL-DT-STCD-RW/DVD DRIVE GCC-4243N, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
ACPI (exconfig-0455): Dynamic SSDT Load - OemId [ PmRef] OemTableId [ Cpu0Ist] [20060707]
ACPI (exconfig-0455): Dynamic SSDT Load - OemId [ PmRef] OemTableId [ Cpu0Cst] [20060707]
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI (exconfig-0455): Dynamic SSDT Load - OemId [ PmRef] OemTableId [ Cpu1Ist] [20060707]
ACPI (exconfig-0455): Dynamic SSDT Load - OemId [ PmRef] OemTableId [ Cpu1Cst] [20060707]
ACPI: Processor [CPU1] (supports 8 throttling states)
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
Attempting manual resume
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
lp: driver loaded but no devices found
ACPI: PCI Interrupt 0000:00:14.6[B] -> GSI 17 (level, low) -> IRQ 17
ALSA sound/pci/atiixp_modem.c:503: atiixp-modem: codec reset timeout
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Linux agpgart interface v0.101 (c) Dave Jones
piix4_smbus 0000:00:14.0: Found 0000:00:14.0 device
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: PCI Interrupt 0000:00:14.5[B] -> GSI 17 (level, low) -> IRQ 17
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
ath_hal: module license 'Proprietary' taints kernel.
ath_hal: 0.9.18.0 (AR5210, AR5211, AR5212, RF5111, RF5112, RF2413, RF5413)
wlan: 0.8.4.2 (svn r2144)
hdc: ATAPI 24X DVD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
8139too Fast Ethernet driver 0.9.28
agpgart: Detected Ati IGP9100/M chipset
agpgart: AGP aperture is 32M @ 0xea000000
ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 19 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:13.0: irq 18, io mem 0xe8001000
ath_pci: 0.9.4.5 (svn r2144)
usb usb1: new device found, idVendor=0000, idProduct=0000
usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: OHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.20-245-xavier ohci_hcd
usb usb1: SerialNumber: 0000:00:13.0
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
ACPI: PCI Interrupt 0000:00:13.1[A] -> GSI 19 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:13.1: irq 18, io mem 0xe8002000
usb usb2: new device found, idVendor=0000, idProduct=0000
usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.20-245-xavier ohci_hcd
usb usb2: SerialNumber: 0000:00:13.1
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
ACPI: PCI Interrupt 0000:00:13.2[A] -> GSI 19 (level, low) -> IRQ 18
ehci_hcd 0000:00:13.2: EHCI Host Controller
ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 3
ehci_hcd 0000:00:13.2: irq 18, io mem 0xe8003000
ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb3: new device found, idVendor=0000, idProduct=0000
usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: EHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.20-245-xavier ehci_hcd
usb usb3: SerialNumber: 0000:00:13.2
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 6 ports detected
usb 1-1: new low speed USB device using ohci_hcd and address 2
ACPI: PCI Interrupt 0000:02:03.0[A] -> GSI 19 (level, low) -> IRQ 18
eth0: RealTek RTL8139 at 0xdd02a000, 00:0f:b0:54:f3:17, IRQ 18
eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
Yenta: CardBus bridge found at 0000:02:04.0 [1179:ff00]
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:02:04.0, mfunc 0x00111c12, devctl 0x44
Yenta: ISA IRQ mask 0x0cf8, PCI irq 16
Socket status: 30000006
pcmcia: parent PCI bridge I/O window: 0xa000 - 0xafff
pcmcia: parent PCI bridge Memory window: 0xe8200000 - 0xe82fffff
pcmcia: parent PCI bridge Memory window: 0x30000000 - 0x33ffffff
ACPI: PCI Interrupt 0000:02:02.0[A] -> GSI 18 (level, low) -> IRQ 19
ath_rate_sample: 1.2 (svn r2144)
wifi0: 11b rates: 1Mbps 2Mbps 5.5Mbps 11Mbps
wifi0: 11g rates: 1Mbps 2Mbps 5.5Mbps 11Mbps 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
wifi0: turboG rates: 6Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
wifi0: H/W encryption support: WEP AES AES_CCM TKIP
usb 1-1: new low speed USB device using ohci_hcd and address 3
wifi0: mac 5.9 phy 4.3 radio 4.6
wifi0: Use hw queue 1 for WME_AC_BE traffic
wifi0: Use hw queue 0 for WME_AC_BK traffic
wifi0: Use hw queue 2 for WME_AC_VI traffic
wifi0: Use hw queue 3 for WME_AC_VO traffic
wifi0: Use hw queue 8 for CAB traffic
wifi0: Use hw queue 9 for beacons
wifi0: Atheros 5212: mem=0xe8200000, irq=19
usb 1-1: new device found, idVendor=09da, idProduct=0006
usb 1-1: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1: Product: USB Optical Mouse
usb 1-1: Manufacturer: A4Tech
usb 1-1: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
input: A4Tech USB Optical Mouse as /class/input/input4
input: USB HID v1.10 Mouse [A4Tech USB Optical Mouse] on usb-0000:00:13.0-1
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
Adding 722916k swap on /dev/hda2.  Priority:-1 extents:1 across:722916k
Adding 208804k swap on /dev/hda9.  Priority:-2 extents:1 across:208804k
omnibook: Driver version 2.20060921-trunk.
omnibook: Toshiba Satellite A70 detected.
omnibook: Begin table match of blank feature.
omnibook: Try to init cdimode
omnibook: Fail to find a supported LPC I/O bridge, please report
omnibook: Backend compal init failed, skipping entry.
omnibook: Returning table entry nr 1.
omnibook: LCD backlight turn off at console blanking is enabled.
omnibook: Begin table match of bluetooth feature.
omnibook: Try to init ACPI backend
omnibook: ACPI EC device found
omnibook: ACPI backend init OK
omnibook: Returning table entry nr 0.
omnibook: get_wireless raw_state: 5
omnibook: Begin table match of cooling feature.
omnibook: CDI backend init already failed, skipping.
omnibook: Backend compal init failed, skipping entry.
omnibook: Match failed: disabling cooling.
omnibook: Begin table match of display feature.
omnibook: ACPI backend has already been initialized
omnibook: Returning table entry nr 0.
omnibook: Begin table match of hotkeys feature.
omnibook: CDI backend init already failed, skipping.
omnibook: Backend compal init failed, skipping entry.
omnibook: Match failed: disabling hotkeys.
omnibook: version feature has no backend table, io_op not initialized.
omnibook: dmi feature has no backend table, io_op not initialized.
omnibook: Begin table match of lcd feature.
omnibook: CDI backend init already failed, skipping.
omnibook: Backend compal init failed, skipping entry.
omnibook: Returning table entry nr 2.
omnibook: Begin table match of temperature feature.
omnibook: Returning table entry nr 0.
omnibook: Begin table match of touchpad feature.
omnibook: CDI backend init already failed, skipping.
omnibook: Backend compal init failed, skipping entry.
omnibook: Match failed: disabling touchpad.
omnibook: Begin table match of wifi feature.
omnibook: ACPI backend has already been initialized
omnibook: Returning table entry nr 0.
omnibook: get_wireless raw_state: 5
omnibook: Begin table match of throttling feature.
omnibook: ACPI backend has already been initialized
omnibook: Returning table entry nr 0.
omnibook: Enabled features: blank bluetooth display version dmi lcd temperature wifi throttling.
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
loop: loaded (max 8 devices)
NTFS driver 2.1.28 [Flags: R/W MODULE].
NTFS volume version 3.1.
ReiserFS: hda5: found reiserfs format "3.6" with standard journal
ReiserFS: hda5: using ordered data mode
reiserfs: using flush barriers
ReiserFS: hda5: journal params: device hda5, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: hda5: checking transaction log (hda5)
ReiserFS: hda5: Using r5 hash to sort names
ReiserFS: hda7: found reiserfs format "3.6" with standard journal
ReiserFS: hda7: using ordered data mode
reiserfs: using flush barriers
ReiserFS: hda7: journal params: device hda7, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: hda7: checking transaction log (hda7)
ReiserFS: hda7: Using r5 hash to sort names
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
AppArmor: AppArmor initialized
audit(1172687982.929:2): AppArmor initialized

IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
ACPI: AC Adapter [ACAD] (on-line)
ACPI: Battery Slot [BAT1] (battery present)
input: Power Button (FF) as /class/input/input5
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input6
ACPI: Lid Switch [LID]
input: Power Button (CM) as /class/input/input7
ACPI: Power Button (CM) [PWRB]
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Mobile IPv6
audit(1172709600.600:3): audit_pid=3204 old=0 by auid=4294967295
eth0: link down
ADDRCONF(NETDEV_UP): eth0: link is not ready
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:01:05.0[A] -> GSI 16 (level, low) -> IRQ 16
[drm] Initialized radeon 1.25.0 20060524 on minor 0
agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V3 device at 0000:00:00.0 into 8x mode
agpgart: Putting AGP V3 device at 0000:01:05.0 into 8x mode
[drm] Setting GART location based on old memory map
[drm] Loading R200 Microcode
[drm] writeback test succeeded in 1 usecs
NET: Registered protocol family 17
ath0: no IPv6 routers present

--Boundary-00=_Jni5FETULzs5Svv
Content-Type: text/plain;
  charset="iso-8859-1";
  name="lspci.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lspci.txt"

00:00.0 Host bridge: ATI Technologies Inc RS300 Host Bridge (rev 02)
00:01.0 PCI bridge: ATI Technologies Inc Radeon 9100 IGP AGP Bridge
00:13.0 USB Controller: ATI Technologies Inc OHCI USB Controller #1 (rev 01)
00:13.1 USB Controller: ATI Technologies Inc OHCI USB Controller #2 (rev 01)
00:13.2 USB Controller: ATI Technologies Inc EHCI USB Controller (rev 01)
00:14.0 SMBus: ATI Technologies Inc ATI SMBus (rev 18)
00:14.1 IDE interface: ATI Technologies Inc ATI Dual Channel Bus Master PCI IDE Controller
00:14.3 ISA bridge: ATI Technologies Inc Unknown device 434c
00:14.4 PCI bridge: ATI Technologies Inc Unknown device 4342
00:14.5 Multimedia audio controller: ATI Technologies Inc IXP150 AC'97 Audio Controller
00:14.6 Modem: ATI Technologies Inc IXP AC'97 Modem (rev 01)
01:05.0 VGA compatible controller: ATI Technologies Inc RS300M AGP [Radeon Mobility 9100IGP]
02:02.0 Ethernet controller: Atheros Communications, Inc. AR5212 802.11abg NIC (rev 01)
02:03.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
02:04.0 CardBus bridge: ENE Technology Inc CB1410 Cardbus Controller (rev 01)

--Boundary-00=_Jni5FETULzs5Svv
Content-Type: text/plain;
  charset="iso-8859-1";
  name="lsmod.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lsmod.txt"

Module                  Size  Used by
wlan_wep                6656  1 
af_packet              20744  4 
radeon                111008  2 
drm                    73748  3 radeon
ipv6                  246976  14 
cpufreq_conservative     7304  0 
cpufreq_ondemand        8204  2 
cpufreq_userspace       4520  0 
cpufreq_powersave       2048  0 
acpi_cpufreq            8728  0 
speedstep_lib           4868  0 
freq_table              4744  2 cpufreq_ondemand,acpi_cpufreq
snd_pcm_oss            46592  0 
snd_mixer_oss          16256  1 snd_pcm_oss
snd_seq                50672  0 
snd_seq_device          8332  1 snd_seq
button                  7952  0 
battery                 9988  0 
ac                      5252  0 
apparmor               48788  0 
aamatch_pcre           14208  1 apparmor
nls_iso8859_1           4352  1 
nls_cp437               6016  1 
vfat                   12288  1 
fat                    48796  1 vfat
reiserfs              220544  2 
nls_utf8                2304  1 
ntfs                  203668  1 
loop                   16520  0 
dm_mod                 53324  0 
omnibook               57396  0 
backlight               6016  1 omnibook
usbhid                 34144  0 
hid                    22912  1 usbhid
ff_memless              5384  1 usbhid
wlan_scan_sta          12544  1 
ath_rate_sample        12032  1 
pcmcia                 35092  0 
firmware_class          9600  1 pcmcia
ath_pci                88480  0 
yenta_socket           25100  1 
rsrc_nonstatic         10752  1 yenta_socket
8139too                25344  0 
mii                     5504  1 8139too
ide_cd                 36768  0 
cdrom                  33184  1 ide_cd
pcmcia_core            37268  3 pcmcia,yenta_socket,rsrc_nonstatic
wlan                  181956  5 wlan_wep,wlan_scan_sta,ath_rate_sample,ath_pci
shpchp                 31124  0 
ehci_hcd               29452  0 
ath_hal               191568  3 ath_rate_sample,ath_pci
ohci_hcd               18820  0 
ati_agp                 8844  1 
snd_atiixp             19468  1 
pci_hotplug            29376  1 shpchp
i2c_piix4               8460  0 
i2c_core               20736  1 i2c_piix4
agpgart                30408  2 drm,ati_agp
usbcore               107092  3 usbhid,ehci_hcd,ohci_hcd
snd_atiixp_modem       16264  1 
snd_ac97_codec         90404  2 snd_atiixp,snd_atiixp_modem
ac97_bus                2560  1 snd_ac97_codec
snd_pcm                77828  4 snd_pcm_oss,snd_atiixp,snd_atiixp_modem,snd_ac97_codec
snd_timer              22148  2 snd_seq,snd_pcm
snd                    54276  13 snd_pcm_oss,snd_mixer_oss,snd_seq,snd_seq_device,snd_atiixp,snd_atiixp_modem,snd_ac97_codec,snd_pcm,snd_timer
soundcore               7648  1 snd
snd_page_alloc         10120  3 snd_atiixp,snd_atiixp_modem,snd_pcm
parport_pc             36708  0 
lp                     11172  0 
parport                33736  2 parport_pc,lp
ext3                  128008  2 
mbcache                 8452  1 ext3
jbd                    64052  1 ext3
edd                     9284  0 
fan                     4868  0 
thermal                14088  0 
processor              30140  2 acpi_cpufreq,thermal
atiixp                  6288  0 [permanent]
ide_disk               15744  9 
ide_core              115656  3 ide_cd,atiixp,ide_disk

--Boundary-00=_Jni5FETULzs5Svv
Content-Type: text/plain;
  charset="iso-8859-1";
  name="proc_interrupts.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="proc_interrupts.txt"

           CPU0       CPU1       
  0:     259246          0  local-APIC-edge-fasteio   timer
  1:        659          0   IO-APIC-edge      i8042
  8:          2          0   IO-APIC-edge      rtc
 12:        119          0   IO-APIC-edge      i8042
 14:      22202          0   IO-APIC-edge      ide0
 15:       1961          0   IO-APIC-edge      ide1
 16:      11477          0   IO-APIC-fasteoi   yenta, radeon@pci:0000:01:05.0
 17:        479          0   IO-APIC-fasteoi   ATI IXP Modem, ATI IXP
 18:       3835          0   IO-APIC-fasteoi   ohci_hcd:usb1, ohci_hcd:usb2, ehci_hcd:usb3, eth0
 19:      12127          0   IO-APIC-fasteoi   wifi0
 21:        216          0   IO-APIC-fasteoi   acpi
NMI:          0          0 
LOC:     258806     259815 
ERR:          0
MIS:          0

--Boundary-00=_Jni5FETULzs5Svv--
