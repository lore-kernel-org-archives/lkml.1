Return-Path: <linux-kernel-owner+w=401wt.eu-S1753409AbYCON7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbYCON7R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 09:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbYCON7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 09:59:04 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:54808 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbYCON7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 09:59:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=a/An8m21ayAby30D0urTrWC0hcZRQq22O+LLkljzI1kNTdhZMOk9MlRfrTaj/7868LcVFwtpXnvLaahARDcg07+O1datVvAqwqqNiNsJlBC6BZmw262MsV8zcBH+/vemCfezmBTmJMqg5uKaU1ybb7SgTKbtpI3jDIEqVroGtDc=
Message-ID: <47DBD5AA.7080703@gmail.com>
Date: Sat, 15 Mar 2008 14:56:58 +0100
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.24 Kernel freeze
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I'm experiencing random kernel freezes with Kernel 2.6.24.3, also -rc3 
and -rc5 (those where the one which I've tested). I'm unable to 
reproduce this bug. It sometimes occurs and usually not. Looks like it 
is more frequent with -rc3 and rc5. With .3, which I'm using since 
26-Feb, it appeared only 2 times.

Boot-up freeze (always) on Thermal Zone setup. Complete sequence:
Dec  8 12:37:13 difrost kernel: Linux version 2.6.24-rc3 (karol@difrost) 
(gcc version 4.2.2) #6 SMP Sat Nov 24 00:12:22 CET 2007
Dec  8 12:37:13 difrost kernel: BIOS-provided physical RAM map:
Dec  8 12:37:13 difrost kernel: 118MB HIGHMEM available.
Dec  8 12:37:13 difrost kernel: 896MB LOWMEM available.
Dec  8 12:37:13 difrost kernel: found SMP MP-table at 000f5cf0
Dec  8 12:37:13 difrost kernel: DMI present.
Dec  8 12:37:13 difrost kernel: ACPI: PM-Timer IO Port: 0x1008
Dec  8 12:37:13 difrost kernel: ACPI: LAPIC (acpi_id[0x00] 
lapic_id[0x00] enabled)
Dec  8 12:37:13 difrost kernel: ACPI: LAPIC (acpi_id[0x01] 
lapic_id[0x01] enabled)
Dec  8 12:37:13 difrost kernel: ACPI: LAPIC_NMI (acpi_id[0x00] high edge 
lint[0x1])
Dec  8 12:37:13 difrost kernel: ACPI: LAPIC_NMI (acpi_id[0x01] high edge 
lint[0x1])
Dec  8 12:37:13 difrost kernel: ACPI: IOAPIC (id[0x01] 
address[0xfec00000] gsi_base[0])
Dec  8 12:37:13 difrost kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 
global_irq 2 dfl dfl)
Dec  8 12:37:13 difrost kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 
global_irq 9 high level)
Dec  8 12:37:13 difrost kernel: ACPI: HPET id: 0x8086a201 base: 0xfed00000
Dec  8 12:37:13 difrost kernel: Using ACPI (MADT) for SMP configuration 
information
Dec  8 12:37:13 difrost kernel: Kernel command line: root=/dev/sda1 
vga=771 ro
Dec  8 12:37:13 difrost kernel: Enabling fast FPU save and restore... done.
Dec  8 12:37:13 difrost kernel: Enabling unmasked SIMD FPU exception 
support... done.
Dec  8 12:37:13 difrost kernel: Initializing CPU#0
Dec  8 12:37:13 difrost kernel: console [tty0] enabled
Dec  8 12:37:13 difrost kernel: Dentry cache hash table entries: 131072 
(order: 7, 524288 bytes)
Dec  8 12:37:13 difrost kernel: Inode-cache hash table entries: 65536 
(order: 6, 262144 bytes)
Dec  8 12:37:13 difrost kernel: Memory: 1026112k/1038912k available 
(2053k kernel code, 12196k reserved, 727k data, 172k init, 121408k highme
m)
Dec  8 12:37:13 difrost kernel: SLUB: Genslabs=11, HWalign=64, 
Order=0-1, MinObjects=4, CPUs=2, Nodes=1
Dec  8 12:37:13 difrost kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Dec  8 12:37:13 difrost kernel: CPU: L2 cache: 2048K
Dec  8 12:37:13 difrost kernel: CPU: Physical Processor ID: 0
Dec  8 12:37:13 difrost kernel: CPU: Processor Core ID: 0
Dec  8 12:37:13 difrost kernel: Intel machine check architecture supported.
Dec  8 12:37:13 difrost kernel: Intel machine check reporting enabled on 
CPU#0.
Dec  8 12:37:13 difrost kernel: Checking 'hlt' instruction... OK.
Dec  8 12:37:13 difrost kernel: SMP alternatives: switching to UP code
Dec  8 12:37:13 difrost kernel: ACPI: Core revision 20070126
Dec  8 12:37:13 difrost kernel: SMP alternatives: switching to SMP code
Dec  8 12:37:13 difrost kernel: Initializing CPU#1
Dec  8 12:37:13 difrost kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Dec  8 12:37:13 difrost kernel: CPU: L2 cache: 2048K
Dec  8 12:37:13 difrost kernel: CPU: Physical Processor ID: 0
Dec  8 12:37:13 difrost kernel: CPU: Processor Core ID: 1
Dec  8 12:37:13 difrost kernel: Intel machine check architecture supported.
Dec  8 12:37:13 difrost kernel: Intel machine check reporting enabled on 
CPU#1.
Dec  8 12:37:13 difrost kernel: Total of 2 processors activated (6656.83 
BogoMIPS).
Dec  8 12:37:13 difrost kernel: ..TIMER: vector=0x31 apic1=0 pin1=2 
apic2=-1 pin2=-1
Dec  8 12:37:13 difrost kernel: checking TSC synchronization [CPU#0 -> 
CPU#1]: passed.
Dec  8 12:37:13 difrost kernel: Brought up 2 CPUs
Dec  8 12:37:13 difrost kernel: net_namespace: 64 bytes
Dec  8 12:37:13 difrost kernel: NET: Registered protocol family 16
Dec  8 12:37:13 difrost kernel: ACPI: bus type pci registered
Dec  8 12:37:13 difrost kernel: PCI: Using MMCONFIG
Dec  8 12:37:13 difrost kernel: ACPI: EC: non-query interrupt received, 
switching to interrupt mode
Dec  8 12:37:13 difrost kernel: ACPI: Interpreter enabled
Dec  8 12:37:13 difrost kernel: ACPI: (supports S0 S4 S5)
Dec  8 12:37:13 difrost kernel: ACPI: Using IOAPIC for interrupt routing
Dec  8 12:37:13 difrost kernel: ACPI: EC: GPE = 0x17, I/O: 
command/status = 0x66, data = 0x62
Dec  8 12:37:13 difrost kernel: ACPI: EC: driver started in interrupt mode
Dec  8 12:37:13 difrost kernel: ACPI: PCI Root Bridge [PCI0] (0000:00)
Dec  8 12:37:13 difrost kernel: PCI: Transparent bridge - 0000:00:1e.0
Dec  8 12:37:13 difrost kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 10 
*11)
Dec  8 12:37:13 difrost kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 10 
*11)
Dec  8 12:37:13 difrost kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 
*10 11)
Dec  8 12:37:13 difrost kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 
*10 11)
Dec  8 12:37:13 difrost kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 
*10 11)
Dec  8 12:37:13 difrost kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 
*10 11)
Dec  8 12:37:13 difrost kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 10 
*11)
Dec  8 12:37:13 difrost kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 10 
11) *5
Dec  8 12:37:13 difrost kernel: Linux Plug and Play Support v0.97 (c) 
Adam Belay
Dec  8 12:37:13 difrost kernel: pnp: PnP ACPI init
Dec  8 12:37:13 difrost kernel: ACPI: bus type pnp registered
Dec  8 12:37:13 difrost kernel: pnp: PnP ACPI: found 11 devices
Dec  8 12:37:13 difrost kernel: ACPI: ACPI bus type pnp unregistered
Dec  8 12:37:13 difrost kernel: SCSI subsystem initialized
Dec  8 12:37:13 difrost kernel: usbcore: registered new interface driver 
usbfs
Dec  8 12:37:13 difrost kernel: usbcore: registered new interface driver hub
Dec  8 12:37:13 difrost kernel: usbcore: registered new device driver usb
Dec  8 12:37:13 difrost kernel: PCI: Using ACPI for IRQ routing
Dec  8 12:37:13 difrost kernel: PCI: If a device doesn't work, try 
"pci=routeirq".  If it helps, post a report
Dec  8 12:37:13 difrost kernel: Time: tsc clocksource has been installed.
Dec  8 12:37:13 difrost kernel: system 00:01: iomem range 
0xe0000000-0xefffffff could not be reserved
Dec  8 12:37:13 difrost kernel: system 00:01: iomem range 
0xfed14000-0xfed17fff could not be reserved
Dec  8 12:37:13 difrost kernel: system 00:01: iomem range 
0xfed18000-0xfed18fff could not be reserved
Dec  8 12:37:13 difrost kernel: system 00:01: iomem range 
0xfed19000-0xfed19fff could not be reserved
Dec  8 12:37:13 difrost kernel: system 00:04: iomem range 
0xfed00000-0xfed003ff could not be reserved
Dec  8 12:37:13 difrost kernel: system 00:07: ioport range 0x6a0-0x6af 
has been reserved
Dec  8 12:37:13 difrost kernel: system 00:07: ioport range 0x6b0-0x6ff 
has been reserved
Dec  8 12:37:13 difrost kernel: PCI: Bridge: 0000:00:1c.0
Dec  8 12:37:13 difrost kernel:   IO window: 2000-2fff
Dec  8 12:37:13 difrost kernel:   MEM window: d2000000-d3ffffff
Dec  8 12:37:13 difrost kernel:   PREFETCH window: d0000000-d1ffffff
Dec  8 12:37:13 difrost kernel: PCI: Bridge: 0000:00:1c.1
Dec  8 12:37:13 difrost kernel:   IO window: disabled.
Dec  8 12:37:13 difrost kernel:   MEM window: d4000000-d40fffff
Dec  8 12:37:13 difrost kernel:   PREFETCH window: disabled.
Dec  8 12:37:13 difrost kernel: PCI: Bridge: 0000:00:1e.0
Dec  8 12:37:13 difrost kernel:   IO window: disabled.
Dec  8 12:37:13 difrost kernel:   MEM window: d4100000-d41fffff
Dec  8 12:37:13 difrost kernel:   PREFETCH window: disabled.
Dec  8 12:37:13 difrost kernel: ACPI: PCI Interrupt 0000:00:1c.0[A] -> 
GSI 17 (level, low) -> IRQ 16
Dec  8 12:37:13 difrost kernel: ACPI: PCI Interrupt 0000:00:1c.1[B] -> 
GSI 16 (level, low) -> IRQ 17
Dec  8 12:37:13 difrost kernel: ACPI: PCI Interrupt 0000:0a:06.0[A] -> 
GSI 22 (level, low) -> IRQ 18
Dec  8 12:37:13 difrost kernel: NET: Registered protocol family 2
Dec  8 12:37:13 difrost kernel: IP route cache hash table entries: 32768 
(order: 5, 131072 bytes)
Dec  8 12:37:13 difrost kernel: TCP established hash table entries: 
131072 (order: 8, 1048576 bytes)
Dec  8 12:37:13 difrost kernel: TCP bind hash table entries: 65536 
(order: 7, 524288 bytes)
Dec  8 12:37:13 difrost kernel: TCP: Hash tables configured (established 
131072 bind 65536)
Dec  8 12:37:13 difrost kernel: TCP reno registered
Dec  8 12:37:13 difrost kernel: Simple Boot Flag at 0x36 set to 0x1
Dec  8 12:37:13 difrost kernel: Machine check exception polling timer 
started.
Dec  8 12:37:13 difrost kernel: SGI XFS with no debug enabled
Dec  8 12:37:13 difrost kernel: Block layer SCSI generic (bsg) driver 
version 0.4 loaded (major 254)
Dec  8 12:37:13 difrost kernel: io scheduler noop registered
Dec  8 12:37:13 difrost kernel: io scheduler cfq registered (default)
Dec  8 12:37:13 difrost kernel: vesafb: framebuffer at 0xc0000000, 
mapped to 0xf8880000, using 975k, total 7872k
Dec  8 12:37:13 difrost kernel: vesafb: mode is 800x600x8, 
linelength=832, pages=14
Dec  8 12:37:13 difrost kernel: vesafb: scrolling: redraw
Dec  8 12:37:13 difrost kernel: vesafb: Pseudocolor: size=8:8:8:8, 
shift=0:0:0:0
Dec  8 12:37:13 difrost kernel: fb0: VESA VGA frame buffer device
Dec  8 12:37:13 difrost kernel: ACPI: AC Adapter [ADP1] (on-line)
Dec  8 12:37:13 difrost kernel: ACPI: Battery Slot [BAT0] (battery present)
Dec  8 12:37:13 difrost kernel: input: Power Button (FF) as 
/devices/virtual/input/input0
Dec  8 12:37:13 difrost kernel: ACPI: Power Button (FF) [PWRF]
Dec  8 12:37:13 difrost kernel: input: Lid Switch as 
/devices/virtual/input/input1
Dec  8 12:37:13 difrost kernel: ACPI: Lid Switch [LID0]
Dec  8 12:37:13 difrost kernel: input: Sleep Button (CM) as 
/devices/virtual/input/input2
Dec  8 12:37:13 difrost kernel: ACPI: Sleep Button (CM) [SLPB]
Dec  8 12:37:13 difrost kernel: ACPI: CPU0 (power states: C1[C1] C2[C2] 
C3[C3])
Dec  8 12:37:13 difrost kernel: ACPI: CPU1 (power states: C1[C1] C2[C2] 
C3[C3])
Dec  8 12:37:13 difrost kernel: ACPI: Thermal Zone [TZS0] (25 C)
Dec  8 12:37:13 difrost kernel: ACPI: Thermal Zone [TZS1] (30 C)

And everytime it freeze exactly in that place. I've got also one bug 
message on ACPI (looks harmless):
Dec  8 12:37:13 difrost kernel: ACPI: RSDP 000F5AE0, 0014 (r0 PTLTD )
Dec  8 12:37:13 difrost kernel: ACPI: RSDT 3F6904D3, 004C (r1 FSC    PC 
        6040000  LTP        0)
Dec  8 12:37:13 difrost kernel: ACPI: FACP 3F697CAA, 0074 (r1 INTEL 
CALISTGA  6040000 LOHR       65)
Dec  8 12:37:13 difrost kernel: ACPI: DSDT 3F691B77, 6133 (r1 WS     Y40 
       6040000 MSFT  100000E)
Dec  8 12:37:13 difrost kernel: ACPI: FACS 3F698FC0, 0040
Dec  8 12:37:13 difrost kernel: ACPI: APIC 3F697D1E, 0068 (r1 INTEL 
CALISTGA  6040000 LOHR       65)
Dec  8 12:37:13 difrost kernel: ACPI: HPET 3F697D86, 0038 (r1 INTEL 
CALISTGA  6040000 LOHR       65)
Dec  8 12:37:13 difrost kernel: ACPI: MCFG 3F697DBE, 003C (r1 INTEL 
CALISTGA  6040000 LOHR       65)
Dec  8 12:37:13 difrost kernel: ACPI: SLIC 3F697DFA, 0176 (r1 FSC    PC 
        6040000 PTL         1)
Dec  8 12:37:13 difrost kernel: ACPI: APIC 3F697F70, 0068 (r1 PTLTD  ^I 
APIC    6040000  LTP        0)
Dec  8 12:37:13 difrost kernel: ACPI: BOOT 3F697FD8, 0028 (r1 PTLTD 
$SBFTBL$  6040000  LTP        1)
Dec  8 12:37:13 difrost kernel: ACPI: SSDT 3F691528, 064F (r1 SataRe 
SataPri     1000 INTL 20050624)
Dec  8 12:37:13 difrost kernel: ACPI: SSDT 3F690E96, 0692 (r1 SataRe 
SataSec     1000 INTL 20050624)
Dec  8 12:37:13 difrost kernel: ACPI: SSDT 3F69051F, 04F6 (r1  PmRef 
CpuPm     3000 INTL 20050624)
Dec  8 12:37:13 difrost kernel: ACPI: BIOS bug: multiple APIC/MADT 
found, using 0
Dec  8 12:37:13 difrost kernel: ACPI: If "acpi_apic_instance=2" works 
better, notify linux-acpi@vger.kernel.org
Dec  8 12:37:13 difrost kernel: Processor #0 6:15 APIC version 20
Dec  8 12:37:13 difrost kernel: Processor #1 6:15 APIC version 20
Dec  8 12:37:13 difrost kernel: IOAPIC[0]: apic_id 1, version 32, 
address 0xfec00000, GSI 0-23
Dec  8 12:37:13 difrost kernel: Enabling APIC mode:  Flat.  Using 1 I/O 
APICs

Previously I was using 2.6.20.1 with which I didn't faced any freeze.
The ACPI message with 2.6.20.1 shows also ,,BIOS bug'':
Dec  8 19:38:32 difrost kernel: ACPI: 2 duplicate APIC table ignored.
Dec  8 19:38:32 difrost kernel: Processor #0 6:15 APIC version 20
Dec  8 19:38:32 difrost kernel: Processor #1 6:15 APIC version 20
Dec  8 19:38:32 difrost kernel: IOAPIC[0]: apic_id 1, version 32, 
address 0xfec00000, GSI 0-23
Dec  8 19:38:32 difrost kernel: Enabling APIC mode:  Flat.  Using 1 I/O 
APICs

How can i find whether it's a Kernel or hardware bug. With 2.6.20.1 it 
works ok, so looks like Kernel misbehavior.

Hardware:
Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
         Vendor: Phoenix Technologies LTD
         Version: R01-B0E
         Release Date: 01/08/2007
         Address: 0xE5F60
         Runtime Size: 106656 bytes
         ROM Size: 1024 kB
         Characteristics:
                 ISA is supported
                 PCI is supported
                 PC Card (PCMCIA) is supported
                 PNP is supported
                 APM is supported
                 BIOS is upgradeable
                 BIOS shadowing is allowed
                 ESCD support is available
                 Boot from CD is supported
                 ACPI is supported
                 USB legacy is supported
                 AGP is supported
                 BIOS boot specification is supported
                 Targeted content distribution is supported

Handle 0x0001, DMI type 1, 27 bytes
System Information
         Manufacturer: FUJITSU SIEMENS
         Product Name: AMILO Pro Edition V3505
         Version: 20
         Serial Number: YK3T106645
         UUID: A5712340-6840-11DB-B19B-000AE4BB0CC5
         Wake-up Type: Power Switch
         SKU Number: Not Specified
         Family: Not Specified

- Jacek
