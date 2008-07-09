Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbYGIRiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbYGIRiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 13:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbYGIRin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 13:38:43 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:51114 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbYGIRim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 13:38:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Pr7pGAWgIq/ThQBOvBmsgdI8SyFnZVuwWg1kNUt+JE8sFb0OmEPLiR1mjSqpsgZ4iy
         9QpgK4Y/lJpxBkmbxkb1B25mkKoIiOaW3XQtCdkn2HUeapwjGjKcrY3SjiwHqxhhX6wI
         3wXVvzqwkOtio7Sk0C7iDfUpHQl3smVoYgZLk=
Message-ID: <86802c440807091038m6c14f165xede8b2b0316d0225@mail.gmail.com>
Date: Wed, 9 Jul 2008 10:38:41 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: akataria@vmware.com
Subject: Re: [PATCH 05/05] x86: Rename paravirtualized TSC functions
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Daniel Hecht" <dhecht@vmware.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1215624603.3930.8.camel@alok-dev1>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214937816.20191.34.camel@promb-2n-dhcp368.eng.vmware.com>
	 <20080709061336.GG9760@elte.hu>
	 <86802c440807090020q516b6332qf8e0d65918e7001e@mail.gmail.com>
	 <1215624603.3930.8.camel@alok-dev1>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2008 at 10:30 AM, Alok Kataria <akataria@vmware.com> wrote:
> On Wed, 2008-07-09 at 00:20 -0700, Yinghai Lu wrote:
>> On Tue, Jul 8, 2008 at 11:13 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > * Alok Kataria <akataria@vmware.com> wrote:
>> >
>
>> got
>> calling  ixgb_init_module+0x0/0x76
>> Intel(R) PRO/10GbE Network Driver - version 1.0.126-k4
>> Copyright (c) 1999-2006 Intel Corporation.
>> vendor=1022 device=7458
>> ACPI: PCI Interrupt 0000:0c:01.0[A] -> GSI 56 (level, low) -> IRQ 56
>> ixgb: eth18: ixgb_probe: Intel(R) PRO/10GbE Network Connection
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
>> IP: [<ffffffff80253b17>] hrtick_start_fair+0x89/0x173
>> PGD 0
>> Oops: 0000 [1] SMP
>> CPU 4
>> Modules linked in:
>> Pid: 103, comm: events/4 Not tainted 2.6.26-rc9-tip-00026-geae1aa0-dirty #240
>> RIP: 0010:[<ffffffff80253b17>]  [<ffffffff80253b17>]
>> hrtick_start_fair+0x89/0x173
>> RSP: 0018:ffff88082481fbd0  EFLAGS: 00010046
>> RAX: 0000000000000000 RBX: ffff880824828000 RCX: 0000000000000006
>> RDX: ffff88084423e700 RSI: ffff880824828000 RDI: ffff88084423e700
>> RBP: ffff88082481fc00 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000000 R12: ffff88084423e700
>> R13: ffff880844239700 R14: ffff880824828000 R15: 0000000000000c1a
>> FS:  0000000000000000(0000) GS:ffff881024c39600(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
>> CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Process events/4 (pid: 103, threadinfo ffff88082481e000, task ffff880824814230)
>> Stack:  ffff880844248118 000000005c0ee9e3 ffff880844239700 ffff88082490d878
>>  ffff88084423e700 0000000000000000 ffff88082481fc40 ffffffff80256591
>>  ffff88082481fc30 ffffffff80516fc5 000000005c0ee9e3 ffff88082490d840
>> Call Trace:
>>  [<ffffffff80256591>] dequeue_task_fair+0x5f/0x7e
>>  [<ffffffff80516fc5>] ? __first_cpu+0x26/0x49
>>  [<ffffffff80252792>] dequeue_task+0xce/0xf0
>>  [<ffffffff80252835>] deactivate_task+0x31/0x50
>>  [<ffffffff80252b93>] pull_task+0x2c/0x78
>>  [<ffffffff80254c04>] load_balance_fair+0x18d/0x277
>>  [<ffffffff80a49f02>] schedule+0x3db/0x962
>>  [<ffffffff802c0f0f>] ? vmstat_update+0x0/0x5e
>>  [<ffffffff802787c9>] ? schedule_delayed_work+0x31/0x48
>>  [<ffffffff802779ee>] worker_thread+0xbb/0x114
>>  [<ffffffff8027c5ec>] ? autoremove_wake_function+0x0/0x63
>>  [<ffffffff80277933>] ? worker_thread+0x0/0x114
>>  [<ffffffff8027c147>] kthread+0x61/0xa4
>>  [<ffffffff802614e5>] ? schedule_tail+0x36/0x81
>>  [<ffffffff8022b509>] child_rip+0xa/0x11
>>  [<ffffffff8027c0e6>] ? kthread+0x0/0xa4
>>  [<ffffffff8022b4ff>] ? child_rip+0x0/0x11
>>
>>
>> Code: c3 80 e8 86 04 01 00 80 3d 76 52 c0 00 00 0f 89 e1 00 00 00 41
>> f6 84 24 70 08 00 00 04 0f 85 d2 00 00 00 49 8b 84 24 a8 08 00 00 <48>
>> 8b 00 83 b8 c0 00 00 00 00 0f 84 ba 00 00 00 49 83 7d 10 01
>> RIP  [<ffffffff80253b17>] hrtick_start_fair+0x89/0x173
>>  RSP <ffff88082481fbd0>
>> CR2: 0000000000000000
>> ---[ end trace c05d5c1f5b126388 ]---
>>
>> yesterday tip/mater with tip/x86/modules
>> tip-history-2008-07-08_16.08_Tue works well.
>>
>> others traps merge seems not to cause the problem..
>>
>
> Hi Yinghai,
>
> Are we sure that these patches cause this null pointer dereference ?
> The panic in scheduler seems to be totally disconnected to the changes
> that these patches make. The only scheduler bit that we touch is the
> sched_clock thingy....but that too looks harmless to me.
>
> Can you please bisect and see if the first patch in the series  is the
> problem ?

tries last night,   it seems pgtable related patches cause that.

YH
