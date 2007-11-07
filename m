Return-Path: <linux-kernel-owner+w=401wt.eu-S1757659AbXKGGQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659AbXKGGQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 01:16:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757145AbXKGGQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 01:16:01 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53819 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756575AbXKGGP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 01:15:58 -0500
Date: Tue, 6 Nov 2007 22:15:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Denys" <denys@visp.net.lb>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: SC1200 failure in 2.6.23 and 2.6.24-rc1-git10
Message-Id: <20071106221521.4f64a066.akpm@linux-foundation.org>
In-Reply-To: <20071101213013.M54162@visp.net.lb>
References: <20071101213013.M54162@visp.net.lb>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 1 Nov 2007 23:30:13 +0200 "Denys" <denys@visp.net.lb> wrote:
> Finally i got full DMESG with 1GB card till end. Seems not readable too.
> 
> Linux version 2.6.24-rc1-git10-embedded (root@homecore.visp.net.lb) (gcc 
> version 4.1.2 (Gentoo 4.1.2 p1.0.1)) #1 Thu Nov 1 23:12:53 EET 2007
> BIOS-provided physical RAM map:
>  BIOS-e801: 0000000000000000 - 000000000009f000 (usable)
>  BIOS-e801: 0000000000100000 - 0000000004000000 (usable)
> 64MB LOWMEM available.
> Zone PFN ranges:
>   DMA             0 ->     4096
>   Normal       4096 ->    16384
> Movable zone start PFN for each node
> early_node_map[1] active PFN ranges
>     0:        0 ->    16384
> DMI not present or invalid.
> Allocating PCI resources starting at 10000000 (gap: 04000000:fc000000)
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 16256
> Kernel command line: console=ttyS0,38400n8
> Initializing CPU#0
> PID hash table entries: 256 (order: 8, 1024 bytes)
> Detected 266.627 MHz processor.
> Console: colour dummy device 80x25
> console [ttyS0] enabled
> Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
> Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
> Memory: 62836k/65536k available (1020k kernel code, 2292k reserved, 317k 
> data, 112k init, 0k highmem)
> virtual kernel memory layout:
>     fixmap  : 0xffffb000 - 0xfffff000   (  16 kB)
>     vmalloc : 0xc4800000 - 0xffff9000   ( 951 MB)
>     lowmem  : 0xc0000000 - 0xc4000000   (  64 MB)
>       .init : 0xc0252000 - 0xc026e000   ( 112 kB)
>       .data : 0xc01ff111 - 0xc024e6f4   ( 317 kB)
>       .text : 0xc0100000 - 0xc01ff111   (1020 kB)
> Checking if this processor honours the WP bit even in supervisor mode... Ok.
> SLUB: Genslabs=11, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
> Calibrating delay using timer specific routine.. 534.41 BogoMIPS (lpj=1068836)
> Mount-cache hash table entries: 512
> Compat vDSO mapped to ffffe000.
> CPU: NSC Unknown stepping 01
> Checking 'hlt' instruction... OK.
> Freeing SMP alternatives: 0k freed
> net_namespace: 64 bytes
> NET: Registered protocol family 16
> PCI: PCI BIOS revision 2.10 entry at 0xfc3ad, last bus=0
> PCI: Using configuration type 1
> Setting up standard PCI resources
> SCSI subsystem initialized
> PCI: Probing PCI hardware
> PCI: Device 0000:00:12.5 not found by BIOS
> Time: tsc clocksource has been installed.
> NET: Registered protocol family 2
> IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
> TCP established hash table entries: 2048 (order: 2, 16384 bytes)
> TCP bind hash table entries: 2048 (order: 1, 8192 bytes)
> TCP: Hash tables configured (established 2048 bind 2048)
> TCP reno registered
> scx200: NatSemi SCx200 Driver
> scx200: GPIO base 0xf400
> scx200: Configuration Block base 0x9000
> io scheduler noop registered (default)
> Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
> serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a NS16550A
> serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
> natsemi dp8381x driver, version 2.1, Sept 11, 2006
>   originally by Donald Becker <becker@scyld.com>
>   2.4.x kernel port by Jeff Garzik, Tjeerd Mulder
> natsemi eth0: NatSemi DP8381[56] at 0x80000000 (0000:00:0e.0), 
> 00:0d:b9:00:8a:30, IRQ 10, port TP.
> scsi0 : sc1200
> scsi1 : sc1200
> ata1: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 irq 14
> ata2: DUMMY
> ata1.00: CFA: SanDisk SDCFH-1024, HDX 3.07, max MWDMA2
> ata1.00: 2001888 sectors, multi 0: LBA
> ata1.00: configured for MWDMA2
> scsi 0:0:0:0: Direct-Access     ATA      SanDisk SDCFH-10 HDX  PQ: 0 ANSI: 5
> sd 0:0:0:0: [sda] 2001888 512-byte hardware sectors (1025 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support 
> DPO or FUA
> sd 0:0:0:0: [sda] 2001888 512-byte hardware sectors (1025 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support 
> DPO or FUA
>  sda:<4>Clocksource tsc unstable (delta = -334501841 ns)
> Time: pit clocksource has been installed.
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1.00: status: { DRDY }
> ata1: soft resetting link
> ata1.00: configured for MWDMA2
> ata1: EH complete
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1.00: status: { DRDY }
> ata1: soft resetting link
> ata1.00: configured for MWDMA2
> ata1: EH complete
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1.00: status: { DRDY }
> ata1: soft resetting link
> ata1.00: configured for MWDMA2
> ata1: EH complete
> ata1.00: limiting speed to MWDMA1:PIO4
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1.00: status: { DRDY }
> ata1: soft resetting link
> ata1.00: configured for MWDMA1
> ata1: EH complete
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1.00: status: { DRDY }
> ata1: soft resetting link
> ata1.00: configured for MWDMA1
> ata1: EH complete
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1.00: status: { DRDY }
> ata1: soft resetting link
> ata1.00: configured for MWDMA1
> sd 0:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
> sd 0:0:0:0: [sda] Sense Key : 0xb [current] [descriptor]
> Descriptor sense data with sense descriptors (in hex):
>         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
>         00 00 00 00
> sd 0:0:0:0: [sda] ASC=0x0 ASCQ=0x0
> end_request: I/O error, dev sda, sector 0
> Buffer I/O error on device sda, logical block 0
> ata1: EH complete
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1.00: status: { DRDY }
> ata1: soft resetting link
> ata1.00: configured for MWDMA1
> ata1: EH complete
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1.00: status: { DRDY }
> ata1: soft resetting link
> ata1.00: configured for MWDMA1
> ata1: EH complete
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1.00: status: { DRDY }
> ata1: soft resetting link
> ata1.00: configured for MWDMA1
> ata1: EH complete
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1.00: status: { DRDY }
> ata1: soft resetting link
> ata1.00: configured for MWDMA1
> ata1: EH complete
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1.00: status: { DRDY }
> ata1: soft resetting link
> ata1.00: configured for MWDMA1
> ata1: EH complete
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1.00: status: { DRDY }
> ata1: soft resetting link
> ata1.00: configured for MWDMA1
> sd 0:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
> sd 0:0:0:0: [sda] Sense Key : 0xb [current] [descriptor]
> Descriptor sense data with sense descriptors (in hex):
>         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
>         00 00 00 00
> sd 0:0:0:0: [sda] ASC=0x0 ASCQ=0x0
> end_request: I/O error, dev sda, sector 0
> Buffer I/O error on device sda, logical block 0
> ata1: EH complete
>  unable to read partition table
> sd 0:0:0:0: [sda] Attached SCSI removable disk
> scx200_wdt: timer margin 60 seconds
> cpuidle: using governor ladder
> enabling scx200 high-res timer (1 MHz +0 ppm)
> TCP cubic registered
> Time: scx200_hrt clocksource has been installed.
> NET: Registered protocol family 1
> NET: Registered protocol family 17
> Using IPI Shortcut mode
> VFS: Cannot open root device "<NULL>" or unknown-block(8,18)
> Please append a correct "root=" boot option; here are the available 
> partitions:
> 0800    1000944 sda driver: sd
> Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-
> block(8,18)
> 

(+linux-ide)

So this has never worked on any known kernel?
