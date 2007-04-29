Return-Path: <linux-kernel-owner+w=401wt.eu-S1752987AbXD2RKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbXD2RKR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 13:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbXD2RKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 13:10:17 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:46170 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbXD2RJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 13:09:44 -0400
Subject: Re: [patch] CFS scheduler, -v6
From: Kasper Sandberg <lkml@metanurb.dk>
To: Ray Lee <madrabbit@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Willy Tarreau <w@1wt.eu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
In-Reply-To: <2c0942db0704290842j71a5d93cn10f7259559311642@mail.gmail.com>
References: <20070425214704.GA32572@elte.hu>
	 <200704261041.04838.gene.heskett@gmail.com>
	 <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu>
	 <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost>
	 <1177809512.9756.10.camel@localhost> <20070429053022.GB23638@1wt.eu>
	 <20070429065900.GB32281@elte.hu> <1177833575.9756.22.camel@localhost>
	 <2c0942db0704290842j71a5d93cn10f7259559311642@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 29 Apr 2007 19:09:27 +0200
Message-Id: <1177866567.9756.35.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-29 at 08:42 -0700, Ray Lee wrote:
> On 4/29/07, Kasper Sandberg <lkml@metanurb.dk> wrote:
> > On Sun, 2007-04-29 at 08:59 +0200, Ingo Molnar wrote:
> > > well, there are several reports of CFS being significantly better than
> > > SD on a number of workloads - and i know of only two reports where SD
> > > was reported to be better than CFS: in Kasper's test (where i'd like to
> > > know what the "3D stuff" he uses is and take a good look at that
> > > workload), and another 3D report which was done against -v6. (And even
> > > in these two reports the 'smoothness advantage' was not dramatic. If you
> > > know of any other reports then please let me know!)
> >
> > I can tell you one thing, its not just me that has observed the
> > smoothness in 3d stuff, after i tried rsdl first i've had lots of people
> > try rsdl and subsequently sd because of the significant improvement in
> > smoothness, and they have all found the same results.
> >
> > The stuff i have tested with in particular is unreal tournament 2004 and
> > world of warcraft through wine, both running opengl, and consuming all
> > the cpu time it can get.
> 
> [snip more of sd smoother than cfs report]
> 
> WINE is an interesting workload as it does most of its work out of
> process to the 'wineserver', which then does more work out of process
> to the X server. So, it's three mutually interacting processes total,
> once one includes the original client (Unreal Tournament or World of
> Warcraft, in this case).
the wineserver process is using next to no cpu-time compared to the main
process..

> 
> Perhaps running one of the windows system performance apps (that can
> be freely downloaded) under WINE would give some hard numbers people
> could use to try to reproduce the report.
> 
> Ray
> 

