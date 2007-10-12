Return-Path: <linux-kernel-owner+w=401wt.eu-S1760068AbXJLMOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068AbXJLMOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 08:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbXJLMOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 08:14:43 -0400
Received: from main.gmane.org ([80.91.229.2]:38313 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753839AbXJLMOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 08:14:42 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Linux 2.6.23
Date: Fri, 12 Oct 2007 08:21:59 -0400
Message-ID: <470F66E7.7010509@tmr.com>
References: <alpine.LFD.0.999.0710091346490.5039@woody.linux-foundation.org> <1191996740.8694.7.camel@entropy> <20071010101452.GA25433@elte.hu> <200710111916.23633.nickpiggin@yahoo.com.au> <20071012054615.GA22256@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Gmane-NNTP-Posting-Host: pool-70-109-100-63.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <20071012054615.GA22256@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
>> ;) I think you snipped the important bit:
>>
>> "the peak is terrible but it has virtually no dropoff and performs 
>> better under load than the default 2.6.21 scheduler." (verbatim)
> 
> hm, i understood that peak remark to be in reference to FreeBSD's 
> scheduler (which the FreeBSD guys are primarily interested in 
> obviously), not v2.6.21 - but i could be wrong.
> 
> In any case, there is indeed a regression with sysbench and a low number 
> of threads, and it's being fixed. The peak got improved visibly in 
> sched-devel:
> 
>   http://people.redhat.com/mingo/misc/sysbench-sched-devel.jpg
> 
> but there is still some peak regression left, i'm testing a patch for 
> that.
> 
There's one important bit missing from that graph, the 
2.6.23-SCHED_BATCH values. Without that we can't tell how much 
improvement is from sched-devel and how much from SCHED_BATCH. Clearly 
2.6.23 is better than 2.6.22.any in this test, the locking issues seem 
to dominate that difference to the point that nothing else would be 
informative.

This weekend I have to do some building of kernels for various machines, 
so I intend to run some builds SCHED_BATCH and some will just run. If I 
find anything interesting I'll report.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

