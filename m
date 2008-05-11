Return-Path: <linux-kernel-owner+w=401wt.eu-S1758503AbYEKT7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503AbYEKT7E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 15:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbYEKT6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 15:58:54 -0400
Received: from mga12.intel.com ([143.182.124.36]:28340 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755155AbYEKT6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 15:58:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,469,1204531200"; 
   d="scan'208";a="245255498"
Message-ID: <48274FF2.8040202@linux.intel.com>
Date: Sun, 11 May 2008 12:58:42 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Error in save_stack_trace() on x86_64?
References: <19f34abd0805110609lf3180dm3b1078e373983ad7@mail.gmail.com>	 <48274C9E.3020608@linux.intel.com> <19f34abd0805111256q29055475leb329179034df20c@mail.gmail.com>
In-Reply-To: <19f34abd0805111256q29055475leb329179034df20c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote: in userspace this trace looks correct.
> 
> No, it is happening from kernel code. As you can see from the original
> backtrace, the regs->ip (RIP) (regs taken from the very same
> do_page_fault()) points at add_uevent_var, which is a kernel function.
> 
>>  if it happens in kernel space... I wonder if the separate exception stack
>> thing
>>  is hurting us with the stacks not being properly connected...
>>  (but oopses and the like seem to come out just fine so I kinda doubt you're
>> hitting that)
>>
> 
> Thanks for looking into this.
> 

do you happen to have something that I maybe can reproduce?
(if you have that it would save me a ton of time in reproducing)
> 
> Vegard
> 

