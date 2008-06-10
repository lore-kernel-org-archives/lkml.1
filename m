Return-Path: <linux-kernel-owner+w=401wt.eu-S1758519AbYFJKi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519AbYFJKi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 06:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbYFJKin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 06:38:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59187 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999AbYFJKim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 06:38:42 -0400
Date: Tue, 10 Jun 2008 12:38:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [patch] trivial feature cleanup
Message-ID: <20080610103829.GN19136@elte.hu>
References: <1212910033.4980.2.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212910033.4980.2.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

>  kernel/sched_features.h |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> Remove unused debug/tuning features.

applied to tip/sched-devel - thanks Mike.

	Ingo

> Signed-off-by: Mike Galbraith <efault@gmx.de>
> 
> diff --git a/kernel/sched_features.h b/kernel/sched_features.h
> index 1c7283c..62b39ca 100644
> --- a/kernel/sched_features.h
> +++ b/kernel/sched_features.h
> @@ -6,5 +6,3 @@ SCHED_FEAT(CACHE_HOT_BUDDY, 1)
>  SCHED_FEAT(SYNC_WAKEUPS, 1)
>  SCHED_FEAT(HRTICK, 1)
>  SCHED_FEAT(DOUBLE_TICK, 0)
> -SCHED_FEAT(NORMALIZED_SLEEPER, 1)
> -SCHED_FEAT(DEADLINE, 1)
> 
