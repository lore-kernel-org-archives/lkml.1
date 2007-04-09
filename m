Return-Path: <linux-kernel-owner+w=401wt.eu-S1752808AbXDIEX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbXDIEX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 00:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbXDIEXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 00:23:51 -0400
Received: from mail.gmx.net ([213.165.64.20]:56913 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752700AbXDIEXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 00:23:21 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/bwAAb99TbvPZQ7q3SG118Q9+Zwps/heXnBq4hlO
	1aAsb7OnnlK4H/
Subject: Re: Ten percent test
From: Mike Galbraith <efault@gmx.de>
To: Rene Herman <rene.herman@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Gene Heskett <gene.heskett@gmail.com>,
       linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
In-Reply-To: <461939A4.2020305@gmail.com>
References: <200703290237.38777.kernel@kolivas.org>
	 <200704071423.47790.gene.heskett@gmail.com>
	 <20070407185220.GA31725@elte.hu>
	 <200704071630.25830.gene.heskett@gmail.com>
	 <20070408104125.GB11123@elte.hu>  <461939A4.2020305@gmail.com>
Content-Type: text/plain
Date: Mon, 09 Apr 2007 06:23:18 +0200
Message-Id: <1176092598.6355.22.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-08 at 20:51 +0200, Rene Herman wrote:
> On 04/08/2007 12:41 PM, Ingo Molnar wrote:
> 
> > this is pretty hard to get right, and the most objective way to change 
> > it is to do it testcase-driven. FYI, interactivity tweaking has been 
> > gradual, the last bigger round of interactivity changes were done a year 
> > ago:
> > 
> >  commit 5ce74abe788a26698876e66b9c9ce7e7acc25413
> >  Author: Mike Galbraith <efault@gmx.de>
> >  Date:   Mon Apr 10 22:52:44 2006 -0700
> > 
> >      [PATCH] sched: fix interactive task starvation
> > 
> > (and a few smaller tweaks since then too.)
> > 
> > and that change from Mike responded to a testcase. Mike's latest changes 
> > (the ones you just tested) were mostly driven by actual testcases too, 
> > which measured long-term timeslice distribution fairness.
> 
> Ah yes, that one. Here's the next one in that series:
> 
> commit f1adad78dd2fc8edaa513e0bde92b4c64340245c
> Author: Linus Torvalds <torvalds@g5.osdl.org>
> Date:   Sun May 21 18:54:09 2006 -0700
> 
>      Revert "[PATCH] sched: fix interactive task starvation"
> 
> It personally had me wonder if _anyone_ was testing this stuff...

Well of course not.  Making random untested changes, and reverting them
later is half the fun of kernel development.

	-Mike

