Return-Path: <linux-kernel-owner+w=401wt.eu-S1756471AbZCYCVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbZCYCVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 22:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbZCYCVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 22:21:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49278 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbZCYCVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 22:21:37 -0400
Date: Tue, 24 Mar 2009 22:21:34 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Nikanth Karthikesan <knikanth@suse.de>,
       Steven Rostedt <srostedt@redhat.com>, rusty@rustcorp.com.au,
       Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ftrace not working?
In-Reply-To: <20090324201357.GB5975@nowhere>
Message-ID: <alpine.DEB.2.00.0903242220140.22830@gandalf.stny.rr.com>
References: <20090323083533.GE18837@elte.hu> <20090323200057.9027.A69D9226@jp.fujitsu.com> <20090323143226.GA18439@elte.hu> <200903242253.36794.knikanth@suse.de> <20090324201357.GB5975@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 24 Mar 2009, Frederic Weisbecker wrote:
> > Steve, Can you merge this.
> > 
> > Thanks
> > Nikanth
> > 
> > In tracer_alloc_buffers(), do not free tracing_cpumask and tracing_buffer_mask
> > on success.
> > 
> > Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> > 
> > ---
> > 
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index 17bb88d..98f609d 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -3887,6 +3887,7 @@ __init static int tracer_alloc_buffers(void)
> >  
> >  	register_die_notifier(&trace_die_notifier);
> >  	ret = 0;
> > +	goto out;
> 
> 
> Ah I see.
> I've sent a fix for that already, it's on latest -tip
> http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commit;h=2fc1dfbe17e7705c55b7a99da995fa565e26f151
> 

Nikanth,

Could you varify that tip is not an issue for you.

  http://people.redhat.com/~mingo/tip.git/readme.txt

Thanks,

-- Steve

