Return-Path: <linux-kernel-owner+w=401wt.eu-S1752475AbXCDUha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbXCDUha (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 15:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbXCDUha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 15:37:30 -0500
Received: from [212.33.180.85] ([212.33.180.85]:32935 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752475AbXCDUh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 15:37:29 -0500
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Mar 2007 15:37:28 EST
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Date: Sun, 4 Mar 2007 23:35:26 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703042335.26785.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> > >> >> >This message is to announce the first general public release of
> > >> >> > the "Rotating Staircase DeadLine" cpu scheduler.

Thanks a lot!

> Just to make it clear. The purpose of this scheduler is at all costs to
> maintain absolute fairness no matter what type of load it is put under.

Great!

> This means that if you heavily load up your machine without the use of
> 'nice' then your interactive tasks _will_ slow down proportionately to the
> amount of cpu you use. So doing make -j4 for example will make any other
> task started in taht presence run precisely 1/5th speed, but they will
> still be responsive, have low latency (and audio shouldn't skip for
> example).

That's just what it did, but when you "nice make -j4", things (gears) start 
to stutter.  Is that due to the staircase?


Thanks!

--
Al

