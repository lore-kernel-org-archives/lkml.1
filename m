Return-Path: <linux-kernel-owner+w=401wt.eu-S1765943AbXEVWeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765943AbXEVWeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 18:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757902AbXEVWeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 18:34:36 -0400
Received: from mail.tmr.com ([64.65.253.246]:43965 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757663AbXEVWef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 18:34:35 -0400
Message-ID: <4653706E.80702@tmr.com>
Date: Tue, 22 May 2007 18:36:30 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: William Lee Irwin III <wli@holomorphy.com>
CC: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Scheduling tests on IPC methods, fc6, sd0.48, cfs12
References: <464CE4AE.3030908@tmr.com> <20070521093958.GI19966@holomorphy.com>
In-Reply-To: <20070521093958.GI19966@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> On Thu, May 17, 2007 at 07:26:38PM -0400, Bill Davidsen wrote:
>> I have posted the results of my initial testing, measuring IPC rates 
>> using various schedulers under no load, limited nice load, and heavy 
>> load at nice 0.
>> http://www.tmr.com/~davidsen/ctxbench_testing.html
> 
> Kernel compiles are not how to stress these. The way to stress them is
> to have multiple simultaneous independent chains of communicators and
> deeper chains of communicators.
> 
> Kernel compiles are little but background cpu/memory load for these
> sorts of tests.

Just so. What is being quantified is the rate of slowdown due to 
external load. I would hope that each IPC method would slow by some 
similar factor.

>                 ...  Something expected to have some sort of mutual
> interference depending on quality of implementation would be a better
> sort of competing load, one vastly more reflective of real workloads.
> For instance, another set of processes communicating using the same
> primitive.
> 
The original intent was purely to measure IPC speed under no load 
conditions, since fairness is in vogue I also attempted to look for 
surprising behavior. Corresponding values under equal load may be useful 
in relation to one another, but this isn't (and hopefully doesn't claim 
to be) a benchmark. It may or may not be useful viewed in that light, 
but that's not the target.

> Perhaps best of all would be a macrobenchmark utilizing a variety of
> the primitives under consideration. Unsurprisingly, major commercial
> databases do so for major benchmarks.
> 
And that's a very good point, either multiple copies or more forked 
processes might be useful, and I do intend to add threaded tests on the 
next upgrade, but perhaps a whole new code might be better for 
generating the load you suggest.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
