Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbYKLNH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbYKLNH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 08:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbYKLNHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 08:07:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51741 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbYKLNHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 08:07:50 -0500
Date: Wed, 12 Nov 2008 14:07:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/2] unlikely profiler and tracer
Message-ID: <20081112130714.GA24472@elte.hu>
References: <20081112051438.843792214@goodmis.org> <20081112105314.GB31958@elte.hu> <alpine.DEB.1.10.0811120800140.2529@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811120800140.2529@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Wed, 12 Nov 2008, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > Ingo,
> > > 
> > > The following patches are in:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > > 
> > >     branch: tip/devel
> > > 
> > > Steven Rostedt (2):
> > >       trace: profile likely and unlikely annotations
> > >       ftrace: unlikely annotation tracer
> > 
> > i've created a new topic branch for this tracer: 
> > tip/tracing/branch-tracer, and applied your patches to that branch. 
> 
> Good idea,
> 
> This profiler is very useful, but also very intrusive. I would like 
> it to get a broader audience for testing.

two more small details i noticed:

 - does it do proper self-test? It doesnt seem so at first sight.

 - i'd suggest a rename patch that does UNLIKELY_PROFILE => BRANCH_PROFILING.

    [ 'to profile' is the verb we use generally (it's a noun too but 
       we tend to use 'profiling' for that in other places of the
       kernel) - so we already have CONFIG_PROFILING, etc. ]

	Ingo
