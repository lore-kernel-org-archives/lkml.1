Return-Path: <linux-kernel-owner+w=401wt.eu-S932268AbYDVJE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268AbYDVJE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 05:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762598AbYDVJEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 05:04:42 -0400
Received: from po-out-1718.google.com ([72.14.252.154]:45843 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762586AbYDVJEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 05:04:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=W8UdwFH06PVk1BnLZ79za4Aa9GzCoWq96GaYJj574GMBuxLyChqjtlQPWO/zSB/4vZtW+q98LiuNxig0+SwA3OvYAmjm0OR/B6JgAKETN7kDM9SSxLJy0LI3osgoF9dD6De+qxPVG5qCADfBP9Q3S0aQT2IoB9RRZT0LQVZuTtE=
Message-ID: <c4e36d110804220204h3043e526xee3966876355cde0@mail.gmail.com>
Date: Tue, 22 Apr 2008 11:04:38 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: WARNING: at arch/x86/kernel/genapic_64.c:86
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I've update to the current commit 2.6.25
8a81f2738f10ca817c975cec893aa58497e873b2

I get this boot WARNING:

 tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
------------[ cut here ]------------
WARNING: at arch/x86/kernel/genapic_64.c:86 read_apic_id+0x81/0x90()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.25 #57

Call Trace:
 [<ffffffff8103d64f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff81062afa>] ? get_lock_stats+0x2a/0x70
 [<ffffffff81062b4e>] ? put_lock_stats+0xe/0x30
 [<ffffffff81038b56>] ? set_cpus_allowed_ptr+0x86/0x120
 [<ffffffff812ee295>] ? _spin_unlock_irqrestore+0x65/0x90
 [<ffffffff810649e1>] ? trace_hardirqs_on+0x131/0x190
 [<ffffffff812ee275>] ? _spin_unlock_irqrestore+0x45/0x90
 [<ffffffff810233f1>] read_apic_id+0x81/0x90
 [<ffffffff814bdcde>] verify_local_APIC+0xc4/0x186
 [<ffffffff814bcaaf>] native_smp_prepare_cpus+0x16e/0x38f
 [<ffffffff814b139b>] kernel_init+0x5a/0x31b
 [<ffffffff810649e1>] ? trace_hardirqs_on+0x131/0x190
 [<ffffffff812ee1ed>] ? _spin_unlock_irq+0x3d/0x80
 [<ffffffff812edbd9>] ? trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff810649e1>] ? trace_hardirqs_on+0x131/0x190
 [<ffffffff8100d548>] child_rip+0xa/0x12
 [<ffffffff8100cc33>] ? restore_args+0x0/0x30
 [<ffffffff814b1341>] ? kernel_init+0x0/0x31b
 [<ffffffff8100d53e>] ? child_rip+0x0/0x12

---[ end trace ca143223eefdc828 ]---
------------[ cut here ]------------
WARNING: at arch/x86/kernel/genapic_64.c:86 read_apic_id+0x81/0x90()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.25 #57

Call Trace:
 [<ffffffff8103d64f>] warn_on_slowpath+0x5f/0x90
 [<ffffffff81062afa>] ? get_lock_stats+0x2a/0x70
 [<ffffffff81062b4e>] ? put_lock_stats+0xe/0x30
 [<ffffffff81038b56>] ? set_cpus_allowed_ptr+0x86/0x120
 [<ffffffff812ee295>] ? _spin_unlock_irqrestore+0x65/0x90
 [<ffffffff810649e1>] ? trace_hardirqs_on+0x131/0x190
 [<ffffffff812ee275>] ? _spin_unlock_irqrestore+0x45/0x90
 [<ffffffff810233f1>] read_apic_id+0x81/0x90
 [<ffffffff814bdd00>] verify_local_APIC+0xe6/0x186
 [<ffffffff814bcaaf>] native_smp_prepare_cpus+0x16e/0x38f
 [<ffffffff814b139b>] kernel_init+0x5a/0x31b
 [<ffffffff810649e1>] ? trace_hardirqs_on+0x131/0x190
 [<ffffffff812ee1ed>] ? _spin_unlock_irq+0x3d/0x80
 [<ffffffff812edbd9>] ? trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff810649e1>] ? trace_hardirqs_on+0x131/0x190
 [<ffffffff8100d548>] child_rip+0xa/0x12
 [<ffffffff8100cc33>] ? restore_args+0x0/0x30
 [<ffffffff814b1341>] ? kernel_init+0x0/0x31b
 [<ffffffff8100d53e>] ? child_rip+0x0/0x12

---[ end trace ca143223eefdc828 ]---
CPU0: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0a
Using local APIC timer interrupts.



Zdenek
