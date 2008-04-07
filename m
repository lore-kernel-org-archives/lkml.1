Return-Path: <linux-kernel-owner+w=401wt.eu-S1756939AbYDGJlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbYDGJlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 05:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbYDGJkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 05:40:55 -0400
Received: from [83.228.35.12] ([83.228.35.12]:54376 "EHLO fs.ru.acad.bg"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754213AbYDGJky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 05:40:54 -0400
Message-ID: <47F9EC23.3030907@fs.ru.acad.bg>
Date: Mon, 07 Apr 2008 12:40:51 +0300
From: Plamen Petrov <plamen.petrov@fs.ru.acad.bg>
Organization: Filial - Silistra
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: linux 2.6.25-rc8-00166-g6fdf5e6 BUG
References: <47F9D21F.4080804@fs.ru.acad.bg> <200804071101.33284.rjw@sisk.pl>
In-Reply-To: <200804071101.33284.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Monday, 7 of April 2008, Plamen Petrov wrote:
>   
>> Hi!
>>     
>
> Hi,
>
>   
>> This morning, while closing KMail from the KDE desktop to
>> shutdown the machine, I got this:
>>
>> [===snip===]
>>
>> [145026.240307] general protection fault: 0000 [1] PREEMPT SMP
>> [145026.240313] CPU 0
>> [145026.240315] Modules linked in:
>> [145026.240318] Pid: 32546, comm: kmail Not tainted 
>> 2.6.25-rc8-00166-g6fdf5e6 #1
>> [145026.240320] RIP: 0010:[<ffffffff80275274>]  [<ffffffff80275274>] 
>> set_page_dirty+0x34/0x90
>> [145026.240327] RSP: 0018:ffff810004ba9d98  EFLAGS: 00010206
>> [145026.240328] RAX: 6b636f6c5f747369 RBX: ffff81000779cae0 RCX: 
>> ffff8100010046e0
>> [145026.240330] RDX: ffffffff802c08d0 RSI: 8000000033d60067 RDI: 
>> ffffe20000b56d00
>> [145026.240332] RBP: 000000000115c000 R08: 0000000000000006 R09: 
>> 0000000000000001
>> [145026.240334] R10: 0000000000000002 R11: 000000000000031b R12: 
>> ffffe20000b56d00
>> [145026.240335] R13: 0000000001200000 R14: 0000000033d60067 R15: 
>> 0000000000000000
>> [145026.240338] FS:  0000000000000000(0000) GS:ffffffff80993000(0000) 
>> knlGS:0000000000000000
>> [145026.240340] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [145026.240341] CR2: 00007f695e7aa3f0 CR3: 0000000000201000 CR4: 
>> 00000000000006e0
>> [145026.240343] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
>> 0000000000000000
>> [145026.240345] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
>> 0000000000000400
>> [145026.240347] Process kmail (pid: 32546, threadinfo ffff810004ba8000, 
>> task ffff81002137a000)
>> [145026.240348] Stack:  0000000001155000 ffff81000779cae0 
>> 000000000115c000 ffffffff8027e271
>> [145026.240353]  0000000000000000 0000000001574fff 0000000000000000 
>> ffff810004ba9ea8
>> [145026.240357]  ffffffffffffffff 0000000000000000 ffff81003af86bd0 
>> ffff810004ba9eb0
>> [145026.240360] Call Trace:
>> [145026.240364]  [<ffffffff8027e271>] ? unmap_vmas+0x611/0x800
>> [145026.240367]  [<ffffffff8028252a>] ? exit_mmap+0x8a/0x130
>> [145026.240370]  [<ffffffff80236957>] ? mmput+0x57/0xe0
>> [145026.240373]  [<ffffffff8023cc8a>] ? do_exit+0x19a/0x7e0
>> [145026.240377]  [<ffffffff807079fb>] ? lockdep_sys_exit_thunk+0x35/0x67
>> [145026.240381]  [<ffffffff803f6281>] ? __up_read+0x21/0xb0
>> [145026.240383]  [<ffffffff8023d303>] ? do_group_exit+0x33/0xa0
>> [145026.240386]  [<ffffffff8020b56b>] ? system_call_after_swapgs+0x7b/0x80
>> [145026.240387]
>>
>>     
>
> Trying the latest -git tree never hurts, but you can open a bug report anyway
> (you can close it later if the bug is not reproducible any more) and please
> mark it as a regression and make it block bug #9832.
>
> Thanks,
> Rafael
>   
Done.

http://bugzilla.kernel.org/show_bug.cgi?id=10412

-- 
Plamen Petrov, network & system administrator
Filial - Silistra
RU "Angel Kantchev"
http://fs.ru.acad.bg/
--------------------------------
this message is UTF8 encoded

