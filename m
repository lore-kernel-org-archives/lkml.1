Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbZBYNzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbZBYNzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 08:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbZBYNyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 08:54:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37608 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbZBYNyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 08:54:46 -0500
Date: Wed, 25 Feb 2009 08:54:43 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
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
In-Reply-To: <49A50D9D.2030400@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0902250852280.12697@gandalf.stny.rr.com>
References: <20090225025608.956691460@goodmis.org> <20090225025753.798204550@goodmis.org> <49A50D9D.2030400@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Feb 2009, Lai Jiangshan wrote:

> Steven Rostedt ??:
> > 
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> > ---
> >  include/asm-generic/vmlinux.lds.h |   11 ++-
> >  kernel/trace/Kconfig              |    9 ++
> >  kernel/trace/Makefile             |    1 +
> >  kernel/trace/trace_events.c       |  280 +++++++++++++++++++++++++++++++++++++
> >  kernel/trace/trace_events.h       |   52 +++++++
> >  5 files changed, 352 insertions(+), 1 deletions(-)
> >  create mode 100644 kernel/trace/trace_events.c
> >  create mode 100644 kernel/trace/trace_events.h
> > 
> 
> Modules can not use this infrastructure,
> will it be implemented in future?

"Give that man a cigar!"  ;-)  (old saying about someone that answers the 
                                game show question correctly).

I was waiting for this question to come up.  The answer is, "Yes", I have 
plans to add implementation to make it work with modules.

-- Steve

