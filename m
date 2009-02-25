Return-Path: <linux-kernel-owner+w=401wt.eu-S1761398AbZBYQ3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761398AbZBYQ3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 11:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756486AbZBYQ3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 11:29:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33981 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbZBYQ3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 11:29:04 -0500
Date: Wed, 25 Feb 2009 11:28:59 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/4] tracing: add DEFINE_TRACE_FMT to tracepoint.h
In-Reply-To: <20090225161335.GB11295@Krystal>
Message-ID: <alpine.DEB.2.00.0902251125490.12697@gandalf.stny.rr.com>
References: <20090225025608.956691460@goodmis.org> <20090225025753.547618424@goodmis.org> <20090225161335.GB11295@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Feb 2009, Mathieu Desnoyers wrote:

> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > This patch creates a DEFINE_TRACE_FMT to map to DECLARE_TRACE.
> > This allows for the developers to place format strings and
> > args in with their tracepoint declaration. A tracer may now
> > override the DEFINE_TRACE_FMT macro and use it to record
> > a default format.
> > 
> 
> Hi Steven,
> 
> How comes does a DEFINE_* maps to a DECLARE_* ?
> 
> Usually, DEFINE_* are meant to be put in .c files. DECLARE_* are in
> headers. I don't see how the mapping you propose here can be
> semantically correct ?

Because it can be either a define or a declare ;-)

Gag, I can't win! First Andrew points out that I use DECLARE_TRACE_FMT 
when it should be a DEFINE. Now I go change it and you state that it 
should be a DECLARE not a DEFINE!


Well, any tracer that remaps it, it should be a DEFINE. Just in the 
"default" case of trace points, is it used as a DECLARE. Because, it 
ignores the fmt parameter that would be used in the define.

-- Steve

