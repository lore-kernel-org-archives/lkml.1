Return-Path: <linux-kernel-owner+w=401wt.eu-S1760784AbZCXPmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760784AbZCXPmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbZCXPlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:41:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37202 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbZCXPlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:41:52 -0400
Date: Tue, 24 Mar 2009 16:41:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Luis Henriques <henrix@sapo.pt>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 -tip] sched: Clean unused fields from struct rq
Message-ID: <20090324154130.GC31143@elte.hu>
References: <20090318225137.GA3766@hades.domain.com> <20090323175224.GA3938@hades.domain.com> <20090324140419.GD32043@elte.hu> <49C8FA99.9030503@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C8FA99.9030503@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gregory Haskins <ghaskins@novell.com> wrote:

> Ingo Molnar wrote:
> > * Luis Henriques <henrix@sapo.pt> wrote:
> >
> >   
> >> On Wed, Mar 18, 2009 at 10:51:37PM +0000, Luis Henriques wrote:
> >>     
> >>> Since they are used on in statistics and are always set to zero, the following
> >>> fields from struct rq have been removed: yld_exp_empty, yld_act_empty and
> >>> yld_both_empty.
> >>>
> >>> Both Sched Debug and SCHEDSTAT_VERSION versions has also been incremented since
> >>> ABIs have been changed.
> >>>
> >>>       
> >> Hi Ingo,
> >>
> >> Sorry to bother you but I can not find this patch in -tip.  Just 
> >> would like to confirm with you that it was NACK'ed or you just 
> >> forgot to merge it to the tree.
> >>     
> >
> > Was held up by the schedstat tool discussions. Please resend the 
> > patch with a link to the updated tool in the commit log perhaps (if 
> > such a link exists), and with Gregory's ack in place.
> >
> > Thanks,
> >
> > 	Ingo
> >   
> Hi Ingo,
>   I was waiting to merge the tool patch until I was sure this would be
> your blessed v15 of the ABI.  If you are comfy with the kernel patch but
> want the tool updated before the kernel, I can do that, no problem.  The
> only thing that I ask is that if for some reason this kernel patch
> doesn't make it in, please require any future patches that change this
> ABI to be versioned > 15 ;)

How about moving schedstat to Documentation/sched/schedstat.c or so? 
It's small and trivial enough, and that way changes would go hand in 
hand with the app.

	Ingo
