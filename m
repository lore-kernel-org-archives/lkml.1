Return-Path: <linux-kernel-owner+w=401wt.eu-S1757432AbZAGJyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbZAGJyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 04:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbZAGJya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 04:54:30 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:32828 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756375AbZAGJy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 04:54:29 -0500
Date: Wed, 7 Jan 2009 09:54:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Newall <davidn@davidnewall.com>
Cc: Nick Andrew <nick@nick-andrew.net>, Linas Vepstas <linasvepstas@gmail.com>,
       david@lang.hm, Kyle Moffett <kyle@moffetthome.net>,
       Ben Goodger <goodgerster@gmail.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org, "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       Travis Crump <pretzalz@techhouse.org>, burdell@iruntheinter.net
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years
 2008-2009
Message-ID: <20090107095419.70b78dc7@lxorguk.ukuu.org.uk>
In-Reply-To: <496479EA.1020207@davidnewall.com>
References: <496076A9.7030907@davidnewall.com>
	<f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com>
	<4960897D.5030603@davidnewall.com>
	<alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm>
	<4961432A.80509@davidnewall.com>
	<alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm>
	<49614835.7000505@davidnewall.com>
	<3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com>
	<20090105143335.GC18055@mail.local.tull.net>
	<4962BB13.7060304@davidnewall.com>
	<20090106025125.GB28431@mail.local.tull.net>
	<20090106094058.64c89586@lxorguk.ukuu.org.uk>
	<496479EA.1020207@davidnewall.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The range of signed 32-bit times is 1901 through 2039, which has only
> one century, 2000, which is a leap year.  So the caveat for leap years
> is correct but unnecessary.

The standard however (and library code) were updated many years ago, so
the description is still wrong.

> So I've discoverd, at least on Ubuntu, something wonderful and
> reassuring.  It already works exactly the way I think is correct.  Look:
> I create a test timezone with no daylight saving and one leap second:

This is entirely configurable - see my earlier post about the "right" and
posix timezones. Really however that belongs on the glibc list.

As far as the kernel and leapseconds go - remember the kernel RTC support
does not know about leap seconds
