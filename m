Return-Path: <linux-kernel-owner+w=401wt.eu-S1759011AbZFILpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759011AbZFILpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 07:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbZFILpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 07:45:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55326 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865AbZFILpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 07:45:00 -0400
Date: Tue, 9 Jun 2009 07:44:59 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][GIT PULL] ring-buffer: pass in lockdep class key for
 reader_lock
In-Reply-To: <20090609112053.GB4463@elte.hu>
Message-ID: <alpine.DEB.2.00.0906090743460.17452@gandalf.stny.rr.com>
References: <20090603151724.144915858@goodmis.org> <20090605145219.GA14830@elte.hu> <20090607082257.GA16761@elte.hu> <alpine.DEB.2.00.0906081135320.9522@gandalf.stny.rr.com> <1244477919.13761.9042.camel@twins> <alpine.DEB.2.00.0906081858580.9522@gandalf.stny.rr.com>
 <20090609112053.GB4463@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 9 Jun 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > Ingo,
> > 
> > Please pull the latest tip/tracing/ftrace tree, which can be found at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > tip/tracing/ftrace
> > 
> > 
> > Peter Zijlstra (1):
> >       ring-buffer: pass in lockdep class key for reader_lock
> > 
> > ----
> >  include/linux/ring_buffer.h |   14 +++++++++++++-
> >  kernel/trace/ring_buffer.c  |    9 +++++++--
> >  2 files changed, 20 insertions(+), 3 deletions(-)
> 
> hm, this doesnt pull anything new here - forgot to push it out 
> perhaps?

I didn't notice my push failed. It is not a fast forward push. I rebased 
it against your branch. I just pushed it again now.

-- Steve

