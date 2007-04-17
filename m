Return-Path: <linux-kernel-owner+w=401wt.eu-S1752367AbXDQHvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbXDQHvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 03:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbXDQHvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 03:51:53 -0400
Received: from holomorphy.com ([66.93.40.71]:41687 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbXDQHvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 03:51:52 -0400
Date: Tue, 17 Apr 2007 00:51:46 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
Message-ID: <20070417075146.GM2986@holomorphy.com>
References: <20070416220715.GA4071@elte.hu> <46246D61.8010300@bigpond.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46246D61.8010300@bigpond.net.au>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> this is the second release of the CFS (Completely Fair Scheduler) 
>> patchset, against v2.6.21-rc7:
>>    http://redhat.com/~mingo/cfs-scheduler/sched-cfs-v2.patch
>> i'd like to thank everyone for the tremendous amount of feedback and 
>> testing the v1 patch got - i could hardly keep up with just reading the 
>> mails! Some of the stuff people addressed i couldnt implement yet, i 
>> mostly concentrated on bugs, regressions and debuggability.

On Tue, Apr 17, 2007 at 04:46:57PM +1000, Peter Williams wrote:
> Have you considered using rq->raw_weighted_load instead of 
> rq->nr_running in calculating fair_clock?  This would take the nice 
> value (or RT priority) of the other tasks into account when determining 
> what's fair.

I suspect you mean (curr->load_weight*delta_exec)/rq->raw_weighted_load
in update_curr().


-- wli
