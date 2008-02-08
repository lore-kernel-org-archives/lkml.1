Return-Path: <linux-kernel-owner+w=401wt.eu-S933504AbYBHJ3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933504AbYBHJ3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 04:29:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759329AbYBHJ2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 04:28:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51442 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759219AbYBHJ2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 04:28:46 -0500
Subject: Re: MM kernels 2.6.24-rc*-mm*, 2.6.24-mm1: gnome-terminal stuck in
	tty_poll
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jay Cliburn <jacliburn@bellsouth.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zan Lynx <zlynx@acm.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080207192623.0471f08e@osprey.hogchain.net>
References: <1202326722.7488.46.camel@localhost>
	 <47AA68AA.3090009@bellsouth.net>
	 <20080206182329.b0956b4a.akpm@linux-foundation.org>
	 <1202413744.6274.26.camel@lappy> <1202415887.6274.40.camel@lappy>
	 <20080207192623.0471f08e@osprey.hogchain.net>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 10:28:31 +0100
Message-Id: <1202462912.6274.56.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-07 at 19:26 -0600, Jay Cliburn wrote:
> On Thu, 07 Feb 2008 21:24:47 +0100
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> The trace isn't from me; it's from Zan.  He's running -mm, I'm not, if
> that makes a difference.
> 
> >         
> >         Call Trace:
> >          [schedule_timeout+149/208] schedule_timeout+0x95/0xd0
> >          [<ffffffff8057dde5>] schedule_timeout+0x95/0xd0
> >          [tty_poll+145/160] tty_poll+0x91/0xa0
> >          [<ffffffff80430f11>] tty_poll+0x91/0xa0
> >          [do_sys_poll+617/880] do_sys_poll+0x269/0x370
> >          [<ffffffff802bbe69>] do_sys_poll+0x269/0x370
> >          [__pollwait+0/304] __pollwait+0x0/0x130
> >          [<ffffffff802bcb30>] __pollwait+0x0/0x130
> 
> Now that my computer is back on the air again, I'll be happy to help
> track this down.  Just tell me what to do.

First would be to see if you could get a sysrq-t dump of the blocked
process. I'm curious if yours would point to the same spot.

Also, could you describe how to reproduce it, given that you managed to
have it reproducable enough to bisect, I'd say you have a good case.

I installed gnome-terminal, started it and wiggled it about while doing
find / - that didn't manage to get it to lock up - but I'll try again if
that is the right way.

