Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbYKFGxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbYKFGxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 01:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbYKFGw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 01:52:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34702 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbYKFGw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 01:52:58 -0500
Date: Thu, 6 Nov 2008 07:52:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] ftrace: start stop infrastructure changes
Message-ID: <20081106065240.GC15731@elte.hu>
References: <20081105212428.148612398@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081105212428.148612398@goodmis.org>
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

>  Note, I'm now trying to learn to use git. I am experimenting with
>  using a combination of quilt and git. I set up a git repo at:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>  This series is in the tip/devel branch.
> 
>  I'll put my changes in that branch and then send out the patches
>  as I have always done. But the introduction will list the shortlog
>  of the changes, then followed by the patches themselves.
> 
>  I do this by using git format-patch and then having quilt send
>  out the queue that was produced.
> 
>  I plan on automating a lot of this, but for this run, it was
>  done manually.

Worked fine on my side - and it's easier than processing patches in 
email: the ordering and dependencies are more obvious.

The only flip side is that it's harder to fix small details in commit 
logs in an ad-hoc way. So be prepared to see more nitpicking from me 
for such details :-)

	Ingo
