Return-Path: <linux-kernel-owner+w=401wt.eu-S964989AbXDUHje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964989AbXDUHje (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 03:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965051AbXDUHje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 03:39:34 -0400
Received: from mail.suse.de ([195.135.220.2]:48083 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964989AbXDUHjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 03:39:33 -0400
Date: Sat, 21 Apr 2007 09:39:05 +0200
From: Nick Piggin <npiggin@suse.de>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Mike Galbraith <efault@gmx.de>,
       Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely   Fair Scheduler [CFS]
Message-ID: <20070421073905.GA28073@wotan.suse.de>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <1176619384.6222.70.camel@Homer.simpson.net> <46240F98.3020800@bigpond.net.au> <1176776941.6222.21.camel@Homer.simpson.net> <20070417034050.GD25513@wotan.suse.de> <1176782489.13059.15.camel@Homer.simpson.net> <20070417041420.GF25513@wotan.suse.de> <20070417095140.GB22626@elte.hu> <462926DF.1030404@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462926DF.1030404@tmr.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 04:47:27PM -0400, Bill Davidsen wrote:
> Ingo Molnar wrote:
> 
> >( Lets be cautious though: the jury is still out whether people actually 
> >  like this more than the current approach. While CFS feedback looks 
> >  promising after a whopping 3 days of it being released [ ;-) ], the 
> >  test coverage of all 'fairness centric' schedulers, even considering 
> >  years of availability is less than 1% i'm afraid, and that < 1% was 
> >  mostly self-selecting. )
> >
> All of my testing has been on desktop machines, although in most cases 
> they were really loaded desktops which had load avg 10..100 from time to 
> time, and none were low memory machines. Up to CFS v3 I thought 
> nicksched was my winner, now CFSv3 looks better, by not having stumbles 
> under stupid loads.

What base_timeslice were you using for nicksched, and what HZ?

