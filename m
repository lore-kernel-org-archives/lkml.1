Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbYJ0KCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbYJ0KCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 06:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbYJ0KB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 06:01:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37059 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbYJ0KB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 06:01:57 -0400
Date: Mon, 27 Oct 2008 11:01:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] ftrace: Add a script to produce a hierarchical
	view of a function trace
Message-ID: <20081027100148.GB8116@elte.hu>
References: <4904DF39.9070203@gmail.com> <alpine.DEB.1.10.0810261903110.26269@gandalf.stny.rr.com> <490513D5.7080806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490513D5.7080806@gmail.com>
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

> Ok it's corrected thanks to the trace sent by Steven.
> Here is a V2.
> ---
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Subject: [PATCH] ftrace: Add a script to produce a hierarchical view of a function trace
> 
> This script parses a function trace and then produces a hierarchical view of the
> function call stack after processing it into a tree.
> 
> Changes on V2:
> _ Support both the files "trace" and "trace_pipe" (comments and space differences)
> _ Correct the mini HOW-TO at the beginning.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

nice! Applied it to tip/tracing/ftrace. I've added Steve's Acked-by, 
and i've moved the script to scripts/tracing/ - now that we'll have a 
handful of utility scripts there we might as well separate it a bit 
more clearly from the usual body of kernel scripts.

i think we should move the other utility scripts there too. (but not 
the recordmcount script - that is an infrastructure script, not a 
utility script)

	Ingo
