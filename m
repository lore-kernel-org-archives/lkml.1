Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbZCKSci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbZCKSci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 14:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbZCKSc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 14:32:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64233 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbZCKSc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 14:32:28 -0400
Date: Wed, 11 Mar 2009 14:32:25 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] tracing: use raw spinlocks for trace_vprintk
In-Reply-To: <20090311182656.GA23739@elte.hu>
Message-ID: <alpine.DEB.2.00.0903111431080.3062@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0903102125250.16494@gandalf.stny.rr.com> <1236754764.22914.3680.camel@twins> <20090311182656.GA23739@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 11 Mar 2009, Ingo Molnar wrote:

> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Tue, 2009-03-10 at 21:26 -0400, Steven Rostedt wrote:
> > 
> > > commit 80370cb758e7ca2692cd9fb5e413d970b1f4b2b2
> > > Author: Steven Rostedt <srostedt@redhat.com>
> > > Date:   Tue Mar 10 17:16:35 2009 -0400
> > > 
> > >     tracing: use raw spinlocks for trace_vprintk
> > >     
> > >     Impact: prevent locking up by lockdep tracer
> > >     
> > >     The lockdep tracer uses trace_vprintk and thus trace_vprintk can not
> > >     call back into lockdep without locking up.
> > 
> > Hmm, I did this when I posted the lockdep tracepoints, so someone then
> > did a bad copy/paste job when renaming ftrace_printk or something?
> > 
> > See efed792d6738964f399a508ef9e831cd60fa4657
> 
> What's the conclusion in this thread? I'm holding the pull 
> until there's agreement.

I believe the conclusion is that Peter's changes got removed when Frederic 
removed the old printk version. But his new version did not have the 
changes.

My changes are basically the same as Peter's except that I did not do 
anything with the local_irq_save, since I do not think those are needed.

Peter,

Are you fine with the change? I guess it's up to you now.

-- Steve

