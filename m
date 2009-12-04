Return-Path: <linux-kernel-owner+w=401wt.eu-S1755466AbZLDKUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbZLDKUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 05:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755080AbZLDKUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 05:20:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44815 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443AbZLDKUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 05:20:06 -0500
Message-ID: <4B18E257.2080009@suse.de>
Date: Fri, 04 Dec 2009 15:50:07 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] sched: fix GENTLE_FAIR_SLEEPERS dependency
References: <4B18D66E.8020905@suse.de> <20091204095408.GA26118@elte.hu>
In-Reply-To: <20091204095408.GA26118@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2009 03:24 PM, Ingo Molnar wrote:
> 
> * Suresh Jayaraman <sjayaraman@suse.de> wrote:
> 
>> The newly introduced GENTLE_FAIR_SLEEPERS does not seem to have any
>> effect without FAIR_SLEEPERS. Fix sysctl.sched_features to reflect
>> this. Without this change, a user who sets GENTLE_FAIR_SLEEPERS
>> without FAIR_SLEEPERS would assume gentle sleeper fairness which
>> is not guaranteed.
>>
> 
> There's a lot of other dependencies between scheduler features so it's 
> possible to change it without it having an effect on the scheduler. 
> 
> sched_features is really a development/debugging facility, you have to 
> know what you are doing.

I think originally introduced as a development/debugging facility,
sched_features is slowly transforming into a viable tool for System
Administrators, by looking at the impact of turning on/off some of these
features on some workloads (especially non-desktop workloads). And I
think these benefits should be passed on to the end users perhaps in the
form of documentation.

> Might be worth adding a comment to the feature definition place itself 
> in the source - explain what it does and how it makes sense (and how it 
> doesnt).
> 

Yes it make more sense to make such changes as part of documentation
than a code enforcement. I'll try and collect some of the useful tuning
information.


Thanks,

-- 
Suresh Jayaraman
