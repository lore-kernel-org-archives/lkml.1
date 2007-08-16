Return-Path: <linux-kernel-owner+w=401wt.eu-S1765482AbXHPIPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765482AbXHPIPU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 04:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757912AbXHPIO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 04:14:58 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:43058 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871AbXHPIOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 04:14:51 -0400
Date: Thu, 16 Aug 2007 10:14:58 +0200
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org
Subject: sysfs_remove_bin_file: bad dentry or inode or no such file: "descriptors"
Message-ID: <20070816081458.GA24671@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This sysfs_remove_bin_file message appears sometimes on my dualcore G5.
I think only during cold boot.

...
sysfs_remove_bin_file: bad dentry or inode or no such file: "descriptors"
Call Trace:
[c0000000015eb750] [c00000000000e414] .show_stack+0x68/0x1b0 (unreliable)
[c0000000015eb7f0] [c0000000000f2428] .sysfs_remove_bin_file+0x4c/0x68
[c0000000015eb870] [c0000000002aaedc] .device_remove_bin_file+0x1c/0x30
[c0000000015eb8f0] [c00000000036cb3c] .usb_remove_sysfs_dev_files+0xa0/0xd4
[c0000000015eb990] [c000000000371cc4] .generic_disconnect+0x40/0x58
[c0000000015eba10] [c000000000368960] .usb_unbind_device+0x30/0x48
[c0000000015eba90] [c0000000002ae88c] .__device_release_driver+0xc4/0x104
[c0000000015ebb20] [c0000000002aeefc] .device_release_driver+0x50/0x94
[c0000000015ebbb0] [c0000000002adea8] .bus_remove_device+0x9c/0xdc
[c0000000015ebc40] [c0000000002ab33c] .device_del+0x2c0/0x3b4
[c0000000015ebce0] [c0000000003611d4] .usb_disconnect+0x11c/0x1f4
[c0000000015ebd90] [c000000000361c38] .hub_thread+0x4dc/0xe10
[c0000000015ebf00] [c00000000005a1ec] .kthread+0x78/0xc4
[c0000000015ebf90] [c00000000001f390] .kernel_thread+0x4c/0x68
...

DART table allocated at: c00000007f000000
Using PowerMac machine description
Page orders: linear mapping = 24, virtual = 12, io = 12
Found initrd at 0xc000000001300000:0xc000000001559c00
Found U4 memory controller & host bridge @ 0xf8000000 revision: 0x42
Mapped at 0xd000080080000000
Found a Shasta mac-io controller, rev: 0, mapped at 0xd000080080041000
PowerMac motherboard: PowerMac G5 Dual Core
DART IOMMU initialized for U4 type chipset
console [udbg0] enabled
Starting Linux PPC64 #194 SMP Wed Aug 15 21:45:05 CEST 2007
-----------------------------------------------------
ppc64_pft_size                = 0x0
physicalMemorySize            = 0x80000000
ppc64_caches.dcache_line_size = 0x80
ppc64_caches.icache_line_size = 0x80
htab_address                  = 0xc00000007c000000
htab_hash_mask                = 0x3ffff
-----------------------------------------------------
Linux version 2.6.23-rc3-g5-g28e8351a (olaf@g5) (gcc version 4.1.0 (SUSE Linux)) #194 SMP Wed Aug 15 21:45:05 CEST 2007
[boot]0012 Setup Arch
Entering add_active_range(0, 0, 524288) 0 entries of 256 used
Found U4-PCIE PCI host bridge.  Firmware bus number: 0->255
Can't get bus-range for /ht@0,f2000000, assume bus 0
Found U3-HT PCI host bridge.  Firmware bus number: 0->-1
SMU driver 0.7 (c) 2005 Benjamin Herrenschmidt, IBM Corp.
nvram: Checking bank 0...
nvram: gen0=206, gen1=205
nvram: Active bank is: 0
nvram: OF partition at 0x410
nvram: XP partition at 0x1020
nvram: NR partition at 0x1120
Top of RAM: 0x80000000, Total RAM: 0x80000000
Memory hole size: 0MB
Zone PFN ranges:
  DMA             0 ->   524288
  Normal     524288 ->   524288
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   524288
On node 0 totalpages: 524288
  DMA zone: 7168 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 517120 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
[boot]0015 Setup Done
Built 1 zonelists in Zone order.  Total pages: 517120
Kernel command line: root=UUID=a77c3a2a-dd4a-4cf6-8c74-287c49897b10 sysrq=1 quiet video=nvidiafb:1024x768@85,bpp:16 panic=12 
mpic: Setting up MPIC " MPIC 1   " version 1.2 at f8040000, max 4 CPUs
mpic: ISU size: 124, shift: 7, mask: 7f
mpic: Initializing for 124 sources
mpic: Setting up HT PICs workarounds for U3/U4
mpic:   - HT:07.0 [0x90] vendor 106b device 0053 has 86 irqs
PID hash table entries: 4096 (order: 12, 32768 bytes)
time_init: decrementer frequency = 33.333333 MHz
time_init: processor frequency   = 2300.000000 MHz
Console: colour dummy device 80x25
console handover: boot [udbg0] -> real [tty0]
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Memory: 2005496k/2097152k available (5816k kernel code, 91028k reserved, 920k data, 498k bss, 204k init)
Calibrating delay loop... 66.56 BogoMIPS (lpj=332800)
Mount-cache hash table entries: 256
device-tree: Duplicate name in /ht@0,f2000000/pci@8/mac-io@7/i2c@18000, renamed to "i2c-bus@0#1"
PowerMac SMP probe found 2 cpus
KeyWest i2c @0xf8001003 irq 16 /u4@0,f8000000/i2c@f8001000
 channel 1 bus /u4@0,f8000000/i2c@f8001000/i2c-bus@1
KeyWest i2c @0x80018000 irq 27 /ht@0,f2000000/pci@8/mac-io@7/i2c@18000
 channel 0 bus /ht@0,f2000000/pci@8/mac-io@7/i2c@18000/i2c-bus@0
 channel 0 bus /ht@0,f2000000/pci@8/mac-io@7/i2c@18000/i2c-bus@0
SMU i2c /smu@0,0/smu-i2c-control@0
 channel b bus /smu@0,0/smu-i2c-control@0/i2c-bus@b
 channel e bus /smu@0,0/smu-i2c-control@0/i2c-bus@e
Processor timebase sync using platform function
mpic: requesting IPIs ... 
Processor 1 found.
Brought up 2 CPUs
NET: Registered protocol family 16
PCI: Probing PCI hardware
IOMMU table initialized, virtual merging enabled
Can't get ranges for PCI-PCI bridge /ht@0,f2000000/pci@1
Can't get ranges for PCI-PCI bridge /ht@0,f2000000/pci@3
Can't get ranges for PCI-PCI bridge /ht@0,f2000000/pci@4
Can't get ranges for PCI-PCI bridge /ht@0,f2000000/pci@5
Can't get ranges for PCI-PCI bridge /ht@0,f2000000/pci@6
PCI: Probing PCI hardware done
Registering pmac pic with sysfs...
SCSI subsystem initialized
libata version 2.21 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Enabling device: (0001:03:0e.0), cmd 2
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[39]  MMIO=[fa400000-fa4007ff]  Max Packet=[4096]  IR/IT contexts=[8/8]
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 6291456 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
Unpacking initramfs... done
Freeing initrd memory: 2407k freed
nvram_init: Could not find nvram partition for nvram buffered error logging.
Registering G5 CPU frequency driver
Frequency method: SCOM, Voltage method: GPIO
Low: 1150 Mhz, High: 2300 Mhz, Cur: 2300 MHz
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
SGI XFS with large block/inode numbers, no debug enabled
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
nvidiafb: Device ID: 10de0141 
nvidiafb: CRTC0 analog found
nvidiafb: CRTC1 analog found
nvidiafb: EDID found from BUS1
i2c-adapter i2c-1: unable to read EDID block.
i2c-adapter i2c-1: unable to read EDID block.
i2c-adapter i2c-1: unable to read EDID block.
ieee1394: Host added: ID:BUS[0-01:1023]  GUID[001451fffea8daae]
nvidiafb: CRTC 0 appears to have a CRT attached
nvidiafb: Using CRT on CRTC 0
Console: switching to colour frame buffer device 128x48
nvidiafb: PCI nVidia NV14 framebuffer (64MB @ 0x90000000)
Generic RTC Driver v1.07
loop: module loaded
tg3.c:v3.80 (August 2, 2007)
eth0: Tigon3 [partno(BCM95780) rev 8003 PHY(5780)] (PCIX:133MHz:64-bit) 10/100/1000Base-T Ethernet 00:14:51:68:b7:00
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth0: dma_rwctrl[76144000] dma_mask[40-bit]
eth1: Tigon3 [partno(BCM95780) rev 8003 PHY(5780)] (PCIX:133MHz:64-bit) 10/100/1000Base-T Ethernet 00:14:51:68:b7:01
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth1: dma_rwctrl[76144000] dma_mask[40-bit]
usbcore: registered new interface driver asix
Linux video capture interface: v2.00
usbcore: registered new interface driver zr364xx
/home/olaf/kernel/linux-2.6/drivers/media/video/zr364xx.c: Zoran 364xx module loaded
MacIO PCI driver attached to Shasta chipset
windfarm: initializing for dual-core desktop G5
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PCI: Enabling device: (0001:03:0d.0), cmd 6
ide0: Found Apple Shasta ATA-6 controller, bus ID 3, irq 38
Probing IDE interface ide0...
hda: HL-DT-ST DVD-RW GWA-4165B, ATAPI CD/DVD-ROM drive
hda: selected mode 0x44
hda: Enabling Ultra DMA 4
ide0 at 0xd0000800822fa000-0xd0000800822fa007,0xd0000800822fa160 on irq 38
hda: ATAPI 32X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(66)
Uniform CD-ROM driver Revision: 3.20
sata_svw 0001:03:0c.0: version 2.2
scsi0 : sata_svw
scsi1 : sata_svw
scsi2 : sata_svw
scsi3 : sata_svw
ata1: SATA max UDMA/133 cmd 0xd0000800822f4000 ctl 0xd0000800822f4020 bmdma 0xd0000800822f4030 irq 18
ata2: SATA max UDMA/133 cmd 0xd0000800822f4100 ctl 0xd0000800822f4120 bmdma 0xd0000800822f4130 irq 18
ata3: SATA max UDMA/133 cmd 0xd0000800822f4200 ctl 0xd0000800822f4220 bmdma 0xd0000800822f4230 irq 18
ata4: SATA max UDMA/133 cmd 0xd0000800822f4300 ctl 0xd0000800822f4320 bmdma 0xd0000800822f4330 irq 18
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: WDC WD2500JS-41MVB1, 10.02E01, max UDMA/133
ata1.00: 488397168 sectors, multi 0: LBA48 
ata1.00: configured for UDMA/133
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-7: Maxtor 6V250F0, VA111630, max UDMA/133
ata2.00: 490234752 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata2.00: configured for UDMA/133
ata3: SATA link down (SStatus 0 SControl 0)
ata4: SATA link down (SStatus 0 SControl 0)
scsi 0:0:0:0: Direct-Access     ATA      WDC WD2500JS-41M 10.0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: [mac] sda1 sda2 sda3 sda4 sda5 sda6 sda7
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Direct-Access     ATA      Maxtor 6V250F0   VA11 PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: [mac] sdb1 sdb2 sdb3 sdb4 sdb5 sdb6 sdb7 sdb8 sdb9 sdb10 sdb11 sdb12
sd 1:0:0:0: [sdb] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg1 type 0
video1394: Installed video1394 module
ieee1394: raw1394: /dev/raw1394 device initialized
eth1394: eth2: IPv4 over IEEE 1394 (fw-host0)
PCI: Enabling device: (0001:01:0b.2), cmd 6
ehci_hcd 0001:01:0b.2: EHCI Host Controller
ehci_hcd 0001:01:0b.2: new USB bus registered, assigned bus number 1
ehci_hcd 0001:01:0b.2: irq 70, io mem 0x80080000
ehci_hcd 0001:01:0b.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 5 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
PCI: Enabling device: (0001:01:0b.0), cmd 2
ohci_hcd 0001:01:0b.0: OHCI Host Controller
ohci_hcd 0001:01:0b.0: new USB bus registered, assigned bus number 2
ohci_hcd 0001:01:0b.0: irq 70, io mem 0x80082000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
PCI: Enabling device: (0001:01:0b.1), cmd 2
ohci_hcd 0001:01:0b.1: OHCI Host Controller
ohci_hcd 0001:01:0b.1: new USB bus registered, assigned bus number 3
ohci_hcd 0001:01:0b.1: irq 70, io mem 0x80081000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb 2-1: new full speed USB device using ohci_hcd and address 2
usb 2-1: configuration #1 chosen from 1 choice
usb 3-2: new full speed USB device using ohci_hcd and address 2
usb 3-2: configuration #1 chosen from 1 choice
hub 3-2:1.0: USB hub found
hub 3-2:1.0: 3 ports detected
usb 3-2.1: new low speed USB device using ohci_hcd and address 3
usb 3-2.1: configuration #1 chosen from 1 choice
usb 3-2.3: new full speed USB device using ohci_hcd and address 4
usb 3-2.3: configuration #1 chosen from 1 choice
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver libusual
usbcore: registered new interface driver usbserial
/home/olaf/kernel/linux-2.6/drivers/usb/serial/usb-serial.c: USB Serial Driver core
/home/olaf/kernel/linux-2.6/drivers/usb/serial/usb-serial.c: USB Serial support registered for Keyspan - (without firmware)
/home/olaf/kernel/linux-2.6/drivers/usb/serial/usb-serial.c: USB Serial support registered for Keyspan 1 port adapter
/home/olaf/kernel/linux-2.6/drivers/usb/serial/usb-serial.c: USB Serial support registered for Keyspan 2 port adapter
/home/olaf/kernel/linux-2.6/drivers/usb/serial/usb-serial.c: USB Serial support registered for Keyspan 4 port adapter
keyspan 2-1:1.0: Keyspan - (without firmware) converter detected
usbcore: registered new interface driver keyspan
/home/olaf/kernel/linux-2.6/drivers/usb/serial/keyspan.c: v1.1.5:Keyspan USB to Serial Converter Driver
mice: PS/2 mouse device common for all mice
PowerMac i2c bus smu 14 registered
wf_sat: creating sat at address b0
PowerMac i2c bus smu 11 registered
PowerMac i2c bus mac-io 0 registered
PowerMac i2c bus mac-io 0 registered
found max6690, loc=BACKSIDE addr=0x98
found max6690, loc=TUNNEL addr=0x9c
PowerMac i2c bus u4 1 registered
usbcore: registered new interface driver hiddev
input: Mitsumi Electric Apple Optical USB Mouse as /class/input/input0
input: USB HID v1.10 Mouse [Mitsumi Electric Apple Optical USB Mouse] on usb-0001:01:0b.1-2.1
input: Mitsumi Electric Apple Extended USB Keyboard as /class/input/input1
input: USB HID v1.10 Keyboard [Mitsumi Electric Apple Extended USB Keyboard] on usb-0001:01:0b.1-2.3
input: Mitsumi Electric Apple Extended USB Keyboard as /class/input/input2
input: USB HID v1.10 Device [Mitsumi Electric Apple Extended USB Keyboard] on usb-0001:01:0b.1-2.3
usbcore: registered new interface driver usbhid
/home/olaf/kernel/linux-2.6/drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.14 (Fri Jul 20 09:12:58 2007 UTC).
usbcore: registered new interface driver snd-usb-audio
usbcore: registered new interface driver snd-usb-usx2y
snd-aoa-fabric-layout: found bus with layout 68
snd-aoa-fabric-layout: Using PMF GPIOs
snd-aoa-codec-onyx: found pcm3052
snd-aoa-fabric-layout: platform-onyx-codec-ref doesn't match!
snd-aoa: fabric didn't like codec onyx
snd-aoa-codec-onyx: found pcm3052
snd-aoa-fabric-layout: can use this codec
windfarm: CPUs control loops started.
snd-aoa-codec-onyx: attached to onyx codec via i2c
snd-aoa-codec-onyx: created and attached onyx instance
ALSA device list:
  #0: SoundByLayout
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Freeing unused kernel memory: 204k freed
ioctl32(showconsole:441): Unknown cmd fd(0) cmd(40045432){t:'T';sz:4} arg(ffa5cbb8) on /dev/console
ioctl32(showconsole:444): Unknown cmd fd(0) cmd(40045432){t:'T';sz:4} arg(ffac3bb8) on /dev/console
usb 2-1: USB disconnect, address 2
keyspan 2-1:1.0: device disconnected
sysfs_remove_bin_file: bad dentry or inode or no such file: "descriptors"
Call Trace:
[c0000000015eb750] [c00000000000e414] .show_stack+0x68/0x1b0 (unreliable)
[c0000000015eb7f0] [c0000000000f2428] .sysfs_remove_bin_file+0x4c/0x68
[c0000000015eb870] [c0000000002aaedc] .device_remove_bin_file+0x1c/0x30
[c0000000015eb8f0] [c00000000036cb3c] .usb_remove_sysfs_dev_files+0xa0/0xd4
[c0000000015eb990] [c000000000371cc4] .generic_disconnect+0x40/0x58
[c0000000015eba10] [c000000000368960] .usb_unbind_device+0x30/0x48
[c0000000015eba90] [c0000000002ae88c] .__device_release_driver+0xc4/0x104
[c0000000015ebb20] [c0000000002aeefc] .device_release_driver+0x50/0x94
[c0000000015ebbb0] [c0000000002adea8] .bus_remove_device+0x9c/0xdc
[c0000000015ebc40] [c0000000002ab33c] .device_del+0x2c0/0x3b4
[c0000000015ebce0] [c0000000003611d4] .usb_disconnect+0x11c/0x1f4
[c0000000015ebd90] [c000000000361c38] .hub_thread+0x4dc/0xe10
[c0000000015ebf00] [c00000000005a1ec] .kthread+0x78/0xc4
[c0000000015ebf90] [c00000000001f390] .kernel_thread+0x4c/0x68
sat 0 partition c8: c8 6 2 7f ff 2 ff 1 fb bf 0 41 0 20 0 0 0 7 89 37 0 a0 0 0
usb 2-1: new full speed USB device using ohci_hcd and address 3
sat 0 partition c4: c4 4 1 7f 22 11 e0 e6 ff 55 7b 12 ec 11 0 0
ioctl32(showconsole:773): Unknown cmd fd(0) cmd(40045432){t:'T';sz:4} arg(ffac8bb8) on /dev/console
usb 2-1: configuration #1 chosen from 2 choices
keyspan 2-1:1.0: Keyspan 2 port adapter converter detected
usb 2-1: Keyspan 2 port adapter converter now attached to ttyUSB0
usb 2-1: Keyspan 2 port adapter converter now attached to ttyUSB1
sat 0 partition c9: c9 6 2 7f ff 2 ff 1 fb bf 0 41 0 20 0 0 0 7 89 37 0 a0 0 0
ioctl32(showconsole:827): Unknown cmd fd(0) cmd(40045432){t:'T';sz:4} arg(ffdfdb18) on /dev/console
Adding 1048568k swap on /dev/sdb3.  Priority:-1 extents:1 across:1048568k
ioctl32(showconsole:854): Unknown cmd fd(0) cmd(40045432){t:'T';sz:4} arg(ff8b4aa8) on /dev/console (deleted)
sat 0 partition c5: c5 4 1 7f 22 11 e0 e6 ff 55 7b 12 ec 11 0 0
windfarm: Backside control loop started.
windfarm: Slots control loop started.
windfarm: Drive bay control loop started.
ioctl32(showconsole:1758): Unknown cmd fd(0) cmd(40045432){t:'T';sz:4} arg(ff848aa8) on /dev/console (deleted)
XFS mounting filesystem sdb11
Ending clean XFS mount for filesystem: sdb11
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
ioctl32(showconsole:1937): Unknown cmd fd(0) cmd(40045432){t:'T';sz:4} arg(ffad3ab8) on /dev/console (deleted)
ioctl32(showconsole:2037): Unknown cmd fd(0) cmd(40045432){t:'T';sz:4} arg(ffaf9af8) on /dev/console
tg3: eth0: Link is up at 100 Mbps, full duplex.
tg3: eth0: Flow control is on for TX and on for RX.
ioctl32(showconsole:2649): Unknown cmd fd(0) cmd(40045432){t:'T';sz:4} arg(fff4ba88) on /dev/tty0
ioctl32(showconsole:3306): Unknown cmd fd(0) cmd(40045432){t:'T';sz:4} arg(ffc74ac8) on /dev/tty0
