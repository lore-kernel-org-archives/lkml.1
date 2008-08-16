Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbYHPNdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbYHPNdY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 09:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbYHPNdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 09:33:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52494 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbYHPNdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 09:33:15 -0400
Date: Sat, 16 Aug 2008 15:32:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/2] ftrace updates
Message-ID: <20080816133257.GA11063@elte.hu>
References: <20080816014003.978160137@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080816014003.978160137@goodmis.org>
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

> Due to the new mcount recording method, the assumptions about the 
> records that hold the mcount locations have changed.  Now we need to 
> protect reading and writing of the records between module load and 
> reading of the debugfs files. There is not much contention here, but 
> they need to be protected none the less.
> 
> I simply use the ftrace_lock to accomplish this. The ftrace_lock 
> should never be held under interrupt context so disabling interrupts 
> should not be necessary. I've run this under lockdep and lockdep has 
> not complained.

applied to tip/tracing/ftrace - thanks Steve.

	Ingo
