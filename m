Return-Path: <linux-kernel-owner+w=401wt.eu-S1759978AbZFLOLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759978AbZFLOLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 10:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbZFLOLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 10:11:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40732 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbZFLOLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 10:11:33 -0400
Date: Fri, 12 Jun 2009 16:11:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, paulus@samba.org,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: origin tree build failure
Message-ID: <20090612141118.GK32105@elte.hu>
References: <20090612102427.32582baa.sfr@canb.auug.org.au> <1244768406.7172.1.camel@pasglop> <20090612092054.GB32052@elte.hu> <1244799197.7172.106.camel@pasglop> <20090612125335.GH31845@elte.hu> <1244812224.7172.146.camel@pasglop> <1244813397.7172.156.camel@pasglop> <20090612134940.GD32105@elte.hu> <1244815574.7172.171.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244815574.7172.171.camel@pasglop>
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


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Fri, 2009-06-12 at 15:49 +0200, Ingo Molnar wrote:
> > * Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> > 
> > > On Fri, 2009-06-12 at 23:10 +1000, Benjamin Herrenschmidt wrote:
> > > > On Fri, 2009-06-12 at 14:53 +0200, Ingo Molnar wrote:
> > > 
> > > > To some extent, here, the issue is on Linus side and it's up to him (Hey
> > > > Linus ! still listening ?) to maybe be more proactive at giving an ack
> > > > or nack so that we can get a chance to do that final pass of ironing out
> > > > the mechanical bugs before we hit the main tree.
> > > 
> > > Let me add a little bit more background to my reasoning here and why I
> > > think having this integration testing step is so valuable...
> > > 
> > > It all boils down to bisection and having a bisectable tree.
> > 
> > I think you are way too concentrated on this particular incident, 
> > and you are generalizing it into something that is not so in 
> > practice.
> 
> Maybe. But maybe it's representative... so far in this merge 
> window, 100% of the powerpc build and runtime breakage upstream 
> comes from stuff that didn't get into -next before.

But that's axiomatic, isnt it? linux-next build-tests PowerPC as the 
first in the row of tests - so no change that was in linux-next can 
ever cause a build failure on PowerPC, right?

	Ingo
