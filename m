Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbZBKMxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbZBKMxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:53:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbZBKMwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:52:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34930 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852AbZBKMww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:52:52 -0500
Date: Wed, 11 Feb 2009 13:52:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: Re: [PATCH] timers: fix TIMER_ABSTIME for process wide cpu timers
Message-ID: <20090211125240.GJ16535@elte.hu>
References: <1233910614.23431.18.camel@marge.simson.net> <20090206140134.GC3415@elte.hu> <1234280251.23438.73.camel@twins> <1234349601.23438.125.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234349601.23438.125.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> While going through the man-pages Michael prepared for the posix timer
> interface I realized that posix timers do expose the absolute time value
> through the use of TIMER_ABSTIME.
> 
> ---
> Subject: timers: fix TIMER_ABSTIME for process wide cpu timers
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Wed Feb 11 11:30:27 CET 2009
> 
> The POSIX timer interface allows for absolute time expiry values through the
> TIMER_ABSTIME flag, therefore we have to synchronize the timer to the clock
> every time we start it.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Applied to tip:timers/urgent, thanks Peter!

	Ingo
