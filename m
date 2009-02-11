Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbZBKItj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbZBKItj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 03:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbZBKIta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 03:49:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49199 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbZBKIta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 03:49:30 -0500
Date: Wed, 11 Feb 2009 09:49:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: git pull request for tip/tracing/urgent
Message-ID: <20090211084919.GF21105@elte.hu>
References: <alpine.DEB.1.10.0902101314440.23505@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902101314440.23505@gandalf.stny.rr.com>
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

> 
> Ingo,
> 
> The bug that is fixed by this change can affect users. Most likely it will 
> not, since the fault should never happen. But this is a protective 
> mechanism, where if it does, that means there is a bug in the tracer.
> 
> As you have previously told me, a bug in the tracer should never crash the 
> kernel. Since the detection of a fault in the function graph tracer can 
> lead to a kernel crash (without this change) I think this qualifies as 
> something for 29.

Yeah, definitely so.

> -- Steve
> 
> 
> The following patch is in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/tracing/urgent
> 
> 
> Steven Rostedt (1):
>       tracing, x86: fix fixup section to return to original code
> 
> ----
>  arch/x86/kernel/ftrace.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)

Pulled into tip:tracing/urgent, thanks Steve!

	Ingo
