Return-Path: <linux-kernel-owner+w=401wt.eu-S933387AbXCQIqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387AbXCQIqi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 04:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933651AbXCQIqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 04:46:38 -0400
Received: from mail.gmx.net ([213.165.64.20]:43570 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933387AbXCQIqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 04:46:37 -0400
X-Provags-ID: V01U2FsdGVkX183cN5vBpQ36HggsOu+ypsFwIYofuMqLh3OKMpaVz
	BFQu0lQ9s5hif4
Subject: Re: RSDL v0.31
From: Mike Galbraith <efault@gmx.de>
To: David Lang <david.lang@digitalinsight.com>
Cc: Ingo Molnar <mingo@elte.hu>, Nicholas Miell <nmiell@comcast.net>,
       Con Kolivas <kernel@kolivas.org>, ck@vds.kolivas.org,
       Al Boldi <a1426z@gawab.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.63.0703162326020.6015@qynat.qvtvafvgr.pbz>
References: <200703042335.26785.a1426z@gawab.com>
	 <200703170040.48316.kernel@kolivas.org>
	 <1174059299.7886.25.camel@Homer.simpson.net>
	 <200703170813.32594.kernel@kolivas.org>
	 <1174084207.7009.9.camel@Homer.simpson.net>
	 <1174105443.3144.4.camel@entropy>
	 <1174110965.7911.44.camel@Homer.simpson.net>
	 <1174112768.3144.8.camel@entropy> <20070317074506.GA13685@elte.hu>
	 <Pine.LNX.4.63.0703162326020.6015@qynat.qvtvafvgr.pbz>
Content-Type: text/plain
Date: Sat, 17 Mar 2007 09:46:27 +0100
Message-Id: <1174121187.8647.20.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-16 at 23:44 -0800, David Lang wrote:

> why isn't niceing X to -10 an acceptable option?

Xorg's priority is only part of the problem.  Every client that needs a
substantial quantity of cpu while a hog is running will also need to be
negative nice, no?

> if you overload the box enough things slow down, what scheduler avoids that?

(Hmm.  What's overload in a multi-tasking multi-threaded world?  I'm
always going to have more tasks available than cpus at some time.  With
KDE, seems to be the norm any time I poke a button)

> where RSDL 'regresses' is with multiple CPU hog running at once (more then the 
> number of real CPU's you have available) at the same priority, with one of them 
> being the X server process.
> 
> the initial report was that with X + 2 cpu hogs on 1.5 cpu's there's more of a 
> slowdown (even with a nice difference of 5 between X and the other processes)

I see interactivity regression with both X and client at nice -10 in the
presence of any cpu hog load.  Maybe a bug lurks.  Maybe it's fairness.

	-Mike

