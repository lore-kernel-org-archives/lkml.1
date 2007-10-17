Return-Path: <linux-kernel-owner+w=401wt.eu-S1764181AbXJQO7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764181AbXJQO7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 10:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757655AbXJQO7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 10:59:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40494 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755106AbXJQO7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 10:59:45 -0400
Date: Wed, 17 Oct 2007 16:59:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [git pull] scheduler fixes
Message-ID: <20071017145933.GA24035@elte.hu>
References: <20071017142935.GA10766@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017142935.GA10766@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Linus, please pull the latest scheduler git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git
> 
> 4 fixes - and one of the fixes could resolve the group-scheduler crashes 
> that were reported. Thanks,

update: i've replaced this one:

> Ingo Molnar (1):
>       sched: fix new task startup crash

with the better fix from Srivatsa Vaddagiri:

  Srivatsa Vaddagiri (1):
        sched: fix new task startup crash

Updated shortlog below.

(if you pulled already that's not a problem either as both trees are 
fine - i'll sort it out)

	Ingo

git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git
------------------>
Dhaval Giani (1):
      sched: fix !SYSFS build breakage

Ken Chen (1):
      sched: fix improper load balance across sched domain

Milton Miller (1):
      sched: more robust sd-sysctl entry freeing

Srivatsa Vaddagiri (1):
      sched: fix new task startup crash

 include/linux/sched.h |    2 ++
 kernel/sched.c        |   38 +++++++++++++++++++++++++++++++-------
 kernel/sched_fair.c   |    6 +-----
 kernel/user.c         |   23 +++++++++++++++--------
 4 files changed, 49 insertions(+), 20 deletions(-)
