Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbZAFCAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbZAFCAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 21:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbZAFCAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 21:00:05 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:43081 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbZAFCAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 21:00:04 -0500
Message-ID: <4962BB13.7060304@davidnewall.com>
Date: Tue, 06 Jan 2009 12:29:47 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Nick Andrew <nick@nick-andrew.net>
CC: Linas Vepstas <linasvepstas@gmail.com>, david@lang.hm,
       Kyle Moffett <kyle@moffetthome.net>,
       Ben Goodger <goodgerster@gmail.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org, "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       Travis Crump <pretzalz@techhouse.org>, burdell@iruntheinter.net
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years
 2008-2009
References: <495F0672.6020708@davidnewall.com> <8752a8760901022237r75d408b3i74c703c8ac2d4597@mail.gmail.com> <496076A9.7030907@davidnewall.com> <f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com> <4960897D.5030603@davidnewall.com> <alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm> <4961432A.80509@davidnewall.com> <alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm> <49614835.7000505@davidnewall.com> <3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com> <20090105143335.GC18055@mail.local.tull.net>
In-Reply-To: <20090105143335.GC18055@mail.local.tull.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Andrew wrote:
> I can sympathise with the opinion that linux should be able to accurately
> distinguish xx:59:60 when a leap second is added (or the missing :59 when
> one is subtracted) but not at the expense of making a day which is not
> 86400 seconds long.
>   

Some days are not 86400 seconds long.  That's a fact and regardless of
how inconvenient it is, we have to live with it.  Some years don't have
365 days; some months don't have 30 days; some Februaries don' have 28
days; and now, some days don't have 86400 seconds. What's the point in
fighting this?

If you want to know the days between two times, dividing by 86400
doesn't cut it.


> Arguably the kernel's responsibility should be to keep track of the
> most fundamental representation of time possible for a machine (that's
> probably TAI) and it is a userspace responsibility to map from that
> value to other time standards including UTC, using control files
> which are updated as leap seconds are declared.

We have this already; zoneinfo

> Just so long as the
> existing behaviour of time() which doesn't recognise leap seconds
> is preserved.

I haven't been able to find this Annex B that Alan talked of, so I can
only go by the man page, which states, simply and explicitly, that
time() returns seconds since Epoch, and also that Epoch is start of
January 1 1970.  To my mind, time *does* recognise leap seconds.
