Return-Path: <linux-kernel-owner+w=401wt.eu-S1757141AbZAGJiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbZAGJiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 04:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbZAGJiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 04:38:06 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35415 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752567AbZAGJiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 04:38:04 -0500
Date: Wed, 7 Jan 2009 09:37:24 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nick Andrew <nick@nick-andrew.net>
Cc: David Newall <davidn@davidnewall.com>,
       Linas Vepstas <linasvepstas@gmail.com>, david@lang.hm,
       Kyle Moffett <kyle@moffetthome.net>,
       Ben Goodger <goodgerster@gmail.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org, "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       Travis Crump <pretzalz@techhouse.org>, burdell@iruntheinter.net
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years
 2008-2009
Message-ID: <20090107093724.0c405f5a@lxorguk.ukuu.org.uk>
In-Reply-To: <20090107011713.GA27527@mail.local.tull.net>
References: <4960897D.5030603@davidnewall.com>
	<alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm>
	<4961432A.80509@davidnewall.com>
	<alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm>
	<49614835.7000505@davidnewall.com>
	<3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com>
	<20090105143335.GC18055@mail.local.tull.net>
	<4962BB13.7060304@davidnewall.com>
	<20090106025125.GB28431@mail.local.tull.net>
	<20090106094058.64c89586@lxorguk.ukuu.org.uk>
	<20090107011713.GA27527@mail.local.tull.net>
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

> "man 2 time" on Debian Lenny. The treatment of leap years looks ridiculous, but
> within the context of a 32-bit time_t, all divisible-by-4 years between 1901 and
> 2038 are leap years. It's a bit of a problem for 64-bit time_t though.

Then Debian documentation needs fixing. POSIX fixed their definition some
years ago.
