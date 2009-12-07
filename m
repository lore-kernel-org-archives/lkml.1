Return-Path: <linux-kernel-owner+w=401wt.eu-S1754946AbZLGHEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbZLGHEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:04:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbZLGHEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:04:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43076 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077AbZLGHEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 02:04:09 -0500
Date: Mon, 7 Dec 2009 08:04:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Walt <w41ter@gmail.com>,
       Prasad <prasad@linux.vnet.ibm.com>
Subject: Re: [GIT PULL] hw-breakpoints fixes
Message-ID: <20091207070409.GA10868@elte.hu>
References: <1260166977-5894-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260166977-5894-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the perf/urgent branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/urgent
> 
> The first patch prevents from stack randomnesses in a breakpoint
> definition.
> The second fixes a ptrace regression reported by walt.
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (2):
>       hw-breakpoints: Zeroe the breakpoint attrs on initialization
>       hw-breakpoints: Fix task-bound breakpoint slot allocation
> 
> 
>  include/linux/hw_breakpoint.h |    2 +
>  kernel/hw_breakpoint.c        |   74 +++++++++++++++++++++++++----------------
>  2 files changed, 47 insertions(+), 29 deletions(-)

Pulled, thanks a lot Frederic!

	Ingo
