Return-Path: <linux-kernel-owner+w=401wt.eu-S1751848AbZJWFfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbZJWFfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 01:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbZJWFfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 01:35:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46092 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbZJWFfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 01:35:37 -0400
Date: Fri, 23 Oct 2009 07:35:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg KH <greg@kroah.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] tracefs
Message-ID: <20091023053530.GB24359@elte.hu>
References: <20091023004937.GA24035@kroah.com> <1256260230.20866.816.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256260230.20866.816.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 2009-10-22 at 17:49 -0700, Greg KH wrote:
> > Hi all,
> > 
> > At LinuxCon this year, Steven and I talked about moving the debugfs
> > usage in the tracing core to a stand-alone filesystem to give the
> > ability to start to lock down the api so that people an count on what is
> > going on in the tracing userspace interface.
> > 
> > So, on the flight to Tokyo for the kernel summit, I wrote up tracefs.
> > Here's the first very rough cut at it below.  I've run it here on my
> > laptop, and all seems well, but I do have a few questions:
> >   - I've made the mount point be /sys/kernel/trace/  Is that ok?  Should
> >     it be /sys/kernel/tracing/?  Or something else?  You get to pick the
> >     mount point now, so I don't want to hear any more grumblings about
> >     the location in the future :)
> 
> /trace
> 
>  (rostedt hides)

No, what we want is either /sys/events/ or /proc/events/ alike place to 
expose event logging formats (i.e. the /debug/tracing/events/ details). 
Those are clean enough to be exposed as an ABI - and it would be a good 
point to start.

	Ingo
