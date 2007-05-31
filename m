Return-Path: <linux-kernel-owner+w=401wt.eu-S1761251AbXEaJ3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761251AbXEaJ3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 05:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760702AbXEaJ2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 05:28:30 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49807 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760855AbXEaJ23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 05:28:29 -0400
Date: Thu, 31 May 2007 15:06:22 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, ckrm-tech@lists.sourceforge.net,
       efault@gmx.de, Peter Williams <pwil3058@bigpond.net.au>,
       tingy@cs.umass.edu, linux-kernel@vger.kernel.org, kernel@kolivas.org,
       tong.n.li@intel.com, containers@lists.osdl.org,
       Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, Guillaume Chazarain <guichaz@yahoo.fr>
Subject: Re: [ckrm-tech] [RFC] [PATCH 0/3] Add group fairness to CFS
Message-ID: <20070531093622.GB9826@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070526154112.GA31925@holomorphy.com> <20070530171405.GA21062@in.ibm.com> <20070530201359.GD6909@holomorphy.com> <20070531032657.GA823@in.ibm.com> <20070531040926.GH6909@holomorphy.com> <20070531054828.GB663@in.ibm.com> <20070531063647.GC15426@holomorphy.com> <20070531083353.GF663@in.ibm.com> <20070531085600.GA9826@in.ibm.com> <20070531091534.GK6909@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531091534.GK6909@holomorphy.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 02:15:34AM -0700, William Lee Irwin III wrote:
> Yes, the larger number of schedulable entities and hence slower
> convergence to groupwise weightings is a disadvantage of the flattening.
> A hybrid scheme seems reasonable enough. 

Cool! This puts me back on track to implement hierarchical scheduling in
CFS :)

Once this is done and once I can get containers running on a box, I will 
experiment with the flattening trick for user and process levels inside 
containers.

Thanks for your feedback so far!

> Ideally one would chop the
> hierarchy in pieces so that n levels of hierarchy become k levels of n/k
> weight-flattened hierarchies for this sort of attack to be most effective
> (at least assuming similar branching factors at all levels of hierarchy
> and sufficient depth to the hierarchy to make it meaningful) but this is
> awkward to do. Peeling off the outermost container or whichever level is
> deemed most important in terms of accuracy of aggregate enforcement as
> a hierarchical scheduler is a practical compromise.
> 
> Hybrid schemes will still incur the difficulties of hierarchical
> scheduling, but they're by no means insurmountable. Sadly, only
> complete flattening yields the simplifications that make task group
> weighting enforcement orthogonal to load balancing and the like. The
> scheme I described for global nice number behavior is also not readily
> adaptable to hybrid schemes.

-- 
Regards,
vatsa
