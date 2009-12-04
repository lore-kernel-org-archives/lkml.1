Return-Path: <linux-kernel-owner+w=401wt.eu-S1756338AbZLDNMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338AbZLDNMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 08:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755984AbZLDNMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 08:12:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50980 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbZLDNMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 08:12:42 -0500
Message-ID: <4B190ACA.6090901@suse.de>
Date: Fri, 04 Dec 2009 18:42:42 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] sched: fix GENTLE_FAIR_SLEEPERS dependency
References: <4B18D66E.8020905@suse.de> <20091204095408.GA26118@elte.hu>	 <4B18E257.2080009@suse.de> <1259924920.17907.8.camel@laptop>	 <4B18F59B.6@suse.de> <1259928516.17907.160.camel@laptop>
In-Reply-To: <1259928516.17907.160.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2009 05:38 PM, Peter Zijlstra wrote:
> On Fri, 2009-12-04 at 17:12 +0530, Suresh Jayaraman wrote:
>> On 12/04/2009 04:38 PM, Peter Zijlstra wrote:
>>> On Fri, 2009-12-04 at 15:50 +0530, Suresh Jayaraman wrote:
>>>>
>>>> I think originally introduced as a development/debugging facility,
>>>> sched_features is slowly transforming into a viable tool for System
>>>> Administrators, by looking at the impact of turning on/off some of these
>>>> features on some workloads (especially non-desktop workloads). And I
>>>> think these benefits should be passed on to the end users perhaps in the
>>>> form of documentation. 
>>>
>>> This is really not meant to be used in that context. Its purely a debug
>>> feature, with knobs coming and going as we see fit.
>>>
>>
>> Does this also mean these features should not impact any specific
>> workload much?
> 
> How would that follow?
> 
>> http://osdir.com/ml/linux-kernel/2009-09/msg03406.html
>> In the thread above Ingo mentions about a few features and my
>> understanding is that some of these might favour one type of workload
>> than other. Is this not true anymore?
> 
> Sure it is, everything is workload dependent, the posix SCHED_OTHER task
> model just doesn't include much usable information.
> 
> But that does not justify promoting this to generic tunable. What if you
> happen to want to run two different workloads on one machine?

Ok, I understand.

> 
> Furthermore, if your favourite workload doesn't work well, file a bug
> report (preferably with reproducer, otherwise its pure guesswork).

Make sense.

> The only reason to poke at it is debugging, full stop, no whining or .33
> won't have the interface anymore, which would be sad because then
> everybody will have to recompile their kernel to debug things.
> 

The intention was to understand better (if at all there is anything
tunable, if yes document) and definitely not whining. Please don't kill it.


Thanks,

-- 
Suresh Jayaraman
