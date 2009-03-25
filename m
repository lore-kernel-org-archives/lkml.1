Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbZCYET2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbZCYET2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 00:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbZCYETR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 00:19:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63937 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbZCYETR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 00:19:17 -0400
Date: Wed, 25 Mar 2009 00:19:14 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Nikanth Karthikesan <knikanth@suse.de>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, stable@kernel.org, gregkh@suse.de
Subject: Re: ftrace not working?
In-Reply-To: <200903250936.06349.knikanth@suse.de>
Message-ID: <alpine.DEB.2.00.0903250018320.30572@gandalf.stny.rr.com>
References: <20090323083533.GE18837@elte.hu> <20090324201357.GB5975@nowhere> <alpine.DEB.2.00.0903242220140.22830@gandalf.stny.rr.com> <200903250936.06349.knikanth@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Wed, 25 Mar 2009, Nikanth Karthikesan wrote:

> On Wednesday 25 March 2009 07:51:34 Steven Rostedt wrote:
> > On Tue, 24 Mar 2009, Frederic Weisbecker wrote:
> > > > Steve, Can you merge this.
> > > >
> > > > Thanks
> > > > Nikanth
> > > >
> > > > In tracer_alloc_buffers(), do not free tracing_cpumask and
> > > > tracing_buffer_mask on success.
> > > >
> > > > Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> > > >
> > > > ---
> > > >
> > > > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > > > index 17bb88d..98f609d 100644
> > > > --- a/kernel/trace/trace.c
> > > > +++ b/kernel/trace/trace.c
> > > > @@ -3887,6 +3887,7 @@ __init static int tracer_alloc_buffers(void)
> > > >
> > > >  	register_die_notifier(&trace_die_notifier);
> > > >  	ret = 0;
> > > > +	goto out;
> > >
> > > Ah I see.
> > > I've sent a fix for that already, it's on latest -tip
> > > http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commit;
> > >h=2fc1dfbe17e7705c55b7a99da995fa565e26f151
> >
> > Nikanth,
> >
> > Could you varify that tip is not an issue for you.
> >
> >   http://people.redhat.com/~mingo/tip.git/readme.txt
> >
> 
> Oh. That should fix it. It would be nice to have it in stable 2.6.29.1.

When it is pulled into Linus's tree, I'll send an note to Greg asking him 
to include it into stable.

Thanks,

-- Steve

