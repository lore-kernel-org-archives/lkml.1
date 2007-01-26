Return-Path: <linux-kernel-owner+w=401wt.eu-S1030690AbXAZAyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030690AbXAZAyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 19:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030692AbXAZAyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 19:54:52 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:39620 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030690AbXAZAyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 19:54:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=GkXtmkRY882PWuPWN3evu61KE4ln8yCRr+lg/70vRBk7n8+92soWNa4FAdh4OnKs81B1VQ7tKXGVMZIRQR0epcjasRrCwhVA6RhNzOy8PBBbLt8c2RrHLfnbzh/oYHyTqKJXhz8erxYQ1yYhhhaOfGGh0ridFCH77botRgG23LQ=
Message-ID: <8355959a0701251654v4aa3123cjf8ea3a1a5ccf07b7@mail.gmail.com>
Date: Fri, 26 Jan 2007 06:24:47 +0530
From: "Sunil Naidu" <akula2.shark@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.20-rc6 - clean boot on P4/HT
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/07, Sunil Naidu <akula2.shark@gmail.com> wrote:
>
> It was a cool booting, have really enjoyed this.

Here is the clean boot for me after spending for good time. Here is
the box info:-

Linux Typhoon 2.6.20-rc6-Akula-II #1 SMP Fri Jan 26 05:33:18 IST 2007
i686 i686 i386 GNU/Linux

I shall test more on different boards/arch, sleep time for now.


Linux version 2.6.20-rc6-Akula-II (root@Typhoon) (gcc version 4.1.1
20070105 (Red Hat 4.1.1-51)) #1 SMP Fri Jan 26 05:33:18 IST 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009fc00 end:
000000000009fc00 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009fc00 size: 0000000000000400 end:
00000000000a0000 type: 2
copy_e820_map() start: 00000000000e6000 size: 000000000001a000 end:
0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000001f62f800 end:
000000001f72f800 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000001f72f800 size: 0000000000000800 end:
000000001f730000 type: 4
copy_e820_map() start: 000000001f730000 size: 0000000000010000 end:
000000001f740000 type: 3
copy_e820_map() start: 000000001f740000 size: 00000000000b0000 end:
000000001f7f0000 type: 4
copy_e820_map() start: 000000001f7f0000 size: 0000000000010000 end:
000000001f800000 type: 2
copy_e820_map() start: 00000000e0000000 size: 0000000010000000 end:
00000000f0000000 type: 2
copy_e820_map() start: 00000000fed13000 size: 0000000000007000 end:
00000000fed1a000 type: 2
copy_e820_map() start: 00000000fed1c000 size: 0000000000084000 end:
00000000feda0000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001f72f800 (usable)
 BIOS-e820: 000000001f72f800 - 000000001f730000 (ACPI NVS)
 BIOS-e820: 000000001f730000 - 000000001f740000 (ACPI data)
 BIOS-e820: 000000001f740000 - 000000001f7f0000 (ACPI NVS)
 BIOS-e820: 000000001f7f0000 - 000000001f800000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fed13000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000feda0000 (reserved)
503MB LOWMEM available.
found SMP MP-table at 000ff780
Entering add_active_range(0, 0, 128815) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   128815
early_node_map[1] active PFN ranges
    0:        0 ->   128815
On node 0 totalpages: 128815
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 974 pages used for memmap
  Normal zone: 123745 pages, LIFO batch:31
DMI 2.3 present.
ACPI: RSDP (v000 ACPIAM                                ) @ 0x000f4eb0
ACPI: RSDT (v001 INTEL  D915GAV  0x20060222 MSFT 0x00000097) @ 0x1f730000
ACPI: FADT (v002 INTEL  D915GAV  0x20060222 MSFT 0x00000097) @ 0x1f730200
ACPI: MADT (v001 INTEL  D915GAV  0x20060222 MSFT 0x00000097) @ 0x1f730390
ACPI: MCFG (v001 INTEL  D915GAV  0x20060222 MSFT 0x00000097) @ 0x1f730400
ACPI: ASF! (v016 LEGEND I865PASF 0x00000001 INTL 0x02002026) @ 0x1f736050
ACPI: TCPA (v001 INTEL  TBLOEMID 0x00000001 MSFT 0x00000097) @ 0x1f7360f0
ACPI: WDDT (v001 INTEL  OEMWDDT  0x00000001 INTL 0x02002026) @ 0x1f736122
ACPI: DSDT (v001 INTEL  D915GAV  0x00000001 INTL 0x02002026) @ 0x00000000
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:4 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:4 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 20000000 (gap: 1f800000:c0800000)
Detected 3000.275 MHz processor.
Built 1 zonelists.  Total pages: 127809
Kernel command line: ro root=LABEL=/1 rhgb quiet
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c0451000 soft=c044f000
PID hash table entries: 2048 (order: 11, 8192 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 504940k/515260k available (2052k kernel code, 9788k reserved,
1048k data, 248k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb7000 - 0xfffff000   ( 288 kB)
    vmalloc : 0xe0000000 - 0xfffb5000   ( 511 MB)
    lowmem  : 0xc0000000 - 0xdf72f000   ( 503 MB)
      .init : 0xc040c000 - 0xc044a000   ( 248 kB)
      .data : 0xc0301067 - 0xc0407114   (1048 kB)
      .text : 0xc0100000 - 0xc0301067   (2052 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 6029.22 BogoMIPS (lpj=3014610)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 00100000 00000000 00000000
0000441d 00000000 00000000
monitor/mwait feature present.
using mwait in idle threads.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 00100000 00000000 00003180
0000441d 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 11k freed
ACPI: Core revision 20060707
CPU0: Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 01
Booting processor 1/1 eip 2000
CPU 1 irqstacks, hard=c0452000 soft=c0450000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5999.32 BogoMIPS (lpj=2999661)
CPU: After generic identify, caps: bfebfbff 00100000 00000000 00000000
0000441d 00000000 00000000
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 00100000 00000000 00003180
0000441d 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
CPU1: Thermal monitoring enabled
CPU1: Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 01
Total of 2 processors activated (12028.54 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization across 2 CPUs: passed.
Brought up 2 CPUs
migration_cost=392
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
Boot video device is 0000:00:02.0
PCI quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 0500-053f claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
ACPI: Power Resource [URP1] (off)
ACPI: Power Resource [FDDP] (off)
ACPI: Power Resource [LPTP] (off)
ACPI: Power Resource [URP2] (off)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 13 devices
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
pnp: 00:0b: ioport range 0x400-0x47f could not be reserved
pnp: 00:0b: ioport range 0x680-0x6ff has been reserved
pnp: 00:0b: ioport range 0x500-0x53f has been reserved
PCI: Ignore bogus resource 6 [0:0] of 0000:00:02.0
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: ffa00000-ffafffff
  PREFETCH window: cff00000-cfffffff
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: ff600000-ff6fffff
  PREFETCH window: cfb00000-cfbfffff
PCI: Bridge: 0000:00:1c.1
  IO window: disabled.
  MEM window: ff700000-ff7fffff
  PREFETCH window: cfc00000-cfcfffff
PCI: Bridge: 0000:00:1c.2
  IO window: disabled.
  MEM window: ff800000-ff8fffff
  PREFETCH window: cfd00000-cfdfffff
PCI: Bridge: 0000:00:1c.3
  IO window: disabled.
  MEM window: ff900000-ff9fffff
  PREFETCH window: cfe00000-cfefffff
PCI: Bridge: 0000:00:1e.0
  IO window: b000-bfff
  MEM window: ff500000-ff5fffff
  PREFETCH window: cfa00000-cfafffff
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.1 to 64
ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.2 to 64
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1c.3 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 6, 327680 bytes)
TCP bind hash table entries: 8192 (order: 5, 163840 bytes)
TCP: Hash tables configured (established 16384 bind 8192)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 1476k freed
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: disabled - APM is not SMP safe.
audit: initializing netlink socket (disabled)
audit(1169790606.680:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
Allocate Port Service[0000:00:01.0:pcie03]
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
PCI: Setting latency timer of device 0000:00:1c.2 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.2:pcie00]
Allocate Port Service[0000:00:1c.2:pcie02]
Allocate Port Service[0000:00:1c.2:pcie03]
PCI: Setting latency timer of device 0000:00:1c.3 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.3:pcie00]
Allocate Port Service[0000:00:1c.3:pcie02]
Allocate Port Service[0000:00:1c.3:pcie03]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: Processor [CPU2] (supports 8 throttling states)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.101 (c) Dave Jones
agpgart: Detected an Intel 915G Chipset.
agpgart: Detected 7932K stolen memory.
agpgart: AGP aperture is 256M @ 0xd0000000
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH6: IDE controller at PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
ICH6: chipset revision 3
ICH6: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
hda: HL-DT-ST DVDRAM GSA-4163B, ATAPI CD/DVD-ROM drive
hdb: HL-DT-ST GCE-8527B, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
Probing IDE interface ide1...
usbcore: registered new interface driver libusual
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 controller doesn't have AUX irq; using default 12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
Starting balanced_irq
Using IPI Shortcut mode
Freeing unused kernel memory: 248k freed
Write protecting the kernel read-only data: 799k
Time: tsc clocksource has been installed.
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 20, io base 0x0000c800
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000cc00
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000d400
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xff43bc00
usb 2-1: new low speed USB device using uhci_hcd and address 2
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
SCSI subsystem initialized
libata version 2.00 loaded.
ata_piix 0000:00:1f.2: version 2.00ac7
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.2 to 64
ata1: SATA max UDMA/133 cmd 0xE800 ctl 0xE402 bmdma 0xD800 irq 19
ata2: SATA max UDMA/133 cmd 0xE000 ctl 0xDC02 bmdma 0xD808 irq 19
scsi0 : ata_piix
ATA: abnormal status 0x7F on port 0xE807
scsi1 : ata_piix
ata2.00: ATA-6, max UDMA/133, 312581808 sectors: LBA48 NCQ (depth 0/32)
ata2.00: ata2: dev 0 multi count 16
ata2.00: configured for UDMA/133
scsi 1:0:0:0: Direct-Access     ATA      ST3160827AS      3.42 PQ: 0 ANSI: 5
SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 >
usb 2-1: new low speed USB device using uhci_hcd and address 3
 sda2: <solaris: [s0] sda10 [s1] sda11 [s2] sda12 [s3] sda13 [s4]
sda14 [s5] sda15 >
sd 1:0:0:0: Attached scsi disk sda
usb 2-1: configuration #1 chosen from 1 choice
input: Microsoft Basic Optical Mouse as /class/input/input1
input: USB HID v1.10 Mouse [Microsoft Basic Optical Mouse] on usb-0000:00:1d.1-1
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
audit(1169790611.747:2): selinux=0 auid=4294967295
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (11-Nov-2006)
iTCO_wdt: Found a ICH6 or ICH6R TCO device (Version=2, TCOBASE=0x0460)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
sd 1:0:0:0: Attached scsi generic sg0 type 0
intel_rng: Firmware space is locked read-only. If you can't or
intel_rng: don't want to disable this in firmware setup, and if
intel_rng: you are certain that your system has a functional
intel_rng: RNG, try using the 'no_fwh_detect' option.
input: PC Speaker as /class/input/input2
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, low) -> IRQ 19
fealnx.c:v2.52 Sep-11-2006
ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 21 (level, low) -> IRQ 21
eth0: 100/10M Ethernet PCI Adapter at 0001b800, 00:a1:b0:10:88:1a, IRQ 21.
hda: ATAPI 40X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
hdb: ATAPI 52X CD-ROM CD-R/RW drive, 1536kB Cache, UDMA(33)
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1b.0 to 64
floppy0: no floppy controllers found
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
lp0: using parport0 (interrupt-driven).
lp0: console ready
input: Power Button (FF) as /class/input/input3
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input4
ACPI: Power Button (CM) [PWRB]
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on sda6, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: checktime reached, running e2fsck is recommended
EXT3 FS on sda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
fuse init (API version 7.8)
Adding 1052216k swap on /dev/sda5.  Priority:-1 extents:1 across:1052216k
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
audit(1169770837.189:3): audit_pid=2009 old=0 by auid=4294967295
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[drm] Initialized i915 1.6.0 20060119 on minor 0
NETDEV WATCHDOG: eth0: transmit timed out
eth0: Transmit timed out, status 00000000, resetting...
  Rx ring dea39000:  80000000 80000000 80000000 80000000 80000000
80000000 80000000 80000000 80000000 80000000 80000000 80000000
  Tx ring dea38000:  80000000 80000000 80000000 80000000 80000000 0000



~Akula2
