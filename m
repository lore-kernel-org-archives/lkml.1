Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbZBQMqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbZBQMqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 07:46:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbZBQMpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 07:45:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54056 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbZBQMpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 07:45:54 -0500
Date: Tue, 17 Feb 2009 07:45:52 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 12/15] ftrace: add traceon traceoff commands to enable/disable
 the buffers
In-Reply-To: <20090217103729.GB6602@elte.hu>
Message-ID: <alpine.DEB.1.10.0902170743520.910@gandalf.stny.rr.com>
References: <20090217051227.957864159@goodmis.org> <20090217051407.422977785@goodmis.org> <20090217103729.GB6602@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 17 Feb 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > +	if (*count != -1)
> > +		(*count)--;
> 
> minor nit: it's a tiny bit more compact as:
> 
> > +	if (*count != -1)
> > +		--*count;

Doesn't that move the pointer? Cases like these, I prefer the parenthesis,
because I get confused about C ordering.

> 
> and this:
> 
> >  	return register_tracer(&function_trace);
> >  }
> >  
> >  device_initcall(init_function_trace);
> > +
> 
> there should be no newline between device_initcall() and the 
> preceding function. (we can think of it as a late attribute of 
> the function, attached to the function. We do the same for 
> EXPORT_SYMBOL's too, etc.)

OK,

Do you want me to rebase, or just send out new "clean up" patches?

-- Steve

