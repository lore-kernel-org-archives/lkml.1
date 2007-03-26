Return-Path: <linux-kernel-owner+w=401wt.eu-S933584AbXCZWm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933584AbXCZWm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 18:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932619AbXCZWm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 18:42:58 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48710 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933584AbXCZWm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 18:42:57 -0400
Subject: Re: 2.6.21-rc4-mm1
From: Badari Pulavarty <pbadari@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Con Kolivas <kernel@kolivas.org>
In-Reply-To: <20070326152249.1d31458f.akpm@linux-foundation.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	 <1174946277.16728.14.camel@dyn9047017100.beaverton.ibm.com>
	 <20070326152249.1d31458f.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 26 Mar 2007 15:43:00 -0800
Message-Id: <1174952580.16728.16.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-26 at 15:22 -0700, Andrew Morton wrote:
..
> > Unable to handle kernel NULL pointer dereference at 0000000000000020
> > RIP:
> >  [<ffffffff804ec090>] __sched_text_start+0x460/0x889
> > PGD 1c1898067 PUD 1c1897067 PMD 0
> > Oops: 0000 [1] SMP
> > last sysfs file: block/hda/range
> > CPU 3
> > Modules linked in:
> > Pid: 900, comm: boot Not tainted 2.6.21-rc4-mm1 #1
> > RIP: 0010:[<ffffffff804ec090>]  [<ffffffff804ec090>] __sched_text_start
> 
> This is a very popular oops, caused by the rsdl scheduler.  I don't _think_
> we yet know exactly why it is happening.  Con, did you get to the bottom
> of this?
> 
> We don't know why it confused kallsyms either.
> 
> I'll try to shove rc5-mm1 out the door this evening, minus rsdl.  And
> -mm2, with rsdl.

Okay, my ppc64 box hangs on boot. It could be different. I will wait
till rc5-mm1 for debugging that one.

Thanks,
Badari

...
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
ReiserFS: sda2: found reiserfs format "3.6" with standard journal
ReiserFS: sda2: using ordered data mode
ReiserFS: sda2: journal params: device sda2, size 8192, journal first
block 18, max trans len 1024, max batch 900, max commit age 30, max
trans age 30
ReiserFS: sda2: checking transaction log (sda2)
ReiserFS: sda2: Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem) readonly.
Freeing unused kernel memory: 272k freed
Warning: unable to open an initial console.
ioctl32(showconsole:1020): Unknown cmd fd(0) cmd(40045432){00} arg
(ffecdb48) on /dev/tty0
ioctl32(showconsole:1048): Unknown cmd fd(0) cmd(40045432){00} arg
(ffb4aad8) on /dev/tty0
PDC20275: IDE controller at PCI slot 0002:d0:01.0
PDC20275: chipset revision 1
PDC20275: PLL input clock is 32814 kHz
PDC20275: 100% native mode on irq 119
    ide2: BM-DMA at 0x2eec00-0x2eec07, BIOS settings: hde:pio, hdf:pio
    ide3: BM-DMA at 0x2eec08-0x2eec0f, BIOS settings: hdg:pio, hdh:pio
scsi 0:0:15:0: Attached scsi generic sg0 type 13
scsi 0:255:255:255: Attached scsi generic sg1 type 31
sd 1:0:4:0: Attached scsi generic sg2 type 0
sd 1:0:5:0: Attached scsi generic sg3 type 0
scsi 1:0:15:0: Attached scsi generic sg4 type 13
scsi 1:255:255:255: Attached scsi generic sg5 type 31
hde: IBM DROM00205, ATAPI CD/DVD-ROM drive
ide2 at 0x2ee400-0x2ee407,0x2edc02 on irq 119
hde: ATAPI 24X DVD-ROM drive, 256kB Cache
Uniform CD-ROM driver Revision: 3.20
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-
devel@redhat.com
ioctl32(showconsole:1918): Unknown cmd fd(0) cmd(40045432){00} arg
(fff00ad8) on /dev/tty0
loop: loaded (max 8 devices)
ioctl32(showconsole:2091): Unknown cmd fd(0) cmd(40045432){00} arg
(fff71ae8) on /dev/tty0
Adding 1050616k swap on /dev/sdb2.  Priority:-1 extents:1
across:1050616k
ioctl32(showconsole:2137): Unknown cmd fd(0) cmd(40045432){00} arg
(ffdd7b28) on /dev/tty0
e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex, Flow
Control: RX
audit(1174945021.442:2): audit_pid=2735 old=0 by auid=4294967295


