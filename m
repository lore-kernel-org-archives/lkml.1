Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbZCYNoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbZCYNoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 09:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756813AbZCYNnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 09:43:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59984 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655AbZCYNnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 09:43:50 -0400
Date: Wed, 25 Mar 2009 09:43:47 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 0/5] [PATCH][GIT PULL] remove unnecessary (un)likelys
In-Reply-To: <20090325072501.GC25833@elte.hu>
Message-ID: <alpine.DEB.2.00.0903250943060.5675@gandalf.stny.rr.com>
References: <20090325051920.406564281@goodmis.org> <20090325072501.GC25833@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Mar 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > ----
> >  arch/x86/kernel/ptrace.c |    4 ++--
> >  kernel/sched.c           |    4 ++--
> >  kernel/sched_rt.c        |    2 +-
> >  mm/rmap.c                |    8 ++++----
> >  mm/slab.c                |    2 +-
> >  mm/slob.c                |    2 +-
> >  mm/slub.c                |    2 +-
> >  7 files changed, 12 insertions(+), 12 deletions(-)
> 
> I commented on the ptrace one - i think we should take that one out 
> or at least wait for more info.
> 
> The MM ones look correct. Maybe your kfree observation will be 
> debated - but i think it's probably right that we should not special 
> annotate kfree(NULL) anymore in any direction. But it's ultimately 
> up to the MM folks. (I've Cc:-ed Pekka too)
> 
> The rmap and the scheduler ones definitely look correct. When you 
> rebase, please include the profiler output to 3/5 too.

I'll rebase it to only include the non controversial changes.

Thanks,

-- Steve

