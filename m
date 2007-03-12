Return-Path: <linux-kernel-owner+w=401wt.eu-S1030672AbXCLRHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030672AbXCLRHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 13:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030679AbXCLRHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 13:07:22 -0400
Received: from pqueuea.post.tele.dk ([193.162.153.9]:46201 "EHLO
	pqueuea.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030672AbXCLRHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 13:07:20 -0400
X-Greylist: delayed 1642 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Mar 2007 13:07:20 EDT
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
From: Kasper Sandberg <lkml@metanurb.dk>
To: Con Kolivas <kernel@kolivas.org>
Cc: Xavier Bestel <xavier.bestel@free.fr>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200703122134.13554.kernel@kolivas.org>
References: <200703111457.17624.kernel@kolivas.org>
	 <200703122022.43021.kernel@kolivas.org>
	 <1173692319.5835.611.camel@frg-rhel40-em64t-03>
	 <200703122134.13554.kernel@kolivas.org>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 17:38:38 +0100
Message-Id: <1173717518.26350.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-12 at 21:34 +1100, Con Kolivas wrote:
> On Monday 12 March 2007 20:38, Xavier Bestel wrote:
> > On Mon, 2007-03-12 at 20:22 +1100, Con Kolivas wrote:
> > > On Monday 12 March 2007 19:55, Mike Galbraith wrote:
> > > > Hmm.  So... anything that's client/server is going to suffer horribly
> > > > unless niced tasks are niced all the way down to 19?
> > >
> > > Fortunately most client server models dont usually have mutually
> > > exclusive cpu use like this X case. There are many things about X that
> > > are still a little (/me tries to think of a relatively neutral term)...
> > > wanting. :(
> >
> > I'd say the problem is less with X than with Xlib, which is heavily
> > round-trip-based. Fortunately XCB (its successor) seeks to be more
> > asynchronous.
> 
> Yes I recall a talk by Keith Packard on Xorg development and how a heck of a 
> lot of time spent spinning by X (?Xlib) for no damn good reason was the 
> number one thing that made X suck and basically it was silly to try and fix 
> that at the cpu scheduler level since it needed to be corrected in X, and was 
> being actively addressed. So we should stop trying to write cpu schedulers 
> for X.
Excuse me for barging in. But.

with latest xorg, xlib will be using xcb internally, which afaik should
help matters a little, but furthermore, with the arrival of xcb, stuff
are bound to change somewhat fast, and with abit more incentive(as in,
real benefit on latest kernels), they are bound to change even faster.

and if people upgrading to newest X(using xlib w/xcb) and applications
being updated can help stuff out in the kernel, i'd say its best to push
for that.
> 
> > 	Xav
> 

