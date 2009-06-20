Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbZFTPLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbZFTPLT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 11:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbZFTPLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 11:11:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53819 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbZFTPLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 11:11:11 -0400
Date: Sat, 20 Jun 2009 17:11:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/2] tracing/urgent: fixes for nop patching omissions
Message-ID: <20090620151107.GA9877@elte.hu>
References: <1245474372-5249-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245474372-5249-1-git-send-email-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Hi Ingo, Steven,
> 
> The first patch in the set fixes a bug on which ftrace silently 
> ommitted to recover nop patching after function tracing.
> 
> The issue is present in .31 and .30 as well
> 
> The second patch just adds a warning to prevent further mistakes 
> like that.
> 
> Thanks.
> 
> Frederic Weisbecker (2):
>   tracing/urgent: fix unbalanced ftrace_start_up
>   tracing/urgent: warn in case of ftrace_start_up inbalance
> 
>  kernel/trace/ftrace.c          |    7 +++++++
>  kernel/trace/trace_functions.c |    8 +++++---
>  2 files changed, 12 insertions(+), 3 deletions(-)
> 
> The following changes since commit 44ad18e0a65e296b2e68a1452509f6222cdce743:
>   Steven Rostedt (1):
>         tracing: update sample event documentation
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	tracing/urgent
> 
> Frederic Weisbecker (2):
>       tracing/urgent: fix unbalanced ftrace_start_up
>       tracing/urgent: warn in case of ftrace_start_up inbalance
> 
>  kernel/trace/ftrace.c          |    7 +++++++
>  kernel/trace/trace_functions.c |    8 +++++---
>  2 files changed, 12 insertions(+), 3 deletions(-)

Pulled, thanks Frederic!

	Ingo
