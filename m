Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbZBIODp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbZBIODp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 09:03:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbZBIODh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 09:03:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60217 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbZBIODg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 09:03:36 -0500
Date: Mon, 9 Feb 2009 15:03:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/5] tracing/core: drop the cpu field from trace_entry
Message-ID: <20090209140321.GA20758@elte.hu>
References: <498e176a.0637560a.3cea.3ff8@mx.google.com> <20090209095324.GD14402@elte.hu> <20090209134744.GC4705@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209134744.GC4705@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Mon, Feb 09, 2009 at 10:53:24AM +0100, Ingo Molnar wrote:
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > Impact: fix a bug on cpu output
> > > 
> > > While looking on the function tracer traces, I first cheered up:
> > > 
> > >             TASK-PID    CPU#    TIMESTAMP  FUNCTION
> > >                | |       |          |         |
> > >          firefox-4622  [081]  1315.790405: lapic_next_event <-clockevents_program_event
> > >          firefox-4622  [178]  1315.790405: native_apic_mem_write <-lapic_next_event
> > >          firefox-4622  [020]  1315.790406: perf_counter_unthrottle <-smp_apic_timer_interrupt
> > > 
> > > But no, actually I don't have so many cpus...
> > 
> > incidentally, Steve came up with the exact same patch :)
> > 
> > 	Ingo
> 
> Heh, I guess the moon inspired both of us in the name of tracing, or
> something like that...

It was exactly at around the time Thomas complained over IRC
about the visible CPU# breakage in the tracer output.

So i blame it on telepathy ;-)

	Ingo
