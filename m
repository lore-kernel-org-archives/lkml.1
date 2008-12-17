Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758478AbYLQCfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758478AbYLQCfX (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 21:35:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbYLQCfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 21:35:07 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:57034 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbYLQCfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 21:35:06 -0500
Date: Wed, 17 Dec 2008 08:04:53 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] sched: Use RCU variant of list traversal in
	for_each_leaf_rt_rq()
Message-ID: <20081217023453.GA4146@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20081215062648.GB4337@in.ibm.com> <20081216203957.GB14787@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216203957.GB14787@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 09:39:57PM +0100, Ingo Molnar wrote:
> 
> * Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:
> 
> > sched: Use RCU variant of list traversal in for_each_leaf_rt_rq()
> > 
> > for_each_leaf_rt_rq() walks an RCU protected list (rq->leaf_rt_rq_list),
> > but doesn't use list_for_each_entry_rcu(). Fix this.
> > 
> > Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> > ---
> >  kernel/sched_rt.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> applied to tip/sched/urgent, thanks Bharata!
> 
> i'm wondering, have you observed a real crash, or did you find this via 
> code review?

Via code review.

Thanks,
Bharata.
