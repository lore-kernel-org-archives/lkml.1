Return-Path: <linux-kernel-owner+w=401wt.eu-S1761585AbXJXSTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761585AbXJXSTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 14:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756871AbXJXSTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 14:19:41 -0400
Received: from orion2.pixelized.ch ([195.190.190.13]:59520 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbXJXSTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 14:19:40 -0400
Message-ID: <471F8CAE.8000906@cateee.net>
Date: Wed, 24 Oct 2007 20:19:26 +0200
From: Giacomo Catenazzi <cate@cateee.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux v2.6.24-rc1
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On 2.6.24-rc1-gc9927c2b BUG: unable to handle kernel paging request at virtual address 3d15b925


In last git, I see the following BUGs in various programs.  It seems
reproducible, but sometime I've hard lookup on poweroff.

ciao
        cate


vivi: open called (minor=0)
vivi: close called (minor=0, users=0)
BUG: unable to handle kernel paging request at virtual address 3d15b925
printing eip: 3d15b925 *pde = 00000000
Oops: 0000 [#1] SMP
Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx bttv ir_common videobuf_dma_sg btcx_risc tveeprom floppy

Pid: 3389, comm: icedove-bin Not tainted (2.6.24-rc1-gc9927c2b #17)
EIP: 0060:[<3d15b925>] EFLAGS: 00210206 CPU: 0
EIP is at 0x3d15b925
EAX: c4c7a2bc EBX: c4c7a36c ECX: 00000000 EDX: 00000000
ESI: c4c7a2bc EDI: 00000000 EBP: 00000000 ESP: c495ee00
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process icedove-bin (pid: 3389, ti=c495e000 task=c4876570 task.ti=c495e000)
Stack: 00000001 0000002e 00000000 00006c01 b1171795 00000000 c4c7a2bc 00008068
       c495ee78 c017c362 00000000 00000000 c495ee78 00008068 00000000 c4c7a2bc
       c017c53a c24058c0 00000001 c4c79f14 00000008 222281a4 22222222 22222222
Call Trace:
 [<c017c362>] inode_setattr+0x53/0x152
 [<c017c53a>] notify_change+0xd9/0x2a3
 [<c0169b51>] do_truncate+0x5e/0x75
 [<c0169130>] get_unused_fd_flags+0x52/0xc1
 [<c0170d4b>] permission+0xc5/0xde
 [<c0171e07>] may_open+0x155/0x1b3
 [<c0173ba4>] open_namei+0x6b/0x5f9
 [<c01693e3>] do_filp_open+0x25/0x40
 [<c0169130>] get_unused_fd_flags+0x52/0xc1
 [<c016943e>] do_sys_open+0x40/0xc5
 [<c01694fe>] sys_open+0x1c/0x20
 [<c0103fde>] sysenter_past_esp+0x5f/0x85
 =======================
Code:  Bad EIP value.
EIP: [<3d15b925>] 0x3d15b925 SS:ESP 0068:c495ee00
BUG: unable to handle kernel paging request at virtual address 3d15b925
printing eip: 3d15b925 *pde = 00000000
Oops: 0000 [#2] SMP
Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx bttv ir_common videobuf_dma_sg btcx_risc tveeprom floppy

Pid: 3696, comm: audacious Tainted: G      D (2.6.24-rc1-gc9927c2b #17)
EIP: 0060:[<3d15b925>] EFLAGS: 00210202 CPU: 1
EIP is at 0x3d15b925
EAX: c4c8969c EBX: c4c8974c ECX: 00000000 EDX: 00000000
ESI: c4c8969c EDI: 00000000 EBP: 00000000 ESP: c48abe00
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process audacious (pid: 3696, ti=c48ab000 task=c24b2030 task.ti=c48ab000)
Stack: 00000b8f 0000007b c43a007b c04900d8 b5b87b8f 00000000 c4c8969c 00008068
       c48abe78 c017c362 00000000 00000000 c48abe78 00008068 00000000 c4c8969c
       c017c53a c24058c0 00000001 c4c8a414 00000008 222281a4 22222222 22222222
Call Trace:
 [<c017c362>] inode_setattr+0x53/0x152
 [<c017c53a>] notify_change+0xd9/0x2a3
 [<c0169b51>] do_truncate+0x5e/0x75
 [<c0169130>] get_unused_fd_flags+0x52/0xc1
 [<c0170d4b>] permission+0xc5/0xde
 [<c0171e07>] may_open+0x155/0x1b3
 [<c0173ba4>] open_namei+0x6b/0x5f9
 [<c01693e3>] do_filp_open+0x25/0x40
 [<c0169130>] get_unused_fd_flags+0x52/0xc1
 [<c016943e>] do_sys_open+0x40/0xc5
 [<c01694fe>] sys_open+0x1c/0x20
 [<c0103fde>] sysenter_past_esp+0x5f/0x85
 =======================
Code:  Bad EIP value.
EIP: [<3d15b925>] 0x3d15b925 SS:ESP 0068:c48abe00
BUG: unable to handle kernel paging request at virtual address 3d15b925
printing eip: 3d15b925 *pde = 00000000
Oops: 0000 [#3] SMP
Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx bttv ir_common videobuf_dma_sg btcx_risc tveeprom floppy

Pid: 3154, comm: akregator Tainted: G      D (2.6.24-rc1-gc9927c2b #17)
EIP: 0060:[<3d15b925>] EFLAGS: 00010206 CPU: 1
EIP is at 0x3d15b925
EAX: c2b830cc EBX: c2b8317c ECX: 00000000 EDX: 00000000
ESI: c2b830cc EDI: 00000000 EBP: 00000000 ESP: c3a15e00
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process akregator (pid: 3154, ti=c3a15000 task=c24ae030 task.ti=c3a15000)
Stack: c298c2bc c0172b52 c482ee94 c02fc0ca c3a46005 00000000 c2b830cc 00008068
       c3a15e78 c017c362 00000000 00000000 c3a15e78 00008068 00000000 c2b830cc
       c017c53a c24058c0 00000708 c4763694 00000008 222281a4 22222222 22222222
Call Trace:
 [<c0172b52>] __link_path_walk+0xac3/0xc4f
 [<c02fc0ca>] sock_def_readable+0x12/0x68
 [<c017c362>] inode_setattr+0x53/0x152
 [<c017c53a>] notify_change+0xd9/0x2a3
 [<c0169b51>] do_truncate+0x5e/0x75
 [<c0169130>] get_unused_fd_flags+0x52/0xc1
 [<c0170d4b>] permission+0xc5/0xde
 [<c0171e07>] may_open+0x155/0x1b3
 [<c0173ba4>] open_namei+0x6b/0x5f9
 [<c01209da>] scheduler_tick+0xdf/0x125
 [<c01693e3>] do_filp_open+0x25/0x40
 [<c0169130>] get_unused_fd_flags+0x52/0xc1
 [<c016943e>] do_sys_open+0x40/0xc5
 [<c01694fe>] sys_open+0x1c/0x20
 [<c0103fde>] sysenter_past_esp+0x5f/0x85
 =======================
Code:  Bad EIP value.
EIP: [<3d15b925>] 0x3d15b925 SS:ESP 0068:c3a15e00
BUG: unable to handle kernel paging request at virtual address 3d15b925
printing eip: 3d15b925 *pde = 00000000
Oops: 0000 [#4] SMP
Modules linked in: fuse tuner tea5767 tda8290 tuner_simple mt20xx bttv ir_common videobuf_dma_sg btcx_risc tveeprom floppy

Pid: 3681, comm: icedove-bin Tainted: G      D (2.6.24-rc1-gc9927c2b #17)
EIP: 0060:[<3d15b925>] EFLAGS: 00210206 CPU: 0
EIP is at 0x3d15b925
EAX: c4c7a0cc EBX: c4c7a17c ECX: 00000000 EDX: 00000000
ESI: c4c7a0cc EDI: 00000000 EBP: 00000000 ESP: c4a49e00
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process icedove-bin (pid: 3681, ti=c4a49000 task=c391cab0 task.ti=c4a49000)
Stack: 00000001 00000051 00000000 000082ca b5dde790 00000000 c4c7a0cc 00008068
       c4a49e78 c017c362 00000000 00000000 c4a49e78 00008068 00000000 c4c7a0cc
       c017c53a c24058c0 00000001 c4c79e94 00000008 222281a4 22222222 22222222
Call Trace:
 [<c017c362>] inode_setattr+0x53/0x152
 [<c017c53a>] notify_change+0xd9/0x2a3
 [<c0169b51>] do_truncate+0x5e/0x75
 [<c0169130>] get_unused_fd_flags+0x52/0xc1
 [<c0170d4b>] permission+0xc5/0xde
 [<c0171e07>] may_open+0x155/0x1b3
 [<c0173ba4>] open_namei+0x6b/0x5f9
 [<c01693e3>] do_filp_open+0x25/0x40
 [<c0169130>] get_unused_fd_flags+0x52/0xc1
 [<c016943e>] do_sys_open+0x40/0xc5
 [<c01694fe>] sys_open+0x1c/0x20
 [<c0103fde>] sysenter_past_esp+0x5f/0x85
 =======================
Code:  Bad EIP value.
EIP: [<3d15b925>] 0x3d15b925 SS:ESP 0068:c4a49e00
