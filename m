Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbYAZTyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbYAZTyM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 14:54:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbYAZTx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 14:53:57 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:8838 "EHLO
	mk-filter-3-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752139AbYAZTxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 14:53:55 -0500
X-Trace: 675221279/mk-filter-3.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.80.29
X-SBRS: None
X-RemoteIP: 81.1.80.29
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FADAem0dRAVAd/2dsb2JhbACBWKpU
Subject: kobject oops with maple bus
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-sh <linux-sh@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 26 Jan 2008 19:53:20 +0000
Message-Id: <1201377200.6672.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Just updated my git to the latest sources and get these (seemingly non-fatal) oops with the Dreamcast maple bus. I'll investigate further, but they may mean something to out out of the box.

Adrian




dreamy:~# [    0.000000] Linux version 2.6.24-gf0ea9c3d-dirty (adrian@bossclass) (gcc version 3.4.6) #328 PREEMPT Sat Jan 26 19:45:30 GMT 2008
[    0.000000] console [sercon0] enabled
[    0.000000] Booting machvec: Sega Dreamcast
[    0.000000] Node 0: start_pfn = 0xc000, low = 0xd000
[    0.000000] Zone PFN ranges:
[    0.000000]   Normal      49152 ->    53248
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:    49152 ->    53248
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4064
[    0.000000] Kernel command line: root=/dev/nfs rw nfsroot=192.168.61.50:/home/adrian/debdist ip=dhcp earlyprintk=serial video=pvr2fb:640x480-32@60 consol7
[    0.000000] PID hash table entries: 64 (order: 6, 256 bytes)
[    0.000000] Using tmu for system timer
[    0.000000] Using 12.469 MHz high precision timer.
[    0.000000] Console: colour dummy device 80x25
[    0.000000] Dentry cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Inode-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Memory: 13468k/16384k available (1918k kernel code, 645k data, 96k init)
[    0.000000] PVR=040205c1 CVR=00000000 PRR=00000000
[    0.000000] I-cache : n_ways=1 n_sets=256 way_incr=8192
[    0.000000] I-cache : entry_mask=0x00001fe0 alias_mask=0x00001000 n_aliases=2
[    0.000000] D-cache : n_ways=1 n_sets=512 way_incr=16384
[    0.000000] D-cache : entry_mask=0x00003fe0 alias_mask=0x00003000 n_aliases=4
[    0.000000] SLUB: Genslabs=9, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
[    0.000000] Mount-cache hash table entries: 512
[    0.000000] CPU: SH7750
[    0.000000] net_namespace: 64 bytes
[    0.000000] NET: Registered protocol family 16
[    0.000000] Maple bus at (0, 0): Connected function 0x0
[    0.000000] No maple driver found for this device
[    0.000000] Maple bus at (1, 0): Connected function 0x0
[    0.000000] No maple driver found for this device
[    0.000000] Maple bus at (2, 0): Connected function 0x0
[    0.000000] No maple driver found for this device
[    0.000000] Maple bus at (3, 0): Connected function 0x0
[    0.000000] No maple driver found for this device
[    0.000000] Maple bus core now registered.
[    0.000000] DMA: Registering DMA API.
[    0.000000] DMA: Registering sh_dmac handler (4 channels).
[    0.000000] Maple bus at (0, 0): Connected function 0x1
[    0.000000] No maple driver found for this device
[    0.000000] kobject (8cc2d360): tried to init an initialized object, something is seriously wrong.
[    0.000000] Stack: (0x8cc1be88 to 0x8cc1c000)
[    0.000000] be80:                   8c00762e 8cc1be98 8c27d050 8cc2d360 8c103890 8cc1bea0 
[    0.000000] bea0: 8c14435e 8cc1beb0 8cc2d200 8cc2d2f8 8cc2d200 8c144aae 8cc1bec0 8cc2d2f8 
[    0.000000] bec0: 8c159aa8 8cc1becc 00000001 8c159e58 8cc1beec 8cc69880 fffffffe 8c159d20 
[    0.000000] bee0: 8c27e14c 8cc2d200 8c27e13c 8cc1bf10 8c02e7c0 8cc0ea3c 8c1dbf60 8c02a2da 
[    0.000000] bf00: 8cc1bf1c 8c018b60 fffffffe 8c159d20 ffffff0f 8cc01240 8c27e13c 8c02a428 
[    0.000000] bf20: 8cc1bf3c 8c02e7c0 <6>DMA: Registering pvr2_dmac handler (1 channel).
[    0.000000] 8c02a220 8c02e940 8c02e200 8cc01248 8cc01240 00000000 
[    0.000000] bf40: <6>DMA: Registering g2_dmac handler (4 channels).
[    0.000000] 8cc0e9c0 8c02e9c0 8cc1bf48 8cc1bf48 00000000 8cc0e9c0 8c02e9c0 8cc1bf48 
[    0.000000] bf60: 8cc1bf48 8c02e25a 8cc1bf84 00000000 fffffffc 8c013900 8c02a3a0 8cc01240 
[    0.000000] bf80: 8c02e200 8c0038c4 00000000 00000000 00000000 00000000 00000000 00000000 
[    0.000000] bfa0: 00000000 Autoconfig PCI channel 0x8c27e36c
[    0.000000] Scanning bus 00, I/O 0x01001600:0x01003600, Mem 0x01840000:0x01848000
[    0.000000] 00:00.0 Class 0200: 11db:1234 (rev 10)
[    0.000000]         I/O at 0x01001600 [size=0x100]
[    0.000000]         Mem at 0x01840000 [size=0x100]
[    0.000000] 00000000 00000000 00000000 8cc11ec8 8c02e220 00000000 00000000 
[    0.000000] bfc0: 00000000 00000000 00000000 00000000 00000000 <5>PCI: Fixing up device 0000:00:00.0
[    0.000000] 00000000 00000000 8cc1bfa0 
[    0.000000] bfe0: 8c0038c0 00000000 40000000 00000000 00000000 00000000 00000000 00000000 
[    0.000000] 
[    0.000000] Call trace: 
[    0.000000] [<8c00762e>] dump_stack+0xe/0x9e0
[    0.000000] [<8c103890>] kobject_init+0x30/0xa0
[    0.000000] [<8c14435e>] device_initialize+0x1e/0xa0
[    0.000000] [<8c144aae>] device_register+0xe/0x40
[    0.000000] [<8c159aa8>] maple_attach_driver+0x128/0x1c0
[    0.000000] [<8c159e58>] maple_dma_handler+0x138/0x300
[    0.000000] [<8c159d20>] maple_dma_handler+0x0/0x300
[    0.000000] [<8c02e7c0>] prepare_to_wait+0x0/0xc0
[    0.000000] [<8c1dbf60>] schedule+0x360/0x420
[    0.000000] [<8c02a2da>] run_workqueue+0xba/0x180
[    0.000000] [<8c018b60>] printk+0x0/0x40
[    0.000000] [<8c159d20>] maple_dma_handler+0x0/0x300
[    0.000000] [<8c02a428>] worker_thread+0x88/0xe0
[    0.000000] [<8c02e7c0>] prepare_to_wait+0x0/0xc0
[    0.000000] [<8c02a220>] run_workqueue+0x0/0x180
[    0.000000] [<8c02e940>] finish_wait+0x0/0x80
[    0.000000] [<8c02e200>] kthread_should_stop+0x0/0x20
[    0.000000] [<8c02e9c0>] autoremove_wake_function+0x0/0x40
[    0.000000] [<8c02e9c0>] autoremove_wake_function+0x0/0x40
[    0.000000] [<8c02e25a>] kthread+0x3a/0x80
[    0.000000] [<8c013900>] complete+0x0/0xc0
[    0.000000] [<8c02a3a0>] worker_thread+0x0/0xe0
[    0.000000] [<8c02e200>] kthread_should_stop+0x0/0x20
[    0.000000] [<8c0038c4>] kernel_thread_helper+0x4/0x20
[    0.000000] [<8c02e220>] kthread+0x0/0x80
[    0.000000] [<8c0038c0>] kernel_thread_helper+0x0/0x20
[    0.000000] 
[    0.000000] Maple bus at (1, 0): Connected function 0x40
[    0.000000] No maple driver found for this device
[    0.000000] Time: SuperH clocksource has been installed.
[    0.000000] kobject (8cc2d560): tried to init an initialized object, something is seriously wrong.
[    0.000000] Stack: (0x8cc1be88 to 0x8cc1c000)
[    0.000000] be80:                   8c00762e 8cc1be98 8c27d050 8cc2d560 8c103890 8cc1bea0 
[    0.000000] bea0: 8c14435e 8cc1beb0 8cc2d400 8cc2d4f8 8cc2d400 8c144aae 8cc1bec0 8cc2d4f8 
[    0.000000] bec0: 8c159aa8 8cc1becc 00000040 8c159e58 8cc1beec 8cc69920 fffffffe 8c159d20 
[    0.000000] bee0: 8c27e14c 8cc2d400 8c27e13c 8cc1bf10 8c02e7c0 8cc0ea3c 8c1dbf60 8c02a2da 
[    0.000000] bf00: 8cc1bf1c 8c018b60 fffffffe 8c159d20 ffffff0f 8cc01240 8c27e13c 8c02a428 
[    0.000000] bf20: 8cc1bf3c 8c02e7c0 8c02a220 8c02e940 8c02e200 8cc01248 8cc01240 00000000 
[    0.000000] bf40: 8cc0e9c0 8c02e9c0 8cc1bf48 8cc1bf48 00000000 8cc0e9c0 8c02e9c0 8cc1bf48 
[    0.000000] bf60: 8cc1bf48 <6>NET: Registered protocol family 2
[    0.000000] 8c02e25a 8cc1bf84 00000000 fffffffc 8c013900 8c02a3a0 8cc01240 
[    0.000000] bf80: 8c02e200 8c0038c4 00000000 00000000 00000000 00000000 00000000 00000000 
[    0.000000] bfa0: 00000000 00000000 00000000 00000000 8cc11ec8 8c02e220 00000000 00000000 
[    0.000000] bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 8cc1bfa0 
[    0.000000] bfe0: 8c0038c0 00000000 40000000 00000000 00000000 00000000 00000000 00000000 
[    0.000000] 
[    0.000000] Call trace: 
[    0.000000] [<8c00762e>] dump_stack+0xe/0x9e0
[    0.000000] [<8c103890>] kobject_init+0x30/0xa0
[    0.000000] [<8c14435e>] device_initialize+0x1e/0xa0
[    0.000000] [<8c144aae>] device_register+0xe/0x40
[    0.000000] [<8c159aa8>] maple_attach_driver+0x128/0x1c0
[    0.000000] [<8c159e58>] maple_dma_handler+0x138/0x300
[    0.000000] [<8c159d20>] maple_dma_handler+0x0/0x300
[    0.000000] [<8c02e7c0>] prepare_to_wait+0x0/0xc0
[    0.000000] [<8c1dbf60>] schedule+0x360/0x420
[    0.000000] [<8c02a2da>] run_workqueue+0xba/0x180
[    0.000000] [<8c018b60>] printk+0x0/0x40
[    0.000000] [<8c159d20>] maple_dma_handler+0x0/0x300
[    0.000000] [<8c02a428>] worker_thread+0x88/0xe0
[    0.000000] [<8c02e7c0>] prepare_to_wait+0x0/0xc0
[    0.000000] [<8c02a220>] run_workqueue+0x0/0x180
[    0.000000] [<8c02e940>] finish_wait+0x0/0x80
[    0.000000] [<8c02e200>] kthread_should_stop+0x0/0x20
[    0.000000] [<8c02e9c0>] autoremove_wake_function+0x0/0x40
[    0.000000] [<8c02e9c0>] autoremove_wake_function+0x0/0x40
[    0.000000] [<8c02e25a>] kthread+0x3a/0x80
[    0.000000] [<8c013900>] complete+0x0/0xc0
[    0.000000] [<8c02a3a0>] worker_thread+0x0/0xe0
[    0.000000] [<8c02e200>] kthread_should_stop+0x0/0x20
[    0.000000] [<8c0038c4>] kernel_thread_helper+0x4/0x20
[    0.000000] [<8c02e220>] kthread+0x0/0x80
[    0.000000] [<8c0038c0>] kernel_thread_helper+0x0/0x20
[    0.000000] 
[    0.000000] No maple devices attached to port 2
[    0.000000] No maple devices attached to port 3

