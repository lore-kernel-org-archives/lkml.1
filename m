Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbYI0REf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbYI0REf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbYI0RE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:04:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41184 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728AbYI0RE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:04:26 -0400
Date: Sat, 27 Sep 2008 19:02:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH v5] Unified trace buffer
Message-ID: <20080927170225.GJ4600@elte.hu>
References: <20080925185154.230259579@goodmis.org> <20080925185236.244343232@goodmis.org> <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com> <48DC406D.1050508@redhat.com> <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com> <20080926173130.GE15446@ghostprotocols.net> <alpine.LFD.1.10.0809261036420.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809261346040.21618@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0809261346040.21618@gandalf.stny.rr.com>
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

> > Indeed. And on some architectures 'packed' will actually mean that 
> > the compiler may think that it's unaligned, and then generate much 
> > worse code to access the fields. So if you align things anyway (and 
> > you do), then 'packed' is the wrong thing to do.
> 
> OK, I'm making v6 now with various cleanups. I'll nuke it on that one.

btw., now that it's getting into shape, could you please fix the ftrace 
portion:

> Subject: [RFC PATCH 2/2 v3] ftrace: make work with new ring buffer
>
> Note: This patch is a proof of concept, and breaks a lot of 
> functionality of ftrace.
>
> This patch simply makes ftrace work with the developmental ring 
> buffer.

... to not have known bugs, so that we could try it in tip/ftrace and 
make sure it works well in practice?

it's a ton of changes already, it would be nice to get to some stable 
known-working state and do delta patches from that point on, and keep 
its 'works well' quality.

	Ingo
