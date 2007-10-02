Return-Path: <linux-kernel-owner+w=401wt.eu-S1752677AbXJBEVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbXJBEVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 00:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbXJBEVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 00:21:46 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:49080 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbXJBEVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 00:21:46 -0400
Message-ID: <4701C737.8070906@linux.vnet.ibm.com>
Date: Tue, 02 Oct 2007 09:51:11 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Memory controller merge (was Re: -mm merge plans for 2.6.24)
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
In-Reply-To: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> memory-controller-add-documentation.patch
> memory-controller-resource-counters-v7.patch
> memory-controller-resource-counters-v7-fix.patch
> memory-controller-containers-setup-v7.patch
> memory-controller-accounting-setup-v7.patch
> memory-controller-memory-accounting-v7.patch
> memory-controller-memory-accounting-v7-fix.patch
> memory-controller-memory-accounting-v7-fix-swapoff-breakage-however.patch
> memory-controller-task-migration-v7.patch
> memory-controller-add-per-container-lru-and-reclaim-v7.patch
> memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
> memory-controller-add-per-container-lru-and-reclaim-v7-fix-2.patch
> memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch
> memory-controller-improve-user-interface.patch
> memory-controller-oom-handling-v7.patch
> memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
> memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
> memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
> memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
> memory-controller-make-page_referenced-container-aware-v7.patch
> memory-controller-make-charging-gfp-mask-aware.patch
> memory-controller-make-charging-gfp-mask-aware-fix.patch
> memory-controller-bug_on.patch
> mem-controller-gfp-mask-fix.patch
> memcontrol-move-mm_cgroup-to-header-file.patch
> memcontrol-move-oom-task-exclusion-to-tasklist.patch
> memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
> oom-add-sysctl-to-enable-task-memory-dump.patch
> kswapd-should-only-wait-on-io-if-there-is-io.patch
> 
>   Hold.  This needs a serious going-over by page reclaim people.
> 

Hi, Andrew,

I mostly agree with your decision. I am a little concerned however
that as we develop and add more features (a.k.a better statistics/
forced reclaim), which are very important; the code base gets larger,
the review takes longer :)

I was hopeful of getting the bare minimal infrastructure for memory
control in mainline, so that review is easy and additional changes
can be well reviewed as well.

Here are the pros and cons of merging the memory controller

Pros
1. Smaller size, easy to review and merge
2. Incremental development, makes it easier to maintain the
   code

Cons
1. Needs more review like you said
2. Although the UI is stable, it's a good chance to review
   it once more before merging the code into mainline

Having said that, I'll continue testing the patches and make the
solution more complete and usable.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
