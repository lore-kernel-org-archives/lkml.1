Return-Path: <linux-kernel-owner+w=401wt.eu-S1752923AbZLIJdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbZLIJdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:33:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbZLIJdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:33:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43262 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779AbZLIJdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:33:06 -0500
Date: Wed, 9 Dec 2009 10:33:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL] tracing/kprobes: Fix field creation's bad error
 handling
Message-ID: <20091209093303.GD28428@elte.hu>
References: <1260263815-5167-1-git-send-regression-fweisbec@gmail.com>
 <4B1E3F33.2090004@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1E3F33.2090004@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Frederic Weisbecker wrote:
> > Ingo,
> > 
> > Please pull the tracing/fixes branch that can be found at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > 	tracing/fixes
> > 
> > Thanks,
> > 	Frederic
> > ---
> > 
> > Frederic Weisbecker (1):
> >       tracing/kprobes: Fix field creation's bad error handling
> > 
> > 
> >  kernel/trace/trace_kprobe.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > ---
> > From 12e22dfaaee46f70762beb1982a7b86a68317b11 Mon Sep 17 00:00:00 2001
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> > Date: Tue, 8 Dec 2009 10:00:04 +0100
> > Subject: [PATCH] tracing/kprobes: Fix field creation's bad error handling
> > Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>
> > 
> > When we define the common event fields in kprobe, we invert the error
> > handling and return immediately in case of success. Then we omit
> > to define specific kprobes fields (ip and nargs), and specific
> > kretprobes fields (func, ret_ip, nargs). And we only define them
> > when we fail to create common fields.
> > 
> > The most visible consequence is that we can't create filter for
> > k(ret)probes specific fields.
> > 
> > This patch re-invert the success/error handling to fix it.
> > 
> > Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Masami Hiramatsu <mhiramat@redhat.com>
> > Cc: Li Zefan <lizf@cn.fujitsu.com>
> 
> Thanks for fix that.
> 
> Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
> 
> 
> Ingo, I think this should go to tip:urgent.

Will apply, thanks guys!

	Ingo
