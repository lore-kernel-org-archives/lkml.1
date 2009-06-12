Return-Path: <linux-kernel-owner+w=401wt.eu-S1764695AbZFLOIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764695AbZFLOIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 10:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbZFLOHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 10:07:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40732 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756148AbZFLOHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 10:07:52 -0400
Date: Fri, 12 Jun 2009 16:07:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, paulus@samba.org,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: origin tree build failure
Message-ID: <20090612140730.GJ32105@elte.hu>
References: <20090612102427.32582baa.sfr@canb.auug.org.au> <1244768406.7172.1.camel@pasglop> <20090612092054.GB32052@elte.hu> <1244799197.7172.106.camel@pasglop> <20090612125335.GH31845@elte.hu> <1244812224.7172.146.camel@pasglop> <20090612134428.GC32105@elte.hu> <1244814976.7172.164.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244814976.7172.164.camel@pasglop>
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

> On Fri, 2009-06-12 at 15:44 +0200, Ingo Molnar wrote:
> 
> > This is certainly doable for agreeable features - which is the bulk 
> > - and it is being done.
> > 
> > But this is a catch-22 for _controversial_ new features - which 
> > perfcounters clearly was, in case you turned off your lkml 
> > subscription ;-)
> 
> I didn't :-) My point here is that Linus can make a decision with 
> an email -before- merging so that -next gets a chance, at least 
> for a couple of days, to do the integration testing once the 
> controversy has been sorted by his highness.

Uhm, the bug you are making a big deal of would have been found and 
fixed by Paulus a few hours after any such mail - and probably by me 
too as i do daily cross builds to Power.

So yes, we had a bug, but any extra linux-next hoops would not have 
prevented it: i could still have messed up by getting lured by that 
nice piece of Power7 hardware enablement patch on the last day ;-)

So the bug was my fault for being too fast-and-loose with that 
particular patch, creating a ~5-commits-hop build breakage bisection 
window on Power.

Now that i'm sufficiently chastised, can we now move on please? :)

	Ingo
