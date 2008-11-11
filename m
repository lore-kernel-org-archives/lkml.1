Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbYKKIYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbYKKIYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 03:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbYKKIYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 03:24:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37159 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481AbYKKIYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 03:24:09 -0500
Date: Tue, 11 Nov 2008 09:23:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/2] ftrace updates for 2.6.28
Message-ID: <20081111082347.GB29901@elte.hu>
References: <20081111025808.946638585@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111025808.946638585@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: devel
> 
> Steven Rostedt (2):
>       ftrace: disable tracing on resize
>       ring-buffer: prevent infinite looping on time stamping
> 
> ----
>  kernel/trace/ring_buffer.c |    2 +-
>  kernel/trace/trace.c       |   17 ++++++++++++++++-
>  2 files changed, 17 insertions(+), 2 deletions(-)

pulled into tip/tracing/urgent, thanks Steve!

> The following patches are needed for 2.6.28. The first one solves a 
> bug where the resizing of the buffer array was not protected against 
> modifications by ftrace.
> 
> The second patch solves an issue tha Thomas Gleixner was seeing 
> where the tracer would detect the infinite recursion too easily by 
> tracing the timer code. This patch prevents the loop from happening 
> and still does not lose any trace entries.
> 
> The changes caused by these patches are low in risk, but I would 
> still like to put them through linux-next before passing them off to 
> Linus.
> 
> Note, these changes are based against Linus's mainline and not tip. 
> Also note that the branch in this tree is "devel" and not 
> "tip/devel".

that's OK. I resolved the (trivial) conflict with pending changes in 
tip/tracing/ftrace and pushed out a new ftrace integration branch 
towards linux-next.

	Ingo
