Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbYKCKKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbYKCKKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 05:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754653AbYKCKKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 05:10:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60625 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640AbYKCKKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 05:10:47 -0500
Date: Mon, 3 Nov 2008 11:10:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -v3] ring-buffer: add paranoid checks for loops
Message-ID: <20081103101027.GG13671@elte.hu>
References: <alpine.DEB.1.10.0810291439460.13214@gandalf.stny.rr.com> <20081030184552.GC17822@elte.hu> <alpine.DEB.1.10.0810302314460.26352@gandalf.stny.rr.com> <20081031093804.GF30317@elte.hu> <alpine.DEB.1.10.0810310956240.13290@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810310956240.13290@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> [
>   Changes from v2:
> 
>    Applied Ingo's comments:
> 
>      Rephrased one of the comments.
> 
>      Renamed the "paranoid" variable into "nr_loops".
> ]
> 
> While writing a new tracer, I had a bug where I caused the ring-buffer
> to recurse in a bad way. The bug was with the tracer I was writing
> and not the ring-buffer itself. But it took a long time to find the
> problem.
> 
> This patch adds paranoid checks into the ring-buffer infrastructure
> that will catch bugs of this nature.
> 
> Note: I put the bug back in the tracer and this patch showed the error
>       nicely and prevented the lockup.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/ring_buffer.c |   56 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 56 insertions(+)

applied to tip/tracing/urgent, thanks Steve!

	Ingo
