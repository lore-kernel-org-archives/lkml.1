Return-Path: <linux-kernel-owner+w=401wt.eu-S1759562AbYHZR7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562AbYHZR7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 13:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759368AbYHZR7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 13:59:18 -0400
Received: from mx2.compro.net ([216.54.166.4]:16132 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759364AbYHZR7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 13:59:16 -0400
X-Greylist: delayed 852 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Aug 2008 13:59:16 EDT
X-IronPort-AV: E=Sophos;i="4.32,271,1217822400"; 
   d="scan'208";a="2742356"
Message-ID: <48B40975.7080803@compro.net>
Date: Tue, 26 Aug 2008 09:47:33 -0400
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
References: <20080819103301.787700742@chello.nl> <200808261900.07383.nickpiggin@yahoo.com.au> <20080826093059.GA471@elte.hu> <200808261954.47987.nickpiggin@yahoo.com.au> <alpine.LFD.1.10.0808261219050.3243@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0808261219050.3243@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Tue, 26 Aug 2008, Nick Piggin wrote:
> 
>> On Tuesday 26 August 2008 19:30, Ingo Molnar wrote:
>>> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
>>>> So... no reply to this? I'm really wondering how it's OK to break
>>>> documented standards and previous Linux behaviour by default for
>>>> something that it is trivial to solve in userspace? [...]
>>> I disagree
>> Your arguments were along the line of:
>>
>> * It probably doesn't break anything (except we had somebody report
>>   that it breaks their app)
> 
> I'm a real-time oldtimer. An application which hogs the CPU for 9.9
> seconds with SCHED_FIFO priority is just broken. It's broken beyond
> all limits, whether POSIX allows to do that or Linux obeyed the
> request of the braindamaged application design.
> 

Well, I've been working on RT hardware (mostly) and software since 1977.
With all due respect, thats crapola. I for one have this requirement and
there is _no_ way around it in my world. In fact it's the kernel thats broke
by stealing precious usecs from me.

>From my point of view, as an RT user, any kernel that supports SMP yet can't 
guarantee me %100 of even one _my_ processors is just a plainly broken kernel. 

>> * If it does break something then they must be doing something stupid
>>   (I refuted that because there are several legitimate ways to use rt
>>   scheduling that is broken by this)
>>
>> * We have many other APIs and tools that don't conform to posix (why
>>   is that a reason to break this one?)
> 
> Simply because we use common sense instead of following every single
> POSIX brainfart by the letter.
> 
>> * We should break the API to cater for stupid users and distros who
>>   create local DoS and/or lock up their boxes (except this is trivial
>>   to solve by setting sysctls or having a watchdog or using sysrq)
> 
> For the vast majority of users and RT developers a sane default of
> sanity measures is useful and sensible. 
> 
> If someone wants to shoot himself in the foot then it's not an
> unreasonable request that he needs to disable the safety guards before
> pulling the trigger.
> 

Again that is also crapola. If i want to shoot myself in the foot, it's
none of your concern. I know perfectly well what will happen when 
I pull the trigger. 

My 2 cents
Regards
Mark
