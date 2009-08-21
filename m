Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbZHUFcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbZHUFcI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 01:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZHUFcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 01:32:07 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:47250 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbZHUFcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 01:32:06 -0400
Date: Fri, 21 Aug 2009 10:58:58 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kamezawa.hiroyu@jp.fujitsu.com, prarit@redhat.com, andi.kleen@intel.com,
       m-kosaki@ceres.dti.ne.jp, dmiyakawa@google.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: Scalability fixes -- 2.6.31 candidate?
Message-ID: <20090821052858.GB29572@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090820190941.GA29572@balbir.in.ibm.com> <20090820161325.562b255e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090820161325.562b255e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [2009-08-20 16:13:25]:

> On Fri, 21 Aug 2009 00:39:42 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > Hi, Andrew,
> > 
> > I've been wondering if the scalability fixes for root overhead in
> > memory cgroup is a candidate for 2.6.31?
> 
> These?
> 
> memcg-improve-resource-counter-scalability.patch
> memcg-improve-resource-counter-scalability-checkpatch-fixes.patch
> memcg-improve-resource-counter-scalability-v5.patch
> 
> 
> > They don't change
> > functionality but help immensely using existing accounting features.
> > 
> > Opening up the email for more debate and discussion and thoughts.
> > 
> 
> They don't apply terribly well to mainline:
> 
> patching file mm/memcontrol.c
> Hunk #1 FAILED at 70.
> Hunk #2 FAILED at 479.
> Hunk #3 FAILED at 1295.
> Hunk #4 FAILED at 1359.
> Hunk #5 FAILED at 1432.
> Hunk #6 FAILED at 1514.
> Hunk #7 FAILED at 1534.
> Hunk #8 FAILED at 1605.
> Hunk #9 FAILED at 1798.
> Hunk #10 FAILED at 1826.
> Hunk #11 FAILED at 1883.
> Hunk #12 FAILED at 1981.
> Hunk #13 succeeded at 2091 (offset -405 lines).
> 12 out of 13 hunks FAILED -- saving rejects to file mm/memcontrol.c.rej
> Failed to apply memcg-improve-resource-counter-scalability
> 
> so maybe you're referring to these:
> 
> memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
> memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
> memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
> 
> as well.
>

Yes, I was referring to those
 
> But then memcg-improve-resource-counter-scalability.patch still doesn't
> apply.  Maybe memcg-improve-resource-counter-scalability.patch depends
> on memory-controller-soft-limit-*.patch too.  I stopped looking.
> 

Yes, there is some diffs that get picked up due to the soft_limit
feature.


> It's a lot of material and a lot of churn.  I'd be more inclined to
> proceed with a 2.6.32 merge and then perhaps you can see if you can
> come up with a minimal patchset for -stable, see if the -stable
> maintainers can be talked into merging it.
> 

Fair enough.. I do have a backport to 2.6.31-rc5 mainline, but going
the stable route would also work.

Thanks!


-- 
	Balbir
