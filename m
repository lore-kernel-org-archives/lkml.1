Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbXH1ICt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbXH1ICt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 04:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbXH1ICe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 04:02:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35043 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbXH1ICb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 04:02:31 -0400
Date: Tue, 28 Aug 2007 10:02:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: Al Boldi <a1426z@gawab.com>, Peter Zijlstra <peterz@infradead.org>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070828080218.GA12247@elte.hu>
References: <200708111344.42934.a1426z@gawab.com> <200708271746.47685.a1426z@gawab.com> <20070827204116.GA12495@elte.hu> <200708280737.53439.a1426z@gawab.com> <1188287015.1131.232.camel@frg-rhel40-em64t-04>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188287015.1131.232.camel@frg-rhel40-em64t-04>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Xavier Bestel <xavier.bestel@free.fr> wrote:

> Are you sure they are stalled ? What you may have is simple gears 
> running at a multiple of your screen refresh rate, so they only appear 
> stalled.
> 
> Plus, as said Linus, you're not really testing the kernel scheduler. 
> gears is really bad benchmark, it should die.

i like glxgears as long as it runs on _real_ 3D hardware, because there 
it has minimal interaction with X and so it's an excellent visual test 
about consistency of scheduling. You can immediately see (literally) 
scheduling hickups down to a millisecond range (!). In this sense, if 
done and interpreted carefully, glxgears gives more feedback than many 
audio tests. (audio latency problems are audible, but on most sound hw 
it takes quite a bit of latency to produce an xrun.) So basically 
glxgears is the "early warning system" that tells us about the potential 
for xruns earlier than an xrun would happen for real.

[ of course you can also run all the other tools to get numeric results,
  but glxgears is nice in that it gives immediate visual feedback. ]

but i agree that on a non-accelerated X setup glxgears is not really 
meaningful. It can have similar "spam the X server" effects as xperf.

	Ingo
