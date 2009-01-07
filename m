Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbZAGNqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbZAGNqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbZAGNqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:46:04 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:43397 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbZAGNqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:46:03 -0500
Message-ID: <4964B20B.4030406@davidnewall.com>
Date: Thu, 08 Jan 2009 00:15:47 +1030
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
References: <496076A9.7030907@davidnewall.com>	<f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com>	<4960897D.5030603@davidnewall.com>	<alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm>	<4961432A.80509@davidnewall.com>	<alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm>	<49614835.7000505@davidnewall.com>	<3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com>	<20090105143335.GC18055@mail.local.tull.net>	<4962BB13.7060304@davidnewall.com>	<20090106025125.GB28431@mail.local.tull.net>	<20090106094058.64c89586@lxorguk.ukuu.org.uk>	<496479EA.1020207@davidnewall.com>	<20090107095419.70b78dc7@lxorguk.ukuu.org.uk>	<49648163.9060007@davidnewall.com> <20090107105201.054c011f@lxorguk.ukuu.org.uk>
In-Reply-To: <20090107105201.054c011f@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> True but irrelevant because the RTC returns a timestamp.  And it's
>> quietly understood that the RTC is only an approximation.
>>     
>
> You miss the point.
>   

No, I got the point.  I see no problem.

> The RTC stores the CMOS time in MM DD YY HH:MM:SS format.

Yes, which is perfect for mktime(), which knows about leap seconds and
so produces the correct time_t.


>> However it is now clear that no special kernel support is required for
>> leap-seconds, and any such code that's been incorporated needs to be
>> removed.  Removed I say!
>>     
>
> There never has been any. Its all handled (both posix and sane) by glibc.

Which is what one would expect.  It's reports of crashes and kernel bugs
being found and fixed in code to handle leap seconds which lead me to a
different understanding.  I thought it was said that there's kernel
support to handle the leap second flag in NTP's broadcasts, and that
that was where the bug was.

So.  What is the situation?
