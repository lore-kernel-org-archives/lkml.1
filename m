Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbZJ3Hpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbZJ3Hpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 03:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbZJ3Hpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 03:45:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43169 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856AbZJ3Hpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 03:45:43 -0400
Date: Fri, 30 Oct 2009 08:45:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/8] tracing: fixes and cleanups for recordmcount.pl
Message-ID: <20091030074540.GB10409@elte.hu>
References: <20091029223254.504427063@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091029223254.504427063@goodmis.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
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

> Ingo,
> 
> Please pull the latest tip/tracing/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/core
> 
> 
> Li Hong (8):
>       tracing: Amend documentation in recordmcount.pl to reflect implementation
>       tracing: Correct the check for number of arguments in recordmcount.pl
>       tracing: Check absolute path of input file in recordmcount.pl
>       tracing: Fix objcopy revision check in recordmcount.pl
>       tracing: Move mcount section search to front of loop in recordmcount.pl
>       tracing: Add regex for weak functions in recordmcount.pl
>       tracing: Move conditional into update_funcs() in recordmcount.pl
>       tracing: Exit with error if a weak function is used in recordmcount.pl
> 
> ----
>  scripts/recordmcount.pl |  210 +++++++++++++++++++++++++----------------------
>  1 files changed, 111 insertions(+), 99 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
