Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993AbXGGBpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbXGGBpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 21:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbXGGBpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 21:45:24 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:37211 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbXGGBpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 21:45:23 -0400
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
From: Badari Pulavarty <pbadari@gmail.com>
To: Andrea Arcangeli <andrea@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070706222651.GG5777@v2.random>
References: <20070706222651.GG5777@v2.random>
Content-Type: text/plain; charset=utf-8
Date: Fri, 06 Jul 2007 18:47:01 -0700
Message-Id: <1183772822.21234.29.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-07 at 00:26 +0200, Andrea Arcangeli wrote:
..
> The following simple bench seems to run fine on one real hardware and
> on kvm (a friend of mine failed so far to run it on his hardware
> though, so perhaps some driver triggers some remaining bugs) when
> booted as init=/tmp/bench-static after “cp -a /dev/hda /tmp/”.

Hmm.. I didn't have any luck booting my machine with the patchset 
(with 8k pagesize) :(

It fails to find the partition table on my hard drive.

Thanks,
Badari

....
AMD8111: IDE controller at PCI slot 0000:00:07.1
AMD8111: chipset revision 3
AMD8111: not 100% native mode: will probe irqs later
AMD8111: 0000:00:07.1 (rev 03) UDMA133 controller
    ide0: BM-DMA at 0x1020-0x1027, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0x1028-0x102f, BIOS settings: hdc:DMA, hdd:pio
hda: IC35L080AVVA07-0, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hdc: TOSHIBA DVD-ROM SD-M1612, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 160836480 sectors (82348 MB) w/1863KiB Cache, CHS=65535/16/63, UDMA
(100)
hda: cache flushes supported
 hda: unknown partition table <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
hdc: ATAPI 48X DVD-ROM drive, 512kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 0.99.newide
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
input: PC Speaker as /class/input/input1
input: PS/2 Generic Mouse as /class/input/input2
TCP cubic registered
NET: Registered protocol family 1
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
VFS: Cannot open root device "hda2" or unknown-block(3,2)
Please append a correct "root=" boot option; here are the available
partitions:
0300   80418240 hda driver: ide-disk
1600    4194302 hdc driver: ide-cdrom
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-
block(3,2)


