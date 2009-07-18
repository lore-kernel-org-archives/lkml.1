Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbZGRU36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbZGRU36 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 16:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbZGRU34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 16:29:56 -0400
Received: from mail.gmx.net ([213.165.64.20]:37793 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753744AbZGRU3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 16:29:55 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX197YP5OVFx7qMdnpgI+pPm4tktA4/8DJNwxtAXhVZ
	LVLmwVWPESttX5
Message-ID: <4A6230C0.6000509@fisher-privat.net>
Date: Sat, 18 Jul 2009 22:29:52 +0200
From: Alexey Fisher <bug-track@fisher-privat.net>
User-Agent: Thunderbird 2.0.0.22 (X11/20090710)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [kmemleak] 60 wornings on sysfs_new_dirent+0x10c
References: <4A5C20E5.6010203@fisher-privat.net>	 <84144f020907140019g511723dctb541f6333d1a082b@mail.gmail.com>	 <4A5C41C8.7040904@fisher-privat.net> <1247564356.28240.30.camel@pc1117.cambridge.arm.com>
In-Reply-To: <1247564356.28240.30.camel@pc1117.cambridge.arm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I getting a lot of sysfs_new_dirent warnings with latest ARM git.
this message come if my usb-cardreader is attached.


this are first sysfs_new_dirent warnings:
======================================================
unreferenced object 0xffff880133c580a0 (size 8):
   comm "khubd", pid 218, jiffies 4294893605
   hex dump (first 8 bytes):
     31 2d 36 00 01 88 ff ff                          1-6.....
   backtrace:
     [<ffffffff814a3115>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f36ab>] __kmalloc_track_caller+0x10b/0x200
     [<ffffffff810d4480>] kstrdup+0x40/0x70
     [<ffffffff8115ebdc>] sysfs_new_dirent+0x10c/0x120
     [<ffffffff8115f9fd>] create_dir+0x3d/0xb0
     [<ffffffff8115faa4>] sysfs_create_dir+0x34/0x50
     [<ffffffff8121ea37>] kobject_add_internal+0xb7/0x200
     [<ffffffff8121eca8>] kobject_add_varg+0x38/0x60
     [<ffffffff8121ed84>] kobject_add+0x44/0x70
     [<ffffffff812f8408>] device_add+0x118/0x5d0
     [<ffffffff8134914d>] usb_new_device+0x6d/0xe0
     [<ffffffff8134adf8>] hub_thread+0x878/0x1280
     [<ffffffff810644f6>] kthread+0x96/0xa0
     [<ffffffff8100c69a>] child_rip+0xa/0x20
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880133c653c0 (size 80):
   comm "khubd", pid 218, jiffies 4294893605
   hex dump (first 32 bytes):
     01 00 00 00 00 00 00 80 10 2e 1c 34 01 88 ff ff  ...........4....
     00 00 00 00 00 00 00 00 a0 80 c5 33 01 88 ff ff  ...........3....
   backtrace:
     [<ffffffff814a3115>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f2aeb>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8115eb0c>] sysfs_new_dirent+0x3c/0x120
     [<ffffffff8115f9fd>] create_dir+0x3d/0xb0
     [<ffffffff8115faa4>] sysfs_create_dir+0x34/0x50
     [<ffffffff8121ea37>] kobject_add_internal+0xb7/0x200
     [<ffffffff8121eca8>] kobject_add_varg+0x38/0x60
     [<ffffffff8121ed84>] kobject_add+0x44/0x70
     [<ffffffff812f8408>] device_add+0x118/0x5d0
     [<ffffffff8134914d>] usb_new_device+0x6d/0xe0
     [<ffffffff8134adf8>] hub_thread+0x878/0x1280
     [<ffffffff810644f6>] kthread+0x96/0xa0
     [<ffffffff8100c69a>] child_rip+0xa/0x20
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880133c580e8 (size 8):
   comm "khubd", pid 218, jiffies 4294893605
   hex dump (first 8 bytes):
     31 2d 36 3a 31 2e 30 00                          1-6:1.0.
   backtrace:
     [<ffffffff814a3115>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f36ab>] __kmalloc_track_caller+0x10b/0x200
     [<ffffffff810d4480>] kstrdup+0x40/0x70
     [<ffffffff8115ebdc>] sysfs_new_dirent+0x10c/0x120
     [<ffffffff8115f9fd>] create_dir+0x3d/0xb0
     [<ffffffff8115faa4>] sysfs_create_dir+0x34/0x50
     [<ffffffff8121ea37>] kobject_add_internal+0xb7/0x200
     [<ffffffff8121eca8>] kobject_add_varg+0x38/0x60
     [<ffffffff8121ed84>] kobject_add+0x44/0x70
     [<ffffffff812f8408>] device_add+0x118/0x5d0
     [<ffffffff81351054>] usb_set_configuration+0x444/0x740
     [<ffffffff8135aba2>] generic_probe+0x32/0xb0
     [<ffffffff81351425>] usb_probe_device+0x25/0x30
     [<ffffffff812faec6>] driver_probe_device+0x86/0x180
     [<ffffffff812fb0ab>] __device_attach+0x4b/0x50
     [<ffffffff812fa048>] bus_for_each_drv+0x68/0x90
unreferenced object 0xffff880133cf2b40 (size 80):
   comm "khubd", pid 218, jiffies 4294893605
   hex dump (first 32 bytes):
     01 00 00 00 00 00 00 80 c0 53 c6 33 01 88 ff ff  .........S.3....
     00 00 00 00 00 00 00 00 e8 80 c5 33 01 88 ff ff  ...........3....
   backtrace:
     [<ffffffff814a3115>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f2aeb>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff8115eb0c>] sysfs_new_dirent+0x3c/0x120
     [<ffffffff8115f9fd>] create_dir+0x3d/0xb0
     [<ffffffff8115faa4>] sysfs_create_dir+0x34/0x50
     [<ffffffff8121ea37>] kobject_add_internal+0xb7/0x200
     [<ffffffff8121eca8>] kobject_add_varg+0x38/0x60
     [<ffffffff8121ed84>] kobject_add+0x44/0x70
     [<ffffffff812f8408>] device_add+0x118/0x5d0
     [<ffffffff81351054>] usb_set_configuration+0x444/0x740
     [<ffffffff8135aba2>] generic_probe+0x32/0xb0
     [<ffffffff81351425>] usb_probe_device+0x25/0x30
     [<ffffffff812faec6>] driver_probe_device+0x86/0x180
     [<ffffffff812fb0ab>] __device_attach+0x4b/0x50
     [<ffffffff812fa048>] bus_for_each_drv+0x68/0x90
     [<ffffffff812fb166>] device_attach+0x86/0x90
===================================================================


dump:
==================================================================
[  604.393175] kmemleak: Object 0xffff880133c580a0 (size 8):
[  604.393179] kmemleak:   comm "khubd", pid 218, jiffies 4294893605
[  604.393180] kmemleak:   min_count = 1
[  604.393182] kmemleak:   count = 0
[  604.393183] kmemleak:   flags = 0x3
[  604.393184] kmemleak:   backtrace:
[  604.393186]      [<ffffffff814a3115>] kmemleak_alloc+0x25/0x60
[  604.393193]      [<ffffffff810f36ab>] __kmalloc_track_caller+0x10b/0x200
[  604.393198]      [<ffffffff810d4480>] kstrdup+0x40/0x70
[  604.393201]      [<ffffffff8115ebdc>] sysfs_new_dirent+0x10c/0x120
[  604.393206]      [<ffffffff8115f9fd>] create_dir+0x3d/0xb0
[  604.393209]      [<ffffffff8115faa4>] sysfs_create_dir+0x34/0x50
[  604.393212]      [<ffffffff8121ea37>] kobject_add_internal+0xb7/0x200
[  604.393217]      [<ffffffff8121eca8>] kobject_add_varg+0x38/0x60
[  604.393220]      [<ffffffff8121ed84>] kobject_add+0x44/0x70
[  604.393223]      [<ffffffff812f8408>] device_add+0x118/0x5d0
[  604.393227]      [<ffffffff8134914d>] usb_new_device+0x6d/0xe0
[  604.393232]      [<ffffffff8134adf8>] hub_thread+0x878/0x1280
[  604.393235]      [<ffffffff810644f6>] kthread+0x96/0xa0
[  604.393240]      [<ffffffff8100c69a>] child_rip+0xa/0x20
[  604.393243]      [<ffffffffffffffff>] 0xffffffffffffffff
===========================================================================

gdb:
==========================================================
(gdb) l *(sysfs_new_dirent+0x10c)
0xffffffff8115ebdc is in sysfs_new_dirent (fs/sysfs/dir.c:315).
310	{
311		char *dup_name = NULL;
312		struct sysfs_dirent *sd;
313	
314		if (type & SYSFS_COPY_NAME) {
315			name = dup_name = kstrdup(name, GFP_KERNEL);
316			if (!name)
317				return NULL;
318		}
319	
=======================================================




