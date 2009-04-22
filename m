Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbZDVTU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbZDVTU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 15:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbZDVTUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 15:20:35 -0400
Received: from ns01.unsolicited.net ([69.10.132.115]:38436 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbZDVTUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 15:20:34 -0400
X-Greylist: delayed 1419 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Apr 2009 15:20:34 EDT
Message-ID: <49EF685E.7040004@unsolicited.net>
Date: Wed, 22 Apr 2009 19:56:30 +0100
From: David <david@unsolicited.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.30-rc3: Warning during boot (ReiserFS)
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing the following warning in my log during boot with rc3 /
ReiserFS. System seems OK afterward.

(Quad Core AMD Phenom)

Cheers
David


Apr 22 19:47:59 david-desktop kernel: [    2.006218] REISERFS (device
md1): found reiserfs format "3.6" with standard journal
Apr 22 19:47:59 david-desktop kernel: [    2.010191] REISERFS (device
md1): using ordered data mode
Apr 22 19:47:59 david-desktop kernel: [    2.030555] REISERFS (device
md1): journal params: device md1, size 8192, journal first block 18, max
trans len 1024, max batch 900, max commit age 30, max trans age 30
Apr 22 19:47:59 david-desktop kernel: [    2.039448] REISERFS (device
md1): checking transaction log (md1)
Apr 22 19:47:59 david-desktop kernel: [    2.148512] REISERFS (device
md1): Using r5 hash to sort names
Apr 22 19:47:59 david-desktop kernel: [    2.152669] ------------[ cut
here ]------------
Apr 22 19:47:59 david-desktop kernel: [    2.156809] WARNING: at
fs/namei.c:1251 lookup_one_len+0xa9/0xc0()
Apr 22 19:47:59 david-desktop kernel: [    2.161017] Hardware name:
GA-MA790X-DS4
Apr 22 19:47:59 david-desktop kernel: [    2.165166] Modules linked in:
Apr 22 19:47:59 david-desktop kernel: [    2.169227] Pid: 1, comm:
swapper Not tainted 2.6.30-rc3 #3
Apr 22 19:47:59 david-desktop kernel: [    2.173339] Call Trace:
Apr 22 19:47:59 david-desktop kernel: [    2.177401] 
[<ffffffff8023dfec>] warn_slowpath+0xdc/0x110
Apr 22 19:47:59 david-desktop kernel: [    2.181536] 
[<ffffffff8023ef97>] ? printk+0x67/0x70
Apr 22 19:47:59 david-desktop kernel: [    2.181540] 
[<ffffffff80330844>] ? prepare_error_buf+0x144/0x660
Apr 22 19:47:59 david-desktop kernel: [    2.181544] 
[<ffffffff802b5d61>] ? new_slab+0x1e1/0x300
Apr 22 19:47:59 david-desktop kernel: [    2.181546] 
[<ffffffff80330e68>] ? reiserfs_info+0x88/0xc0
Apr 22 19:47:59 david-desktop kernel: [    2.181549] 
[<ffffffff802c8289>] lookup_one_len+0xa9/0xc0
Apr 22 19:47:59 david-desktop kernel: [    2.181553] 
[<ffffffff802eb29a>] ? inotify_d_instantiate+0x1a/0x50
Apr 22 19:47:59 david-desktop kernel: [    2.181556] 
[<ffffffff80342d6d>] reiserfs_xattr_init+0xed/0x230
Apr 22 19:47:59 david-desktop kernel: [    2.181558] 
[<ffffffff8032f47f>] reiserfs_fill_super+0x62f/0xdc0
Apr 22 19:47:59 david-desktop kernel: [    2.181561] 
[<ffffffff8037f49e>] ? vsnprintf+0x1be/0x500
Apr 22 19:47:59 david-desktop kernel: [    2.181564] 
[<ffffffff80316fcf>] ? sysv68_partition+0x5f/0x180
Apr 22 19:47:59 david-desktop kernel: [    2.181567] 
[<ffffffff8037f949>] ? snprintf+0x59/0x60
Apr 22 19:47:59 david-desktop kernel: [    2.181570] 
[<ffffffff80519187>] ? __down_write_nested+0x17/0xb0
Apr 22 19:47:59 david-desktop kernel: [    2.181574] 
[<ffffffff8037d03f>] ? strlcpy+0x4f/0x70
Apr 22 19:47:59 david-desktop kernel: [    2.181576] 
[<ffffffff802bf1d0>] ? test_bdev_super+0x0/0x20
Apr 22 19:47:59 david-desktop kernel: [    2.181578] 
[<ffffffff802bfa3f>] ? sget+0x3df/0x480
Apr 22 19:47:59 david-desktop kernel: [    2.181580] 
[<ffffffff802c07e0>] get_sb_bdev+0x150/0x190
Apr 22 19:47:59 david-desktop kernel: [    2.181583] 
[<ffffffff8032ee50>] ? reiserfs_fill_super+0x0/0xdc0
Apr 22 19:47:59 david-desktop kernel: [    2.181586] 
[<ffffffff8029a176>] ? kstrdup+0x56/0x110
Apr 22 19:47:59 david-desktop kernel: [    2.181589] 
[<ffffffff8032c353>] get_super_block+0x13/0x20
Apr 22 19:47:59 david-desktop kernel: [    2.181591] 
[<ffffffff802c0065>] vfs_kern_mount+0x75/0x160
Apr 22 19:47:59 david-desktop kernel: [    2.181594] 
[<ffffffff802c01be>] do_kern_mount+0x4e/0x100
Apr 22 19:47:59 david-desktop kernel: [    2.181596] 
[<ffffffff802d668a>] do_mount+0x53a/0x7f0
Apr 22 19:47:59 david-desktop kernel: [    2.181599] 
[<ffffffff802d69d4>] sys_mount+0x94/0xf0
Apr 22 19:47:59 david-desktop kernel: [    2.181602] 
[<ffffffff80724078>] mount_block_root+0x98/0x2c0
Apr 22 19:47:59 david-desktop kernel: [    2.181605] 
[<ffffffff807242f6>] mount_root+0x56/0x60
Apr 22 19:47:59 david-desktop kernel: [    2.181607] 
[<ffffffff80724351>] prepare_namespace+0x51/0x1c0
Apr 22 19:47:59 david-desktop kernel: [    2.181609] 
[<ffffffff80723a47>] kernel_init+0x187/0x1b0
Apr 22 19:47:59 david-desktop kernel: [    2.181613] 
[<ffffffff8020cd3a>] child_rip+0xa/0x20
Apr 22 19:47:59 david-desktop kernel: [    2.181615] 
[<ffffffff807238c0>] ? kernel_init+0x0/0x1b0
Apr 22 19:47:59 david-desktop kernel: [    2.181618] 
[<ffffffff8020cd30>] ? child_rip+0x0/0x20
Apr 22 19:47:59 david-desktop kernel: [    2.181620] ---[ end trace
005d9a9fced3a16a ]---

