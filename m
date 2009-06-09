Return-Path: <linux-kernel-owner+w=401wt.eu-S1760243AbZFIMDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760243AbZFIMDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 08:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759516AbZFIMDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 08:03:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49128 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758205AbZFIMDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 08:03:43 -0400
Date: Tue, 9 Jun 2009 14:03:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][GIT PULL] ring-buffer: pass in lockdep class key for
	reader_lock
Message-ID: <20090609120331.GA25586@elte.hu>
References: <20090603151724.144915858@goodmis.org> <20090605145219.GA14830@elte.hu> <20090607082257.GA16761@elte.hu> <alpine.DEB.2.00.0906081135320.9522@gandalf.stny.rr.com> <1244477919.13761.9042.camel@twins> <alpine.DEB.2.00.0906081858580.9522@gandalf.stny.rr.com> <20090609112053.GB4463@elte.hu> <alpine.DEB.2.00.0906090743460.17452@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0906090743460.17452@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Tue, 9 Jun 2009, Ingo Molnar wrote:
> 
> > 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > 
> > > Ingo,
> > > 
> > > Please pull the latest tip/tracing/ftrace tree, which can be found at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > > tip/tracing/ftrace
> > > 
> > > 
> > > Peter Zijlstra (1):
> > >       ring-buffer: pass in lockdep class key for reader_lock
> > > 
> > > ----
> > >  include/linux/ring_buffer.h |   14 +++++++++++++-
> > >  kernel/trace/ring_buffer.c  |    9 +++++++--
> > >  2 files changed, 20 insertions(+), 3 deletions(-)
> > 
> > hm, this doesnt pull anything new here - forgot to push it out 
> > perhaps?
> 
> I didn't notice my push failed. It is not a fast forward push. I rebased 
> it against your branch. I just pushed it again now.

Pulled, thanks Steve!

	Ingo
