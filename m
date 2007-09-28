Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbXI1Jjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbXI1Jjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 05:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754678AbXI1Jj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 05:39:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52193 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238AbXI1Jj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 05:39:27 -0400
Date: Fri, 28 Sep 2007 11:39:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.10
Message-ID: <20070928093902.GA28455@elte.hu>
References: <bf97f66cfc0696c8574921d53eaafcb7@pinky> <20070928084003.GA18882@elte.hu> <20070928020132.f6c6f528.akpm@linux-foundation.org> <20070928092235.GA31180@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928092235.GA31180@shadowen.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.1.7-deb
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0239]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Whitcroft <apw@shadowen.org> wrote:

> > >   WARNING: multiple assignments should be avoided
> > >   #2319:
> > >   +       max_load = this_load = total_load = total_pwr = 0;
> > 
> > That warning is non-bogus, although this is one of the bogosities 
> > which I personally don't bother fixing or making a fuss about.
> > 
> > But I do think it detracts from the readability of the code, and 
> > from patches which later alter that code.  A bit.
> 
> I tend to agree, watching the automatic replies from checkpatch, the 
> majority of these are "justifiable" in their context.  I think I'll 
> lower this one to a CHECK in the next release.

what matters is that only items should be displayed that i _can_ fix. 
With v8 i was able to make kernel/sched*.c almost noise-free, but with 
v9 and v10 that's not possible anymore. And the moment the default 
output of the tool cannot be made 'empty', we've lost the biggest 
battle. Seeing the same bogus (or borderline) warnings again and again 
destroys the biggest dynamic that could get people to use this tool more 
often: the gratification of having a 'perfectly clean' file/patch.

And this is not about any particular false positive. I dont mind an 
"advanced mode" non-default opt-in option for the script, if someone is 
interested in borderline or hard to judge warnings too, but these 
default false positives are _lethal_ for a tool like this. (and i made 
this point before.) This is a _fundamental_ thing, and i'm still not 
sure whether you accept and understand that point. This is very basic 
and very important, and this isnt the first (or second) time i raised 
this.

	Ingo
