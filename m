Return-Path: <linux-kernel-owner+w=401wt.eu-S1030351AbXDWB0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030351AbXDWB0G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 21:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030354AbXDWB0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 21:26:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030351AbXDWB0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 21:26:05 -0400
Date: Mon, 23 Apr 2007 03:25:09 +0200
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch] CFS scheduler, -v5
Message-ID: <20070423012509.GA25162@wotan.suse.de>
References: <20070420140457.GA14017@elte.hu> <20070423011229.GA20367@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423011229.GA20367@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2007 at 03:12:29AM +0200, Ingo Molnar wrote:
> 
> i'm pleased to announce release -v5 of the CFS scheduler patchset. The 
> patch against v2.6.21-rc7 and v2.6.20.7 can be downloaded from:
> 
>     http://redhat.com/~mingo/cfs-scheduler/
> 
> this CFS release mainly fixes regressions and improves interactivity:
> 
>     13 files changed, 211 insertions(+), 199 deletions(-)
> 
> the biggest user-visible change in -v5 are various interactivity 
> improvements (especially under higher load) to fix reported regressions, 
> and an improved way of handling nice levels. There's also a new 
> sys_sched_yield_to() syscall implementation for i686 and x86_64.
> 
> All known regressions have been fixed. (knock on wood)

I think the granularity is still much too low. Why not increase it to
something more reasonable as a default?

