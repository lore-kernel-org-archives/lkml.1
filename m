Return-Path: <linux-kernel-owner+w=401wt.eu-S1765443AbXHNQeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765443AbXHNQeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 12:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760630AbXHNQdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 12:33:52 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:48584 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758279AbXHNQdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 12:33:47 -0400
Date: Tue, 14 Aug 2007 18:33:23 +0200
To: Len Brown <lenb@kernel.org>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       Sergey Dolgov <solkaa@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       Len Brown <len.brown@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Henrique de Moraes Holshuh <hmh@hmh.eng.br>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Fwd: Re: 2.6.23-rc3 regression and bisection query]
Message-ID: <20070814163323.GA5355@gamma.logic.tuwien.ac.at>
References: <Pine.LNX.4.64.0708131905280.13982@blonde.wat.veritas.com> <46C0D35B.5030104@suse.de> <20070814070917.GA21301@gamma.logic.tuwien.ac.at> <200708141218.18697.lenb@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <200708141218.18697.lenb@kernel.org>
User-Agent: Mutt/1.3.28i
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Len,

On Die, 14 Aug 2007, Len Brown wrote:
> > But there is still the strange thing that
> > 	ACPI: Battery Slot [BAT1] (battery absent)
> > is present in the dmesg, while 
> > 	$ acpi
> > 	     Battery 1: charging, 46%, 00:00:49 until charged
> 
> Does the system support more than 1 battery?

At least not physically ...

> Can you show the full dmesg and the full contents of /proc/acpi/battery/*/*?

dmesg I sent already, but attached here from 
	2.6.23-rc3 + acpi-ec-fix-regression

$ ls /proc/acpi/battery/
BAT1
$ ls /proc/acpi/battery/BAT1 
alarm  info  state
$ cat /proc/acpi/battery/BAT1/alarm 
alarm:                   unsupported
$ cat /proc/acpi/battery/BAT1/info 
present:                 yes
design capacity:         2000 mAh
last full capacity:      1649 mAh
battery technology:      rechargeable
design voltage:          11100 mV
design capacity warning: 300 mAh
design capacity low:     65 mAh
capacity granularity 1:  32 mAh
capacity granularity 2:  32 mAh
model number:            ZH01
serial number:           40110
battery type:            LION
OEM info:                SANYO
$ cat /proc/acpi/battery/BAT1/state 
present:                 yes
capacity state:          ok
charging state:          charged
present rate:            0 mA
remaining capacity:      1649 mAh
present voltage:         12538 mV

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
DULEEK (n.)
Sudden realisation, as you lie in bed waiting for the alarm to go off,
that it should have gone off an hour ago.
			--- Douglas Adams, The Meaning of Liff

--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

Linux version 2.6.23-rc3 (root@mithrandir) (gcc version 4.1.3 20070812 (prerelease) (Debian 4.1.2-15)) #7 SMP PREEMPT Tue Aug 14 08:59:17 CEST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003f680000 (usable)
 BIOS-e820: 000000003f680000 - 000000003f696000 (ACPI data)
 BIOS-e820: 000000003f696000 - 000000003f700000 (ACPI NVS)
 BIOS-e820: 000000003f700000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
118MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f69f0
Entering add_active_range(0, 0, 259712) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   259712
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   259712
On node 0 totalpages: 259712
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 237 pages used for memmap
  HighMem zone: 30099 pages, LIFO batch:7
  Movable zone: 0 pages used for memmap
DMI present.
ACPI: RSDP 000F6920, 0014 (r0 PTLTD )
ACPI: RSDT 3F68CF85, 0040 (r1 PTLTD    RSDT    6040000  LTP        0)
ACPI: FACP 3F695E20, 0074 (r1 INTEL  CALISTGA  6040000 LOHR       5A)
ACPI: DSDT 3F68D941, 84DF (r1 INTEL  CALISTGA  6040000 MSFT  2000002)
ACPI: FACS 3F696FC0, 0040
ACPI: APIC 3F695E94, 0068 (r1 INTEL  CALISTGA  6040000 LOHR       5A)
ACPI: HPET 3F695EFC, 0038 (r1 INTEL  CALISTGA  6040000 LOHR       5A)
ACPI: MCFG 3F695F34, 003C (r1 INTEL  CALISTGA  6040000 LOHR       5A)
ACPI: APIC 3F695F70, 0068 (r1 PTLTD  	 APIC    6040000  LTP        0)
ACPI: BOOT 3F695FD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: SSDT 3F68CFC5, 04F6 (r1  PmRef    CpuPm     3000 INTL 20050624)
ACPI: BIOS bug: multiple APIC/MADT found, using 0
ACPI: If "acpi_apic_instance=2" works better, notify linux-acpi@vger.kernel.org
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:14 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 6:14 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000dc000
swsusp: Registered nosave memory region: 00000000000dc000 - 0000000000100000
Built 1 zonelists in Zone order.  Total pages: 257683
Kernel command line: root=/dev/sda6 ro resume=/dev/sda5
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1666.906 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1022248k/1038848k available (2325k kernel code, 15888k reserved, 1028k data, 200k init, 121344k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc044e000 - 0xc0480000   ( 200 kB)
      .data : 0xc0345426 - 0xc04464a4   (1028 kB)
      .text : 0xc0100000 - 0xc0345426   (2325 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
Calibrating delay using timer specific routine.. 3337.27 BogoMIPS (lpj=6674558)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfe9fbff 00100000 00000000 00000000 0000c1a9 00000000 00000000 00000000
monitor/mwait feature present.
using mwait in idle threads.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: After all inits, caps: bfe9fbff 00100000 00000000 00002940 0000c1a9 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
ACPI: Table DSDT replaced by host OS
ACPI: DSDT 00000000, 79B8 (r1 INTEL  CALISTGA  6040000 INTL 20060912)
ACPI: DSDT override uses original SSDTs unless "acpi_no_auto_ssdt"CPU0: Intel Genuine Intel(R) CPU           T2300  @ 1.66GHz stepping 08
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3333.62 BogoMIPS (lpj=6667256)
CPU: After generic identify, caps: bfe9fbff 00100000 00000000 00000000 0000c1a9 00000000 00000000 00000000
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfe9fbff 00100000 00000000 00002940 0000c1a9 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel Genuine Intel(R) CPU           T2300  @ 1.66GHz stepping 08
Total of 2 processors activated (6670.90 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
PM: Adding info for No Bus:platform
NET: Registered protocol family 16
PM: Adding info for No Bus:vtcon0
ACPI: bus type pci registered
PM: Adding info for No Bus:id
PCI: Using MMCONFIG
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: System BIOS is requesting _OSI(Linux)
ACPI: If "acpi_osi=Linux" works better,
Please send dmidecode to linux-acpi@vger.kernel.org
ACPI: Interpreter enabled
ACPI: (supports S0 S3)
ACPI: Using IOAPIC for interrupt routing
PM: Adding info for acpi:LNXSYSTM:00
PM: Adding info for acpi:LNXPWRBN:00
PM: Adding info for acpi:ACPI0007:00
PM: Adding info for acpi:ACPI0007:01
PM: Adding info for acpi:device:00
PM: Adding info for acpi:PNP0A08:00
PM: Adding info for acpi:PNP0C02:00
PM: Adding info for acpi:LNXVIDEO:00
PM: Adding info for acpi:device:01
PM: Adding info for acpi:device:02
PM: Adding info for acpi:device:03
PM: Adding info for acpi:device:04
PM: Adding info for acpi:device:05
PM: Adding info for acpi:device:06
PM: Adding info for acpi:device:07
PM: Adding info for acpi:device:08
PM: Adding info for acpi:device:09
PM: Adding info for acpi:device:0a
PM: Adding info for acpi:device:0b
PM: Adding info for acpi:device:0c
PM: Adding info for acpi:device:0d
PM: Adding info for acpi:device:0e
PM: Adding info for acpi:device:0f
PM: Adding info for acpi:device:10
PM: Adding info for acpi:device:11
PM: Adding info for acpi:device:12
PM: Adding info for acpi:device:13
PM: Adding info for acpi:device:14
PM: Adding info for acpi:device:15
PM: Adding info for acpi:device:16
PM: Adding info for acpi:device:17
PM: Adding info for acpi:device:18
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
PM: Adding info for acpi:PNP0C09:00
PM: Adding info for acpi:PNP0200:00
PM: Adding info for acpi:PNP0103:00
PM: Adding info for acpi:PNP0000:00
PM: Adding info for acpi:PNP0C04:00
PM: Adding info for acpi:PNP0C02:01
PM: Adding info for acpi:PNP0B00:00
PM: Adding info for acpi:PNP0100:00
PM: Adding info for acpi:PNP0A05:00
PM: Adding info for acpi:NSC6001:00
PM: Adding info for acpi:PNP0501:00
PM: Adding info for acpi:PNP0401:00
PM: Adding info for acpi:PNP0303:00
PM: Adding info for acpi:SYN1003:00
PM: Adding info for acpi:device:1c
PM: Adding info for acpi:device:1d
PM: Adding info for acpi:device:1e
PM: Adding info for acpi:device:1f
PM: Adding info for acpi:device:20
PM: Adding info for acpi:device:21
PM: Adding info for acpi:device:22
PM: Adding info for acpi:device:23
PM: Adding info for acpi:ACPI0003:00
PM: Adding info for acpi:PNP0C0A:00
PM: Adding info for acpi:PNP0C0D:00
PM: Adding info for acpi:PNP0C0C:00
PM: Adding info for acpi:PNP0C0E:00
PM: Adding info for acpi:PNP0C14:00
PM: Adding info for acpi:LNXTHERM:00
PM: Adding info for acpi:LNXTHERM:01
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: PCI Root Bridge [PCI0] (0000:00)
PM: Adding info for No Bus:pci0000:00
PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 1180-11bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
PCI: Bus #0b (-#0e) is hidden behind transparent bridge #0a (-#0b) (try 'pci=assign-busses')
Please report the result to <bk@suse.de> to fix this permanently
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
PM: Adding info for pci:0000:00:00.0
PM: Adding info for pci:0000:00:02.0
PM: Adding info for pci:0000:00:02.1
PM: Adding info for pci:0000:00:1b.0
PM: Adding info for pci:0000:00:1c.0
PM: Adding info for pci:0000:00:1c.1
PM: Adding info for pci:0000:00:1c.2
PM: Adding info for pci:0000:00:1c.3
PM: Adding info for pci:0000:00:1d.0
PM: Adding info for pci:0000:00:1d.1
PM: Adding info for pci:0000:00:1d.2
PM: Adding info for pci:0000:00:1d.3
PM: Adding info for pci:0000:00:1d.7
PM: Adding info for pci:0000:00:1e.0
PM: Adding info for pci:0000:00:1f.0
PM: Adding info for pci:0000:00:1f.2
PM: Adding info for pci:0000:00:1f.3
PM: Adding info for pci:0000:02:00.0
PM: Adding info for pci:0000:03:00.0
PM: Adding info for pci:0000:0a:09.0
PM: Adding info for pci:0000:0a:09.1
PM: Adding info for pci:0000:0a:09.2
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 14 15)
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
SCSI subsystem initialized
libata version 2.21 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI: Cannot allocate resource region 7 of bridge 0000:00:1c.0
PCI: Cannot allocate resource region 8 of bridge 0000:00:1c.0
PCI: Cannot allocate resource region 9 of bridge 0000:00:1c.0
PCI: Cannot allocate resource region 7 of bridge 0000:00:1c.1
PCI: Cannot allocate resource region 8 of bridge 0000:00:1c.1
PCI: Cannot allocate resource region 9 of bridge 0000:00:1c.1
PCI: Cannot allocate resource region 7 of bridge 0000:00:1c.2
PCI: Cannot allocate resource region 8 of bridge 0000:00:1c.2
PCI: Cannot allocate resource region 9 of bridge 0000:00:1c.2
PCI: Cannot allocate resource region 7 of bridge 0000:00:1c.3
PCI: Cannot allocate resource region 8 of bridge 0000:00:1c.3
PCI: Cannot allocate resource region 9 of bridge 0000:00:1c.3
Bluetooth: Core ver 2.11
PM: Adding info for platform:bluetooth
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
ACPI: RTC can wake from S4
Time: tsc clocksource has been installed.
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
pnp: 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
pnp: 00:01: iomem range 0xfed14000-0xfed17fff could not be reserved
pnp: 00:01: iomem range 0xfed18000-0xfed18fff could not be reserved
pnp: 00:01: iomem range 0xfed19000-0xfed19fff could not be reserved
pnp: 00:03: iomem range 0xfed00000-0xfed003ff could not be reserved
PM: Adding info for No Bus:mem
PM: Adding info for No Bus:kmem
PM: Adding info for No Bus:null
PM: Adding info for No Bus:port
PM: Adding info for No Bus:zero
PM: Adding info for No Bus:full
PM: Adding info for No Bus:random
PM: Adding info for No Bus:urandom
PM: Adding info for No Bus:kmsg
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: 54000000-540fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.1
  IO window: disabled.
  MEM window: 54100000-541fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.2
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.3
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bus 11, cardbus bridge: 0000:0a:09.0
  IO window: 00002000-000020ff
  IO window: 00002400-000024ff
  PREFETCH window: 50000000-53ffffff
  MEM window: 58000000-5bffffff
PCI: Bridge: 0000:00:1e.0
  IO window: 2000-2fff
  MEM window: b0400000-b04fffff
  PREFETCH window: 50000000-53ffffff
PCI: Enabling device 0000:00:1c.0 (0000 -> 0002)
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
PCI: Enabling device 0000:00:1c.1 (0000 -> 0002)
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.1 to 64
ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.2 to 64
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1c.3 to 64
PCI: Enabling device 0000:00:1e.0 (0004 -> 0007)
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt 0000:0a:09.0[A] -> GSI 20 (level, low) -> IRQ 20
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 7, 786432 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 2979k freed
Simple Boot Flag at 0x3e set to 0x1
Machine check exception polling timer started.
PM: Adding info for No Bus:msr0
PM: Adding info for No Bus:msr1
PM: Adding info for No Bus:cpu0
PM: Adding info for No Bus:cpu1
PM: Adding info for No Bus:microcode
PM: Adding info for platform:microcode
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
PM: Adding info for platform:pcspkr
PM: Adding info for No Bus:snapshot
highmem bounce pool size: 64 pages
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
Boot video device is 0000:00:02.0
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
PM: Adding info for pci_express:0000:00:1c.0:pcie00
Allocate Port Service[0000:00:1c.0:pcie02]
PM: Adding info for pci_express:0000:00:1c.0:pcie02
Allocate Port Service[0000:00:1c.0:pcie03]
PM: Adding info for pci_express:0000:00:1c.0:pcie03
PCI: Setting latency timer of device 0000:00:1c.1 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.1:pcie00]
PM: Adding info for pci_express:0000:00:1c.1:pcie00
Allocate Port Service[0000:00:1c.1:pcie02]
PM: Adding info for pci_express:0000:00:1c.1:pcie02
Allocate Port Service[0000:00:1c.1:pcie03]
PM: Adding info for pci_express:0000:00:1c.1:pcie03
PCI: Setting latency timer of device 0000:00:1c.2 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.2:pcie00]
PM: Adding info for pci_express:0000:00:1c.2:pcie00
Allocate Port Service[0000:00:1c.2:pcie02]
PM: Adding info for pci_express:0000:00:1c.2:pcie02
Allocate Port Service[0000:00:1c.2:pcie03]
PM: Adding info for pci_express:0000:00:1c.2:pcie03
PCI: Setting latency timer of device 0000:00:1c.3 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.3:pcie00]
PM: Adding info for pci_express:0000:00:1c.3:pcie00
Allocate Port Service[0000:00:1c.3:pcie02]
PM: Adding info for pci_express:0000:00:1c.3:pcie02
Allocate Port Service[0000:00:1c.3:pcie03]
PM: Adding info for pci_express:0000:00:1c.3:pcie03
ACPI: AC Adapter [ACAD] (on-line)
ACPI: Battery Slot [BAT1] (battery absent)
PM: Adding info for No Bus:input0
input: Power Button (FF) as /devices/virtual/input/input0
ACPI: Power Button (FF) [PWRF]
PM: Adding info for No Bus:input1
input: Lid Switch as /devices/virtual/input/input1
ACPI: Lid Switch [LID]
PM: Adding info for No Bus:input2
input: Power Button (CM) as /devices/virtual/input/input2
ACPI: Power Button (CM) [PWRB]
PM: Adding info for No Bus:input3
input: Sleep Button (CM) as /devices/virtual/input/input3
ACPI: Sleep Button (CM) [SLPB]
ACPI: SSDT 3F68D710, 01A8 (r1  PmRef  Cpu0Ist     3000 INTL 20050624)
ACPI: SSDT 3F68D4BB, 01D0 (r1  PmRef  Cpu0Cst     3001 INTL 20050624)
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 3F68D8B8, 0089 (r1  PmRef  Cpu1Ist     3000 INTL 20050624)
ACPI: SSDT 3F68D68B, 0085 (r1  PmRef  Cpu1Cst     3000 INTL 20050624)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU1] (supports 8 throttling states)
Marking TSC unstable due to: possible TSC halt in C2.
Time: hpet clocksource has been installed.
ACPI: Thermal Zone [THRM] (48 C)
PM: Adding info for No Bus:tty
PM: Adding info for No Bus:console
PM: Adding info for No Bus:ptmx
PM: Adding info for No Bus:tty0
PM: Adding info for No Bus:vcs
PM: Adding info for No Bus:vcsa
PM: Adding info for No Bus:tty1
PM: Adding info for No Bus:tty2
PM: Adding info for No Bus:tty3
PM: Adding info for No Bus:tty4
PM: Adding info for No Bus:tty5
PM: Adding info for No Bus:tty6
PM: Adding info for No Bus:tty7
PM: Adding info for No Bus:tty8
PM: Adding info for No Bus:tty9
PM: Adding info for No Bus:tty10
PM: Adding info for No Bus:tty11
PM: Adding info for No Bus:tty12
PM: Adding info for No Bus:tty13
PM: Adding info for No Bus:tty14
PM: Adding info for No Bus:tty15
PM: Adding info for No Bus:tty16
PM: Adding info for No Bus:tty17
PM: Adding info for No Bus:tty18
PM: Adding info for No Bus:tty19
PM: Adding info for No Bus:tty20
PM: Adding info for No Bus:tty21
PM: Adding info for No Bus:tty22
PM: Adding info for No Bus:tty23
PM: Adding info for No Bus:tty24
PM: Adding info for No Bus:tty25
PM: Adding info for No Bus:tty26
PM: Adding info for No Bus:tty27
PM: Adding info for No Bus:tty28
PM: Adding info for No Bus:tty29
PM: Adding info for No Bus:tty30
PM: Adding info for No Bus:tty31
PM: Adding info for No Bus:tty32
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
hpet_resources: 0xfed00000 is busy
intel_rng: FWH not detected
Linux agpgart interface v0.102
agpgart: Detected an Intel 945GM Chipset.
agpgart: Detected 7932K stolen memory.
PM: Adding info for No Bus:agpgart
agpgart: AGP aperture is 256M @ 0xc0000000
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[drm] Initialized i915 1.6.0 20060119 on minor 0
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
tg3.c:v3.80 (August 2, 2007)
PCI: Enabling device 0000:03:00.0 (0000 -> 0002)
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:03:00.0 to 64
PM: Adding info for No Bus:eth0
eth0: Tigon3 [partno(BCM95789) rev 4101 PHY(5750)] (PCI Express) 10/100/1000Base-T Ethernet 00:16:36:1e:27:ad
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth0: dma_rwctrl[76180000] dma_mask[64-bit]
PM: Adding info for No Bus:lo
ata_piix 0000:00:1f.2: version 2.11
ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
Clocksource tsc unstable (delta = -117952383 ns)
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ata_piix
PM: Adding info for No Bus:host0
scsi1 : ata_piix
PM: Adding info for No Bus:host1
ata1: SATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x000118b0 irq 14
ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x000118b8 irq 15
ata1.00: ATA-7: ST9100824AS, 3.06, max UDMA/133
ata1.00: 195371568 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
PM: Adding info for No Bus:target0:0:0
scsi 0:0:0:0: Direct-Access     ATA      ST9100824AS      3.06 PQ: 0 ANSI: 5
PM: Adding info for scsi:0:0:0:0
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
sd 0:0:0:0: [sda] Attached SCSI disk
Yenta: CardBus bridge found at 0000:0a:09.0 [1025:0098]
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:0a:09.0, mfunc 0x01321b22, devctl 0x66
Yenta: ISA IRQ mask 0x0cf8, PCI irq 20
Socket status: 30000006
Yenta: Raising subordinate bus# of parent bus (#0a) from #0b to #0e
pcmcia: parent PCI bridge I/O window: 0x2000 - 0x2fff
pcmcia: parent PCI bridge Memory window: 0xb0400000 - 0xb04fffff
pcmcia: parent PCI bridge Memory window: 0x50000000 - 0x53ffffff
PM: Adding info for No Bus:pcmcia_socket0
PM: Adding info for No Bus:usbmon0
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
PM: Adding info for No Bus:usbmon1
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 21, io mem 0xb0004000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
PM: Adding info for usb:usb1
PM: Adding info for No Bus:usbdev1.1_ep00
usb usb1: configuration #1 chosen from 1 choice
PM: Adding info for usb:1-0:1.0
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
PM: Adding info for No Bus:usbdev1.1_ep81
PM: Adding info for No Bus:usbdev1.1
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
PM: Adding info for No Bus:usbmon2
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 21, io base 0x00001820
PM: Adding info for usb:usb2
PM: Adding info for No Bus:usbdev2.1_ep00
usb usb2: configuration #1 chosen from 1 choice
PM: Adding info for usb:2-0:1.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev2.1_ep81
PM: Adding info for No Bus:usbdev2.1
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
PM: Adding info for No Bus:usbmon3
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001840
PM: Adding info for usb:usb3
PM: Adding info for No Bus:usbdev3.1_ep00
usb usb3: configuration #1 chosen from 1 choice
PM: Adding info for usb:3-0:1.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev3.1_ep81
PM: Adding info for No Bus:usbdev3.1
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
PM: Adding info for No Bus:usbmon4
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001860
PM: Adding info for usb:usb4
PM: Adding info for No Bus:usbdev4.1_ep00
usb usb4: configuration #1 chosen from 1 choice
PM: Adding info for usb:4-0:1.0
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 1-8: new high speed USB device using ehci_hcd and address 2
PM: Adding info for No Bus:usbdev4.1_ep81
PM: Adding info for No Bus:usbdev4.1
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
PM: Adding info for No Bus:usbmon5
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 16, io base 0x00001880
PM: Adding info for usb:usb5
PM: Adding info for No Bus:usbdev5.1_ep00
usb usb5: configuration #1 chosen from 1 choice
PM: Adding info for usb:5-0:1.0
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev5.1_ep81
PM: Adding info for No Bus:usbdev5.1
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
PM: Adding info for platform:i8042
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
PM: Adding info for serio:serio0
serio: i8042 AUX1 port at 0x60,0x64 irq 12
PM: Adding info for serio:serio1
serio: i8042 AUX2 port at 0x60,0x64 irq 12
PM: Adding info for serio:serio2
serio: i8042 AUX3 port at 0x60,0x64 irq 12
PM: Adding info for serio:serio3
PM: Adding info for No Bus:mice
PM: Adding info for serio:serio4
PM: Adding info for No Bus:psaux
mice: PS/2 mouse device common for all mice
PM: Adding info for No Bus:event0
PM: Adding info for No Bus:event1
PM: Adding info for No Bus:event2
PM: Adding info for No Bus:event3
PM: Adding info for No Bus:input4
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
PM: Adding info for No Bus:event4
PM: Adding info for usb:1-8
PM: Adding info for No Bus:usbdev1.2_ep00
usb 1-8: configuration #1 chosen from 1 choice
PM: Adding info for usb:1-8:1.0
PM: Adding info for No Bus:usbdev1.2_ep81
PM: Adding info for No Bus:usbdev1.2_ep82
PM: Adding info for No Bus:usbdev1.2
PM: Adding info for No Bus:rtc0
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
PM: Removing info for No Bus:rtc0
rtc_cmos: probe of 00:06 failed with error -16
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, low) -> IRQ 19
PM: Adding info for No Bus:i2c-0
Bluetooth: HCI USB driver ver 2.9
usbcore: registered new interface driver hci_usb
Advanced Linux Sound Architecture Driver Version 1.0.14 (Fri Jul 20 09:12:58 2007 UTC).
PM: Adding info for No Bus:timer
PM: Adding info for No Bus:sequencer
PM: Adding info for No Bus:sequencer2
request_module: runaway loop modprobe net-pf-1
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
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:seq
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1b.0 to 64
PM: Adding info for No Bus:card0
PM: Adding info for No Bus:pcmC0D2c
PM: Adding info for No Bus:pcmC0D0p
PM: Adding info for No Bus:pcmC0D0c
PM: Adding info for No Bus:dsp
PM: Adding info for No Bus:audio
PM: Adding info for No Bus:controlC0
PM: Adding info for No Bus:mixer
ALSA device list:
  #0: HDA Intel at 0xb0000000 irq 22
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
ieee80211_crypt: registered algorithm 'NULL'
ieee80211_crypt: registered algorithm 'WEP'
Using IPI No-Shortcut mode
swsusp: Resume From Partition /dev/sda5
PM: Checking swsusp image.
PM: Resume from disk failed.
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
Freeing unused kernel memory: 200k freed
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x81a0b1, caps: 0xa04713/0x204000
PM: Adding info for No Bus:input5
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input5
PM: Adding info for No Bus:mouse0
PM: Adding info for No Bus:event5
Attempting manual resume
swsusp: Resume From Partition 8:5
PM: Checking swsusp image.
PM: Resume from disk failed.
swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
swsusp: Basic memory bitmaps created
swsusp: Basic memory bitmaps freed
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
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
NET: Registered protocol family 23
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 0.1.8k
iwl3945: Copyright(c) 2003-2007 Intel Corporation
PCI: Enabling device 0000:02:00.0 (0000 -> 0002)
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:02:00.0 to 64
iwl3945: Detected Intel PRO/Wireless 3945ABG Network Connection
PM: Adding info for No Bus:0000:02:00.0
PM: Removing info for No Bus:0000:02:00.0
ACPI: PCI Interrupt 0000:0a:09.2[A] -> GSI 20 (level, low) -> IRQ 20
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
PM: Adding info for platform:serial8250
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
PM: Adding info for No Bus:ttyS0
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
PM: Adding info for No Bus:ttyS1
PM: Adding info for No Bus:ttyS2
PM: Adding info for No Bus:ttyS3
PM: Removing info for No Bus:ttyS0
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
PM: Adding info for No Bus:ttyS0
ACPI: PCI Interrupt 0000:0a:09.1[A] -> GSI 20 (level, low) -> IRQ 20
nsc-ircc, chip->init
nsc-ircc, Found chip at base=0x164e
nsc-ircc, driver loaded (Dag Brattli)
PM: Adding info for No Bus:irda0
IrDA: Registered device irda0
nsc-ircc, Found dongle: Supports SIR Mode only
PM: Adding info for platform:nsc-ircc.0
iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
PM: Adding info for No Bus:phy0
PM: Adding info for No Bus:wmaster0
wmaster0: Selected rate control algorithm 'iwl-3945-rs'
PM: Adding info for No Bus:wlan0
udev: renamed network interface wlan0 to wireless
firewire_ohci: Added fw-ohci device 0000:0a:09.1, OHCI version 1.10
PM: Adding info for firewire:fw0
firewire_core: created new fw device fw0 (0 config rom retries, S400)
Adding 971892k swap on /dev/sda5.  Priority:-1 extents:1 across:971892k
EXT3 FS on sda6, internal journal
PM: Adding info for platform:coretemp.0
PM: Adding info for platform:coretemp.1
fuse init (API version 7.8)
PM: Adding info for No Bus:fuse
pcmcia: Detected deprecated PCMCIA ioctl usage from process: discover.
pcmcia: This interface will soon be removed from the kernel; please expect breakage unless you upgrade to new tools.
pcmcia: see http://www.kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html for details.
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
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Removing info for No Bus:vcs2
PM: Removing info for No Bus:vcsa2
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Removing info for No Bus:vcs2
PM: Removing info for No Bus:vcsa2
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Removing info for No Bus:vcs2
PM: Removing info for No Bus:vcsa2
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Removing info for No Bus:vcs3
PM: Removing info for No Bus:vcsa3
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Removing info for No Bus:vcs3
PM: Removing info for No Bus:vcsa3
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Removing info for No Bus:vcs3
PM: Removing info for No Bus:vcsa3
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Removing info for No Bus:vcs4
PM: Removing info for No Bus:vcsa4
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Removing info for No Bus:vcs4
PM: Removing info for No Bus:vcsa4
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Removing info for No Bus:vcs4
PM: Removing info for No Bus:vcsa4
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Removing info for No Bus:vcs5
PM: Removing info for No Bus:vcsa5
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Removing info for No Bus:vcs5
PM: Removing info for No Bus:vcsa5
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Removing info for No Bus:vcs5
PM: Removing info for No Bus:vcsa5
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Removing info for No Bus:vcs6
PM: Removing info for No Bus:vcsa6
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Removing info for No Bus:vcs6
PM: Removing info for No Bus:vcsa6
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Removing info for No Bus:vcs6
PM: Removing info for No Bus:vcsa6
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
wireless: Initial auth_alg=0
wireless: authenticate with AP 00:1b:2f:50:ac:26
wireless: RX authentication from 00:1b:2f:50:ac:26 (alg=0 transaction=2 status=0)
wireless: authenticated
wireless: associate with AP 00:1b:2f:50:ac:26
wireless: RX AssocResp from 00:1b:2f:50:ac:26 (capab=0x431 status=0 aid=1)
wireless: associated
wireless: CTS protection enabled (BSSID=00:1b:2f:50:ac:26)
wireless: CTS protection disabled (BSSID=00:1b:2f:50:ac:26)
wireless: CTS protection enabled (BSSID=00:1b:2f:50:ac:26)
PM: Adding info for No Bus:vcs7
PM: Adding info for No Bus:vcsa7
PM: Removing info for No Bus:vcs7
PM: Removing info for No Bus:vcsa7
PM: Adding info for No Bus:vcs7
PM: Adding info for No Bus:vcsa7
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6

--RnlQjJ0d97Da+TV1--
