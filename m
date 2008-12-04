Return-Path: <linux-kernel-owner+w=401wt.eu-S1757265AbYLDTFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbYLDTFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 14:05:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756442AbYLDTFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 14:05:19 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:40017 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759101AbYLDTE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 14:04:58 -0500
Message-ID: <493829D2.9010203@gnat.ca>
Date: Thu, 04 Dec 2008 12:04:50 -0700
From: "Nathanael D. Noblet" <nathanael@gnat.ca>
Organization: Gnat Solutions, Inc
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Nick Andrew <nick@nick-andrew.net>, linux-kernel@vger.kernel.org
Subject: Re: PS/2 Issues
References: <49358FC7.8070106@gnat.ca> <20081203114803.GC11807@mail.local.tull.net>
In-Reply-To: <20081203114803.GC11807@mail.local.tull.net>
Content-Type: multipart/mixed;
 boundary="------------060401060004010601090703"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060401060004010601090703
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Nick Andrew wrote:
> On Tue, Dec 02, 2008 at 12:43:03PM -0700, Nathanael D. Noblet wrote:
>> I've also had lockups sooner when sharing via  
>> nfs. Even without those programs running I still have lockups  
>> periodically, however those programs being active shorten the time  
>> between lockups.
> 
> This doesn't sound like a software problem. Have you proven that the
> error does not occur when running certain older kernel revisions?

Well, I just replaced the motherboard yesterday with a completely 
different brand / chipset. Originally it was a Asus P5N-D (i750) or 
something if I remember correctly. Now its a GigaByte with a P43.

I started noticing some odd behaviour. Keyboard/mouse is continuing to 
function, however I did another sysrq -t and the paste is messed up again.

Could this be memory then? I could try running memtest again I guess, 
but it passed wonderfully when I purchased it before.

Where do I look for this issue?
-- 
Nathanael d. Noblet
Gnat Solutions, Inc
T: 403.875.4613

--------------060401060004010601090703
Content-Type: text/plain;
 name="sysrq.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sysrq.txt"

Dec  4 11:57:44 iridium kernel: SysRq : Show State
Dec  4 11:57:44 iridium kernel:  task                        PC stack   pid father
Dec  4 11:57:44 iridium kernel: init          S ffff88012ac309c0     0     1      0
Dec  4 11:57:44 iridium kernel: ffff88012fa819c8 0000000000000086 0000000000000000 ffff88012fa8198c
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012fa78000 ffff8801131a4530
Dec  4 11:57:44 iridium kernel: ffff88012fa78378 000000028108e952 ffffe20003ee47a8 ffff88012fa78378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff813308b0>] schedule_timeout+0x22/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff81330632>] ? _cond_resched+0x9/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff81330bbe>] ? mutex_lock+0x22/0x33
Dec  4 11:57:44 iridium kernel: [<ffffffff810eac64>] ? inotify_poll+0x52/0x5c
Dec  4 11:57:44 iridium kernel: [<ffffffff81031023>] ? need_resched+0x1e/0x28
Dec  4 11:57:44 iridium kernel: [<ffffffff810ccb72>] do_select+0x499/0x505
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff81142f68>] ? selinux_inode_free_security+0x73/0x7b
Dec  4 11:57:44 iridium kernel: [<ffffffff81142f68>] ? selinux_inode_free_security+0x73/0x7b
Dec  4 11:57:44 iridium kernel: [<ffffffff811006d5>] ? proc_destroy_inode+0x14/0x16
Dec  4 11:57:44 iridium kernel: [<ffffffff811006d5>] ? proc_destroy_inode+0x14/0x16
Dec  4 11:57:44 iridium kernel: [<ffffffff811006d5>] ? proc_destroy_inode+0x14/0x16
Dec  4 11:57:44 iridium kernel: [<ffffffff810d2ef3>] ? destroy_inode+0x3a/0x4f
Dec  4 11:57:44 iridium kernel: [<ffffffff81101098>] ? proc_delete_inode+0x0/0x60
Dec  4 11:57:44 iridium kernel: [<ffffffff81101098>] ? proc_delete_inode+0x0/0x60
Dec  4 11:57:44 iridium kernel: [<ffffffff810d345d>] ? generic_delete_inode+0x147/0x150
Dec  4 11:57:44 iridium kernel: [<ffffffff810d262a>] ? iput+0x61/0x65
Dec  4 11:57:44 iridium kernel: [<ffffffff810b9c04>] ? __slab_free+0x83/0x28e
Dec  4 11:57:44 iridium kernel: [<ffffffff8103f127>] ? __cleanup_signal+0x20/0x24
Dec  4 11:57:44 iridium kernel: [<ffffffff810ccd55>] core_sys_select+0x177/0x213
Dec  4 11:57:44 iridium kernel: [<ffffffff8113ec16>] ? selinux_task_wait+0x33/0x35
Dec  4 11:57:44 iridium kernel: [<ffffffff8113baa9>] ? security_task_wait+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff81043cd6>] ? wait_consider_task+0x7d/0x92c
Dec  4 11:57:44 iridium kernel: [<ffffffff810553e2>] ? remove_wait_queue+0x2f/0x39
Dec  4 11:57:44 iridium kernel: [<ffffffff8104488f>] ? do_wait+0x30a/0x343
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd11e>] sys_select+0xb8/0x15a
Dec  4 11:57:44 iridium kernel: [<ffffffff81331c7e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: kthreadd      S 0000000000000000     0     2      0
Dec  4 11:57:44 iridium kernel: ffff88012fa83ed0 0000000000000046 0000000000000000 ffffffff81331dea
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012fa79710 ffff88012faa4530
Dec  4 11:57:44 iridium kernel: ffff88012fa79a88 0000000100000000 ffff88012fa83e60 ffff88012fa79a88
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff81331dea>] ? _spin_lock+0x9/0xc
Dec  4 11:57:44 iridium kernel: [<ffffffff81031eab>] ? __wake_up_common+0x46/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff81054cf3>] kthreadd+0x8b/0x1a2
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054c68>] ? kthreadd+0x0/0x1a2
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: migration/0   S 0000000000000000     0     3      2
Dec  4 11:57:44 iridium kernel: ffff88012fa8ded0 0000000000000046 0000000000000000 ffff88012fade010
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012fa7ae20 ffffffff814ab340
Dec  4 11:57:44 iridium kernel: ffff88012fa7b198 00000000810310f4 0000000000000002 ffff88012fa7b198
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8103e50d>] migration_thread+0x1c8/0x276
Dec  4 11:57:44 iridium kernel: [<ffffffff8103e345>] ? migration_thread+0x0/0x276
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: ksoftirqd/0   S 0000000000000001     0     4      2
Dec  4 11:57:44 iridium kernel: ffff88012fa8ff00 0000000000000046 0000000000000000 ffff88012b335c40
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012fa7c530 ffff88012b335c40
Dec  4 11:57:44 iridium kernel: ffff88012fa7c8a8 0000000000000000 ffff88012fa8e000 ffff88012fa7c8a8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff810464a8>] ksoftirqd+0x34/0xcf
Dec  4 11:57:44 iridium kernel: [<ffffffff81046474>] ? ksoftirqd+0x0/0xcf
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: watchdog/0    S 0000000000000001     0     5      2
Dec  4 11:57:44 iridium kernel: ffff88012fa99ed0 0000000000000046 ffff8800a6951000 0000000000000000
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012fa7dc40 ffff88012fa79710
Dec  4 11:57:44 iridium kernel: ffff88012fa7dfb8 000000002fa7dc40 ffff88012fa99ec0 ffff88012fa7dfb8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff810820f1>] ? watchdog+0x0/0x1f8
Dec  4 11:57:44 iridium kernel: [<ffffffff81082137>] watchdog+0x46/0x1f8
Dec  4 11:57:44 iridium kernel: [<ffffffff810820f1>] ? watchdog+0x0/0x1f8
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: migration/1   S 0000000000000000     0     6      2
Dec  4 11:57:44 iridium kernel: ffff88012fa9bed0 0000000000000046 0000000000000000 ffff88012fade010
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012faa0000 ffff88012faa4530
Dec  4 11:57:44 iridium kernel: ffff88012faa0378 00000001810310f4 0000000000000002 ffff88012faa0378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8103e50d>] migration_thread+0x1c8/0x276
Dec  4 11:57:44 iridium kernel: [<ffffffff8103e345>] ? migration_thread+0x0/0x276
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: ksoftirqd/1   S ffff880117acb400     0     7      2
Dec  4 11:57:44 iridium kernel: ffff88012faa9f00 0000000000000046 0000000000000000 ffff88012faa9ec4
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012faa1710 ffff880116caae20
Dec  4 11:57:44 iridium kernel: ffff88012faa1a88 0000000100000001 ffffffff81010a07 ffff88012faa1a88
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff810464a8>] ksoftirqd+0x34/0xcf
Dec  4 11:57:44 iridium kernel: [<ffffffff81046474>] ? ksoftirqd+0x0/0xcf
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: watchdog/1    S 0000000000000000     0     8      2
Dec  4 11:57:44 iridium kernel: ffff88012faabed0 0000000000000046 ffff8800a6961000 0000000000000001
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012faa2e20 ffff88012faa4530
Dec  4 11:57:44 iridium kernel: ffff88012faa3198 000000012faa2e20 ffff88012faabec0 ffff88012faa3198
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff810820f1>] ? watchdog+0x0/0x1f8
Dec  4 11:57:44 iridium kernel: [<ffffffff81082137>] watchdog+0x46/0x1f8
Dec  4 11:57:44 iridium kernel: [<ffffffff810820f1>] ? watchdog+0x0/0x1f8
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: migration/2   S 0000000000000000     0     9      2
Dec  4 11:57:44 iridium kernel: ffff88012fad5ed0 0000000000000046 0000000000000000 ffff88012fb16010
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012faa5c40 ffff88012fae2e20
Dec  4 11:57:44 iridium kernel: ffff88012faa5fb8 00000002810310f4 0000000000000003 ffff88012faa5fb8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8103e50d>] migration_thread+0x1c8/0x276
Dec  4 11:57:44 iridium kernel: [<ffffffff8103e345>] ? migration_thread+0x0/0x276
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: ksoftirqd/2   S ffff880118fd56c0     0    10      2
Dec  4 11:57:44 iridium kernel: ffff88012fad7f00 0000000000000046 0000000000000000 ffff8800b0509710
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012fae0000 ffff8800b0509710
Dec  4 11:57:44 iridium kernel: ffff88012fae0378 000000022951a400 0000000000000000 ffff88012fae0378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff810464a8>] ksoftirqd+0x34/0xcf
Dec  4 11:57:44 iridium kernel: [<ffffffff81046474>] ? ksoftirqd+0x0/0xcf
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: watchdog/2    S 0000000000000000     0    11      2
Dec  4 11:57:44 iridium kernel: ffff88012fadded0 0000000000000046 ffff8800a6971000 0000000000000002
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012fae1710 ffff88012fae2e20
Dec  4 11:57:44 iridium kernel: ffff88012fae1a88 000000022fae1710 ffff88012faddec0 ffff88012fae1a88
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff810820f1>] ? watchdog+0x0/0x1f8
Dec  4 11:57:44 iridium kernel: [<ffffffff81082137>] watchdog+0x46/0x1f8
Dec  4 11:57:44 iridium kernel: [<ffffffff810820f1>] ? watchdog+0x0/0x1f8
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: migration/3   S 0000000000000000     0    12      2
Dec  4 11:57:44 iridium kernel: ffff88012fb0ded0 0000000000000046 0000000000000000 ffffffff81572010
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012fae4530 ffff88012fb19710
Dec  4 11:57:44 iridium kernel: ffff88012fae48a8 00000003810310f4 0000000000000000 ffff88012fae48a8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8103e50d>] migration_thread+0x1c8/0x276
Dec  4 11:57:44 iridium kernel: [<ffffffff8103e345>] ? migration_thread+0x0/0x276
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: ksoftirqd/3   S ffff88012ac516c0     0    13      2
Dec  4 11:57:44 iridium kernel: ffff88012fb0ff00 0000000000000046 0000000000000000 ffff88012fb0fec4
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012fae5c40 ffff8801179dc530
Dec  4 11:57:44 iridium kernel: ffff88012fae5fb8 0000000300000000 ffff88012fb0e000 ffff88012fae5fb8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff810464a8>] ksoftirqd+0x34/0xcf
Dec  4 11:57:44 iridium kernel: [<ffffffff81046474>] ? ksoftirqd+0x0/0xcf
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: watchdog/3    S 0000000000000000     0    14      2
Dec  4 11:57:44 iridium kernel: ffff88012fb15ed0 0000000000000046 ffff8800a6981000 0000000000000003
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012fb18000 ffff88012fb19710
Dec  4 11:57:44 iridium kernel: ffff88012fb18378 000000032fb18000 ffff88012fb15ec0 ffff88012fb18378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff810820f1>] ? watchdog+0x0/0x1f8
Dec  4 11:57:44 iridium kernel: [<ffffffff81082137>] watchdog+0x46/0x1f8
Dec  4 11:57:44 iridium kernel: [<ffffffff810820f1>] ? watchdog+0x0/0x1f8
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: events/0      S 0000000000000000     0    15      2
Dec  4 11:57:44 iridium kernel: ffff88012fb4fec0 0000000000000046 0000000000000000 0000000000000000
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012fb1ae20 ffffffff814ab340
Dec  4 11:57:44 iridium kernel: ffff88012fb1b198 000000002c346000 ffff88012c3465e0 ffff88012fb1b198
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffffa001bc23>] ? drm_bo_delayed_workqueue+0x88/0x91 [drm]
Dec  4 11:57:44 iridium kernel: [<ffffffff81051a31>] worker_thread+0xb5/0x109
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff8105197c>] ? worker_thread+0x0/0x109
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: events/1      S 0000000000000000     0    16      2
Dec  4 11:57:44 iridium kernel: ffff88012fb55ec0 0000000000000046 0000000000000000 00000000000003e8
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012fb1c530 ffff88012faa4530
Dec  4 11:57:44 iridium kernel: ffff88012fb1c8a8 000000012803bae0 ffffffff8109bf2f ffff88012fb1c8a8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8109bf2f>] ? vmstat_update+0x0/0x32
Dec  4 11:57:44 iridium kernel: [<ffffffff81052549>] ? queue_delayed_work+0x21/0x23
Dec  4 11:57:44 iridium kernel: [<ffffffff81051a31>] worker_thread+0xb5/0x109
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff8105197c>] ? worker_thread+0x0/0x109
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: events/2      S 0000000000000000     0    17      2
Dec  4 11:57:44 iridium kernel: ffff88012fb57ec0 0000000000000046 0000000000000000 ffff88012b0f1000
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012fb1dc40 ffff88012fae2e20
Dec  4 11:57:44 iridium kernel: ffff88012fb1dfb8 0000000200000286 ffff88012b0f1020 ffff88012fb1dfb8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff81051a31>] worker_thread+0xb5/0x109
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff8105197c>] ? worker_thread+0x0/0x109
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: events/3      S 0000000000000001     0    18      2
Dec  4 11:57:44 iridium kernel: ffff88012fb61ec0 0000000000000046 00000000ffffffff 00000000000003e8
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012fb58000 ffff880129439710
Dec  4 11:57:44 iridium kernel: ffff88012fb58378 000000032805bae0 ffffffff8109bf2f ffff88012fb58378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8109bf2f>] ? vmstat_update+0x0/0x32
Dec  4 11:57:44 iridium kernel: [<ffffffff81052549>] ? queue_delayed_work+0x21/0x23
Dec  4 11:57:44 iridium kernel: [<ffffffff813320ea>] ? _spin_lock_irq+0x21/0x26
Dec  4 11:57:44 iridium kernel: [<ffffffff81051a31>] worker_thread+0xb5/0x109
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff8105197c>] ? worker_thread+0x0/0x109
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: khelper       S ffff88004dd370c0     0    19      2
Dec  4 11:57:44 iridium kernel: ffff88012fb63ec0 0000000000000046 0000000000000000 ffff88012fb62000
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012fb59710 ffff8800b1eb1710
Dec  4 11:57:44 iridium kernel: ffff88012fb59a88 0000000200000000 ffffffff810116df ffff88012fb59a88
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff813320ea>] ? _spin_lock_irq+0x21/0x26
Dec  4 11:57:44 iridium kernel: [<ffffffff81051a31>] worker_thread+0xb5/0x109
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff8105197c>] ? worker_thread+0x0/0x109
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: kintegrityd/0 S 0000000000000000     0    90      2
Dec  4 11:57:44 iridium kernel: ffff88012f0d1ec0 0000000000000046 0000000000000000 ffffffff81347a00
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012fb5ae20 ffff88012fa79710
Dec  4 11:57:44 iridium kernel: ffff88012fb5b198 00000000814ab020 0000000000000000 ffff88012fb5b198
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8133050e>] ? thread_return+0xab/0xd9
Dec  4 11:57:44 iridium kernel: [<ffffffff81051a31>] worker_thread+0xb5/0x109
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff8105197c>] ? worker_thread+0x0/0x109
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: kintegrityd/1 S 0000000000000000     0    91      2
Dec  4 11:57:44 iridium kernel: ffff88012f0d3ec0 0000000000000046 0000000000000000 ffffffff81347a00
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012fb5c530 ffff88012faa4530
Dec  4 11:57:44 iridium kernel: ffff88012fb5c8a8 00000001814ab020 0000000000000000 ffff88012fb5c8a8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8133050e>] ? thread_return+0xab/0xd9
Dec  4 11:57:44 iridium kernel: [<ffffffff81051a31>] worker_thread+0xb5/0x109
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff8105197c>] ? worker_thread+0x0/0x109
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: kintegrityd/2 S 0000000000000000     0    92      2
Dec  4 11:57:44 iridium kernel: ffff88012f0d5ec0 0000000000000046 0000000000000000 ffffffff81347a00
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012fb5dc40 ffff88012fae2e20
Dec  4 11:57:44 iridium kernel: ffff88012fb5dfb8 00000002814ab020 0000000000000000 ffff88012fb5dfb8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8133050e>] ? thread_return+0xab/0xd9
Dec  4 11:57:44 iridium kernel: [<ffffffff81051a31>] worker_thread+0xb5/0x109
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff8105197c>] ? worker_thread+0x0/0x109
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: kintegrityd/3 S 0000000000000000     0    93      2
Dec  4 11:57:44 iridium kernel: ffff88012f0d7ec0 0000000000000046 0000000000000000 ffffffff81347a00
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012fb99710 ffff88012fb19710
Dec  4 11:57:44 iridium kernel: ffff88012fb99a88 00000003814ab020 0000000000000000 ffff88012fb99a88
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8133050e>] ? thread_return+0xab/0xd9
Dec  4 11:57:44 iridium kernel: [<ffffffff81051a31>] worker_thread+0xb5/0x109
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff8105197c>] ? worker_thread+0x0/0x109
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: kblockd/0     S ffff88004dd370c0     0    95      2
Dec  4 11:57:44 iridium kernel: ffff88012f0dbec0 0000000000000046 ffff8801294296c8 ffff8801294297e8
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012f0e0000 ffff8800ba582e20
Dec  4 11:57:44 iridium kernel: ffff88012f0e0378 00000000294296c8 ffff88012f0dbe60 ffff88012f0e0378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff813320ea>] ? _spin_lock_irq+0x21/0x26
Dec  4 11:57:44 iridium kernel: [<ffffffff81051a31>] worker_thread+0xb5/0x109
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff8105197c>] ? worker_thread+0x0/0x109
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: kblockd/1     S 0000000000000000     0    96      2
Dec  4 11:57:44 iridium kernel: ffff88012f0e9ec0 0000000000000046 0000000000000000 ffff88012b068120
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012f0e1710 ffff88012faa4530
Dec  4 11:57:44 iridium kernel: ffff88012f0e1a88 00fff49
Dec  4 11:57:44 iridium kernel: <4n+0x0/read+0ad+0a/0x1s+0x4> [<ffffff] ?0x1/2 000   8010000000000bc0ffffff816f0efae80100288012f081051a3f81ffffff80116>] ? r? kthhild_r0000c0 00029428f0e4530 fff10
Dec  4 11:57:44 iridium kernel: e48000 ff
Dec  4 11:57:44 iridium kernel: <4 100    0000000de500 801200000ce:
Dec  4 11:57:44 iridium kernel: [<ffffff] wb5/ffforetio [<7c>] ?0x0fff kt6
Dec  4 11:57:44 iridium kernel: 6e9xa/fff re0/0x30
Dec  4 11:57:44 iridium kernel: ffffff8i_no801f813ffff0378 378d_reker_t] ? ff8105ffff6e9>] child11
Dec  4 11:57:44 iridium kernel: <1010_arg<ff>] 0x7ff8101rip<6>S 00     <4>ec00460007a00
Dec  4 11:57:44 iridium kernel: 012f1814abace:ab/5/0xake_fker_ththreadld_r_argreadx11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: <6   000  29ec0040000005
Dec  4 11:57:44 iridium kernel: <e50e502e2b340
Dec  4 11:57:44 iridium kernel: <31980080d319ce:
Dec  4 11:57:44 iridium kernel: <ffffff0/0x
Dec  4 11:57:44 iridium kernel: <4fffff8108105116d000000 0005
Dec  4 11:57:44 iridium kernel: 88010000<4>Cr_the_wake_func38
Dec  4 11:57:44 iridium kernel: 105thr [<53>/0xfff810ip+<ff>] +0x0/0fffthr4> 16dip+0x0/ 186 000fff fff0d081051a310551> [<f109
Dec  4 11:57:44 iridium kernel: [<ff[<fffff81054e0a>d+0fff ch<4>   000      f0cb00000000000016d16df0ffb188012f0fdfff8rkeoremov519054e53child_re ? kld_ri0000000000000046 00047a16de50c539712f0fc8b02000c8ae:
Dec  4 11:57:44 iridium kernel: 050etu4> 1a3read+0xb5move_rked+0xxa/00/0x304> [<>
Dec  4 11:57:44 iridium kernel: k 19000000f816d2e20
Dec  4 11:57:44 iridium kernel: f19888  ff>Ca[<f1>]+0xb5/fff aufun
Dec  4 11:57:44 iridium kernel: [7c>ead [<53>9/0x76
Dec  4 11:57:44 iridium kernel: <ffffffff>] 0000da08000
Dec  4 11:57:44 iridium kernel: <88010000088
Dec  4 11:57:44 iridium kernel: b_th__swit>] ? 39528>] ? hx0/fffhre[<f9>]/0xfff810re_<4>54e+0x0/0fffhil
Dec  4 11:57:44 iridium kernel: <4   0000000   000ffffff88 ff
Dec  4 11:57:44 iridium kernel: 1d/00x37on+0xemovd>] ?054ed_rip+0xa/0fff? r0x3105ad+<ff>] ? c11
Dec  4 11:57:44 iridium kernel:   000266   012000000012fffffff816 fffff<ffffffffff8109653>]  child? re kthrchild00     0   <4>b0  00fff> f0 f0 ffffffff> f8 01 0000ff8>Ca[<f1>]inodes+031
Dec  4 11:57:44 iridium kernel: f810] chresthread_ri01   0000000
Dec  4 11:57:44 iridium kernel: <4004530 000000ll Trace:
Dec  4 11:57:44 iridium kernel: ff81reafffswa
Dec  4 11:57:44 iridium kernel: <4098e_page34
Dec  4 11:57:44 iridium kernel: 810remion+0xfff? k6
Dec  4 11:57:44 iridium kernel: <105d+0x49/0x7a/0x14> [<ffff     ffff8ffff500 f8012f00 ffff83050e>fff81055199>] ? autoake_x38105hre4> 4e549/0x7f810_ri [<07>] ?x0/fff kt
Dec  4 11:57:44 iridium kernel: <410116df>0000c0  ffffff8ab02ace:
Dec  4 11:57:44 iridium kernel: <xab/0x/0x1ke_fun ? w] kthchildgfffthr [<f] ?/0x2  00000017 f88000000000f81fffffff88ff880120000000fffff811055> [4> [<f<ffff811054e016df>]     88010 ff ffff88012b8801fff000000012l Tffffffrea0xdff8er_thr<4>551ove+0xffffffff8105e9>]e_a0/0x760x1   50046 016de8012fa0000ce:
Dec  4 11:57:44 iridium kernel: er+0x9n+0x46/0xffffcsix0/fffrea> [6e9>] x11
Dec  4 11:57:44 iridium kernel: f81tor0
Dec  4 11:57:44 iridium kernel: e0ax0/fff chx11
Dec  4 11:57:44 iridium kernel:  2
Dec  4 11:57:44 iridium kernel: 00016d12b6880>] s81031eff81 [<fff<ffffff8ffffff6df>] ? ch0x11h_2000   012000012b230002ff8ff8012b6ea780120300128012b6ei_iterae>]] ? >] ?81054e9>]  ? reskthreld_rip0000 00000024e0000 ffff8
Dec  4 11:57:44 iridium kernel: <43780 ffff4>C [<fe>] ser+ [<ab>common[<fc>]han
Dec  4 11:57:44 iridium kernel: <41054e53rip+rgs+<4>scsi  2000000ffff4> f245e0ffff4> [<f46/0x0/0x4ee
Dec  4 11:57:44 iridium kernel: <4810+0xfffld_4> 0a0args+0fff ? 76
Dec  4 11:57:44 iridium kernel: 810116p+0>sc000    2
Dec  4 11:57:44 iridium kernel: 0000000e500b8 0
Dec  4 11:57:44 iridium kernel: ror__wake6c>]054ee9>] c7>] >] ? ] ? 000000     0   21130040 f0
Dec  4 11:57:44 iridium kernel: <de5de500 0 f0
Dec  4 11:57:44 iridium kernel: <9c8ab020 0 f8
Dec  4 11:57:44 iridium kernel: <<4>000000000fffff000 f0000>Call_hardhedule_timb4
Dec  4 11:57:44 iridium kernel: 105_to4> 02a0xfffffffdo_a0
Dec  4 11:57:44 iridium kernel: 810remove0x0fff? mx13fff81054e116e9tor+0x0x0/0  0   746 0ff816dffff3d08 fl Tra6/0x76
Dec  4 11:57:44 iridium kernel: <4105hre> [>] ake0x3ff8105_thr
Dec  4 11:57:44 iridium kernel: <40540x49/0fffld_4> 0a0_args+0x0+0x0/4>
Dec  4 11:57:44 iridium kernel: <6   000ffff710
Dec  4 11:57:44 iridium kernel: <44de7fffff
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: unctd+0x0/0x109fffrea[<f ch11
Dec  4 11:57:44 iridium kernel: 810ore_ar [<f0a>0/0ffff81d_r>
Dec  4 11:57:44 iridium kernel: <  S000     2
Dec  4 11:57:44 iridium kernel: 00 ffff816df5f5fb8_wak wor9>] ?ff810ffffffffff010aff810 ? child_ri<4>   00  2
Dec  4 11:57:44 iridium kernel: <c9e00000000 4
Dec  4 11:57:44 iridium kernel: <de5de5e4530 0
Dec  4 11:57:44 iridium kernel: <e48ce81c0ce48a8
Dec  4 11:57:44 iridium kernel: 1b5/ake_d+06
Dec  4 11:57:44 iridium kernel: [ [<fffffff    <4> f0000fffff000
Dec  4 11:57:44 iridium kernel: <00 ffff880>Ca<ff sc22/fff __0xe0
Dec  4 11:57:44 iridium kernel: <0310esc<4>ccb72>99/fff? _0xefff8103f810<ff<fff4> [k+0s+0xk+0x0x82writele_r? tou5>] ] ? get_pagate<4>368age27
Dec  4 11:57:44 iridium kernel: 810ys_sel
Dec  4 11:57:44 iridium kernel: 330loc> [<ff] ?virt_tut_n? vs_selehard4a>_7    > ffff ffff816de5> ff00 ffffffffff81031eab_up76
Dec  4 11:57:44 iridium kernel: 202r_hee
Dec  4 11:57:44 iridium kernel: 810d+0x49/fffhil
Dec  4 11:57:44 iridium kernel: <4010a07gs+<ff>] 0x7fff810100000008f9
Dec  4 11:57:44 iridium kernel: <420 f02fl Trndler+or_hathreadld_r_argsreadx11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel:   000  25eb0040005d00
Dec  4 11:57:44 iridium kernel: <e500e50c539710
Dec  4 11:57:44 iridium kernel: <4c8a0245d0c8ace:
Dec  4 11:57:44 iridium kernel: [<fff/0x<4>ffff810105416df00002b9a3ffff00 ff88012b661a88
Dec  4 11:57:44 iridium kernel: <4
Dec  4 11:57:44 iridium kernel: <4305tur<ff>] 0xbfffffffautounc<4>5197c>ad+[<f3>]0x7fff8101 res kt0/0x 18146 f16de80120000<4> [/0xd9
Dec  4 11:57:44 iridium kernel: 0x109
Dec  4 11:57:44 iridium kernel: <ake_fthread+0x0/0<fff] k
Dec  4 11:57:44 iridium kernel: 6e9xa/fff resto0
Dec  4 11:57:44 iridium kernel: <4105ad+<ffffff ch11
Dec  4 11:57:44 iridium kernel: /2 0001815   000000fff801212ac] wo] ? fffffffff8810116e1010054e0116df0000000000016 880000000b81ffffff816dac3dfb18010032ac000ac3racfffrker_the_wake_ ? wad+x11
Dec  4 11:57:44 iridium kernel: 0x304> [>
Dec  4 11:57:44 iridium kernel: <6   2
Dec  4 11:57:44 iridium kernel: <00000de5ae2e20000fffffff8105er_09
Dec  4 11:57:44 iridium kernel: 055e_wx0/fff worker109
Dec  4 11:57:44 iridium kernel: f81ad+[<ffffchi1
Dec  4 11:57:44 iridium kernel: <101re_
Dec  4 11:57:44 iridium kernel: [<810116d    9be9c24
Dec  4 11:57:44 iridium kernel: 012b300000078
Dec  4 11:57:44 iridium kernel: +0x1bove_wa729b3>] kth] chilargs+0x0/0xfff kt4> f>]x0/our000000184fff8012fffffffffffff8808801[<fff8105fffff] ?  ffff88c87ec0ffff88012ad2ae2058a0122800002b1ce:fa024a7tim [cd]
Dec  4 11:57:44 iridium kernel: 813320ck_<4>51area<4> [<f8
Dec  4 11:57:44 iridium kernel: [109ffffa07>4e0a ? c00000c0 0024a7affffc8a8012adbs_timer+0[cp
Dec  4 11:57:44 iridium kernel: <41a3+0x<ff>] ake_fu
Dec  4 11:57:44 iridium kernel: 051_th
Dec  4 11:57:44 iridium kernel: [<53>/0xfffld_<4> [<fffff10116000 0007ac
Dec  4 11:57:44 iridium kernel: <2ad2000004>Ca_timeffffffffff0x0/0109
Dec  4 11:57:44 iridium kernel: [<ff4e539/0ff8ip+<ff>] +0x0/0xfff8thr4> 16df>]0/0dem0000  4> ffff8fffa fff000Callmer+1051ff81 [<f
Dec  4 11:57:44 iridium kernel: 4> [ffff [<ff10116df>] 0x0dit801242ff8000000000012affffffff88012012ff800_moedus_tmer+_waitlt_w>] ? f810<6>au43    000000016de510
Dec  4 11:57:44 iridium kernel: ffff88 0 00fffallfff] f9/0x3af810ex_
Dec  4 11:57:44 iridium kernel: <403a5b8ke_xf
Dec  4 11:57:44 iridium kernel: 810ex+> [<ffffffffff2b2 traf8101audi2242
Dec  4 11:57:44 iridium kernel: 000fffffffb340
Dec  4 11:57:44 iridium kernel: <12b9d5b [<ffff8103a5bt_w0/0f81+0x<ff>] 0x3ce/0fff piair [<fff ? itc> [50eeturn+013
Dec  4 11:57:44 iridium kernel: <hunath+    0000ffff0 ffffc000 Trace:d_pagetimedule_s_timeout+0x0[<f>] ?1c/0ff8ys_71
Dec  4 11:57:44 iridium kernel: 810cd1it+<ff>] ?_functfff810264ffffx4dk+0xck_i] ?  defb>] 56c>] ] ? x+0x8unk+0utex9/0x16/0x10     0000000fffff816de500 816d89bab39bb942c8f9bb198
Dec  4 11:57:44 iridium kernel: <40earead4> [<ff>] ake0x3ff8ecurity10c07>] em_ 0002691ffff012a2fa9:
Dec  4 11:57:44 iridium kernel: <x674> [< [<ff810<ffff[<ffffffffff811302014ff81026ffff
Dec  4 11:57:44 iridium kernel: [<sched? rek_preempt_/0xfffin_+0xfff] ?p+0x26ffff co0x17<fffff se1/0fff _save+0x66/0x8
Dec  4 11:57:44 iridium kernel: [<f1b
Dec  4 11:57:44 iridium kernel:  222 00016de800c126810553b0>] s? _m_pollsched+x499/0x505xe0
Dec  4 11:57:44 iridium kernel: <0xf
Dec  4 11:57:44 iridium kernel: x14de
Dec  4 11:57:44 iridium kernel: g+0x2e_sta_cpu+0x19/0x2ffff? t3/0ff81hed0f/ffffff8_sh18ef81nop+0x0fff waf/0fff __cpus_w__neschedd55f81033ffffffff<4> [9
Dec  4 11:57:44 iridium kernel: ffff4> [<fb
Dec  4 11:57:44 iridium kernel: 0      1f880fff8804> f00 ffff331c7> [<ff8133042826>] ? x18fff km<4>090+0xffffffoc_0xaff81read+0x<ff>] 0x6ff8tem_calS 0008c79c50d880128 006037er+08d/0eout+er+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: 0x499/0xc
Dec  4 11:57:44 iridium kernel: _on_nts_p__rm2905>]] ? avone_st9>] ?] ? ta>] ] ? tg_noptg_tr __cxt_cpu+0x19<ff][5>]ct+> [<ff] ?ity [<f8c>] ?_fa4> 1e4t_t
Dec  4 11:57:44 iridium kernel: [<d9
Dec  4 11:57:44 iridium kernel: > [<ff1b
Dec  4 11:57:44 iridium kernel: < 2272 2 0000f816de20
Dec  4 11:57:44 iridium kernel: 8 ffffff81fffff812ec23dffff8f810cd1c0>ff810ffff810fff0x3<4> 
Dec  4 11:57:44 iridium kernel: [<eld_IPive_s] ? spinf8103a5 [<fff> [<ffffffff cox17fffo_f73
Dec  4 11:57:44 iridium kernel: 810ee+0x4fff? me+0x[<ffffsysx15ff8dity+0x10_fast0000000000 fffdc400281>Cal22/0xb4> [<fffffffff8810c5b8>] f8103a3a5b03a5bb8>]? fla101f860x4f4> [<ffffff] ?rqr
Dec  4 11:57:44 iridium kernel: <45a6>ke_
Dec  4 11:57:44 iridium kernel: <403a5c5ke_xf
Dec  4 11:57:44 iridium kernel: 810ys_sele
Dec  4 11:57:44 iridium kernel: <4061ex+> [9224>] sysl_enll_fg t00082 816d88012fa00c7f810fffff [<fa4
Dec  4 11:57:44 iridium kernel: <2/0xc3
Dec  4 11:57:44 iridium kernel: 103t_w/0xf106x+0[<ff>] ? _y+0<ff>] sk_fai [<37>xe/fff? geet_ts+> [<fff>ir8801801200 ffff 0000all Trleep+0er_na5>] ? do_nanosle9
Dec  4 11:57:44 iridium kernel: <058eepffff] stpa4>
Dec  4 11:57:44 iridium kernel: m 00    1
Dec  4 11:57:44 iridium kernel: 9df9c8 82 50 00
Dec  4 11:57:44 iridium kernel: 6de16de8 000ce:
Dec  4 11:57:44 iridium kernel: 4> 4> fff8810ccb810cd1c0 ? de] ? a4>] ?fff81<ffffffff8126b4eup29
Dec  4 11:57:44 iridium kernel: 0e5k_che
Dec  4 11:57:44 iridium kernel: <133k_kern> [d55lec<4> [<d>]erm [<f8>/0x6<4> [ffff0102d/0869e31ef9
Dec  4 11:57:44 iridium kernel: f8801289000a0ace_bh+0xdp_conffffffff81051athr<4>199ake_0cv_d? autoremoveff8ff81xf
Dec  4 11:57:44 iridium kernel: <4<4> [< [<f
Dec  4 11:57:44 iridium kernel: e3
Dec  4 11:57:44 iridium kernel: e_fuokup_light+4> 87e0xafff_sp21/fffff81h_p4> 024l_fast<4>   b67   88012585f00000 ff2580125874>] edulewait0xa1
Dec  4 11:57:44 iridium kernel: [<fffffffff4> [x0/0xf
Dec  4 11:57:44 iridium kernel: <> [<81055
Dec  4 11:57:44 iridium kernel: udit+0x74/0x78
Dec  4 11:57:44 iridium kernel: <4ff8kfd1b/ff8s_s07
Dec  4 11:57:44 iridium kernel: 8113faas_
Dec  4 11:57:44 iridium kernel: <4330_retur [<b3>x1dfff sysm_call_faf8893b112699fff8808d319
Dec  4 11:57:44 iridium kernel: Ca83/0x28eta+0ut+0xd6/0a1
Dec  4 11:57:44 iridium kernel: <471
Dec  4 11:57:44 iridium kernel: [<xe0
Dec  4 11:57:44 iridium kernel: <functi_function+0[<f>] unc[<fc>]msg [<fff ? 0xffff] ? do/0xfffautunc
Dec  4 11:57:44 iridium kernel: [<ff0xc9
Dec  4 11:57:44 iridium kernel: <on+0xamissput+0x [<ffff1b
Dec  4 11:57:44 iridium kernel: <3576     ffff88fff8162dfbll Tr0x65/ove_tex_lock+0 [<f5>]/0xf81de_0x6ff810brea4> 5199ve_wak0x3ff8linsio4> [+0x11/0<fffff816>wp    0> ff880duleait+xa18
Dec  4 11:57:44 iridium kernel: <4 [<fffffffffffff85>] ? treamerm+t_has] ? _re_sys_sel213810c_r> [199e_wx0/0x3f81ele<4>7e7d8>ll_135f81m_c0x16/0x     0000000000058fff8816180e80125000000f7a183ce:f810b9fre4> f95asecb
Dec  4 11:57:44 iridium kernel: 2/00xe0<4>
Dec  4 11:57:44 iridium kernel: <4
Dec  4 11:57:44 iridium kernel: <40x0/0x_functiofaulfault_w90f12991>] 9>] ? f81fffff811<4> [<fx11/0x21
Dec  4 11:57:44 iridium kernel: <4f810unt   4> 00000012581c530 ff1ae2258c42dd88a8:
Dec  4 11:57:44 iridium kernel: <10b9c3ee+ [<70>]e/0x65813le_xb4f81queue_sigeduffff<4> [< [<fff[<ff> [<f
Dec  4 11:57:44 iridium kernel: 1
Dec  4 11:57:44 iridium kernel: <00000 ff816df88012125waiteup+0xait+0x2ault608dick_next_td/0fffd_t<ff>] ay+[<ffff? k49/ffffys_fut4> 71b+0xfff>] system   S f880 fff6de500ff882594bit+00x0/4
Dec  4 11:57:44 iridium kernel: <4fffffffff810resrea0x964> fff8110102
Dec  4 11:57:44 iridium kernel: a24930000500 2faa4e8 00[<ffffffff8 __d0x3f81_ti4
Dec  4 11:57:44 iridium kernel: <10clwait+<ff>] 2e/0fffff8s_p1
Dec  4 11:57:44 iridium kernel: <10clwa4> [<ffff0xftion_wak defau031e56c>]ke_f0xdc<4>  [<f [<f[<fffff0>] ll_fastpa0000080126035a6e
Dec  4 11:57:44 iridium kernel: ffde5e5198000ab8 ff<4>> [a6entity+ [<f6>mpt0x1ffff3e
Dec  4 11:57:44 iridium kernel: [<0x22/ [<[<ff> [<fffffffff
Dec  4 11:57:44 iridium kernel: [< [<ffffffffff810 [<f<4> ffffff810ex_<4>8ff>5/0xfff __+0x61/fffpicir+[<fffff? ftch [<0e>turn1d/0x25
Dec  4 11:57:44 iridium kernel: /0x  0  000ffff81ffff88176<4> cd
Dec  4 11:57:44 iridium kernel: /0xb4
Dec  4 11:57:44 iridium kernel: > [ [<fffffffffff810ffffff8> [<fffffffff0xf
Dec  4 11:57:44 iridium kernel: ock+0eck+0x82/0xfff geate> [377_fr4> [<f>] s+0 [<14>] ?_sw0x7ff8rt_0x31/0xx7d/0x21
Dec  4 11:57:44 iridium kernel: <4[<ff1b
Dec  4 11:57:44 iridium kernel: < 271082 0 ffffff0122waitfuncmon+0xed/0xffffff8103408c>]<4> <4> [<fff>] +0xfff_fu
Dec  4 11:57:44 iridium kernel: <40c7ut+0x1fff? antr<4> [<a>]ast
Dec  4 11:57:44 iridium kernel: <4shoacb6080  000000e5004> ffff81228feedimeit+020/0xa1e/0/0x50ffffffff
Dec  4 11:57:44 iridium kernel: <4fffffffffff[<f [<fffff<4> [<f<ffffffff8autnct [<] s/0xfffaudit_x10fff] stpath+6>s 00    1
Dec  4 11:57:44 iridium kernel: 69959c126995880120008
Dec  4 11:57:44 iridium kernel: <4e_t__po0x1f/0x28
Dec  4 11:57:44 iridium kernel: <ffff03a03a516c7 ? 142f6fffffffff81100616
Dec  4 11:57:44 iridium kernel: <16
Dec  4 11:57:44 iridium kernel: [<ffef3>ode<ff? pde+<ff>] ? pe+0fff] ? e_inod4> 2621/0fff d_lookups_srel>] ? f810<ffffffffd810102etd  ffff880 ffff88801028a94> [<fff8<fffff> [<fffffff810ccb7lec4> c0>0/0fffdeftion+0fff? dncti> [<ff] ?fun<4>3a5t_wake_? udp_soc1>] ffffffff[<ffffffffffffff11e>dit_stem00000000f816f814ab229da9>]o_wadefault8104system_call_fx16/sql801770ff8000000000012ffffffff8801012ff8000ff8fff880d_reschait+ll+0sched+x4990x0/0/0xf
Dec  4 11:57:44 iridium kernel: <
Dec  4 11:57:44 iridium kernel: f8109<ffff4> [<ffffffffsch10ffff_sha18ef81nop+0xfff waf/0ffff81us_45
Dec  4 11:57:44 iridium kernel: 811xt_
Dec  4 11:57:44 iridium kernel: [<310/x17_senf4>c2>]388ca>ffffe7d8fffqld   01209a1c1289518801209000004>Cal0/0xaa4
Dec  4 11:57:44 iridium kernel: <40x26327/ion+0x0/0x90/text+0x21
Dec  4 11:57:44 iridium kernel: [<f6120xffffath
Dec  4 11:57:44 iridium kernel: <407esyscalx13ff8em_c0x16/0ld 801  2 ff8 00000000
Dec  4 11:57:44 iridium kernel: 91ae0028all k_i fut_up_+0x4on+0x04> > [a/0x4> ff81] ? a>] system_sqldff8801234d300000008616d16d091faa453009180034d3091837:
Dec  4 11:57:44 iridium kernel: <108accc
Dec  4 11:57:44 iridium kernel: <4519ve_0x0ffffffpin<4>612b+0xf5/fff pa21
Dec  4 11:57:44 iridium kernel: 810it_sysa>] s    ff880 fff16defff81258_timt+0x8dut+x1c [<<4> [81331
Dec  4 11:57:44 iridium kernel: [<4> 8105e_fau tracfffff81010a07>] gs+fffcor7/0fff __+0x61/fff__s/0x3ffff81_nex9dfff? fitch/0x15a
Dec  4 11:57:44 iridium kernel: 0x46astp00008 00d198530 ff0 ffffffffffff[<ffff> [<f4> [<fff[<fff811dea>] 0aae2ffff8109fefffff<fffff4a51>] ? d+0x<ff ? _th<4>31cardirq/0xfffestx30
Dec  4 11:57:44 iridium kernel: <4cbfset [<55>lect+0entity+_tonext_t>] ?10cd111010    963c
Dec  4 11:57:44 iridium kernel: ffff880fff805f39? mnt_watime+0xda/0faulfutex+0x90<ff] ?y+0fff? pfai> [<ff] ?k+0<ff>] ? tab/fffys_13
Dec  4 11:57:44 iridium kernel: f810c71b3107e7d8fffff16/  0  2783ff880116de2fb1fffffffff8[<ff3c
Dec  4 11:57:44 iridium kernel: 0x99b4
Dec  4 11:57:44 iridium kernel: <4> [<ffff>] t_i9/0f81t_s16bffffffspi1/0fffpath_p> [7d8cal0x1ffff81ysqld  ff88012f8800 fff00004>Cafaultx3a4
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: 0c711061f810c7] ? audit_sy+0[<f] sth+<6>S 00     <4>e18082000 fff<4>50050071092ddc8 f61b>] ? _>] se4>] ? __mepol defait_scall_0    0000000d
Dec  4 11:57:44 iridium kernel: 40 ffff88012> ff 00fff880allfff] ? __0xcff8dule/0xb4
Dec  4 11:57:44 iridium kernel: 104ss_b
Dec  4 11:57:44 iridium kernel: <104d_timell_watl+0x2a_funcit_024d  
Dec  4 11:57:44 iridium kernel: <4fff8f880012fa9cl Tr/0xcd
Dec  4 11:57:44 iridium kernel: <d/0xb4 [<ff10ccbp_set31dea10aaec0>] ? __p0xef81e_m63
Dec  4 11:57:44 iridium kernel: 811lev32
Dec  4 11:57:44 iridium kernel: <fffre> [2a3b>] ? fffff13
Dec  4 11:57:44 iridium kernel: y+0xxb/ath+9509c0000e5004> ff88o_sytimeou+0x1ex38<fff0/0xf
Dec  4 11:57:44 iridium kernel: <135
Dec  4 11:57:44 iridium kernel: >
Dec  4 11:57:44 iridium kernel: <6896   20086500 ffffffffff8fff000000f88Call Trfffys_72/0ffffff8ode/0xfffo_s/0x12dx4f
Dec  4 11:57:44 iridium kernel: <ion+0x4ee_p secfff8ffff] sy000000000ffffae20009b7>] ? i_sync_re+0xn+0xx4e/0fileurity_file_0x1fffaud0x1<ff>] 0xd
Dec  4 11:57:44 iridium kernel: 102ll_0x1b       c338  880000f88011ffffff81 ff000 fffff81ffffff fff<fff2a3b>]8113bfffffffffa>] sy 00000 000fffffff1971fff811319fffffff810bfdcbc_re<4>199ake0x3ff8free+0xfff] ?perxb8
Dec  4 11:57:44 iridium kernel: 3b8y_f+0xfff>] ?f81131a4a>]    fff00 000816de5ffff011amtime_permreafunctio
Dec  4 11:57:44 iridium kernel: [ssione_permi] ? 31a4a>] syttpdfff880119c89d0000000fff8168161a22fae2e21a281100001a2148ae:
Dec  4 11:57:44 iridium kernel: 811mti631ff81140ffffffff<4><ffff/0x_perscalp+0xb/x16/0913 19d96de5dfb84>C12e/0xf
Dec  4 11:57:44 iridium kernel: [<ffff8155>] ?1330e21fffff801024a>] sysast<4>  S    1
Dec  4 11:57:44 iridium kernel: e2b000086 01 dc
Dec  4 11:57:44 iridium kernel: 6de6de500 00 30
Dec  4 11:57:44 iridium kernel: d68b109e2bac8fffff8ff81fff81fffff8fffff8fffff3a5b3a53a53a53a5b3a5b3a5b3a5bbfdc] ? finspinx62x1d/0x39/0xx16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: dae0004  1190000000000000f81f81119d12fae2e119222119119l Trac2/0xb4
Dec  4 11:57:44 iridium kernel: 5c/vmsg_hatore1299>] sync_to_fake_y_ffile_prity_fs_r/0x60x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: 1
Dec  4 11:57:44 iridium kernel: <880e500 fffff8012bd23198
Dec  4 11:57:44 iridium kernel: <ce:
Dec  4 11:57:44 iridium kernel: <810tim[<fb>]out [<fff ? t+0fff ? __moxcdf81polx45fff810c71f81ffff4> [<f00  29f880118c91a788133ffff81e84d2201190222437c91e84aceff81331unl+0xfff] ?tity+0x22e0
Dec  4 11:57:44 iridium kernel: [1
Dec  4 11:57:44 iridium kernel: fffff8103a5[<fff[<fff
Dec  4 11:57:44 iridium kernel: [+0x0//0xc
Dec  4 11:57:44 iridium kernel: ed
Dec  4 11:57:44 iridium kernel: <<4>fffff0x0k_sw9/0xc
Dec  4 11:57:44 iridium kernel: [<ffffffff8ys_<4>24astp<4>   3e700   18c900008c93a78fe416d16d8c72bd22e000000<ff0x3e
Dec  4 11:57:44 iridium kernel: 0x46/0ut+0xait+xa1
Dec  4 11:57:44 iridium kernel: [<ffff8103a58103a810551ffff8112991f81331c78109cb>] remo03e2ad>[<ff810bf8f8>] ? fsacces4> b3>]/0xfff_po4> [<ff>] stp<4>
Dec  4 11:57:44 iridium kernel:    S 00    19df00000000000 fff81> fffac8fff8fffff88104a7c>] sys_pt+0xon+0on+0on+on+on+0on+0x0ion+0_funcefaul103a8113b85c>] ? fil11/fff8_pu> [63039/0x85f81m_cx16onsole-012 29fff000 0000006de5009dc003ffffffffff
Dec  4 11:57:44 iridium kernel: [<fff813] dollwunctiounctunctunct+0x60x100
Dec  4 11:57:44 iridium kernel: <ffff103[<ffff31/0d9
Dec  4 11:57:44 iridium kernel: [<fffff1b3>x1dfffoll [<4a>fastpat>
Dec  4 11:57:44 iridium kernel: <d S000     1
Dec  4 11:57:44 iridium kernel: 5bc0005bc5bbff816de40
Dec  4 11:57:44 iridium kernel: <5bbc8ffff8ffff+0x2_filult_ex+0e7/0x
Dec  4 11:57:44 iridium kernel: 0x38ffffc71udit_system_88012ac300016de fff5dcc8f [<ffffffff8vt_/0xf81t_wx0/fffsecurit0x1ff8octld
Dec  4 11:57:44 iridium kernel: 77ferm [<ff>0xb5/0xerm+0x61/0x0x5d//0x7/0x20x7ax1b
Dec  4 11:57:44 iridium kernel:    1cf8 ff0 f000000l Trx1cbb
Dec  4 11:57:44 iridium kernel: <xf
Dec  4 11:57:44 iridium kernel: 4> [<ff8113 do_? inodecefa3>fs_ioctl+0 [<1>]24dfffs_i
Dec  4 11:57:44 iridium kernel: <401024a>fasb
Dec  4 11:57:44 iridium kernel: <kit-ac30680   118000118ffffffffff88a88 09e81 relea811d>] ?>] ?t_ioperx973<4> ffff>] dioctpath+0x1 2965 fbcf8ffffff8dc40
Dec  4 11:57:44 iridium kernel: <cc8 ffff880114>C[<f] ?sem4> 425ive+0x8fff ? unct4> [<ff>] abl [<de>1057/0x170x4e/b5/0x9erm+00x761/0x2a/6a
Dec  4 11:57:44 iridium kernel: <fffffcon> ffff8f8 fffff816d880118ffff889>11d425>]  secx105s_perdo_fut_perm+0x5b/ffff tt7c8
Dec  4 11:57:44 iridium kernel: 0cbl+0<ff>] do_v/0xfffs_io
Dec  4 11:57:44 iridium kernel: [<4a>fasb
Dec  4 11:57:44 iridium kernel: <kit2ac30688 00000
Dec  4 11:57:44 iridium kernel: 8d02e2000
Dec  4 11:57:44 iridium kernel: Caase_caitactiault_w? s>] v ? av5/0x0x5b/fffffa01>]sys_em_calffff8880118d<4>0118d00004>Callse_consd4255> ? default_on+0fff sece/0fff_io71d
Dec  4 11:57:44 iridium kernel: <43e7_pe4> [08ff>]5/0fff inx5bfffffff81ff81010cba0ff810c0102consfff80008d05c400000> [<4> fffffffffffffff8113e? dom+0x5+0x76ctl+d/0x26a
Dec  4 11:57:44 iridium kernel: <4810ctl+ffffystth+<6>S ffff  0<4>d28 082 ff000<4>5005008000 ff00000 Trsemctive+t_wak] ? _iocerm+973
Dec  4 11:57:44 iridium kernel: 4> [fff8] dooctath+0 0  f88011fffd19a88all Tconso55>]default_wak0x0/0fffcurx10f81ctl
Dec  4 11:57:44 iridium kernel: [7f>rm+[<fff>] ? x97ff8ode/0xffff811ce10cba01>10cb24a>] sole-k8801000ae200 <ffff810f8113d52d avcex+0xb0x5[<ffff1>] cba730102it-d S 00000   1
Dec  4 11:57:44 iridium kernel: 3d22 00 00
Dec  4 11:57:44 iridium kernel: <de500 0 f0 f0
Dec  4 11:57:44 iridium kernel: <41c8a8 0 f8 f8
Dec  4 11:57:44 iridium kernel: <<4>1d4255>3a5b8>ff8fffffffff<fff<fffffff1ceffs_i0x24d0x7ax16/0x  0 082 ffffffff88fb8
Dec  4 11:57:44 iridium kernel: <semitact? de ? securitye/0fffctl> [77ferm [<fff ? 0x9fff8node_h61
Dec  4 11:57:44 iridium kernel: 811ctl4> cb766>]1>] do] sem_c 00018d200000118200000
Dec  4 11:57:44 iridium kernel: ffffffffffffff8117f>inotl+0x2a/0x76a
Dec  4 11:57:44 iridium kernel: <f810d S 0ff8800000500 ffff880fff88> f0000f88f88Cal<ffffft_w/0xfff8efault0x0fff se+0xfffffffffffffffffffffff810cfff8] systfff8000000f8d2c33cce89d4255? defa? securit+0x160
Dec  4 11:57:44 iridium kernel: <973
Dec  4 11:57:44 iridium kernel: <m+0xc8
Dec  4 11:57:44 iridium kernel: [<fff766>2a/fff_ioa
Dec  4 11:57:44 iridium kernel: <10ctl+0x5fffsysath+
Dec  4 11:57:44 iridium kernel: cofff   
Dec  4 11:57:44 iridium kernel: <47d200082 fff816d801100 ffe:
Dec  4 11:57:44 iridium kernel: <em+0x19/0xx0/10
Dec  4 11:57:44 iridium kernel: <ffffff811efa3_ioc24d/> [<
Dec  4 11:57:44 iridium kernel: co<4> 0000c40 00020b8
Dec  4 11:57:44 iridium kernel: +0x89/0xbb
Dec  4 11:57:44 iridium kernel: <4fff8fau+0xfffecuxe/fffff81ctl
Dec  4 11:57:44 iridium kernel: <413es_perm[<fd>]erm [<fa3>] t6>] vfvfsioctlall_faf88012d3bd
Dec  4 11:57:44 iridium kernel: fff8f88ffffffff3a5b3b2e>]_has_pperm+0xx3e0fffffff81<fff01024a>] sastp<4>d S    1
Dec  4 11:57:44 iridium kernel: d3d00008200 00
Dec  4 11:57:44 iridium kernel: 6de6de50010 10
Dec  4 11:57:44 iridium kernel: d410008d3dccf811dff8103afffffff811d5fff08ff>]140tacefaulturity_+0x1057/fff? a/0x810ute4> 028d>]rm+[<f3>]61/0x7ff8ioc4> ba0ctl+0x<4> [<16/0 1
Dec  4 11:57:44 iridium kernel: <40000 ff98 00000Call ctive+0unctixe/0x157 ttyx7c810c+0xfff] d24d/0xfff_io<4>1024a>astp
Dec  4 11:57:44 iridium kernel: <4it-00088      1
Dec  4 11:57:44 iridium kernel: <40000 ff0
Dec  4 11:57:44 iridium kernel: <4d63cffff3a5b8>] ? d_fu<4>246>abl [<de>057/0xfffavc/0xfff8114_ha61
Dec  4 11:57:44 iridium kernel: 811ctl<4> ffffffff8fff810c01024a>]sole-fff8801ffffff6de500 ffff8fffff ff1041 [<ffffff/0xf [<f<ffffffff8113avc0x6810x+0[<fd>]erm+0xfff tt0x7fff810tl+[<f1>]0x2[<fffffcon<4> 0000fff<4>8d6d425? d? soctm+0xb/0x
Dec  4 11:57:44 iridium kernel: fffff810cba013>]fas 0  20000> ff880118d6ae2880118002118d69aceff8lease_cc6/fffvt_w9/0xbb810ult+0xfff ? secuvt_ioc_hado_finode_ tty vfsl+0xa
Dec  4 11:57:44 iridium kernel: <
Dec  4 11:57:44 iridium kernel:  2fff880116de50118df f<4> [> [<f
Dec  4 11:57:44 iridium kernel: ion+0ity_x1057/0x171dfffffavcx60060ex+ [<8d>] ? +0xfff] ? x109/0xfffy_ic8
Dec  4 11:57:44 iridium kernel: 810octltl+0x0x55/h+0x16    00000ffff0 ff2dff:
Dec  4 11:57:44 iridium kernel: <41dc
Dec  4 11:57:44 iridium kernel: [<fff[<fffffff3e77 ? das_1/0x/0xa
Dec  4 11:57:44 iridium kernel: [fffff<6>co4   82 f0 ffffffff816f88880ff8002801801lm+0 [<fff vt89/fff denctie/0x10
Dec  4 11:57:44 iridium kernel: 1d
Dec  4 11:57:44 iridium kernel: <40x60
Dec  4 11:57:44 iridium kernel: <x973
Dec  4 11:57:44 iridium kernel: <5b/0x1/0x[<fffffff8] systd S ff0118d ffff0 fff18d71041ff811f810<4> fff8fffff81fff811<fff> [<f810cba01>]tl+0x [<f>] s7a
Dec  4 11:57:44 iridium kernel: <810_ca16/0x1be-k12a299fff880000801fffffffffffff0
Dec  4 11:57:44 iridium kernel: dcc81041[<ffff> [<ff0x0/x10
Dec  4 11:57:44 iridium kernel: <4<ffffff81028da3>] vdo_vys_ioctlastpa  0  82 f16de5084530
Dec  4 11:57:44 iridium kernel: 7fccff81fffffffffff<ffffffff81secuxe/fff8tl+0<4>3e7_perm+<ff>] 5/0fffff81de_0x6ff8ioc8
Dec  4 11:57:44 iridium kernel: ff810cfff8024e-k ffff9cf8 00ffff0118d848a8
Dec  4 11:57:44 iridium kernel: nsolive+ction++0xe/
Dec  4 11:57:44 iridium kernel: ffff8114028d11cevfs_ifs_ioctys_iocfastpath+0x1
Dec  4 11:57:44 iridium kernel: S f    4> 28 82 f8 00004> 00 00 40 ffff4> b8 00 c8 fb8
Dec  4 11:57:44 iridium kernel: sole_waitacult? sece>] >] ? 8ffode_h+0x7
Dec  4 11:57:44 iridium kernel: fffff024ad S ffd28 000008d9000 fffffff8f811dffffxf
Dec  4 11:57:44 iridium kernel: <4> [<fffff>] vt/0xfffhas_0
Dec  4 11:57:44 iridium kernel: <106tex+0xfff] ?m+0<ffffffty_7c8f81oct4> [<fffff [<ff8nso<4>0000801100000 Trac> [<f0x0/0pable+ctl+m+0x4e/0x6fffo_f<> [fa3>] t/0x7fffs_i
Dec  4 11:57:44 iridium kernel: [01>+0x[<f3>]55/0x7apath+00  00000ffffffff000000<4> 4> [<f4> > [<ff<4>0
Dec  4 11:57:44 iridium kernel: b/0x6 [<810cba10cba7301024<6>c4> ffff8801100000000000ffffff88088012f880000880880118dTrafff_wa0xbffffffffffff81ffff8d>]11c6>] vfs_ioct0x55/l_fa000000082ffff0 ff030
Dec  4 11:57:44 iridium kernel: ffffffff8efauon+ffffecurxe/ffft_ioctl
Dec  4 11:57:44 iridium kernel: <413es_pe<4> [<d>]erm [<a3>x761/0x7ca/0x78
Dec  4 11:57:44 iridium kernel: x264> [</0x1 3005 00006de500 a8378 000000 ffffff>Calfff vt89/fffff81auln+0fff ? secuxe/ffft_i171fff8ffffffffffffff766>]o_vs_iotem012a0000016de500 ffff00 ff0 f<4>  00 ff ff
Dec  4 11:57:44 iridium kernel: Ca<ff>] oledc
Dec  4 11:57:44 iridium kernel: 425ive [<b8>ake_funcrityctl+as_petex+0perm+0xx7c8fffff10cba73>] sys_io55/0fffem_6/0xsol8800  3007ff8000ff80000000ffffffff8ff84> ffff8808 ff89>8111036>] ?de>] vs_perfute0x5b761/0x7x2a/0l+07a
Dec  4 11:57:44 iridium kernel: [<24a>]fas<4> S f80    18db5d20085cf000816de50e50c53dc418d0200> [<f6/0x1dc0xbon+0xpabl0x10s_perm/0x9731
Dec  4 11:57:44 iridium kernel: ffff01>] s_iostpa ffffff880118db8
Dec  4 11:57:44 iridium kernel: <4em+0x1tactive def? security_c/0x10ff8tl+ [<7f>rm+[<fffff? dx97ff8ode_has1
Dec  4 11:57:44 iridium kernel: <11ctl+> [b766] do_vfs_system_d S 80118d0000f880000000000all e_sem+ctive+akeecuiocs_pb5/0xm+0x5b/0x+0x761ctl+0xd/0x26a
Dec  4 11:57:44 iridium kernel: 810cba7tl+fffystth+<6>S ffff  0<4>d28082 fff000<4>5005001710 ffff0000<4>x1dc
Dec  4 11:57:44 iridium kernel: 4> [<ff4> <4> [<ff [<fffffff8fff811> [<
Dec  4 11:57:44 iridium kernel: [ [<fff6a
Dec  4 11:57:44 iridium kernel: a
Dec  4 11:57:44 iridium kernel: <> [<ff4a>] sast4>
Dec  4 11:57:44 iridium kernel: S f0     18dbfd28082cf860016de500500e20c408dc00000000 ffff880118dbfcc8  Tr0x1dxbb
Dec  4 11:57:44 iridium kernel: _func se>] ve77f>81008ff>]0xb5/fff ino/0xfff_io8
Dec  4 11:57:44 iridium kernel: 766x2afffdo_vfs_26af81oct> [024a>] ole-kitfffffffffde500 ffc48a8<4>Cale_co] vt] ? defffff8<4> [<4> [<0x60x973
Dec  4 11:57:44 iridium kernel: 14028as_p4> [3>]61/fffvfs_ioc4> ba0tl+> [<ff] s0x7ff8em_+0x16/00    000ff81688011d8880118dff81044> [<4> [<fx0/0xfcapab_ioctl+vc_has>] d>] ? inodx5b/0fff_io4> b760x2fffffffvfsx26ff8ioctl+<ff>] stp<4>it-d S ff8801f fffdd0378 078
Dec  4 11:57:44 iridium kernel: <ole_sem+waitefault46>fffffffff<ffff> [<ffx61
Dec  4 11:57:44 iridium kernel: efa3>x76ffff_ioc<4>cbactl+0x<ff>] /0xfff8101cal6/0sol880 0  ffff8de500 fdc418dffffff81[<fffff8103a [<f
Dec  4 11:57:44 iridium kernel: <4> [<e/0x6xb5/0xrm+0ctl+oct+0x2a/0ffffdo_0x26810ctl [<4a>] sypat>
Dec  4 11:57:44 iridium kernel: <d S680   1
Dec  4 11:57:44 iridium kernel: <d9d000d9cffffff
Dec  4 11:57:44 iridium kernel: 880118d0004>Cconsoltacti_functurityt_iavc_ff>] ?4028d811cfffff810cba01ctl+> [3>] x7af81m_cx16/0x1le-012 30ffff880000880ffffff fff> fffcc8 fff041ffffffffffffffff8ffff8fffffff> [<
Dec  4 11:57:44 iridium kernel:  [<f6a
Dec  4 11:57:44 iridium kernel: a
Dec  4 11:57:44 iridium kernel: [<f4a>]ast4>
Dec  4 11:57:44 iridium kernel: <S f0    18e05d2082cf800016de50500c40c408dd0000 Trace_semtive+akeecuritctl+0+0x4exb5rm+x761/tl+0x2_iococtlem_d S ffff88   <4>8 0fff0004> 00 ffffffffff4> 78 0000ffffff4>C [<e89>] ?fffff8ff8f> [<ffffffff0608ff402811ce0cb810cffffffff8ction+0ction+ction+ction+x59/0xxf8
Dec  4 11:57:44 iridium kernel: <4
Dec  4 11:57:44 iridium kernel: [
Dec  4 11:57:44 iridium kernel: [<9
Dec  4 11:57:44 iridium kernel: [ [<ffffffff81ffffffhald- 2960
Dec  4 11:57:44 iridium kernel: 0000000816de5710
Dec  4 11:57:44 iridium kernel: ffff88011898 000 ffffffCall<ff>] ut+0x2fff? _/0xfff810res
Dec  4 11:57:44 iridium kernel: <40cct+0x> [<ffff[<fffff
Dec  4 11:57:44 iridium kernel: [<fff[<fff0/0x612
Dec  4 11:57:44 iridium kernel: +0x4e/9/0x5b
Dec  4 11:57:44 iridium kernel: 8
Dec  4 11:57:44 iridium kernel: 0x60
Dec  4 11:57:44 iridium kernel: <ct+0d+0xeerm+0xad+0xb8/0x1ry+0x0x16/0 0  086 000de500 fb197119da5ac8 ffff810ffffff81ff8104afe4>] ? p_timeo4> [<7c>]x1c/ffffdo_/0x371810cdllw4> a5b8>]_fu
Dec  4 11:57:44 iridium kernel: <403at_w0x0/0xf
Dec  4 11:57:44 iridium kernel: 0xc
Dec  4 11:57:44 iridium kernel: 47/0x4b5/0x170x3d/0x3f
Dec  4 11:57:44 iridium kernel: [<ffd25f8f/0xff8to_/0x4fffntput_n0x1ffflkde68
Dec  4 11:57:44 iridium kernel: e72_op
Dec  4 11:57:44 iridium kernel: <40bedata_to_f getnamreschreschencpy_ ? vi0c71b3>s_polltpath+   0  0000000 ffff
Dec  4 11:57:44 iridium kernel: fff3ac8 ff ? __mmeout+/0xb
Dec  4 11:57:44 iridium kernel: <41c/0xc+0x2a8x0/0x0xf
Dec  4 11:57:44 iridium kernel: [<fffa5b8>] ake_f
Dec  4 11:57:44 iridium kernel: <41deack+ffff] ? ko0x4bff8t_de7
Dec  4 11:57:44 iridium kernel: bc9>ce_<4>0c1isk_putput+to_hea? mntp? blk3>] ?810be810c9f9e>? need_r32>]4>] ? _10b810c71b10ccystem_cffff011795dc
Dec  4 11:57:44 iridium kernel: 4c530ffff880117955a8012l Trfffflab_8e
Dec  4 11:57:44 iridium kernel: <812releasb
Dec  4 11:57:44 iridium kernel: <41330e_tb4
Dec  4 11:57:44 iridium kernel: d29it+[<f5>]0x20//0x371
Dec  4 11:57:44 iridium kernel: <0xe0
Dec  4 11:57:44 iridium kernel: <n+0x0/uncti_has_pesock_aio>] ? sock_ainc_reawake_ftask_sfile_p? secc71b3>c630>] system  S fff 000000fffffffff8ffff88ace:
Dec  4 11:57:44 iridium kernel: <+0x27/0xcall_ce+0x1c9meout+store+0x27/0xffff ? ax3c/fffd_ch4
Dec  4 11:57:44 iridium kernel: <103a5bake_0xf
Dec  4 11:57:44 iridium kernel: f81_ldisc0xaff8rea> [0748>] vfs_6>] sm_callff8801dd48 04> fff0 ffff8801179fdd08 8fddface:8133nloc0x27ffff ? atoll_c5
Dec  4 11:57:44 iridium kernel: <11dn_writ
Dec  4 11:57:44 iridium kernel: 330_ti4
Dec  4 11:57:44 iridium kernel: <81331fe4810553aaffff8defaul6f>] tty_rexa8/0x102 [<ffff16/0x1b
Dec  4 11:57:44 iridium kernel: <0     000082 f0 ffffff
Dec  4 11:57:44 iridium kernel: ffff880110000fff8f880l Trfff? _sqresto> [ed0tif+0x13/fffdo_9a/ffff] schedulefe4>] ? _spin10553aaffffff811df8103> [<ff
Dec  4 11:57:44 iridium kernel: 4> [<f10c0866] sys883d331fff816ff816d82ae93901103000083dd82b1aceff8spin_unloc1334ed4> [<
Dec  4 11:57:44 iridium kernel: [<ffff0xb4x27/0x3queuen+0x4fn+0x0/0x13/fffffff810c01024a> S fff7961d4> ffffffff816dfffff888011011880110010801180118eracefffspistore+<ff>] ?ier13/fffff> [<ff[<fffffx27/0x<4> [<
Dec  4 11:57:44 iridium kernel: /0xf
Dec  4 11:57:44 iridium kernel: [xa1
Dec  4 11:57:44 iridium kernel: c5
Dec  4 11:57:44 iridium kernel: <4[<ffffffa>] syld-add960
Dec  4 11:57:44 iridium kernel: <400000ffffff011793d11793der+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: <fffffhedul/0xb810ess_xb
Dec  4 11:57:44 iridium kernel: <8104b5mer+ [<34>]0x2a8/ffff __pxe0f81fault_wa8>] ? d331de2>] ?2>] ?? scsi_si_di0x65
Dec  4 11:57:44 iridium kernel: <4x41
Dec  4 11:57:44 iridium kernel: [<fffff616d>_exp<4> 7d>]n+0fff] ? __37/fff? nlp+0x2fff? g1d2f81ed_rescsched+0xtrncpy_t_to_heb3>] oll+0x39/0x85
Dec  4 11:57:44 iridium kernel: <ffffystem+0xld-a0000 0  4> fff000000000004> ffffffffff8fff4> 8a8 000000093c8a8
Dec  4 11:57:44 iridium kernel: <_modb>] scfe4>] ? pro? __mod4>] do>] ? _? def ? def8133181167fff81>] ? s? scsi_disk_pux3f
Dec  4 11:57:44 iridium kernel: 810d2x2ffff8irt_0x3ffffffntpx31ffff ? blk68
Dec  4 11:57:44 iridium kernel: <810bntrx24fff810be<fffffffff81ff8133fff811 [<ff0x41
Dec  4 11:57:44 iridium kernel: <4ffffff24a>]  S 000006dc1b121c989
Dec  4 11:57:44 iridium kernel: <0116d420000 fffffffffff810ffffff
Dec  4 11:57:44 iridium kernel: [[<ffffffff8104 __m0xcd810cll+0> [1c0>t+0x0/ffffdefatio[<ffff? dencti> [c04ree+0x83/0xecute_rute_rute_req+0tl_i scsi_ffff11f11 ? sc0d25f8 virt_d>] ? ff810ff810sys_pofastpath+0x16/0
Dec  4 11:57:44 iridium kernel: S ff    4> 18 086 0000 fff4> f00 00 40 fff4> b8 07e f08 fb8
Dec  4 11:57:44 iridium kernel: <eout+0x22/wait+0x2c/0xx2a8/0xt+0x0/0xeon+0x0/_wakeult_wakult_w avc_inode_7>] 2a3b>]13b85c>ffff810c71b3>]put+[<ff] sy
Dec  4 11:57:44 iridium kernel: 0102all_/0x1b
Dec  4 11:57:44 iridium kernel: on-c6de489 f880117000117f81ffffffffff88011616ca9a88 ? __dedule_wait+20/0xa1
Dec  4 11:57:44 iridium kernel: <4a8/04> [<fon+0xction+e/0x6/0x1005b/0x61permew_sta0x21
Dec  4 11:57:44 iridium kernel: <4fffffff8101024em_cx16/d-ad0003190fff800000000002000fffffffff801fff8fff000ffff8ffffffffff81055ffffff [<fffffff8 [<ffffff4> [ffffff8[<ff38
Dec  4 11:57:44 iridium kernel: f/0xble_per_read+0x47l_fasff8800000000fff816de500 ff6de524530530
Dec  4 11:57:44 iridium kernel: 48a80000baa48a8
Dec  4 11:57:44 iridium kernel: [de5dlt+> [<ff] ? s_onx3cf81dule_timeo? __polnix_p_poll+0x2aollwfunctionefaul>] ? >] ? dffff8fffff8ffffffffffff> [<ion+0x0ch+0x31/0xc9
Dec  4 11:57:44 iridium kernel: <ffffselision<fff>] e_pe/0x13
Dec  4 11:57:44 iridium kernel: 10c7put+ [<f30>] sy85
Dec  4 11:57:44 iridium kernel: 810_ca16/org       23
Dec  4 11:57:44 iridium kernel: 00000016caae019e54c28:
Dec  4 11:57:44 iridium kernel: [n_thunk+0x31/0x39d400000000fff816dcaae20
Dec  4 11:57:44 iridium kernel: ff85fbf00868 f<4>> [<779>u+0x19ffff neee/0ffff81le_xb4f810ollw0
Dec  4 11:57:44 iridium kernel: [<ffffffff> [<fffffffff810fffffffffff8ffffffff2>] ? uffffffffff8ffffff<4> [/0x7a<4> [<<ffffffff8105519autonction [<] ? wit4> [d11e>]8/0xffff autry+0x1<ff>] stp<4>on-w 663fb18 000003d6640000303cee:
Dec  4 11:57:44 iridium kernel: [<ffffffff81312ffff810cc31fffffffffff81ff8129907f>] ? o_wr<4> 1f9>d+0x[<ff>] m+0x4efff set+0<ffffffff81 secit+[<f2>]t_queue+0x2wait+00x1d<4> [<gnome-ke  1
Dec  4 11:57:44 iridium kernel: <0 ffff8fff816198 00066431b0>] 296>]c590f0cc33 __pollwake_function+<4> a5b8ke_f<4>3a5_wak0/0xf
Dec  4 11:57:44 iridium kernel: 103alt_w0x0fffff8aultn+0xfff ? functioee+0x83_inode __slinux_inof81298129888 [<ff[<ffffcfd70>tput_no? __fput+0xl+0x3ll_fa00    086 ffff8801150fff8> ffffff880f880 fff 00000fffff81le_txb4f810parlusive+0x5c/recv_d? auto812a1b21>]a5c5>] ffffffffff810[<fffffffffffffff80/0x3cd/0x2a01/0x6a
Dec  4 11:57:44 iridium kernel: [<ff100e76ch_t4> [4>] up_l4
Dec  4 11:57:44 iridium kernel: 129a87m+0x<ff>] rq+0x21ffff? ftch [<1b3>] ?ll_fastp00000000086fff80
Dec  4 11:57:44 iridium kernel: c8 f ? __mod_] schrocess_t>] ? ___sys_p] ? efaul8>] ?ffff8
Dec  4 11:57:44 iridium kernel: 4> [<f<4> [<ffffffff>] ? dfunc> [<>] ?_fun
Dec  4 11:57:44 iridium kernel: 03a5b8ke_xf
Dec  4 11:57:44 iridium kernel: <810ult_wa/0xfff81fauon+<ffffffff8fffffkeyrin31b18 dc
Dec  4 11:57:44 iridium kernel: <4fffffff810000> [<ffff0xb4
Dec  4 11:57:44 iridium kernel: [<6/0xe20/0x> [<ffffff8103a5b8>] ?t_wa0/0xf810t_wax0/ffff8socket0x5bff81soc/0x7a
Dec  4 11:57:44 iridium kernel: 1299aio_00
Dec  4 11:57:44 iridium kernel: 810bsync_reaemove_w2ad>]81142a [<fffffff3
Dec  4 11:57:44 iridium kernel: [21
Dec  4 11:57:44 iridium kernel: <<fffffffme-set  1
Dec  4 11:57:44 iridium kernel: <cb9ffff816<4> f2bcb9ac8 104b61b>] ? __r+0xbb/0fffffsched/0ffffprocx0/0xb810d_ti
Dec  4 11:57:44 iridium kernel: <40cc334>0x2a<fff>] x0/ffffff81[<fffff/0xf
Dec  4 11:57:44 iridium kernel: on+0x0_functioault_wault_waka5b8>] ?a5b8>]ffff4> [<<4> [<0x31/ile_perrity_file_perx11/0x1fffffath_> [630>39/0fffff8m_cax16nomff8801 342ffff0000fff ffff00 ffff9a88 007939a8_allocc6432>] pitoremovf81330b10c6c5f811f810b810551
Dec  4 11:57:44 iridium kernel: [ssion+0x_permission+0<4> [<07488/0xff8read> [<24a>] tpat4>
Dec  4 11:57:44 iridium kernel: <   4340  49
Dec  4 11:57:44 iridium kernel: 1a30000000000000
Dec  4 11:57:44 iridium kernel: <4ff880118 000b8
Dec  4 11:57:44 iridium kernel: Call0x60/0ximeout+d6/0xe0x20/1e/0xx505
Dec  4 11:57:44 iridium kernel: <4/0xe0functionil+0x41/0x4a
Dec  4 11:57:44 iridium kernel: <ffffsockx18/0fffnix_g+0 [<fff ? _+0x5fff] ? soe8/fff __x6d/fffffff8fffff81b
Dec  4 11:57:44 iridium kernel: 213
Dec  4 11:57:44 iridium kernel: <4<4> [<ffff[<fffff0x121
Dec  4 11:57:44 iridium kernel: <[<ffff101/0xa00000000
Dec  4 11:57:44 iridium kernel: 0 ffff8800ba58 ffff00000ff88801ll ffff ? __mxcd
Dec  4 11:57:44 iridium kernel: f813ule0xb4
Dec  4 11:57:44 iridium kernel: <04afs_ti
Dec  4 11:57:44 iridium kernel: <404b_timer+0x1_poll+wait+ake_functidefadefault103a5b8>103a5b [<ff
Dec  4 11:57:44 iridium kernel: +0x0/0ke_fu defaul? default_wakn+0x0ffffs_po [<4a>]fastb
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel:  Sd80  3312b495b0008000000f81ff816de500 ffff8816feb1_check+eout+0/0x38
Dec  4 11:57:44 iridium kernel: /0x34> [<ff71
Dec  4 11:57:44 iridium kernel: [<ffxe0
Dec  4 11:57:44 iridium kernel: <nctiotion+0xction+0x0/0xffffff defaion+fff? dencti> [<ff] ?fun<4>3a5b8>e_fuf
Dec  4 11:57:44 iridium kernel: <4103lt_+0x0/0xf
Dec  4 11:57:44 iridium kernel: <_functit_wak selinux_ff8113ffffff81fffffff81ffff<6>g   1
Dec  4 11:57:44 iridium kernel: <0000de500 f
Dec  4 11:57:44 iridium kernel: ffff88011000000000f880l Trffff? __f/0x13f81ule0xb4ff810cwait> [<f85+0x2<ffffffff8ffffffffff
Dec  4 11:57:44 iridium kernel: [+0x0/e_funmsg+0xite+0adv_wrck_aio_re] ? ffff8133fff810c04> [<faf/0ermissi path_p sys_p_fastpath+0x1>
Dec  4 11:57:44 iridium kernel: bo S ff     <4> b18082 bd8 ff<4>500500 530 fff<4>8a840000048a8
Dec  4 11:57:44 iridium kernel: Calfind_sched96>] ?5>] ?4>] dpollwawake_t_wake defh_walrm+0x4/0x60x61
Dec  4 11:57:44 iridium kernel: de+0x14inodee+0x4e/0x65
Dec  4 11:57:44 iridium kernel: ock+0x9ify_m+0x1d/0x21
Dec  4 11:57:44 iridium kernel: fff81poll[<ff sypath>
Dec  4 11:57:44 iridium kernel: <a S ff    1
Dec  4 11:57:44 iridium kernel: <40bb1800082 00 000
Dec  4 11:57:44 iridium kernel: <4de5de5fec530 ff0002000ll Traon+0xmeout+0wait+0poll+0/0x371 [<fff [<fff [<fff [<fff [<fff [<fff [<fff [<fff [<fffffffffffffff810c8101024>
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: ffff880116000000fff88f880fffffffff8ff8801ff8000ff8ff8801l Trfffffut0x3ffff810374<ffff ? wa>] ? dff810600f4>] 10c2>] ke_up_+0x1cd> [<ffe7d8>] ?[<ffff16/0x1438      1
Dec  4 11:57:44 iridium kernel: <4113a600000000000
Dec  4 11:57:44 iridium kernel: 16d16de3a68005303a61053a63bd378:
Dec  4 11:57:44 iridium kernel: <103e_u/0x76
Dec  4 11:57:44 iridium kernel: <44b6 [fus+0x5b4e/0x60x0/0x0x5b/0x6> [<ffff0x0/0xermissioncurityc0748>+0x47//0x1b
Dec  4 11:57:44 iridium kernel: 1
Dec  4 11:57:44 iridium kernel: 0000006de500 0
Dec  4 11:57:44 iridium kernel: ffff8801 0000ffff8ff88ll fff ? on+0x46ffffus7/0> [<fff] ? m+0<ff>] m+0x4e/0tion+5b/0x61+0xe7/0nction+linux ? security_fssion> [<f8>] 102f810ead+ [<fff sypath>
Dec  4 11:57:44 iridium kernel: <e S ff    1
Dec  4 11:57:44 iridium kernel: <483b000000010 fde500 fffff8801113a71a04>] ? skb_release_d/0xcff813le_
Dec  4 11:57:44 iridium kernel: 0cd2wai> [<ff] ?0/0fff_sys_p
Dec  4 11:57:44 iridium kernel: <40cdwai [<5b8>]fff8103fffffff8129909>] ? sf810bffffffn+0x0sion+missid/0x21
Dec  4 11:57:44 iridium kernel: <
Dec  4 11:57:44 iridium kernel: [<f1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel:      1
Dec  4 11:57:44 iridium kernel: 00000500 f0
Dec  4 11:57:44 iridium kernel: f ffff9c04> ? skbschedu] ? __p5>] ? 334>] __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<nction3a5b8a5b8>5b8>b8>] ?fc>] 9>] ? soc100
Dec  4 11:57:44 iridium kernel: <4ead+utore8103e<ffff+0xafle_pe path_] sys_all_f S fffff80000000 ff0113a52e20
Dec  4 11:57:44 iridium kernel: <4880110116489a84>] ? ? sk308b0ff810cfff81[<ffff1
Dec  4 11:57:44 iridium kernel: 0x0/0xult_8103 [<ffctio_recvsock_>] ? fdcbff810x38
Dec  4 11:57:44 iridium kernel: <ask_switc9
Dec  4 11:57:44 iridium kernel: <4le_p13b84> [<f[<ffe500 ffffffff816de500 ffff880113a72e20 ffff880116caae20
Dec  4 11:57:44 iridium kernel: ffff880113a73198 0000000081765900 ffff880113c0bac8 ffff880113a73198
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<fftionault_03a5b> [<ftion+0fffff> [<fffffff
Dec  4 11:57:44 iridium kernel: 0/0xf
Dec  4 11:57:44 iridium kernel: n+0x0e_permcurifffff[<ffff<4> tpatfff881138fae0 fff81<4> 00000<ffff4
Dec  4 11:57:44 iridium kernel: x9/0_lock+> [<52/0poll+ollwailt_wn+0x0/ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: cpufreq-apple S 0000000000000000     0  3492      1
Dec  4 11:57:44 iridium kernel: ffff880113157b18 0000000000000082 0000000000000000 ffff880116caae20
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff880113a6ae20 ffff88012fae2e20
Dec  4 11:57:44 iridium kernel: ffff880113a6b198 000000022fad8000 ffff880113157ac8 ffff880113a6b198
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff81142a3b>] ? selinux_file_permission+0xaf/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff8113b85c>] ? security_file_permission+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: multiload-app S ffff88012b33da00     0  3496      1
Dec  4 11:57:44 iridium kernel: ffff88011317fb18 0000000000000086 0000000000000000 0000008000000000
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff880113a75c40 ffff880116caae20
Dec  4 11:57:44 iridium kernel: ffff880113a75fb8 0000000081765900 ffff88011317fac8 ffff880113a75fb8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff81142a3b>] ? selinux_file_permission+0xaf/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff8113b85c>] ? security_file_permission+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: tomboy        S ffff880118fd7a80     0  3500      1
Dec  4 11:57:44 iridium kernel: ffff8801131edb18 0000000000000082 0000000000000000 0000008000000000
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88011648dc40 ffff880116caae20
Dec  4 11:57:44 iridium kernel: ffff88011648dfb8 0000000200000000 ffff88000000f008 ffff88011648dfb8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff810930c5>] ? free_pages_check+0x82/0x8a
Dec  4 11:57:44 iridium kernel: [<ffffffff813308b0>] schedule_timeout+0x22/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd296>] ? __pollwait+0xd6/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff81312f85>] ? unix_poll+0x20/0xa1
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff81142a3b>] ? selinux_file_permission+0xaf/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff8113b85c>] ? security_file_permission+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: mono          S 0000000000000000     0  3515      1
Dec  4 11:57:44 iridium kernel: ffff88010e5cbe78 0000000000000082 0000000000000000 ffff88010e5cbea8
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88011329c530 ffff88012faa4530
Dec  4 11:57:44 iridium kernel: ffff88011329c8a8 00000001810575b2 ffff88010e5cbe18 ffff88011329c8a8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff81330e3c>] do_nanosleep+0x66/0xa9
Dec  4 11:57:44 iridium kernel: [<ffffffff8105805e>] hrtimer_nanosleep+0x6b/0xdd
Dec  4 11:57:44 iridium kernel: [<ffffffff81057855>] ? hrtimer_wakeup+0x0/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff81330e21>] ? do_nanosleep+0x4b/0xa9
Dec  4 11:57:44 iridium kernel: [<ffffffff81058124>] sys_nanosleep+0x54/0x6c
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: mono          S 0000000000000001     0  3516      1
Dec  4 11:57:44 iridium kernel: ffff88010ed5fc38 0000000000000082 ffff88010ed5fb98 ffffffff81020143
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff880118fd8000 ffff88012adf1710
Dec  4 11:57:44 iridium kernel: ffff880118fd8378 00000002000000fd 0000000000000001 ffff880118fd8378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff81020143>] ? apic_wait_icr_idle+0x1a/0x24
Dec  4 11:57:44 iridium kernel: [<ffffffff810264e1>] ? flat_send_IPI_mask+0x52/0x6c
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f391>] futex_wait+0x1b9/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5c5>] ? default_wake_function+0xd/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff81031eab>] ? __wake_up_common+0x46/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f6d9>] ? futex_wake+0xdc/0xed
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff810c957f>] ? path_lookup_open+0xc/0xe
Dec  4 11:57:44 iridium kernel: [<ffffffff810c97f1>] ? do_filp_open+0xb6/0x7db
Dec  4 11:57:44 iridium kernel: [<ffffffff81031023>] ? need_resched+0x1e/0x28
Dec  4 11:57:44 iridium kernel: [<ffffffff81330632>] ? _cond_resched+0x9/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff8116d894>] ? __strncpy_from_user+0x2c/0x53
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: clock-applet  S ffff880116de63c0     0  3502      1
Dec  4 11:57:44 iridium kernel: ffff880113257b18 0000000000000086 0000000000000000 ffff88002805f500
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8801131a5c40 ffff880116caae20
Dec  4 11:57:44 iridium kernel: ffff8801131a5fb8 000000032fb10000 ffff880113257ac8 ffff8801131a5fb8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810bfdcb>] ? do_sync_read+0xe7/0x12d
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff81142a3b>] ? selinux_file_permission+0xaf/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff8113b85c>] ? security_file_permission+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: clock-applet  S ffff880116de63c0     0  3693      1
Dec  4 11:57:44 iridium kernel: ffff8800ca571b18 0000000000000086 ffff8800ca571ae0 ffff8800ca571adc
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800ca455c40 ffff880113a54530
Dec  4 11:57:44 iridium kernel: ffff8800ca455fb8 0000000300000000 ffff88000000f008 ffff8800ca455fb8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff813308b0>] schedule_timeout+0x22/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd296>] ? __pollwait+0xd6/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff81312f85>] ? unix_poll+0x20/0xa1
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103e2ad>] ? finish_task_switch+0x31/0xc9
Dec  4 11:57:44 iridium kernel: [<ffffffff8133050e>] ? thread_return+0xab/0xd9
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: gdm-user-swit S 0000000000000000     0  3506      1
Dec  4 11:57:44 iridium kernel: ffff8801132c3b18 0000000000000086 0000000000000000 0000008000000000
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88011329ae20 ffff88012fae2e20
Dec  4 11:57:44 iridium kernel: ffff88011329b198 000000022fad8000 ffff8801132c3ac8 ffff88011329b198
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff81142a3b>] ? selinux_file_permission+0xaf/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff8113b85c>] ? security_file_permission+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: notification- S ffff880117aca080     0  3508      1
Dec  4 11:57:44 iridium kernel: ffff880113137b18 0000000000000082 0000000000000000 ffff880113137e98
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88011648ae20 ffff880116caae20
Dec  4 11:57:44 iridium kernel: ffff88011648b198 000000002fb10000 ffff880113137ac8 ffff88011648b198
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b3f3>] ? try_to_del_timer_sync+0x58/0x63
Dec  4 11:57:44 iridium kernel: [<ffffffff813308b0>] schedule_timeout+0x22/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd296>] ? __pollwait+0xd6/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff81312f85>] ? unix_poll+0x20/0xa1
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103e2ad>] ? finish_task_switch+0x31/0xc9
Dec  4 11:57:44 iridium kernel: [<ffffffff81142a3b>] ? selinux_file_permission+0xaf/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff8113b85c>] ? security_file_permission+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: gweather-appl S ffff880116de7740     0  3510      1
Dec  4 11:57:44 iridium kernel: ffff880113327b18 0000000000000082 0000000000000000 0000008000000000
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff880113a6dc40 ffff880116caae20
Dec  4 11:57:44 iridium kernel: ffff880113a6dfb8 000000032fb10000 ffff880113327ac8 ffff880113a6dfb8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff81142a3b>] ? selinux_file_permission+0xaf/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff8113b85c>] ? security_file_permission+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: mixer_applet2 S 0000000000000000     0  3512      1
Dec  4 11:57:44 iridium kernel: ffff880113371b18 0000000000000082 0000000000000000 ffff880113371adc
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff880113329710 ffff88012fb19710
Dec  4 11:57:44 iridium kernel: ffff880113329a88 0000000300000000 ffff88000000f008 ffff880113329a88
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff813308b0>] schedule_timeout+0x22/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd296>] ? __pollwait+0xd6/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff81312f85>] ? unix_poll+0x20/0xa1
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff81142a3b>] ? selinux_file_permission+0xaf/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff8113b85c>] ? security_file_permission+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: mixer_applet2 S 0000000000000000     0  3527      1
Dec  4 11:57:44 iridium kernel: ffff88010e591b18 0000000000000082 ffff88010e591ae0 ffff88010e591adc
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff880113298000 ffff88012fae2e20
Dec  4 11:57:44 iridium kernel: ffff880113298378 0000000203b3ebb0 000002000e591c18 ffff880113298378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff813308b0>] schedule_timeout+0x22/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd296>] ? __pollwait+0xd6/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff810c590f>] ? pipe_poll+0x2e/0x8b
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5a6>] ? try_to_wake_up+0x26f/0x281
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5a6>] ? try_to_wake_up+0x26f/0x281
Dec  4 11:57:44 iridium kernel: [<ffffffff8113e77f>] ? avc_has_perm+0x4e/0x60
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f6d9>] ? futex_wake+0xdc/0xed
Dec  4 11:57:44 iridium kernel: [<ffffffff8114028d>] ? inode_has_perm+0x5b/0x61
Dec  4 11:57:44 iridium kernel: [<ffffffff810608ff>] ? do_futex+0xb5/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff813320ea>] ? _spin_lock_irq+0x21/0x26
Dec  4 11:57:44 iridium kernel: [<ffffffff81033b5f>] ? __dequeue_entity+0x61/0x6a
Dec  4 11:57:44 iridium kernel: [<ffffffff8103e2ad>] ? finish_task_switch+0x31/0xc9
Dec  4 11:57:44 iridium kernel: [<ffffffff81142a3b>] ? selinux_file_permission+0xaf/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff8113b85c>] ? security_file_permission+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: mixer_applet2 S ffff880117acaa40     0  3528      1
Dec  4 11:57:44 iridium kernel: ffff88010c977b18 0000000000000082 ffff88010c977a78 0000000000000000
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff880113299710 ffff880113329710
Dec  4 11:57:44 iridium kernel: ffff880113299a88 0000000303b43f88 ffff88010ed56030 ffff880113299a88
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8109d950>] ? pmd_alloc+0x41/0x7c
Dec  4 11:57:44 iridium kernel: [<ffffffff813308b0>] schedule_timeout+0x22/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd296>] ? __pollwait+0xd6/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff810c590f>] ? pipe_poll+0x2e/0x8b
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f4ab>] ? futex_wait+0x2d3/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff81298f8e>] ? __sock_sendmsg+0x59/0x62
Dec  4 11:57:44 iridium kernel: [<ffffffff812998ce>] ? sock_sendmsg+0xc7/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff810b9c04>] ? __slab_free+0x83/0x28e
Dec  4 11:57:44 iridium kernel: [<ffffffff81142f68>] ? selinux_inode_free_security+0x73/0x7b
Dec  4 11:57:44 iridium kernel: [<ffffffff810b9c04>] ? __slab_free+0x83/0x28e
Dec  4 11:57:44 iridium kernel: [<ffffffff81142f68>] ? selinux_inode_free_security+0x73/0x7b
Dec  4 11:57:44 iridium kernel: [<ffffffff81298886>] ? sock_destroy_inode+0x14/0x16
Dec  4 11:57:44 iridium kernel: [<ffffffff81298886>] ? sock_destroy_inode+0x14/0x16
Dec  4 11:57:44 iridium kernel: [<ffffffff810b7aaf>] ? add_partial+0x48/0x52
Dec  4 11:57:44 iridium kernel: [<ffffffff810b9c30>] ? __slab_free+0xaf/0x28e
Dec  4 11:57:44 iridium kernel: [<ffffffff810cfd70>] ? d_free+0x4e/0x65
Dec  4 11:57:44 iridium kernel: [<ffffffff8113f44f>] ? selinux_file_free_security+0x1e/0x20
Dec  4 11:57:44 iridium kernel: [<ffffffff810cfd70>] ? d_free+0x4e/0x65
Dec  4 11:57:44 iridium kernel: [<ffffffff810d616d>] ? mntput_no_expire+0x31/0x144
Dec  4 11:57:44 iridium kernel: [<ffffffff810c0e16>] ? __fput+0x161/0x16d
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: bluetooth-app S ffff880116de5d40     0  3535   3349
Dec  4 11:57:44 iridium kernel: ffff88010c8f9b18 0000000000000082 ffff88010c8f9ae0 ffff88010c8f9adc
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8801131a4530 ffff880113a52e20
Dec  4 11:57:44 iridium kernel: ffff8801131a48a8 0000000200000000 ffff88010c8f9aa8 ffff8801131a48a8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff813308b0>] schedule_timeout+0x22/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd296>] ? __pollwait+0xd6/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff81312f85>] ? unix_poll+0x20/0xa1
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810bfdcb>] ? do_sync_read+0xe7/0x12d
Dec  4 11:57:44 iridium kernel: [<ffffffff8103e2ad>] ? finish_task_switch+0x31/0xc9
Dec  4 11:57:44 iridium kernel: [<ffffffff81142a3b>] ? selinux_file_permission+0xaf/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff8113b85c>] ? security_file_permission+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: gpk-update-ic S ffff880118fd4000     0  3539   3349
Dec  4 11:57:44 iridium kernel: ffff88010ca83b18 0000000000000086 0000000000000001 ffff88010ca82000
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88011793ae20 ffff880116fe8000
Dec  4 11:57:44 iridium kernel: ffff88011793b198 000000032fb10000 ffff88010ca83ac8 ffff88011793b198
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103e2ad>] ? finish_task_switch+0x31/0xc9
Dec  4 11:57:44 iridium kernel: [<ffffffff81142a3b>] ? selinux_file_permission+0xaf/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff8113b85c>] ? security_file_permission+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: vino-server   S ffff880028028b10     0  3541   3349
Dec  4 11:57:44 iridium kernel: ffff88010a06bb18 0000000000000086 ffff88010a06bae0 ffff88010a06badc
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff880113a6c530 ffff8800c7cc0000
Dec  4 11:57:44 iridium kernel: ffff880113a6c8a8 0000000081765900 ffff88010a06bac8 ffff880113a6c8a8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff813308b0>] schedule_timeout+0x22/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd296>] ? __pollwait+0xd6/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff81312f85>] ? unix_poll+0x20/0xa1
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103e2ad>] ? finish_task_switch+0x31/0xc9
Dec  4 11:57:44 iridium kernel: [<ffffffff81142a3b>] ? selinux_file_permission+0xaf/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff8113b85c>] ? security_file_permission+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: python        S 0000000000000000     0  3542   3349
Dec  4 11:57:44 iridium kernel: ffff88010a01fb18 0000000000000082 0000000000000000 ffff88010a01fadc
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff880113328000 ffffffff814ab340
Dec  4 11:57:44 iridium kernel: ffff880113328378 0000000000000000 ffff88010a01faa8 ffff880113328378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff810b9c04>] ? __slab_free+0x83/0x28e
Dec  4 11:57:44 iridium kernel: [<ffffffff813308b0>] schedule_timeout+0x22/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd296>] ? __pollwait+0xd6/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff81312f85>] ? unix_poll+0x20/0xa1
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff812990fc>] ? __sock_recvmsg+0x6d/0x7a
Dec  4 11:57:44 iridium kernel: [<ffffffff812991f9>] ? sock_aio_read+0xf0/0x100
Dec  4 11:57:44 iridium kernel: [<ffffffff810bfdb6>] ? do_sync_read+0xd2/0x12d
Dec  4 11:57:44 iridium kernel: [<ffffffff810bfdcb>] ? do_sync_read+0xe7/0x12d
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff8103e2ad>] ? finish_task_switch+0x31/0xc9
Dec  4 11:57:44 iridium kernel: [<ffffffff81142a3b>] ? selinux_file_permission+0xaf/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff8113b85c>] ? security_file_permission+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: nm-applet     S ffff88012ac31040     0  3552   3349
Dec  4 11:57:44 iridium kernel: ffff88010c939b18 0000000000000082 0000000000000001 0000000000000001
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88011332ae20 ffff88011329dc40
Dec  4 11:57:44 iridium kernel: ffff88011332b198 000000022fad8000 ffff88010c939ac8 ffff88011332b198
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810bfdcb>] ? do_sync_read+0xe7/0x12d
Dec  4 11:57:44 iridium kernel: [<ffffffff8103e2ad>] ? finish_task_switch+0x31/0xc9
Dec  4 11:57:44 iridium kernel: [<ffffffff81142a3b>] ? selinux_file_permission+0xaf/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff8113b85c>] ? security_file_permission+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: gnome-power-m S ffff880117acad80     0  3556      1
Dec  4 11:57:44 iridium kernel: ffff8801090d1b18 0000000000000082 ffff8801090d1f40 ffff8801090d1e98
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff880113a52e20 ffff880116caae20
Dec  4 11:57:44 iridium kernel: ffff880113a53198 000000012fa9c000 ffff8801090d1ac8 ffff880113a53198
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff81142a3b>] ? selinux_file_permission+0xaf/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff8113b85c>] ? security_file_permission+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: /usr/bin/seal S 0000000000000000     0  3561      1
Dec  4 11:57:44 iridium kernel: ffff880109007b18 0000000000000086 ffff880109007ae0 ffff880109007adc
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88011329dc40 ffff88012fae2e20
Dec  4 11:57:44 iridium kernel: ffff88011329dfb8 0000000200000000 ffff88000000f008 ffff88011329dfb8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff813308b0>] schedule_timeout+0x22/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd296>] ? __pollwait+0xd6/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff81312f85>] ? unix_poll+0x20/0xa1
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103e2ad>] ? finish_task_switch+0x31/0xc9
Dec  4 11:57:44 iridium kernel: [<ffffffff81142a3b>] ? selinux_file_permission+0xaf/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff8113b85c>] ? security_file_permission+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: rhythmbox     S 0000000000000000     0  3581      1
Dec  4 11:57:44 iridium kernel: ffff880107d83b18 0000000000000086 0000000000000000 0000008000000000
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8801131a0000 ffff88012fb19710
Dec  4 11:57:44 iridium kernel: ffff8801131a0378 000000032fb10000 ffff880107d83ac8 ffff8801131a0378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff81142a3b>] ? selinux_file_permission+0xaf/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff8113b85c>] ? security_file_permission+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: rhythmbox     S ffff88012ac50d00     0  3589      1
Dec  4 11:57:44 iridium kernel: ffff880105831c38 0000000000000086 0000000000000000 ffff88012ac50d68
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff880109022e20 ffff8801131a0000
Dec  4 11:57:44 iridium kernel: ffff880109023198 0000000000000006 ffff880105831bc8 ffff880109023198
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff81334a51>] ? do_page_fault+0x6d0/0xad2
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f391>] futex_wait+0x1b9/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104bdbd>] ? __sigqueue_free+0x38/0x3c
Dec  4 11:57:44 iridium kernel: [<ffffffff8104cab5>] ? __dequeue_signal+0x103/0x12f
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f6d9>] ? futex_wake+0xdc/0xed
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff813320ea>] ? _spin_lock_irq+0x21/0x26
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff81140c88>] ? selinux_capable+0x1a/0x8a
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: rhythmbox     S 0000000000000000     0  4182      1
Dec  4 11:57:44 iridium kernel: ffff8800ab951c38 0000000000000086 0000000000000000 0000000000000000
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8801228fae20 ffff88012faa4530
Dec  4 11:57:44 iridium kernel: ffff8801228fb198 000000010a9e4afe 00000000001201d2 ffff8801228fb198
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f391>] futex_wait+0x1b9/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff81331dea>] ? _spin_lock+0x9/0xc
Dec  4 11:57:44 iridium kernel: [<ffffffff810d721a>] ? mnt_drop_write+0x82/0x143
Dec  4 11:57:44 iridium kernel: [<ffffffff810d5545>] ? mnt_want_write+0x77/0x8d
Dec  4 11:57:44 iridium kernel: [<ffffffff810d25a7>] ? touch_atime+0xda/0xfc
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff810bfdcb>] ? do_sync_read+0xe7/0x12d
Dec  4 11:57:44 iridium kernel: [<ffffffff81031023>] ? need_resched+0x1e/0x28
Dec  4 11:57:44 iridium kernel: [<ffffffff81330632>] ? _cond_resched+0x9/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff81330bbe>] ? mutex_lock+0x22/0x33
Dec  4 11:57:44 iridium kernel: [<ffffffff810ea681>] ? inotify_inode_queue_event+0xca/0xd9
Dec  4 11:57:44 iridium kernel: [<ffffffff810d18bb>] ? dput+0x3d/0x13e
Dec  4 11:57:44 iridium kernel: [<ffffffff810eab9b>] ? inotify_dentry_parent_queue_event+0x79/0x92
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: rhythmbox     S ffff88012ac50d00     0  4218      1
Dec  4 11:57:44 iridium kernel: ffff8800a91b3c38 0000000000000086 ffff8800a91b3ba8 ffff8800a91b3c68
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800bc52dc40 ffff880109024530
Dec  4 11:57:44 iridium kernel: ffff8800bc52dfb8 00000000810575b2 ffff8800a91b3bd8 ffff8800bc52dfb8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff81057fd1>] ? hrtimer_start+0x12e/0x150
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f3ff>] futex_wait+0x227/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff81057855>] ? hrtimer_wakeup+0x0/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f3db>] ? futex_wait+0x203/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffffa016e882>] ? snd_pcm_playback_ioctl1+0x258/0x275 [snd_pcm]
Dec  4 11:57:44 iridium kernel: [<ffffffff81016837>] ? read_tsc+0xe/0x24
Dec  4 11:57:44 iridium kernel: [<ffffffff8105a18b>] ? getnstimeofday+0x3a/0x96
Dec  4 11:57:44 iridium kernel: [<ffffffff8105819e>] ? ktime_get_ts+0x49/0x4e
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: rhythmbox     S 0000000000000000     0  4219      1
Dec  4 11:57:44 iridium kernel: ffff8800a90e7c38 0000000000000086 0000000000000000 0000000000000001
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800bc52ae20 ffff88012fae2e20
Dec  4 11:57:44 iridium kernel: ffff8800bc52b198 0000000281033e10 ffff8800a90e7be8 ffff8800bc52b198
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f391>] futex_wait+0x1b9/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5c5>] ? default_wake_function+0xd/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff81031eab>] ? __wake_up_common+0x46/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f6d9>] ? futex_wake+0xdc/0xed
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff8103408c>] ? pick_next_task_fair+0x9d/0xac
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: rhythmbox     S ffff88012ac50d00     0  4220      1
Dec  4 11:57:44 iridium kernel: ffff8800a89efc38 0000000000000086 0000000000000000 ffff88002802fe80
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff880109024530 ffff880116caae20
Dec  4 11:57:44 iridium kernel: ffff8801090248a8 00000000bc52ae58 ffff8800a89efbe8 ffff8801090248a8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff81331fe4>] ? _spin_unlock_irqrestore+0x27/0x3e
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f391>] futex_wait+0x1b9/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff8101f864>] ? native_smp_send_reschedule+0x4d/0x4f
Dec  4 11:57:44 iridium kernel: [<ffffffff810310f4>] ? resched_task+0x84/0x8c
Dec  4 11:57:44 iridium kernel: [<ffffffff81331fe4>] ? _spin_unlock_irqrestore+0x27/0x3e
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5a6>] ? try_to_wake_up+0x26f/0x281
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f6d9>] ? futex_wake+0xdc/0xed
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff8103408c>] ? pick_next_task_fair+0x9d/0xac
Dec  4 11:57:44 iridium kernel: [<ffffffff81331c7e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: rhythmbox     S 0000000000000000     0 17616      1
Dec  4 11:57:44 iridium kernel: ffff880075bb5c38 0000000000000086 0000000000000000 ffff880075bb5bfc
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800c7cc5c40 ffff88012faa4530
Dec  4 11:57:44 iridium kernel: ffff8800c7cc5fb8 0000000181033e10 ffff880075bb5bd8 ffff8800c7cc5fb8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff81331fe4>] ? _spin_unlock_irqrestore+0x27/0x3e
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f391>] futex_wait+0x1b9/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff8101f864>] ? native_smp_send_reschedule+0x4d/0x4f
Dec  4 11:57:44 iridium kernel: [<ffffffff810310f4>] ? resched_task+0x84/0x8c
Dec  4 11:57:44 iridium kernel: [<ffffffff81331fe4>] ? _spin_unlock_irqrestore+0x27/0x3e
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5a6>] ? try_to_wake_up+0x26f/0x281
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff8103408c>] ? pick_next_task_fair+0x9d/0xac
Dec  4 11:57:44 iridium kernel: [<ffffffff81331c7e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: rhythmbox     S 0000000000000000     0 19154      1
Dec  4 11:57:44 iridium kernel: ffff880128ddfe78 0000000000000086 0000000000000000 ffff880128ddfea8
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800c7de0000 ffff88012fb19710
Dec  4 11:57:44 iridium kernel: ffff8800c7de0378 00000003810575b2 ffff880128ddfe18 ffff8800c7de0378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff81330e3c>] do_nanosleep+0x66/0xa9
Dec  4 11:57:44 iridium kernel: [<ffffffff8105805e>] hrtimer_nanosleep+0x6b/0xdd
Dec  4 11:57:44 iridium kernel: [<ffffffff81057855>] ? hrtimer_wakeup+0x0/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff81330e21>] ? do_nanosleep+0x4b/0xa9
Dec  4 11:57:44 iridium kernel: [<ffffffff81058124>] sys_nanosleep+0x54/0x6c
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: rhythmbox     R  running task        0 19155      1
Dec  4 11:57:44 iridium kernel: ffff880129379b18 ffffffff8133050e 0000000000000000 ffff880129379adc
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800b1780000 ffffffff814ab340
Dec  4 11:57:44 iridium kernel: ffff8800b1780378 000000030214f3e8 00000000816dee80 ffff8800b1780378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8133050e>] ? thread_return+0xab/0xd9
Dec  4 11:57:44 iridium kernel: [<ffffffff810553e2>] ? remove_wait_queue+0x2f/0x39
Dec  4 11:57:44 iridium kernel: [<ffffffff8113e77f>] ? avc_has_perm+0x4e/0x60
Dec  4 11:57:44 iridium kernel: [<ffffffff8113fcc8>] ? ipc_has_perm+0x55/0x57
Dec  4 11:57:44 iridium kernel: [<ffffffff81131a16>] ? sys_semtimedop+0x5d1/0x631
Dec  4 11:57:44 iridium kernel: [<ffffffff8113e77f>] ? avc_has_perm+0x4e/0x60
Dec  4 11:57:44 iridium kernel: [<ffffffff810610e0>] ? do_futex+0x896/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffffa016e882>] ? snd_pcm_playback_ioctl1+0x258/0x275 [snd_pcm]
Dec  4 11:57:44 iridium kernel: [<ffffffffa016f13c>] ? snd_pcm_playback_ioctl+0x2e/0x36 [snd_pcm]
Dec  4 11:57:44 iridium kernel: [<ffffffff810cb766>] ? vfs_ioctl+0x2a/0x78
Dec  4 11:57:44 iridium kernel: [<ffffffff810cba01>] ? do_vfs_ioctl+0x24d/0x26a
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff81331c7e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
Dec  4 11:57:44 iridium kernel: [<ffffffff81010295>] ? sysret_check+0x41/0x7c
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: notification- S ffff88012acb4340     0  3595      1
Dec  4 11:57:44 iridium kernel: ffff880105879b18 0000000000000082 ffff880105879f40 0000000000000001
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff880113a69710 ffff880116caae20
Dec  4 11:57:44 iridium kernel: ffff880113a69a88 0000000000000000 ffffe20001a37fd0 ffff880113a69a88
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff810b9c30>] ? __slab_free+0xaf/0x28e
Dec  4 11:57:44 iridium kernel: [<ffffffff8129f958>] ? skb_release_data+0xc6/0xcb
Dec  4 11:57:44 iridium kernel: [<ffffffff813308b0>] schedule_timeout+0x22/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd296>] ? __pollwait+0xd6/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff81312f85>] ? unix_poll+0x20/0xa1
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810bfdcb>] ? do_sync_read+0xe7/0x12d
Dec  4 11:57:44 iridium kernel: [<ffffffff8103e2ad>] ? finish_task_switch+0x31/0xc9
Dec  4 11:57:44 iridium kernel: [<ffffffff81142a3b>] ? selinux_file_permission+0xaf/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff8113b85c>] ? security_file_permission+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: evolution-dat S ffff880118fd63c0     0  3696      1
Dec  4 11:57:44 iridium kernel: ffff8800c7413b18 0000000000000086 0000000000000000 0000000000236c00
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff880109020000 ffff8800ca454530
Dec  4 11:57:44 iridium kernel: ffff880109020378 0000000100000000 ffff8800c7413ac8 ffff880109020378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff81033b5f>] ? __dequeue_entity+0x61/0x6a
Dec  4 11:57:44 iridium kernel: [<ffffffff813308b0>] schedule_timeout+0x22/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd296>] ? __pollwait+0xd6/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff81312f85>] ? unix_poll+0x20/0xa1
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff81331dea>] ? _spin_lock+0x9/0xc
Dec  4 11:57:44 iridium kernel: [<ffffffff810d721a>] ? mnt_drop_write+0x82/0x143
Dec  4 11:57:44 iridium kernel: [<ffffffff81331dea>] ? _spin_lock+0x9/0xc
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f6d9>] ? futex_wake+0xdc/0xed
Dec  4 11:57:44 iridium kernel: [<ffffffff810608ff>] ? do_futex+0xb5/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff810bfdcb>] ? do_sync_read+0xe7/0x12d
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff81331dea>] ? _spin_lock+0x9/0xc
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: evolution-dat S ffff880118fd63c0     0  3697      1
Dec  4 11:57:44 iridium kernel: ffff8800c7451b18 0000000000000086 ffff8800c7451af8 ffffffff8109de5d
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800ca454530 ffff880113a6ae20
Dec  4 11:57:44 iridium kernel: ffff8800ca4548a8 0000000102c42b78 00000200c7451aa8 ffff8800ca4548a8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8109de5d>] ? __do_fault+0x2d6/0x31c
Dec  4 11:57:44 iridium kernel: [<ffffffff810b9c04>] ? __slab_free+0x83/0x28e
Dec  4 11:57:44 iridium kernel: [<ffffffff8129f958>] ? skb_release_data+0xc6/0xcb
Dec  4 11:57:44 iridium kernel: [<ffffffff813308b0>] schedule_timeout+0x22/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd296>] ? __pollwait+0xd6/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff81312f85>] ? unix_poll+0x20/0xa1
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608ff>] ? do_futex+0xb5/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff81033b5f>] ? __dequeue_entity+0x61/0x6a
Dec  4 11:57:44 iridium kernel: [<ffffffff8103e2ad>] ? finish_task_switch+0x31/0xc9
Dec  4 11:57:44 iridium kernel: [<ffffffff8133050e>] ? thread_return+0xab/0xd9
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: gvfsd-http    S 0000000000000000     0  3803      1
Dec  4 11:57:44 iridium kernel: ffff88010031db18 0000000000000082 0000000000000000 ffffffff81331fe4
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800ca450000 ffffffff814ab340
Dec  4 11:57:44 iridium kernel: ffff8800ca450378 0000000000000801 ffffffff816de500 ffff8800ca450378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff81331fe4>] ? _spin_unlock_irqrestore+0x27/0x3e
Dec  4 11:57:44 iridium kernel: [<ffffffff813308b0>] schedule_timeout+0x22/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd296>] ? __pollwait+0xd6/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff81312f85>] ? unix_poll+0x20/0xa1
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff812990fc>] ? __sock_recvmsg+0x6d/0x7a
Dec  4 11:57:44 iridium kernel: [<ffffffff810b9c04>] ? __slab_free+0x83/0x28e
Dec  4 11:57:44 iridium kernel: [<ffffffff81142f68>] ? selinux_inode_free_security+0x73/0x7b
Dec  4 11:57:44 iridium kernel: [<ffffffff810b9c04>] ? __slab_free+0x83/0x28e
Dec  4 11:57:44 iridium kernel: [<ffffffff81142f68>] ? selinux_inode_free_security+0x73/0x7b
Dec  4 11:57:44 iridium kernel: [<ffffffff81298886>] ? sock_destroy_inode+0x14/0x16
Dec  4 11:57:44 iridium kernel: [<ffffffff81298886>] ? sock_destroy_inode+0x14/0x16
Dec  4 11:57:44 iridium kernel: [<ffffffff810b9c04>] ? __slab_free+0x83/0x28e
Dec  4 11:57:44 iridium kernel: [<ffffffff810cfd70>] ? d_free+0x4e/0x65
Dec  4 11:57:44 iridium kernel: [<ffffffff8113f44f>] ? selinux_file_free_security+0x1e/0x20
Dec  4 11:57:44 iridium kernel: [<ffffffff810cfd70>] ? d_free+0x4e/0x65
Dec  4 11:57:44 iridium kernel: [<ffffffff810d616d>] ? mntput_no_expire+0x31/0x144
Dec  4 11:57:44 iridium kernel: [<ffffffff810c0e16>] ? __fput+0x161/0x16d
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: dhclient      S 0000000000000000     0  3828   2469
Dec  4 11:57:44 iridium kernel: ffff880100e9b9c8 0000000000000086 0000000000000000 ffff88012ac50d00
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8801058a2e20 ffff88012fae2e20
Dec  4 11:57:44 iridium kernel: ffff8801058a3198 000000022fad8000 ffff880100e9b978 ffff8801058a3198
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff810ccb72>] do_select+0x499/0x505
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810469d2>] ? _local_bh_enable_ip+0xd5/0xe2
Dec  4 11:57:44 iridium kernel: [<ffffffff810469e8>] ? local_bh_enable_ip+0x9/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff81331ef9>] ? _spin_unlock_bh+0x13/0x15
Dec  4 11:57:44 iridium kernel: [<ffffffff8129bbeb>] ? release_sock+0xb0/0xbc
Dec  4 11:57:44 iridium kernel: [<ffffffff8129f6ee>] ? kfree_skb+0x27/0x29
Dec  4 11:57:44 iridium kernel: [<ffffffff812ed555>] ? udp_recvmsg+0x1fb/0x277
Dec  4 11:57:44 iridium kernel: [<ffffffff8129b07b>] ? sock_common_recvmsg+0x32/0x47
Dec  4 11:57:44 iridium kernel: [<ffffffff8113faa1>] ? selinux_socket_recvmsg+0x1d/0x1f
Dec  4 11:57:44 iridium kernel: [<ffffffff812990fc>] ? __sock_recvmsg+0x6d/0x7a
Dec  4 11:57:44 iridium kernel: [<ffffffff8129979a>] ? sock_recvmsg+0xca/0xe3
Dec  4 11:57:44 iridium kernel: [<ffffffff810ccd55>] core_sys_select+0x177/0x213
Dec  4 11:57:44 iridium kernel: [<ffffffff8129a59d>] ? move_addr_to_user+0x67/0x86
Dec  4 11:57:44 iridium kernel: [<ffffffff8129a8a6>] ? sys_recvfrom+0xcb/0xf8
Dec  4 11:57:44 iridium kernel: [<ffffffff810b8bc1>] ? virt_to_head_page+0x31/0x41
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd11e>] sys_select+0xb8/0x15a
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: ntpd          S 0000000000000000     0  3934      1
Dec  4 11:57:44 iridium kernel: ffff8800bc47f9c8 0000000000000082 0000000000000000 ffffffff812a5b7b
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8801058a4530 ffff88012fae2e20
Dec  4 11:57:44 iridium kernel: ffff8801058a48a8 000000022fad8000 ffff8800bc47f978 ffff8801058a48a8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff812a5b7b>] ? dev_hard_start_xmit+0x1d6/0x258
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff810ccb72>] do_select+0x499/0x505
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff810ccd55>] core_sys_select+0x177/0x213
Dec  4 11:57:44 iridium kernel: [<ffffffff8129a6fe>] ? sys_recvmsg+0x142/0x21f
Dec  4 11:57:44 iridium kernel: [<ffffffff8129a2e5>] ? move_addr_to_kernel+0x40/0x49
Dec  4 11:57:44 iridium kernel: [<ffffffff8129a3cd>] ? sys_sendto+0xdf/0x107
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd11e>] sys_select+0xb8/0x15a
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: deluge        S ffff880116de5a00     0  3971      1
Dec  4 11:57:44 iridium kernel: ffff8800ba61db18 0000000000000086 0000000000000000 ffffffff812c292f
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800bc5f0000 ffff8801058a0000
Dec  4 11:57:44 iridium kernel: ffff8800bc5f0378 000000032fb10000 ffff8800ba61dac8 ffff8800bc5f0378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff812c292f>] ? __nf_conntrack_find+0x51/0x9e
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810bfdcb>] ? do_sync_read+0xe7/0x12d
Dec  4 11:57:44 iridium kernel: [<ffffffff810d2ef3>] ? destroy_inode+0x3a/0x4f
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff81142a3b>] ? selinux_file_permission+0xaf/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff8113b85c>] ? security_file_permission+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: deluge        S 0000000000000000     0  3995      1
Dec  4 11:57:44 iridium kernel: ffff8800b052bd48 0000000000000086 0000000000000000 0000000000000000
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800bc5f2e20 ffffffff814ab340
Dec  4 11:57:44 iridium kernel: ffff8800bc5f3198 00000000b052bd88 0000000028028c30 ffff8800bc5f3198
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff813308b0>] schedule_timeout+0x22/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff810469e8>] ? local_bh_enable_ip+0x9/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff81331ef9>] ? _spin_unlock_bh+0x13/0x15
Dec  4 11:57:44 iridium kernel: [<ffffffff8129bbeb>] ? release_sock+0xb0/0xbc
Dec  4 11:57:44 iridium kernel: [<ffffffff810552bc>] ? prepare_to_wait_exclusive+0x5c/0x65
Dec  4 11:57:44 iridium kernel: [<ffffffff812d5f58>] inet_csk_accept+0xc8/0x1f6
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff812f350b>] inet_accept+0x28/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff8113fac6>] ? selinux_socket_accept+0x23/0x50
Dec  4 11:57:44 iridium kernel: [<ffffffff8129ab29>] do_accept+0x11a/0x1d6
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8129ad83>] sys_accept+0xb/0x10
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: deluged       S 0000000000000000     0  3986      1
Dec  4 11:57:44 iridium kernel: ffff8800b047db18 0000000000000086 0000000000000000 ffff8800b047dadc
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800b0508000 ffff88012fae2e20
Dec  4 11:57:44 iridium kernel: ffff8800b0508378 000000022fad8000 ffff8800b047dac8 ffff8800b0508378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f4ab>] ? futex_wait+0x2d3/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5c5>] ? default_wake_function+0xd/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff81031eab>] ? __wake_up_common+0x46/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff81331dea>] ? _spin_lock+0x9/0xc
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f6d9>] ? futex_wake+0xdc/0xed
Dec  4 11:57:44 iridium kernel: [<ffffffff810608ff>] ? do_futex+0xb5/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff8103408c>] ? pick_next_task_fair+0x9d/0xac
Dec  4 11:57:44 iridium kernel: [<ffffffff8103e2ad>] ? finish_task_switch+0x31/0xc9
Dec  4 11:57:44 iridium kernel: [<ffffffff8133050e>] ? thread_return+0xab/0xd9
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: deluged       S ffff880118fd56c0     0  3987      1
Dec  4 11:57:44 iridium kernel: ffff8800b044dc38 0000000000000086 ffff8800b044db98 ffffffff81035abd
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800ba56ae20 ffff8800b0509710
Dec  4 11:57:44 iridium kernel: ffff8800ba56b198 000000022804f500 ffff8800b044dbd8 ffff8800ba56b198
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff81035abd>] ? enqueue_task_fair+0x46/0x4b
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5a6>] ? try_to_wake_up+0x26f/0x281
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f391>] futex_wait+0x1b9/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff81331fe4>] ? _spin_unlock_irqrestore+0x27/0x3e
Dec  4 11:57:44 iridium kernel: [<ffffffff81331dea>] ? _spin_lock+0x9/0xc
Dec  4 11:57:44 iridium kernel: [<ffffffff810d721a>] ? mnt_drop_write+0x82/0x143
Dec  4 11:57:44 iridium kernel: [<ffffffff810d5545>] ? mnt_want_write+0x77/0x8d
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff810bfc9e>] ? do_sync_write+0xe7/0x12d
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff81331dea>] ? _spin_lock+0x9/0xc
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: deluged       S 0000000000000000     0  3988      1
Dec  4 11:57:44 iridium kernel: ffff8800b043fe18 0000000000000086 0000000000000000 ffff8800b0407300
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800b0509710 ffff88012fae2e20
Dec  4 11:57:44 iridium kernel: ffff8800b0509a88 000000022fad8000 ffff8800b043fdc8 ffff8800b0509a88
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff810ebab5>] sys_epoll_wait+0x1da/0x45f
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: deluged       S 0000000000000000     0  3989      1
Dec  4 11:57:44 iridium kernel: ffff8800b0449e18 0000000000000086 0000000000000000 ffffffff8105f6d9
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800b050ae20 ffff88012fae2e20
Dec  4 11:57:44 iridium kernel: ffff8800b050b198 000000023f4e7cf0 0000000400000000 ffff8800b050b198
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f6d9>] ? futex_wake+0xdc/0xed
Dec  4 11:57:44 iridium kernel: [<ffffffff810608ff>] ? do_futex+0xb5/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff813308b0>] schedule_timeout+0x22/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8103408c>] ? pick_next_task_fair+0x9d/0xac
Dec  4 11:57:44 iridium kernel: [<ffffffff810ebab5>] sys_epoll_wait+0x1da/0x45f
Dec  4 11:57:44 iridium kernel: [<ffffffff8133050e>] ? thread_return+0xab/0xd9
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: deluged       S ffff880118fd56c0     0  3992      1
Dec  4 11:57:44 iridium kernel: ffff8800bc507e18 0000000000000086 ffff8800bc507ed8 ffff8800c685a670
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800b050c530 ffff8800b0509710
Dec  4 11:57:44 iridium kernel: ffff8800b050c8a8 000000023d8cccb0 0000000d00000000 ffff8800b050c8a8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff810bfc9e>] ? do_sync_write+0xe7/0x12d
Dec  4 11:57:44 iridium kernel: [<ffffffff813308b0>] schedule_timeout+0x22/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff81031023>] ? need_resched+0x1e/0x28
Dec  4 11:57:44 iridium kernel: [<ffffffff81330632>] ? _cond_resched+0x9/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff810ebab5>] sys_epoll_wait+0x1da/0x45f
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: deluged       S 0000000000000000     0  3993      1
Dec  4 11:57:44 iridium kernel: ffff8800b0447d48 0000000000000086 0000000000000000 0000000000000000
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800ba569710 ffffffff814ab340
Dec  4 11:57:44 iridium kernel: ffff8800ba569a88 00000000b0447d88 0000000000000000 ffff8800ba569a88
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff813308b0>] schedule_timeout+0x22/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff810469e8>] ? local_bh_enable_ip+0x9/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff81331ef9>] ? _spin_unlock_bh+0x13/0x15
Dec  4 11:57:44 iridium kernel: [<ffffffff8129bbeb>] ? release_sock+0xb0/0xbc
Dec  4 11:57:44 iridium kernel: [<ffffffff810552bc>] ? prepare_to_wait_exclusive+0x5c/0x65
Dec  4 11:57:44 iridium kernel: [<ffffffff812d5f58>] inet_csk_accept+0xc8/0x1f6
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff812f350b>] inet_accept+0x28/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff8113fac6>] ? selinux_socket_accept+0x23/0x50
Dec  4 11:57:44 iridium kernel: [<ffffffff8129ab29>] do_accept+0x11a/0x1d6
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8129ad83>] sys_accept+0xb/0x10
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: pidgin        S 0000000000000000     0  4126      1
Dec  4 11:57:44 iridium kernel: ffff8800ac945b18 0000000000000082 0000000000000000 ffffffff811141d5
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800ba580000 ffff88012fae2e20
Dec  4 11:57:44 iridium kernel: ffff8800ba580378 000000022fad8000 ffff8800ac945ac8 ffff8800ba580378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff811141d5>] ? ext3_get_blocks_handle+0x9d/0x86e
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff81142a3b>] ? selinux_file_permission+0xaf/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff8113b85c>] ? security_file_permission+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: rpc.rquotad   S 0000000000000000     0 12698      1
Dec  4 11:57:44 iridium kernel: ffff880010df9b18 0000000000000082 0000000000000000 ffffffff8109de5d
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012291ae20 ffff88012fb19710
Dec  4 11:57:44 iridium kernel: ffff88012291b198 0000000302589eb8 ffff880010df9ab8 ffff88012291b198
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8109de5d>] ? __do_fault+0x2d6/0x31c
Dec  4 11:57:44 iridium kernel: [<ffffffff813308b0>] schedule_timeout+0x22/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd296>] ? __pollwait+0xd6/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff812d64cb>] ? tcp_poll+0x1f/0x152
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8113e77f>] ? avc_has_perm+0x4e/0x60
Dec  4 11:57:44 iridium kernel: [<ffffffff8114028d>] ? inode_has_perm+0x5b/0x61
Dec  4 11:57:44 iridium kernel: [<ffffffff813321dc>] ? unlock_kernel+0x2f/0x32
Dec  4 11:57:44 iridium kernel: [<ffffffff8114028d>] ? inode_has_perm+0x5b/0x61
Dec  4 11:57:44 iridium kernel: [<ffffffff810c26ab>] ? chrdev_open+0x0/0x169
Dec  4 11:57:44 iridium kernel: [<ffffffff810be64e>] ? __dentry_open+0x162/0x249
Dec  4 11:57:44 iridium kernel: [<ffffffff81140786>] ? dentry_has_perm+0x44/0x4b
Dec  4 11:57:44 iridium kernel: [<ffffffff810be7eb>] ? nameidata_to_filp+0x2e/0x40
Dec  4 11:57:44 iridium kernel: [<ffffffff810c3064>] ? cp_new_stat+0xe2/0xef
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: lockd         S 0000000000000000     0 12701      2
Dec  4 11:57:44 iridium kernel: ffff8800134d1d90 0000000000000046 0000000000000000 ffff8800134d1cf8
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8801058a1710 ffff88012fb19710
Dec  4 11:57:44 iridium kernel: ffff8801058a1a88 0000000300001031 0000000000000633 ffff8801058a1a88
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff813308b0>] schedule_timeout+0x22/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff810469d2>] ? _local_bh_enable_ip+0xd5/0xe2
Dec  4 11:57:44 iridium kernel: [<ffffffff810469e8>] ? local_bh_enable_ip+0x9/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffffa02daa11>] svc_recv+0x330/0x795 [sunrpc]
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff813320ea>] ? _spin_lock_irq+0x21/0x26
Dec  4 11:57:44 iridium kernel: [<ffffffffa04c17b3>] lockd+0x126/0x1db [lockd]
Dec  4 11:57:44 iridium kernel: [<ffffffff81031eab>] ? __wake_up_common+0x46/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffffa04c168d>] ? lockd+0x0/0x1db [lockd]
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: nfsd4         S 0000000000000000     0 12702      2
Dec  4 11:57:44 iridium kernel: ffff8800264ddec0 0000000000000046 0000000000000000 000000000000005a
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800ba56dc40 ffffffff814ab340
Dec  4 11:57:44 iridium kernel: ffff8800ba56dfb8 00000000a04e94b2 ffff8800264dde40 ffff8800ba56dfb8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff81051a31>] worker_thread+0xb5/0x109
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff8105197c>] ? worker_thread+0x0/0x109
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: nfsd          S 0000000000000000     0 12703      2
Dec  4 11:57:44 iridium kernel: ffff880012d5dde0 0000000000000046 0000000000000000 0000000181140786
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800ba568000 ffff88012fae2e20
Dec  4 11:57:44 iridium kernel: ffff8800ba568378 000000022fad8000 ffff880012d5dd90 ffff8800ba568378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffffa02daa11>] svc_recv+0x330/0x795 [sunrpc]
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffffa04d2810>] nfsd+0xeb/0x1a5 [nfsd]
Dec  4 11:57:44 iridium kernel: [<ffffffffa04d2725>] ? nfsd+0x0/0x1a5 [nfsd]
Dec  4 11:57:44 iridium kernel: [<ffffffffa04d2725>] ? nfsd+0x0/0x1a5 [nfsd]
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: nfsd          S 0000000000000000     0 12704      2
Dec  4 11:57:44 iridium kernel: ffff880013561de0 0000000000000046 0000000000000000 0000000181140786
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800ba56c530 ffff88012fae2e20
Dec  4 11:57:44 iridium kernel: ffff8800ba56c8a8 000000022fad8000 ffff880013561d90 ffff8800ba56c8a8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffffa02daa11>] svc_recv+0x330/0x795 [sunrpc]
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffffa04d2810>] nfsd+0xeb/0x1a5 [nfsd]
Dec  4 11:57:44 iridium kernel: [<ffffffffa04d2725>] ? nfsd+0x0/0x1a5 [nfsd]
Dec  4 11:57:44 iridium kernel: [<ffffffffa04d2725>] ? nfsd+0x0/0x1a5 [nfsd]
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: nfsd          S 0000000000000001     0 12705      2
Dec  4 11:57:44 iridium kernel: ffff88000e4c5de0 0000000000000046 0000000000000000 00000001810c31e1
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8801059b0000 ffff8800ba568000
Dec  4 11:57:44 iridium kernel: ffff8801059b0378 000000022fad8000 ffff88000e4c5d90 ffff8801059b0378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffffa02daa11>] svc_recv+0x330/0x795 [sunrpc]
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffffa04d2810>] nfsd+0xeb/0x1a5 [nfsd]
Dec  4 11:57:44 iridium kernel: [<ffffffffa04d2725>] ? nfsd+0x0/0x1a5 [nfsd]
Dec  4 11:57:44 iridium kernel: [<ffffffffa04d2725>] ? nfsd+0x0/0x1a5 [nfsd]
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: nfsd          S 0000000000000000     0 12706      2
Dec  4 11:57:44 iridium kernel: ffff88000e565de0 0000000000000046 0000000000000000 ffffffff810469e8
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8801059b1710 ffff88012faa4530
Dec  4 11:57:44 iridium kernel: ffff8801059b1a88 000000012fa9c000 ffff88000e565d90 ffff8801059b1a88
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff810469e8>] ? local_bh_enable_ip+0x9/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffffa02daa11>] svc_recv+0x330/0x795 [sunrpc]
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffffa04d2810>] nfsd+0xeb/0x1a5 [nfsd]
Dec  4 11:57:44 iridium kernel: [<ffffffffa04d2725>] ? nfsd+0x0/0x1a5 [nfsd]
Dec  4 11:57:44 iridium kernel: [<ffffffffa04d2725>] ? nfsd+0x0/0x1a5 [nfsd]
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: nfsd          S 0000000000000000     0 12707      2
Dec  4 11:57:44 iridium kernel: ffff88000e5e5de0 0000000000000046 0000000000000000 ffff88000e5e5da4
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800bc5f5c40 ffff88012faa4530
Dec  4 11:57:44 iridium kernel: ffff8800bc5f5fb8 000000012fa9c000 ffff88000e5e5d90 ffff8800bc5f5fb8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffffa02daa11>] svc_recv+0x330/0x795 [sunrpc]
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffffa04d2810>] nfsd+0xeb/0x1a5 [nfsd]
Dec  4 11:57:44 iridium kernel: [<ffffffffa04d2725>] ? nfsd+0x0/0x1a5 [nfsd]
Dec  4 11:57:44 iridium kernel: [<ffffffffa04d2725>] ? nfsd+0x0/0x1a5 [nfsd]
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: nfsd          S 0000000000000000     0 12708      2
Dec  4 11:57:44 iridium kernel: ffff88000e665de0 0000000000000046 0000000000000000 ffffffff810469e8
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800bc52c530 ffff88012fae2e20
Dec  4 11:57:44 iridium kernel: ffff8800bc52c8a8 000000022fad8000 ffff88000e665d90 ffff8800bc52c8a8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff810469e8>] ? local_bh_enable_ip+0x9/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffffa02daa11>] svc_recv+0x330/0x795 [sunrpc]
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffffa04d2810>] nfsd+0xeb/0x1a5 [nfsd]
Dec  4 11:57:44 iridium kernel: [<ffffffffa04d2725>] ? nfsd+0x0/0x1a5 [nfsd]
Dec  4 11:57:44 iridium kernel: [<ffffffffa04d2725>] ? nfsd+0x0/0x1a5 [nfsd]
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: nfsd          S 0000000000000000     0 12709      2
Dec  4 11:57:44 iridium kernel: ffff88000e6e5de0 0000000000000046 0000000000000000 ffffffff810b9c30
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800bc528000 ffff88012fae2e20
Dec  4 11:57:44 iridium kernel: ffff8800bc528378 000000022fad8000 ffff88000e6e5d90 ffff8800bc528378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff810b9c30>] ? __slab_free+0xaf/0x28e
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffffa02daa11>] svc_recv+0x330/0x795 [sunrpc]
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffffa04d2810>] nfsd+0xeb/0x1a5 [nfsd]
Dec  4 11:57:44 iridium kernel: [<ffffffffa04d2725>] ? nfsd+0x0/0x1a5 [nfsd]
Dec  4 11:57:44 iridium kernel: [<ffffffffa04d2725>] ? nfsd+0x0/0x1a5 [nfsd]
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: nfsd          S ffff8800bc56c9c0     0 12710      2
Dec  4 11:57:44 iridium kernel: ffff88000e765de0 0000000000000046 0000000000000001 0000000181140786
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800b050dc40 ffff8800b0509710
Dec  4 11:57:44 iridium kernel: ffff8800b050dfb8 000000022fad8000 ffff88000e765d90 ffff8800b050dfb8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffffa02daa11>] svc_recv+0x330/0x795 [sunrpc]
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffffa04d2810>] nfsd+0xeb/0x1a5 [nfsd]
Dec  4 11:57:44 iridium kernel: [<ffffffffa04d2725>] ? nfsd+0x0/0x1a5 [nfsd]
Dec  4 11:57:44 iridium kernel: [<ffffffffa04d2725>] ? nfsd+0x0/0x1a5 [nfsd]
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e53>] kthread+0x49/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116e9>] child_rip+0xa/0x11
Dec  4 11:57:44 iridium kernel: [<ffffffff81010a07>] ? restore_args+0x0/0x30
Dec  4 11:57:44 iridium kernel: [<ffffffff81054e0a>] ? kthread+0x0/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff810116df>] ? child_rip+0x0/0x11
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: rpc.mountd    S 0000000000000001     0 12713      1
Dec  4 11:57:44 iridium kernel: ffff880010c959c8 0000000000000086 0000000200000044 ffff880010c959d8
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012587dc40 ffff8801059b1710
Dec  4 11:57:44 iridium kernel: ffff88012587dfb8 000000020007ffff ffff880010c95968 ffff88012587dfb8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff810553aa>] ? add_wait_queue+0x3c/0x45
Dec  4 11:57:44 iridium kernel: [<ffffffff813308b0>] schedule_timeout+0x22/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd296>] ? __pollwait+0xd6/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff812d64cb>] ? tcp_poll+0x1f/0x152
Dec  4 11:57:44 iridium kernel: [<ffffffff81031023>] ? need_resched+0x1e/0x28
Dec  4 11:57:44 iridium kernel: [<ffffffff810ccb72>] do_select+0x499/0x505
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffffa02d32d4>] ? ip_map_put+0x40/0x45 [sunrpc]
Dec  4 11:57:44 iridium kernel: [<ffffffff810d616d>] ? mntput_no_expire+0x31/0x144
Dec  4 11:57:44 iridium kernel: [<ffffffff810b8bc1>] ? virt_to_head_page+0x31/0x41
Dec  4 11:57:44 iridium kernel: [<ffffffffa04d95c3>] ? svc_export_parse+0x5c8/0x5e5 [nfsd]
Dec  4 11:57:44 iridium kernel: [<ffffffff810ccd55>] core_sys_select+0x177/0x213
Dec  4 11:57:44 iridium kernel: [<ffffffff810caa98>] ? user_path_at+0x5d/0x8c
Dec  4 11:57:44 iridium kernel: [<ffffffff811403db>] ? file_has_perm+0x83/0x8e
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd11e>] sys_select+0xb8/0x15a
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: smbd          S 0000000000000000     0 27154      1
Dec  4 11:57:44 iridium kernel: ffff8801208779c8 0000000000000086 ffff880120877990 ffff88012087798c
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800bc5f1710 ffff88012faa4530
Dec  4 11:57:44 iridium kernel: ffff8800bc5f1a88 000000018108e952 ffff880120877968 ffff8800bc5f1a88
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff813308b0>] schedule_timeout+0x22/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd296>] ? __pollwait+0xd6/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff81031023>] ? need_resched+0x1e/0x28
Dec  4 11:57:44 iridium kernel: [<ffffffff810ccb72>] do_select+0x499/0x505
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810b8bc1>] ? virt_to_head_page+0x31/0x41
Dec  4 11:57:44 iridium kernel: [<ffffffff810ba491>] ? kmem_cache_free+0x99/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff81331dea>] ? _spin_lock+0x9/0xc
Dec  4 11:57:44 iridium kernel: [<ffffffff810d721a>] ? mnt_drop_write+0x82/0x143
Dec  4 11:57:44 iridium kernel: [<ffffffff810d25a7>] ? touch_atime+0xda/0xfc
Dec  4 11:57:44 iridium kernel: [<ffffffff810ccd55>] core_sys_select+0x177/0x213
Dec  4 11:57:44 iridium kernel: [<ffffffff810bfdcb>] ? do_sync_read+0xe7/0x12d
Dec  4 11:57:44 iridium kernel: [<ffffffff8113ec16>] ? selinux_task_wait+0x33/0x35
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff81044807>] ? do_wait+0x282/0x343
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd11e>] sys_select+0xb8/0x15a
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: smbd          S 0000000000000000     0 27165  27154
Dec  4 11:57:44 iridium kernel: ffff8801059fbf68 0000000000000082 0000000000000000 ffff88012ac97040
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88011f952e20 ffff88012fb19710
Dec  4 11:57:44 iridium kernel: ffff88011f953198 0000000300000000 ffff8800ab81cc28 ffff88011f953198
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8104bb6e>] sys_pause+0x19/0x22
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: nmbd          S 0000000000000000     0 27170      1
Dec  4 11:57:44 iridium kernel: ffff88009be37e78 0000000000000082 0000000000000000 ffff88009be37ea8
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800ca45c530 ffffffff814ab340
Dec  4 11:57:44 iridium kernel: ffff8800ca45c8a8 00000000810575b2 ffff88009be37e18 ffff8800ca45c8a8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff81330e3c>] do_nanosleep+0x66/0xa9
Dec  4 11:57:44 iridium kernel: [<ffffffff8105805e>] hrtimer_nanosleep+0x6b/0xdd
Dec  4 11:57:44 iridium kernel: [<ffffffff81057855>] ? hrtimer_wakeup+0x0/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff81330e21>] ? do_nanosleep+0x4b/0xa9
Dec  4 11:57:44 iridium kernel: [<ffffffff81058124>] sys_nanosleep+0x54/0x6c
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: nmbd          S 0000000000000000     0 27171  27170
Dec  4 11:57:44 iridium kernel: ffff880026489cd8 0000000000000086 0000000000000000 0000000000000000
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8801268d0000 ffff88012faa4530
Dec  4 11:57:44 iridium kernel: ffff8801268d0378 00000001ad9fc558 ffff880026489d18 ffff8801268d0378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff810c6432>] pipe_wait+0x65/0x8d
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff81330bbe>] ? mutex_lock+0x22/0x33
Dec  4 11:57:44 iridium kernel: [<ffffffff810c6c55>] pipe_read+0x335/0x3ac
Dec  4 11:57:44 iridium kernel: [<ffffffff8114028d>] ? inode_has_perm+0x5b/0x61
Dec  4 11:57:44 iridium kernel: [<ffffffff810bfdcb>] do_sync_read+0xe7/0x12d
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff81142a3b>] ? selinux_file_permission+0xaf/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff8113b85c>] ? security_file_permission+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff810c0748>] vfs_read+0xa8/0x102
Dec  4 11:57:44 iridium kernel: [<ffffffff810c0866>] sys_read+0x47/0x6e
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: rpcbind       S 0000000000000000     0 27238      1
Dec  4 11:57:44 iridium kernel: ffff880012d19b18 0000000000000086 0000000000000000 ffff880012d19adc
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800ca451710 ffff88012fae2e20
Dec  4 11:57:44 iridium kernel: ffff8800ca451a88 000000022fad8000 ffff880012d19ac8 ffff8800ca451a88
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810b8bc1>] ? virt_to_head_page+0x31/0x41
Dec  4 11:57:44 iridium kernel: [<ffffffff81298886>] ? sock_destroy_inode+0x14/0x16
Dec  4 11:57:44 iridium kernel: [<ffffffff810d2ef3>] ? destroy_inode+0x3a/0x4f
Dec  4 11:57:44 iridium kernel: [<ffffffff810cfd70>] ? d_free+0x4e/0x65
Dec  4 11:57:44 iridium kernel: [<ffffffff810d616d>] ? mntput_no_expire+0x31/0x144
Dec  4 11:57:44 iridium kernel: [<ffffffff810c0e16>] ? __fput+0x161/0x16d
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: artsd         S 0000000000000001     0 29086      1
Dec  4 11:57:44 iridium kernel: ffff8800827c79c8 0000000000000082 0000000000000000 ffff8800827c798c
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800ba585c40 ffff880129439710
Dec  4 11:57:44 iridium kernel: ffff8800ba585fb8 000000032fb10000 ffff8800827c7978 ffff8800ba585fb8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff810ccb72>] do_select+0x499/0x505
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8116acc3>] ? __up_read+0x7a/0x83
Dec  4 11:57:44 iridium kernel: [<ffffffff81058397>] ? up_read+0x9/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff81334a51>] ? do_page_fault+0x6d0/0xad2
Dec  4 11:57:44 iridium kernel: [<ffffffff8113e77f>] ? avc_has_perm+0x4e/0x60
Dec  4 11:57:44 iridium kernel: [<ffffffff810b9c04>] ? __slab_free+0x83/0x28e
Dec  4 11:57:44 iridium kernel: [<ffffffff8116a5d1>] ? rb_insert_color+0x69/0xe6
Dec  4 11:57:44 iridium kernel: [<ffffffff810575b2>] ? enqueue_hrtimer+0xd3/0xe1
Dec  4 11:57:44 iridium kernel: [<ffffffff81331fe4>] ? _spin_unlock_irqrestore+0x27/0x3e
Dec  4 11:57:44 iridium kernel: [<ffffffff81057fd1>] ? hrtimer_start+0x12e/0x150
Dec  4 11:57:44 iridium kernel: [<ffffffff8105819e>] ? ktime_get_ts+0x49/0x4e
Dec  4 11:57:44 iridium kernel: [<ffffffff8104e3e4>] ? dequeue_signal+0x9e/0x118
Dec  4 11:57:44 iridium kernel: [<ffffffff810cbfd8>] ? zero_fd_set+0x1b/0x1d
Dec  4 11:57:44 iridium kernel: [<ffffffff810ccd55>] core_sys_select+0x177/0x213
Dec  4 11:57:44 iridium kernel: [<ffffffff813320ea>] ? _spin_lock_irq+0x21/0x26
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd11e>] sys_select+0xb8/0x15a
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: xdg-open      ? 0000000000000000     0 29801   3971
Dec  4 11:57:44 iridium kernel: ffff8800265c1ea8 0000000000000046 0000000000000000 0000000000000046
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8801268f1710 ffff88012faa4530
Dec  4 11:57:44 iridium kernel: ffff8801268f1a88 0000000100000000 ffff8800265c1e38 ffff8801268f1a88
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff81330632>] ? _cond_resched+0x9/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff810452b1>] do_exit+0x892/0x8a0
Dec  4 11:57:44 iridium kernel: [<ffffffff81045341>] do_group_exit+0x82/0xaf
Dec  4 11:57:44 iridium kernel: [<ffffffff81045380>] sys_exit_group+0x12/0x14
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: skype         S 0000000000000000     0 13948      1
Dec  4 11:57:44 iridium kernel: ffff880071e83b18 0000000000200086 0000000000000000 ffff880071e83adc
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8801058a5c40 ffffffff814ab340
Dec  4 11:57:44 iridium kernel: ffff8801058a5fb8 0000000081765900 ffff880071e83ac8 ffff8801058a5fb8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff812990fc>] ? __sock_recvmsg+0x6d/0x7a
Dec  4 11:57:44 iridium kernel: [<ffffffff812991f9>] ? sock_aio_read+0xf0/0x100
Dec  4 11:57:44 iridium kernel: [<ffffffff810bfdcb>] ? do_sync_read+0xe7/0x12d
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff81142a3b>] ? selinux_file_permission+0xaf/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff8113b85c>] ? security_file_permission+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8102e5d5>] sysenter_dispatch+0x7/0x4b
Dec  4 11:57:44 iridium kernel: [<ffffffff81331c7e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: skype         S ffff8800bc56c9c0     0 13950      1
Dec  4 11:57:44 iridium kernel: ffff880046619c38 0000000000200086 ffff8800321cc1c0 0000000000000000
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8801268f0000 ffff880116caae20
Dec  4 11:57:44 iridium kernel: ffff8801268f0378 000000010000015a ffff880046619c18 ffff8801268f0378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff810d1656>] ? d_alloc+0x24/0x19b
Dec  4 11:57:44 iridium kernel: [<ffffffff81331dea>] ? _spin_lock+0x9/0xc
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f391>] futex_wait+0x1b9/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff810d616d>] ? mntput_no_expire+0x31/0x144
Dec  4 11:57:44 iridium kernel: [<ffffffff810c709d>] ? mntput+0x18/0x1a
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810d616d>] ? mntput_no_expire+0x31/0x144
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff813321dc>] ? unlock_kernel+0x2f/0x32
Dec  4 11:57:44 iridium kernel: [<ffffffff810ceb28>] ? vfs_lock_file+0x33/0x35
Dec  4 11:57:44 iridium kernel: [<ffffffff810b8bc1>] ? virt_to_head_page+0x31/0x41
Dec  4 11:57:44 iridium kernel: [<ffffffff81331dea>] ? _spin_lock+0x9/0xc
Dec  4 11:57:44 iridium kernel: [<ffffffff810d616d>] ? mntput_no_expire+0x31/0x144
Dec  4 11:57:44 iridium kernel: [<ffffffff810614af>] compat_sys_futex+0xef/0x10d
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8102e5d5>] sysenter_dispatch+0x7/0x4b
Dec  4 11:57:44 iridium kernel: [<ffffffff81331c7e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: skype         S 0000000000000000     0 13951      1
Dec  4 11:57:44 iridium kernel: ffff880075ba99d8 0000000000200086 0000000000000000 ffffffff810b2478
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88011f955c40 ffffffff814ab340
Dec  4 11:57:44 iridium kernel: ffff88011f955fb8 0000000081765900 ffff880075ba9988 ffff88011f955fb8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff810b2478>] ? alloc_page_vma+0xc1/0xc6
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff810ccb72>] do_select+0x499/0x505
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff812aeb78>] ? __rtnl_unlock+0x10/0x12
Dec  4 11:57:44 iridium kernel: [<ffffffff812a6223>] ? netdev_run_todo+0x4d/0x1de
Dec  4 11:57:44 iridium kernel: [<ffffffff812aeb66>] ? rtnl_unlock+0x9/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff812a771f>] ? dev_ioctl+0x570/0x621
Dec  4 11:57:44 iridium kernel: [<ffffffff8114028d>] ? inode_has_perm+0x5b/0x61
Dec  4 11:57:44 iridium kernel: [<ffffffff810ee879>] compat_core_sys_select+0x179/0x212
Dec  4 11:57:44 iridium kernel: [<ffffffff81298886>] ? sock_destroy_inode+0x14/0x16
Dec  4 11:57:44 iridium kernel: [<ffffffff810d2ef3>] ? destroy_inode+0x3a/0x4f
Dec  4 11:57:44 iridium kernel: [<ffffffff810b8bc1>] ? virt_to_head_page+0x31/0x41
Dec  4 11:57:44 iridium kernel: [<ffffffff810cfd70>] ? d_free+0x4e/0x65
Dec  4 11:57:44 iridium kernel: [<ffffffff810d616d>] ? mntput_no_expire+0x31/0x144
Dec  4 11:57:44 iridium kernel: [<ffffffff810eec9b>] compat_sys_select+0x9b/0x132
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8102e5d5>] sysenter_dispatch+0x7/0x4b
Dec  4 11:57:44 iridium kernel: [<ffffffff81331c7e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: skype         S 0000000000000000     0 13952      1
Dec  4 11:57:44 iridium kernel: ffff880075abfe68 0000000000200086 0000000000000000 ffff880075abfe98
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8801268d1710 ffff88012faa4530
Dec  4 11:57:44 iridium kernel: ffff8801268d1a88 00000001810575b2 ffff880075abfe08 ffff8801268d1a88
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff81330e3c>] do_nanosleep+0x66/0xa9
Dec  4 11:57:44 iridium kernel: [<ffffffff8105805e>] hrtimer_nanosleep+0x6b/0xdd
Dec  4 11:57:44 iridium kernel: [<ffffffff81057855>] ? hrtimer_wakeup+0x0/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff81330e21>] ? do_nanosleep+0x4b/0xa9
Dec  4 11:57:44 iridium kernel: [<ffffffff8106ec8f>] compat_sys_nanosleep+0x9b/0x136
Dec  4 11:57:44 iridium kernel: [<ffffffff8102e5d5>] sysenter_dispatch+0x7/0x4b
Dec  4 11:57:44 iridium kernel: [<ffffffff81331c7e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: skype         S 0000000000000000     0 13953      1
Dec  4 11:57:44 iridium kernel: ffff88004dfd7c38 0000000000200086 0000000000000000 0000000100000000
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88011648c530 ffff88012fae2e20
Dec  4 11:57:44 iridium kernel: ffff88011648c8a8 0000000200000000 ccd1ccd100000011 ffff88011648c8a8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff81331fe4>] ? _spin_unlock_irqrestore+0x27/0x3e
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f391>] futex_wait+0x1b9/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff8101f864>] ? native_smp_send_reschedule+0x4d/0x4f
Dec  4 11:57:44 iridium kernel: [<ffffffff810310f4>] ? resched_task+0x84/0x8c
Dec  4 11:57:44 iridium kernel: [<ffffffff81331fe4>] ? _spin_unlock_irqrestore+0x27/0x3e
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5a6>] ? try_to_wake_up+0x26f/0x281
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810614af>] compat_sys_futex+0xef/0x10d
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8102e5d5>] sysenter_dispatch+0x7/0x4b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: skype         S ffff8800bc56c9c0     0 13954      1
Dec  4 11:57:44 iridium kernel: ffff880075badc38 0000000000200086 ffff880075badb70 ffff880075badd00
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8801228f8000 ffff88011648c530
Dec  4 11:57:44 iridium kernel: ffff8801228f8378 0000000275badbb0 ffff880075badbb0 ffff8801228f8378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f391>] futex_wait+0x1b9/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff813320ea>] ? _spin_lock_irq+0x21/0x26
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810614af>] compat_sys_futex+0xef/0x10d
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8102e5d5>] sysenter_dispatch+0x7/0x4b
Dec  4 11:57:44 iridium kernel: [<ffffffff81331c7e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: skype         S ffff8800bc56c9c0     0 13955      1
Dec  4 11:57:44 iridium kernel: ffff8800c53fdc38 0000000000200086 00000000ccd10000 0000000100000000
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8801179ddc40 ffff88011f955c40
Dec  4 11:57:44 iridium kernel: ffff8801179ddfb8 0000000200000000 ccd1ccd100000011 ffff8801179ddfb8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f391>] futex_wait+0x1b9/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff812998ce>] ? sock_sendmsg+0xc7/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff810d5545>] ? mnt_want_write+0x77/0x8d
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f6d9>] ? futex_wake+0xdc/0xed
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff8129a3df>] ? sys_sendto+0xf1/0x107
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff8103e2ad>] ? finish_task_switch+0x31/0xc9
Dec  4 11:57:44 iridium kernel: [<ffffffff81142a3b>] ? selinux_file_permission+0xaf/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff810614af>] compat_sys_futex+0xef/0x10d
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8102e5d5>] sysenter_dispatch+0x7/0x4b
Dec  4 11:57:44 iridium kernel: [<ffffffff81331c7e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: skype         S ffff8800bc56c9c0     0 13959      1
Dec  4 11:57:44 iridium kernel: ffff880046711c38 0000000000200086 ffff880046711b88 ffffffff81166779
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff880122919710 ffff8801058a5c40
Dec  4 11:57:44 iridium kernel: ffff880122919a88 0000000200000001 ffff880046711bc8 ffff880122919a88
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff81166779>] ? __next_cpu+0x19/0x26
Dec  4 11:57:44 iridium kernel: [<ffffffff81035a6e>] ? enqueue_entity+0x1b9/0x1c2
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f391>] futex_wait+0x1b9/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff81331c7e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
Dec  4 11:57:44 iridium kernel: [<ffffffff81331dea>] ? _spin_lock+0x9/0xc
Dec  4 11:57:44 iridium kernel: [<ffffffff810d721a>] ? mnt_drop_write+0x82/0x143
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff810bfc9e>] ? do_sync_write+0xe7/0x12d
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff810cfd70>] ? d_free+0x4e/0x65
Dec  4 11:57:44 iridium kernel: [<ffffffff81331dea>] ? _spin_lock+0x9/0xc
Dec  4 11:57:44 iridium kernel: [<ffffffff810614af>] compat_sys_futex+0xef/0x10d
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8102e5d5>] sysenter_dispatch+0x7/0x4b
Dec  4 11:57:44 iridium kernel: [<ffffffff81331c7e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: pickup        S ffff8800bc56ea40     0 17558   2845
Dec  4 11:57:44 iridium kernel: ffff8800c9367e18 0000000000000082 ffffffff00000002 0000000000000000
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012587ae20 ffff8801209b1710
Dec  4 11:57:44 iridium kernel: ffff88012587b198 000000032fb10000 ffff8800c9367dc8 ffff88012587b198
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff810ebab5>] sys_epoll_wait+0x1da/0x45f
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: eclipse       S 0000000000000000     0 19157      1
Dec  4 11:57:44 iridium kernel: ffff8801292ffe68 0000000000000082 0000000000000000 0000000000000092
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff880109021710 ffff88012fae2e20
Dec  4 11:57:44 iridium kernel: ffff880109021a88 0000000200000000 ffff8801292ffdf8 ffff880109021a88
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8113baa9>] ? security_task_wait+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff810447d5>] do_wait+0x250/0x343
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8104495e>] sys_wait4+0x96/0xb1
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S 0000000000000000     0 19172  19157
Dec  4 11:57:44 iridium kernel: ffff88012acafc38 0000000000000086 0000000000000000 ffff88004dd37128
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800ba581710 ffff88012fae2e20
Dec  4 11:57:44 iridium kernel: ffff8800ba581a88 0000000200000014 ffff88012acafbe8 ffff8800ba581a88
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f391>] futex_wait+0x1b9/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff81037400>] ? tg_shares_up+0x0/0x18e
Dec  4 11:57:44 iridium kernel: [<ffffffff8103126b>] ? tg_nop+0x0/0x6
Dec  4 11:57:44 iridium kernel: [<ffffffff81032dea>] ? walk_tg_tree+0x7f/0x98
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff810310f4>] ? resched_task+0x84/0x8c
Dec  4 11:57:44 iridium kernel: [<ffffffff810310c2>] ? resched_task+0x52/0x8c
Dec  4 11:57:44 iridium kernel: [<ffffffff810388ca>] ? wake_up_new_task+0x106/0x117
Dec  4 11:57:44 iridium kernel: [<ffffffff81040fac>] ? do_fork+0x1cd/0x257
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S 0000000000000000     0 19173  19157
Dec  4 11:57:44 iridium kernel: ffff88012b981b18 0000000000000086 0000000000000000 ffff88012b981adc
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800ba582e20 ffffffff814ab340
Dec  4 11:57:44 iridium kernel: ffff8800ba583198 0000000081765900 ffff88012b981ac8 ffff8800ba583198
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff812990fc>] ? __sock_recvmsg+0x6d/0x7a
Dec  4 11:57:44 iridium kernel: [<ffffffff812991f9>] ? sock_aio_read+0xf0/0x100
Dec  4 11:57:44 iridium kernel: [<ffffffff810bfdcb>] ? do_sync_read+0xe7/0x12d
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff81142a3b>] ? selinux_file_permission+0xaf/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff8113b85c>] ? security_file_permission+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S 0000000000000000     0 19174  19157
Dec  4 11:57:44 iridium kernel: ffff88012b57dc38 0000000000000086 0000000000000000 0000000000000001
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88011f951710 ffff88012fb19710
Dec  4 11:57:44 iridium kernel: ffff88011f951a88 0000000381033e10 ffff88012b57dbe8 ffff88011f951a88
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f391>] futex_wait+0x1b9/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5c5>] ? default_wake_function+0xd/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff81031eab>] ? __wake_up_common+0x46/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f6d9>] ? futex_wake+0xdc/0xed
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff81033b5f>] ? __dequeue_entity+0x61/0x6a
Dec  4 11:57:44 iridium kernel: [<ffffffff8103408c>] ? pick_next_task_fair+0x9d/0xac
Dec  4 11:57:44 iridium kernel: [<ffffffff81016837>] ? read_tsc+0xe/0x24
Dec  4 11:57:44 iridium kernel: [<ffffffff8105a18b>] ? getnstimeofday+0x3a/0x96
Dec  4 11:57:44 iridium kernel: [<ffffffff8105819e>] ? ktime_get_ts+0x49/0x4e
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S 0000000000000000     0 19175  19157
Dec  4 11:57:44 iridium kernel: ffff88012934dc38 0000000000000086 0000000000000000 ffffffff810264e1
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88011f950000 ffff88012fae2e20
Dec  4 11:57:44 iridium kernel: ffff88011f950378 000000028101f864 ffff88012934dbe8 ffff88011f950378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff810264e1>] ? flat_send_IPI_mask+0x52/0x6c
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f391>] futex_wait+0x1b9/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff81031eab>] ? __wake_up_common+0x46/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff8103356c>] ? __wake_up+0x43/0x50
Dec  4 11:57:44 iridium kernel: [<ffffffff8117083c>] ? plist_add+0x82/0x8a
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff81033b5f>] ? __dequeue_entity+0x61/0x6a
Dec  4 11:57:44 iridium kernel: [<ffffffff8103408c>] ? pick_next_task_fair+0x9d/0xac
Dec  4 11:57:44 iridium kernel: [<ffffffff81031e49>] ? pick_next_task+0x25/0x41
Dec  4 11:57:44 iridium kernel: [<ffffffff8133050e>] ? thread_return+0xab/0xd9
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S 0000000000000000     0 19176  19157
Dec  4 11:57:44 iridium kernel: ffff8801292f9c38 0000000000000086 0000000000000000 ffffffff81020143
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88011f954530 ffffffff814ab340
Dec  4 11:57:44 iridium kernel: ffff88011f9548a8 00000000000000fd 0000000000000004 ffff88011f9548a8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff81020143>] ? apic_wait_icr_idle+0x1a/0x24
Dec  4 11:57:44 iridium kernel: [<ffffffff810264e1>] ? flat_send_IPI_mask+0x52/0x6c
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f391>] futex_wait+0x1b9/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff81031eab>] ? __wake_up_common+0x46/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5c5>] ? default_wake_function+0xd/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff81031eab>] ? __wake_up_common+0x46/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f6d9>] ? futex_wake+0xdc/0xed
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff81033b5f>] ? __dequeue_entity+0x61/0x6a
Dec  4 11:57:44 iridium kernel: [<ffffffff8103408c>] ? pick_next_task_fair+0x9d/0xac
Dec  4 11:57:44 iridium kernel: [<ffffffff81031e49>] ? pick_next_task+0x25/0x41
Dec  4 11:57:44 iridium kernel: [<ffffffff8133050e>] ? thread_return+0xab/0xd9
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S 0000000000000000     0 19177  19157
Dec  4 11:57:44 iridium kernel: ffff8801292d1c38 0000000000000086 0000000000000000 ffffffff81020143
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800ca452e20 ffffffff814ab340
Dec  4 11:57:44 iridium kernel: ffff8800ca453198 00000000000000fd 0000000000000008 ffff8800ca453198
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff81020143>] ? apic_wait_icr_idle+0x1a/0x24
Dec  4 11:57:44 iridium kernel: [<ffffffff810264e1>] ? flat_send_IPI_mask+0x52/0x6c
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f391>] futex_wait+0x1b9/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff81031eab>] ? __wake_up_common+0x46/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5c5>] ? default_wake_function+0xd/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff81031eab>] ? __wake_up_common+0x46/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f6d9>] ? futex_wake+0xdc/0xed
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff81033b5f>] ? __dequeue_entity+0x61/0x6a
Dec  4 11:57:44 iridium kernel: [<ffffffff8103408c>] ? pick_next_task_fair+0x9d/0xac
Dec  4 11:57:44 iridium kernel: [<ffffffff81016837>] ? read_tsc+0xe/0x24
Dec  4 11:57:44 iridium kernel: [<ffffffff8105a18b>] ? getnstimeofday+0x3a/0x96
Dec  4 11:57:44 iridium kernel: [<ffffffff8105819e>] ? ktime_get_ts+0x49/0x4e
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S 0000000000000000     0 19178  19157
Dec  4 11:57:44 iridium kernel: ffff8801292bbc38 0000000000000086 0000000000000000 ffff8801292bbc68
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8801059b4530 ffff88012faa4530
Dec  4 11:57:44 iridium kernel: ffff8801059b48a8 00000001810575b2 ffff8801292bbbd8 ffff8801059b48a8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f3ff>] futex_wait+0x227/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff81057855>] ? hrtimer_wakeup+0x0/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f3db>] ? futex_wait+0x203/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f6d9>] ? futex_wake+0xdc/0xed
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff8100e80e>] ? __switch_to+0x1b0/0x3e0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103408c>] ? pick_next_task_fair+0x9d/0xac
Dec  4 11:57:44 iridium kernel: [<ffffffff81016837>] ? read_tsc+0xe/0x24
Dec  4 11:57:44 iridium kernel: [<ffffffff8103e2ad>] ? finish_task_switch+0x31/0xc9
Dec  4 11:57:44 iridium kernel: [<ffffffff8105a18b>] ? getnstimeofday+0x3a/0x96
Dec  4 11:57:44 iridium kernel: [<ffffffff8105819e>] ? ktime_get_ts+0x49/0x4e
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S ffff88004dd370c0     0 19179  19157
Dec  4 11:57:44 iridium kernel: ffff88012928fc38 0000000000000086 ffffffff816dee80 0000000000000001
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8801059b5c40 ffff8801059b2e20
Dec  4 11:57:44 iridium kernel: ffff8801059b5fb8 0000000281033e10 ffff88012928fbe8 ffff8801059b5fb8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f391>] futex_wait+0x1b9/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff81037f8f>] ? check_preempt_wakeup+0x12c/0x19e
Dec  4 11:57:44 iridium kernel: [<ffffffff81331fe4>] ? _spin_unlock_irqrestore+0x27/0x3e
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5a6>] ? try_to_wake_up+0x26f/0x281
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff8103408c>] ? pick_next_task_fair+0x9d/0xac
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S ffff88004dd370c0     0 19180  19157
Dec  4 11:57:44 iridium kernel: ffff88012928bc38 0000000000000086 ffffffff8116a5d1 ffff88012928bc68
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8801059b2e20 ffff8800ba582e20
Dec  4 11:57:44 iridium kernel: ffff8801059b3198 000000022804b348 ffff88012928bbe8 ffff8801059b3198
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8116a5d1>] ? rb_insert_color+0x69/0xe6
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f391>] futex_wait+0x1b9/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff81057855>] ? hrtimer_wakeup+0x0/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f6d9>] ? futex_wake+0xdc/0xed
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff8113f44f>] ? selinux_file_free_security+0x1e/0x20
Dec  4 11:57:44 iridium kernel: [<ffffffff81016837>] ? read_tsc+0xe/0x24
Dec  4 11:57:44 iridium kernel: [<ffffffff8105a18b>] ? getnstimeofday+0x3a/0x96
Dec  4 11:57:44 iridium kernel: [<ffffffff8105819e>] ? ktime_get_ts+0x49/0x4e
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S 0000000000000000     0 19181  19157
Dec  4 11:57:44 iridium kernel: ffff880129281c38 0000000000000086 0000000000000000 ffffffff810264e1
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800ca459710 ffff88012fae2e20
Dec  4 11:57:44 iridium kernel: ffff8800ca459a88 000000028101f864 ffff880129281be8 ffff8800ca459a88
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff810264e1>] ? flat_send_IPI_mask+0x52/0x6c
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f391>] futex_wait+0x1b9/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff8103656c>] ? find_busiest_group+0x327/0x7d5
Dec  4 11:57:44 iridium kernel: [<ffffffff8116a625>] ? rb_insert_color+0xbd/0xe6
Dec  4 11:57:44 iridium kernel: [<ffffffff81020143>] ? apic_wait_icr_idle+0x1a/0x24
Dec  4 11:57:44 iridium kernel: [<ffffffff81026391>] ? __send_IPI_dest_field+0x5e/0x67
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff81331b60>] ? __down_write_nested+0xa3/0xbd
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S 0000000000000000     0 19182  19157
Dec  4 11:57:44 iridium kernel: ffff880129267c38 0000000000000086 0000000000000000 ffff880129267bfc
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800ca45ae20 ffff88012fae2e20
Dec  4 11:57:44 iridium kernel: ffff8800ca45b198 0000000200000007 ffff880129267bc8 ffff8800ca45b198
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f391>] futex_wait+0x1b9/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff81092ecf>] ? free_pages_bulk+0x7a/0x88
Dec  4 11:57:44 iridium kernel: [<ffffffff810930c5>] ? free_pages_check+0x82/0x8a
Dec  4 11:57:44 iridium kernel: [<ffffffff810923be>] ? get_pageblock_migratetype+0x1b/0x1d
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f6d9>] ? futex_wake+0xdc/0xed
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff810aa414>] ? free_pages_and_swap_cache+0x57/0x72
Dec  4 11:57:44 iridium kernel: [<ffffffff8116acc3>] ? __up_read+0x7a/0x83
Dec  4 11:57:44 iridium kernel: [<ffffffff81058397>] ? up_read+0x9/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8109d232>] ? sys_madvise+0x49a/0x4dc
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S 0000000000000001     0 19183  19157
Dec  4 11:57:44 iridium kernel: ffff880129229c38 0000000000000086 ffff88004dd37128 ffff88004dd37128
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800ca458000 ffff880129438000
Dec  4 11:57:44 iridium kernel: ffff8800ca458378 0000000000000007 ffff880129229bc8 ffff8800ca458378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff81334a51>] ? do_page_fault+0x6d0/0xad2
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f391>] futex_wait+0x1b9/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5c5>] ? default_wake_function+0xd/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff81031eab>] ? __wake_up_common+0x46/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f6d9>] ? futex_wake+0xdc/0xed
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff8100ea2c>] ? __switch_to+0x3ce/0x3e0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103408c>] ? pick_next_task_fair+0x9d/0xac
Dec  4 11:57:44 iridium kernel: [<ffffffff8103e2ad>] ? finish_task_switch+0x31/0xc9
Dec  4 11:57:44 iridium kernel: [<ffffffff8133050e>] ? thread_return+0xab/0xd9
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5e4>] ? wake_up_process+0x10/0x12
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S 0000000000000000     0 19184  19157
Dec  4 11:57:44 iridium kernel: ffff880129227c38 0000000000000086 0000000000000000 ffff88004dd37128
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800ca45dc40 ffffffff814ab340
Dec  4 11:57:44 iridium kernel: ffff8800ca45dfb8 0000000000000014 ffff880129227bc8 ffff8800ca45dfb8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff81334a51>] ? do_page_fault+0x6d0/0xad2
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f391>] futex_wait+0x1b9/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff81020143>] ? apic_wait_icr_idle+0x1a/0x24
Dec  4 11:57:44 iridium kernel: [<ffffffff81026391>] ? __send_IPI_dest_field+0x5e/0x67
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff813320ea>] ? _spin_lock_irq+0x21/0x26
Dec  4 11:57:44 iridium kernel: [<ffffffff81331afa>] ? __down_write_nested+0x3d/0xbd
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S 0000000000000000     0 19185  19157
Dec  4 11:57:44 iridium kernel: ffff880129219c38 0000000000000086 0000000000000000 ffff880129219bfc
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff880113a51710 ffff88012fb19710
Dec  4 11:57:44 iridium kernel: ffff880113a51a88 00000003810575b2 ffff880129219bd8 ffff880113a51a88
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f3ff>] futex_wait+0x227/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff81057855>] ? hrtimer_wakeup+0x0/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f3db>] ? futex_wait+0x203/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f6d9>] ? futex_wake+0xdc/0xed
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff810aa414>] ? free_pages_and_swap_cache+0x57/0x72
Dec  4 11:57:44 iridium kernel: [<ffffffff81016837>] ? read_tsc+0xe/0x24
Dec  4 11:57:44 iridium kernel: [<ffffffff8105a18b>] ? getnstimeofday+0x3a/0x96
Dec  4 11:57:44 iridium kernel: [<ffffffff8105819e>] ? ktime_get_ts+0x49/0x4e
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S 0000000000000000     0 19187  19157
Dec  4 11:57:44 iridium kernel: ffff88011d8a1c38 0000000000000086 0000000000000000 ffff88011d8a1c68
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800ba584530 ffff88012fb19710
Dec  4 11:57:44 iridium kernel: ffff8800ba5848a8 00000003810575b2 ffff88011d8a1bd8 ffff8800ba5848a8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f3ff>] futex_wait+0x227/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff81057855>] ? hrtimer_wakeup+0x0/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f3db>] ? futex_wait+0x203/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff81026391>] ? __send_IPI_dest_field+0x5e/0x67
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff81016837>] ? read_tsc+0xe/0x24
Dec  4 11:57:44 iridium kernel: [<ffffffff8105a18b>] ? getnstimeofday+0x3a/0x96
Dec  4 11:57:44 iridium kernel: [<ffffffff8105819e>] ? ktime_get_ts+0x49/0x4e
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S 0000000000000000     0 19188  19157
Dec  4 11:57:44 iridium kernel: ffff880105911c38 0000000000000086 ffff880105911c00 ffff880105911bfc
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff880122918000 ffff88012fb19710
Dec  4 11:57:44 iridium kernel: ffff880122918378 0000000381033e10 ffff880105911be8 ffff880122918378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f391>] futex_wait+0x1b9/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5c5>] ? default_wake_function+0xd/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff81031eab>] ? __wake_up_common+0x46/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f6d9>] ? futex_wake+0xdc/0xed
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff8100e80e>] ? __switch_to+0x1b0/0x3e0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103408c>] ? pick_next_task_fair+0x9d/0xac
Dec  4 11:57:44 iridium kernel: [<ffffffff8103e2ad>] ? finish_task_switch+0x31/0xc9
Dec  4 11:57:44 iridium kernel: [<ffffffff8133050e>] ? thread_return+0xab/0xd9
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S 0000000000000000     0 19189  19157
Dec  4 11:57:44 iridium kernel: ffff8801295cbc38 0000000000000086 0000000000000000 0000000000000001
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012291c530 ffff88012fae2e20
Dec  4 11:57:44 iridium kernel: ffff88012291c8a8 0000000281033e10 ffff8801295cbbe8 ffff88012291c8a8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f391>] futex_wait+0x1b9/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5c5>] ? default_wake_function+0xd/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff81031eab>] ? __wake_up_common+0x46/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f6d9>] ? futex_wake+0xdc/0xed
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff8100ea2c>] ? __switch_to+0x3ce/0x3e0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103408c>] ? pick_next_task_fair+0x9d/0xac
Dec  4 11:57:44 iridium kernel: [<ffffffff8103e2ad>] ? finish_task_switch+0x31/0xc9
Dec  4 11:57:44 iridium kernel: [<ffffffff8133050e>] ? thread_return+0xab/0xd9
Dec  4 11:57:44 iridium kernel: [<ffffffff810c339c>] ? vfs_stat_fd+0x21/0x4e
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S 0000000000000000     0 19190  19157
Dec  4 11:57:44 iridium kernel: ffff880075bd9c38 0000000000000086 0000000000000000 ffff880075bd9bfc
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012bd20000 ffff88012fb19710
Dec  4 11:57:44 iridium kernel: ffff88012bd20378 00000003810575b2 ffff880075bd9bd8 ffff88012bd20378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f3ff>] futex_wait+0x227/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff81057855>] ? hrtimer_wakeup+0x0/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f3db>] ? futex_wait+0x203/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff8103408c>] ? pick_next_task_fair+0x9d/0xac
Dec  4 11:57:44 iridium kernel: [<ffffffff81016837>] ? read_tsc+0xe/0x24
Dec  4 11:57:44 iridium kernel: [<ffffffff8105a18b>] ? getnstimeofday+0x3a/0x96
Dec  4 11:57:44 iridium kernel: [<ffffffff8105819e>] ? ktime_get_ts+0x49/0x4e
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S 0000000000000000     0 19194  19157
Dec  4 11:57:44 iridium kernel: ffff8800a03f1c38 0000000000000086 0000000000000000 ffff88004dd37128
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800c7de2e20 ffff88012fae2e20
Dec  4 11:57:44 iridium kernel: ffff8800c7de3198 0000000200000006 ffff8800a03f1bc8 ffff8800c7de3198
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff81331fe4>] ? _spin_unlock_irqrestore+0x27/0x3e
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f391>] futex_wait+0x1b9/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff8101f864>] ? native_smp_send_reschedule+0x4d/0x4f
Dec  4 11:57:44 iridium kernel: [<ffffffff810310f4>] ? resched_task+0x84/0x8c
Dec  4 11:57:44 iridium kernel: [<ffffffff81331fe4>] ? _spin_unlock_irqrestore+0x27/0x3e
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5a6>] ? try_to_wake_up+0x26f/0x281
Dec  4 11:57:44 iridium kernel: [<ffffffff81026391>] ? __send_IPI_dest_field+0x5e/0x67
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f6d9>] ? futex_wake+0xdc/0xed
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5a6>] ? try_to_wake_up+0x26f/0x281
Dec  4 11:57:44 iridium kernel: [<ffffffff81016837>] ? read_tsc+0xe/0x24
Dec  4 11:57:44 iridium kernel: [<ffffffff8105a18b>] ? getnstimeofday+0x3a/0x96
Dec  4 11:57:44 iridium kernel: [<ffffffff8105819e>] ? ktime_get_ts+0x49/0x4e
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S 0000000000000000     0 19195  19157
Dec  4 11:57:44 iridium kernel: ffff880077d2dc38 0000000000000086 0000000000000000 ffff88004dd37128
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88012bd25c40 ffff88012faa4530
Dec  4 11:57:44 iridium kernel: ffff88012bd25fb8 0000000100000006 ffff880077d2dbd8 ffff88012bd25fb8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f391>] futex_wait+0x1b9/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff81037ff6>] ? check_preempt_wakeup+0x193/0x19e
Dec  4 11:57:44 iridium kernel: [<ffffffff81331fe4>] ? _spin_unlock_irqrestore+0x27/0x3e
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5a6>] ? try_to_wake_up+0x26f/0x281
Dec  4 11:57:44 iridium kernel: [<ffffffff81026391>] ? __send_IPI_dest_field+0x5e/0x67
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f6d9>] ? futex_wake+0xdc/0xed
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S ffff88004dd370c0     0 19199  19157
Dec  4 11:57:44 iridium kernel: ffff8800c7d77c38 0000000000000086 ffff8800c7d77b88 ffff8800c7d77c68
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8801228fdc40 ffff8800ba582e20
Dec  4 11:57:44 iridium kernel: ffff8801228fdfb8 00000000810575b2 ffff8800c7d77bd8 ffff8801228fdfb8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff81057fd1>] ? hrtimer_start+0x12e/0x150
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f3ff>] futex_wait+0x227/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff81057855>] ? hrtimer_wakeup+0x0/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f3db>] ? futex_wait+0x203/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff810bfc9e>] ? do_sync_write+0xe7/0x12d
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff81016837>] ? read_tsc+0xe/0x24
Dec  4 11:57:44 iridium kernel: [<ffffffff8105a18b>] ? getnstimeofday+0x3a/0x96
Dec  4 11:57:44 iridium kernel: [<ffffffff8105819e>] ? ktime_get_ts+0x49/0x4e
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S ffff88004dd370c0     0 19200  19157
Dec  4 11:57:44 iridium kernel: ffff88008dff7c38 0000000000000086 0000000000000000 ffff88008dff7c68
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88011d828000 ffff8801289b9710
Dec  4 11:57:44 iridium kernel: ffff88011d828378 00000003810575b2 ffff88008dff7bd8 ffff88011d828378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff81057fd1>] ? hrtimer_start+0x12e/0x150
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f3ff>] futex_wait+0x227/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff81057855>] ? hrtimer_wakeup+0x0/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f3db>] ? futex_wait+0x203/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f6d9>] ? futex_wake+0xdc/0xed
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff8103408c>] ? pick_next_task_fair+0x9d/0xac
Dec  4 11:57:44 iridium kernel: [<ffffffff81016837>] ? read_tsc+0xe/0x24
Dec  4 11:57:44 iridium kernel: [<ffffffff8105a18b>] ? getnstimeofday+0x3a/0x96
Dec  4 11:57:44 iridium kernel: [<ffffffff8105819e>] ? ktime_get_ts+0x49/0x4e
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S ffff88004dd370c0     0 19201  19157
Dec  4 11:57:44 iridium kernel: ffff8800265afc38 0000000000000086 ffffffff8116a5d1 ffff8800265afc68
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8801289b9710 ffff88012bd20000
Dec  4 11:57:44 iridium kernel: ffff8801289b9a88 00000003810575b2 ffff8800265afbd8 ffff8801289b9a88
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8116a5d1>] ? rb_insert_color+0x69/0xe6
Dec  4 11:57:44 iridium kernel: [<ffffffff81057fd1>] ? hrtimer_start+0x12e/0x150
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f3ff>] futex_wait+0x227/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff81057855>] ? hrtimer_wakeup+0x0/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f3db>] ? futex_wait+0x203/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff810310c2>] ? resched_task+0x52/0x8c
Dec  4 11:57:44 iridium kernel: [<ffffffff81016837>] ? read_tsc+0xe/0x24
Dec  4 11:57:44 iridium kernel: [<ffffffff8105a18b>] ? getnstimeofday+0x3a/0x96
Dec  4 11:57:44 iridium kernel: [<ffffffff8105819e>] ? ktime_get_ts+0x49/0x4e
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S 0000000000000000     0 19202  19157
Dec  4 11:57:44 iridium kernel: ffff880015595c38 0000000000000086 0000000000000000 ffff880015595c68
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8801209b4530 ffffffff814ab340
Dec  4 11:57:44 iridium kernel: ffff8801209b48a8 00000000810575b2 ffff880015595bd8 ffff8801209b48a8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f3ff>] futex_wait+0x227/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff81057855>] ? hrtimer_wakeup+0x0/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f3db>] ? futex_wait+0x203/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff8103408c>] ? pick_next_task_fair+0x9d/0xac
Dec  4 11:57:44 iridium kernel: [<ffffffff81016837>] ? read_tsc+0xe/0x24
Dec  4 11:57:44 iridium kernel: [<ffffffff8105a18b>] ? getnstimeofday+0x3a/0x96
Dec  4 11:57:44 iridium kernel: [<ffffffff8105819e>] ? ktime_get_ts+0x49/0x4e
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S ffff88004dd370c0     0 19203  19157
Dec  4 11:57:44 iridium kernel: ffff8800b1f27c38 0000000000000086 0000000000000000 ffff8800b1f27c68
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff880116488000 ffff880116caae20
Dec  4 11:57:44 iridium kernel: ffff880116488378 00000001810575b2 ffff8800b1f27bd8 ffff880116488378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff81057fd1>] ? hrtimer_start+0x12e/0x150
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f3ff>] futex_wait+0x227/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff81057855>] ? hrtimer_wakeup+0x0/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f3db>] ? futex_wait+0x203/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff8103408c>] ? pick_next_task_fair+0x9d/0xac
Dec  4 11:57:44 iridium kernel: [<ffffffff81016837>] ? read_tsc+0xe/0x24
Dec  4 11:57:44 iridium kernel: [<ffffffff8105a18b>] ? getnstimeofday+0x3a/0x96
Dec  4 11:57:44 iridium kernel: [<ffffffff8105819e>] ? ktime_get_ts+0x49/0x4e
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S 0000000000000000     0 19204  19157
Dec  4 11:57:44 iridium kernel: ffff8800b1e4fc38 0000000000000086 0000000000000000 ffff8800b1e4fc68
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff880116641710 ffffffff814ab340
Dec  4 11:57:44 iridium kernel: ffff880116641a88 00000000810575b2 ffff8800b1e4fbd8 ffff880116641a88
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f3ff>] futex_wait+0x227/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff81057855>] ? hrtimer_wakeup+0x0/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f3db>] ? futex_wait+0x203/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f6d9>] ? futex_wake+0xdc/0xed
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff8103408c>] ? pick_next_task_fair+0x9d/0xac
Dec  4 11:57:44 iridium kernel: [<ffffffff81016837>] ? read_tsc+0xe/0x24
Dec  4 11:57:44 iridium kernel: [<ffffffff8105a18b>] ? getnstimeofday+0x3a/0x96
Dec  4 11:57:44 iridium kernel: [<ffffffff8105819e>] ? ktime_get_ts+0x49/0x4e
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S 0000000000000000     0 19211  19157
Dec  4 11:57:44 iridium kernel: ffff8800b1f4bc38 0000000000000086 ffff8800b1f4bc00 ffff8800b1f4bbfc
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff88011a215c40 ffffffff814ab340
Dec  4 11:57:44 iridium kernel: ffff88011a215fb8 0000000000000006 ffff8800b1f4bbd8 ffff88011a215fb8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f391>] futex_wait+0x1b9/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff81037ff6>] ? check_preempt_wakeup+0x193/0x19e
Dec  4 11:57:44 iridium kernel: [<ffffffff81331fe4>] ? _spin_unlock_irqrestore+0x27/0x3e
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5a6>] ? try_to_wake_up+0x26f/0x281
Dec  4 11:57:44 iridium kernel: [<ffffffff81026391>] ? __send_IPI_dest_field+0x5e/0x67
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f6d9>] ? futex_wake+0xdc/0xed
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8107e7d8>] ? audit_syscall_entry+0x101/0x135
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S 0000000000000000     0 19212  19157
Dec  4 11:57:44 iridium kernel: ffff88008dfc1c38 0000000000000086 0000000000000000 ffff88008dfc1c68
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800b1785c40 ffff88012faa4530
Dec  4 11:57:44 iridium kernel: ffff8800b1785fb8 00000001810575b2 ffff88008dfc1bd8 ffff8800b1785fb8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f3ff>] futex_wait+0x227/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff81057855>] ? hrtimer_wakeup+0x0/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f3db>] ? futex_wait+0x203/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f6d9>] ? futex_wake+0xdc/0xed
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810608da>] do_futex+0x90/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff81016837>] ? read_tsc+0xe/0x24
Dec  4 11:57:44 iridium kernel: [<ffffffff8105a18b>] ? getnstimeofday+0x3a/0x96
Dec  4 11:57:44 iridium kernel: [<ffffffff8105819e>] ? ktime_get_ts+0x49/0x4e
Dec  4 11:57:44 iridium kernel: [<ffffffff810612b2>] sys_futex+0xf5/0x113
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S 0000000000000000     0 19228  19157
Dec  4 11:57:44 iridium kernel: ffff8800264cfb18 0000000000000086 ffff8800264cfae0 ffff8800264cfadc
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800c7de5c40 ffff88012fb19710
Dec  4 11:57:44 iridium kernel: ffff8800c7de5fb8 0000000300000092 ffffffff816dee80 ffff8800c7de5fb8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff813308b0>] schedule_timeout+0x22/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd296>] ? __pollwait+0xd6/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff812d64cb>] ? tcp_poll+0x1f/0x152
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff81057e54>] ? hrtimer_cancel+0x14/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f4ab>] ? futex_wait+0x2d3/0x3a4
Dec  4 11:57:44 iridium kernel: [<ffffffff81057855>] ? hrtimer_wakeup+0x0/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff81331dea>] ? _spin_lock+0x9/0xc
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f6d9>] ? futex_wake+0xdc/0xed
Dec  4 11:57:44 iridium kernel: [<ffffffff810608ff>] ? do_futex+0xb5/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff81016837>] ? read_tsc+0xe/0x24
Dec  4 11:57:44 iridium kernel: [<ffffffff8105a18b>] ? getnstimeofday+0x3a/0x96
Dec  4 11:57:44 iridium kernel: [<ffffffff8105819e>] ? ktime_get_ts+0x49/0x4e
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: java          S 0000000000000000     0 19229  19157
Dec  4 11:57:44 iridium kernel: ffff8800242a7b18 0000000000000086 ffff8800242a7ae0 ffff8800242a7adc
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800c7de1710 ffffffff814ab340
Dec  4 11:57:44 iridium kernel: ffff8800c7de1a88 00000000040f0b08 ffff880129557b00 ffff8800c7de1a88
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff813308b0>] schedule_timeout+0x22/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd296>] ? __pollwait+0xd6/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff812d64cb>] ? tcp_poll+0x1f/0x152
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff810359a2>] ? enqueue_entity+0xed/0x1c2
Dec  4 11:57:44 iridium kernel: [<ffffffff81035abd>] ? enqueue_task_fair+0x46/0x4b
Dec  4 11:57:44 iridium kernel: [<ffffffff81031998>] ? enqueue_task+0x50/0x5b
Dec  4 11:57:44 iridium kernel: [<ffffffff81331fe4>] ? _spin_unlock_irqrestore+0x27/0x3e
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5a6>] ? try_to_wake_up+0x26f/0x281
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5c5>] ? default_wake_function+0xd/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff81031eab>] ? __wake_up_common+0x46/0x76
Dec  4 11:57:44 iridium kernel: [<ffffffff8103356c>] ? __wake_up+0x43/0x50
Dec  4 11:57:44 iridium kernel: [<ffffffff8105f5f1>] ? wake_futex+0x27/0x33
Dec  4 11:57:44 iridium kernel: [<ffffffff810610e0>] ? do_futex+0x896/0x973
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: gnome-termina S ffff8800bc56fa80     0 19258      1
Dec  4 11:57:44 iridium kernel: ffff880128865b18 0000000000000082 ffff880128865ae0 ffff880128865adc
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8801058a0000 ffff880113a51710
Dec  4 11:57:44 iridium kernel: ffff8801058a0378 000000032fb10000 ffff880128865ac8 ffff8801058a0378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b61b>] ? __mod_timer+0xbb/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff8133091b>] schedule_timeout+0x8d/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff8104afe4>] ? process_timeout+0x0/0xb
Dec  4 11:57:44 iridium kernel: [<ffffffff8104b57c>] ? __mod_timer+0x1c/0xcd
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc334>] do_sys_poll+0x2a8/0x371
Dec  4 11:57:44 iridium kernel: [<ffffffff810cd1c0>] ? __pollwait+0x0/0xe0
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff81142a3b>] ? selinux_file_permission+0xaf/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff8113b85c>] ? security_file_permission+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff810c71b3>] ? path_put+0x1d/0x21
Dec  4 11:57:44 iridium kernel: [<ffffffff810cc630>] sys_poll+0x39/0x85
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: gnome-termina S 0000000000000000     0 19264      1
Dec  4 11:57:44 iridium kernel: ffff8800a87e9cd8 0000000000000082 0000000000000000 ffff8800a87e9c9c
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800c7cc0000 ffff88012faa4530
Dec  4 11:57:44 iridium kernel: ffff8800c7cc0378 0000000100000000 0000000000000000 ffff8800c7cc0378
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff810c6432>] pipe_wait+0x65/0x8d
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff81330bbe>] ? mutex_lock+0x22/0x33
Dec  4 11:57:44 iridium kernel: [<ffffffff810c6c55>] pipe_read+0x335/0x3ac
Dec  4 11:57:44 iridium kernel: [<ffffffff8114028d>] ? inode_has_perm+0x5b/0x61
Dec  4 11:57:44 iridium kernel: [<ffffffff810bfdcb>] do_sync_read+0xe7/0x12d
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff811429cf>] ? selinux_file_permission+0x43/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff81142a3b>] ? selinux_file_permission+0xaf/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff8113b85c>] ? security_file_permission+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff810c0748>] vfs_read+0xa8/0x102
Dec  4 11:57:44 iridium kernel: [<ffffffff810c0866>] sys_read+0x47/0x6e
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: gnome-pty-hel S 0000000000000000     0 19261  19258
Dec  4 11:57:44 iridium kernel: ffff880077dfdb38 0000000000000086 0000000000000000 ffff8801281a0018
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8801131a1710 ffff88012faa4530
Dec  4 11:57:44 iridium kernel: ffff8801131a1a88 000000012ad06800 ffff8801281a0018 ffff8801131a1a88
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff81122606>] ? journal_stop+0x1b2/0x1c1
Dec  4 11:57:44 iridium kernel: [<ffffffff813308b0>] schedule_timeout+0x22/0xb4
Dec  4 11:57:44 iridium kernel: [<ffffffff81055365>] ? prepare_to_wait+0x5c/0x65
Dec  4 11:57:44 iridium kernel: [<ffffffff81314c36>] unix_stream_recvmsg+0x304/0x612
Dec  4 11:57:44 iridium kernel: [<ffffffff8113e77f>] ? avc_has_perm+0x4e/0x60
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff812990fc>] __sock_recvmsg+0x6d/0x7a
Dec  4 11:57:44 iridium kernel: [<ffffffff812991f9>] sock_aio_read+0xf0/0x100
Dec  4 11:57:44 iridium kernel: [<ffffffff810bfdcb>] do_sync_read+0xe7/0x12d
Dec  4 11:57:44 iridium kernel: [<ffffffff81031023>] ? need_resched+0x1e/0x28
Dec  4 11:57:44 iridium kernel: [<ffffffff81055199>] ? autoremove_wake_function+0x0/0x38
Dec  4 11:57:44 iridium kernel: [<ffffffff81142a3b>] ? selinux_file_permission+0xaf/0xb8
Dec  4 11:57:44 iridium kernel: [<ffffffff8113b85c>] ? security_file_permission+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff810c075b>] vfs_read+0xbb/0x102
Dec  4 11:57:44 iridium kernel: [<ffffffff810c0866>] sys_read+0x47/0x6e
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: bash          S ffff88004dd35040     0 19262  19258
Dec  4 11:57:44 iridium kernel: ffff8800ad90fe68 0000000000000082 0000000000000002 0000043f000004a5
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800c7de4530 ffff8800c7cc4530
Dec  4 11:57:44 iridium kernel: ffff8800c7de48a8 0000000200000000 ffff8800ad90fdf8 ffff8800c7de48a8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8113baa9>] ? security_task_wait+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff81043cd6>] ? wait_consider_task+0x7d/0x92c
Dec  4 11:57:44 iridium kernel: [<ffffffff810447d5>] do_wait+0x250/0x343
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8104495e>] sys_wait4+0x96/0xb1
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: su            S 0000000000000000     0 19304  19262
Dec  4 11:57:44 iridium kernel: ffff880075b81e68 0000000000000082 0000000000000000 0000000000000092
Dec  4 11:57:44 iridium kernel: ffffffff816de500 ffffffff816de500 ffff8800c7cc4530 ffff88012fae2e20
Dec  4 11:57:44 iridium kernel: ffff8800c7cc48a8 0000000200000000 ffff880075b81df8 ffff8800c7cc48a8
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8113baa9>] ? security_task_wait+0x11/0x13
Dec  4 11:57:44 iridium kernel: [<ffffffff810447d5>] do_wait+0x250/0x343
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5b8>] ? default_wake_function+0x0/0xf
Dec  4 11:57:44 iridium kernel: [<ffffffff8104495e>] sys_wait4+0x96/0xb1
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: bash          R  running task        0 19311  19304
Dec  4 11:57:44 iridium kernel: 0000000000000002 0000000000000006 ffff8800c7d73cb8 ffffffff8116c74f
Dec  4 11:57:44 iridium kernel: 0000000400000002 0000000000000046 00000002c7d73b98 0000000000000400
Dec  4 11:57:44 iridium kernel: ffffffff817652c0 ffffffff817656c0 ffff8800c7d73bf8 ffffffff8103a5a6
Dec  4 11:57:44 iridium kernel: Call Trace:
Dec  4 11:57:44 iridium kernel: [<ffffffff8116c74f>] ? vsnprintf+0x56b/0x5bd
Dec  4 11:57:44 iridium kernel: [<ffffffff8103a5a6>] ? try_to_wake_up+0x26f/0x281
Dec  4 11:57:44 iridium kernel: [<ffffffff81331fe4>] ? _spin_unlock_irqrestore+0x27/0x3e
Dec  4 11:57:44 iridium kernel: [<ffffffff81331fe4>] ? _spin_unlock_irqrestore+0x27/0x3e
Dec  4 11:57:44 iridium kernel: [<ffffffff8132faf6>] ? printk+0x3c/0x3e
Dec  4 11:57:44 iridium kernel: [<ffffffff8132faf6>] ? printk+0x3c/0x3e
Dec  4 11:57:44 iridium kernel: [<ffffffff8132faf6>] ? printk+0x3c/0x3e
Dec  4 11:57:44 iridium kernel: [<ffffffff81011e46>] ? print_trace_address+0x39/0x3e
Dec  4 11:57:44 iridium kernel: [<ffffffff81053244>] ? __kernel_text_address+0x3d/0x48
Dec  4 11:57:44 iridium kernel: [<ffffffff81011f12>] ? print_context_stack+0xa8/0xc0
Dec  4 11:57:44 iridium kernel: [<ffffffff81012174>] ? dump_trace+0x24a/0x259
Dec  4 11:57:44 iridium kernel: [<ffffffff810121cc>] show_trace_log_lvl+0x49/0x63
Dec  4 11:57:44 iridium kernel: [<ffffffff810122cd>] show_stack_log_lvl+0xe7/0xf6
Dec  4 11:57:44 iridium kernel: [<ffffffff81012d24>] show_stack+0x17/0x19
Dec  4 11:57:44 iridium kernel: [<ffffffff8103cb38>] sched_show_task+0xa5/0xaa
Dec  4 11:57:44 iridium kernel: [<ffffffff8103cb8d>] show_state_filter+0x50/0x9b
Dec  4 11:57:44 iridium kernel: [<ffffffff811df462>] sysrq_handle_showstate+0xb/0xd
Dec  4 11:57:44 iridium kernel: [<ffffffff811df388>] __handle_sysrq+0xbb/0x158
Dec  4 11:57:44 iridium kernel: [<ffffffff8110753c>] ? write_sysrq_trigger+0x0/0x3d
Dec  4 11:57:44 iridium kernel: [<ffffffff8110756f>] write_sysrq_trigger+0x33/0x3d
Dec  4 11:57:44 iridium kernel: [<ffffffff81100b22>] proc_reg_write+0x89/0xa6
Dec  4 11:57:44 iridium kernel: [<ffffffff810c055a>] vfs_write+0xab/0x105
Dec  4 11:57:44 iridium kernel: [<ffffffff810c0678>] sys_write+0x47/0x6f
Dec  4 11:57:44 iridium kernel: [<ffffffff8101024a>] system_call_fastpath+0x16/0x1b
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: Sched Debug Version: v0.07, 2.6.27.5-117.fc10.x86_64 #1
Dec  4 11:57:44 iridium kernel: now at 68042855.958024 msecs
Dec  4 11:57:44 iridium kernel:  .sysctl_sched_latency                    : 60.000000
Dec  4 11:57:44 iridium kernel:  .sysctl_sched_min_granularity            : 12.000000
Dec  4 11:57:44 iridium kernel:  .sysctl_sched_wakeup_granularity         : 15.000000
Dec  4 11:57:44 iridium kernel:  .sysctl_sched_child_runs_first           : 0.000001
Dec  4 11:57:44 iridium kernel:  .sysctl_sched_features                   : 7807
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: cpu#0, 2400.074 MHz
Dec  4 11:57:44 iridium kernel:  .nr_running                    : 1
Dec  4 11:57:44 iridium kernel:  .load                          : 1024
Dec  4 11:57:44 iridium kernel:  .nr_switches                   : 21176546
Dec  4 11:57:44 iridium kernel:  .nr_load_updates               : 11142500
Dec  4 11:57:44 iridium kernel:  .nr_uninterruptible            : -28952
Dec  4 11:57:44 iridium kernel:  .jiffies                       : 4362710150
Dec  4 11:57:44 iridium kernel:  .next_balance                  : 4362.710364
Dec  4 11:57:44 iridium kernel:  .curr->pid                     : 3224
Dec  4 11:57:44 iridium kernel:  .clock                         : 68042855.479349
Dec  4 11:57:44 iridium kernel:  .cpu_load[0]                   : 1024
Dec  4 11:57:44 iridium kernel:  .cpu_load[1]                   : 1288
Dec  4 11:57:44 iridium kernel:  .cpu_load[2]                   : 2116
Dec  4 11:57:44 iridium kernel:  .cpu_load[3]                   : 2783
Dec  4 11:57:44 iridium kernel:  .cpu_load[4]                   : 2832
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: cfs_rq[0]:/
Dec  4 11:57:44 iridium kernel:  .exec_clock                    : 1677027.602223
Dec  4 11:57:44 iridium kernel:  .MIN_vruntime                  : 0.000001
Dec  4 11:57:44 iridium kernel:  .min_vruntime                  : 1174334.123729
Dec  4 11:57:44 iridium kernel:  .max_vruntime                  : 0.000001
Dec  4 11:57:44 iridium kernel:  .spread                        : 0.000000
Dec  4 11:57:44 iridium kernel:  .spread0                       : 0.000000
Dec  4 11:57:44 iridium kernel:  .nr_running                    : 2
Dec  4 11:57:44 iridium kernel:  .load                          : 2048
Dec  4 11:57:44 iridium kernel:  .yld_exp_empty                 : 0
Dec  4 11:57:44 iridium kernel:  .yld_act_empty                 : 0
Dec  4 11:57:44 iridium kernel:  .yld_both_empty                : 0
Dec  4 11:57:44 iridium kernel:  .yld_count                     : 1697861
Dec  4 11:57:44 iridium kernel:  .sched_switch                  : 0
Dec  4 11:57:44 iridium kernel:  .sched_count                   : 25346113
Dec  4 11:57:44 iridium kernel:  .sched_goidle                  : 9184999
Dec  4 11:57:44 iridium kernel:  .ttwu_count                    : 11645133
Dec  4 11:57:44 iridium kernel:  .ttwu_local                    : 10218949
Dec  4 11:57:44 iridium kernel:  .bkl_count                     : 302204
Dec  4 11:57:44 iridium kernel:  .nr_spread_over                : 53478
Dec  4 11:57:44 iridium kernel:  .shares                        : 0
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: rt_rq[0]:/
Dec  4 11:57:44 iridium kernel:  .rt_nr_running                 : 0
Dec  4 11:57:44 iridium kernel:  .rt_throttled                  : 0
Dec  4 11:57:44 iridium kernel:  .rt_time                       : 0.000000
Dec  4 11:57:44 iridium kernel:  .rt_runtime                    : 950.000000
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: runnable tasks:
Dec  4 11:57:44 iridium kernel:            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Dec  4 11:57:44 iridium kernel: ----------------------------------------------------------------------------------------------------------
Dec  4 11:57:44 iridium kernel: R           Xorg  3224   1174332.702474   6938776   120   1174332.702474   1462080.053817  65364590.724448 /
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: cpu#1, 2400.074 MHz
Dec  4 11:57:44 iridium kernel:  .nr_running                    : 3
Dec  4 11:57:44 iridium kernel:  .load                          : 3072
Dec  4 11:57:44 iridium kernel:  .nr_switches                   : 14394345
Dec  4 11:57:44 iridium kernel:  .nr_load_updates               : 7440577
Dec  4 11:57:44 iridium kernel:  .nr_uninterruptible            : -5047
Dec  4 11:57:44 iridium kernel:  .jiffies                       : 4362710150
Dec  4 11:57:44 iridium kernel:  .next_balance                  : 4362.710364
Dec  4 11:57:44 iridium kernel:  .curr->pid                     : 2270
Dec  4 11:57:44 iridium kernel:  .clock                         : 68042856.126997
Dec  4 11:57:44 iridium kernel:  .cpu_load[0]                   : 3072
Dec  4 11:57:44 iridium kernel:  .cpu_load[1]                   : 2751
Dec  4 11:57:44 iridium kernel:  .cpu_load[2]                   : 2114
Dec  4 11:57:44 iridium kernel:  .cpu_load[3]                   : 1492
Dec  4 11:57:44 iridium kernel:  .cpu_load[4]                   : 997
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: cfs_rq[1]:/
Dec  4 11:57:44 iridium kernel:  .exec_clock                    : 1608077.781240
Dec  4 11:57:44 iridium kernel:  .MIN_vruntime                  : 1320928.265178
Dec  4 11:57:44 iridium kernel:  .min_vruntime                  : 1321043.356110
Dec  4 11:57:44 iridium kernel:  .max_vruntime                  : 1320983.571498
Dec  4 11:57:44 iridium kernel:  .spread                        : 55.306320
Dec  4 11:57:44 iridium kernel:  .spread0                       : 146709.232381
Dec  4 11:57:44 iridium kernel:  .nr_running                    : 3
Dec  4 11:57:44 iridium kernel:  .load                          : 3072
Dec  4 11:57:44 iridium kernel:  .yld_exp_empty                 : 0
Dec  4 11:57:44 iridium kernel:  .yld_act_empty                 : 0
Dec  4 11:57:44 iridium kernel:  .yld_both_empty                : 0
Dec  4 11:57:44 iridium kernel:  .yld_count                     : 1731929
Dec  4 11:57:44 iridium kernel:  .sched_switch                  : 0
Dec  4 11:57:44 iridium kernel:  .sched_count                   : 17151400
Dec  4 11:57:44 iridium kernel:  .sched_goidle                  : 4952504
Dec  4 11:57:44 iridium kernel:  .ttwu_count                    : 8008979
Dec  4 11:57:44 iridium kernel:  .ttwu_local                    : 6785065
Dec  4 11:57:44 iridium kernel:  .bkl_count                     : 116975
Dec  4 11:57:44 iridium kernel:  .nr_spread_over                : 71329
Dec  4 11:57:44 iridium kernel:  .shares                        : 0
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: rt_rq[1]:/
Dec  4 11:57:44 iridium kernel:  .rt_nr_running                 : 0
Dec  4 11:57:44 iridium kernel:  .rt_throttled                  : 0
Dec  4 11:57:44 iridium kernel:  .rt_time                       : 0.000000
Dec  4 11:57:44 iridium kernel:  .rt_runtime                    : 950.000000
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: runnable tasks:
Dec  4 11:57:44 iridium kernel:            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Dec  4 11:57:44 iridium kernel: ----------------------------------------------------------------------------------------------------------
Dec  4 11:57:44 iridium kernel: R       rsyslogd  2270   1320986.481355       163   120   1320986.481355        57.549279  68004537.624366 /
Dec  4 11:57:44 iridium kernel:        rsyslogd 19308   1320928.265178         3   120   1320928.265178         4.928484      7453.806431 /
Dec  4 11:57:44 iridium kernel:       rhythmbox 17616   1320983.571498     69131   120   1320983.571498      6629.496603   2734415.166312 /
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: cpu#2, 2400.074 MHz
Dec  4 11:57:44 iridium kernel:  .nr_running                    : 2
Dec  4 11:57:44 iridium kernel:  .load                          : 2048
Dec  4 11:57:44 iridium kernel:  .nr_switches                   : 22720374
Dec  4 11:57:44 iridium kernel:  .nr_load_updates               : 12203675
Dec  4 11:57:44 iridium kernel:  .nr_uninterruptible            : 11747
Dec  4 11:57:44 iridium kernel:  .jiffies                       : 4362710150
Dec  4 11:57:44 iridium kernel:  .next_balance                  : 4362.710174
Dec  4 11:57:44 iridium kernel:  .curr->pid                     : 19311
Dec  4 11:57:44 iridium kernel:  .clock                         : 68042847.365316
Dec  4 11:57:44 iridium kernel:  .cpu_load[0]                   : 0
Dec  4 11:57:44 iridium kernel:  .cpu_load[1]                   : 4
Dec  4 11:57:44 iridium kernel:  .cpu_load[2]                   : 33
Dec  4 11:57:44 iridium kernel:  .cpu_load[3]                   : 54
Dec  4 11:57:44 iridium kernel:  .cpu_load[4]                   : 60
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: cfs_rq[2]:/
Dec  4 11:57:44 iridium kernel:  .exec_clock                    : 2123453.364280
Dec  4 11:57:44 iridium kernel:  .MIN_vruntime                  : 2513177.241533
Dec  4 11:57:44 iridium kernel:  .min_vruntime                  : 2513225.872763
Dec  4 11:57:44 iridium kernel:  .max_vruntime                  : 2513177.241533
Dec  4 11:57:44 iridium kernel:  .spread                        : 0.000000
Dec  4 11:57:44 iridium kernel:  .spread0                       : 1338891.749034
Dec  4 11:57:44 iridium kernel:  .nr_running                    : 2
Dec  4 11:57:44 iridium kernel:  .load                          : 2048
Dec  4 11:57:44 iridium kernel:  .yld_exp_empty                 : 0
Dec  4 11:57:44 iridium kernel:  .yld_act_empty                 : 0
Dec  4 11:57:44 iridium kernel:  .yld_both_empty                : 0
Dec  4 11:57:44 iridium kernel:  .yld_count                     : 2002639
Dec  4 11:57:44 iridium kernel:  .sched_switch                  : 0
Dec  4 11:57:44 iridium kernel:  .sched_count                   : 25242063
Dec  4 11:57:44 iridium kernel:  .sched_goidle                  : 8741723
Dec  4 11:57:44 iridium kernel:  .ttwu_count                    : 12164897
Dec  4 11:57:44 iridium kernel:  .ttwu_local                    : 11118203
Dec  4 11:57:44 iridium kernel:  .bkl_count                     : 125302
Dec  4 11:57:44 iridium kernel:  .nr_spread_over                : 116402
Dec  4 11:57:44 iridium kernel:  .shares                        : 0
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: rt_rq[2]:/
Dec  4 11:57:44 iridium kernel:  .rt_nr_running                 : 0
Dec  4 11:57:44 iridium kernel:  .rt_throttled                  : 0
Dec  4 11:57:44 iridium kernel:  .rt_time                       : 0.000000
Dec  4 11:57:44 iridium kernel:  .rt_runtime                    : 950.000000
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: runnable tasks:
Dec  4 11:57:44 iridium kernel:            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Dec  4 11:57:44 iridium kernel: ----------------------------------------------------------------------------------------------------------
Dec  4 11:57:44 iridium kernel:       rhythmbox  4219   2513177.241533    698514   120   2513177.241533     77684.584367  67425617.012588 /
Dec  4 11:57:44 iridium kernel: R           bash 19311   2513231.349399        79   120   2513231.349399        57.392607      7265.986691 /
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: cpu#3, 2400.074 MHz
Dec  4 11:57:44 iridium kernel:  .nr_running                    : 0
Dec  4 11:57:44 iridium kernel:  .load                          : 0
Dec  4 11:57:44 iridium kernel:  .nr_switches                   : 14410292
Dec  4 11:57:44 iridium kernel:  .nr_load_updates               : 6604591
Dec  4 11:57:44 iridium kernel:  .nr_uninterruptible            : 22252
Dec  4 11:57:44 iridium kernel:  .jiffies                       : 4362710150
Dec  4 11:57:44 iridium kernel:  .next_balance                  : 4362.709586
Dec  4 11:57:44 iridium kernel:  .curr->pid                     : 0
Dec  4 11:57:44 iridium kernel:  .clock                         : 68042854.623177
Dec  4 11:57:44 iridium kernel:  .cpu_load[0]                   : 2048
Dec  4 11:57:44 iridium kernel:  .cpu_load[1]                   : 1280
Dec  4 11:57:44 iridium kernel:  .cpu_load[2]                   : 800
Dec  4 11:57:44 iridium kernel:  .cpu_load[3]                   : 452
Dec  4 11:57:44 iridium kernel:  .cpu_load[4]                   : 246
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: cfs_rq[3]:/
Dec  4 11:57:44 iridium kernel:  .exec_clock                    : 1368787.116980
Dec  4 11:57:44 iridium kernel:  .MIN_vruntime                  : 0.000001
Dec  4 11:57:44 iridium kernel:  .min_vruntime                  : 1912037.642712
Dec  4 11:57:44 iridium kernel:  .max_vruntime                  : 0.000001
Dec  4 11:57:44 iridium kernel:  .spread                        : 0.000000
Dec  4 11:57:44 iridium kernel:  .spread0                       : 737703.518983
Dec  4 11:57:44 iridium kernel:  .nr_running                    : 0
Dec  4 11:57:44 iridium kernel:  .load                          : 0
Dec  4 11:57:44 iridium kernel:  .yld_exp_empty                 : 0
Dec  4 11:57:44 iridium kernel:  .yld_act_empty                 : 0
Dec  4 11:57:44 iridium kernel:  .yld_both_empty                : 0
Dec  4 11:57:44 iridium kernel:  .yld_count                     : 1921520
Dec  4 11:57:44 iridium kernel:  .sched_switch                  : 0
Dec  4 11:57:44 iridium kernel:  .sched_count                   : 16802701
Dec  4 11:57:44 iridium kernel:  .sched_goidle                  : 4780339
Dec  4 11:57:44 iridium kernel:  .ttwu_count                    : 8039512
Dec  4 11:57:44 iridium kernel:  .ttwu_local                    : 6800175
Dec  4 11:57:44 iridium kernel:  .bkl_count                     : 255773
Dec  4 11:57:44 iridium kernel:  .nr_spread_over                : 55584
Dec  4 11:57:44 iridium kernel:  .shares                        : 0
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: rt_rq[3]:/
Dec  4 11:57:44 iridium kernel:  .rt_nr_running                 : 0
Dec  4 11:57:44 iridium kernel:  .rt_throttled                  : 0
Dec  4 11:57:44 iridium kernel:  .rt_time                       : 0.000000
Dec  4 11:57:44 iridium kernel:  .rt_runtime                    : 950.000000
Dec  4 11:57:44 iridium kernel:
Dec  4 11:57:44 iridium kernel: runnable tasks:
Dec  4 11:57:44 iridium kernel:            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Dec  4 11:57:44 iridium kernel: ----------------------------------------------------------------------------------------------------------

--------------060401060004010601090703--
