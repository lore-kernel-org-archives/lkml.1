Return-Path: <linux-kernel-owner+w=401wt.eu-S1759565AbYGJRYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565AbYGJRYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbYGJRYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:24:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754599AbYGJRYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:24:02 -0400
Date: Thu, 10 Jul 2008 10:21:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.26-rc9-git4: Reported regressions from 2.6.25
In-Reply-To: <20080710110213.GA6688@martell.zuzino.mipt.ru>
Message-ID: <alpine.LFD.1.10.0807101020270.11076@woody.linux-foundation.org>
References: <4yrA-dRoNlD.A.jcB.ny-cIB@albercik> <200807101725.36175.nickpiggin@yahoo.com.au> <20080710110213.GA6688@martell.zuzino.mipt.ru>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Jul 2008, Alexey Dobriyan wrote:

> On Thu, Jul 10, 2008 at 05:25:35PM +1000, Nick Piggin wrote:
> > 
> > Attached is my fix for this problem. I don't think it is a regression
> > as such, but it can't hurt to go into 2.6.26 IMO.

Nick, you're a hero.

> > PREEMPT_RCU without HOTPLUG_CPU is broken.
> 
> Bastard!
> 
> rcutorture fixed here, starting cross-compile stuff (without much interest).

I'm marking this "tested-by" by you too, on the strength of that 
rcutorture thing. I think Nick nailed this one.

Good jorb,

		Linus
