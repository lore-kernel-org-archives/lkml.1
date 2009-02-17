Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbZBQPCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbZBQPCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 10:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbZBQPCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 10:02:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40304 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbZBQPCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 10:02:00 -0500
Date: Tue, 17 Feb 2009 15:37:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 00/15] [git pull] for tip/tracing/ftrace
Message-ID: <20090217143752.GB7576@elte.hu>
References: <20090217051227.957864159@goodmis.org> <20090217104213.GC6602@elte.hu> <alpine.DEB.1.10.0902170747160.910@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902170747160.910@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > > I implement a 'traceon' and 'traceoff' to have a function 
> > > start or stop tracing when it is hit. It also includes a 
> > > counter for the number of times to implement the trace on/off.
> > > 
> > >  echo '*_lock:traceon:4' > set_ftrace_filter
> > >  echo '*_unlock:traceoff:5' > set_ftrace_filter
> > 
> > if there's no counter specified, does it default to 1 
> > [single-shot trigger] or infinity?
> 
> Bad documentation on my part :-/
> 
> No number is infinity, since infinity is no number ;-)

Well infinity is a number too, in most schools of algebra, just 
one with unusual properties :)

	Ingo
