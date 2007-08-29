Return-Path: <linux-kernel-owner+w=401wt.eu-S1760125AbXH2DqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760125AbXH2DqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 23:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbXH2Dp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 23:45:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59352 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbXH2Dp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 23:45:57 -0400
Date: Wed, 29 Aug 2007 05:45:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Al Boldi <a1426z@gawab.com>, Peter Zijlstra <peterz@infradead.org>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070829034542.GA32164@elte.hu>
References: <200708111344.42934.a1426z@gawab.com> <200708220127.30698.a1426z@gawab.com> <20070824134510.GA21382@elte.hu> <200708260127.32238.a1426z@gawab.com> <46D4E9FE.6080306@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D4E9FE.6080306@tmr.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.1.7-deb
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0325]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Bill Davidsen <davidsen@tmr.com> wrote:

> > There is another way to show the problem visually under X 
> > (vesa-driver), by starting 3 gears simultaneously, which after 
> > laying them out side-by-side need some settling time before 
> > smoothing out.  Without __update_curr it's absolutely smooth from 
> > the start.
> 
> I posted a LOT of stuff using the glitch1 script, and finally found a 
> set of tuning values which make the test script run smooth. See back 
> posts, I don't have them here.

but you have real 3D hw and DRI enabled, correct? In that case X uses up 
almost no CPU time and glxgears makes most of the processing. That is 
quite different from the above software-rendering case, where X spends 
most of the CPU time.

	Ingo
