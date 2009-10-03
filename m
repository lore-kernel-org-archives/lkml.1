Return-Path: <linux-kernel-owner+w=401wt.eu-S1756938AbZJCTeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbZJCTeJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 15:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756878AbZJCTeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 15:34:08 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48043 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756865AbZJCTeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 15:34:08 -0400
Message-ID: <4AC7A6FF.8040002@cs.helsinki.fi>
Date: Sat, 03 Oct 2009 22:33:19 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: cl@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       rusty@rustcorp.com.au
Subject: Re: [this_cpu_xx V4 02/20] this_cpu: X86 optimized this_cpu	operations
References: <20091001212521.123389189@gentwo.org> <20091001212557.963565363@gentwo.org> <20091002095916.GA26201@elte.hu>
In-Reply-To: <20091002095916.GA26201@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ingo Molnar wrote:
> * cl@linux-foundation.org <cl@linux-foundation.org> wrote:
> 
>> Basically the existing percpu ops can be used for this_cpu variants 
>> that allow operations also on dynamically allocated percpu data. 
>> However, we do not pass a reference to a percpu variable in. Instead a 
>> dynamically or statically allocated percpu variable is provided.
>>
>> Preempt, the non preempt and the irqsafe operations generate the same 
>> code. It will always be possible to have the requires per cpu 
>> atomicness in a single RMW instruction with segment override on x86.
>>
>> 64 bit this_cpu operations are not supported on 32 bit.
>>
>> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>

I haven't looked at the series in detail but AFAICT the SLUB patches 
depend on the x86 ones. Any suggestions how to get all this into 
linux-next? Should I make a topic branch in slab.git on top of -tip or 
something?

			Pekka
