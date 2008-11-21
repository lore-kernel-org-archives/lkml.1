Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbYKUKX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbYKUKX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 05:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbYKUKXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 05:23:48 -0500
Received: from an-out-0708.google.com ([209.85.132.240]:47381 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbYKUKXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 05:23:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=QnqZR800jJsOSzYJVLMf4iO3MVP4dArdMd0WNrK6DXw8Wnd+r1I6zEyWwmMwddOqSN
         rDl0cWdy1EeLjmIXjaOQec3GcIVvHhZFRMQ0ENdrf/9SWASnqy0ivD9erdNkdTvCaKht
         v7Ddo1FA3XJ1128IXyDdbVe/0Rf091JtEaTk0=
Message-ID: <a4423d670811210223j53883165mb6651d8fa1bef95f@mail.gmail.com>
Date: Fri, 21 Nov 2008 13:23:45 +0300
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       vojtech@suse.cz, tglx@linutronix.de
Subject: next-20081121: WARNING: at lib/debugobjects.c: hpet
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

It is x86_64 SMP

hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
ODEBUG: object is on stack, but not annotated
------------[ cut here ]------------
WARNING: at lib/debugobjects.c:251 __debug_object_init+0x2bf/0x36d()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.28-rc5-next-20081121 #8
Call Trace:
 [<ffffffff80236bfb>] warn_on_slowpath+0x58/0x7d
 [<ffffffff804e3405>] ? printk+0x67/0x6a
 [<ffffffff803803cc>] ? __debug_object_init+0x191/0x36d
 [<ffffffff803804fa>] __debug_object_init+0x2bf/0x36d
 [<ffffffff80297856>] ? compound_order+0x15/0x26
 [<ffffffff803805d5>] debug_object_init+0x14/0x17
 [<ffffffff8023fcbf>] init_timer+0x18/0x5b
 [<ffffffff8022087d>] hpet_cpuhp_notify+0x93/0x105
 [<ffffffff802209b6>] ? hpet_work+0x0/0x206
 [<ffffffff803d1ae8>] ? hpet_alloc+0x333/0x38f
 [<ffffffff802577cd>] ? trace_hardirqs_on_caller+0x128/0x153
 [<ffffffff80257805>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff806d15f5>] ? hpet_late_init+0x0/0x19e
 [<ffffffff806d15f5>] ? hpet_late_init+0x0/0x19e
 [<ffffffff806d175f>] hpet_late_init+0x16a/0x19e
 [<ffffffff806cf7c2>] ? print_all_ICs+0x0/0x540
 [<ffffffff80209058>] _stext+0x58/0x138
 [<ffffffff804e5e83>] ? _spin_unlock+0x4a/0x57
 [<ffffffff802de3c4>] ? proc_register+0x10b/0x118
 [<ffffffff802de4f9>] ? create_proc_entry+0x7e/0x94
 [<ffffffff80268745>] ? register_irq_proc+0xb0/0xcc
 [<ffffffff802d0000>] ? do_usbdevfs_discsignal+0x20/0x84
 [<ffffffff806c666d>] kernel_init+0x125/0x179
 [<ffffffff804e583a>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8020c8a9>] child_rip+0xa/0x11
 [<ffffffff8020bd98>] ? restore_args+0x0/0x30
 [<ffffffff806c6548>] ? kernel_init+0x0/0x179
 [<ffffffff8020c89f>] ? child_rip+0x0/0x11
---[ end trace 4eaa2a86a8e2da22 ]---
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 3
Switched to high resolution mode on CPU 2
Switched to high resolution mode on CPU 1
