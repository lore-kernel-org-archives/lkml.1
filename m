Return-Path: <linux-kernel-owner+w=401wt.eu-S1767376AbXECEfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767376AbXECEfF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 00:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767377AbXECEfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 00:35:05 -0400
Received: from holomorphy.com ([66.93.40.71]:43524 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767376AbXECEfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 00:35:04 -0400
Date: Wed, 2 May 2007 21:35:41 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org, ck@vds.kolivas.org
Subject: Re: [ck] [REPORT] 2.6.21.1 vs 2.6.21-sd046 vs 2.6.21-cfs-v6
Message-ID: <20070503043541.GC19966@holomorphy.com>
References: <200705030211.39345.a1426z@gawab.com> <20070503004929.GA19966@holomorphy.com> <200705030651.43865.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705030651.43865.a1426z@gawab.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
>> That's odd. The ->load_weight changes should've improved that quite
>> a bit. There may be something slightly off in how lag is computed,
>> or maybe the O(n) lag issue Ying Tang spotted is biting you.

On Thu, May 03, 2007 at 06:51:43AM +0300, Al Boldi wrote:
> Is it not biting you too?

I'm a kernel programmer. I'm not an objective tester.

It also happens to be the case that I personally have never encountered
a performance problem with any of the schedulers, mainline included, on
any system I use interactively. So my "user experience" is not valuable.


William Lee Irwin III wrote:
>> Also, I should say that the nice number affairs don't imply fairness
>> per se. The way that works is that when tasks have "weights" (like
>> nice levels in UNIX) the definition of fairness changes so that each
>> task gets shares of CPU bandwidth proportional to its weight instead
>> of one share for one task.

On Thu, May 03, 2007 at 06:51:43AM +0300, Al Boldi wrote:
> Ok, but you can easily expose scheduler unfairness by using nice levels as 
> relative magnifiers; provided nice levels are implemented correctly.

This doesn't really fit in with anything I'm aware of.


William Lee Irwin III wrote:
>> The other thing to do is try a different number of tasks with a
>> different mix of nice levels. The weight w_i for a given nice
>> level n_i should be the same even in a different mix of tasks
>> and nice levels if the nice levels are the same.
>> If this sounds too far out, there's nothing to worry about. You can
>> just run the different numbers of tasks with different mixes of nice
>> levels and post the %cpu numbers. Or if that's still a bit far out
>> for you, a test that does all this is eventually going to get written.

On Thu, May 03, 2007 at 06:51:43AM +0300, Al Boldi wrote:
> chew.c does exactly that, just make sure sched_granularity_ms >= 5,000,000.

Please post the source of chew.c


-- wli
