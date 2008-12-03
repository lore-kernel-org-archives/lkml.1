Return-Path: <linux-kernel-owner+w=401wt.eu-S1752650AbYLCIQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbYLCIQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 03:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbYLCIQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 03:16:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40576 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbYLCIQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 03:16:42 -0500
Date: Wed, 3 Dec 2008 09:16:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tim Bird <tim.bird@am.sony.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/function-graph-tracer: display unified
	style cmdline and pid
Message-ID: <20081203081624.GG21006@elte.hu>
References: <4935E13D.9000208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4935E13D.9000208@gmail.com>
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

> Impact: let one know which thread called a function
> 
> This patch implements a helper function to print the couple cmdline/pid.
> Its output is provided during task switching and on each row if the new
> "funcgraph-proc" defualt-off option is set through trace_options file.
> 
> The output is center aligned and never exceeds 14 characters. The cmdline
> is truncated over 7 chars.
> But note that if the pid exceeds 6 characters, the column will overflow (but
> the situation is abnormal).
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

applied, thanks Frederic!

	Ingo
