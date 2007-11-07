Return-Path: <linux-kernel-owner+w=401wt.eu-S1757258AbXKGQGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258AbXKGQGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 11:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbXKGQGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 11:06:25 -0500
Received: from usermail.globalproof.net ([194.146.153.18]:56386 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbXKGQGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 11:06:23 -0500
From: "Denys Fedoryshchenko" <denys@visp.net.lb>
To: James Andrewartha <jamesa@daa.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, alan@lxorguk.ukuu.org.uk, htejun@gmail.com
Subject: Re: SC1200 failure in 2.6.23 and 2.6.24-rc1-git10
Date: Wed, 7 Nov 2007 18:06:08 +0200
Message-Id: <20071107160426.M31617@visp.net.lb>
In-Reply-To: <4731D85E.70201@daa.com.au>
References: <20071101213013.M54162@visp.net.lb> <20071106221521.4f64a066.akpm@linux-foundation.org> <20071107132630.M65286@visp.net.lb> <4731D85E.70201@daa.com.au>
X-Mailer: OpenWebMail 2.52 20060502
X-OriginatingIP: 195.69.208.251 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Nov 2007 00:23:10 +0900, James Andrewartha wrote
> Denys Fedoryshchenko wrote:
> > On Tue, 6 Nov 2007 22:15:21 -0800, Andrew Morton wrote
> >>> On Thu, 1 Nov 2007 23:30:13 +0200 "Denys" <denys@visp.net.lb> wrote:
> >>> Finally i got full DMESG with 1GB card till end. Seems not readable too.
> >>> scsi0 : sc1200
> >>> scsi1 : sc1200
> >>> ata1: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 irq 14
> >>> ata2: DUMMY
> >>> ata1.00: CFA: SanDisk SDCFH-1024, HDX 3.07, max MWDMA2
> >>> ata1.00: 2001888 sectors, multi 0: LBA
> >>> ata1.00: configured for MWDMA2
> >>> scsi 0:0:0:0: Direct-Access     ATA      SanDisk SDCFH-10 HDX  PQ: 0 
> > ANSI: 5
> >>> sd 0:0:0:0: [sda] 2001888 512-byte hardware sectors (1025 MB)
> >>> sd 0:0:0:0: [sda] Write Protect is off
> >>> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
> > support 
> >>> DPO or FUA
> >>> sd 0:0:0:0: [sda] 2001888 512-byte hardware sectors (1025 MB)
> >>> sd 0:0:0:0: [sda] Write Protect is off
> >>> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
> > support 
> >>> DPO or FUA
> >>>  sda:<4>Clocksource tsc unstable (delta = -334501841 ns)
> >>> Time: pit clocksource has been installed.
> >>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> >>> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 
4096 
> > in
> >>>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> >>> ata1.00: status: { DRDY }
> >>> ata1: soft resetting link
> >>> ata1.00: configured for MWDMA2
> >>> ata1: EH complete
> >>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> >>> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 
4096 
> > in
> >>>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> >>> ata1.00: status: { DRDY }
> >>> ata1: soft resetting link
> >>> ata1.00: configured for MWDMA2
> >>> ata1: EH complete
> >>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> >>> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 
4096 
> > in
> >>>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> >>> ata1.00: status: { DRDY }
> >>> ata1: soft resetting link
> >>> ata1.00: configured for MWDMA2
> >>> ata1: EH complete
> >>> ata1.00: limiting speed to MWDMA1:PIO4
> >>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> >>> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 
4096 
> > in
> >>>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> >>> ata1.00: status: { DRDY }
> >>> ata1: soft resetting link
> >>> ata1.00: configured for MWDMA1
> >>> ata1: EH complete
> >>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> >>> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 
4096 
> > in
> >>>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> >>> ata1.00: status: { DRDY }
> >>> ata1: soft resetting link
> >>> ata1.00: configured for MWDMA1
> >>> ata1: EH complete
> >>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> >>> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 
4096 
> > in
> >>>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> >>> ata1.00: status: { DRDY }
> >>> ata1: soft resetting link
> >>> ata1.00: configured for MWDMA1
> >>> sd 0:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
> >>> sd 0:0:0:0: [sda] Sense Key : 0xb [current] [descriptor]
> >>> Descriptor sense data with sense descriptors (in hex):
> >>>         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
> >>>         00 00 00 00
> >>> sd 0:0:0:0: [sda] ASC=0x0 ASCQ=0x0
> >>> end_request: I/O error, dev sda, sector 0
> >>> Buffer I/O error on device sda, logical block 0
> >>> ata1: EH complete
> >>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> >>> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 
4096 
> > in
> >>>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> >>> ata1.00: status: { DRDY }
> >>> ata1: soft resetting link
> >>> ata1.00: configured for MWDMA1
> >>> ata1: EH complete
> >>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> >>> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 
4096 
> > in
> >>>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> >>> ata1.00: status: { DRDY }
> >>> ata1: soft resetting link
> >>> ata1.00: configured for MWDMA1
> >>> ata1: EH complete
> >>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> >>> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 
4096 
> > in
> >>>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> >>> ata1.00: status: { DRDY }
> >>> ata1: soft resetting link
> >>> ata1.00: configured for MWDMA1
> >>> ata1: EH complete
> >>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> >>> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 
4096 
> > in
> >>>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> >>> ata1.00: status: { DRDY }
> >>> ata1: soft resetting link
> >>> ata1.00: configured for MWDMA1
> >>> ata1: EH complete
> >>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> >>> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 
4096 
> > in
> >>>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> >>> ata1.00: status: { DRDY }
> >>> ata1: soft resetting link
> >>> ata1.00: configured for MWDMA1
> >>> ata1: EH complete
> >>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> >>> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 
4096 
> > in
> >>>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> >>> ata1.00: status: { DRDY }
> >>> ata1: soft resetting link
> >>> ata1.00: configured for MWDMA1
> >>> sd 0:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
> >>> sd 0:0:0:0: [sda] Sense Key : 0xb [current] [descriptor]
> >>> Descriptor sense data with sense descriptors (in hex):
> >>>         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
> >>>         00 00 00 00
> >>> sd 0:0:0:0: [sda] ASC=0x0 ASCQ=0x0
> >>> end_request: I/O error, dev sda, sector 0
> >>> Buffer I/O error on device sda, logical block 0
> >>> ata1: EH complete
> >>>  unable to read partition table
> >>> sd 0:0:0:0: [sda] Attached SCSI removable disk
> >>> scx200_wdt: timer margin 60 seconds
> >>> cpuidle: using governor ladder
> >>> enabling scx200 high-res timer (1 MHz +0 ppm)
> >>> TCP cubic registered
> >>> Time: scx200_hrt clocksource has been installed.
> >>> NET: Registered protocol family 1
> >>> NET: Registered protocol family 17
> >>> Using IPI Shortcut mode
> >>> VFS: Cannot open root device "<NULL>" or unknown-block(8,18)
> >>> Please append a correct "root=" boot option; here are the available 
> >>> partitions:
> >>> 0800    1000944 sda driver: sd
> >>> Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-
> >>> block(8,18)
> >>>
> >> (+linux-ide)
> (+alan, tejun)
> >> So this has never worked on any known kernel?
> > 
> > It is working now on old ide code (not libata).
> 
> Can you post the dmesg and hdparm -I of a working boot using the old 
> ide code? The thing that stuck out to me (as just a reader of linux-
> ide) was that the problem involves MWDMA and CF, which have had 
> problems (although not the same as this one) in the past: 
> http://thread.gmane.org/gmane.linux.ide/22058 and http://thread.gmane.org/
gmane.linux.ide/22400
> 
> -- 
> James Andrewartha
WRAP ~ #./hdparm -I /dev/hda

/dev/hda:

ATAPI Write-once device, with non-removable media
        Model Number:       SanDisk SDP3B-16
        Serial Number:      24313671615
        Firmware Revision:  vdd 1.00
Standards:
        Likely used: 3
Configuration:
        DRQ response: 50us.
        Packet size: Unknown
Capabilities:
        LBA, IORDY(may be)(cannot be disabled)
        Buffer size: 1.0kB      bytes avail on r/w long: 4
        DMA: not supported
        PIO: pio0 pio1


Now it is linux-2.6.24-rc1 from wireless-2.6 git (just testing)
All messages about IDE very similar to 2.6.24-rc2 (tested too)

    0.000000] Linux version 2.6.24-rc1-embedded-g09bbb0a3-dirty 
(root@homecore.visp.net.lb) (gcc version 4.1.2 (Gentoo 4.1.2 p1.0.1)) #8 Wed 
Nov 7 04:23:31 EET 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e801: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e801: 0000000000100000 - 0000000004000000 (usable)
[    0.000000] 64MB LOWMEM available.
[    0.000000] Entering add_active_range(0, 0, 16384) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->    16384
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->    16384
[    0.000000] On node 0 totalpages: 16384
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 96 pages used for memmap
[    0.000000]   Normal zone: 12192 pages, LIFO batch:1
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI not present or invalid.
[    0.000000] Allocating PCI resources starting at 10000000 (gap: 
04000000:fc000000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total 
pages: 16256
[    0.000000] Kernel command line: console=ttyS0,38400n8 panic=5 reboot=soft 
clocksource=scx200_hrt notsc
[    0.000000] notsc: Kernel compiled with CONFIG_X86_TSC, cannot disable TSC.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 256 (order: 8, 1024 bytes)
[    0.000000] Detected 266.627 MHz processor.
[    6.146789] Console: colour dummy device 80x25
[    6.146884] console [ttyS0] enabled
[    6.493841] Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
[    6.514729] Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
[    6.553125] Memory: 61992k/65536k available (1113k kernel code, 3136k 
reserved, 454k data, 680k init, 0k highmem)
[    6.584035] virtual kernel memory layout:
[    6.584060]     fixmap  : 0xffffb000 - 0xfffff000   (  16 kB)
[    6.584092]     vmalloc : 0xc4800000 - 0xffff9000   ( 951 MB)
[    6.584124]     lowmem  : 0xc0000000 - 0xc4000000   (  64 MB)
[    6.584157]       .init : 0xc028c000 - 0xc0336000   ( 680 kB)
[    6.584190]       .data : 0xc0216775 - 0xc028824c   ( 454 kB)
[    6.584222]       .text : 0xc0100000 - 0xc0216775   (1113 kB)
[    6.699565] Checking if this processor honours the WP bit even in 
supervisor mode... Ok.
[    6.724157] SLUB: Genslabs=11, HWalign=32, Order=0-1, MinObjects=4, 
CPUs=1, Nodes=1
[    6.827181] Calibrating delay using timer specific routine.. 534.53 
BogoMIPS (lpj=1069066)
[    6.852327] Mount-cache hash table entries: 512
[    6.867065] CPU: After generic identify, caps: 00808131 01818131 00000000 
00000000 00000000 00000000 00000000 00000000
[    6.867249] CPU: After all inits, caps: 00808131 00818131 00000000 
00000001 00000000 00000000 00000000 00000000
[    6.867402] Compat vDSO mapped to ffffe000.
[    6.880052] CPU: NSC Unknown stepping 01
[    6.892089] Checking 'hlt' instruction... OK.
[    6.905494] Freeing SMP alternatives: 0k freed
[    6.921472] net_namespace: 64 bytes
[    6.937068] NET: Registered protocol family 16
[    6.955287] PCI: PCI BIOS revision 2.10 entry at 0xfc3ad, last bus=0
[    6.974479] PCI: Using configuration type 1
[    6.987082] Setting up standard PCI resources
[    7.012835] SCSI subsystem initialized
[    7.024946] PCI: Probing PCI hardware
[    7.036044] PCI: Probing PCI hardware (bus 00)
[    7.044386] PCI: Device 0000:00:12.5 not found by BIOS
[    7.064960] Time: tsc clocksource has been installed.
[    7.084872] NET: Registered protocol family 2
[    7.099253] IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
[    7.122746] TCP established hash table entries: 2048 (order: 2, 16384 
bytes)
[    7.144139] TCP bind hash table entries: 2048 (order: 1, 8192 bytes)
[    7.163374] TCP: Hash tables configured (established 2048 bind 2048)
[    7.182494] TCP reno registered
[    7.545264] apm: BIOS not found.
[    7.555735] scx200: NatSemi SCx200 Driver
[    7.568689] scx200: GPIO base 0xf400
[    7.579604] scx200: Configuration Block base 0x9000
[    7.598345] io scheduler noop registered (default)
[    8.294143] nsc_gpio initializing
[    8.294203] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ 
sharing disabled
[    8.318680] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a NS16550A
[    8.338718] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
[    8.368801] loop: module loaded
[    8.378981] natsemi dp8381x driver, version 2.1, Sept 11, 2006
[    8.379033]   originally by Donald Becker <becker@scyld.com>
[    8.379074]   2.4.x kernel port by Jeff Garzik, Tjeerd Mulder
[    8.435811] natsemi eth0: NatSemi DP8381[56] at 0x80000000 (0000:00:0e.0), 
00:0d:b9:00:8a:30, IRQ 10, port TP.
[    8.466288] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[    8.485458] ide: Assuming 33MHz system bus speed for PIO modes; override 
with idebus=xx
[    8.510324] SC1200: IDE controller (0x100b:0x0502 rev 0x01) at  PCI slot 
0000:00:12.2
[    8.533951] SC1200: not 100% native mode: will probe irqs later
[    8.551829]     ide0: BM-DMA at 0xfc00-0xfc07, BIOS settings: hda:pio, 
hdb:pio
[    8.573784]     ide1: BM-DMA at 0xfc08-0xfc0f, BIOS settings: hdc:pio, 
hdd:pio
[    8.595746] Probing IDE interface ide0...
[    8.608917] Clocksource tsc unstable (delta = -497090346 ns)
[    8.625999] Time: pit clocksource has been installed.
[    8.644055] hda: SanDisk SDP3B-16, ATA DISK drive
[    8.658485] hda: applying conservative PIO "downgrade"
[    8.674009] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[    8.674264] hda: set_drive_speed_status: status=0x51 { DriveReady 
SeekComplete Error }
[    8.698231] hda: set_drive_speed_status: error=0x04 { DriveStatusError }
[    8.718590] hda: applying conservative PIO "downgrade"
[    8.734085] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[    8.734337] hda: set_drive_speed_status: status=0x51 { DriveReady 
SeekComplete Error }
[    8.758315] hda: set_drive_speed_status: error=0x04 { DriveStatusError }
[    8.778838] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    8.793310] Probing IDE interface ide1...
[    8.807926] hda: max request size: 128KiB
[    8.820076] hda: 31360 sectors (16 MB) w/1KiB Cache, CHS=490/2/32
[    8.838987]  hda: hda1
[    8.851358] scx200_wdt: NatSemi SCx200 Watchdog Driver
[    8.851431] scx200_wdt: timer margin 60 seconds
[    8.865139] scx200_wdt: disabling watchdog timer
[    8.865921] cpuidle: using governor ladder
[    8.878349] cpuidle: using governor menu
[    8.890225] enabling scx200 high-res timer (1 MHz +0 ppm)
[    8.906518] Netfilter messages via NETLINK v0.30.
[    8.920683] Time: scx200_hrt clocksource has been installed.
[    8.937755] Switched to high resolution mode on CPU 0
[    8.952999] TCP cubic registered
[    8.962739] NET: Registered protocol family 1
[    8.975940] NET: Registered protocol family 17
[    8.989342] Using IPI Shortcut mode
[    9.006475] Freeing unused kernel memory: 680k freed
[   10.189658] eth0: DSPCFG accepted after 0 usec.
[   10.203289] eth0: link up.
[   10.211460] eth0: Setting full-duplex based on negotiated link capability.





--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

