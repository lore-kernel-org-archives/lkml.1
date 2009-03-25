Return-Path: <linux-kernel-owner+w=401wt.eu-S1758562AbZCYH2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562AbZCYH2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 03:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758444AbZCYH17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 03:27:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47115 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756598AbZCYH15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 03:27:57 -0400
Date: Wed, 25 Mar 2009 08:27:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Steven Rostedt <srostedt@redhat.com>, rusty@rustcorp.com.au,
       =?utf-8?B?RnLpppjpp7tpYw==?= Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ftrace not working?
Message-ID: <20090325072729.GE25833@elte.hu>
References: <20090323143226.GA18439@elte.hu> <200903242253.36794.knikanth@suse.de> <20090325121906.D2D6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325121906.D2D6.A69D9226@jp.fujitsu.com>
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


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

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
> >  
> >  out_free_cpumask:
> >  	free_cpumask_var(tracing_cpumask);
> 
> Good catch!
> 
> I think this patch should send to 2.6.29.1 :)

a fix for that was in the tracing tree already - and will be 
forwarded to .29.1 or .29.2.

	Ingo
