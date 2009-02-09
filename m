Return-Path: <linux-kernel-owner+w=401wt.eu-S1753147AbZBIJya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbZBIJya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 04:54:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754869AbZBIJx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 04:53:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54140 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859AbZBIJxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 04:53:55 -0500
Date: Mon, 9 Feb 2009 10:53:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5][RESEND] tracing/function-graph-tracer: drop the
	kernel_text_address check
Message-ID: <20090209095343.GE14402@elte.hu>
References: <498e1784.1438560a.641c.2d82@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498e1784.1438560a.641c.2d82@mx.google.com>
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

> When the function graph tracer picks a return address, it ensures this address
> is really a kernel text one by calling __kernel_text_address()
> Actually this path has never been taken. Its role was more likely to debug the tracer
> on the beginning of its development but this function is wasteful since it is called
> for every traced function.
> 
> The fault check is already sufficient.
> 
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  arch/x86/kernel/ftrace.c |    7 -------
>  kernel/extable.c         |    4 ++--
>  kernel/module.c          |    2 +-
>  3 files changed, 3 insertions(+), 10 deletions(-)

Applied to tip/tracing/ftrace, thanks Frederic!

	Ingo
