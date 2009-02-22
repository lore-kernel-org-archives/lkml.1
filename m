Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbZBVWRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbZBVWRJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 17:17:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbZBVWQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 17:16:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37341 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbZBVWQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 17:16:55 -0500
Date: Sun, 22 Feb 2009 23:16:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] tracing/ftrace: add missing wake-up on some callsites
Message-ID: <20090222221646.GC21459@elte.hu>
References: <49a1cc8f.2283420a.54d2.ffff8461@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49a1cc8f.2283420a.54d2.ffff8461@mx.google.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Impact: fix unwaken pipe
> 
> Now that we use a common wakeup infrastructure, we must append a wakeup
> on few callsites which lack it or tasks reading trace_pipe will not be
> awaken when events come on few tracers.
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/trace.c             |    2 ++
>  kernel/trace/trace_branch.c      |    2 ++
>  kernel/trace/trace_hw_branches.c |    2 ++
>  3 files changed, 6 insertions(+), 0 deletions(-)

Applied to tip:tracing/ftrace, thanks Frederic!

	Ingo
