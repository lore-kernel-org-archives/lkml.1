Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbYLHOQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbYLHOQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 09:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbYLHOP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 09:15:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37537 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbYLHOP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 09:15:58 -0500
Date: Mon, 8 Dec 2008 15:15:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/function-graph-tracer: append the
	tracing_graph_flag
Message-ID: <20081208141547.GC14856@elte.hu>
References: <4939E6DD.8020506@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4939E6DD.8020506@gmail.com>
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

> Impact: Provide a way to pause the function graph tracer
> 
> As suggested by Steven Rostedt, the previous patch that prevented from 
> spinlock function tracing shouldn't use the raw_spinlock to fix it. 
> It's much better to follow lockdep with normal spinlock, so this patch 
> adds a new flag for each task to make the function graph tracer able to 
> be paused. We also can send an ftrace_printk whithout worrying of the 
> irrelevant traced spinlock during insertion.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

applied to tip/tracing/function-graph-tracer, thanks Frederic!

	Ingo
