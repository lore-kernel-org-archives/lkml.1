Return-Path: <linux-kernel-owner+w=401wt.eu-S1752179AbZILHrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbZILHrr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 03:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbZILHrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 03:47:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:49121 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbZILHrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 03:47:46 -0400
Date: Sat, 12 Sep 2009 09:51:10 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Nikos Chantziaras <realnc@arcor.de>
Cc: Volker Armin Hemmann <volkerarmin@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Con Kolivas <kernel@kolivas.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090912095110.6db75091@infradead.org>
In-Reply-To: <4AAB4FC9.4060402@arcor.de>
References: <200909112033.34445.volkerarmin@googlemail.com>
	<4AAB4FC9.4060402@arcor.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Sep 2009 10:37:45 +0300
Nikos Chantziaras <realnc@arcor.de> wrote:

> (Volker stripped all CCs from his posts; I restored them manually.)
> 
> On 09/11/2009 09:33 PM, Volker Armin Hemmann wrote:
> > Hi,
> >
> > this is with 2.6.31+reiser4+fglrx
> > Phenom II X4 955
> >
> > KDE 4.3.1, composite temporary disabled.
> > tvtime running.
> >
> > load:
> > fat emerge with make -j5 running in one konsole tab (xulrunner being
> > compiled).
> >
> > without NO_NEW_FAIR_SLEEPERS:
> >
> > tvtime is smooth most of the time
> >
> > with NO_NEW_FAIR_SLEEPERS:
> >
> > tvtime is more jerky. Very visible in scenes with movement.
> 
> Is the make -j5 running niced 0?  If yes, that would be actually the 
> correct behavior.  Unfortunately, I can't test tvtime specifically (I 
> don't have a TV card), but other applications displaying video
> continue to work smooth on my dual core machine (Core 2 Duo E6600)
> even if I do "nice -n 19 make -j20".  If I don't nice it, the video
> is skippy here too though.
> 
> Question to Ingo:
> Would posting perf results help in any way with finding differences 
> between mainline NEW_FAIR_SLEEPERS/NO_NEW_FAIR_SLEEPERS and BFS?

please also post latencytop output for the app you care about
(the system wide latencytop numbers aren't as relevant; to some large
degree what is happening is that if you oversubscribe, you need to pay
the price for that period, all you can do is move the cost around to
those tasks you don't care about. For that reason, latencytop output
for the task you care about is relevant ;-)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
