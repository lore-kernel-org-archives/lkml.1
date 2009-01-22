Return-Path: <linux-kernel-owner+w=401wt.eu-S1757175AbZAVJch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175AbZAVJch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 04:32:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbZAVJc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 04:32:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48618 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644AbZAVJc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 04:32:27 -0500
Date: Thu, 22 Jan 2009 10:32:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5] ftrace: updates for tip
Message-ID: <20090122093211.GB24758@elte.hu>
References: <20090121235306.224764198@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090121235306.224764198@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> These patches are fixes for the wakeup tracer.

That was quick! :-)

> The first is a fix to the empty output you reported to me earlier.
> 
> The second is a fix for the ring buffer to not record updates if it is 
> disabled, otherwised you can get empty traces there too.
> 
> The third is the wakeup change to record all tasks and not just realtime 
> tasks. It adds a wakeup_rt tracer to record only rt tasks.
> 
> The forth is the addition of the scheduling wakeup and sched switch output 
> to the wakeup tracer. This is very helpful data.
> 
> The last is probably the most important, and should go into 29 as well. I 
> never reset the timestamps used to connect the trace stamps in the 
> buffers. This can cause stale stamps to appear and explains some of the 
> really bad timestamps in the buffer I've seen.

okay, i've pulled your fixes into tip/tracing/ftrace and i've cherry-picked 
the timestamp fix over into tracing/urgent.

Thanks,

	Ingo
