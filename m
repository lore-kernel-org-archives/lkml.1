Return-Path: <linux-kernel-owner+w=401wt.eu-S1760513AbXEUK6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760513AbXEUK6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbXEUK6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:58:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59984 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934AbXEUK6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:58:13 -0400
Date: Mon, 21 May 2007 12:58:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>, Bill Huey <billh@gnuppy.monkey.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] lockdep: lock contention tracking
Message-ID: <20070521105803.GA17096@elte.hu>
References: <1179657026.5915.10.camel@lappy> <20070521060446.GA4593@gnuppy.monkey.org> <20070521060828.GB20277@elte.hu> <20070521064150.GC4442@gnuppy.monkey.org> <20070521075013.GA9419@elte.hu> <20070521091848.GB4593@gnuppy.monkey.org> <20070521093639.GA29025@elte.hu> <20070521095547.GA10697@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521095547.GA10697@infradead.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, May 21, 2007 at 11:36:39AM +0200, Ingo Molnar wrote:
> > you got the history wrong i think: the first version of lockdep was 
> > released to lkml a year ago (May 2006), while the first time you 
> > mentioned your lock contention patch was November 2006 and you released 
> > it to lkml in December 2006 - so it was _you_ who was "replicating the 
> > same work", not lockdep :-) And this was pointed out to you very early 
> > on, many months ago.
> 
> And lockmeter, the very first patch of this sort is from the 90s, but 
> got mostly ignored here on lkml, of course :)

i certainly did not ignore lockmeter - i periodically tried it and even 
considered adding it to -rt. But it was always pretty problematic from 
an impact POV:

  23 files changed, 2659 insertions(+), 13 deletions(-)

and nobody pushed strong enough to get it included. But ... Peter's 
patch could perhaps be extended to cover similar stats as lockmeter, 
ontop of the existing lockdep instrumentation. Peter, can you see any 
particular roadblocks with that?

	Ingo
