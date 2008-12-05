Return-Path: <linux-kernel-owner+w=401wt.eu-S1757603AbYLENsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbYLENsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 08:48:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbYLENsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 08:48:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50356 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbYLENsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 08:48:23 -0500
Date: Fri, 5 Dec 2008 14:48:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] tracing/ftrace: don't insert TRACE_PRINT during
	selftests
Message-ID: <20081205134818.GA27039@elte.hu>
References: <49385E07.7050304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49385E07.7050304@gmail.com>
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

> Impact: fix tracer selfstests false results
> 
> After setting a ftrace_printk somewhere in th kernel, I saw the
> Function tracer selftest failing.
> 
> When a selftest occurs, the ring buffer is lurked to see if
> some entries were inserted. But concurrent insertion such as
> ftrace_printk could occured at the same time and could give
> false positive or negative results.
> 
> This patch prevent prevent from TRACE_PRINT entries insertion
> during selftests.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/trace.c |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)

applied to tip/tracing/ftrace, thanks.

I suspect you'll also fix the things Steve pointed out?

	Ingo
