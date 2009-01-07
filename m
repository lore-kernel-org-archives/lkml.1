Return-Path: <linux-kernel-owner+w=401wt.eu-S1753682AbZAGKSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbZAGKSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 05:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756262AbZAGKS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 05:18:27 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:43340 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001AbZAGKS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 05:18:26 -0500
Message-ID: <49648163.9060007@davidnewall.com>
Date: Wed, 07 Jan 2009 20:48:11 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Nick Andrew <nick@nick-andrew.net>, Linas Vepstas <linasvepstas@gmail.com>,
       david@lang.hm, Kyle Moffett <kyle@moffetthome.net>,
       Ben Goodger <goodgerster@gmail.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org, "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       Travis Crump <pretzalz@techhouse.org>, burdell@iruntheinter.net
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years
 2008-2009
References: <496076A9.7030907@davidnewall.com>	<f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com>	<4960897D.5030603@davidnewall.com>	<alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm>	<4961432A.80509@davidnewall.com>	<alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm>	<49614835.7000505@davidnewall.com>	<3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com>	<20090105143335.GC18055@mail.local.tull.net>	<4962BB13.7060304@davidnewall.com>	<20090106025125.GB28431@mail.local.tull.net>	<20090106094058.64c89586@lxorguk.ukuu.org.uk>	<496479EA.1020207@davidnewall.com> <20090107095419.70b78dc7@lxorguk.ukuu.org.uk>
In-Reply-To: <20090107095419.70b78dc7@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> As far as the kernel and leapseconds go - remember the kernel RTC support
> does not know about leap seconds
>   

True but irrelevant because the RTC returns a timestamp.  And it's
quietly understood that the RTC is only an approximation.

The remaining fly in the ointment, if indeed the NTP client doesn't
already do what I've outlined, is that leap seconds aren't reckoned into
NTP broadcasts.  As intimated, this is correctable using leap second
information from zoneinfo.

Even though this is manifestly not a kernel issue, I'll work up a patch
for ntpdate (apparently what I use) and post her, which I'm sure will be
useful for all other NTP clients.

However it is now clear that no special kernel support is required for
leap-seconds, and any such code that's been incorporated needs to be
removed.  Removed I say!
