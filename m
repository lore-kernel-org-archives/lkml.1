Return-Path: <linux-kernel-owner+w=401wt.eu-S1759129AbZACGdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129AbZACGdq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 01:33:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbZACGdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 01:33:37 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:41263 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbZACGdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 01:33:36 -0500
Message-ID: <495F0672.6020708@davidnewall.com>
Date: Sat, 03 Jan 2009 17:02:18 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel@vger.kernel.org, linasvepstas@gmail.com,
       "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       Travis Crump <pretzalz@techhouse.org>,
       Goodgerster <goodgerster@gmail.com>, burdell@iruntheinter.net
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years
   2008-2009
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com> <20090102210430.49649261@diego-desktop> <495E7849.4030706@shaw.ca>
In-Reply-To: <495E7849.4030706@shaw.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Diego Calleja wrote:
>> How could I create a test case that reproduces what ntp does? Just add
>> a second?
>
> I'd think that setting the clock to just before midnight on Dec.31 and
> using the adjtimex syscall to set the TIME_INS state on the clock,
> then waiting until midnight rolls around would be a reasonable test.. 

I don't understand this idea, nor the patch for the problem.  I don't
see why adding a leap second would impact the kernel in any way. 
Shouldn't this be a simple zoneinfo change, whereby the last two seconds
of the year (in each timezone) both map to 31dec2008 23:59:59?  That's
the way the change has worked in the real world.  Why would ntp or the
kernel be involved?
