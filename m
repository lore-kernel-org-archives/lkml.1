Return-Path: <linux-kernel-owner+w=401wt.eu-S1753102AbXCRGs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbXCRGs0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 02:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753103AbXCRGs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 02:48:26 -0400
Received: from pfepc.post.tele.dk ([195.41.46.237]:53818 "EHLO
	pfepc.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbXCRGsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 02:48:11 -0400
Subject: Re: RSDL v0.31
From: Kasper Sandberg <lkml@metanurb.dk>
To: Mike Galbraith <efault@gmx.de>
Cc: Al Boldi <a1426z@gawab.com>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1174198651.8199.44.camel@Homer.simpson.net>
References: <200703042335.26785.a1426z@gawab.com>
	 <200703172048.46267.kernel@kolivas.org>
	 <1174125534.7734.2.camel@Homer.simpson.net>
	 <200703172355.30989.a1426z@gawab.com>
	 <1174198651.8199.44.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Sun, 18 Mar 2007 07:47:43 +0100
Message-Id: <1174200463.10498.23.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-18 at 07:17 +0100, Mike Galbraith wrote:
> On Sat, 2007-03-17 at 23:55 +0300, Al Boldi wrote:
> 
> > Mike, I'm not saying RSDL is perfect, but v0.31 is by far better than 
> > mainline.  Try this easy test:
> > 
> > startx with the vesa driver
> > run reflect from the mesa5.0-demos
> > load 5 cpu-hogs
> > start moving the mouse
> > 
> > On my desktop, mainline completely breaks down, and no nicing may rescue.
> 
> (hmm.. i would think that _renicing_ X would help that)
> 
> > On RSDL, even without nicing, the desktop is at least useable.
> 
> So neither does a good job with this load.
that sorely depends on what you mean by good job.

It seems like what you call a good job is preserving the speed of the
gui(X + apps which uses it) at _ALL_ costs to other stuff.

> 
> 	-Mike
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

