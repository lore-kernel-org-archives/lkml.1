Return-Path: <linux-kernel-owner+w=401wt.eu-S1756974AbZCBHo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974AbZCBHo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 02:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbZCBHoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 02:44:19 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:13213 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbZCBHoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 02:44:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=FeJfZ3LMf/F0qW7zS1zXOi+XcWjMb7YvpNM0ywIpnk48NsQPgEYBpepW21BahRMrFw
         LLHSkKNAI2U1rTKmYjXKM2mz9aN9BPpg8GinQoz/6T8kM3/+0yGcPcg5mW45mXk0C1B+
         kzij7H7qT/EZuxnSoKI00B09XE1hl2xH7LANE=
Date: Mon, 2 Mar 2009 15:44:25 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Wang Chen <wangchen@cn.fujitsu.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: kill unused parameter of pick_next_task()
Message-ID: <20090302074425.GI1771@hack.private>
References: <49AB74CE.2000200@cn.fujitsu.com> <20090302061350.GE1771@hack.private> <49AB8246.6020809@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49AB8246.6020809@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 02:52:54PM +0800, Wang Chen wrote:
>Américo Wang said the following on 2009-3-2 14:13:
>> On Mon, Mar 02, 2009 at 01:55:26PM +0800, Wang Chen wrote:
>>> based on tip/sched/cleanups
>>>
>>> impact: no change in functionality
>>>
>>> Parameter "prev" seems like an unusable thing.
>>>
>>> Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>
>>> ---
>>> kernel/sched.c |    6 +++---
>>> 1 files changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/kernel/sched.c b/kernel/sched.c
>>> index 410eec4..57f8b12 100644
>>> --- a/kernel/sched.c
>>> +++ b/kernel/sched.c
>>> @@ -4512,7 +4512,7 @@ static inline void schedule_debug(struct task_struct *prev)
>>>  * Pick up the highest-prio task:
>>>  */
>>> static inline struct task_struct *
>>> -pick_next_task(struct rq *rq, struct task_struct *prev)
>>> +pick_next_task(struct rq *rq)
>>> {
>>> 	const struct sched_class *class;
>>> 	struct task_struct *p;
>>> @@ -4587,7 +4587,7 @@ need_resched_nonpreemptible:
>>> 		idle_balance(cpu, rq);
>>>
>>> 	prev->sched_class->put_prev_task(rq, prev);
>>         ^^^^^
>> 
>> How about this? :)
>> 
>
>need_resched_nonpreemptible is inside another function instead of pick_next_task().
>Because "diff" doesn't know "asmlinkage void __sched schedule(void)".
>;)
>

Oops, I misread the patch. Then it's OK. :)


-- 
Do what you love, f**k the rest! F**k the regulations!
 
