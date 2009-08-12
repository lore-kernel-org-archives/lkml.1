Return-Path: <linux-kernel-owner+w=401wt.eu-S932532AbZHLKvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532AbZHLKvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 06:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932468AbZHLKvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 06:51:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44211 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932067AbZHLKvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 06:51:36 -0400
Date: Wed, 12 Aug 2009 12:51:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
Message-ID: <20090812105106.GA7885@elte.hu>
References: <Pine.LNX.4.44L0.0908111659510.5845-100000@iolanthe.rowland.org> <20090812094119.GC14734@elte.hu> <1250074070.10001.33.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250074070.10001.33.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2009-08-12 at 11:41 +0200, Ingo Molnar wrote:
> > * Alan Stern <stern@rowland.harvard.edu> wrote:
> > 
> > > This patch (as1279) adds kerneldoc for flush_scheduled_work()
> > > containing a stern warning that the function should be avoided.
> > > 
> > > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> > >  
> > > +/**
> > > + * flush_scheduled_work - ensure that all work scheduled on keventd_wq has run to completion.
> 
> > > + */
> > 
> > Looks good - a small nit: please use proper/consistent line length, 
> > something like:
> > 
> > /**
> >  * flush_scheduled_work - ensure that all work scheduled on 
> >  *			  keventd_wq has run to completion
> >  *
> 
> >  */
> 
> 
> And here I was thinking kerneldoc doesn't actually work 
> like that, but perhaps Randy fixed it so the initial 
> description can line-wrap?

Ah, the main changes i did were to the body, that is what 
caught my eyes. If KernelDoc doesnt handle line-wrap in the 
first line then that has to stay so. (and KernelDoc needs to 
be fixed as well - it should result in better documentation, 
not worse)

	Ingo
