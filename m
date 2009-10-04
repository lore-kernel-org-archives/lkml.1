Return-Path: <linux-kernel-owner+w=401wt.eu-S1757607AbZJDQw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607AbZJDQw2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 12:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757588AbZJDQw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 12:52:28 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33010 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583AbZJDQw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 12:52:27 -0400
Message-ID: <4AC8D298.6080206@cs.helsinki.fi>
Date: Sun, 04 Oct 2009 19:51:36 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: cl@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       rusty@rustcorp.com.au
Subject: Re: [this_cpu_xx V4 02/20] this_cpu: X86 optimized this_cpu	operations
References: <20091001212521.123389189@gentwo.org> <20091001212557.963565363@gentwo.org> <20091002095916.GA26201@elte.hu> <4AC7A6FF.8040002@cs.helsinki.fi> <20091004164731.GA20489@elte.hu>
In-Reply-To: <20091004164731.GA20489@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Ingo Molnar wrote:
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
>> Hi,
>>
>> Ingo Molnar wrote:
>>> * cl@linux-foundation.org <cl@linux-foundation.org> wrote:
>>>
>>>> Basically the existing percpu ops can be used for this_cpu variants  
>>>> that allow operations also on dynamically allocated percpu data.  
>>>> However, we do not pass a reference to a percpu variable in. Instead 
>>>> a dynamically or statically allocated percpu variable is provided.
>>>>
>>>> Preempt, the non preempt and the irqsafe operations generate the same 
>>>> code. It will always be possible to have the requires per cpu  
>>>> atomicness in a single RMW instruction with segment override on x86.
>>>>
>>>> 64 bit this_cpu operations are not supported on 32 bit.
>>>>
>>>> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
>>> Acked-by: Ingo Molnar <mingo@elte.hu>
>> I haven't looked at the series in detail but AFAICT the SLUB patches 
>> depend on the x86 ones. Any suggestions how to get all this into 
>> linux-next? Should I make a topic branch in slab.git on top of -tip or 
>> something?
> 
> I'd suggest to keep these patches together in the right topical tree: 
> Tejun's percpu tree. Any problem with that approach?

I'm fine with that. Just wanted to make sure who is taking the patches 
and if I should pick any of them up. We can get some conflicts between 
the per-cpu tree and slab.git if new SLUB patches get merged but that's 
probably not a huge problem.

			Pekka
