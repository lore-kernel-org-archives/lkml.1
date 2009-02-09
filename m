Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbZBIQHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbZBIQHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 11:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620AbZBIQHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 11:07:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62042 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262AbZBIQHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 11:07:45 -0500
Date: Mon, 9 Feb 2009 11:07:44 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/5] tracing/core: drop the cpu field from trace_entry
In-Reply-To: <20090209140321.GA20758@elte.hu>
Message-ID: <alpine.DEB.1.10.0902091106410.14528@gandalf.stny.rr.com>
References: <498e176a.0637560a.3cea.3ff8@mx.google.com> <20090209095324.GD14402@elte.hu> <20090209134744.GC4705@nowhere> <20090209140321.GA20758@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 9 Feb 2009, Ingo Molnar wrote:

> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Mon, Feb 09, 2009 at 10:53:24AM +0100, Ingo Molnar wrote:
> > > 
> > > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > 
> > > > Impact: fix a bug on cpu output
> > > > 
> > > > While looking on the function tracer traces, I first cheered up:
> > > > 
> > > >             TASK-PID    CPU#    TIMESTAMP  FUNCTION
> > > >                | |       |          |         |
> > > >          firefox-4622  [081]  1315.790405: lapic_next_event <-clockevents_program_event
> > > >          firefox-4622  [178]  1315.790405: native_apic_mem_write <-lapic_next_event
> > > >          firefox-4622  [020]  1315.790406: perf_counter_unthrottle <-smp_apic_timer_interrupt
> > > > 
> > > > But no, actually I don't have so many cpus...
> > > 
> > > incidentally, Steve came up with the exact same patch :)
> > > 
> > > 	Ingo
> > 
> > Heh, I guess the moon inspired both of us in the name of tracing, or
> > something like that...
> 
> It was exactly at around the time Thomas complained over IRC
> about the visible CPU# breakage in the tracer output.
> 
> So i blame it on telepathy ;-)

Thomas was the full moon, his complaint to me was the reason I pushed it 
out ASAP.

-- Steve

