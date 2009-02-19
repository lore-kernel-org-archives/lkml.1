Return-Path: <linux-kernel-owner+w=401wt.eu-S1755797AbZBSLOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbZBSLOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 06:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbZBSLOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 06:14:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33308 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413AbZBSLO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 06:14:29 -0500
Date: Thu, 19 Feb 2009 12:14:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       linuxppc-dev@ozlabs.org
Subject: Re: [git pull] for both tip and powerpc
Message-ID: <20090219111410.GM2354@elte.hu>
References: <alpine.DEB.1.10.0902181408160.11411@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902181408160.11411@gandalf.stny.rr.com>
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

> Ingo and Benjamin,
> 
> As discussed, I made a branch called mainline/function-graph-tracer 
> based off of Linus's commit:
> 
> commit d2f8d7ee1a9b4650b4e43325b321801264f7c37a
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Fri Feb 13 15:31:30 2009 -0800
> 
>     Linux 2.6.29-rc5
> 
> 
> and cherry picked the below change. I added Ingo's Acked-by as well. If 
> both of you pull this change in (assuming both trees are already based 
> off of Linus's 2.6.29-rc5) then there should be no conflicts when this 
> gets merged back to Linus's tree.
> 
> I will not touch this branch again, until it is officially in mainline.
> 
> Please pull the latest mainline/function-graph tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> mainline/function-graph
> 
> 
> Steven Rostedt (1):
>       tracing/function-graph-tracer: make arch generic push pop functions
> 
> ----
>  arch/x86/include/asm/ftrace.h        |   25 -----------
>  arch/x86/kernel/dumpstack.c          |    1 +
>  arch/x86/kernel/ftrace.c             |   75 +---------------------------------
>  include/linux/ftrace.h               |   24 +++++++++++
>  kernel/trace/trace_functions_graph.c |   75 ++++++++++++++++++++++++++++++++++
>  5 files changed, 101 insertions(+), 99 deletions(-)

Pulled into tip:tracing/function-graph-tracer, thanks Steve!

	Ingo
