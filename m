Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbYH1HrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbYH1HrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 03:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbYH1Hq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 03:46:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41650 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364AbYH1Hq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 03:46:57 -0400
Date: Thu, 28 Aug 2008 09:46:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH] ftrace stack tracer
Message-ID: <20080828074640.GH21875@elte.hu>
References: <alpine.DEB.1.10.0808272324210.1782@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808272324210.1782@gandalf.stny.rr.com>
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

> This is another tracer using the ftrace infrastructure, that examines 
> at each function call the size of the stack. If the stack use is 
> greater than the previous max it is recorded.

i've created a new, -git based topic for this: tip/tracing/stack-tracer, 
applied your new stacktrace plugin and started testing it.

	Ingo
