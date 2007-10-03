Return-Path: <linux-kernel-owner+w=401wt.eu-S1756896AbXJCIUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbXJCIUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 04:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbXJCIT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 04:19:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40416 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbXJCITz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 04:19:55 -0400
Date: Wed, 3 Oct 2007 10:19:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mel Gorman <mel@skynet.ie>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
Message-ID: <20071003081938.GA32218@elte.hu>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <1191326858.28962.8.camel@localhost> <20071002121556.GA22864@elte.hu> <20071002172135.GA12182@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071002172135.GA12182@skynet.ie>
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


* Mel Gorman <mel@skynet.ie> wrote:

> On (02/10/07 14:15), Ingo Molnar didst pronounce:
> > 
> > * Mel Gorman <mel@csn.ul.ie> wrote:
> > 
> > > Dirt. Booting with "profile=sleep,2" is broken in 2.6.23-rc9 and 
> > > 2.6.23-rc8 but working in 2.6.22. I was checking it out as part of a 
> > > discussion in another thread and noticed it broken in -mm as well 
> > > (2.6.23-rc8-mm2). Bisect is in progress but suggestions as to the 
> > > prime candidates are welcome or preferably, pointing out that I'm an 
> > > idiot because I missed twiddling some config change.
> > 
> > Mel, does the patch below fix this bug for you? (Note: you will need to 
> > enable CONFIG_SCHEDSTATS=y too.)
> 
> Nice one Ingo - got it first try. The problem commit was 
> dd41f596cda0d7d6e4a8b139ffdfabcefdd46528 and it's clear that the code 
> removed in this commit is put back by this latest patch.  When 
> applied, profile=sleep works as long as CONFIG_SCHEDSTAT is set.

great - thanks for testing it. I'm glad you caught it as sleep=profile 
is pretty useful in "why is my system so slow" tests. (which problems 
are usually reported _after_ a stable kernel is released ...)

	Ingo
