Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbZBINsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbZBINsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:48:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698AbZBINrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:47:52 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:59250 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711AbZBINrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:47:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Xp4Ky9JGZI9KYwNEtEDYetwks9F3KkZuYM9Zlp5u6xZHLTJhaLm7WRU1+aarvJ/h3l
         Vs7kpci4z8ozmcqHjtjeUVwv/zY+wA2cfPpTXxYPV6H6vpxIYrtyJutZ/2muGvgcsom/
         sRwmxjiPvUwQ1l6P5wjqUTjx4xkNdw4ss9kck=
Date: Mon, 9 Feb 2009 14:47:46 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] tracing/core: drop the cpu field from trace_entry
Message-ID: <20090209134744.GC4705@nowhere>
References: <498e176a.0637560a.3cea.3ff8@mx.google.com> <20090209095324.GD14402@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209095324.GD14402@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 10:53:24AM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Impact: fix a bug on cpu output
> > 
> > While looking on the function tracer traces, I first cheered up:
> > 
> >             TASK-PID    CPU#    TIMESTAMP  FUNCTION
> >                | |       |          |         |
> >          firefox-4622  [081]  1315.790405: lapic_next_event <-clockevents_program_event
> >          firefox-4622  [178]  1315.790405: native_apic_mem_write <-lapic_next_event
> >          firefox-4622  [020]  1315.790406: perf_counter_unthrottle <-smp_apic_timer_interrupt
> > 
> > But no, actually I don't have so many cpus...
> 
> incidentally, Steve came up with the exact same patch :)
> 
> 	Ingo

Heh, I guess the moon inspired both of us in the name of tracing, or
something like that...

Anyway, thanks for having applied the other patches :-)

