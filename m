Return-Path: <linux-kernel-owner+w=401wt.eu-S965007AbXIGFnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965007AbXIGFnE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 01:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbXIGFmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 01:42:54 -0400
Received: from king.bitgnome.net ([70.84.111.244]:42876 "EHLO
	king.bitgnome.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbXIGFmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 01:42:53 -0400
X-Greylist: delayed 929 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Sep 2007 01:42:53 EDT
Date: Fri, 7 Sep 2007 00:27:21 -0500
From: Mark Nipper <nipsy@bitgnome.net>
To: linux-kernel@vger.kernel.org
Subject: BUG: unable to handle kernel NULL pointer dereference<1>
Message-ID: <20070907052720.GA3122@king.bitgnome.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

        I've received two oopses now from my kernel while running
the 2.6.22 series.  The first was with 2.6.22.1 back in July and
the second which happened just within the last day is 2.6.22.5.
They both appear to be the same bug and I don't think it's
hardware related.  I'm attaching the entries from logcheck which
I received when they happened.

        I'm not subscribed to the mailing list, so please make
sure to copy me directly on any replies.  And let me know if
anyone needs any additional information to try to track this
down.  Thanks for reading...

-- 
Mark Nipper                                                e-contacts:
4320 Milam Street                                   nipsy@bitgnome.net
Bryan, Texas 77801-3920                     http://nipsy.bitgnome.net/
(979)575-3193                      AIM/Yahoo: texasnipsy ICQ: 66971617

-----BEGIN GEEK CODE BLOCK-----
Version: 3.1
GG/IT d- s++:+ a- C++$ UBL++++$ P--->+++ L+++$ !E---
W++(--) N+ o K++ w(---) O++ M V(--) PS+++(+) PE(--)
Y+ PGP t+ 5 X R tv b+++@ DI++ D+ G e(*) h r(%) y+(**)
------END GEEK CODE BLOCK------

---begin random quote of the moment---
"They that can give up essential liberty to obtain a little
temporary safety deserve neither liberty nor safety."
 -- Benjamin Franklin, _Historical Review of Pennsylvania_, 1759
----end random quote of the moment----

--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=oops1

System Events
=-=-=-=-=-=-=
Jul 28 10:37:31 king kernel: BUG: unable to handle kernel NULL pointer dereference<1>BUG: unable to handle kernel NULL pointer dereference at virtual address 00000054
Jul 28 10:37:31 king kernel:  printing eip:
Jul 28 10:37:31 king kernel: c02aa5af
Jul 28 10:37:31 king kernel: *pde = 00000000
Jul 28 10:37:31 king kernel: Oops: 0000 [#1]
Jul 28 10:37:31 king kernel: SMP
Jul 28 10:37:31 king kernel: Modules linked in:
Jul 28 10:37:31 king kernel: CPU:    2
Jul 28 10:37:31 king kernel: EIP:    0060:[<c02aa5af>]    Not tainted VLI
Jul 28 10:37:31 king kernel: EFLAGS: 00210202   (2.6.22.1 #1)
Jul 28 10:37:31 king kernel: EIP is at netlink_run_queue+0x2d/0x102
Jul 28 10:37:31 king kernel: eax: 00000000   ebx: f7888000   ecx: 00000000   edx: 00200202
Jul 28 10:37:31 king kernel: esi: 00000000   edi: e5527e04   ebp: c22ef06c   esp: e5527dec
Jul 28 10:37:31 king kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Jul 28 10:37:31 king kernel: Process identd (pid: 25336, ti=e5526000 task=c7660540 task.ti=e5526000)
Jul 28 10:37:31 king kernel: Stack: c02de0e9 c22ef000 0000004c e5527f60 f78d1c00 c02dd72c 00000001 c22ef000
Jul 28 10:37:31 king kernel:        0000004c c02aab05 0000004c c22ef000 c02a982b e5527e9c 00000000 c02aaa12
Jul 28 10:37:31 king kernel:        00000000 f7f903c0 00000000 00000000 00000000 eca07c80 e5527e7c 000062f7
Jul 28 10:37:31 king kernel: Call Trace:
Jul 28 10:37:31 king kernel:  [<c02de0e9>] inet_diag_rcv_msg+0x0/0x56d
Jul 28 10:37:31 king kernel:  [<c02dd72c>] inet_diag_rcv+0x1c/0x29
Jul 28 10:37:31 king kernel:  [<c02aab05>] netlink_data_ready+0x12/0x4e
Jul 28 10:37:31 king kernel:  [<c02a982b>] netlink_sendskb+0x19/0x30
Jul 28 10:37:31 king kernel:  [<c02aaa12>] netlink_sendmsg+0x1ba/0x29b
Jul 28 10:37:31 king kernel:  [<c0293ffc>] sock_aio_write+0xd4/0xee
Jul 28 10:37:31 king kernel:  [<c0149537>] find_extend_vma+0x12/0x4d
Jul 28 10:37:31 king kernel:  [<c0156f62>] do_sync_write+0xd2/0x10e
Jul 28 10:37:31 king kernel:  [<c0129a17>] autoremove_wake_function+0x0/0x37
Jul 28 10:37:31 king kernel:  [<c01577a9>] vfs_write+0x111/0x118
Jul 28 10:37:31 king kernel:  [<c0157ce8>] sys_write+0x41/0x6a
Jul 28 10:37:31 king kernel:  [<c010270a>] syscall_call+0x7/0xb
Jul 28 10:37:31 king kernel:  =======================
Jul 28 10:37:31 king kernel: Code: 56 53 83 ec 04 89 c3 89 d7 89 0c 24 8b 02 85 c0 0f 84 a6 00 00 00 8d 6b 6c 3b 43 74 0f 87 9a 00 00 00 89 e8 e8 ca ef fe ff 89 c6 <8b> 50 54 83 fa 0f 76 4b 8b 98 8c 00 00 00 8b 03 83 f8 0f 76 3e
Jul 28 10:37:31 king kernel: EIP: [<c02aa5af>] netlink_run_queue+0x2d/0x102 SS:ESP 0068:e5527dec
Jul 28 10:37:31 king kernel:  at virtual address 00000054
Jul 28 10:37:31 king kernel:  printing eip:
Jul 28 10:37:31 king kernel: c02aa5af
Jul 28 10:37:31 king kernel: *pde = 00000000
Jul 28 10:37:31 king kernel: Oops: 0000 [#2]
Jul 28 10:37:31 king kernel: SMP
Jul 28 10:37:31 king kernel: Modules linked in:
Jul 28 10:37:31 king kernel: CPU:    3
Jul 28 10:37:31 king kernel: EIP:    0060:[<c02aa5af>]    Not tainted VLI
Jul 28 10:37:31 king kernel: EFLAGS: 00210202   (2.6.22.1 #1)
Jul 28 10:37:31 king kernel: EIP is at netlink_run_queue+0x2d/0x102
Jul 28 10:37:31 king kernel: eax: 00000000   ebx: e37cb800   ecx: 00000000   edx: 00200202
Jul 28 10:37:31 king kernel: esi: 00000000   edi: eb635e04   ebp: c22ef06c   esp: eb635dec
Jul 28 10:37:31 king kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Jul 28 10:37:31 king kernel: Process identd (pid: 25337, ti=eb634000 task=dd8da030 task.ti=eb634000)
Jul 28 10:37:31 king kernel: Stack: c02de0e9 c22ef000 0000004c eb635f60 f7e77e00 c02dd72c 00000001 c22ef000
Jul 28 10:37:31 king kernel:        0000004c c02aab05 0000004c c22ef000 c02a982b eb635e9c 00000000 c02aaa12
Jul 28 10:37:31 king kernel:        00000000 f7f903c0 00000000 00000000 00000000 cde60680 eb635e7c 000062f7
Jul 28 10:37:31 king kernel: Call Trace:
Jul 28 10:37:31 king kernel:  [<c02de0e9>] inet_diag_rcv_msg+0x0/0x56d
Jul 28 10:37:31 king kernel:  [<c02dd72c>] inet_diag_rcv+0x1c/0x29
Jul 28 10:37:31 king kernel:  [<c02aab05>] netlink_data_ready+0x12/0x4e
Jul 28 10:37:31 king kernel:  [<c02a982b>] netlink_sendskb+0x19/0x30
Jul 28 10:37:31 king kernel:  [<c02aaa12>] netlink_sendmsg+0x1ba/0x29b
Jul 28 10:37:31 king kernel:  [<c0293ffc>] sock_aio_write+0xd4/0xee
Jul 28 10:37:31 king kernel:  [<c0149537>] find_extend_vma+0x12/0x4d
Jul 28 10:37:31 king kernel:  [<c0156f62>] do_sync_write+0xd2/0x10e
Jul 28 10:37:31 king kernel:  [<c0129a17>] autoremove_wake_function+0x0/0x37
Jul 28 10:37:31 king kernel:  [<c01493f4>] exit_mmap+0xab/0xea
Jul 28 10:37:31 king kernel:  [<c01577a9>] vfs_write+0x111/0x118
Jul 28 10:37:31 king kernel:  [<c0157ce8>] sys_write+0x41/0x6a
Jul 28 10:37:31 king kernel:  [<c010270a>] syscall_call+0x7/0xb
Jul 28 10:37:31 king kernel:  =======================
Jul 28 10:37:31 king kernel: Code: 56 53 83 ec 04 89 c3 89 d7 89 0c 24 8b 02 85 c0 0f 84 a6 00 00 00 8d 6b 6c 3b 43 74 0f 87 9a 00 00 00 89 e8 e8 ca ef fe ff 89 c6 <8b> 50 54 83 fa 0f 76 4b 8b 98 8c 00 00 00 8b 03 83 f8 0f 76 3e
Jul 28 10:37:31 king kernel: EIP: [<c02aa5af>] netlink_run_queue+0x2d/0x102 SS:ESP 0068:eb635dec

--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=oops2

System Events
=-=-=-=-=-=-=
Sep  6 20:16:56 king kernel: BUG: unable to handle kernel NULL pointer dereference<1>BUG: unable to handle kernel NULL pointer dereference at virtual address 00000054
Sep  6 20:16:56 king kernel:  printing eip:
Sep  6 20:16:56 king kernel: c02a85ef
Sep  6 20:16:56 king kernel: *pde = 00000000
Sep  6 20:16:56 king kernel: Oops: 0000 [#1]
Sep  6 20:16:56 king kernel: SMP
Sep  6 20:16:56 king kernel: Modules linked in:
Sep  6 20:16:56 king kernel: CPU:    1
Sep  6 20:16:56 king kernel: EIP:    0060:[<c02a85ef>]    Not tainted VLI
Sep  6 20:16:56 king kernel: EFLAGS: 00210202   (2.6.22.5 #1)
Sep  6 20:16:56 king kernel: EIP is at netlink_run_queue+0x2d/0x102
Sep  6 20:16:56 king kernel: eax: 00000000   ebx: f3453200   ecx: 00000000   edx: 00200202
Sep  6 20:16:56 king kernel: esi: 00000000   edi: d8a9fe04   ebp: f7e2046c   esp: d8a9fdec
Sep  6 20:16:56 king kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Sep  6 20:16:56 king kernel: Process identd (pid: 23985, ti=d8a9e000 task=f6bb4070 task.ti=d8a9e000)
Sep  6 20:16:56 king kernel: Stack: c02da499 f7e20400 0000004c d8a9ff60 f7a03800 c02d9adc 00000001 f7e20400
Sep  6 20:16:56 king kernel:        0000004c c02a8b45 0000004c f7e20400 c02a786b d8a9fe9c 00000000 c02a8a52
Sep  6 20:16:56 king kernel:        00000000 f161e200 00000000 00000000 00000000 e3872a80 d8a9fe7c 00005dae
Sep  6 20:16:56 king kernel: Call Trace:
Sep  6 20:16:56 king kernel:  [<c02da499>] inet_diag_rcv_msg+0x0/0x56d
Sep  6 20:16:56 king kernel:  [<c02d9adc>] inet_diag_rcv+0x1c/0x29
Sep  6 20:16:56 king kernel:  [<c02a8b45>] netlink_data_ready+0x12/0x4e
Sep  6 20:16:56 king kernel:  [<c02a786b>] netlink_sendskb+0x19/0x30
Sep  6 20:16:56 king kernel:  [<c02a8a52>] netlink_sendmsg+0x1ba/0x29b
Sep  6 20:16:56 king kernel:  [<c02920cc>] sock_aio_write+0xd4/0xee
Sep  6 20:16:56 king kernel:  [<c01490a7>] find_extend_vma+0x12/0x4d
Sep  6 20:16:56 king kernel:  [<c0156ad2>] do_sync_write+0xd2/0x10e
Sep  6 20:16:56 king kernel:  [<c0129577>] autoremove_wake_function+0x0/0x37
Sep  6 20:16:56 king kernel:  [<c0148f64>] exit_mmap+0xab/0xea
Sep  6 20:16:56 king kernel:  [<c0157319>] vfs_write+0x111/0x118
Sep  6 20:16:56 king kernel:  [<c0157858>] sys_write+0x41/0x6a
Sep  6 20:16:56 king kernel:  [<c010270a>] syscall_call+0x7/0xb
Sep  6 20:16:56 king kernel:  =======================
Sep  6 20:16:56 king kernel: Code: 56 53 83 ec 04 89 c3 89 d7 89 0c 24 8b 02 85 c0 0f 84 a6 00 00 00 8d 6b 6c 3b 43 74 0f 87 9a 00 00 00 89 e8 e8 5a f0 fe ff 89 c6 <8b> 50 54 83 fa 0f 76 4b 8b 98 8c 00 00 00 8b 03 83 f8 0f 76 3e
Sep  6 20:16:56 king kernel: EIP: [<c02a85ef>] netlink_run_queue+0x2d/0x102 SS:ESP 0068:d8a9fdec
Sep  6 20:16:56 king kernel:  at virtual address 00000054
Sep  6 20:16:56 king kernel:  printing eip:
Sep  6 20:16:56 king kernel: c02a85ef
Sep  6 20:16:56 king kernel: *pde = 00000000
Sep  6 20:16:56 king kernel: Oops: 0000 [#2]
Sep  6 20:16:56 king kernel: SMP
Sep  6 20:16:56 king kernel: Modules linked in:
Sep  6 20:16:56 king kernel: CPU:    0
Sep  6 20:16:56 king kernel: EIP:    0060:[<c02a85ef>]    Not tainted VLI
Sep  6 20:16:56 king kernel: EFLAGS: 00210202   (2.6.22.5 #1)
Sep  6 20:16:56 king kernel: EIP is at netlink_run_queue+0x2d/0x102
Sep  6 20:16:56 king kernel: eax: 00000000   ebx: f67f2000   ecx: 00000000   edx: 00200202
Sep  6 20:16:56 king kernel: esi: 00000000   edi: da345e04   ebp: f7e2046c   esp: da345dec
Sep  6 20:16:56 king kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Sep  6 20:16:56 king kernel: Process identd (pid: 23984, ti=da344000 task=d4072580 task.ti=da344000)
Sep  6 20:16:56 king kernel: Stack: c02da499 f7e20400 0000004c da345f60 db56d600 c02d9adc 00000001 f7e20400
Sep  6 20:16:56 king kernel:        0000004c c02a8b45 0000004c f7e20400 c02a786b da345e9c 00000000 c02a8a52
Sep  6 20:16:56 king kernel:        00000000 f161e200 00000000 00000000 00000000 e403ec80 da345e7c 00005dae
Sep  6 20:16:56 king kernel: Call Trace:
Sep  6 20:16:56 king kernel:  [<c02da499>] inet_diag_rcv_msg+0x0/0x56d
Sep  6 20:16:56 king kernel:  [<c02d9adc>] inet_diag_rcv+0x1c/0x29
Sep  6 20:16:56 king kernel:  [<c02a8b45>] netlink_data_ready+0x12/0x4e
Sep  6 20:16:56 king kernel:  [<c02a786b>] netlink_sendskb+0x19/0x30
Sep  6 20:16:56 king kernel:  [<c02a8a52>] netlink_sendmsg+0x1ba/0x29b
Sep  6 20:16:56 king kernel:  [<c02920cc>] sock_aio_write+0xd4/0xee
Sep  6 20:16:56 king kernel:  [<c01490a7>] find_extend_vma+0x12/0x4d
Sep  6 20:16:56 king kernel:  [<c0156ad2>] do_sync_write+0xd2/0x10e
Sep  6 20:16:56 king kernel:  [<c0129577>] autoremove_wake_function+0x0/0x37
Sep  6 20:16:56 king kernel:  [<c0157319>] vfs_write+0x111/0x118
Sep  6 20:16:56 king kernel:  [<c0157858>] sys_write+0x41/0x6a
Sep  6 20:16:56 king kernel:  [<c010270a>] syscall_call+0x7/0xb
Sep  6 20:16:56 king kernel:  =======================
Sep  6 20:16:56 king kernel: Code: 56 53 83 ec 04 89 c3 89 d7 89 0c 24 8b 02 85 c0 0f 84 a6 00 00 00 8d 6b 6c 3b 43 74 0f 87 9a 00 00 00 89 e8 e8 5a f0 fe ff 89 c6 <8b> 50 54 83 fa 0f 76 4b 8b 98 8c 00 00 00 8b 03 83 f8 0f 76 3e
Sep  6 20:16:56 king kernel: EIP: [<c02a85ef>] netlink_run_queue+0x2d/0x102 SS:ESP 0068:da345dec


--pf9I7BMVVzbSWLtt--
