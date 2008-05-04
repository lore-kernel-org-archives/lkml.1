Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbYEDHsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbYEDHsT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 03:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbYEDHsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 03:48:10 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:40759 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbYEDHsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 03:48:09 -0400
Date: Sun, 4 May 2008 10:47:08 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Valdis.Kletnieks@vt.edu
Cc: Ingo Molnar <mingo@elte.hu>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ingo, no more kconfig patches
Message-ID: <20080504074708.GD5838@cs181133002.pp.htv.fi>
References: <20080430230100.GK29330@cs181133002.pp.htv.fi> <20080501025234.GE27574@elte.hu> <20080501115923.GX29330@cs181133002.pp.htv.fi> <20080503191445.GF5292@elte.hu> <20080503202416.GR5838@cs181133002.pp.htv.fi> <20080503210300.GA10979@elte.hu> <20080503212429.GT5838@cs181133002.pp.htv.fi> <20080503215214.GA18407@elte.hu> <20080503220330.GV5838@cs181133002.pp.htv.fi> <19743.1209873251@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <19743.1209873251@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2008 at 11:54:11PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Sun, 04 May 2008 01:03:30 +0300, Adrian Bunk said:
> > On Sat, May 03, 2008 at 11:52:14PM +0200, Ingo Molnar wrote:
> 
> > > My larger point is that this kconfig tool bug breeds a constant stream 
> > > of avoidable breakages, which causes lost manpower and causes a stream 
> > > of trivial patches hindering maintainers all around the tree. Because 
> > > every such trivial patch has to be reviewed, tested, it clogs the commit 
> > > logs, etc.
> > > 
> > > So the more trivial patches we _avoid_ having to do in the future, the 
> > > better. I'm not sure why you are even arguing against this this rather 
> > > simple point - your arguments are rather hard to understand. Wouldnt you 
> > > be happier if a whole category of trivial breakages was avoided and if 
> > > you didnt have to deal with and waste your time on that category of 
> > > trivial patches anymore?
> > > 
> > > Most of the time reoccuring trivial patches are an indicator of some 
> > > deeper structural problem - as in this case.
> > 
> > Your conclusions are based on an assumption that isn't true.
> > 
> > "trivial patches" are the patches you send.
> > 
> > But they are often bogus.
> > 
> > Fixing these issues properly often requires a deeper understanding of 
> > both kconfig and the dependencies of the underlying code.
> 
> I suspect that Ingo is however correct

Ingo claims the problem was trivial since the patches were trivial.

But fact is they aren't trivial - as you can e.g. see on Ingos patch 
that started this thread, and that was for the completely wrong place.

> - although a *proper* fix of one of
> these bugs requires human-intelligence to figure out what's *really* intended,
> the kconfig program *does* have enough information available to issue a a clear
> warning:
> 
> "Yo doodz - I don't know *what* you intended here, but this SELECT is just
> waiting to sink its teeth into somebody's posterior.  You might want to fix it
> somehow before somebody needs rabies shots..."
>...

And what do you want to do in such a case?

Kconfig is a user interface, and we actually need such cases you want to 
warn for for getting a good UI.

We already know what can cause problems.

But as far as I know there are no such problems users actually ran into 
in recent stable kernels - and most of the problems (like the one in 
this thread) are pathological cornercases you only see with randconfig.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

