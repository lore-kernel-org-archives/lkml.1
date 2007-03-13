Return-Path: <linux-kernel-owner+w=401wt.eu-S965458AbXCMIXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965458AbXCMIXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 04:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965478AbXCMIXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 04:23:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53441 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965458AbXCMIXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 04:23:06 -0400
Date: Tue, 13 Mar 2007 09:22:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Con Kolivas <kernel@kolivas.org>
Cc: Mike Galbraith <efault@gmx.de>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Message-ID: <20070313082251.GA26604@elte.hu>
References: <200703111457.17624.kernel@kolivas.org> <8cd998d50703121551u44ea3d85g2541503373f461f4@mail.gmail.com> <1173762639.7944.45.camel@Homer.simpson.net> <200703131653.39415.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703131653.39415.kernel@kolivas.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Con Kolivas <kernel@kolivas.org> wrote:

> > It's not "offensive" to me, it is a behavioral regression.  The 
> > situation as we speak is that you can run cpu intensive tasks while 
> > watching eye-candy.  With RSDL, you can't, you feel the 
> > non-interactive load instantly.  Doesn't the fact that you're asking 
> > me to lower my expectations tell you that I just might have a point?
> 
> Yet looking at the mainline scheduler code, nice 5 tasks are also 
> supposed to get 75% cpu compared to nice 0 tasks, however I cannot 
> seem to get 75% cpu with a fully cpu bound task in the presence of an 
> interactive task. [...]

i'm sorry, but your argument seems to be negated. We of course have no 
problem with interactive tasks stealing CPU time from CPU hogs. The 
situation Mike found is _the other direction_: that /CPU hogs/ stole 
from interactive tasks. That's bad and needs to be fixed. Please?

	Ingo
