Return-Path: <linux-kernel-owner+w=401wt.eu-S1757226AbZADInp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbZADInp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 03:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756410AbZADIne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 03:43:34 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:41433 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbZADInd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 03:43:33 -0500
Message-ID: <496076A9.7030907@davidnewall.com>
Date: Sun, 04 Jan 2009 19:13:21 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Ben Goodger <goodgerster@gmail.com>
CC: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       linasvepstas@gmail.com, "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       Travis Crump <pretzalz@techhouse.org>, burdell@iruntheinter.net
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years
 2008-2009
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>	 <20090102210430.49649261@diego-desktop> <495E7849.4030706@shaw.ca>	 <495F0672.6020708@davidnewall.com> <8752a8760901022237r75d408b3i74c703c8ac2d4597@mail.gmail.com>
In-Reply-To: <8752a8760901022237r75d408b3i74c703c8ac2d4597@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Goodger wrote:
> 2009/1/3 David Newall <davidn@davidnewall.com>:
>   
>> Shouldn't this be a simple zoneinfo change, whereby the last two seconds
>> of the year (in each timezone) both map to 31dec2008 23:59:59?  That's
>> the way the change has worked in the real world.  Why would ntp or the
>> kernel be involved?
>>     
>
> Actually, the change has worked in the real world with the
> introduction of a new second named 23:59:60

Fine.  However you want to describe that last second is immaterial.  The
point is that diddling the clock is not a true solution.  Take seconds
since epoch for January 1 and subtract the seconds since epoch since the
previous day and if the result isn't 86401 it's wrong.  Is Linux wrong? 
(I gather it is.)
