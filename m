Return-Path: <linux-kernel-owner+w=401wt.eu-S1758476AbXGPUcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476AbXGPUcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 16:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbXGPUcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 16:32:42 -0400
Received: from waste.org ([66.93.16.53]:60782 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204AbXGPUcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 16:32:41 -0400
Date: Mon, 16 Jul 2007 15:31:18 -0500
From: Matt Mackall <mpm@selenic.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Ingo Molnar <mingo@elte.hu>, James Bruce <bruce@andrew.cmu.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
Message-ID: <20070716203117.GC11166@waste.org>
References: <1184355835.12353.321.camel@chaos> <469B0D9E.3030402@andrew.cmu.edu> <20070716070610.GA10907@elte.hu> <Pine.LNX.4.64.0707161213500.1817@scrub.home> <20070716112037.GA6895@elte.hu> <Pine.LNX.4.64.0707161331570.1817@scrub.home> <20070716121246.GA17880@elte.hu> <Pine.LNX.4.64.0707161427100.1817@scrub.home> <20070716134036.GA1533@elte.hu> <Pine.LNX.4.64.0707161548000.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707161548000.1817@scrub.home>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2007 at 04:01:17PM +0200, Roman Zippel wrote:
> Hi,
> 
> On Mon, 16 Jul 2007, Ingo Molnar wrote:
> 
> > to sum it up: a nice +19 task (the most commonly used nice level in 
> > practice) gets 9.1%, 3.9%, 3.1% of CPU time on the old scheduler, 
> > depending on the value of HZ. This is quite inconsistent and illogical.
> 
> You're correct that you can find artifacts in the extreme cases, it's 
> subjective whether this is a serious problem.
> It's nice that these artifacts are gone, but that still doesn't explain 
> why this ratio had to be increase that much from around 1:10 to 1:69.

More dynamic range is better? If you actually want a task to get 20x
the CPU time of another, the older scheduler doesn't really allow it.

Getting 1/69th of a modern CPU is still a fair number of cycles.
Nevermind 1/69th of a machine with > 64 cores.

-- 
Mathematics is the supreme nostalgia of our time.
