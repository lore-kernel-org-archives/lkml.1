Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbZBJNBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbZBJNBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 08:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbZBJNBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 08:01:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55025 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008AbZBJNBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 08:01:02 -0500
Date: Tue, 10 Feb 2009 14:00:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 0/3] git pull request for tip/tracing/ftrace
Message-ID: <20090210130050.GA8341@elte.hu>
References: <20090209172830.087244662@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209172830.087244662@goodmis.org>
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
> I pulled in the splice code from Eduard into a branch that is
> based off of tip's tracing/ftrace branch.
> 
> I kept Eduard's patches as is, and implemented the suggested clean
> ups at the end.
> 
> My branch names were getting too long so I hacked off the "/devel"
> part at the end that I usually have.

> Eduard - Gabriel Munteanu (2):
>       tracing: splice support for tracing_pipe
>       tracing: Move pipe waiting code out of tracing_read_pipe().
> 
> Steven Rostedt (1):
>       tracing: clean up splice code
> 
> ----
>  kernel/trace/trace.c |  219 +++++++++++++++++++++++++++++++++++++++++++-------
>  kernel/trace/trace.h |    6 ++
>  2 files changed, 196 insertions(+), 29 deletions(-)

Pulled into tip:tracing/ftrace, thanks guys!

A small request regarding the commit logs, could you please
in the future make the titles more consistent:

 34cd499: tracing: clean up splice code
 ff98781: tracing: Move pipe waiting code out of tracing_read_pipe().
 3c56819: tracing: splice support for tracing_pipe

the closing period in the second commit is unnecessary, and
capitalization should be consistent as well.

Thanks,

	Ingo
