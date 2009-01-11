Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbZAKESm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbZAKESm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 23:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbZAKESd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 23:18:33 -0500
Received: from relay2.sgi.com ([192.48.179.30]:45979 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751086AbZAKESd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 23:18:33 -0500
Message-ID: <49697306.9040103@sgi.com>
Date: Sat, 10 Jan 2009 20:18:14 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Matt Mackall <mpm@selenic.com>, Yinghai Lu <yinghai@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sparseirq: make some func to be used with genirq
References: <496534B1.6080902@kernel.org> <20090108120619.GF1539@elte.hu> <1231435078.3178.278.camel@calx> <20090111034646.GA28520@elte.hu> <49696E92.6010804@sgi.com> <20090111040513.GF28520@elte.hu>
In-Reply-To: <20090111040513.GF28520@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Ingo Molnar wrote:
>>> * Matt Mackall <mpm@selenic.com> wrote:
>>>
>>>> On Thu, 2009-01-08 at 13:06 +0100, Ingo Molnar wrote:
>>>>> (Matt Cc:-ed)
>>>>>
>>>>> Matt, does this look good to you? The point of this cleanup would be to 
>>>>> make desc->timer_rand_state depend on hardirq (the presence of irq_desc[]) 
>>>>> - not sparseirq (which does not make much sense).
>>>> Seems fine.
>>>>
>>>> Signed-off-by: Matt Mackall <mpm@selenic.com>
>>> applied it to tip/irq/urgent, thanks guys!
>>>
>>> 	Ingo
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>> This will conflict with the change of kstat_irqs from unsigned int to 
>> unsigned long.
>>
>> If you do your magic on tip/cpus4096, I will git-remote update my tree 
>> and make the conflict go away...
> 
> you can defer the change to unsigned long to a later stage, when these 
> have hit upstream. (in a few days)
> 
> 	Ingo

Good idea since the change to long tripped a panic in the CPUMASK_OFFSTACK=n
case (which doesn't make a lot of sense at this moment.)

Will push the remainder soon.

Thanks,
Mike

