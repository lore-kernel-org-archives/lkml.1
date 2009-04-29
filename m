Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbZD2Jvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbZD2Jvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbZD2Jvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:51:41 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:58525 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbZD2Jvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:51:39 -0400
Message-ID: <49F8232B.4090007@in.ibm.com>
Date: Wed, 29 Apr 2009 15:21:39 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_W?= =?ISO-8859-1?Q?eisbecker?= 
	<fweisbec@gmail.com>,
       linux-s390@vger.kernel.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Next April 24: [S390] allmodconfig build failure (trace/events)
References: <20090424150456.ff35e4ea.sfr@canb.auug.org.au> <49F16654.8040208@in.ibm.com> <20090424072533.GE24912@elte.hu> <20090424104108.0f2c0f05@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20090424104108.0f2c0f05@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
> On Fri, 24 Apr 2009 09:25:33 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>> * Sachin Sant <sachinp@in.ibm.com> wrote:
>>
>>     
>>> Today's next tree build(s390 allmodconfig) failed with
>>>
>>> kernel/built-in.o: In function `trace_softirq_entry'
>>> include/trace/events/irq.h:42: undefined reference to  
>>> `'
>>> include/trace/events/irq.h:42: undefined reference to  
>>> `__tracepoint_softirq_entry'
>>> kernel/built-in.o: In function `trace_softirq_exit':
>>> include/trace/events/irq.h:48: undefined reference to  
>>> `__tracepoint_softirq_exit'
>>> include/trace/events/irq.h:48: undefined reference to  
>>> `__tracepoint_softirq_exit'
>>>       
>> Hm, that's weird - s390 does not build kernel/softirq.o? Hm, it does 
>> - softirq.o is an obj-y object.
>>     
>
> s390 does build kernel/softirq.o. However it's anything but obvious to
> me how the tracepoint infrastructure works. Too many #ifdefs, #define's
> and #undefine's...
>
> I would expect that struct __tracepoint_softirq_entry somehow gets
> defined via one of the TRACE_FORMAT macros, no?
Today's next tree also has this failure. Any solution for this problem ?

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

