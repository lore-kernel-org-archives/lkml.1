Return-Path: <linux-kernel-owner+w=401wt.eu-S1750893AbXCUI6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750893AbXCUI6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 04:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbXCUI6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 04:58:22 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:41619 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbXCUI6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 04:58:21 -0400
Subject: Re: [ck] Re: RSDL v0.31
From: Kasper Sandberg <lkml@metanurb.dk>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Mike Galbraith <efault@gmx.de>,
       Radoslaw Szkodzinski <astralstorm@gmail.com>,
       Al Boldi <a1426z@gawab.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ck@vds.kolivas.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nicholas Miell <nmiell@comcast.net>
In-Reply-To: <45FEF6D1.7020309@tmr.com>
References: <200703042335.26785.a1426z@gawab.com>
	 <200703172048.46267.kernel@kolivas.org>
	 <1174125534.7734.2.camel@Homer.simpson.net>
	 <200703172355.30989.a1426z@gawab.com>
	 <1174198651.8199.44.camel@Homer.simpson.net>
	 <1174200463.10498.23.camel@localhost>
	 <1174201726.8732.6.camel@Homer.simpson.net>
	 <f44c5fdf0703180022n44b2ca61o62602e54aaab3334@mail.gmail.com>
	 <1174203482.8855.8.camel@Homer.simpson.net>
	 <1174211853.10498.25.camel@localhost>  <45FEF6D1.7020309@tmr.com>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 09:58:03 +0100
Message-Id: <1174467483.22159.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 16:47 -0400, Bill Davidsen wrote:
> Kasper Sandberg wrote:
> > On Sun, 2007-03-18 at 08:38 +0100, Mike Galbraith wrote:
> >> On Sun, 2007-03-18 at 08:22 +0100, Radoslaw Szkodzinski wrote:
> >>
> >>> I'd recon KDE regresses because of kioslaves waiting on a pipe
> >>> (communication with the app they're doing IO for) and then expiring.
> >>> That's why splitting IO from an app isn't exactly smart. It should at
> >>> least be ran in an another thread.
> >> Hm.  Sounds rather a lot like the...
> >> X sucks, fix X and RSDL will rock your world.  RSDL is perfect.
> >> ...that I've been getting.
> >>
> > not really, only X sucks. KDE works atleast as good with rsdl as
> > vanilla. i dont know how originally said kde works worse, wasnt it just
> > someone that thought?
> > 
> It was probably me, and I had the opinion that KDE is not as smooth as 
> GNOME with RSDL. I haven't had time to measure, but using for daily 
> stuff for about an hour each way hasn't changed my opinion. Every once 
> in a while KDE will KLUNK to a halt for 200-300ms doing mundane stuff 
> like redrawing a page, scrolling, etc. I don't see it with GNOME.

umm, could you try to find something that always does it, so i can try
to reproduce? cause i dont really hit any such thing, and i only have a
2ghz amd64

> 

