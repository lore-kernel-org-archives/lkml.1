Return-Path: <linux-kernel-owner+w=401wt.eu-S964896AbXCQHpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964896AbXCQHpy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 03:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965069AbXCQHpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 03:45:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40666 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964896AbXCQHpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 03:45:53 -0400
Date: Sat, 17 Mar 2007 08:45:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nicholas Miell <nmiell@comcast.net>
Cc: Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Al Boldi <a1426z@gawab.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: RSDL v0.31
Message-ID: <20070317074506.GA13685@elte.hu>
References: <200703042335.26785.a1426z@gawab.com> <200703170040.48316.kernel@kolivas.org> <1174059299.7886.25.camel@Homer.simpson.net> <200703170813.32594.kernel@kolivas.org> <1174084207.7009.9.camel@Homer.simpson.net> <1174105443.3144.4.camel@entropy> <1174110965.7911.44.camel@Homer.simpson.net> <1174112768.3144.8.camel@entropy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174112768.3144.8.camel@entropy>
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


* Nicholas Miell <nmiell@comcast.net> wrote:

> The X people have plans for how to go about fixing this, [...]

then we'll first have wait for those X changes to at least be done in a 
minimal manner so that they can be tested for real with RSDL. (is it 
_really_ due to that? Or will X regress forever once we switch to RSDL?) 
We cannot regress the scheduling of a workload as important as "X mixed 
with CPU-intense tasks". And "in theory this should be fixed if X is 
fixed" does not cut it. X is pretty much _the_ most important thing to 
optimize the interactive behavior of a Linux scheduler for. Also, 
paradoxically, it is precisely the improvement of _X_ workloads that 
RSDL argues with.

this regression has to be fixed before RSDL can be merged, simply 
because it is a pretty negative effect that goes beyond any of the 
visible positive improvements that RSDL brings over the current 
scheduler. If it is better to fix X, then X has to be fixed _first_, at 
least in form of a prototype patch that can be _tested_, and then the 
result has to be validated against RSDL.

	Ingo
