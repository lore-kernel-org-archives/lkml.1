Return-Path: <linux-kernel-owner+w=401wt.eu-S1763086AbZBYQJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763086AbZBYQJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 11:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761407AbZBYQJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 11:09:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50102 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762301AbZBYQJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 11:09:32 -0500
Date: Wed, 25 Feb 2009 11:09:28 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/4] tracing: add event trace infrastructure
In-Reply-To: <20090225155709.GA12732@elte.hu>
Message-ID: <alpine.DEB.2.00.0902251107350.12697@gandalf.stny.rr.com>
References: <20090225025608.956691460@goodmis.org> <20090225025753.798204550@goodmis.org> <20090224194548.3effb746.akpm@linux-foundation.org> <alpine.DEB.2.00.0902242252480.12697@gandalf.stny.rr.com> <20090224203308.8d623e0b.akpm@linux-foundation.org>
 <20090225081118.GC15303@elte.hu> <20090225002852.5ef5b869.akpm@linux-foundation.org> <84144f020902250100k41e55dd7w8a9c8d2ca96908ea@mail.gmail.com> <20090225012250.db68e480.akpm@linux-foundation.org> <alpine.DEB.2.00.0902250923360.12697@gandalf.stny.rr.com>
 <20090225155709.GA12732@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Feb 2009, Ingo Molnar wrote:
> > Yeah, maybe that file (latency_trace) is a bit too much. I for 
> > one love it. It is great to load a kernel on some remote box, 
> > and run the irqs off latency tracer to see where the 
> > interrupts are disabled for the longest time. This format is 
> > really nice because it shows me when we are in an interrupt, 
> > or interrupts are disabled, and when the task should have been 
> > rescheduled.
> > 
> > This has help find places that we miss a preemption check too.
> 
> Could we get that, as PeterZ has suggested, as a trace_option 
> column in the 'trace' file? It would be default off for 
> non-latency tracers, with latency tracing plugins turning it on 
> by default. Would that work?

Sure, I'd be fine with it as an option. I just don't want to 
completely lose the ability to retrieve that information.

-- Steve

