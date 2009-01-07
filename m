Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbZAGKEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbZAGKEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 05:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbZAGKEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 05:04:15 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:43324 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbZAGKEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 05:04:15 -0500
Message-ID: <49647E0F.9030008@davidnewall.com>
Date: Wed, 07 Jan 2009 20:33:59 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: linasvepstas@gmail.com
CC: mayer@ntp.isc.org, david@lang.hm, Robert Hancock <hancockr@shaw.ca>,
       Ben Goodger <goodgerster@gmail.com>,
       Kyle Moffett <kyle@moffetthome.net>,
       MentalMooMan <slashdot@jameshallam.info>, linux-kernel@vger.kernel.org,
       ntpwg@lists.ntp.isc.org, Travis Crump <pretzalz@techhouse.org>,
       burdell@iruntheinter.net, Nick Andrew <nick@nick-andrew.net>,
       "Jeffrey J. Kosowsky" <jeff@kosowsky.org>
Subject: Re: [ntpwg] Bug: Status/Summary of slashdot leap-second crash on
 new years 2008-2009
References: <495F0672.6020708@davidnewall.com> <4961432A.80509@davidnewall.com>	 <alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm>	 <49614835.7000505@davidnewall.com>	 <3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com>	 <20090105143335.GC18055@mail.local.tull.net>	 <3ae3aa420901050808r100e533fo5f88edfbb5f0747a@mail.gmail.com>	 <alpine.DEB.1.10.0901050949560.27641@asgard.lang.hm>	 <3ae3aa420901050942y56f0ecdei39c091a73e49c1fd@mail.gmail.com>	 <49642674.9080703@ntp.isc.org> <3ae3aa420901062052h75fcab11n8ce45c41ac0e4cd2@mail.gmail.com>
In-Reply-To: <3ae3aa420901062052h75fcab11n8ce45c41ac0e4cd2@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linas Vepstas wrote:
> Currently, the Linux kernel keeps time in UTC. This means
> that it must take special actions to tick twice when a leap
> second comes by.

Except it doesn't have to tick twice.  Refer to
http://lkml.org/lkml/2009/1/7/78 in which I show that a time_t (what
time() returns) counts leap seconds (According to Bernstein this is what
UTC means), and using zoneinfo, the library processes leap seconds
correctly.

I just realised that the Notes in man 2 time are confusing and probably
unnecessary.  Suffice to say that (assuming correctly configured
zoneinfo) time() returns the number of seconds elapsed since start 1970.
