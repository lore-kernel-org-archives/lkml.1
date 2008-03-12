Return-Path: <linux-kernel-owner+w=401wt.eu-S1753414AbYCLFxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbYCLFxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 01:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbYCLFxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 01:53:23 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:58539 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbYCLFxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 01:53:23 -0400
Message-Id: <200803120546.m2C5kE8L082233@www262.sakura.ne.jp>
Subject: Re: [2.6.25-rc5-mm1] BUG() at mnt_want_write().
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Wed, 12 Mar 2008 14:46:14 +0900
References: <200803120137.m2C1bffL037440@www262.sakura.ne.jp> <1205291010.9828.60.camel@nimitz.home.sr71.net>
In-Reply-To: <1205291010.9828.60.camel@nimitz.home.sr71.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

The file causing BUG seems to be "proc/sys/kernel/real-root-dev",
which is not starting with '/'.
I think the vfsmount used for name resolution
is pointing invalid address.

Regards.
---------- dmesg ----------

input: ImPS/2 Generic Wheel Mouse as /class/input/input1
do_sys_open: /dev/ram
do_sys_open: /initrd.image
RAMDISK: cramfs filesystem found at block 0
RAMDISK: Loading 1060KiB [1 disk] into ram disk... done.
VFS: Mounted root (cramfs filesystem) readonly.
do_sys_open: /
do_sys_open: /old
do_sys_open: /dev/console
do_sys_open: /etc/ld.so.preload
do_sys_open: /etc/ld.so.cache
do_sys_open: /lib/tls/i686/mmx/cmov/libc.so.6
do_sys_open: /lib/tls/i686/mmx/libc.so.6
do_sys_open: /lib/tls/i686/cmov/libc.so.6
do_sys_open: /lib/tls/i686/libc.so.6
do_sys_open: /lib/tls/mmx/cmov/libc.so.6
do_sys_open: /lib/tls/mmx/libc.so.6
do_sys_open: /lib/tls/cmov/libc.so.6
do_sys_open: /lib/tls/libc.so.6
do_sys_open: /linuxrc
do_sys_open: /etc/ld.so.preload
do_sys_open: /etc/ld.so.cache
do_sys_open: /lib/tls/i686/mmx/cmov/libblkid.so.1
do_sys_open: /lib/tls/i686/mmx/libblkid.so.1
do_sys_open: /lib/tls/i686/cmov/libblkid.so.1
do_sys_open: /lib/tls/i686/libblkid.so.1
do_sys_open: /lib/tls/mmx/cmov/libblkid.so.1
do_sys_open: /lib/tls/mmx/libblkid.so.1
do_sys_open: /lib/tls/cmov/libblkid.so.1
do_sys_open: /lib/tls/libblkid.so.1
do_sys_open: /lib/i686/mmx/cmov/libblkid.so.1
do_sys_open: /lib/i686/mmx/libblkid.so.1
do_sys_open: /lib/i686/cmov/libblkid.so.1
do_sys_open: /lib/i686/libblkid.so.1
do_sys_open: /lib/mmx/cmov/libblkid.so.1
do_sys_open: /lib/mmx/libblkid.so.1
do_sys_open: /lib/cmov/libblkid.so.1
do_sys_open: /lib/libblkid.so.1
do_sys_open: /lib/tls/libuuid.so.1
do_sys_open: /lib/libuuid.so.1
do_sys_open: /lib/tls/libc.so.6
do_sys_open: /dev/null
do_sys_open: /etc/blkid.tab
mount used greatest stack depth: 2632 bytes left
do_sys_open: /etc/ld.so.preload
do_sys_open: /etc/ld.so.cache
do_sys_open: /lib/tls/i686/mmx/cmov/libc.so.6
do_sys_open: /lib/tls/i686/mmx/libc.so.6
do_sys_open: /lib/tls/i686/cmov/libc.so.6
do_sys_open: /lib/tls/i686/libc.so.6
do_sys_open: /lib/tls/mmx/cmov/libc.so.6
do_sys_open: /lib/tls/mmx/libc.so.6
do_sys_open: /lib/tls/cmov/libc.so.6
do_sys_open: /lib/tls/libc.so.6
do_sys_open: proc/sys/kernel/real-root-dev
do_sys_open: proc/sys/kernel/real-root-dev
do_sys_open: /etc/ld.so.preload
do_sys_open: /etc/ld.so.cache
do_sys_open: /lib/tls/i686/mmx/cmov/libblkid.so.1
do_sys_open: /lib/tls/i686/mmx/libblkid.so.1
do_sys_open: /lib/tls/i686/cmov/libblkid.so.1
do_sys_open: /lib/tls/i686/libblkid.so.1
do_sys_open: /lib/tls/mmx/cmov/libblkid.so.1
do_sys_open: /lib/tls/mmx/libblkid.so.1
do_sys_open: /lib/tls/cmov/libblkid.so.1
do_sys_open: /lib/tls/libblkid.so.1
do_sys_open: /lib/i686/mmx/cmov/libblkid.so.1
do_sys_open: /lib/i686/mmx/libblkid.so.1
do_sys_open: /lib/i686/cmov/libblkid.so.1
do_sys_open: /lib/i686/libblkid.so.1
do_sys_open: /lib/mmx/cmov/libblkid.so.1
do_sys_open: /lib/mmx/libblkid.so.1
do_sys_open: /lib/cmov/libblkid.so.1
do_sys_open: /lib/libblkid.so.1
do_sys_open: /lib/tls/libuuid.so.1
do_sys_open: /lib/libuuid.so.1
do_sys_open: /lib/tls/libc.so.6
do_sys_open: /dev/null
do_sys_open: /etc/blkid.tab
do_sys_open: bin/root
linuxrc used greatest stack depth: 2344 bytes left
debug: unmapping init memory c048d000..c051f000
Write protecting the kernel text: 2348k
Write protecting the kernel read-only data: 1052k
do_sys_open: /dev/console
do_sys_open: /etc/ld.so.preload
do_sys_open: /etc/ld.so.cache
do_sys_open: /lib/tls/i686/mmx/cmov/libc.so.6
do_sys_open: /lib/tls/i686/mmx/libc.so.6
do_sys_open: /lib/tls/i686/cmov/libc.so.6
do_sys_open: /lib/tls/i686/libc.so.6
do_sys_open: /lib/tls/mmx/cmov/libc.so.6
do_sys_open: /lib/tls/mmx/libc.so.6
do_sys_open: /lib/tls/cmov/libc.so.6
do_sys_open: /lib/tls/libc.so.6
do_sys_open: /sbin/init
do_sys_open: /linuxrc.conf
initrd-tools: 0.1.81.1
do_sys_open: bin/root
do_sys_open: /etc/ld.so.preload
do_sys_open: /etc/ld.so.cache
do_sys_open: /lib/tls/i686/mmx/cmov/libblkid.so.1
do_sys_open: /lib/tls/i686/mmx/libblkid.so.1
do_sys_open: /lib/tls/i686/cmov/libblkid.so.1
do_sys_open: /lib/tls/i686/libblkid.so.1
do_sys_open: /lib/tls/mmx/cmov/libblkid.so.1
do_sys_open: /lib/tls/mmx/libblkid.so.1
do_sys_open: /lib/tls/cmov/libblkid.so.1
do_sys_open: /lib/tls/libblkid.so.1
do_sys_open: /lib/i686/mmx/cmov/libblkid.so.1
do_sys_open: /lib/i686/mmx/libblkid.so.1
do_sys_open: /lib/i686/cmov/libblkid.so.1
do_sys_open: /lib/i686/libblkid.so.1
do_sys_open: /lib/mmx/cmov/libblkid.so.1
do_sys_open: /lib/mmx/libblkid.so.1
do_sys_open: /lib/cmov/libblkid.so.1
do_sys_open: /lib/libblkid.so.1
do_sys_open: /lib/tls/libuuid.so.1
do_sys_open: /lib/libuuid.so.1
do_sys_open: /lib/tls/libc.so.6
do_sys_open: /etc/mtab
do_sys_open: proc/sys/kernel/real-root-dev
BUG: unable to handle kernel paging request at df368fe8
IP: [<c017e0d0>] mnt_want_write+0x41/0x5f
*pde = 1f884163 *pte = 1f368160
Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
last sysfs file:
Modules linked in:

Pid: 1, comm: init Not tainted (2.6.25-rc5-mm1 #2)
EIP: 0060:[<c017e0d0>] EFLAGS: 00010286 CPU: 0
EIP is at mnt_want_write+0x41/0x5f
EAX: 00000000 EBX: c1453460 ECX: 00000001 EDX: df368f78
ESI: df365f78 EDI: 00000000 EBP: df8e1ef0 ESP: df8e1ee4
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process init (pid: 1, ti=df8e1000 task=df8f8020 task.ti=df8e1000)
Stack: ffffffeb 00000200 df8e1f20 df8e1f7c c0173481 ffffa7fe 00000000 ffffff9c
       c053482b 00008242 00000000 00000002 00008241 df365f78 df56af50 df365f78
       df56af50 92aaee34 0000000d df911010 00000300 00000000 00000000 c016a9ca
Call Trace:
 [<c0173481>] ? do_filp_open+0x233/0x52f
 [<c016a9ca>] ? get_unused_fd_flags+0xb3/0xbe
 [<c016aabd>] ? do_sys_open+0x50/0xd0
 [<c016ab53>] ? sys_open+0x16/0x18
 [<c0103966>] ? syscall_call+0x7/0xb
 =======================
Code: 8d 1c 02 89 d8 e8 d3 b4 1c 00 89 f0 e8 7e ff ff ff 85 c0 74 07 bf e2 ff ff ff eb 1f 8b 53 2c 39 f2 74 15 85 d2 74 0e 8b 43 28 90 <01> 42 70 c7 43 28
00 00 00 00 89 73 2c ff 43 28 89 d8 e8 cf b5
EIP: [<c017e0d0>] mnt_want_write+0x41/0x5f SS:ESP 0068:df8e1ee4
---[ end trace c340a6739d39d70a ]---
Kernel panic - not syncing: Attempted to kill init!
