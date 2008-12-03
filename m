Return-Path: <linux-kernel-owner+w=401wt.eu-S1751598AbYLCQQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbYLCQQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 11:16:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbYLCQPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 11:15:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33568 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbYLCQPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 11:15:42 -0500
Date: Wed, 3 Dec 2008 17:15:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/2] ftrace: fixes for tip
Message-ID: <20081203161534.GA6787@elte.hu>
References: <20081203160448.972919719@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203160448.972919719@goodmis.org>
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
> These two patches are fixes. The first cleans up the stack_trace
> output to print 0's for the return_to_handler function.
> 
> The second is the nasty race we have been hitting. My patches must
> have made the race window bigger for you since the bug was there
> before. It is a nasty race in the fork code. More info in the change log
> of that patch.
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/devel
> 
> 
> Steven Rostedt (2):
>       trace: fix output of stack trace
>       ftrace: fix race in function graph during fork
> 
> ----
>  kernel/fork.c              |    9 ++++++---
>  kernel/trace/trace_stack.c |    5 ++++-
>  2 files changed, 10 insertions(+), 4 deletions(-)

pulled, thanks Steve! I think this should explain the crash i was seeing.

	Ingo
