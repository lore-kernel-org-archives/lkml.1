Return-Path: <linux-kernel-owner+w=401wt.eu-S1758027AbZAEABt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbZAEABt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 19:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbZAEABl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 19:01:41 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:41571 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbZAEABl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 19:01:41 -0500
Message-ID: <49614DD8.7070707@davidnewall.com>
Date: Mon, 05 Jan 2009 10:31:28 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Chris Adams <cmadams@hiwaay.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years
 2008-2009
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com> <20090102210430.49649261@diego-desktop> <495E7849.4030706@shaw.ca> <495F0672.6020708@davidnewall.com> <8752a8760901022237r75d408b3i74c703c8ac2d4597@mail.gmail.com> <496076A9.7030907@davidnewall.com> <f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com> <4960897D.5030603@davidnewall.com> <alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm> <4961432A.80509@davidnewall.com> <20090104232534.GB1297917@hiwaay.net>
In-Reply-To: <20090104232534.GB1297917@hiwaay.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Adams wrote:
> Once upon a time, David Newall <davidn@davidnewall.com> said:
>   
>> No.  Exactly the contrary.  I'm saying that through use of zoneinfo, for
>> example, no kernel support is required for leap seconds.  And! this
>> provides correct results for seconds-between two dates.
>>     
>
> Again: zoneinfo provides offset from UTC.  Leap seconds are changes in
> UTC itself, not time zones, so zoneinfo can't handle that.
>   

Yes, but zoneinfo ALSO provides support for leap seconds.  Do read man
zic for specific details.

> Please go read Google, Wikipedia, and NTP lists.

I think you particularly mean NTP.  I think your reasoning is that
because NTP's timestamp doesn't include leap seconds, and because we all
like to use NTP to synchronise our clocks, Linux has to make up the
difference.  But there is an alternative; which is for the NTP client to
insert those missing leap seconds, which number it can get from
zoneinfo.  Epoch remains the start of  1978; seconds between any two
dates included leap-seconds and no special kernel support is required.
