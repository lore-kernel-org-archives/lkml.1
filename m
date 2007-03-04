Return-Path: <linux-kernel-owner+w=401wt.eu-S1752505AbXCDVtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbXCDVtj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 16:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbXCDVti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 16:49:38 -0500
Received: from mail06.syd.optusnet.com.au ([211.29.132.187]:55106 "EHLO
	mail06.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752505AbXCDVti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 16:49:38 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Al Boldi <a1426z@gawab.com>, ck list <ck@vds.kolivas.org>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Date: Mon, 5 Mar 2007 08:49:29 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200703042335.26785.a1426z@gawab.com>
In-Reply-To: <200703042335.26785.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703050849.29674.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2007 07:35, Al Boldi wrote:
> Con Kolivas wrote:
> > > >> >> >This message is to announce the first general public release of
> > > >> >> > the "Rotating Staircase DeadLine" cpu scheduler.
>
> Thanks a lot!

You're welcome.
>
> > Just to make it clear. The purpose of this scheduler is at all costs to
> > maintain absolute fairness no matter what type of load it is put under.
>
> Great!
>
> > This means that if you heavily load up your machine without the use of
> > 'nice' then your interactive tasks _will_ slow down proportionately to
> > the amount of cpu you use. So doing make -j4 for example will make any
> > other task started in taht presence run precisely 1/5th speed, but they
> > will still be responsive, have low latency (and audio shouldn't skip for
> > example).
>
> That's just what it did, but when you "nice make -j4", things (gears) start
> to stutter.  Is that due to the staircase?

gears isn't an interactive task. Apart from using it as a background load to 
check for starvation because it loads up the cpu fully (which a gpu intensive 
but otherwise simple app like this should _not_ do) graphics card drivers and 
interrupts and so on, I wouldn't put much credence on gears as anything else. 
However I suspect that gears will still get a fair share of the cpu on RSDL 
which almost never happens on any other scheduler.

P.S. Al, please don't drop ccs from the original thread.

-- 
-ck
