Return-Path: <linux-kernel-owner+w=401wt.eu-S1753631AbZGJLbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbZGJLbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 07:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbZGJLbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 07:31:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40340 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbZGJLbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 07:31:25 -0400
Date: Fri, 10 Jul 2009 13:31:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [PATCH 0/3] [GIT PULL] rebase of lockless ring buffer
Message-ID: <20090710113105.GE3760@elte.hu>
References: <20090708201312.222046866@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090708201312.222046866@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

> 
> Ingo,
> 
> This is the same as v2 that I posted a while ago. You asked me to resend
> after the merge window. It is now after the merge window and I rebased
> the work against latest tip/tracing/core. I made no changes that git
> could not figure out itself.
> 
> Please pull the latest tip/tracing/ring-buffer-3 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ring-buffer-3
> 
> 
> Steven Rostedt (3):
>       ring-buffer: make the buffer a true circular link list
>       ring-buffer: make lockless
>       ring-buffer: add design document
> 
> ----
>  Documentation/trace/ring-buffer-design.txt |  955 ++++++++++++++++++++++++++++
>  include/linux/ring_buffer.h                |    1 -
>  kernel/trace/ring_buffer.c                 |  935 ++++++++++++++++++++++-----
>  kernel/trace/trace.c                       |    3 -
>  4 files changed, 1725 insertions(+), 169 deletions(-)

Pulled into tip:tracing/core, thanks a lot Steve!

	Ingo
