Return-Path: <linux-kernel-owner+w=401wt.eu-S1763343AbYEBBQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763343AbYEBBQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 21:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbYEBBQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 21:16:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64157 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbYEBBQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 21:16:50 -0400
Date: Thu, 1 May 2008 21:16:48 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       hch@infradead.org, adobriyan@gmail.com, bunk@kernel.org
Subject: Re: [PATCH] add typecheck on irqsave and friends for correct flags
In-Reply-To: <20080501172810.fa39dad6.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0805012114180.31096@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0805011946290.12785@gandalf.stny.rr.com>
 <20080501172810.fa39dad6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 1 May 2008, Andrew Morton wrote:
> > This patch adds a typecheck inside the irqsave and restore functions
> > to flag these cases.
>
> hm, not exactly a thing of beauty, but it could have been worse.

Beauty is in the eye of the beholder.
 (a mother always thinks their kid is beautiful ;-).

>
>
> If we had implemeted these things properly, as
>
> 	unsigned long spin_lock_irqsave(spinlock_t *lock);

Then we would have been forced to do the

	irqflags_t spin_lock_irqsave(spinlock_t *lock);

trick. Which would probably be the better long term solution, but the
biggest PITA for you in the short term.

-- Steve

>
> then we wouldn't be able to do this at all.
>
> Oh well, thanks, I'll toss it in there.  Maybe this should go into
> git-sched (aka git-omnibus)?
>
>
