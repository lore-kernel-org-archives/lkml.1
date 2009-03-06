Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbZCFTR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbZCFTR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 14:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbZCFTRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 14:17:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60322 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755176AbZCFTRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 14:17:50 -0500
Date: Fri, 6 Mar 2009 20:17:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4/5 v3] tracing/core: drop the old ftrace_printk
	implementation in favour of ftrace_bprintk
Message-ID: <20090306191732.GA32249@elte.hu>
References: <1236356510-8381-1-git-send-email-fweisbec@gmail.com> <1236356510-8381-5-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.0903061146000.23248@gandalf.stny.rr.com> <20090306170222.GA11285@elte.hu> <20090306171413.GB32128@elte.hu> <alpine.DEB.2.00.0903061302210.23248@gandalf.stny.rr.com> <20090306184904.GA24571@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306184904.GA24571@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > You can go ahead and merge it into tracing/ftrace, and then 
> > I can work with that to fix up the formatting.
> 
> triggers this build failure on certain configs:
> 
> kernel/trace/trace.c:1205: error: implicit declaration of function 'vbin_printf'
> kernel/trace/trace_output.c:64: error: implicit declaration of function 'bstr_printf'
> 
> so i've excluded it from tip:master again for now.

ah, disregard this - that's a testing fluke - i have put it back 
again.

(a test-system got hold of an intermediate merge and found a 
build bug in it.)

	Ingo
