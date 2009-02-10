Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbZBJOjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbZBJOjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 09:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbZBJOjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 09:39:43 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:54788 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbZBJOjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:39:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Y6usk5ei/VFbcGyd6x3XPvY4KI8ReUmyqw6ltnrrE8A381/sJq5eDJV+0MeB23+hvg
         vRWZAoweHMhDMDKG9lu6W6xyPUrvnR3kTVlJp+dx5w3TCpbZLtiIRiHv28dpkesIhZYn
         hRCbQniUXVX8o1amA2loBwEbXZKb4d8eH5CRY=
Date: Tue, 10 Feb 2009 15:39:38 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 1/2] tracing/sysprof: add missing
	tracing_{start,stop}_record_cmdline()
Message-ID: <20090210143937.GC5836@nowhere>
References: <4990fdb7.0e0f660a.1d27.5399@mx.google.com> <20090210122726.GA21531@elte.hu> <20090210123145.GA1403@elte.hu> <20090210141052.GA5836@nowhere> <alpine.DEB.1.10.0902100922230.23505@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902100922230.23505@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 09:26:11AM -0500, Steven Rostedt wrote:
> 
> On Tue, 10 Feb 2009, Frederic Weisbecker wrote:
> 
> Hi Frederic!
> 
> Just a quick comment about the change log. I'm still learning how to
> write them too, but I'll give my 2 cents anyway ;-)
> 
> When looking a logs, I sometimes like to know the reason for the change.
> So below I would have also included...
> 
> > 
> > --
> > >From 97113f668e9aef7ba101fbb3399e5ebb27aeec4c Mon Sep 17 00:00:00 2001
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> > Date: Tue, 10 Feb 2009 15:07:22 +0100
> > Subject: [PATCH] tracing/sysprof: fix a build error on sysprof tracer
> > 
> 
> The sysprof tracer gets the command line data from the context switch 
> tracer. We must select it otherwise we get 
> 
> >  the following build error:
> > 
> > kernel/built-in.o: In function `stack_trace_reset':
> > trace_sysprof.c:(.text+0x3e91a): undefined reference to `tracing_stop_cmdline_record'
> > kernel/built-in.o: In function `stack_trace_init':
> > trace_sysprof.c:(.text+0x3e953): undefined reference to `tracing_start_cmdline_record'
> > 
> > Reported-by: Ingo Molnar <mingo@elte.hu>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Just makes reading the logs a bit easier to see what is happening.


Exact, you're right :-)
Anyway, I've unified it in a combo patch...

 
> Thanks!
> 
> Acked-by: Steven Rostedt <srostedt@redhat.com>
> 
> -- Steve
> 

