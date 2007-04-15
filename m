Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869AbXDOPrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbXDOPrJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 11:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbXDOPrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 11:47:09 -0400
Received: from holomorphy.com ([66.93.40.71]:48456 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbXDOPrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 11:47:08 -0400
Date: Sun, 15 Apr 2007 08:47:09 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Willy Tarreau <w@1wt.eu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       hui Bill Huey <billh@gnuppy.monkey.org>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070415154709.GC2986@holomorphy.com>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415051645.GA28438@gnuppy.monkey.org> <20070415084447.GC24886@elte.hu> <20070415095146.GA30327@gnuppy.monkey.org> <84144f020704150339i4a0d437fja6868ab671558ba1@mail.gmail.com> <20070415124527.GP943@1wt.eu> <20070415153933.GB6623@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070415153933.GB6623@elte.hu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Willy Tarreau <w@1wt.eu> wrote:
>> [...] and using part of Bill's work to speed up development.

On Sun, Apr 15, 2007 at 05:39:33PM +0200, Ingo Molnar wrote:
> ok, let me make this absolutely clear: i didnt use any bit of plugsched 
> - in fact the most difficult bits of the modularization was for areas of 
> sched.c that plugsched never even touched AFAIK. (the load-balancer for 
> example.)
> Plugsched simply does something else: i modularized scheduling policies 
> in essence that have to cooperate with each other, while plugsched 
> modularized complete schedulers which are compile-time or boot-time 
> selected, with no runtime cooperation between them. (one has to be 
> selected at a time)
> (and i have no trouble at all with crediting Will's work either: a few 
> years ago i used Will's PID rework concepts for an NPTL related speedup 
> and Will is very much credited for it in today's kernel/pid.c and he 
> continued to contribute to it later on.)
> (the tree walking bits of sched_fair.c were in fact derived from 
> kernel/hrtimer.c, the rbtree code written by Thomas and me :-)

The extant plugsched patches have nothing to do with cfs; I suspect
what everyone else is going on about is terminological confusion. The
4-year-old sample policy with scheduling classes for the original
plugsched is something you had no way of knowing about, as it was never
publicly posted. There isn't really anything all that interesting going
on here, apart from pointing out that it's been done before.


-- wli
