Return-Path: <linux-kernel-owner+w=401wt.eu-S1753372AbZHMHZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbZHMHZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 03:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbZHMHZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 03:25:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45152 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837AbZHMHZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 03:25:35 -0400
Date: Thu, 13 Aug 2009 09:25:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andy Whitcroft <apw@canonical.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
Message-ID: <20090813072514.GF12143@elte.hu>
References: <Pine.LNX.4.44L0.0908121005370.2955-100000@iolanthe.rowland.org> <1250094123.4000.43.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250094123.4000.43.camel@mulgrave.site>
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


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Wed, 2009-08-12 at 10:13 -0400, Alan Stern wrote:
> > On Wed, 12 Aug 2009, Ingo Molnar wrote:
> > 
> > > > And here I was thinking kerneldoc doesn't actually work 
> > > > like that, but perhaps Randy fixed it so the initial 
> > > > description can line-wrap?
> > 
> > Yes, that's what I thought too.  If kerneldoc has been fixed 
> > then the description line certainly should get wrapped.
> 
> I really don't think it needs to be fixed: it's a feature not a 
> bug.  It requires people writing kernel doc actually to think of 
> one line summaries.

As long as the argument is that it's good to have limitations just 
because it has good effects as well (which the gist of your argument 
seems to be), i disagree.

That's a very basic argument of freedom. Just consider the Gestapo 
which was also a 'feature' to keep criminals in check. Did you know 
that there were record low levels of petty criminality both in nazi 
Germany and during communism (and under just about any totalitarian 
regime)? Still nobody in their right mind is arguing that just due 
to that they are the right social model ...

I think this DocBook limitation needs to be fixed, because there are 
legitimate cases where a function name got too long (for no fault of 
its own, but for properties of the name-space it is operating in), 
and we do not want a nanny state beat it into a single line.

> LSI recently tried to submit a ten line wrapped summary which the 
> current feature makes it very easy to knock back and say this must 
> be a single line, so trim it and move the rest to the function 
> description body.

Uhm, the democratic solution for _that_ problem is to add a very 
simple check/warning to checkpatch.pl.

Freedom to use common sense and stuff. That principle is in the US 
Constitution as well, or something quite similar to that, right? ;-)

	Ingo
