Return-Path: <linux-kernel-owner+w=401wt.eu-S1762272AbXEYLzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762272AbXEYLzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 07:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbXEYLzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 07:55:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42929 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989AbXEYLzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 07:55:47 -0400
Date: Fri, 25 May 2007 13:55:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] sched_clock(): cleanups, #2
Message-ID: <20070525115544.GP8094@one.firstfloor.org>
References: <20070525084426.GA29973@elte.hu> <20070525084547.GJ8094@one.firstfloor.org> <20070525015544.bce3cb99.akpm@linux-foundation.org> <20070525090315.GK8094@one.firstfloor.org> <20070525091928.GA3177@elte.hu> <20070525094640.GL8094@one.firstfloor.org> <20070525101248.GA7547@elte.hu> <20070525112020.GN8094@one.firstfloor.org> <20070525112600.GA27007@elte.hu> <20070525115004.GA4574@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525115004.GA4574@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 01:50:04PM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > > please send me your current sched-clock.c, i'll redo any remaining 
> > > > cleanups.
> > > 
> > > It needs at least one new preliminary patch (to add on_cpu_single);
> > > please get the series from 
> > > ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches-2.6.22-rc2-git7-070525-1.tar.gz
> > > You need at least tsc-unstable upto paravirt-add-a-sched_clock-paravirt
> > > for everything
> > 
> > thanks.
> > 
> > you missed one patch: please pick up the NUMAQ change i did too. (i 
> > kept the printk to make sure someone notices that and actually tests 
> > thing - i dont have a NUMAQ machine to try this on.)
> > 
> > i'm looking at the other things now.
> 
> find below the cleanups from my first patch that didnt make it into your 
> cleanups. (plus one more cleanup i noticed while merging the missing 
> bits from my first patch) Goes after the bugfix i just sent. Please 
> apply.

I cannot apply it as is because it changes code from the paravirtops
patch too.

BTW to nitpick the original formattings you changed are all probably
standard code style and the new comment is a classical
i++; /* Increase i */

I'll fold the comment change into Jeremy's paravirt ops patch.

-Andi
