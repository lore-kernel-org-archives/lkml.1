Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbZADKEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbZADKEI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 05:04:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbZADKDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 05:03:55 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:41440 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbZADKDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 05:03:54 -0500
Message-ID: <4960897D.5030603@davidnewall.com>
Date: Sun, 04 Jan 2009 20:33:41 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Kyle Moffett <kyle@moffetthome.net>
CC: Ben Goodger <goodgerster@gmail.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org, linasvepstas@gmail.com,
       "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       Travis Crump <pretzalz@techhouse.org>, burdell@iruntheinter.net
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years
 2008-2009
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>	 <20090102210430.49649261@diego-desktop> <495E7849.4030706@shaw.ca>	 <495F0672.6020708@davidnewall.com>	 <8752a8760901022237r75d408b3i74c703c8ac2d4597@mail.gmail.com>	 <496076A9.7030907@davidnewall.com> <f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com>
In-Reply-To: <f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> Actually, "diddling the clock" is really the only valid solution to
> the leap-second problem.  The leap-second is such a fine adjustment
> that it is actually affected by random "noise" introduced into the
> solar-system from the chaotic gravitational interactions of the
> planets with each other.  It's impossible to reliably calculate which
> future years will have leap seconds, and in which direction they will
> occur.
>   

You're confusing the system of keeping time with those characteristics
of the real-world which it represents.  They are, in fact, two different
things, hence we regularly adjust the system.  Now in the case of UNIX
and derivatives, the system records the number of seconds since an
arbitrary point-in-time, and presents a "wall time" (i.e. the time
displayed by the clock on the wall) using, amongst other things, a set
of adjustment rules codified by a zoneinfo file.  The number of second
between 1 minute to- and midnight-ending 31 December is 61.  If Linux
does not reflect that it is wrong and must be fixed.  If it isn't fixed
we will increasingly discover a discrepancy between time-data that
originates on Linux versus other, correct systems.

I don't understand why such a simple thing was unnecessarily
complicated.  And causing crashes!  Ha ha ha or what?  A simple addition
to zoneinfo was (and still is) all that is required.
