Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbYLCILl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbYLCILl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 03:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbYLCILd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 03:11:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44047 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507AbYLCILc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 03:11:32 -0500
Date: Wed, 3 Dec 2008 09:11:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5] ftrace: updates for tip
Message-ID: <20081203081118.GD21006@elte.hu>
References: <20081203045001.367443457@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203045001.367443457@goodmis.org>
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

> Ingo,
> 
> Most of thes patches are improvements to function graph. I'm
> working on making a way to pick a function to trace, which the
> patch function entry patch is needed.
> 
> The one ring buffer patch converts all variables called 'page' to
> 'bpage' as per Andrew's request.
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/devel
> 
> 
> Steven Rostedt (5):
>       ftrace: add ftrace_graph_stop
>       ring-buffer: change page variables to bpage
>       ftrace: print real return in dumpstack for function graph
>       ftrace: function graph return for function entry
>       ftrace: add checks on ret stack in function graph
> 
> ----
>  arch/x86/kernel/dumpstack.c    |   34 ++++++++++-
>  arch/x86/kernel/dumpstack.h    |    2 +-
>  arch/x86/kernel/dumpstack_32.c |    5 +-
>  arch/x86/kernel/dumpstack_64.c |    7 +-
>  arch/x86/kernel/entry_32.S     |    3 +
>  arch/x86/kernel/entry_64.S     |    3 +
>  arch/x86/kernel/ftrace.c       |   34 +++++++++--
>  include/linux/ftrace.h         |    4 +-
>  kernel/trace/ftrace.c          |   15 ++++-
>  kernel/trace/ring_buffer.c     |  130 ++++++++++++++++++++--------------------
>  kernel/trace/trace.c           |    4 +-
>  kernel/trace/trace.h           |    2 +-
>  12 files changed, 161 insertions(+), 82 deletions(-)

pulled into tip/tracing/ftrace, thanks Steve!

	Ingo
