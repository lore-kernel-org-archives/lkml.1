Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbXDOWxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbXDOWxw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 18:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbXDOWxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 18:53:52 -0400
Received: from mail02.syd.optusnet.com.au ([211.29.132.183]:42089 "EHLO
	mail02.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754039AbXDOWxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 18:53:51 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Jonathan Lundell <linux@lundell-bros.com>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Date: Mon, 16 Apr 2007 08:52:33 +1000
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       Willy Tarreau <w@1wt.eu>, hui Bill Huey <billh@gnuppy.monkey.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070413202100.GA9957@elte.hu> <Pine.LNX.4.64.0704151054080.5473@woody.linux-foundation.org> <6741477B-4621-4A50-952E-0D03260D9526@lundell-bros.com>
In-Reply-To: <6741477B-4621-4A50-952E-0D03260D9526@lundell-bros.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704160852.34241.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 April 2007 05:00, Jonathan Lundell wrote:
> On Apr 15, 2007, at 10:59 AM, Linus Torvalds wrote:
> > It's a really good thing, and it means that if somebody shows that
> > your
> > code is flawed in some way (by, for example, making a patch that
> > people
> > claim gets better behaviour or numbers), any *good* programmer that
> > actually cares about his code will obviously suddenly be very
> > motivated to
> > out-do the out-doer!
>
> "No one who cannot rejoice in the discovery of his own mistakes
> deserves to be called a scholar."

Lovely comment. I realise this is not truly directed at me but clearly in the 
context it has been said people will assume it is directed my way, so while 
we're all spinning lkml quality rhetoric, let me have a right of reply.

One thing I have never tried to do was to ignore bug reports. I'm forever 
joking that I keep pulling code out of my arse to improve what I've done. 
RSDL/SD was no exception; heck it had 40 iterations. The reason I could not 
reply to bug report A with "Oh that is problem B so I'll fix it with code C" 
was, as I've said many many times over, health related. I did indeed try to 
fix many of them without spending hours replying to sometimes unpleasant 
emails. If health wasn't an issue there might have been 1000 iterations of 
SD.

There was only ever _one_ thing that I was absolutely steadfast on as a 
concept that I refused to fix that people might claim was "a mistake I did 
not rejoice in to be a scholar". That was that the _correct_ behaviour for a 
scheduler is to be fair such that proportional slowdown with load is (using 
that awful pun) a feature, not a bug. Now there are people who will still 
disagree violently with me on that. SD attempted to be a fairness first 
virtual-deadline design. If I failed on that front, then so be it (and at 
least one person certainly has said in lovely warm fuzzy friendly 
communication that I'm a global failure on all fronts with SD). But let me 
point out now that Ingo's shiny new scheduler is a fairness-first 
virtual-deadline design which will have proportional slowdown with load. So 
it will have a very similar feature. I dare anyone to claim that proportional 
slowdown with load is a bug, because I will no longer feel like I'm standing 
alone with a BFG9000 trying to defend my standpoint. Others can take up the 
post at last.

-- 
-ck
