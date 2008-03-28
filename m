Return-Path: <linux-kernel-owner+w=401wt.eu-S1758274AbYC1UeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbYC1UeF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755051AbYC1Udz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:33:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43574 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754951AbYC1Udy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:33:54 -0400
Date: Fri, 28 Mar 2008 21:33:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pawel Staszewski <pstaszewski@artcom.pl>,
       Christoph Lameter <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
Message-ID: <20080328203314.GC26555@elte.hu>
References: <200803272353.51901.rjw@sisk.pl> <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org> <200803281710.44576.rjw@sisk.pl> <alpine.LFD.1.00.0803280938430.14670@woody.linux-foundation.org> <20080328173642.GG32200@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328173642.GG32200@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Adrian Bunk <bunk@kernel.org> wrote:

> But that was one year ago when we had only half as many regressions 
> per release as they do now, with 2.6.25 we had a peak of 66 pending 
> regressions...

we have twice as many commits, and we have better test coverage. I get 
the impression that user trust is coming back as well: regressions are 
being reported sooner and more persistently - because we are handling 
them in a more structured and more dependable way. We also seem to have 
more users of latest -git.

so it _appears_ to be an increase in bugginess but i believe it's an 
increase of activity and it's all good IMO, we close 90% of the 
regressions within a week or two, and most of the regressions are for 
obscure cases.

I had 2.6.25 running on most of my boxes from -rc1 on without any 
unprovoked crash. (provoked bugs were another matter) Bisection became 
more practical and more widespread as well. And i periodically find bugs 
that came from ancient kernels so we are fixing bugs faster than we put 
them in i think. I didnt have that feeling in the .18-.19 kernels.

also, now that the kerneloops.org client is in Fedora 9 by default, 
we'll start to have really objective long-term statistics about how our 
users react to the bugs we put into the kernel.

	Ingo
