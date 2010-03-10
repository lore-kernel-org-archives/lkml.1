Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab0CJCOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 21:14:07 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56901 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755522Ab0CJCOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 21:14:05 -0500
Message-ID: <4B970064.2040802@cn.fujitsu.com>
Date: Wed, 10 Mar 2010 10:13:56 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, josh@joshtriplett.org,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC PATCH] rcu: don't ignore preempt_disable() in the idle	loop
References: <4B962D57.1000406@cn.fujitsu.com> <20100310013035.GB6203@linux.vnet.ibm.com>
In-Reply-To: <20100310013035.GB6203@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
>>
>> This is another try, it uses the fact that idle loops
>> are executing with preept_count()=1.
>> But I didn't look deep into all idle loops.
> 
> Hello, Lai!
> 
> One question below...
> 
> 						Thanx, Paul
> 

[...]

>> +
>> +	if ((preempt_count() & PREEMPT_MASK) > IDLE_CORE_LOOP_PREEMPT_COUNT)
>> +		return 0;
> 
> How does this work in CONFIG_PREEMPT=n kernels?  I don't see how it
> does, regardless of what preempt_count() returns in this case.
> 
>

You are right, It cannot work in CONFIG_PREEMPT=n kernels.
ignore this stupid patch.

Thanx, Lai
