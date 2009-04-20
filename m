Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbZDTIrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbZDTIrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 04:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbZDTIrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 04:47:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56855 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbZDTIrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 04:47:01 -0400
Date: Mon, 20 Apr 2009 10:46:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] ftrace, workqueuetrace: Make
	workqueuetracepoints use TRACE_EVENT macro
Message-ID: <20090420084631.GA32625@elte.hu>
References: <20090420103612.4B4E.A69D9226@jp.fujitsu.com> <47EF9F5C609F496FBBD423EA81A00920@zhaoleiwin> <20090420104734.4B51.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090420104734.4B51.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> OK.
> 
> thus, I recoomend to pending 2 and 3. and change 1 as Ingo 
> suggested. if not, reviewer might forgot this thread.

Ok - but even the original order of patches would be fine - as long 
as the end result is agreed on and is reached.

I've asked Frederic (the original author of the workqueue tracer 
plugin) to collect these patches into a topic branch in his tree. 
Once it's a complete story we can pull it into tip:tracing/core.

Oleg seemed not to disagree and Andrew is in hiding.

Andrew, Oleg: if you plan to make unhappy noises about this level of 
instrumentation in the workqueue code, please do it sooner rather 
than later, as there's quite some effort injected into this already. 
A tentative non-NAK now (patches are still being sorted out) and an 
Ack on the final topic tree from you (once we send it and if it's 
good) and general happiness would be the ideal outcome :)

Thanks,

	Ingo
