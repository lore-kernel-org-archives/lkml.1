Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbYFYJLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbYFYJLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 05:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356AbYFYJKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 05:10:53 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:52442 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbYFYJKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 05:10:52 -0400
Date: Wed, 25 Jun 2008 02:04:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Adrian Bunk <bunk@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [Bug #10815] 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
Message-ID: <20080625090400.GB11325@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080615232754.GD17915@linux.vnet.ibm.com> <alpine.LFD.1.10.0806151633290.2949@woody.linux-foundation.org> <20080616030154.GA7445@martell.zuzino.mipt.ru> <20080616033126.GF17915@linux.vnet.ibm.com> <20080616034659.GA7600@martell.zuzino.mipt.ru> <20080617034228.GA18217@linux.vnet.ibm.com> <20080624005053.GA4827@martell.zuzino.mipt.ru> <20080624120404.GA7978@linux.vnet.ibm.com> <20080624210812.GA27486@linux.vnet.ibm.com> <20080624211547.GB27452@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080624211547.GB27452@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 11:15:47PM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > > >   Also Core 2 Duo, x86_64 [1]
> > > > 
> > > >   Race is wide -- 60 seconds of rcutorture is enough.
> > 
> > This is rcutorture by itself, or in parallel with LTP/kernbench?
> > 
> > (I have mostly been running on 4-CPU boxes without failure either way, 
> > so will try a dual-CPU box.)
> 
> FYI, i've been running rcutorture for days on lots of testboxes ranging 
> all across the x86 spectrum from single CPU, through dual-core, to 
> dual-socket, dual-socket HT, 8-way and 16-way - both 32-bit and 64-bit 
> x86.
> 
> Not a single failure has been detected in thousands of bootups of random 
> kernels (rcu-preempt + rcutorture was a frequent combination tested). I 
> added a WARN_ON() to rcutorture failures so it should show up very 
> clearly.
> 
> This makes me suspect that it might be some special environment issue - 
> gcc for example. I'm using gcc 4.2.2 on most of the testboxes.

And running rcutorture overnight on an Opteron system (9.7M updates) showed
no failures.

						Thanx, Paul
