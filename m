Return-Path: <linux-kernel-owner+w=401wt.eu-S1755971AbYDJKvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbYDJKvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 06:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbYDJKvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 06:51:15 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:41889 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbYDJKvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 06:51:14 -0400
Message-ID: <47FDF11D.40407@linux.vnet.ibm.com>
Date: Thu, 10 Apr 2008 16:21:09 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Jacek Luczak <difrost.kernel@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUG] linux-next: Tree for April 9 warning on CC_STACKPROTECTOR,
 followed by kernel panic
References: <20080409185309.b94c9d15.sfr@canb.auug.org.au> <47FDE045.4070509@linux.vnet.ibm.com> <47FDE881.1030409@gmail.com>
In-Reply-To: <47FDE881.1030409@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jacek Luczak wrote:
> Kamalesh Babulal pisze:
>> Hi Stephen,
>>
>> The next-20080409 kernel warns while booting up on a x86_64 machine.
>> When compiled the kernel with CONFIG_CC_STACKPROTECTOR=y, the warning
>> is followed by the kernel panic.
>>
>> Testing -fstack-protector-all feature
>> No -fstack-protector-stack-frame!
>> -fstack-protector-all test failed
>> ------------[ cut here ]------------
>> WARNING: at kernel/panic.c:365 __stack_chk_test+0x4b/0x50()
>> Modules linked in:
>> Pid: 1, comm: swapper Not tainted 2.6.25-rc8-next-20080409-autotest #1
>>
>> Call Trace:
>>  [<ffffffff80231f5e>] warn_on_slowpath+0x51/0x63
>>  [<ffffffff80232d93>] printk+0x4e/0x56
>>  [<ffffffff80382fcd>] extract_entropy+0x47/0x90
>>  [<ffffffff80230000>] dup_mm+0xca/0x3fd
>>  [<ffffffff80231eba>] __stack_chk_test_func+0x21/0x32
>>  [<ffffffff80231fbb>] __stack_chk_test+0x4b/0x50
>>  [<ffffffff808ba8f1>] kernel_init+0x189/0x2f9
>>  [<ffffffff804ee221>] _spin_unlock_irq+0x9/0xc
>>  [<ffffffff8020cb88>] child_rip+0xa/0x12
>>  [<ffffffff808ba768>] kernel_init+0x0/0x2f9
>>  [<ffffffff8020cb7e>] child_rip+0x0/0x12
>>
>> ---[ end trace d88d2f3a71e3b32c ]---
> 
> Hi,
> 
> what version of GCC are you using?
> 
> -Jacek
Hi Jacek,

I use the gcc version (GCC) 4.1.1 20060525 (Red Hat 4.1.1-1)

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
