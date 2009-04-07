Return-Path: <linux-kernel-owner+w=401wt.eu-S1755679AbZDGTT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbZDGTT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 15:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbZDGTTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 15:19:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61213 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbZDGTTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 15:19:16 -0400
Date: Tue, 7 Apr 2009 15:19:14 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 05/10] tracing/ftrace: factorize the tracing files
 creation
In-Reply-To: <20090407122315.GD11641@elte.hu>
Message-ID: <alpine.DEB.2.00.0904071518480.30880@gandalf.stny.rr.com>
References: <20090406163706.097842409@goodmis.org> <20090406163830.773115333@goodmis.org> <20090407122315.GD11641@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 7 Apr 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > --- a/kernel/trace/trace_event_profile.c
> > +++ b/kernel/trace/trace_event_profile.c
> > @@ -6,7 +6,7 @@
> >   */
> >  
> >  #include "trace.h"
> > -
> > +#if 0
> >  int ftrace_profile_enable(int event_id)
> >  {
> >  	struct ftrace_event_call *event;
> > @@ -29,3 +29,4 @@ void ftrace_profile_disable(int event_id)
> >  	}
> >  }
> >  
> > +#endif
> 
> uhm, that's not a very nice to do ;-)

Ug! I mssed that :-p

-- Steve

