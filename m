Return-Path: <linux-kernel-owner+w=401wt.eu-S1760377AbXI1Jpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760377AbXI1Jpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 05:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759222AbXI1JpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 05:45:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46297 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758950AbXI1JpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 05:45:08 -0400
Date: Fri, 28 Sep 2007 11:44:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.10
Message-ID: <20070928094446.GB28455@elte.hu>
References: <bf97f66cfc0696c8574921d53eaafcb7@pinky> <20070928084003.GA18882@elte.hu> <20070928020132.f6c6f528.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928020132.f6c6f528.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 28 Sep 2007 10:40:03 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > i ran it over kernel/sched.c and there are many bogus warnings that i 
> > reported to you earlier:
> > 
> >   WARNING: multiple assignments should be avoided
> >   #2319:
> >   +       max_load = this_load = total_load = total_pwr = 0;
> 
> That warning is non-bogus, although this is one of the bogosities 
> which I personally don't bother fixing or making a fuss about.
> 
> But I do think it detracts from the readability of the code, and from 
> patches which later alter that code.  A bit.

well, the two variants is:

	max_load = this_load = total_load = total_pwr = 0;

	max_load = 0;
	this_load = 0;
	total_load = 0;
	total_pwr = 0;

and the first one is more readable and more compact. (as long as the 
conceptual 'type' of the variables is the same - which it is in this 
case.)

anyway, this is something where reasonable people might disagree, and a 
tool should not force it one way or another. And this is the second time 
i raised this very example and Andy ignored my feedback and failed to 
notice the structural problem behind it (that a tool should only warn by 
default if it is _sure_ that there is a problem - otherwise the tool 
cannot be used for effective [i.e. automated] quality control), so i'm 
raising this point again, in a slightly more irritated tone ;-)

	Ingo
