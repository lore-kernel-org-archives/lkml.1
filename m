Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbYJ0Prs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbYJ0Prs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 11:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbYJ0Pri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 11:47:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42882 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbYJ0Pri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 11:47:38 -0400
Date: Mon, 27 Oct 2008 16:47:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH][RESEND] tracing/ftrace: Make boot tracer select the
	sched_switch tracer
Message-ID: <20081027154725.GP5704@elte.hu>
References: <48FF623F.3010507@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FF623F.3010507@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0025]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> If the boot tracer is selected but not the sched_switch,
> there will be a build failure:
> 
> kernel/built-in.o: In function `boot_trace_init':
> trace_boot.c:(.text+0x5ee38): undefined reference to `sched_switch_trace'
> kernel/built-in.o: In function `disable_boot_trace':
> (.text+0x5eee1): undefined reference to `tracing_stop_cmdline_record'
> kernel/built-in.o: In function `enable_boot_trace':
> (.text+0x5ef11): undefined reference to `tracing_start_cmdline_record'
> 
> This patch fixes it.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

applied to tip/tracing/urgent, thanks!

	Ingo
