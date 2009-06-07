Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbZFGJwC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbZFGJwC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 05:52:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbZFGJvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 05:51:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47441 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbZFGJvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 05:51:53 -0400
Date: Sun, 7 Jun 2009 11:51:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, stable@kernel.org
Subject: Re: [PATCH 0/2] [GIT PULL][urgent] function-graph: allocation and
	freeing of ret_stack
Message-ID: <20090607095145.GF31286@elte.hu>
References: <20090602220212.894951549@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602220212.894951549@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> Here's a couple of more fixes.
> 
> Please pull the latest tip/tracing/urgent-1 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/urgent-1
> 
> 
> Steven Rostedt (2):
>       function-graph: move initialization of new tasks up in fork
>       function-graph: always initialize task ret_stack
> 
> ----
>  kernel/fork.c         |   10 ++++------
>  kernel/trace/ftrace.c |    6 ++++--
>  2 files changed, 8 insertions(+), 8 deletions(-)

Pulled, thanks Steve!

( Note, we need to keep these two commits in mind and forward them 
  to stable@kernel.org in a few days - as they have no Cc:
  stable@kernel.org tags. )

	Ingo
