Return-Path: <linux-kernel-owner+w=401wt.eu-S932857AbXBXNyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857AbXBXNyh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 08:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932863AbXBXNyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 08:54:37 -0500
Received: from mail.gmx.net ([213.165.64.20]:34209 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932857AbXBXNye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 08:54:34 -0500
X-Provags-ID: V01U2FsdGVkX1/xOOQtotXxQDscrCOSuucLRC2OLPgWowF4p/YZJW
	jFXQ==
From: Malte =?iso-8859-1?q?Schr=F6der?= <MalteSch@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: OOPS in 2.6.19.1 and also 2.6.20, connected to nfs4 and autofs4
Date: Sat, 24 Feb 2007 14:54:33 +0100
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1724325.uZWDxcLTc1";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702241454.37054.MalteSch@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1724325.uZWDxcLTc1
Content-Type: multipart/mixed;
  boundary="Boundary-01=_aOE4Fg+h7G3TKF5"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_aOE4Fg+h7G3TKF5
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,
I reported this problem in the past for 2.6.19.1=20
(http://lkml.org/lkml/2006/12/22/81).
It still happens, also=20
with //www.linux-nfs.org/Linux-2.6.x/2.6.20/linux-2.6.20-NFS_ALL.dif applie=
d.

I think it happens when autofs unmounts a nfs-share. The problem got better=
=20
since I removed the unmount-timeout from the autofs-mountpoint for nfs.

Could please someone take a look at this?

Regards
=2D-=20
=2D--------------------------------------
Malte Schr=F6der
MalteSch@gmx.de
ICQ# 68121508
=2D--------------------------------------


--Boundary-01=_aOE4Fg+h7G3TKF5
Content-Type: application/x-troff;
  name="fail.dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="fail.dmesg"

.903038]   MEM window: fe800000-fe8fffff
[   33.903305]   PREFETCH window: disabled.
[   33.903573] PCI: Bridge: 0000:00:1e.0
[   33.903838]   IO window: c000-cfff
[   33.904101]   MEM window: fea00000-feafffff
[   33.904369]   PREFETCH window: disabled.
[   33.904644] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[   33.905172] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   33.905185] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[   33.905715] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   33.905727] ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16 (level, low) -> IRQ 16
[   33.906256] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[   33.906269] ACPI: PCI Interrupt 0000:00:1c.5[B] -> GSI 17 (level, low) -> IRQ 17
[   33.906799] PCI: Setting latency timer of device 0000:00:1c.5 to 64
[   33.906807] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[   33.906826] NET: Registered protocol family 2
[   33.909595] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[   33.910320] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[   33.912263] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   33.912920] TCP: Hash tables configured (established 262144 bind 65536)
[   33.913197] TCP reno registered
[   33.914344] checking if image is initramfs... it is
[   34.096102] Freeing initrd memory: 2836k freed
[   34.097703] audit: initializing netlink socket (disabled)
[   34.097989] audit(1172311370.521:1): initialized
[   34.098419] io scheduler noop registered
[   34.098722] io scheduler cfq registered (default)
[   34.184195] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   34.184229] assign_interrupt_mode Found MSI capability
[   34.184535] Allocate Port Service[0000:00:01.0:pcie00]
[   34.184595] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   34.184626] assign_interrupt_mode Found MSI capability
[   34.184919] Allocate Port Service[0000:00:1c.0:pcie00]
[   34.184940] Allocate Port Service[0000:00:1c.0:pcie02]
[   34.185013] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[   34.185043] assign_interrupt_mode Found MSI capability
[   34.185339] Allocate Port Service[0000:00:1c.4:pcie00]
[   34.185360] Allocate Port Service[0000:00:1c.4:pcie02]
[   34.185433] PCI: Setting latency timer of device 0000:00:1c.5 to 64
[   34.185463] assign_interrupt_mode Found MSI capability
[   34.185756] Allocate Port Service[0000:00:1c.5:pcie00]
[   34.185778] Allocate Port Service[0000:00:1c.5:pcie02]
[   34.203137] Real Time Clock Driver v1.12ac
[   34.203524] hpet_resources: 0xfed00000 is busy
[   34.203538] Linux agpgart interface v0.101 (c) Dave Jones
[   34.203811] Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing disabled
[   34.204405] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   34.204943] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   34.205654] RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
[   34.206270] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[   34.206545] PNP: PS/2 controller doesn't have AUX irq; using default 12
[   34.209486] serio: i8042 KBD port at 0x60,0x64 irq 1
[   34.209758] serio: i8042 AUX port at 0x60,0x64 irq 12
[   34.210078] mice: PS/2 mouse device common for all mice
[   34.210466] BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
[   34.210802] Freeing unused kernel memory: 208k freed
[   34.228734] input: AT Translated Set 2 keyboard as /class/input/input0
[   34.254384] SCSI subsystem initialized
[   34.257051] libata version 2.00 loaded.
[   34.257874] ahci 0000:00:1f.2: version 2.0
[   34.257892] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
[   35.257556] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[   35.257563] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[   35.258078] ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo pmp pio slum part 
[   35.258624] ata1: SATA max UDMA/133 cmd 0xFFFFC20000008900 ctl 0x0 bmdma 0x0 irq 507
[   35.259164] ata2: SATA max UDMA/133 cmd 0xFFFFC20000008980 ctl 0x0 bmdma 0x0 irq 507
[   35.259702] ata3: SATA max UDMA/133 cmd 0xFFFFC20000008A00 ctl 0x0 bmdma 0x0 irq 507
[   35.272548] ata4: SATA max UDMA/133 cmd 0xFFFFC20000008A80 ctl 0x0 bmdma 0x0 irq 507
[   35.273087] ata5: SATA max UDMA/133 cmd 0xFFFFC20000008B00 ctl 0x0 bmdma 0x0 irq 507
[   35.273627] ata6: SATA max UDMA/133 cmd 0xFFFFC20000008B80 ctl 0x0 bmdma 0x0 irq 507
[   35.274128] scsi0 : ahci
[   35.731795] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   35.734419] ata1.00: ATA-6, max UDMA/133, 145226112 sectors: LBA48 
[   35.734708] ata1.00: ata1: dev 0 multi count 0
[   35.738322] ata1.00: configured for UDMA/133
[   35.738604] scsi1 : ahci
[   36.041223] ata2: SATA link down (SStatus 0 SControl 300)
[   36.041512] scsi2 : ahci
[   36.498569] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   36.500062] ata3.00: ATA-6, max UDMA/100, 160836480 sectors: LBA48 
[   36.500348] ata3.00: ata3: dev 0 multi count 0
[   36.502124] ata3.00: configured for UDMA/100
[   36.502405] scsi3 : ahci
[   36.805201] ata4: SATA link down (SStatus 0 SControl 300)
[   36.805481] scsi4 : ahci
[   37.107630] ata5: SATA link down (SStatus 0 SControl 300)
[   37.107917] scsi5 : ahci
[   37.410079] ata6: SATA link down (SStatus 0 SControl 300)
[   37.410430] scsi 0:0:0:0: Direct-Access     ATA      WDC WD740GD-00FL 33.0 PQ: 0 ANSI: 5
[   37.411021] scsi 2:0:0:0: Direct-Access     ATA      HDS722580VLSA80  V32O PQ: 0 ANSI: 5
[   37.411583] PCI: Device 0000:03:00.0 not available because of resource collisions
[   37.412083] ahci: probe of 0000:03:00.0 failed with error -22
[   37.415994] SCSI device sda: 145226112 512-byte hdwr sectors (74356 MB)
[   37.416280] sda: Write Protect is off
[   37.416545] sda: Mode Sense: 00 3a 00 00
[   37.416556] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   37.417089] SCSI device sda: 145226112 512-byte hdwr sectors (74356 MB)
[   37.417373] sda: Write Protect is off
[   37.417637] sda: Mode Sense: 00 3a 00 00
[   37.417648] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   37.418157]  sda: sda1 sda2 sda3 < sda5 sda6 >
[   37.452104] sd 0:0:0:0: Attached scsi disk sda
[   37.452406] SCSI device sdb: 160836480 512-byte hdwr sectors (82348 MB)
[   37.452689] sdb: Write Protect is off
[   37.452956] sdb: Mode Sense: 00 3a 00 00
[   37.452967] SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   37.453497] SCSI device sdb: 160836480 512-byte hdwr sectors (82348 MB)
[   37.453778] sdb: Write Protect is off
[   37.454044] sdb: Mode Sense: 00 3a 00 00
[   37.454055] SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   37.454558]  sdb: sdb1 sdb3 < sdb5 sdb6 >
[   37.487472] sd 2:0:0:0: Attached scsi disk sdb
[   37.491052] NET: Registered protocol family 1
[   37.512565] ACPI (exconfig-0455): Dynamic SSDT Load - OemId [   AMI] OemTableId [  CPU1PM] [20060707]
[   37.513694] ACPI (exconfig-0455): Dynamic SSDT Load - OemId [   AMI] OemTableId [  CPU2PM] [20060707]
[   37.605821] usbcore: registered new interface driver usbfs
[   37.606113] usbcore: registered new interface driver hub
[   37.606399] usbcore: registered new device driver usb
[   37.606740] PCI: Enabling device 0000:03:00.1 (0000 -> 0001)
[   37.607588] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
[   37.608139] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[   37.608147] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[   37.608153] USB Universal Host Controller Interface driver v3.0
[   37.608815] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[   37.609349] ehci_hcd 0000:00:1a.7: debug port 1
[   37.609628] PCI: cache line size of 32 is not supported by device 0000:00:1a.7
[   37.609635] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfebff400
[   37.613793] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   37.614392] usb usb1: configuration #1 chosen from 1 choice
[   37.614692] hub 1-0:1.0: USB hub found
[   37.614966] hub 1-0:1.0: 4 ports detected
[   37.615255] ACPI: PCI Interrupt 0000:03:00.1[B] -> GSI 17 (level, low) -> IRQ 17
[   37.616105] PCI: Setting latency timer of device 0000:03:00.1 to 64
[   37.616133] ata7: PATA max UDMA/100 cmd 0xBC00 ctl 0xB882 bmdma 0xB400 irq 17
[   37.616439] ata8: PATA max UDMA/100 cmd 0xB800 ctl 0xB482 bmdma 0xB408 irq 17
[   37.616733] scsi6 : pata_jmicron
[   37.650306] ieee1394: Initialized config rom entry `ip1394'
[   37.715760] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
[   37.716300] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[   37.716303] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   37.716589] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 2
[   37.717108] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000e000
[   37.717442] usb usb2: configuration #1 chosen from 1 choice
[   37.717735] hub 2-0:1.0: USB hub found
[   37.718002] hub 2-0:1.0: 2 ports detected
[   37.818706] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 17 (level, low) -> IRQ 17
[   37.819246] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[   37.819249] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   37.819538] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 3
[   37.820054] uhci_hcd 0000:00:1a.1: irq 17, io base 0x0000e080
[   37.820391] usb usb3: configuration #1 chosen from 1 choice
[   37.820679] hub 3-0:1.0: USB hub found
[   37.820948] hub 3-0:1.0: 2 ports detected
[   37.922169] ata7.00: ATAPI, max UDMA/33
[   38.076636] ata7.01: ATAPI, max UDMA/66
[   38.231466] ata7.00: configured for UDMA/33
[   38.386154] ata7.01: configured for UDMA/66
[   38.386425] scsi7 : pata_jmicron
[   38.548689] ATA: abnormal status 0x7F on port 0xB807
[   38.550916] scsi 6:0:0:0: CD-ROM            BENQ     DVD DD DW1640    BSRB PQ: 0 ANSI: 5
[   38.552643] scsi 6:0:1:0: CD-ROM            PIONEER  DVD-ROM DVD-106  1.22 PQ: 0 ANSI: 5
[   38.554102] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
[   38.554645] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   38.554648] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   38.555139] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[   38.555662] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d800
[   38.556567] usb usb4: configuration #1 chosen from 1 choice
[   38.556864] hub 4-0:1.0: USB hub found
[   38.557135] hub 4-0:1.0: 2 ports detected
[   38.658303] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[   38.658856] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   38.658859] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   38.659145] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
[   38.659669] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d880
[   38.660005] usb usb5: configuration #1 chosen from 1 choice
[   38.660298] hub 5-0:1.0: USB hub found
[   38.660569] hub 5-0:1.0: 2 ports detected
[   38.761162] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[   38.761715] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   38.761717] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   38.762006] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
[   38.762529] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000dc00
[   38.762861] usb usb6: configuration #1 chosen from 1 choice
[   38.763157] hub 6-0:1.0: USB hub found
[   38.763425] hub 6-0:1.0: 2 ports detected
[   38.863903] usb 4-2: new full speed USB device using uhci_hcd and address 2
[   38.867129] ACPI: PCI Interrupt 0000:05:02.2[B] -> GSI 20 (level, low) -> IRQ 20
[   38.869085] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
[   38.869627] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   38.869630] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   38.869925] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
[   38.870448] ehci_hcd 0000:00:1d.7: debug port 1
[   38.870724] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[   38.870730] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfebff000
[   38.877763] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   38.878325] usb usb7: configuration #1 chosen from 1 choice
[   38.878618] hub 7-0:1.0: USB hub found
[   38.878895] hub 7-0:1.0: 6 ports detected
[   38.926191] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[20]  MMIO=[feaff800-feafffff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   38.929774] ACPI: PCI Interrupt 0000:05:03.0[A] -> GSI 21 (level, low) -> IRQ 21
[   38.995574] ohci1394: fw-host1: OHCI-1394 1.1 (PCI): IRQ=[21]  MMIO=[feaff000-feaff7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   39.141254] kjournald starting.  Commit interval 5 seconds
[   39.141546] EXT3-fs: mounted filesystem with ordered data mode.
[   39.228316] usb 7-2: new high speed USB device using ehci_hcd and address 2
[   39.342396] usb 7-2: configuration #1 chosen from 1 choice
[   39.342838] hub 7-2:1.0: USB hub found
[   39.343190] hub 7-2:1.0: 7 ports detected
[   39.650621] usb 7-5: new high speed USB device using ehci_hcd and address 3
[   39.799917] usb 7-5: configuration #1 chosen from 1 choice
[   39.977202] usb 7-2.3: new low speed USB device using ehci_hcd and address 4
[   40.057626] usb 7-2.3: configuration #1 chosen from 1 choice
[   40.184820] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023c00310163af]
[   40.223691] usb 7-2.4: new low speed USB device using ehci_hcd and address 5
[   40.306379] usb 7-2.4: configuration #1 chosen from 1 choice
[   40.440332] ieee1394: Host added: ID:BUS[1-00:1023]  GUID[0011d80000f9b6dc]
[   40.694727] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[   40.695229] Uniform CD-ROM driver Revision: 3.20
[   40.695528] sr 6:0:0:0: Attached scsi CD-ROM sr0
[   40.700162] sr1: scsi3-mmc drive: 40x/40x cd/rw xa/form2 cdda tray
[   40.700466] sr 6:0:1:0: Attached scsi CD-ROM sr1
[   40.803464] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   40.803755] sd 2:0:0:0: Attached scsi generic sg1 type 0
[   40.804040] sr 6:0:0:0: Attached scsi generic sg2 type 5
[   40.804324] sr 6:0:1:0: Attached scsi generic sg3 type 5
[   41.124339] input: PC Speaker as /class/input/input1
[   41.149031] Floppy drive(s): fd0 is 1.44M
[   41.163427] eth1394: eth0: IEEE-1394 IPv4 over 1394 Ethernet (fw-host0)
[   41.163757] eth1394: eth1: IEEE-1394 IPv4 over 1394 Ethernet (fw-host1)
[   41.164954] FDC 0 is a post-1991 82077
[   41.245598] agpgart: Detected an Intel 965G Chipset.
[   41.259450] agpgart: AGP aperture is 256M @ 0x0
[   41.281308] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[   41.281862] PCI: Setting latency timer of device 0000:02:00.0 to 64
[   41.281917] sky2 v1.10 addr 0xfe8fc000 irq 17 Yukon-EC Ultra (0xb4) rev 2
[   41.283260] sky2 eth0: addr 00:18:f3:c6:8a:c1
[   41.300005] PCI: Enabling device 0000:00:1f.3 (0001 -> 0003)
[   41.300292] ACPI: PCI Interrupt 0000:00:1f.3[C] -> GSI 18 (level, low) -> IRQ 18
[   41.386503] usbcore: registered new interface driver hiddev
[   41.389953] input: Logitech USB-PS/2 Optical Mouse as /class/input/input2
[   41.390268] input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.7-2.3
[   41.401927] Initializing USB Mass Storage driver...
[   41.402258] scsi8 : SCSI emulation for USB Mass Storage devices
[   41.402574] usb-storage: device found at 3
[   41.402576] usb-storage: waiting for device to settle before scanning
[   41.404149] input: Microsoft Microsoft SideWinder Precision Pro (USB) as /class/input/input3
[   41.404684] input: USB HID v1.00 Joystick [Microsoft Microsoft SideWinder Precision Pro (USB)] on usb-0000:00:1d.7-2.4
[   41.405279] usbcore: registered new interface driver usbhid
[   41.405555] drivers/usb/input/hid-core.c: v2.6:USB HID core driver
[   41.405838] usbcore: registered new interface driver usb-storage
[   41.406115] USB Mass Storage support registered.
[   41.600851] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
[   41.601411] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   41.676562] hda_codec: Unknown model for AD1988, trying auto-probe from BIOS...
[   41.714475] ACPI: PCI Interrupt 0000:05:02.0[A] -> GSI 23 (level, low) -> IRQ 23
[   42.727096] Adding 3212960k swap on /dev/sdb1.  Priority:-1 extents:1 across:3212960k
[   42.823663] EXT3 FS on sda6, internal journal
[   43.663439] TCP cubic registered
[   43.901639] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
[   44.056999] kjournald starting.  Commit interval 5 seconds
[   44.057644] EXT3 FS on sda2, internal journal
[   44.057949] EXT3-fs: mounted filesystem with ordered data mode.
[   44.059704] kjournald starting.  Commit interval 5 seconds
[   44.060154] EXT3 FS on sdb6, internal journal
[   44.060451] EXT3-fs: mounted filesystem with ordered data mode.
[   44.061798] kjournald starting.  Commit interval 5 seconds
[   44.062241] EXT3 FS on sdb5, internal journal
[   44.062549] EXT3-fs: mounted filesystem with ordered data mode.
[   44.206532] fuse init (API version 7.8)
[   45.060558] NET: Registered protocol family 10
[   45.061209] lo: Disabled Privacy Extensions
[   45.061525] Mobile IPv6
[   46.395434] usb-storage: device scan complete
[   46.621450] scsi 8:0:0:0: Direct-Access     OTi      CF CARD Reader   2.00 PQ: 0 ANSI: 0 CCS
[   46.848466] scsi 8:0:0:1: Direct-Access     OTi      SM CARD Reader   2.00 PQ: 0 ANSI: 0 CCS
[   47.075859] scsi 8:0:0:2: Direct-Access     OTi      SD CARD Reader   2.00 PQ: 0 ANSI: 0 CCS
[   47.302628] scsi 8:0:0:3: Direct-Access     OTi      MS CARD Reader   2.00 PQ: 0 ANSI: 0 CCS
[   47.969112] sd 8:0:0:0: Attached scsi removable disk sdc
[   47.969424] sd 8:0:0:0: Attached scsi generic sg4 type 0
[   48.967679] sd 8:0:0:1: Attached scsi removable disk sdd
[   48.968001] sd 8:0:0:1: Attached scsi generic sg5 type 0
[   49.633391] sd 8:0:0:2: Attached scsi removable disk sde
[   49.633716] sd 8:0:0:2: Attached scsi generic sg6 type 0
[   50.139344] sd 8:0:0:3: Attached scsi removable disk sdf
[   50.139666] sd 8:0:0:3: Attached scsi generic sg7 type 0
[   55.398172] sky2 eth0: enabling interface
[   55.400661] sky2 eth0: ram buffer 0K
[   55.408088] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   56.441531] NET: Registered protocol family 17
[   57.100979] sky2 eth0: Link is up at 100 Mbps, full duplex, flow control both
[   57.108282] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   61.026709] input: Power Button (FF) as /class/input/input4
[   61.033693] ACPI: Power Button (FF) [PWRF]
[   61.034082] input: Power Button (CM) as /class/input/input5
[   61.034435] ACPI: Power Button (CM) [PWRB]
[   73.134333] nvidia: module license 'NVIDIA' taints kernel.
[   73.387494] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[   73.387651] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   73.387810] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  1.0-9746  Fri Dec 15 10:19:35 PST 2006
[   73.859991] **WARNING** I2C adapter driver [NVIDIA i2c adapter 0 at 1:00.0] forgot to specify physical device; fix it!
[   73.860287] **WARNING** I2C adapter driver [NVIDIA i2c adapter 1 at 1:00.0] forgot to specify physical device; fix it!
[   73.860316] **WARNING** I2C adapter driver [NVIDIA i2c adapter 2 at 1:00.0] forgot to specify physical device; fix it!
[   73.860334] **WARNING** I2C adapter driver [NVIDIA i2c adapter 3 at 1:00.0] forgot to specify physical device; fix it!
[ 5548.306776] Unable to handle kernel NULL pointer dereference at 0000000000000010 RIP: 
[ 5548.306780]  [<ffffffff883b74a1>] :nfs:nfs_update_inode+0x96/0x59b
[ 5548.306797] PGD ae557067 PUD 6cc63067 PMD 0 
[ 5548.306800] Oops: 0000 [1] PREEMPT SMP 
[ 5548.306803] CPU 0 
[ 5548.306804] Modules linked in: nvidia(P) snd_rtctimer binfmt_misc cpufreq_userspace cpufreq_powersave rpcsec_gss_krb5 auth_rpcgss nfs lockd nfs_acl sunrpc button ac battery autofs4 af_packet ipv6 fuse dm_snapshot dm_mirror dm_mod kvm_intel kvm w83781d hwmon_vid hwmon i2c_isa eeprom acpi_cpufreq cpufreq_conservative cpufreq_ondemand freq_table tcp_cubic snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_seq snd_emu10k1 snd_hda_intel snd_hda_codec joydev snd_pcm_oss snd_mixer_oss snd_rawmidi snd_ac97_codec ac97_bus snd_seq_device snd_pcm snd_util_mem usb_storage snd_timer usbhid psmouse snd_hwdep hid i2c_i801 sky2 intel_agp snd ff_memless evdev eth1394 snd_page_alloc floppy pcspkr soundcore sg sr_mod cdrom ext3 jbd mbcache ohci1394 ieee1394 uhci_hcd ehci_hcd pata_jmicron usbcore thermal processor fan unix sd_mod ahci libata scsi_mod
[ 5548.306853] Pid: 8134, comm: umount Tainted: P      2.6.20-ck1-nfs #1
[ 5548.306855] RIP: 0010:[<ffffffff883b74a1>]  [<ffffffff883b74a1>] :nfs:nfs_update_inode+0x96/0x59b
[ 5548.306868] RSP: 0018:ffff810081f39c88  EFLAGS: 00010246
[ 5548.306870] RAX: 0000000000000000 RBX: ffff8100753438d0 RCX: 00000000000081a4
[ 5548.306873] RDX: ffff81008d643c80 RSI: ffff8100753438d0 RDI: ffff810067b5b9b8
[ 5548.306875] RBP: ffff810067b5b9b8 R08: 00000000000081a4 R09: ffff81007fe05748
[ 5548.306877] R10: ffff810075c39650 R11: 0000000000000000 R12: ffff810067b5b800
[ 5548.306879] R13: ffff810067b5b9b8 R14: ffff81008f156bc0 R15: ffff8100753438d0
[ 5548.306882] FS:  00002b861bd3d1f0(0000) GS:ffffffff81246000(0000) knlGS:0000000000000000
[ 5548.306884] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 5548.306886] CR2: 0000000000000010 CR3: 00000000a9dc1000 CR4: 00000000000026e0
[ 5548.306889] Process umount (pid: 8134, threadinfo ffff810081f38000, task ffff81007330b180)
[ 5548.306891] Stack:  ffff810067b5b9b8 ffff8100753438d0 ffff810067b5ba6c ffff810067b5b9b8
[ 5548.306896]  ffff81008f156bc0 ffffffff883b8b23 ffff810075343800 ffff810075c39580
[ 5548.306899]  0000000000000000 ffffffff883c6888 ffff810074ea9ee0 ffff81008d643c80
[ 5548.306903] Call Trace:
[ 5548.306918]  [<ffffffff883b8b23>] :nfs:nfs_post_op_update_inode+0x36/0x47
[ 5548.306933]  [<ffffffff883c6888>] :nfs:nfs4_proc_delegreturn+0x14a/0x199
[ 5548.306954]  [<ffffffff883d117c>] :nfs:nfs_do_return_delegation+0x17/0x2b
[ 5548.306967]  [<ffffffff883b5d15>] :nfs:nfs_dentry_iput+0x1b/0x4f
[ 5548.306973]  [<ffffffff810aeafd>] shrink_dcache_for_umount_subtree+0x200/0x255
[ 5548.306978]  [<ffffffff810af106>] shrink_dcache_for_umount+0x2f/0x3d
[ 5548.306982]  [<ffffffff810a9075>] generic_shutdown_super+0x19/0xf4
[ 5548.306987]  [<ffffffff810a9194>] kill_anon_super+0x9/0x36
[ 5548.306999]  [<ffffffff883b928f>] :nfs:nfs_kill_super+0xd/0x16
[ 5548.307003]  [<ffffffff810a9225>] deactivate_super+0x49/0x62
[ 5548.307007]  [<ffffffff810b0f6b>] expire_mount_list+0x124/0x164
[ 5548.307014]  [<ffffffff810b0fe1>] shrink_submounts+0x36/0xdc
[ 5548.307021]  [<ffffffff810b1187>] sys_umount+0x100/0x226
[ 5548.307027]  [<ffffffff81020eab>] sys_newstat+0x19/0x31
[ 5548.307037]  [<ffffffff8105511e>] system_call+0x7e/0x83
[ 5548.307046] 
[ 5548.307047] 
[ 5548.307047] Code: 48 3b 68 10 75 2a 48 8b 73 60 48 39 b2 b8 00 00 00 48 8d 8a 
[ 5548.307056] RIP  [<ffffffff883b74a1>] :nfs:nfs_update_inode+0x96/0x59b
[ 5548.307068]  RSP <ffff810081f39c88>
[ 5548.307069] CR2: 0000000000000010
[ 5548.307071]  <6>note: umount[8134] exited with preempt_count 1
[ 5548.307094] BUG: scheduling while atomic: umount/0x10000001/8134
[ 5548.307096] 
[ 5548.307096] Call Trace:
[ 5548.307100]  [<ffffffff810582ed>] __sched_text_start+0x5d/0x6c3
[ 5548.307107]  [<ffffffff8102aca7>] __wake_up+0x38/0x4f
[ 5548.307115]  [<ffffffff8107614f>] __cond_resched+0x1c/0x44
[ 5548.307118]  [<ffffffff810591c7>] cond_resched+0x2e/0x39
[ 5548.307121]  [<ffffffff81007ac3>] unmap_vmas+0x59d/0x751
[ 5548.307136]  [<ffffffff81035621>] exit_mmap+0x83/0x11f
[ 5548.307141]  [<ffffffff81037745>] mmput+0x2c/0x9e
[ 5548.307145]  [<ffffffff81013791>] do_exit+0x21c/0x82c
[ 5548.307149]  [<ffffffff8105aa49>] _spin_unlock_irqrestore+0x8/0x30
[ 5548.307155]  [<ffffffff8100a7d4>] do_page_fault+0x6cf/0x74a
[ 5548.307158]  [<ffffffff8105a1fe>] __up_wakeup+0x35/0x67
[ 5548.307164]  [<ffffffff81058953>] thread_return+0x0/0xf4
[ 5548.307167]  [<ffffffff810589f7>] thread_return+0xa4/0xf4
[ 5548.307178]  [<ffffffff8105ac6d>] error_exit+0x0/0x84
[ 5548.307197]  [<ffffffff883b74a1>] :nfs:nfs_update_inode+0x96/0x59b
[ 5548.307202]  [<ffffffff8101b61b>] sigprocmask+0xba/0xc1
[ 5548.307216]  [<ffffffff883b8b23>] :nfs:nfs_post_op_update_inode+0x36/0x47
[ 5548.307231]  [<ffffffff883c6888>] :nfs:nfs4_proc_delegreturn+0x14a/0x199
[ 5548.307251]  [<ffffffff883d117c>] :nfs:nfs_do_return_delegation+0x17/0x2b
[ 5548.307264]  [<ffffffff883b5d15>] :nfs:nfs_dentry_iput+0x1b/0x4f
[ 5548.307269]  [<ffffffff810aeafd>] shrink_dcache_for_umount_subtree+0x200/0x255
[ 5548.307274]  [<ffffffff810af106>] shrink_dcache_for_umount+0x2f/0x3d
[ 5548.307278]  [<ffffffff810a9075>] generic_shutdown_super+0x19/0xf4
[ 5548.307282]  [<ffffffff810a9194>] kill_anon_super+0x9/0x36
[ 5548.307294]  [<ffffffff883b928f>] :nfs:nfs_kill_super+0xd/0x16
[ 5548.307298]  [<ffffffff810a9225>] deactivate_super+0x49/0x62
[ 5548.307303]  [<ffffffff810b0f6b>] expire_mount_list+0x124/0x164
[ 5548.307310]  [<ffffffff810b0fe1>] shrink_submounts+0x36/0xdc
[ 5548.307316]  [<ffffffff810b1187>] sys_umount+0x100/0x226
[ 5548.307323]  [<ffffffff81020eab>] sys_newstat+0x19/0x31
[ 5548.307333]  [<ffffffff8105511e>] system_call+0x7e/0x83
[ 5548.307341] 
[ 5548.308028] BUG: scheduling while atomic: umount/0x10000001/8134
[ 5548.308030] 
[ 5548.308031] Call Trace:
[ 5548.308037]  [<ffffffff810582ed>] __sched_text_start+0x5d/0x6c3
[ 5548.308049]  [<ffffffff8107614f>] __cond_resched+0x1c/0x44
[ 5548.308052]  [<ffffffff810591c7>] cond_resched+0x2e/0x39
[ 5548.308055]  [<ffffffff81007ac3>] unmap_vmas+0x59d/0x751
[ 5548.308069]  [<ffffffff81035621>] exit_mmap+0x83/0x11f
[ 5548.308074]  [<ffffffff81037745>] mmput+0x2c/0x9e
[ 5548.308078]  [<ffffffff81013791>] do_exit+0x21c/0x82c
[ 5548.308082]  [<ffffffff8105aa49>] _spin_unlock_irqrestore+0x8/0x30
[ 5548.308087]  [<ffffffff8100a7d4>] do_page_fault+0x6cf/0x74a
[ 5548.308090]  [<ffffffff8105a1fe>] __up_wakeup+0x35/0x67
[ 5548.308096]  [<ffffffff81058953>] thread_return+0x0/0xf4
[ 5548.308099]  [<ffffffff810589f7>] thread_return+0xa4/0xf4
[ 5548.308111]  [<ffffffff8105ac6d>] error_exit+0x0/0x84
[ 5548.308131]  [<ffffffff883b74a1>] :nfs:nfs_update_inode+0x96/0x59b
[ 5548.308136]  [<ffffffff8101b61b>] sigprocmask+0xba/0xc1
[ 5548.308150]  [<ffffffff883b8b23>] :nfs:nfs_post_op_update_inode+0x36/0x47
[ 5548.308165]  [<ffffffff883c6888>] :nfs:nfs4_proc_delegreturn+0x14a/0x199
[ 5548.308184]  [<ffffffff883d117c>] :nfs:nfs_do_return_delegation+0x17/0x2b
[ 5548.308198]  [<ffffffff883b5d15>] :nfs:nfs_dentry_iput+0x1b/0x4f
[ 5548.308202]  [<ffffffff810aeafd>] shrink_dcache_for_umount_subtree+0x200/0x255
[ 5548.308207]  [<ffffffff810af106>] shrink_dcache_for_umount+0x2f/0x3d
[ 5548.308211]  [<ffffffff810a9075>] generic_shutdown_super+0x19/0xf4
[ 5548.308215]  [<ffffffff810a9194>] kill_anon_super+0x9/0x36
[ 5548.308228]  [<ffffffff883b928f>] :nfs:nfs_kill_super+0xd/0x16
[ 5548.308231]  [<ffffffff810a9225>] deactivate_super+0x49/0x62
[ 5548.308235]  [<ffffffff810b0f6b>] expire_mount_list+0x124/0x164
[ 5548.308242]  [<ffffffff810b0fe1>] shrink_submounts+0x36/0xdc
[ 5548.308249]  [<ffffffff810b1187>] sys_umount+0x100/0x226
[ 5548.308255]  [<ffffffff81020eab>] sys_newstat+0x19/0x31
[ 5548.308265]  [<ffffffff8105511e>] system_call+0x7e/0x83
[ 5548.308274] 
[ 5608.211648] Unable to handle kernel NULL pointer dereference at 0000000000000010 RIP: 
[ 5608.211652]  [<ffffffff883b74a1>] :nfs:nfs_update_inode+0x96/0x59b
[ 5608.211675] PGD b59a0067 PUD b599f067 PMD 0 
[ 5608.211679] Oops: 0000 [2] PREEMPT SMP 
[ 5608.211683] CPU 0 
[ 5608.211685] Modules linked in: nvidia(P) snd_rtctimer binfmt_misc cpufreq_userspace cpufreq_powersave rpcsec_gss_krb5 auth_rpcgss nfs lockd nfs_acl sunrpc button ac battery autofs4 af_packet ipv6 fuse dm_snapshot dm_mirror dm_mod kvm_intel kvm w83781d hwmon_vid hwmon i2c_isa eeprom acpi_cpufreq cpufreq_conservative cpufreq_ondemand freq_table tcp_cubic snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_seq snd_emu10k1 snd_hda_intel snd_hda_codec joydev snd_pcm_oss snd_mixer_oss snd_rawmidi snd_ac97_codec ac97_bus snd_seq_device snd_pcm snd_util_mem usb_storage snd_timer usbhid psmouse snd_hwdep hid i2c_i801 sky2 intel_agp snd ff_memless evdev eth1394 snd_page_alloc floppy pcspkr soundcore sg sr_mod cdrom ext3 jbd mbcache ohci1394 ieee1394 uhci_hcd ehci_hcd pata_jmicron usbcore thermal processor fan unix sd_mod ahci libata scsi_mod
[ 5608.211756] Pid: 8162, comm: 192.168.1.3-del Tainted: P      2.6.20-ck1-nfs #1
[ 5608.211759] RIP: 0010:[<ffffffff883b74a1>]  [<ffffffff883b74a1>] :nfs:nfs_update_inode+0x96/0x59b
[ 5608.211779] RSP: 0000:ffff810081f35e30  EFLAGS: 00010246
[ 5608.211782] RAX: 0000000000000000 RBX: ffff810075dee0d0 RCX: 00000000000081e4
[ 5608.211786] RDX: ffff81008d643c80 RSI: ffff810075dee0d0 RDI: ffff810067aa39b8
[ 5608.211789] RBP: ffff810067aa39b8 R08: 00000000000081e4 R09: ffff81007fe05748
[ 5608.211793] R10: ffff810075c39b50 R11: 0000000000000000 R12: ffff810067aa3800
[ 5608.211797] R13: ffff810067aa39b8 R14: ffff81008f156bc0 R15: ffff810075dee0d0
[ 5608.211800] FS:  0000000000000000(0000) GS:ffffffff81246000(0000) knlGS:0000000000000000
[ 5608.211804] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[ 5608.211807] CR2: 0000000000000010 CR3: 00000000b6bcc000 CR4: 00000000000026e0
[ 5608.211811] Process 192.168.1.3-del (pid: 8162, threadinfo ffff810081f34000, task ffff8100954fc0c0)
[ 5608.211814] Stack:  ffff810067aa39b8 ffff810075dee0d0 ffff810067aa3a6c ffff810067aa39b8
[ 5608.211821]  ffff81008f156bc0 ffffffff883b8b23 ffff810075dee000 ffff810075c39a80
[ 5608.211826]  0000000000000000 ffffffff883c6888 ffff8100777aaae0 ffff81008d643c80
[ 5608.211831] Call Trace:
[ 5608.211854]  [<ffffffff883b8b23>] :nfs:nfs_post_op_update_inode+0x36/0x47
[ 5608.211877]  [<ffffffff883c6888>] :nfs:nfs4_proc_delegreturn+0x14a/0x199
[ 5608.211889]  [<ffffffff8108661c>] keventd_create_kthread+0x0/0x6a
[ 5608.211915]  [<ffffffff883d117c>] :nfs:nfs_do_return_delegation+0x17/0x2b
[ 5608.211931]  [<ffffffff883d193e>] :nfs:nfs_do_expire_all_delegations+0x6d/0xb3
[ 5608.211945]  [<ffffffff883d18d1>] :nfs:nfs_do_expire_all_delegations+0x0/0xb3
[ 5608.211949]  [<ffffffff8102e835>] kthread+0xd1/0x100
[ 5608.211955]  [<ffffffff81055ef8>] child_rip+0xa/0x12
[ 5608.211958]  [<ffffffff8108661c>] keventd_create_kthread+0x0/0x6a
[ 5608.211967]  [<ffffffff8102e764>] kthread+0x0/0x100
[ 5608.211969]  [<ffffffff81055eee>] child_rip+0x0/0x12
[ 5608.211973] 
[ 5608.211974] 
[ 5608.211974] Code: 48 3b 68 10 75 2a 48 8b 73 60 48 39 b2 b8 00 00 00 48 8d 8a 
[ 5608.211983] RIP  [<ffffffff883b74a1>] :nfs:nfs_update_inode+0x96/0x59b
[ 5608.211995]  RSP <ffff810081f35e30>
[ 5608.211996] CR2: 0000000000000010
[ 5608.211998]  <6>note: 192.168.1.3-del[8162] exited with preempt_count 1

--Boundary-01=_aOE4Fg+h7G3TKF5
Content-Type: text/plain;
  charset="iso-8859-1";
  name="config-2.6.20-ck1-nfs"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="config-2.6.20-ck1-nfs"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.20-ck1-nfs
# Fri Feb 16 21:02:33 2007
#
CONFIG_X86_64=y
CONFIG_64BIT=y
CONFIG_X86=y
CONFIG_ZONE_DMA32=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_MMU=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_CMPXCHG=y
CONFIG_EARLY_PRINTK=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_DMI=y
CONFIG_AUDIT_ARCH=y
CONFIG_GENERIC_BUG=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# Code maturity level options
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32

#
# General setup
#
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SWAP_PREFETCH=y
CONFIG_SYSVIPC=y
CONFIG_IPC_NS=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set
CONFIG_UTS_NS=y
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
# CONFIG_CPUSETS is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SHMEM=y
CONFIG_SLAB=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
# CONFIG_SLOB is not set

#
# Loadable module support
#
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y

#
# Block layer
#
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_IO_TRACE is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"

#
# Processor type and features
#
CONFIG_X86_PC=y
# CONFIG_X86_VSMP is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_TSC=y
CONFIG_X86_GOOD_APIC=y
CONFIG_MICROCODE=m
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_X86_HT=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_MTRR=y
CONFIG_SMP=y
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_BKL=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_NR_CPUS=8
# CONFIG_HOTPLUG_CPU is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_SWIOTLB=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250_NODEFAULT is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_REORDER=y
CONFIG_K8_NB=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_ISA_DMA_API=y
CONFIG_GENERIC_PENDING_IRQ=y

#
# Power management options
#
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
# CONFIG_PM_SYSFS_DEPRECATED is not set

#
# ACPI (Advanced Configuration and Power Interface) Support
#
CONFIG_ACPI=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_HOTKEY=m
CONFIG_ACPI_FAN=m
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_THERMAL=m
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_IBM is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=m
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_ACPI_CPUFREQ=m

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
# CONFIG_X86_SPEEDSTEP_LIB is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=m
# CONFIG_HOTPLUG_PCI_PCIE_POLL_EVENT_MODE is not set
CONFIG_PCIEAER=y
CONFIG_PCI_MSI=y
CONFIG_HT_IRQ=y

#
# PCCARD (PCMCIA/CardBus) support
#
# CONFIG_PCCARD is not set

#
# PCI Hotplug Support
#
CONFIG_HOTPLUG_PCI=m
# CONFIG_HOTPLUG_PCI_FAKE is not set
CONFIG_HOTPLUG_PCI_ACPI=m
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=m
CONFIG_COMPAT=y
CONFIG_SYSVIPC_COMPAT=y

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
# CONFIG_NETDEBUG is not set
CONFIG_PACKET=m
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=m
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_NET_KEY=m
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
# CONFIG_IP_PIMSM_V1 is not set
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=m
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
# CONFIG_DEFAULT_BIC is not set
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
CONFIG_DEFAULT_RENO=y
CONFIG_DEFAULT_TCP_CONG="reno"
CONFIG_TCP_MD5SIG=y

#
# IP: Virtual Server Configuration
#
# CONFIG_IP_VS is not set
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=y
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK_ENABLED=m
CONFIG_NF_CONNTRACK_SUPPORT=y
# CONFIG_IP_NF_CONNTRACK_SUPPORT is not set
CONFIG_NF_CONNTRACK=m
# CONFIG_NF_CT_ACCT is not set
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_IPRANGE=m
CONFIG_IP_NF_MATCH_TOS=m
CONFIG_IP_NF_MATCH_RECENT=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_MATCH_OWNER=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_IP_NF_TARGET_TCPMSS=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_SAME=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_TOS=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m
CONFIG_IP_NF_MATCH_IPP2P=m

#
# IPv6: Netfilter Configuration (EXPERIMENTAL)
#
CONFIG_NF_CONNTRACK_IPV6=m
# CONFIG_IP6_NF_QUEUE is not set
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_OWNER=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_RAW=m

#
# Bridge: Netfilter Configuration
#
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=m

#
# DCCP Configuration (EXPERIMENTAL)
#
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m
CONFIG_IP_DCCP_ACKVEC=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
CONFIG_IP_DCCP_CCID2=m
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=m
CONFIG_IP_DCCP_TFRC_LIB=m
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_CCID3_RTO=100

#
# SCTP Configuration (EXPERIMENTAL)
#
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
CONFIG_SCTP_HMAC_SHA1=y
# CONFIG_SCTP_HMAC_MD5 is not set

#
# TIPC Configuration (EXPERIMENTAL)
#
CONFIG_TIPC=m
# CONFIG_TIPC_ADVANCED is not set
# CONFIG_TIPC_DEBUG is not set
# CONFIG_ATM is not set
CONFIG_BRIDGE=m
CONFIG_VLAN_8021Q=m
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set

#
# QoS and/or fair queueing
#
# CONFIG_NET_SCHED is not set
CONFIG_NET_CLS_ROUTE=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_IEEE80211 is not set
CONFIG_FIB_RULES=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=m
# CONFIG_SYS_HYPERVISOR is not set

#
# Connector - unified userspace <-> kernelspace linker
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y

#
# Memory Technology Devices (MTD)
#
# CONFIG_MTD is not set

#
# Parallel port support
#
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y

#
# Plug and Play support
#
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Block devices
#
CONFIG_BLK_DEV_FD=m
# CONFIG_PARIDE is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
CONFIG_BLK_DEV_INITRD=y
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=m

#
# Misc devices
#
# CONFIG_IBM_ASM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_MSI_LAPTOP is not set

#
# ATA/ATAPI/MFM/RLL support
#
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
# CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set

#
# SCSI low-level drivers
#
CONFIG_ISCSI_TCP=m
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set

#
# Serial ATA (prod) and Parallel ATA (experimental) drivers
#
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_SATA_AHCI=m
# CONFIG_SATA_SVW is not set
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
CONFIG_PATA_JMICRON=m
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# Multi-device support (RAID and LVM)
#
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_RAID5_RESHAPE=y
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_EMC=m

#
# Fusion MPT device support
#
# CONFIG_FUSION is not set
# CONFIG_FUSION_SPI is not set
# CONFIG_FUSION_FC is not set
# CONFIG_FUSION_SAS is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_IEEE1394=m

#
# Subsystem Options
#
# CONFIG_IEEE1394_VERBOSEDEBUG is not set
# CONFIG_IEEE1394_OUI_DB is not set
CONFIG_IEEE1394_EXTRA_CONFIG_ROMS=y
CONFIG_IEEE1394_CONFIG_ROM_IP1394=y
CONFIG_IEEE1394_EXPORT_FULL_API=y

#
# Device Drivers
#
CONFIG_IEEE1394_PCILYNX=m
CONFIG_IEEE1394_OHCI1394=m

#
# Protocol Drivers
#
CONFIG_IEEE1394_VIDEO1394=m
CONFIG_IEEE1394_SBP2=m
CONFIG_IEEE1394_ETH1394=m
CONFIG_IEEE1394_DV1394=m
CONFIG_IEEE1394_RAWIO=m

#
# I2O device support
#
# CONFIG_I2O is not set

#
# Network device support
#
CONFIG_NETDEVICES=y
# CONFIG_DUMMY is not set
CONFIG_BONDING=m
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
# CONFIG_NET_SB1000 is not set

#
# ARCnet devices
#
# CONFIG_ARCNET is not set

#
# PHY device support
#

#
# Ethernet (10 or 100Mbit)
#
# CONFIG_NET_ETHERNET is not set
CONFIG_MII=m

#
# Ethernet (1000 Mbit)
#
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
CONFIG_SKY2=m
# CONFIG_SK98LIN is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set

#
# Ethernet (10000 Mbit)
#
# CONFIG_CHELSIO_T1 is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set

#
# Token Ring devices
#
# CONFIG_TR is not set

#
# Wireless LAN (non-hamradio)
#
# CONFIG_NET_RADIO is not set

#
# Wan interfaces
#
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PLIP is not set
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
# CONFIG_SLIP is not set
CONFIG_SLHC=m
# CONFIG_NET_FC is not set
# CONFIG_SHAPER is not set
CONFIG_NETCONSOLE=m
CONFIG_NETPOLL=y
CONFIG_NETPOLL_RX=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y

#
# ISDN subsystem
#
# CONFIG_ISDN is not set

#
# Telephony Support
#
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1280
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=1024
CONFIG_INPUT_JOYDEV=m
# CONFIG_INPUT_TSDEV is not set
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=m
CONFIG_JOYSTICK_IFORCE_USB=y
# CONFIG_JOYSTICK_IFORCE_232 is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_DB9=m
# CONFIG_JOYSTICK_GAMECON is not set
# CONFIG_JOYSTICK_TURBOGRAFX is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
CONFIG_INPUT_UINPUT=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_GAMEPORT=m
# CONFIG_GAMEPORT_NS558 is not set
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=2
CONFIG_SERIAL_8250_RUNTIME_UARTS=2
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
# CONFIG_TIPAR is not set

#
# IPMI
#
# CONFIG_IPMI_HANDLER is not set

#
# Watchdog Cards
#
# CONFIG_WATCHDOG is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_RTC=y
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=m
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_DRM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
# CONFIG_HPET_RTC_IRQ is not set
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set

#
# TPM devices
#
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set

#
# I2C support
#
CONFIG_I2C=y
CONFIG_I2C_CHARDEV=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=m
# CONFIG_I2C_I810 is not set
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_ISA=m
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PARPORT is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_PROSAVAGE is not set
# CONFIG_I2C_SAVAGE4 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set
# CONFIG_I2C_VOODOO3 is not set
# CONFIG_I2C_PCA_ISA is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_SENSORS_DS1337 is not set
# CONFIG_SENSORS_DS1374 is not set
CONFIG_SENSORS_EEPROM=m
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set

#
# Dallas's 1-wire bus
#
# CONFIG_W1 is not set

#
# Hardware Monitoring support
#
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Multimedia devices
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_VIDEO_V4L2=y

#
# Video Capture Adapters
#

#
# Video Capture Adapters
#
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9840=m
CONFIG_VIDEO_TDA9875=m
CONFIG_VIDEO_TEA6415C=m
CONFIG_VIDEO_TEA6420=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_BT819=m
CONFIG_VIDEO_BT856=m
CONFIG_VIDEO_KS0127=m
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_SAA7110=m
CONFIG_VIDEO_SAA7111=m
CONFIG_VIDEO_SAA7114=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_TVP5150=m
CONFIG_VIDEO_VPX3220=m
CONFIG_VIDEO_CX25840=m
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_SAA7185=m
CONFIG_VIDEO_ADV7170=m
CONFIG_VIDEO_ADV7175=m
CONFIG_VIDEO_VIVI=m
CONFIG_VIDEO_BT848=m
CONFIG_VIDEO_BT848_DVB=y
CONFIG_VIDEO_SAA6588=m
CONFIG_VIDEO_BWQCAM=m
CONFIG_VIDEO_CQCAM=m
CONFIG_VIDEO_W9966=m
CONFIG_VIDEO_CPIA=m
# CONFIG_VIDEO_CPIA_PP is not set
CONFIG_VIDEO_CPIA_USB=m
CONFIG_VIDEO_CPIA2=m
CONFIG_VIDEO_SAA5246A=m
CONFIG_VIDEO_SAA5249=m
CONFIG_TUNER_3036=m
CONFIG_VIDEO_STRADIS=m
CONFIG_VIDEO_ZORAN_ZR36060=m
CONFIG_VIDEO_ZORAN=m
CONFIG_VIDEO_ZORAN_BUZ=m
CONFIG_VIDEO_ZORAN_DC10=m
CONFIG_VIDEO_ZORAN_DC30=m
CONFIG_VIDEO_ZORAN_LML33=m
CONFIG_VIDEO_ZORAN_LML33R10=m
CONFIG_VIDEO_ZORAN_AVS6EYES=m
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_VIDEO_SAA7134_DVB=m
CONFIG_VIDEO_MXB=m
CONFIG_VIDEO_DPC=m
CONFIG_VIDEO_HEXIUM_ORION=m
CONFIG_VIDEO_HEXIUM_GEMINI=m
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_VP3054=m
CONFIG_VIDEO_CAFE_CCIC=m

#
# V4L USB devices
#
CONFIG_VIDEO_PVRUSB2=m
# CONFIG_VIDEO_PVRUSB2_29XXX is not set
CONFIG_VIDEO_PVRUSB2_24XXX=y
CONFIG_VIDEO_PVRUSB2_SYSFS=y
# CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
CONFIG_VIDEO_EM28XX=m
CONFIG_VIDEO_USBVISION=m
CONFIG_VIDEO_USBVIDEO=m
CONFIG_USB_VICAM=m
CONFIG_USB_IBMCAM=m
CONFIG_USB_KONICAWC=m
CONFIG_USB_QUICKCAM_MESSENGER=m
CONFIG_USB_ET61X251=m
CONFIG_VIDEO_OVCAMCHIP=m
CONFIG_USB_W9968CF=m
CONFIG_USB_OV511=m
CONFIG_USB_SE401=m
CONFIG_USB_SN9C102=m
CONFIG_USB_STV680=m
CONFIG_USB_ZC0301=m
CONFIG_USB_PWC=m
# CONFIG_USB_PWC_DEBUG is not set

#
# Radio Adapters
#
# CONFIG_RADIO_GEMTEK_PCI is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_MAESTRO is not set
CONFIG_USB_DSBR=m

#
# Digital Video Broadcasting Devices
#
CONFIG_DVB=y
CONFIG_DVB_CORE=m
# CONFIG_DVB_CORE_ATTACH is not set

#
# Supported SAA7146 based PCI Adapters
#
# CONFIG_DVB_AV7110 is not set
# CONFIG_DVB_BUDGET is not set
# CONFIG_DVB_BUDGET_CI is not set
# CONFIG_DVB_BUDGET_AV is not set

#
# Supported USB Adapters
#
CONFIG_DVB_USB=m
# CONFIG_DVB_USB_DEBUG is not set
CONFIG_DVB_USB_A800=m
CONFIG_DVB_USB_DIBUSB_MB=m
# CONFIG_DVB_USB_DIBUSB_MB_FAULTY is not set
CONFIG_DVB_USB_DIBUSB_MC=m
CONFIG_DVB_USB_DIB0700=m
CONFIG_DVB_USB_UMT_010=m
CONFIG_DVB_USB_CXUSB=m
CONFIG_DVB_USB_DIGITV=m
CONFIG_DVB_USB_VP7045=m
CONFIG_DVB_USB_VP702X=m
CONFIG_DVB_USB_GP8PSK=m
CONFIG_DVB_USB_NOVA_T_USB2=m
CONFIG_DVB_USB_TTUSB2=m
CONFIG_DVB_USB_DTT200U=m
CONFIG_DVB_TTUSB_BUDGET=m
CONFIG_DVB_TTUSB_DEC=m
CONFIG_DVB_CINERGYT2=m
# CONFIG_DVB_CINERGYT2_TUNING is not set

#
# Supported FlexCopII (B2C2) Adapters
#
CONFIG_DVB_B2C2_FLEXCOP=m
# CONFIG_DVB_B2C2_FLEXCOP_PCI is not set
CONFIG_DVB_B2C2_FLEXCOP_USB=m
# CONFIG_DVB_B2C2_FLEXCOP_DEBUG is not set

#
# Supported BT878 Adapters
#
CONFIG_DVB_BT8XX=m

#
# Supported Pluto2 Adapters
#
CONFIG_DVB_PLUTO2=m

#
# Supported DVB Frontends
#

#
# Customise DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_STV0299=m
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_MT312=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_TDA10086=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m

#
# Tuners/PLL support
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUNER_MT2060=m
CONFIG_DVB_TUNER_LGH06XF=m

#
# Miscellaneous devices
#
CONFIG_DVB_LNBP21=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_TUA6100=m
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_VIDEO_VIDEOBUF=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_BUF=m
CONFIG_VIDEO_BUF_DVB=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_USB_DABUSB=m

#
# Graphics support
#
CONFIG_FIRMWARE_EDID=y
CONFIG_FB=m
# CONFIG_FB_DDC is not set
# CONFIG_FB_CFB_FILLRECT is not set
# CONFIG_FB_CFB_COPYAREA is not set
# CONFIG_FB_CFB_IMAGEBLIT is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=m
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y

#
# Logo configuration
#
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_BACKLIGHT_DEVICE=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_DEVICE=y

#
# Sound
#
CONFIG_SOUND=m

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_RTCTIMER=m
CONFIG_SND_SEQ_RTCTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
CONFIG_SND_MPU401_UART=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
CONFIG_SND_MTS64=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m

#
# PCI devices
#
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
CONFIG_SND_EMU10K1=m
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_AC97_POWER_SAVE is not set

#
# USB devices
#
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_USX2Y=m

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m

#
# HID Devices
#
CONFIG_HID=m

#
# USB support
#
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_BANDWIDTH=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_SPLIT_ISO=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=m
# CONFIG_USB_SL811_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_DPCM=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_KARMA=y
# CONFIG_USB_LIBUSUAL is not set

#
# USB Input Devices
#
CONFIG_USB_HID=m
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
CONFIG_HID_FF=y
CONFIG_HID_PID=y
CONFIG_LOGITECH_FF=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_ZEROPLUS_FF=y
CONFIG_USB_HIDDEV=y

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=m
CONFIG_USB_AIPTEK=m
CONFIG_USB_WACOM=m
CONFIG_USB_ACECAD=m
CONFIG_USB_KBTAB=m
CONFIG_USB_POWERMATE=m
CONFIG_USB_TOUCHSCREEN=m
CONFIG_USB_TOUCHSCREEN_EGALAX=y
CONFIG_USB_TOUCHSCREEN_PANJIT=y
CONFIG_USB_TOUCHSCREEN_3M=y
CONFIG_USB_TOUCHSCREEN_ITM=y
CONFIG_USB_TOUCHSCREEN_ETURBO=y
CONFIG_USB_TOUCHSCREEN_GUNZE=y
CONFIG_USB_TOUCHSCREEN_DMC_TSC10=y
CONFIG_USB_YEALINK=m
CONFIG_USB_XPAD=m
CONFIG_USB_ATI_REMOTE=m
CONFIG_USB_ATI_REMOTE2=m
CONFIG_USB_KEYSPAN_REMOTE=m
CONFIG_USB_APPLETOUCH=m

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET_MII=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_NET_ZAURUS=m
CONFIG_USB_MON=y

#
# USB port drivers
#
CONFIG_USB_USS720=m

#
# USB Serial Converter support
#
CONFIG_USB_SERIAL=m
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_AIRPRIME is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP2101 is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_FUNSOFT is not set
CONFIG_USB_SERIAL_VISOR=m
# CONFIG_USB_SERIAL_IPAQ is not set
CONFIG_USB_SERIAL_IR=m
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
CONFIG_USB_SERIAL_KOBIL_SCT=m
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
CONFIG_USB_SERIAL_NAVMAN=m
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_HP4X is not set
# CONFIG_USB_SERIAL_SAFE is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
CONFIG_USB_SERIAL_OPTION=m
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
CONFIG_USB_AUERSWALD=m
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
# CONFIG_USB_PHIDGET is not set
CONFIG_USB_IDMOUSE=m
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
# CONFIG_USB_TEST is not set

#
# USB DSL modem support
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set

#
# MMC/SD Card support
#
# CONFIG_MMC is not set

#
# LED devices
#
# CONFIG_NEW_LEDS is not set

#
# LED drivers
#

#
# LED Triggers
#

#
# InfiniBand support
#
# CONFIG_INFINIBAND is not set

#
# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
#
# CONFIG_EDAC is not set

#
# Real Time Clock
#
# CONFIG_RTC_CLASS is not set

#
# DMA Engine support
#
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y

#
# DMA Devices
#
# CONFIG_INTEL_IOATDMA is not set

#
# Virtualization
#
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set

#
# File systems
#
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
# CONFIG_EXT2_FS_POSIX_ACL is not set
# CONFIG_EXT2_FS_SECURITY is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=m
CONFIG_EXT3_FS_XATTR=y
# CONFIG_EXT3_FS_POSIX_ACL is not set
# CONFIG_EXT3_FS_SECURITY is not set
CONFIG_EXT4DEV_FS=m
CONFIG_EXT4DEV_FS_XATTR=y
# CONFIG_EXT4DEV_FS_POSIX_ACL is not set
# CONFIG_EXT4DEV_FS_SECURITY is not set
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
# CONFIG_REISERFS_FS_POSIX_ACL is not set
# CONFIG_REISERFS_FS_SECURITY is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
CONFIG_DNOTIFY=y
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_ZISOFS_FS=m
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_RAMFS=y
CONFIG_CONFIGFS_FS=m

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=m
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=y
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set

#
# Network File Systems
#
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFS_DIRECTIO=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_TCP=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_RPCSEC_GSS_SPKM3=m
CONFIG_SMB_FS=m
# CONFIG_SMB_NLS_DEFAULT is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_EXPERIMENTAL=y
CONFIG_CIFS_UPCALL=y
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
# CONFIG_9P_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_BSD_DISKLABEL is not set
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y

#
# Native Language Support
#
CONFIG_NLS=m
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=m

#
# Distributed Lock Manager
#
CONFIG_DLM=m
# CONFIG_DLM_TCP is not set
CONFIG_DLM_SCTP=y
# CONFIG_DLM_DEBUG is not set

#
# Instrumentation Support
#
# CONFIG_PROFILING is not set
# CONFIG_KPROBES is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
CONFIG_LOG_BUF_SHIFT=15
CONFIG_DEBUG_BUGVERBOSE=y

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set

#
# Cryptographic options
#
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_HASH=m
CONFIG_CRYPTO_MANAGER=m
CONFIG_CRYPTO_HMAC=m
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_TEST is not set

#
# Hardware crypto devices
#

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC32=y
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_PLIST=y
CONFIG_IOMAP_COPY=y

--Boundary-01=_aOE4Fg+h7G3TKF5--

--nextPart1724325.uZWDxcLTc1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBF4EOd4q3E2oMjYtURAkaAAKCSbvZAKhMcKg7bh5UJEQ7gUfwMFACePvQL
PNXuRExzmOQ8KNZwrj6ZvaI=
=LRvP
-----END PGP SIGNATURE-----

--nextPart1724325.uZWDxcLTc1--
