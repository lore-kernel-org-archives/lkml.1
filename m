Return-Path: <linux-kernel-owner+w=401wt.eu-S1756532AbZCROBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbZCROBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 10:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbZCROA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 10:00:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51727 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbZCROA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 10:00:56 -0400
Date: Wed, 18 Mar 2009 10:00:52 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/ftrace: stop {irqs,preempt}soff tracers when
 tracing is stopped
In-Reply-To: <20090318085957.GB15416@elte.hu>
Message-ID: <alpine.DEB.2.00.0903181000370.10610@gandalf.stny.rr.com>
References: <1237325938-5240-1-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.0903171745440.9036@gandalf.stny.rr.com> <20090317214926.GA5137@nowhere> <alpine.DEB.2.00.0903171757320.9036@gandalf.stny.rr.com> <20090317225454.GA5143@nowhere>
 <20090318085957.GB15416@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Wed, 18 Mar 2009, Ingo Molnar wrote:
> > 
> > I tested the call to the start/stop callbacks from tracing_start() 
> > and tracing_stop() but it's not possible for now: the sched_switch 
> > tracer register/unregister his tracepoints from these callbacks, 
> > thus allocate some memory. But tracing_start/stop can be called 
> > from atomic.
> > 
> > I discussed about that with Steven on irc, and for now the v1 
> > should be applied as a temporary solution. We plan to simplify 
> > later the start/stop callbacks from each tracers that need it.
> 
> ok. Steve, could you please pick v1 up?

Will do.

-- Steve

