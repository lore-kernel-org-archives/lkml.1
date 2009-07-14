Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbZGNKhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbZGNKhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 06:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbZGNKhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 06:37:09 -0400
Received: from mail.gmx.net ([213.165.64.20]:46811 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754183AbZGNKhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 06:37:07 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX19ACWwW76VA2e2u8HIBoSsBdTNWE4s4gQAHdIZn9r
	cppcsau41M+rEa
Message-ID: <4A5C5FD0.3020204@fisher-privat.net>
Date: Tue, 14 Jul 2009 12:37:04 +0200
From: Alexey Fisher <bug-track@fisher-privat.net>
User-Agent: Thunderbird 2.0.0.22 (X11/20090710)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       x86@kernel.org
Subject: Re: [PATCH] x86: _edata should include all .data.* sections on	X86_64
References: <4A5C20E5.6010203@fisher-privat.net>	 <84144f020907140019g511723dctb541f6333d1a082b@mail.gmail.com>	 <4A5C41C8.7040904@fisher-privat.net>	 <1247564356.28240.30.camel@pc1117.cambridge.arm.com>	 <1247565175.28240.37.camel@pc1117.cambridge.arm.com>	 <4A5C5A59.5080304@fisher-privat.net> <1247567499.28240.48.camel@pc1117.cambridge.arm.com>
In-Reply-To: <1247567499.28240.48.camel@pc1117.cambridge.arm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas schrieb:
> On Tue, 2009-07-14 at 12:13 +0200, Alexey Fisher wrote:
>> With this patch i have only 25 reports....
>> but i still have a lot of ext4 and some other reports.
> 
> Apart from ext4, what are the other reports?
> 
> Thanks.
> 

this is complete trace from debug/kmemleak .
i will compile now latest linux-arm.org/linux-2.6.git

but i think i need step by step howto... it's really new for me.

unreferenced object 0xffff88013711c2a8 (size 64):
   comm "swapper", pid 1, jiffies 4294892383
   backtrace:
     [<ffffffff810fbaca>] create_object+0x13a/0x2c0
     [<ffffffff810fbd75>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f596b>] __kmalloc+0x11b/0x210
     [<ffffffff81263b41>] kzalloc+0xf/0x11
     [<ffffffff8126416d>] acpi_add_single_object+0x5b0/0xd5a
     [<ffffffff81264b32>] acpi_bus_scan+0x125/0x1af
     [<ffffffff8176dcb7>] acpi_scan_init+0xc8/0xe9
     [<ffffffff8176da72>] acpi_init+0x21f/0x265
     [<ffffffff8100905b>] do_one_initcall+0x4b/0x190
     [<ffffffff8174b6ef>] kernel_init+0x169/0x1bf
     [<ffffffff8100c69a>] child_rip+0xa/0x20
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801349aa150 (size 96):
   comm "swapper", pid 1, jiffies 4294892492
   backtrace:
     [<ffffffff810fbaca>] create_object+0x13a/0x2c0
     [<ffffffff810fbd75>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff811f815f>] new_inode_smack+0x2f/0xc0
     [<ffffffff811f8215>] smack_inode_alloc_security+0x25/0x40
     [<ffffffff811f0cdc>] security_inode_alloc+0x1c/0x20
     [<ffffffff811135a5>] inode_init_always+0xc5/0x220
     [<ffffffff8111372c>] alloc_inode+0x2c/0x50
     [<ffffffff81113778>] new_inode+0x28/0xc0
     [<ffffffff8111d581>] simple_fill_super+0x41/0x200
     [<ffffffff811f8da5>] smk_fill_super+0x25/0x70
     [<ffffffff81100ed8>] get_sb_single+0x98/0xc0
     [<ffffffff811f8d73>] smk_get_sb+0x13/0x20
     [<ffffffff81100bf6>] vfs_kern_mount+0x76/0x180
     [<ffffffff81100d14>] kern_mount_data+0x14/0x20
     [<ffffffff817677d0>] init_smk_fs+0x3b/0x7b
unreferenced object 0xffff880133bf8540 (size 96):
   comm "swapper", pid 1, jiffies 4294893530
   backtrace:
     [<ffffffff810fbaca>] create_object+0x13a/0x2c0
     [<ffffffff810fbd75>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f596b>] __kmalloc+0x11b/0x210
     [<ffffffff8128b80c>] acpi_processor_register_performance+0x2ab/0x3eb
     [<ffffffff8101fc51>] acpi_cpufreq_cpu_init+0xb1/0x500
     [<ffffffff813b4004>] cpufreq_add_dev+0x154/0x650
     [<ffffffff81300926>] sysdev_driver_register+0xa6/0x130
     [<ffffffff813b3000>] cpufreq_register_driver+0x80/0x160
     [<ffffffff81754348>] acpi_cpufreq_init+0x91/0xc7
     [<ffffffff8100905b>] do_one_initcall+0x4b/0x190
     [<ffffffff8174b6ef>] kernel_init+0x169/0x1bf
     [<ffffffff8100c69a>] child_rip+0xa/0x20
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880133bf85e8 (size 96):
   comm "swapper", pid 1, jiffies 4294893531
   backtrace:
     [<ffffffff810fbaca>] create_object+0x13a/0x2c0
     [<ffffffff810fbd75>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f596b>] __kmalloc+0x11b/0x210
     [<ffffffff8128b80c>] acpi_processor_register_performance+0x2ab/0x3eb
     [<ffffffff8101fc51>] acpi_cpufreq_cpu_init+0xb1/0x500
     [<ffffffff813b4004>] cpufreq_add_dev+0x154/0x650
     [<ffffffff81300926>] sysdev_driver_register+0xa6/0x130
     [<ffffffff813b3000>] cpufreq_register_driver+0x80/0x160
     [<ffffffff81754348>] acpi_cpufreq_init+0x91/0xc7
     [<ffffffff8100905b>] do_one_initcall+0x4b/0x190
     [<ffffffff8174b6ef>] kernel_init+0x169/0x1bf
     [<ffffffff8100c69a>] child_rip+0xa/0x20
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880132c48890 (size 1024):
   comm "exe", pid 1612, jiffies 4294894130
   backtrace:
     [<ffffffff810fbaca>] create_object+0x13a/0x2c0
     [<ffffffff810fbd75>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f596b>] __kmalloc+0x11b/0x210
     [<ffffffff811ae061>] ext4_mb_init+0x1b1/0x5c0
     [<ffffffff8119f1e9>] ext4_fill_super+0x1e29/0x2720
     [<ffffffff8110111f>] get_sb_bdev+0x16f/0x1b0
     [<ffffffff81195413>] ext4_get_sb+0x13/0x20
     [<ffffffff81100bf6>] vfs_kern_mount+0x76/0x180
     [<ffffffff81100d6d>] do_kern_mount+0x4d/0x120
     [<ffffffff81118ee7>] do_mount+0x307/0x8b0
     [<ffffffff8111951f>] sys_mount+0x8f/0xe0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801335be738 (size 192):
   comm "exe", pid 1612, jiffies 4294894130
   backtrace:
     [<ffffffff810fbaca>] create_object+0x13a/0x2c0
     [<ffffffff810fbd75>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f596b>] __kmalloc+0x11b/0x210
     [<ffffffff811ae061>] ext4_mb_init+0x1b1/0x5c0
     [<ffffffff8119f1e9>] ext4_fill_super+0x1e29/0x2720
     [<ffffffff8110111f>] get_sb_bdev+0x16f/0x1b0
     [<ffffffff81195413>] ext4_get_sb+0x13/0x20
     [<ffffffff81100bf6>] vfs_kern_mount+0x76/0x180
     [<ffffffff81100d6d>] do_kern_mount+0x4d/0x120
     [<ffffffff81118ee7>] do_mount+0x307/0x8b0
     [<ffffffff8111951f>] sys_mount+0x8f/0xe0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801329ac708 (size 128):
   comm "udevd", pid 1710, jiffies 4294894924
   backtrace:
     [<ffffffff810fbaca>] create_object+0x13a/0x2c0
     [<ffffffff810fbd75>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff811325fa>] sys_inotify_add_watch+0xca/0x350
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801329ac7d0 (size 128):
   comm "udevd", pid 1710, jiffies 4294894924
   backtrace:
     [<ffffffff810fbaca>] create_object+0x13a/0x2c0
     [<ffffffff810fbd75>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff811325fa>] sys_inotify_add_watch+0xca/0x350
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801329ac898 (size 128):
   comm "udevd", pid 1710, jiffies 4294894924
   backtrace:
     [<ffffffff810fbaca>] create_object+0x13a/0x2c0
     [<ffffffff810fbd75>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff811325fa>] sys_inotify_add_watch+0xca/0x350
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801329ac960 (size 128):
   comm "udevd", pid 1710, jiffies 4294894924
   backtrace:
     [<ffffffff810fbaca>] create_object+0x13a/0x2c0
     [<ffffffff810fbd75>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff811325fa>] sys_inotify_add_watch+0xca/0x350
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801329aca28 (size 128):
   comm "udevd", pid 1710, jiffies 4294894925
   backtrace:
     [<ffffffff810fbaca>] create_object+0x13a/0x2c0
     [<ffffffff810fbd75>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff811325fa>] sys_inotify_add_watch+0xca/0x350
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801329acaf0 (size 128):
   comm "udevd", pid 1710, jiffies 4294894925
   backtrace:
     [<ffffffff810fbaca>] create_object+0x13a/0x2c0
     [<ffffffff810fbd75>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff811325fa>] sys_inotify_add_watch+0xca/0x350
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801329acbb8 (size 128):
   comm "udevd", pid 1710, jiffies 4294894925
   backtrace:
     [<ffffffff810fbaca>] create_object+0x13a/0x2c0
     [<ffffffff810fbd75>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff811325fa>] sys_inotify_add_watch+0xca/0x350
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801329ace10 (size 128):
   comm "udevd", pid 1710, jiffies 4294894925
   backtrace:
     [<ffffffff810fbaca>] create_object+0x13a/0x2c0
     [<ffffffff810fbd75>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
     [<ffffffff811325fa>] sys_inotify_add_watch+0xca/0x350
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88012f48d440 (size 64):
   comm "mount", pid 2393, jiffies 4294896562
   backtrace:
     [<ffffffff810fbaca>] create_object+0x13a/0x2c0
     [<ffffffff810fbd75>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f596b>] __kmalloc+0x11b/0x210
     [<ffffffff811ae061>] ext4_mb_init+0x1b1/0x5c0
     [<ffffffff8119f1e9>] ext4_fill_super+0x1e29/0x2720
     [<ffffffff8110111f>] get_sb_bdev+0x16f/0x1b0
     [<ffffffff81195413>] ext4_get_sb+0x13/0x20
     [<ffffffff81100bf6>] vfs_kern_mount+0x76/0x180
     [<ffffffff81100d6d>] do_kern_mount+0x4d/0x120
     [<ffffffff81118ee7>] do_mount+0x307/0x8b0
     [<ffffffff8111951f>] sys_mount+0x8f/0xe0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880132815158 (size 1024):
   comm "mount", pid 2393, jiffies 4294896569
   backtrace:
     [<ffffffff810fbaca>] create_object+0x13a/0x2c0
     [<ffffffff810fbd75>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f596b>] __kmalloc+0x11b/0x210
     [<ffffffff811ae061>] ext4_mb_init+0x1b1/0x5c0
     [<ffffffff8119f1e9>] ext4_fill_super+0x1e29/0x2720
     [<ffffffff8110111f>] get_sb_bdev+0x16f/0x1b0
     [<ffffffff81195413>] ext4_get_sb+0x13/0x20
     [<ffffffff81100bf6>] vfs_kern_mount+0x76/0x180
     [<ffffffff81100d6d>] do_kern_mount+0x4d/0x120
     [<ffffffff81118ee7>] do_mount+0x307/0x8b0
     [<ffffffff8111951f>] sys_mount+0x8f/0xe0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801328159e8 (size 1024):
   comm "mount", pid 2393, jiffies 4294896569
   backtrace:
     [<ffffffff810fbaca>] create_object+0x13a/0x2c0
     [<ffffffff810fbd75>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f596b>] __kmalloc+0x11b/0x210
     [<ffffffff811ae061>] ext4_mb_init+0x1b1/0x5c0
     [<ffffffff8119f1e9>] ext4_fill_super+0x1e29/0x2720
     [<ffffffff8110111f>] get_sb_bdev+0x16f/0x1b0
     [<ffffffff81195413>] ext4_get_sb+0x13/0x20
     [<ffffffff81100bf6>] vfs_kern_mount+0x76/0x180
     [<ffffffff81100d6d>] do_kern_mount+0x4d/0x120
     [<ffffffff81118ee7>] do_mount+0x307/0x8b0
     [<ffffffff8111951f>] sys_mount+0x8f/0xe0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880132816b08 (size 1024):
   comm "mount", pid 2393, jiffies 4294896569
   backtrace:
     [<ffffffff810fbaca>] create_object+0x13a/0x2c0
     [<ffffffff810fbd75>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f596b>] __kmalloc+0x11b/0x210
     [<ffffffff811ae061>] ext4_mb_init+0x1b1/0x5c0
     [<ffffffff8119f1e9>] ext4_fill_super+0x1e29/0x2720
     [<ffffffff8110111f>] get_sb_bdev+0x16f/0x1b0
     [<ffffffff81195413>] ext4_get_sb+0x13/0x20
     [<ffffffff81100bf6>] vfs_kern_mount+0x76/0x180
     [<ffffffff81100d6d>] do_kern_mount+0x4d/0x120
     [<ffffffff81118ee7>] do_mount+0x307/0x8b0
     [<ffffffff8111951f>] sys_mount+0x8f/0xe0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801328155a0 (size 1024):
   comm "mount", pid 2393, jiffies 4294896569
   backtrace:
     [<ffffffff810fbaca>] create_object+0x13a/0x2c0
     [<ffffffff810fbd75>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f596b>] __kmalloc+0x11b/0x210
     [<ffffffff811ae061>] ext4_mb_init+0x1b1/0x5c0
     [<ffffffff8119f1e9>] ext4_fill_super+0x1e29/0x2720
     [<ffffffff8110111f>] get_sb_bdev+0x16f/0x1b0
     [<ffffffff81195413>] ext4_get_sb+0x13/0x20
     [<ffffffff81100bf6>] vfs_kern_mount+0x76/0x180
     [<ffffffff81100d6d>] do_kern_mount+0x4d/0x120
     [<ffffffff81118ee7>] do_mount+0x307/0x8b0
     [<ffffffff8111951f>] sys_mount+0x8f/0xe0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880132812f18 (size 1024):
   comm "mount", pid 2393, jiffies 4294896583
   backtrace:
     [<ffffffff810fbaca>] create_object+0x13a/0x2c0
     [<ffffffff810fbd75>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f596b>] __kmalloc+0x11b/0x210
     [<ffffffff811ae061>] ext4_mb_init+0x1b1/0x5c0
     [<ffffffff8119f1e9>] ext4_fill_super+0x1e29/0x2720
     [<ffffffff8110111f>] get_sb_bdev+0x16f/0x1b0
     [<ffffffff81195413>] ext4_get_sb+0x13/0x20
     [<ffffffff81100bf6>] vfs_kern_mount+0x76/0x180
     [<ffffffff81100d6d>] do_kern_mount+0x4d/0x120
     [<ffffffff81118ee7>] do_mount+0x307/0x8b0
     [<ffffffff8111951f>] sys_mount+0x8f/0xe0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880132811568 (size 1024):
   comm "mount", pid 2393, jiffies 4294896583
   backtrace:
     [<ffffffff810fbaca>] create_object+0x13a/0x2c0
     [<ffffffff810fbd75>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f596b>] __kmalloc+0x11b/0x210
     [<ffffffff811ae061>] ext4_mb_init+0x1b1/0x5c0
     [<ffffffff8119f1e9>] ext4_fill_super+0x1e29/0x2720
     [<ffffffff8110111f>] get_sb_bdev+0x16f/0x1b0
     [<ffffffff81195413>] ext4_get_sb+0x13/0x20
     [<ffffffff81100bf6>] vfs_kern_mount+0x76/0x180
     [<ffffffff81100d6d>] do_kern_mount+0x4d/0x120
     [<ffffffff81118ee7>] do_mount+0x307/0x8b0
     [<ffffffff8111951f>] sys_mount+0x8f/0xe0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880132811120 (size 1024):
   comm "mount", pid 2393, jiffies 4294896583
   backtrace:
     [<ffffffff810fbaca>] create_object+0x13a/0x2c0
     [<ffffffff810fbd75>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f596b>] __kmalloc+0x11b/0x210
     [<ffffffff811ae061>] ext4_mb_init+0x1b1/0x5c0
     [<ffffffff8119f1e9>] ext4_fill_super+0x1e29/0x2720
     [<ffffffff8110111f>] get_sb_bdev+0x16f/0x1b0
     [<ffffffff81195413>] ext4_get_sb+0x13/0x20
     [<ffffffff81100bf6>] vfs_kern_mount+0x76/0x180
     [<ffffffff81100d6d>] do_kern_mount+0x4d/0x120
     [<ffffffff81118ee7>] do_mount+0x307/0x8b0
     [<ffffffff8111951f>] sys_mount+0x8f/0xe0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880132810cd8 (size 1024):
   comm "mount", pid 2393, jiffies 4294896583
   backtrace:
     [<ffffffff810fbaca>] create_object+0x13a/0x2c0
     [<ffffffff810fbd75>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f596b>] __kmalloc+0x11b/0x210
     [<ffffffff811ae061>] ext4_mb_init+0x1b1/0x5c0
     [<ffffffff8119f1e9>] ext4_fill_super+0x1e29/0x2720
     [<ffffffff8110111f>] get_sb_bdev+0x16f/0x1b0
     [<ffffffff81195413>] ext4_get_sb+0x13/0x20
     [<ffffffff81100bf6>] vfs_kern_mount+0x76/0x180
     [<ffffffff81100d6d>] do_kern_mount+0x4d/0x120
     [<ffffffff81118ee7>] do_mount+0x307/0x8b0
     [<ffffffff8111951f>] sys_mount+0x8f/0xe0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880132810890 (size 1024):
   comm "mount", pid 2393, jiffies 4294896583
   backtrace:
     [<ffffffff810fbaca>] create_object+0x13a/0x2c0
     [<ffffffff810fbd75>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f596b>] __kmalloc+0x11b/0x210
     [<ffffffff811ae061>] ext4_mb_init+0x1b1/0x5c0
     [<ffffffff8119f1e9>] ext4_fill_super+0x1e29/0x2720
     [<ffffffff8110111f>] get_sb_bdev+0x16f/0x1b0
     [<ffffffff81195413>] ext4_get_sb+0x13/0x20
     [<ffffffff81100bf6>] vfs_kern_mount+0x76/0x180
     [<ffffffff81100d6d>] do_kern_mount+0x4d/0x120
     [<ffffffff81118ee7>] do_mount+0x307/0x8b0
     [<ffffffff8111951f>] sys_mount+0x8f/0xe0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880132810448 (size 1024):
   comm "mount", pid 2393, jiffies 4294896583
   backtrace:
     [<ffffffff810fbaca>] create_object+0x13a/0x2c0
     [<ffffffff810fbd75>] kmemleak_alloc+0x25/0x60
     [<ffffffff810f596b>] __kmalloc+0x11b/0x210
     [<ffffffff811ae061>] ext4_mb_init+0x1b1/0x5c0
     [<ffffffff8119f1e9>] ext4_fill_super+0x1e29/0x2720
     [<ffffffff8110111f>] get_sb_bdev+0x16f/0x1b0
     [<ffffffff81195413>] ext4_get_sb+0x13/0x20
     [<ffffffff81100bf6>] vfs_kern_mount+0x76/0x180
     [<ffffffff81100d6d>] do_kern_mount+0x4d/0x120
     [<ffffffff81118ee7>] do_mount+0x307/0x8b0
     [<ffffffff8111951f>] sys_mount+0x8f/0xe0
     [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff
