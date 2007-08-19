Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbXHSTqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbXHSTqQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 15:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbXHSTqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 15:46:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236AbXHSTp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 15:45:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 5/5] exec: RT sub-thread can livelock and monopolize CPU on exec
In-Reply-To: Oleg Nesterov's message of  Sunday, 19 August 2007 12:38:27 +0400 <20070819083827.GA83@tv-sign.ru>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20070819194552.B9A5E4D058C@magilla.localdomain>
Date: Sun, 19 Aug 2007 12:45:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The group_leader can sleep before it enters exit_notify(). In that case
> wait_task_inactive() returns, and we still need some polling to wait for
> EXIT_ZOMBIE.

It could be a loop as now with yield.  It's still polling, but only one
poll per wakeup of the target.

> Yes sure. But in any case I think we should avoid polling, we need some
> notification from exit_notify().

Indeed.


Thanks,
Roland
