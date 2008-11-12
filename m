Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbYKLWQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbYKLWQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 17:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbYKLWQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 17:16:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35345 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbYKLWQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 17:16:36 -0500
Date: Wed, 12 Nov 2008 23:16:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/function-return-tracer: Call
	prepare_ftrace_return by registers
Message-ID: <20081112221623.GB6125@elte.hu>
References: <491B4F63.3090909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491B4F63.3090909@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Impact: Optimize a bit the function return tracer
> 
> This patch changes the calling convention of prepare_ftrace_return
> to pass its arguments by register. This will optimize it a bit and
> prepare it to support dynamic tracing.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/x86/kernel/entry_32.S |    5 +----
>  arch/x86/kernel/ftrace.c   |    1 -
>  2 files changed, 1 insertions(+), 5 deletions(-)

applied	to tip/tracing/function-return-tracer, thanks Frederic!

btw., should we now rename it all to the function-cost tracer?

	Ingo
