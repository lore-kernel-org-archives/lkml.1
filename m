Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbXDPDfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbXDPDfg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 23:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754416AbXDPDff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 23:35:35 -0400
Received: from mx1.suse.de ([195.135.220.2]:38303 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412AbXDPDff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 23:35:35 -0400
Date: Mon, 16 Apr 2007 05:34:53 +0200
From: Nick Piggin <npiggin@suse.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Jonathan Lundell <linux@lundell-bros.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       Willy Tarreau <w@1wt.eu>, hui Bill Huey <billh@gnuppy.monkey.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070416033453.GA2659@wotan.suse.de>
References: <20070413202100.GA9957@elte.hu> <200704160852.34241.kernel@kolivas.org> <20070416022838.GA13626@wotan.suse.de> <200704161315.28440.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704161315.28440.kernel@kolivas.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 01:15:27PM +1000, Con Kolivas wrote:
> On Monday 16 April 2007 12:28, Nick Piggin wrote:
> > So, on to something productive, we have 3 candidates for a new scheduler so
> > far. How do we decide which way to go? (and yes, I still think switchable
> > schedulers is wrong and a copout) This is one area where it is virtually
> > impossible to discount any decent design on correctness/performance/etc.
> > and even testing in -mm isn't really enough.
> 
> We're in agreement! YAY!
> 
> Actually this is simpler than that. I'm taking SD out of the picture. It has 
> served it's purpose of proving that we need to seriously address all the 
> scheduling issues and did more than a half decent job at it. Unfortunately I 
> also cannot sit around supporting it forever by myself. My own life is more 
> important, so consider SD not even running the race any more.
> 
> I'm off to continue maintaining permanent-out-of-tree leisurely code at my own 
> pace. What's more is, I think I'll just stick to staircase Gen I version blah 
> and shelve SD and try to have fond memories of SD as an intellectual 
> prompting exercise only.

Well I would hope that _if_ we decide to switch schedulers, then you
get a chance to field something (and I hope you will decide to and have
time to), and I hope we don't rush into the decision.

We've had the current scheduler for so many years now that it is much
more important to make sure we take the time to do the right thing
rather than absolutely have to merge a new scheduler right now ;)

