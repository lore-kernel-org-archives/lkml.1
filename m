Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbYJIMeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbYJIMeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 08:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757440AbYJIMeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 08:34:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38023 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759027AbYJIMeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 08:34:01 -0400
Date: Thu, 9 Oct 2008 14:33:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: pull request for range-hrtimer updates
Message-ID: <20081009123345.GC2952@elte.hu>
References: <20081008083320.41840108@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081008083320.41840108@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> Hi,
> 
> a few changes have been put into the range-hrtimer tree; the first three have been on lkml before, 
> the last 2 are build fixes reported in the last few days.... please pull.
> 
> The following changes since commit a7cda5d3ae218476927ac3fd9756ea617c4ddfb2:
>   Ingo Molnar (1):
>         Merge branch 'sched/core'
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-hrtimer.git master
> 
> Arjan van de Ven (5):
>       hrtimer: make the nanosleep() syscall use the per process slack
>       hrtimer: make the futex() system call use the per process slack value
>       hrtimer: peek at the timer queue just before going idle
>       select: fix alpha OSF wrapper
>       rangetimer: fix x86 build failure for the !HRTIMERS case
> 
>  arch/alpha/kernel/osf_sys.c |   13 +++++++------
>  drivers/cpuidle/cpuidle.c   |    7 +++++++
>  include/linux/hrtimer.h     |    7 +++++++
>  kernel/futex.c              |    6 +++++-
>  kernel/hrtimer.c            |   37 ++++++++++++++++++++++++++++++++++++-
>  5 files changed, 62 insertions(+), 8 deletions(-)

pulled into tip/timers/range-hrtimers, thanks Arjan!

	Ingo
