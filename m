Return-Path: <linux-kernel-owner+w=401wt.eu-S1751666AbYLHIc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbYLHIc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 03:32:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbYLHIcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 03:32:47 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:54273 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbYLHIcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 03:32:46 -0500
In-Reply-To: <20081208012211.GA23106@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eric Dumazet <dada1@cosmosbay.com>, David Miller <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, Peter Anvin <hpa@zytor.com>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-kernel-owner@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Robert Richter <robert.richter@amd.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Subject: Re: [patch] Performance Counters for Linux, v2
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF9822E5EF.E1B46155-ON87257519.002E51BD-88257519.002EF09B@us.ibm.com>
From: Corey J Ashford <cjashfor@us.ibm.com>
Date: Mon, 8 Dec 2008 00:32:41 -0800
X-MIMETrack: Serialize by Router on D03NM120/03/M/IBM(Release 8.0.1|February 07, 2008) at
 12/08/2008 01:32:41,
	Serialize complete at 12/08/2008 01:32:41
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-kernel-owner@vger.kernel.org wrote on 12/07/2008 05:22:12 PM:
[snip]
> 
> The other big change is the support of virtual task counters via counter 

> scheduling: a task can specify more counters than there are on the CPU, 
> the kernel will then schedule the counters periodically to spread out hw 

> resources. So for example if a task starts 6 counters on a CPU that has 
> only two hardware counters, it still gets this output:
> 
>  counter[0 cycles              ]:   5204680573 , delta:   1733680843 
events
>  counter[1 instructions        ]:   1364468045 , delta:    454818351 
events
>  counter[2 cache-refs          ]:        12732 , delta:         4399 
events
>  counter[3 cache-misses        ]:         1009 , delta:          336 
events
>  counter[4 branch-instructions ]:    125993304 , delta:     42006998 
events
>  counter[5 branch-misses       ]:         1946 , delta:          649 
events
>

Hello Ingo,

I posted some questions about this capability in your proposal on LKML, 
but I wasn't able to get the reply threaded in properly.  Could you take a 
look at this post, please?

http://lkml.org/lkml/2008/12/5/299

Thanks for your consideration,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR 
503-578-3507 
cjashfor@us.ibm.com
