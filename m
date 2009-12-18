Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbZLRNG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbZLRNG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 08:06:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751050AbZLRNGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 08:06:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47986 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbZLRNGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 08:06:53 -0500
Date: Fri, 18 Dec 2009 14:06:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Jason Garrett-Glaser <darkshikari@gmail.com>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: x264 benchmarks BFS vs CFS
Message-ID: <20091218130642.GA17033@elte.hu>
References: <1261042383.14314.0.camel@localhost>
 <28f2fcbc0912170242r6d93dfb1j337558a829e21a75@mail.gmail.com>
 <20091217105316.GB26010@elte.hu>
 <1261047618.14314.6.camel@localhost>
 <28f2fcbc0912171718x271520b4k5da3376b5182d88a@mail.gmail.com>
 <20091218052344.GD417@elte.hu>
 <1261121405.30469.8.camel@marge.simson.net>
 <28f2fcbc0912180211we599252v39cb94d113537eb5@mail.gmail.com>
 <1261140546.15591.5.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261140546.15591.5.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> > I'm personally curious as to what kind of scheduler issues this results 
> > in--I haven't done any BFS vs CFS tests with this option enabled yet.
> 
> I'll look for x264 source, and patch/piddle.

btw., would be nice to look at it via tools/perf/ as well:

  perf stat --repeat 3 ...

to see the basic hardware utilization (cycles/cache-misses, branch execution 
rate, instructions, etc.) and the basic parallelism metrics, at a glance.

i suspect "perf stat -e L1-icache-loads -e L1-icache-load-misses" would give 
us an even more detailed picture.

	Ingo
