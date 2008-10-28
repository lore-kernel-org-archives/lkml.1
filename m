Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbYJ1SQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbYJ1SQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 14:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbYJ1SQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 14:16:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44387 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbYJ1SQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 14:16:21 -0400
Date: Tue, 28 Oct 2008 19:16:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: perform an initialization for ftrace to enable
	it
Message-ID: <20081028181614.GB11275@elte.hu>
References: <49076552.2090500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49076552.2090500@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0008]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Impact: Corrects a bug which made the function tracer not functionnal
> 
> With latest git, the function tracer didn't get any trace. The 
> problem was the fact that ftrace_enabled wasn't initialized to 1 
> because ftrace hasn't any init function when DYNAMIC_FTRACE is 
> disabled. So when a tracer tries to register an ftrace_ops struct, 
> __register_ftrace_function failed to set the hook.
> 
> This patch corrects it by setting an init function to initialize 
> ftrace during the boot.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

applied to tip/tracing/urgent, thanks Frederic!

	Ingo
