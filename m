Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbYDWIJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbYDWIJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 04:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbYDWIIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 04:08:51 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:62642 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbYDWIIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 04:08:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KvC266hUI8ccilDpBssSE0+TISX+jjVDino4ZTPLRXdM4aLJBgovCGYf0bmKGGC27KPdcq8r6KfUTaowRa+avLig1e7vDwb3hHSY5j4gveVP8J0Hn7XdUglYwRMMDZD6OCwZEjj/SnnFmtymata12AG7yaZibWYgTvCbRwTUnl4=
Message-ID: <58cb370e0804230108n15553401uae048d325f1403d4@mail.gmail.com>
Date: Wed, 23 Apr 2008 10:08:43 +0200
From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
To: "Dmitri Vorobiev" <dmitri.vorobiev@gmail.com>
Subject: Re: [REGRESSION][linux-next] ide0: failed to initialize IDE interface
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       "John Keller" <jpk@sgi.com>
In-Reply-To: <480E40CA.4020301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <90edad820804220334taea7660n27c3d41e25c4946b@mail.gmail.com>
	 <480E40CA.4020301@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Apr 22, 2008 at 9:47 PM, Dmitri Vorobiev
<dmitri.vorobiev@gmail.com> wrote:
> Ping!
>
>  Having IDE broken in one of my most frequently used test setups is
>  serious enough for me to try to get more attention.
>
>  Anyone among the IDE people has noticed the regression?

I've seen your mail and added it to my TODO.  Unfortunately I'm quite
busy with my real job so I won't have time to take in-depth look into
the issue until the next week.

In the meantime please use a hot-fix posted by John Keller:

http://article.gmane.org/gmane.linux.ide/30860

Thanks,
Bart

>  Thanks,
>  Dmitri
>
>  P.S. I'm not subscribed to linux-ide, so please Cc: me on reply.
>
>
>
>  Dmitri Vorobiev wrote:
>  > Hi Bart,
>  >
>  > I got the following IDE error while trying to boot the linux-next tree
>  > using a Qemu-emulated MIPS Malta board:
>  >
>  > [    0.000000] Linux version 2.6.25 (dmitri.vorobiev@amber.auriga.ru)
>  > (gcc version 3.4.4) #14 PREEMPT Tue Apr 22 13:09:11 MSD 2008
>  > [    0.000000]
>  > [    0.000000] LINUX started...
>  > [    0.000000] console [early0] enabled
>  > [    0.000000] CPU revision is: 00019300 (MIPS 24K)
>  > [    0.000000] FPU revision is: 00739300
>  > [    0.000000] registering PCI controller with io_map_base unset
>  > [    0.000000] Determined physical RAM map:
>  > [    0.000000]  memory: 00001000 @ 00000000 (reserved)
>  > [    0.000000]  memory: 000ef000 @ 00001000 (ROM data)
>  > [    0.000000]  memory: 002bf000 @ 000f0000 (reserved)
>  > [    0.000000]  memory: 07c50000 @ 003af000 (usable)
>  > [    0.000000] Wasting 30176 bytes for tracking 943 unused pages
>  > [    0.000000] Zone PFN ranges:
>  > [    0.000000]   DMA             0 ->     4096
>  > [    0.000000]   Normal       4096 ->    32767
>  > [    0.000000] Movable zone start PFN for each node
>  > [    0.000000] early_node_map[1] active PFN ranges
>  > [    0.000000]     0:        0 ->    32767
>  > [    0.004000] Built 1 zonelists in Zone order, mobility grouping on.
>  > Total pages: 32512
>  > [    0.004000] Kernel command line: rd_start=0x803af000
>  > rd_size=2908011 led_blink_period=5 root=/dev/hda1 console=ttyS0
>  > [    0.004000] Primary instruction cache 2kB, VIPT, 2-way, linesize 16 bytes.
>  > [    0.004000] Primary data cache 2kB, 2-way, VIPT, no aliases,
>  > linesize 16 bytes
>  > [    0.004000] Synthesized clear page handler (26 instructions).
>  > [    0.004000] Synthesized copy page handler (46 instructions).
>  > [    0.004000] Cache parity protection enabled
>  > [    0.004000] PID hash table entries: 512 (order: 9, 2048 bytes)
>  > [    0.004000] CPU frequency 199.99 MHz
>  > [    0.004000] Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
>  > [    0.004000] Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
>  > [    0.016001] Memory: 125992k/127296k available (2008k kernel code,
>  > 1128k reserved, 388k data, 136k init, 0k highmem)
>  > [    0.108006] Mount-cache hash table entries: 512
>  > [    0.120007] net_namespace: 152 bytes
>  > [    0.124007] NET: Registered protocol family 16
>  > [    0.140008] pci 0000:00:0a.3: quirk: region 1100-110f claimed by PIIX4 SMB
>  > [    0.144009] PCI: Ignore bogus resource 2 [0:0] of 0000:00:00.0
>  > [    0.144009] PCI: Ignore bogus resource 4 [0:0] of 0000:00:00.0
>  > [    0.164010] NET: Registered protocol family 2
>  > [    0.204012] IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
>  > [    0.204012] TCP established hash table entries: 4096 (order: 3, 32768 bytes)
>  > [    0.208013] TCP bind hash table entries: 4096 (order: 2, 16384 bytes)
>  > [    0.208013] TCP: Hash tables configured (established 4096 bind 4096)
>  > [    0.208013] TCP reno registered
>  > [    0.228014] io scheduler noop registered (default)
>  > [    0.232014] rtc: SRM (post-2000) epoch (2000) detected
>  > [    0.232014] Real Time Clock Driver v1.12ac
>  > [    0.232014] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports,
>  > IRQ sharing disabled
>  > [    0.240015] serial8250.2: ttyS0 at I/O 0x3f8 (irq = 4) is a 16450
>  > [    0.240015] console handover: boot [early0] -> real [ttyS0]
>  > [    0.244015] serial8250.2: ttyS2 at MMIO 0x1f000900 (irq = 18) is a 16450
>  > [    0.252015] loop: module loaded
>  > [    0.252015] pcnet32.c:v1.34 14.Aug.2007 tsbogend@alpha.franken.de
>  > [    0.256016] pcnet32: PCnet/PCI II 79C970A at 0x1020,
>  > 52:54:00:12:34:56 assigned IRQ 10.
>  > [    0.260016] eth0: registered as PCnet/PCI II 79C970A
>  > [    0.260016] pcnet32: 1 cards_found.
>  > [    0.260016] Uniform Multi-Platform E-IDE driver
>  > [    1.172073] ide0: DISABLED, NO IRQ
>  > [    1.172073] ide0: failed to initialize IDE interface
>  > [    1.176073] TCP cubic registered
>  > [    1.176073] NET: Registered protocol family 1
>  > [    1.176073] NET: Registered protocol family 17
>  > [    1.180073] RPC: Registered udp transport module.
>  > [    1.180073] RPC: Registered tcp transport module.
>  > [    1.184074] md: Autodetecting RAID arrays.
>  > [    1.188074] md: Scanned 0 and added 0 devices.
>  > [    1.188074] md: autorun ...
>  > [    1.188074] md: ... autorun DONE.
>  > [    1.188074] Root-NFS: No NFS server available, giving up.
>  > [    1.188074] VFS: Unable to mount root fs via NFS, trying floppy.
>  > [    1.192074] VFS: Cannot open root device "hda1" or unknown-block(2,0)
>  > [    1.192074] Please append a correct "root=" boot option; here are
>  > the available partitions:
>  > [    1.192074] Kernel panic - not syncing: VFS: Unable to mount root
>  > fs on unknown-block(2,0)
>  >
>  > This error was bisected to the following commit:
>  >
>  > commit fb56dbc95e05415a0c967ece13f927dd50c254bc
>  > Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>  > Date:   Mon Apr 21 11:44:02 2008 +1000
>  >
>  >     ide: fix hwif-s initialization
>  >
>  >     * Add ide_hwifs[] entry initialization to ide_find_port_slot()
>  >       and remove ide_init_port_data() calls from host drivers.
>  >
>  >     * Unexport ide_init_port_data().
>  >
>  >     * Remove no longer needed init_ide_data().
>  >
>  >     Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>  >
>  > My .config if attached to this email.
>  >
>  > Thanks,
>  > Dmitri Vorobiev
