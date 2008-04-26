Return-Path: <linux-kernel-owner+w=401wt.eu-S1754929AbYDZMbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbYDZMbD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 08:31:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbYDZMax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 08:30:53 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:56542 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbYDZMaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 08:30:52 -0400
Message-ID: <48132072.9060308@linux.vnet.ibm.com>
Date: Sat, 26 Apr 2008 18:00:42 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: kernel list <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Ingo Molnar <mingo@elte.hu>, apw@shadowen.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [BUG] 2.6.25-git8 Kernel Bug while bootup on ppc and x86
References: <48131052.2080102@linux.vnet.ibm.com> <20080426113040.GC2252@cs181133002.pp.htv.fi>
In-Reply-To: <20080426113040.GC2252@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sat, Apr 26, 2008 at 04:51:54PM +0530, Kamalesh Babulal wrote:
>> While booting the 2.6.25-git8 kernel on the ppc and x86_64 machine, kernel
>> bug is hit. This was reported in the next-20080423 kernel 
>> http://lkml.org/lkml/2008/4/23/206.
>>
>> Call trace of x86_64 machine
>>
>> BUG: unable to handle kernel paging request at 00000000ffffffff
>> IP: [<ffffffff802359e5>] put_files_struct+0x25/0x110
>> PGD 0 
>> Oops: 0002 [333] SMP 
>> CPU 3 
>> Modules linked in:
>> Pid: 1391, comm: khelper Tainted: G      D  2.6.25-git8-autotest #1
>> RIP: 0010:[<ffffffff802359e5>]  [<ffffffff802359e5>] put_files_struct+0x25/0x110
>> RSP: 0000:ffff81090d06bdb0  EFLAGS: 00010282
>> RAX: 0000000000000101 RBX: fffffffffffffffe RCX: ffff8100010260e0
>> RDX: 0000000000000007 RSI: 0000000000000001 RDI: 00000000ffffffff
>> RBP: 00000000fffffffe R08: 2222222222222267 R09: 2222222222222222
>> R10: 0000000000000010 R11: 2222222222222222 R12: 00000000ffffffff
>> R13: ffff81032d2e9000 R14: ffff81090e74b000 R15: ffff81061e4cbce0
>> FS:  0000000000000000(0000) GS:ffff81032e4ae940(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
>> CR2: 00000000ffffffff CR3: 0000000000201000 CR4: 00000000000006e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Process khelper (pid: 1391, threadinfo ffff81090d06a000, task ffff81090d8113a0)
>> Stack:  ffff81090d8113a0 fffffffffffffffe 00000000fffffffe ffff81032e556e00
>>  ffff81032d2e9000 ffff81090e74b000 ffff81061e4cbce0 ffffffff80294278
>>  ffff81090d06be70 ffffffff80636bc0 ffff81090d3646c0 ffff81032d2e9000
>> Call Trace:
>>  [<ffffffff80294278>] do_execve+0x108/0x230
>> ...
> 
> Most likely fixed by
>   http://lkml.org/lkml/2008/4/26/1

Hi Adrian,

Thanks, the patch fixes the boot up bug.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
