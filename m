Return-Path: <linux-kernel-owner+w=401wt.eu-S1750714AbXCUI4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750714AbXCUI4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 04:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbXCUI4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 04:56:18 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:40618 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbXCUI4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 04:56:17 -0400
Subject: Re: RSDL v0.31
From: Kasper Sandberg <lkml@metanurb.dk>
To: ray-gmail@madrabbit.org
Cc: Mark Lord <lkml@rtr.ca>, Linus Torvalds <torvalds@linux-foundation.org>,
       Xavier Bestel <xavier.bestel@free.fr>, Al Boldi <a1426z@gawab.com>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <2c0942db0703200816r36544407o1f60270c5d1da7af@mail.gmail.com>
References: <200703042335.26785.a1426z@gawab.com>
	 <200703172048.46267.kernel@kolivas.org>
	 <1174125534.7734.2.camel@Homer.simpson.net>
	 <200703172355.30989.a1426z@gawab.com> <45FEB54A.3040602@rtr.ca>
	 <1174321617.30876.69.camel@frg-rhel40-em64t-04> <45FEBBF5.9060002@rtr.ca>
	 <1174322580.30876.72.camel@frg-rhel40-em64t-04>
	 <Pine.LNX.4.64.0703192006130.6730@woody.linux-foundation.org>
	 <45FFDFF8.2090208@rtr.ca>
	 <2c0942db0703200816r36544407o1f60270c5d1da7af@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 09:55:29 +0100
Message-Id: <1174467329.22159.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-20 at 08:16 -0700, Ray Lee wrote:
> On 3/20/07, Mark Lord <lkml@rtr.ca> wrote:
> > I've droppped it from my machine -- interactive response is much
> > more important for my primary machine right now.
> 
> Help out with a data point? Are you running KDE as well? If you are,
> then it looks like the common denominator that RSDL is handling poorly
> is client-server communication. (KDE's KIO slaves in this case, but X
> in general.)

im not experiencing any problems with KDE. if anything ktorrent seems to
be going a teeny tiny bit smoother, though its nothing i can back up
with data.

now i havent tested ALL kioslaves yet, but stuff like sftp, fish, tar
and such works just as good.


> 
> If so, one would hope that a variation on Linus's 2.5.63 pipe wakeup
> pass-the-interactivity idea could work here. The problem with that
> original patch, IIRC, was that a couple of tasks could bounce their
> interactivity bonus back and forth and thereby starve others. Which
> might be expected given there was no 'decaying' of the interactivity
> bonus, which means you can make a feedback loop.
> 
> Anyway, looks like processes that do A -> B -> A communication chains
> are getting penalized under RSDL. In which case, perhaps I can make a
> test case that exhibits the problem without having to have the same
> graphics card or desktop as you.
An easy-to-reproduce testcase would be good.

> 
> Ray
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

