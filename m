Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbXD2HSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbXD2HSK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 03:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756258AbXD2HSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 03:18:09 -0400
Received: from 1wt.eu ([62.212.114.60]:2346 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756243AbXD2HSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 03:18:06 -0400
Date: Sun, 29 Apr 2007 09:16:27 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070429071627.GC23638@1wt.eu>
References: <20070425214704.GA32572@elte.hu> <1177596399.14496.1.camel@localhost> <200704261041.04838.gene.heskett@gmail.com> <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu> <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost> <1177809512.9756.10.camel@localhost> <20070429053022.GB23638@1wt.eu> <20070429065900.GB32281@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070429065900.GB32281@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 08:59:01AM +0200, Ingo Molnar wrote:
> 
> * Willy Tarreau <w@1wt.eu> wrote:
> 
> > I don't know if Mike still has problems with SD, but there are now 
> > several interesting reports of SD giving better feedback than CFS on 
> > real work. In my experience, CFS seems smoother on *technical* tests, 
> > which I agree that they do not really simulate real work.
> 
> well, there are several reports of CFS being significantly better than 
> SD on a number of workloads - and i know of only two reports where SD 
> was reported to be better than CFS: in Kasper's test (where i'd like to 
> know what the "3D stuff" he uses is and take a good look at that 
> workload), and another 3D report which was done against -v6. (And even 
> in these two reports the 'smoothness advantage' was not dramatic. If you 
> know of any other reports then please let me know!)

There was Caglar Onur too but he said he will redo all the tests. I'm
not tracking all tests nor versions, so it might be possible that some
of the differences vanish with v7.

In fact, what I'd like to see in 2.6.22 is something better for everybody
and with *no* regression, even if it's not perfect. I had the feeling
that SD matched that goal right now, except for Mike who has not tested
recent versions. Don't get me wrong, I still think that CFS is a more
interesting long-term target. But it may require more time to satisfy
everyone. At least with one of them in 2.6.22, we won't waste time
comparing to current mainline.

> 	Ingo

Willy

