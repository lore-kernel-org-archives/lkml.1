Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbZBOTIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbZBOTIb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 14:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbZBOTIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 14:08:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44444 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111AbZBOTIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 14:08:06 -0500
Date: Sun, 15 Feb 2009 20:07:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] ftrace: updates for 2.6.29
Message-ID: <20090215190731.GA10534@elte.hu>
References: <20090109002747.240318148@goodmis.org> <20090111030641.GJ7077@elte.hu> <20090215205846.4d96260b@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090215205846.4d96260b@daedalus.pq.iki.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Paalanen <pq@iki.fi> wrote:

> On Sun, 11 Jan 2009 04:06:41 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
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
> > > 
> > > Pekka Paalanen (3):
> > >       doc: mmiotrace.txt, buffer size control change
> > >       trace: mmiotrace to the tracer menu in Kconfig
> > >       mmiotrace: count events lost due to not recording
> > > 
> > > ----
> > >  Documentation/tracers/mmiotrace.txt |    6 ++----
> > >  arch/x86/Kconfig.debug              |   24 ++----------------------
> > >  kernel/trace/Kconfig                |   23 +++++++++++++++++++++++
> > >  kernel/trace/trace_mmiotrace.c      |   14 ++++++++++----
> > >  4 files changed, 37 insertions(+), 30 deletions(-)
> > 
> > pulled into tip/tracing/urgent, thanks Steve!
> 
> Hi,
> 
> I was just diffing linus/master to Ingo's tip/master, and I see the
> "mmiotrace: count events lost due to not recording" being added in
> tip/master. The doc and Kconfig updates also, nothing is in linus'.
> 
> I thought all these were going into 2.6.29. What happened?

The urgent marker got lost. [There were a bunch of changes originally
destined for .29 but then delayed to .30.]

I've queued them up for .29-rc6 into tip:tracing/urgent:

 [tracing/urgent 391b170] mmiotrace: count events lost due to not recording
 [tracing/urgent 6bc5c36] trace: mmiotrace to the tracer menu in Kconfig
 [tracing/urgent f9aa28a] doc: mmiotrace.txt, buffer size control change

It never hurts to double-check the routing and status of your commits.

Thanks,

	Ingo
