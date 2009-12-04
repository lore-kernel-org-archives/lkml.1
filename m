Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbZLDLmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbZLDLmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 06:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbZLDLmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 06:42:19 -0500
Received: from cantor.suse.de ([195.135.220.2]:42347 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701AbZLDLmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 06:42:19 -0500
Message-ID: <4B18F59B.6@suse.de>
Date: Fri, 04 Dec 2009 17:12:19 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] sched: fix GENTLE_FAIR_SLEEPERS dependency
References: <4B18D66E.8020905@suse.de> <20091204095408.GA26118@elte.hu>	 <4B18E257.2080009@suse.de> <1259924920.17907.8.camel@laptop>
In-Reply-To: <1259924920.17907.8.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2009 04:38 PM, Peter Zijlstra wrote:
> On Fri, 2009-12-04 at 15:50 +0530, Suresh Jayaraman wrote:
>>
>> I think originally introduced as a development/debugging facility,
>> sched_features is slowly transforming into a viable tool for System
>> Administrators, by looking at the impact of turning on/off some of these
>> features on some workloads (especially non-desktop workloads). And I
>> think these benefits should be passed on to the end users perhaps in the
>> form of documentation. 
> 
> This is really not meant to be used in that context. Its purely a debug
> feature, with knobs coming and going as we see fit.
> 

Does this also mean these features should not impact any specific
workload much?

http://osdir.com/ml/linux-kernel/2009-09/msg03406.html
In the thread above Ingo mentions about a few features and my
understanding is that some of these might favour one type of workload
than other. Is this not true anymore?


Thanks,

-- 
Suresh Jayaraman
