Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbYAZWCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbYAZWCV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 17:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbYAZWCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 17:02:13 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:6560 "EHLO
	mk-filter-3-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754447AbYAZWCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 17:02:12 -0500
X-Trace: 675251418/mk-filter-3.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.80.29
X-SBRS: None
X-RemoteIP: 81.1.80.29
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAKc8m0dRAVAd/2dsb2JhbACBWKo+
Subject: Re: kobject oops with maple bus
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-sh <linux-sh@vger.kernel.org>
In-Reply-To: <20080126204402.GA30867@kroah.com>
References: <1201377200.6672.10.camel@localhost.localdomain>
	 <20080126204402.GA30867@kroah.com>
Content-Type: text/plain
Date: Sat, 26 Jan 2008 22:01:48 +0000
Message-Id: <1201384908.6672.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-01-26 at 12:44 -0800, Greg KH wrote:
> On Sat, Jan 26, 2008 at 07:53:20PM +0000, Adrian McMenamin wrote:
> > Greg,
> > 
> > Just updated my git to the latest sources and get these (seemingly non-fatal) oops with the Dreamcast maple bus. I'll investigate further, but they may mean something to out out of the box.
> > 
> > Adrian
> > 
> > 
> > 
> > 
> > dreamy:~# [    0.000000] Linux version 2.6.24-gf0ea9c3d-dirty (adrian@bossclass) (gcc version 3.4.6) #328 PREEMPT Sat Jan 26 19:45:30 GMT 2008
> > [    0.000000] console [sercon0] enabled
> > [    0.000000] Booting machvec: Sega Dreamcast
> > [    0.000000] Node 0: start_pfn = 0xc000, low = 0xd000
> > [    0.000000] Zone PFN ranges:
> > [    0.000000]   Normal      49152 ->    53248
> > [    0.000000] Movable zone start PFN for each node
> > [    0.000000] early_node_map[1] active PFN ranges
> > [    0.000000]     0:    49152 ->    53248
> > [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4064
> > [    0.000000] Kernel command line: root=/dev/nfs rw nfsroot=192.168.61.50:/home/adrian/debdist ip=dhcp earlyprintk=serial video=pvr2fb:640x480-32@60 consol7
> > [    0.000000] PID hash table entries: 64 (order: 6, 256 bytes)
> > [    0.000000] Using tmu for system timer
> > [    0.000000] Using 12.469 MHz high precision timer.
> > [    0.000000] Console: colour dummy device 80x25
> > [    0.000000] Dentry cache hash table entries: 2048 (order: 1, 8192 bytes)
> > [    0.000000] Inode-cache hash table entries: 1024 (order: 0, 4096 bytes)
> > [    0.000000] Memory: 13468k/16384k available (1918k kernel code, 645k data, 96k init)
> > [    0.000000] PVR=040205c1 CVR=00000000 PRR=00000000
> > [    0.000000] I-cache : n_ways=1 n_sets=256 way_incr=8192
> > [    0.000000] I-cache : entry_mask=0x00001fe0 alias_mask=0x00001000 n_aliases=2
> > [    0.000000] D-cache : n_ways=1 n_sets=512 way_incr=16384
> > [    0.000000] D-cache : entry_mask=0x00003fe0 alias_mask=0x00003000 n_aliases=4
> > [    0.000000] SLUB: Genslabs=9, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
> > [    0.000000] Mount-cache hash table entries: 512
> > [    0.000000] CPU: SH7750
> > [    0.000000] net_namespace: 64 bytes
> > [    0.000000] NET: Registered protocol family 16
> > [    0.000000] Maple bus at (0, 0): Connected function 0x0
> > [    0.000000] No maple driver found for this device
> > [    0.000000] Maple bus at (1, 0): Connected function 0x0
> > [    0.000000] No maple driver found for this device
> > [    0.000000] Maple bus at (2, 0): Connected function 0x0
> > [    0.000000] No maple driver found for this device
> > [    0.000000] Maple bus at (3, 0): Connected function 0x0
> > [    0.000000] No maple driver found for this device
> > [    0.000000] Maple bus core now registered.
> > [    0.000000] DMA: Registering DMA API.
> > [    0.000000] DMA: Registering sh_dmac handler (4 channels).
> > [    0.000000] Maple bus at (0, 0): Connected function 0x1
> > [    0.000000] No maple driver found for this device
> > [    0.000000] kobject (8cc2d360): tried to init an initialized object, something is seriously wrong.
> 
> The problem is here.  You have possibly already initialized this object,
> or called 'kobject_get' on it before registering it with the driver
> core.  This is a new sanity check that has been in the -mm tree for
> years :)
> 
> So I think something needs to be fixed in the code.  Do you want me to
> take a look at it?
> 

I think it is probably registering the "dummy" driver a second or
further time. Does that make sense? By all means have a look, but I'll
have a go - I'm sure you have better things to do than mess about with
Dreamcast code :)

