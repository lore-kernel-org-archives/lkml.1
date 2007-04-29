Return-Path: <linux-kernel-owner+w=401wt.eu-S1752250AbXD2BSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbXD2BSp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 21:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbXD2BSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 21:18:45 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:50330 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbXD2BSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 21:18:44 -0400
Subject: Re: [patch] CFS scheduler, -v6
From: Kasper Sandberg <lkml@metanurb.dk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>
In-Reply-To: <1177774551.21279.8.camel@localhost>
References: <20070425214704.GA32572@elte.hu>
	 <1177596399.14496.1.camel@localhost>
	 <200704261041.04838.gene.heskett@gmail.com>
	 <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu>
	 <20070427115526.GA7699@elte.hu>  <1177774551.21279.8.camel@localhost>
Content-Type: text/plain
Date: Sun, 29 Apr 2007 03:18:32 +0200
Message-Id: <1177809512.9756.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Okay so i've tried with cfs 7 now, and the completely broken audio
behavior is fixed.

The only things i really notice now is that gtk apps seems to redraw
somewhat slower, and renicing X doesent seem to be able to bring it on
par with SD or vanilla.

And smoothness just doesent match SD, it may be abit better than
vanilla/staircase, i cant really definitively say, but SD just has the
smoothness factor which is extremely attractive.

This is with 3d stuff, like through wine or natively on linux, under
load(and even just minor things like using a browser or other things,
like spamasassin), vanilla/staircase(not rsdl or sd)/cfs will go down in
FPS, but at the same time stutter, it goes down to around the same fps
under same load, as SD, but SD is completely smooth.

Im not sure im describing properly, but say it takes 35fps for the 3d
stuff to seem perfect, the fps monitor updates once every 1 or two
seconds, showing average fps(havent looked at the code, but i assume it
spans those 1-2 seconds), usually i have like 60 fps, but under load it
can go down to 35, but under anything but SD its not smooth, it will do
the 35 fps, but i suspect it does it in chunks, for example it will skip
for 200 ms and then hurry to display the 35 frames. This means it does
get the workload done, but not in a very plesant matter, and its here i
see SD as being in such a high league that its really impossible to
describe the results with any other word than Perfect.

mvh.
Kasper Sandberg

