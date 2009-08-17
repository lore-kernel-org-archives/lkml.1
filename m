Return-Path: <linux-kernel-owner+w=401wt.eu-S1758180AbZHQVwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbZHQVwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 17:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758128AbZHQVwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 17:52:50 -0400
Received: from www.tglx.de ([62.245.132.106]:47683 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbZHQVwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 17:52:49 -0400
Date: Mon, 17 Aug 2009 23:52:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT pull] irq fixes for 2.6.31
In-Reply-To: <alpine.LFD.2.01.0908171340540.3162@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0908172342400.2782@localhost.localdomain>
References: <alpine.LFD.2.00.0908172055360.2782@localhost.localdomain> <alpine.LFD.2.01.0908171340540.3162@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Mon, 17 Aug 2009, Linus Torvalds wrote:
> On Mon, 17 Aug 2009, Thomas Gleixner wrote:
> > 
> > Please pull the latest irq-fixes-for-linus git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus
> > 
> > Thanks,
> > 
> > 	tglx
> > 
> > ------------------>
> > Thomas Gleixner (1):
> >       genirq: Do not wakeup irq thread from __setup_irq() and set action->irq
> > 
> > 
> >  kernel/irq/manage.c |    3 +--
> >  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> This is not what I get when I pull. Instead I get the "genirq: Prevent 
> race between free_irq() and handle_IRQ_event()" commit that I thought we 
> agreed wasn't correct.

I have no idea what went wrong this time. I force pushed the branch
and pulled it back on a test machine to compile and test boot. The
test machine still has the correct sha1 for that branch while
master.kernel.org did not. I probably pushed out some other branch
between the point where I sent the pull request and the time you
pulled, but I can not find any hint in my bash history which would
explain why it wreckaged the irq-fixes-for-linus branch.

Just double checked that it is pushed out to git://.... as well.

Thanks,

	tglx
