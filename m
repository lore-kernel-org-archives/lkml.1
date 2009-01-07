Return-Path: <linux-kernel-owner+w=401wt.eu-S1753119AbZAGKwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbZAGKwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 05:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbZAGKwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 05:52:35 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38071 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752015AbZAGKwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 05:52:34 -0500
Date: Wed, 7 Jan 2009 10:52:01 +0000
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
Message-ID: <20090107105201.054c011f@lxorguk.ukuu.org.uk>
In-Reply-To: <49648163.9060007@davidnewall.com>
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
	<20090107095419.70b78dc7@lxorguk.ukuu.org.uk>
	<49648163.9060007@davidnewall.com>
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

> True but irrelevant because the RTC returns a timestamp.  And it's
> quietly understood that the RTC is only an approximation.

You miss the point.

The RTC stores the CMOS time in MM DD YY HH:MM:SS format. That conversion
is done kernel side when reading/writing the RTC chip. Thus if you are
using leap second timing your BIOS RTC values will not agree with the
expected value.

> However it is now clear that no special kernel support is required for
> leap-seconds, and any such code that's been incorporated needs to be
> removed.  Removed I say!

There never has been any. Its all handled (both posix and sane) by glibc.

Alan
