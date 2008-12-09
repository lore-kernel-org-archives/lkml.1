Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbYLITDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbYLITDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 14:03:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbYLITDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 14:03:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35713 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841AbYLITDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 14:03:36 -0500
Date: Tue, 9 Dec 2008 20:02:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Chris Friesen <cfriesen@nortel.com>
Cc: eranian@gmail.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>, Paul Mackerras <paulus@samba.org>,
       Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Subject: Re: [patch] Performance Counters for Linux, v2
Message-ID: <20081209190254.GA27833@elte.hu>
References: <20081208012211.GA23106@elte.hu> <7c86c4470812082237ne58c814s7218cc663f3b49e9@mail.gmail.com> <20081209134636.GA1926@elte.hu> <493E9F3E.3020902@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493E9F3E.3020902@nortel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Friesen <cfriesen@nortel.com> wrote:

> Ingo Molnar wrote:
>
>> When there are two (or more) hw metrics to profile, the ideally best 
>> (i.e. the statistically most stable and most relevant) sampling for 
>> the two statistical variables (say of l2_misses versus l2_accesses) is 
>> to sample them independently, via their own metric. Not via a static 
>> 1khz rate - or via picking one of the variables to generate samples.
>
> Regardless of sampling method, don't you still want some way to 
> enable/disable the various counters as close to simultaneously as 
> possible?

If it's about counter control for the monitored task, then we sure could 
do something about that. (apps/libraries could thus select a subset of 
functions to profile/measure, runtime, etc.)

If it's about counter control for the profiler/debugger, i'm not sure how 
useful that is - do you have a good usecase for it?

	Ingo
