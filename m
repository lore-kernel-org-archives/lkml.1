Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbZJDQsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbZJDQsm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 12:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757400AbZJDQsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 12:48:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39597 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757386AbZJDQsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 12:48:40 -0400
Date: Sun, 4 Oct 2009 18:47:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: cl@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       rusty@rustcorp.com.au
Subject: Re: [this_cpu_xx V4 02/20] this_cpu: X86 optimized this_cpu
	operations
Message-ID: <20091004164731.GA20489@elte.hu>
References: <20091001212521.123389189@gentwo.org> <20091001212557.963565363@gentwo.org> <20091002095916.GA26201@elte.hu> <4AC7A6FF.8040002@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC7A6FF.8040002@cs.helsinki.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi,
>
> Ingo Molnar wrote:
>> * cl@linux-foundation.org <cl@linux-foundation.org> wrote:
>>
>>> Basically the existing percpu ops can be used for this_cpu variants  
>>> that allow operations also on dynamically allocated percpu data.  
>>> However, we do not pass a reference to a percpu variable in. Instead 
>>> a dynamically or statically allocated percpu variable is provided.
>>>
>>> Preempt, the non preempt and the irqsafe operations generate the same 
>>> code. It will always be possible to have the requires per cpu  
>>> atomicness in a single RMW instruction with segment override on x86.
>>>
>>> 64 bit this_cpu operations are not supported on 32 bit.
>>>
>>> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
>>
>> Acked-by: Ingo Molnar <mingo@elte.hu>
>
> I haven't looked at the series in detail but AFAICT the SLUB patches 
> depend on the x86 ones. Any suggestions how to get all this into 
> linux-next? Should I make a topic branch in slab.git on top of -tip or 
> something?

I'd suggest to keep these patches together in the right topical tree: 
Tejun's percpu tree. Any problem with that approach?

	Ingo
