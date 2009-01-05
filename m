Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbZAEAOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbZAEAOq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 19:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbZAEAOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 19:14:38 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:41588 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbZAEAOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 19:14:37 -0500
Message-ID: <496150DF.2070501@davidnewall.com>
Date: Mon, 05 Jan 2009 10:44:23 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: david@lang.hm
CC: Kyle Moffett <kyle@moffetthome.net>, Ben Goodger <goodgerster@gmail.com>,
       Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       linasvepstas@gmail.com, "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       Travis Crump <pretzalz@techhouse.org>, burdell@iruntheinter.net
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years
 2008-2009
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>  <20090102210430.49649261@diego-desktop> <495E7849.4030706@shaw.ca>  <495F0672.6020708@davidnewall.com>  <8752a8760901022237r75d408b3i74c703c8ac2d4597@mail.gmail.com>  <496076A9.7030907@davidnewall.com> <f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com> <4960897D.5030603@davidnewall.com> <alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm> <4961432A.80509@davidnewall.com> <alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm> <49614835.7000505@davidnewall.com> <alpine.DEB.1.10.0901041702540.25545@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.10.0901041702540.25545@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> On Mon, 5 Jan 2009, David Newall wrote:
>
>> david@lang.hm wrote:
>>> then new zoneinfo files need to be sent out every time there is a leap
>>> second (which from other posts on this thread is potentially every
>>> month)
>>
>> Not every few months, for goodness sake!  Leap seconds aren't that
>> common!  These files do change regularly, however, sometimes on a yearly
>> basis, because that's how often the date might be changed when daylight
>> savings transitions.  This is to say that leap seconds don't
>> particularly change the frequency of zoneinfo updates.
>
> another poster said that NTP packets include information about this
> month's leap second, so that implies that they could change monthly.

Not "could change monthly" rather, "could change at any month".

The frequency of zoneinfo updates would therefore be: every time the
zones you care about change; and every time there's a leap second.  No
big effort.
