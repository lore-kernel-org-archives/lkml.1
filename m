Return-Path: <linux-kernel-owner+w=401wt.eu-S1763001AbXGZKub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763001AbXGZKub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 06:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755677AbXGZKuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 06:50:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43765 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674AbXGZKuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 06:50:22 -0400
Date: Thu, 26 Jul 2007 12:50:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [bug] SLUB & freeing locks [was: Re: 2.6.23-rc1: known
	regressions with patches]
Message-ID: <20070726105009.GA7673@elte.hu>
References: <46A47940.7030801@googlemail.com> <20070726091048.GA7366@elte.hu> <1185441963.8197.67.camel@twins> <1185442353.8197.71.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185442353.8197.71.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2007-07-26 at 11:26 +0200, Peter Zijlstra wrote:
> > On Thu, 2007-07-26 at 11:10 +0200, Ingo Molnar wrote:
> > > there's a new regression:
> > > 
> > > SLUB does not seem to call debug_check_no_locks_freed() - hence on SLUB 
> > > we will not notice certain types of freeing races. (such as freeing an 
> > > object still locked and used on another CPU.) SLAB does this corretly.
> 
> Oh, nm, it doesn't call debug_check_no_locks_freed() at all.
> 
> This should do I guess.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

yeah.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
