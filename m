Return-Path: <linux-kernel-owner+w=401wt.eu-S1755043AbZCRUKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbZCRUKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 16:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbZCRUKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 16:10:43 -0400
Received: from relay3.ptmail.sapo.pt ([212.55.154.23]:42946 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751082AbZCRUKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 16:10:42 -0400
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Wed, 18 Mar 2009 20:08:29 +0000
From: Luis Henriques <henrix@sapo.pt>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 -tip] sched: Clean unused fields from struct rq
Message-ID: <20090318200829.GA4157@hades.domain.com>
References: <20090318000343.GA2189@hades.domain.com> <1237334969.5189.1242.camel@laptop> <20090318002327.GA2382@hades.domain.com> <49C04F5F.1020700@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C04F5F.1020700@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 17, 2009 at 09:33:19PM -0400, Gregory Haskins wrote:
> >> I think this bit is ABI, so you either have to bump the version number
> >> or emit 0s, iirc gregory touched some of that last -- or at least wrote
> >> userspace for it..
> >>     
> >
> > Hmm... you're right.  I should have though about that.  Anyway, what is the
> > the best approach here?
> >
> > I know that changes in ABI shall not break anything, but just increasing the
> > version number will really solve the issue?  Will userspace care for this?
> > On the other hand, just writting 0s does not sound interesting either...
> >
> >   
> Hi Luis,
>   My app does check the version number, so bumping it is probably the
> best solution.   Be sure to keep me in the loop about whether this patch
> gets merged and I will be sure to update it to handle the new version.

Hi Greg,

(sorry for the _huge_ delay for replying, but my timeslice for lkml is quite
small...)

I'll quickly prepare another patch that also modifies the version and repost it.
Maybe you can then give me more feedback on it.

Thanks for comments.
-- 
Luis Henriques
