Return-Path: <linux-kernel-owner+w=401wt.eu-S1760772AbZLJIGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760772AbZLJIGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 03:06:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760727AbZLJIGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 03:06:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56868 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760710AbZLJIGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 03:06:08 -0500
Date: Thu, 10 Dec 2009 09:06:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] softirq,tracing: enable to trace softirq raise latency
Message-ID: <20091210080608.GA944@elte.hu>
References: <4B1E0F1B.7020305@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1E0F1B.7020305@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> Rebase it for the newly codes
> Collect Acks(Acked-by Mathieu Desnoyers and Frederic Weisbecker)
> 
> 
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> Add a tracepoint for tracing when softirq action is raised.
> 
> It and the existed tracepoints complete softirq's tracepoints:
> softirq_raise, softirq_entry and softirq_exit.
> 
> And when this tracepoint is used in combination with
> the softirq_entry tracepoint we can determine
> the softirq raise latency.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

ok, it would be nice to expose this functionality via some sort of 'perf 
trace --irqlatency' (or perhaps a separate 'perf irq record' 'perf irq 
trace' tool) so that users/developers can make use of this new event and 
that we can check that it works and latencies are correct, etc.

	Ingo
