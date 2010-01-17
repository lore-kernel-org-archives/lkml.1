Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093Ab0AQPSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab0AQPSF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 10:18:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910Ab0AQPSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 10:18:01 -0500
Received: from lo.gmane.org ([80.91.229.12]:40212 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836Ab0AQPSA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 10:18:00 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Florian Mickler <florian@mickler.org>
Subject: Re: 2.6.33-rc2: Reported regressions from 2.6.32
Date: Sun, 17 Jan 2010 16:17:26 +0100
Message-ID: <20100117161726.5752b181@schatten.dmk.lab>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
	<20100116174821.GA18306@redhat.com>
	<201001162257.16277.rjw@sisk.pl>
	<alpine.LFD.2.00.1001161402400.13231@localhost.localdomain>
	<20100117123218.GA3182@redhat.com>
	<84144f021001170618g708a7c14ob1b222ab1cbdaa20@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p4ff662ab.dip.t-dialin.net
X-Newsreader: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Cc: kernel-testers@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jan 2010 16:18:39 +0200
Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Sun, Jan 17, 2010 at 2:32 PM, Michael S. Tsirkin
> <m.s.tsirkin@gmail.com> wrote:
> > On Sat, Jan 16, 2010 at 02:04:07PM -0800, Linus Torvalds wrote:
> >>
> >>
> >> On Sat, 16 Jan 2010, Rafael J. Wysocki wrote:
> >> >
> >> > > Immediately upon startup, screen is flickering (becomes
> >> > > lighter and darker again). The problem occurs with kernels
> >> > > 2.6.33-rc1 to 2.6.33-rc4, but not with kernel 2.6.32 and below.
> >> >
> >> > We've already had several reports like this already.
> >> >
> >> > Care to review the bugs linked to http://bugzilla.kernel.org/show_bug.cgi?id=14885
> >> > and check if none of them matches the problem you describe?
> >>
> >> I suspect that should be fixed by commit 33814341f22 ("drm/i915: disable
> >> LVDS downclock by default") that got merged today.
> >>
> >> So try current -git.
> >>
> >>               Linus
> >
> >
> > Tested with 6ccf80eb15ccaca4d3f1ab5162b9ded5eecd9971, still get
> > the flickering effect. so 33814341f22 does not seem to help.
> 
> Yeah, me too which is why I am doing a git bisect here. What's strange
> about it is that the first bisection point seems to suggest that the
> regression happened _before_ the DRM merge to 2.6.33-rc1. I guess it's
> possible that the bug is already in 2.6.32 but I've yet to see the
> flickering effect. Oh well, back to bisect...
> 
>                         Pekka

on which side of the merge? linus or drm? 
i.e. it is to be expected to be before the merge, (but on the drm side)
so don't get confused... or did i misunderstood the situation?


