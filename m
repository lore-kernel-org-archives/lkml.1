Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbZAETeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbZAETeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbZAETe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:34:28 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:43016 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbZAETe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:34:27 -0500
Message-ID: <4961A9E2.9060601@davidnewall.com>
Date: Mon, 05 Jan 2009 17:04:10 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Ben Goodger <goodgerster@gmail.com>
CC: david@lang.hm, Kyle Moffett <kyle@moffetthome.net>,
       Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       linasvepstas@gmail.com, "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       Travis Crump <pretzalz@techhouse.org>, burdell@iruntheinter.net
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years
 2008-2009
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>	 <496076A9.7030907@davidnewall.com>	 <f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com>	 <4960897D.5030603@davidnewall.com>	 <alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm>	 <4961432A.80509@davidnewall.com>	 <alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm>	 <49614835.7000505@davidnewall.com>	 <alpine.DEB.1.10.0901041702540.25545@asgard.lang.hm>	 <496150DF.2070501@davidnewall.com> <8752a8760901041621o51380e91x9ef8414b22c40ffc@mail.gmail.com>
In-Reply-To: <8752a8760901041621o51380e91x9ef8414b22c40ffc@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Goodger wrote:
> 2009/1/5 David Newall <davidn@davidnewall.com>:
>   
>>> another poster said that NTP packets include information about this
>>> month's leap second, so that implies that they could change monthly.
>>>       
>> Not "could change monthly" rather, "could change at any month".
>>
>> The frequency of zoneinfo updates would therefore be: every time the
>> zones you care about change; and every time there's a leap second.  No
>> big effort.
>>     
>
> Unfortunately, as has been pointed out, timezones are completely
> unrelated to leap seconds.
>   

Zoneinfo files cater for leap seconds.

> NB. Leap seconds, positive or negative, potentially occur every six
> months (June 30 or Dec 31), but since their introduction this
> frequency has happened only once (in 1972); historically they have
> been inserted on average every 1.5 years, but there have been only two
> since 2000.

If you know in advance, you can update zoneinfo files with multiple leap
seconds.
