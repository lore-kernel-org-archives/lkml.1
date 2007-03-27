Return-Path: <linux-kernel-owner+w=401wt.eu-S934145AbXC0Sxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934145AbXC0Sxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 14:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934175AbXC0Sxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 14:53:51 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:53293 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934145AbXC0Sxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 14:53:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=iIJJJKg4X4STba4Rx7T3ZJttLwDOTxJRfwynOBUZRv4ASzAHK+JsKR1FY4F+5tjIfLvii/wE9R+nI7YJaApFWVDHgCDhHn1wQCmjNzDzBCjf3j93eY3vI8oVLPmoMYc5MeYIzlXYQDIa3Ysp2ovG8RFMsVobM17GWM6qmy7LYZk=
Message-ID: <46096834.5050508@googlemail.com>
Date: Tue, 27 Mar 2007 20:53:40 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: Linux 2.6.21-rc5
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds napisał(a):
> There's various fixes here, ranging from some architecture updates (ia64, 
> ARM, MIPS, SH, Sparc64) to KVM, networking and network drivers.
> 
> And random one-liners.
> 

I found this in mm snapshot
http://www.ussg.iu.edu/hypermail/linux/kernel/0703.2/1367.html
it's in mainline too.

Andi, any progress with this bug?

BUG: using smp_processor_id() in preemptible [00000001] code: mount/7245
caller is avail_to_resrv_perfctr_nmi_bit+0x1a/0x32
 [<c0105039>] show_trace_log_lvl+0x1a/0x2f
 [<c0105720>] show_trace+0x12/0x14
 [<c01057d2>] dump_stack+0x16/0x18
 [<c01f911e>] debug_smp_processor_id+0xa2/0xb4
 [<c0115832>] avail_to_resrv_perfctr_nmi_bit+0x1a/0x32
 [<fdca69b5>] nmi_create_files+0x2a/0x10e [oprofile]
 [<fdca5f4e>] oprofile_create_files+0xe6/0xec [oprofile]
 [<fdca6153>] oprofilefs_fill_super+0x78/0x7e [oprofile]
 [<c0173516>] get_sb_single+0x46/0x8c
 [<fdca608b>] oprofilefs_get_sb+0x1c/0x1e [oprofile]
 [<c0173406>] vfs_kern_mount+0x81/0xf1
 [<c01734be>] do_kern_mount+0x30/0x42
 [<c0185be9>] do_mount+0x601/0x678
 [<c0185ccf>] sys_mount+0x6f/0xa4
 [<c0104060>] syscall_call+0x7/0xb
 =======================
BUG: using smp_processor_id() in preemptible [00000001] code: mount/7245
caller is avail_to_resrv_perfctr_nmi_bit+0x1a/0x32
 [<c0105039>] show_trace_log_lvl+0x1a/0x2f
 [<c0105720>] show_trace+0x12/0x14
 [<c01057d2>] dump_stack+0x16/0x18
 [<c01f911e>] debug_smp_processor_id+0xa2/0xb4
 [<c0115832>] avail_to_resrv_perfctr_nmi_bit+0x1a/0x32
 [<fdca69b5>] nmi_create_files+0x2a/0x10e [oprofile]
 [<fdca5f4e>] oprofile_create_files+0xe6/0xec [oprofile]
 [<fdca6153>] oprofilefs_fill_super+0x78/0x7e [oprofile]
 [<c0173516>] get_sb_single+0x46/0x8c
 [<fdca608b>] oprofilefs_get_sb+0x1c/0x1e [oprofile]
 [<c0173406>] vfs_kern_mount+0x81/0xf1
 [<c01734be>] do_kern_mount+0x30/0x42
 [<c0185be9>] do_mount+0x601/0x678
 [<c0185ccf>] sys_mount+0x6f/0xa4
 [<c0104060>] syscall_call+0x7/0xb
 =======================
BUG: using smp_processor_id() in preemptible [00000001] code: mount/7245
caller is avail_to_resrv_perfctr_nmi_bit+0x1a/0x32
 [<c0105039>] show_trace_log_lvl+0x1a/0x2f
 [<c0105720>] show_trace+0x12/0x14
 [<c01057d2>] dump_stack+0x16/0x18
 [<c01f911e>] debug_smp_processor_id+0xa2/0xb4
 [<c0115832>] avail_to_resrv_perfctr_nmi_bit+0x1a/0x32
 [<fdca69b5>] nmi_create_files+0x2a/0x10e [oprofile]
 [<fdca5f4e>] oprofile_create_files+0xe6/0xec [oprofile]
 [<fdca6153>] oprofilefs_fill_super+0x78/0x7e [oprofile]
 [<c0173516>] get_sb_single+0x46/0x8c
 [<fdca608b>] oprofilefs_get_sb+0x1c/0x1e [oprofile]
 [<c0173406>] vfs_kern_mount+0x81/0xf1
 [<c01734be>] do_kern_mount+0x30/0x42
 [<c0185be9>] do_mount+0x601/0x678
 [<c0185ccf>] sys_mount+0x6f/0xa4
 [<c0104060>] syscall_call+0x7/0xb
 =======================
BUG: using smp_processor_id() in preemptible [00000001] code: mount/7245
caller is avail_to_resrv_perfctr_nmi_bit+0x1a/0x32
 [<c0105039>] show_trace_log_lvl+0x1a/0x2f
 [<c0105720>] show_trace+0x12/0x14
 [<c01057d2>] dump_stack+0x16/0x18
 [<c01f911e>] debug_smp_processor_id+0xa2/0xb4
 [<c0115832>] avail_to_resrv_perfctr_nmi_bit+0x1a/0x32
 [<fdca69b5>] nmi_create_files+0x2a/0x10e [oprofile]
 [<fdca5f4e>] oprofile_create_files+0xe6/0xec [oprofile]
 [<fdca6153>] oprofilefs_fill_super+0x78/0x7e [oprofile]
 [<c0173516>] get_sb_single+0x46/0x8c
 [<fdca608b>] oprofilefs_get_sb+0x1c/0x1e [oprofile]
 [<c0173406>] vfs_kern_mount+0x81/0xf1
 [<c01734be>] do_kern_mount+0x30/0x42
 [<c0185be9>] do_mount+0x601/0x678
 [<c0185ccf>] sys_mount+0x6f/0xa4
 [<c0104060>] syscall_call+0x7/0xb
 =======================
SELinux: initialized (dev oprofilefs, type oprofilefs), uses genfs_contexts

=================================
[ INFO: inconsistent lock state ]
2.6.21-rc5-gd4590940-dirty #128
---------------------------------
inconsistent {hardirq-on-W} -> {in-hardirq-W} usage.
firefox-bin/3542 [HC1[1]:SC0[0]:HE0:SE1] takes:
 (oprofilefs_lock){+-..}, at: [<fdca6b6a>] nmi_cpu_setup+0x15/0x4f [oprofile]
{hardirq-on-W} state was registered at:
  [<c013d338>] __lock_acquire+0x442/0xba1
  [<c013daff>] lock_acquire+0x68/0x82
  [<c031a947>] _spin_lock+0x35/0x42
  [<fdca6343>] oprofilefs_ulong_from_user+0x4e/0x74 [oprofile]
  [<fdca6393>] ulong_write_file+0x2a/0x38 [oprofile]
  [<c0171d13>] vfs_write+0xaf/0x138
  [<c01722dd>] sys_write+0x3d/0x61
  [<c0104060>] syscall_call+0x7/0xb
  [<ffffffff>] 0xffffffff
irq event stamp: 50464270
hardirqs last  enabled at (50464269): [<c0104189>] syscall_exit_work+0x11/0x26
hardirqs last disabled at (50464270): [<c0104ae9>] call_function_interrupt+0x29/0x38
softirqs last  enabled at (50462522): [<c012653b>] __do_softirq+0xe4/0xea
softirqs last disabled at (50462515): [<c01069b5>] do_softirq+0x64/0xd1

other info that might help us debug this:
no locks held by firefox-bin/3542.

stack backtrace:
 [<c0105039>] show_trace_log_lvl+0x1a/0x2f
 [<c0105720>] show_trace+0x12/0x14
 [<c01057d2>] dump_stack+0x16/0x18
 [<c013bd13>] print_usage_bug+0x140/0x14a
 [<c013c51e>] mark_lock+0xa1/0x40b
 [<c013d2a9>] __lock_acquire+0x3b3/0xba1
 [<c013daff>] lock_acquire+0x68/0x82
 [<c031a947>] _spin_lock+0x35/0x42
 [<fdca6b6a>] nmi_cpu_setup+0x15/0x4f [oprofile]
 [<c0112a61>] smp_call_function_interrupt+0x3a/0x56
 [<c0104af3>] call_function_interrupt+0x33/0x38
 =======================

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc5/git-config2
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc5/git-dmesg

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
