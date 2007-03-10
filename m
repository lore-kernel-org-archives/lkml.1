Return-Path: <linux-kernel-owner+w=401wt.eu-S933413AbXCJIp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413AbXCJIp7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 03:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933062AbXCJIp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 03:45:59 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3157 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933413AbXCJIp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 03:45:58 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-rc3-mm1
Date: Sat, 10 Mar 2007 09:48:11 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
       linux-usb-devel@lists.sourceforge.net
References: <20070307201839.6f45735b.akpm@linux-foundation.org> <200703100933.35743.m.kozlowski@tuxland.pl>
In-Reply-To: <200703100933.35743.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703100948.13189.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

> Unable to reproduce so far.

Ok I was wrong. Able to reproduce quite easily. Let me know if you need
anything more.

usb 2-1: new low speed USB device using uhci_hcd and address 11
usb 2-1: new device found, idVendor=046d, idProduct=c00e
usb 2-1: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-1: Product: USB-PS/2 Optical Mouse
usb 2-1: Manufacturer: Logitech
usb 2-1: configuration #1 chosen from 1 choice
khubd: page allocation failure. order:5, mode:0xd0
 [<c01045c4>] show_trace_log_lvl+0x1a/0x30
 [<c0104d50>] show_trace+0x12/0x14
 [<c0104e07>] dump_stack+0x16/0x18
 [<c014acc6>] __alloc_pages+0x2e4/0x303
 [<c01604df>] cache_alloc_refill+0x2e4/0x516
 [<c01608e4>] kmem_cache_zalloc+0x78/0x7c
 [<c0341343>] hid_parse_report+0xce/0x26b
 [<c032d99b>] hid_probe+0x264/0xdba
 [<c030feb9>] usb_probe_interface+0x5a/0x89
 [<c02bf74f>] driver_probe_device+0x86/0x178
 [<c02bf849>] __device_attach+0x8/0xa
 [<c02beadc>] bus_for_each_drv+0x4a/0x68
 [<c02bfb39>] device_attach+0x8b/0xd2
 [<c02bea4e>] bus_attach_device+0x40/0x84
 [<c02bd835>] device_add+0x5d0/0x6c8
 [<c030e8bd>] usb_set_configuration+0x2d6/0x4c6
 [<c03158ab>] generic_probe+0x15c/0x251
 [<c030fb87>] usb_probe_device+0x36/0x3c
 [<c02bf74f>] driver_probe_device+0x86/0x178
 [<c02bf849>] __device_attach+0x8/0xa
 [<c02beadc>] bus_for_each_drv+0x4a/0x68
 [<c02bfb39>] device_attach+0x8b/0xd2
 [<c02bea4e>] bus_attach_device+0x40/0x84
 [<c02bd835>] device_add+0x5d0/0x6c8
 [<c030a078>] usb_new_device+0x128/0x196
 [<c030aedd>] hub_thread+0x28a/0xb4a
 [<c0126c75>] kthread+0xa2/0xc9
 [<c010422f>] kernel_thread_helper+0x7/0x18
 =======================
Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15 usd:   0
Active:71402 inactive:8979 dirty:610 writeback:0 unstable:0
 free:23528 slab:13478 mapped:18407 pagetables:424 bounce:0
DMA free:2160kB min:92kB low:112kB high:136kB active:9264kB inactive:0kB present:16256kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 459 459
Normal free:91952kB min:2692kB low:3364kB high:4036kB active:276344kB inactive:35916kB present:470856kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
DMA: 306*4kB 83*8kB 11*16kB 1*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2160kB
Normal: 13334*4kB 3899*8kB 460*16kB 2*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 91952kB
Swap cache: add 1853, delete 1558, find 498/539, race 1+0
Free swap  = 496520kB
Total swap = 498004kB
Free swap:       496520kB
122736 pages of RAM
0 pages of HIGHMEM
2265 reserved pages
83052 pages shared
295 pages swap cached
610 pages dirty
0 pages writeback
18407 pages mapped
13461 pages slab
424 pages pagetables

Regards,

	Mariusz Kozlowski
