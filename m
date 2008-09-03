Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbYICSLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbYICSLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 14:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbYICSLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 14:11:17 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:14970 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbYICSLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 14:11:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=pU1E7VxPSOfg1MkGr4zNtjn5baaCQ23SUFRAytKeyht9njJOjlWndYC/OilUxVbfbx
         F1m3Wv8DYdJcXi8rOgExd93lM/xvhVpGcZafieXhKc0nDizQyEksCPDQHknQYIKLB/ym
         vj+F67MkXdmFZI2lwtNIVsihVPsI5OJ7qGT8E=
Message-ID: <dd18b0c30809031111v3669fe38q1333975cacde8054@mail.gmail.com>
Date: Wed, 3 Sep 2008 11:11:13 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [ 0.618502] WARNING: at drivers/misc/kgdbts.c:302 check_and_rewind_pc+0x9a/0xb4()
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've a macbook and a dell inspiron,(don't see any serial plugins);
but wanted to see if there is any way to use this debugger i.g.
usb, or anything, if not oh well.
when configuring kgdb I just said "y" to all of the options.
When booting, using kgdboc=off (not sure if this is correct or not);
lets me boot into  the system, or else freeze.
under dmesg I see this:

[    0.618288] ------------[ cut here ]------------
[    0.618502] WARNING: at drivers/misc/kgdbts.c:302
check_and_rewind_pc+0x9a/0xb4()
[    0.618845] Modules linked in:
[    0.619000] Pid: 1, comm: swapper Not tainted 2.6.27-rc5-00006-gbef69ea #15
[    0.619321]  [<c0123dd6>] warn_on_slowpath+0x41/0x65
[    0.619568]  [<c0124313>] ? release_console_sem+0x185/0x18d
[    0.619849]  [<c0111f94>] ? kgdb_correct_hw_break+0x13/0xc7
[    0.622511]  [<c03a091b>] ? notifier_call_chain+0x2b/0x4a
[    0.622511]  [<c03a094b>] ? __atomic_notifier_call_chain+0x11/0x13
[    0.622511]  [<c028bd4e>] ? kgdbts_break_test+0x0/0x1e
[    0.622511]  [<c01247b5>] ? printk+0x15/0x17
[    0.622511]  [<c028bd4e>] ? kgdbts_break_test+0x0/0x1e
[    0.622511]  [<c028c882>] check_and_rewind_pc+0x9a/0xb4
[    0.622511]  [<c0150b89>] ? kgdb_breakpoint+0x13/0x24
[    0.622511]  [<c028bd4e>] ? kgdbts_break_test+0x0/0x1e
[    0.622511]  [<c028ba32>] validate_simple_test+0x22/0x69
[    0.622511]  [<c028c0f0>] run_simple_test+0x1a1/0x20e
[    0.622511]  [<c028bacd>] kgdbts_put_char+0x14/0x16
[    0.622511]  [<c01509f2>] put_packet+0x6b/0xbb
[    0.622511]  [<c0151dd0>] kgdb_handle_exception+0xba5/0xc6d
[    0.622511]  [<c01123ad>] kgdb_notify+0x139/0x160
[    0.622511]  [<c03a091b>] notifier_call_chain+0x2b/0x4a
[    0.622511]  [<c03a094b>] __atomic_notifier_call_chain+0x11/0x13
[    0.622511]  [<c03a0959>] atomic_notifier_call_chain+0xc/0xe
[    0.622511]  [<c01371fa>] notify_die+0x2d/0x2f
[    0.622511]  [<c039f45a>] do_int3+0x29/0x67
[    0.622511]  [<c039ee4b>] int3+0x27/0x2c
[    0.622511]  [<c0150b89>] ? kgdb_breakpoint+0x13/0x24
[    0.622511]  [<c028c4d4>] configure_kgdbts+0x1ba/0x404
[    0.622511]  [<c0524413>] init_kgdbts+0x13/0x15
[    0.622511]  [<c0101125>] _stext+0x3d/0x129
[    0.622511]  [<c0524400>] ? init_kgdbts+0x0/0x15
[    0.622511]  [<c0153da6>] ? register_irq_proc+0x9c/0xb5
[    0.622511]  [<c0153de7>] ? init_irq_proc+0x28/0x33
[    0.622511]  [<c050a512>] kernel_init+0xf9/0x147
[    0.622511]  [<c050a419>] ? kernel_init+0x0/0x147
[    0.622511]  [<c0103cbf>] kernel_thread_helper+0x7/0x10
[    0.622511]  =======================
[    0.622511] ---[ end trace 1534190084874a32 ]---
[    0.622511] kgdbts: ERROR PUT: end of test buffer on
'singlestep_breakpoint_test' line 3 expected kgdbts_break_test got
$000000000000000046000000ab00000064ff84f740ff84f7e803000000000000
[    0.622511] ------------[ cut here ]------------
[    0.622511] WARNING: at drivers/misc/kgdbts.c:721
run_simple_test+0x1de/0x20e()
[    0.622511] Modules linked in:
[    0.622511] Pid: 1, comm: swapper Tainted: G        W
2.6.27-rc5-00006-gbef69ea #15
[    0.622511]  [<c0123dd6>] warn_on_slowpath+0x41/0x65
[    0.622511]  [<c0124313>] ? release_console_sem+0x185/0x18d
[    0.622511]  [<c03a094b>] ? __atomic_notifier_call_chain+0x11/0x13
[    0.622511]  [<c028bd4e>] ? kgdbts_break_test+0x0/0x1e
[    0.622511]  [<c01247b5>] ? printk+0x15/0x17
[    0.622511]  [<c01247b5>] ? printk+0x15/0x17
[    0.622511]  [<c028c12d>] run_simple_test+0x1de/0x20e
[    0.622511]  [<c028bacd>] kgdbts_put_char+0x14/0x16
[    0.622511]  [<c01509f2>] put_packet+0x6b/0xbb
[    0.622511]  [<c0151dd0>] kgdb_handle_exception+0xba5/0xc6d
[    0.622511]  [<c01123ad>] kgdb_notify+0x139/0x160
[    0.622511]  [<c03a091b>] notifier_call_chain+0x2b/0x4a
[    0.622511]  [<c03a094b>] __atomic_notifier_call_chain+0x11/0x13
[    0.622511]  [<c03a0959>] atomic_notifier_call_chain+0xc/0xe
[    0.622511]  [<c01371fa>] notify_die+0x2d/0x2f
[    0.622511]  [<c039f45a>] do_int3+0x29/0x67
[    0.622511]  [<c039ee4b>] int3+0x27/0x2c
[    0.622511]  [<c0150b89>] ? kgdb_breakpoint+0x13/0x24
[    0.622511]  [<c028c4d4>] configure_kgdbts+0x1ba/0x404
[    0.622511]  [<c0524413>] init_kgdbts+0x13/0x15
[    0.622511]  [<c0101125>] _stext+0x3d/0x129
[    0.622511]  [<c0524400>] ? init_kgdbts+0x0/0x15
[    0.622511]  [<c0153da6>] ? register_irq_proc+0x9c/0xb5
[    0.622511]  [<c0153de7>] ? init_irq_proc+0x28/0x33
[    0.622511]  [<c050a512>] kernel_init+0xf9/0x147
[    0.622511]  [<c050a419>] ? kernel_init+0x0/0x147
[    0.622511]  [<c0103cbf>] kernel_thread_helper+0x7/0x10
[    0.622511]  =======================
[    0.622511] ---[ end trace 1534190084874a32 ]---

If anybody has any ideas on how
I can use this debugger it would be appreciated.

regards;


-- 
Justin P. Mattock
