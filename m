Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbZCYEKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbZCYEKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 00:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbZCYEIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 00:08:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50364 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbZCYEIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 00:08:37 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: ftrace not working?
Date: Wed, 25 Mar 2009 09:36:05 +0530
User-Agent: KMail/1.10.3 (Linux/2.6.27.19-3.2-default; KDE/4.1.3; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>, rusty@rustcorp.com.au,
       Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org
References: <20090323083533.GE18837@elte.hu> <20090324201357.GB5975@nowhere> <alpine.DEB.2.00.0903242220140.22830@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0903242220140.22830@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903250936.06349.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 March 2009 07:51:34 Steven Rostedt wrote:
> On Tue, 24 Mar 2009, Frederic Weisbecker wrote:
> > > Steve, Can you merge this.
> > >
> > > Thanks
> > > Nikanth
> > >
> > > In tracer_alloc_buffers(), do not free tracing_cpumask and
> > > tracing_buffer_mask on success.
> > >
> > > Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> > >
> > > ---
> > >
> > > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > > index 17bb88d..98f609d 100644
> > > --- a/kernel/trace/trace.c
> > > +++ b/kernel/trace/trace.c
> > > @@ -3887,6 +3887,7 @@ __init static int tracer_alloc_buffers(void)
> > >
> > >  	register_die_notifier(&trace_die_notifier);
> > >  	ret = 0;
> > > +	goto out;
> >
> > Ah I see.
> > I've sent a fix for that already, it's on latest -tip
> > http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commit;
> >h=2fc1dfbe17e7705c55b7a99da995fa565e26f151
>
> Nikanth,
>
> Could you varify that tip is not an issue for you.
>
>   http://people.redhat.com/~mingo/tip.git/readme.txt
>

Oh. That should fix it. It would be nice to have it in stable 2.6.29.1.

Thanks
Nikanth
