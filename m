Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683AbYK0PFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbYK0PFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 10:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbYK0PFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 10:05:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46728 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbYK0PFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 10:05:21 -0500
Date: Thu, 27 Nov 2008 16:05:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Tim Bird <tim.bird@am.sony.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/function-branch-tracer: enhancements for the
	trace output
Message-ID: <20081127150507.GB10188@elte.hu>
References: <492DEDE9.9010109@gmail.com> <1227781146.4454.1369.camel@twins> <c62985530811270653y644295d6x57de6be7a51be667@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530811270653y644295d6x57de6be7a51be667@mail.gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> I didn't think of ftrace_printk yet. That's a good idea, this way we 
> will see where the ftrace_printk was called, in which function at 
> which depth....
> 
> Don't you think that would be better to have it as C comments. We 
> are in a C-style output and ftrace_printk are especially designed 
> for comments in a trace. That would make sense to read:
> 
>        do_sync_read() {
>           /* sock: 0x12345 flag: 1 */
>           sock_aio_read() {

Nice idea :-)

	Ingo
