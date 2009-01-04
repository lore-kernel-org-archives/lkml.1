Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618AbZADJA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbZADJA3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 04:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750775AbZADJAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 04:00:20 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:49568 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbZADJAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 04:00:19 -0500
Message-ID: <f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com>
Date: Sun, 4 Jan 2009 04:00:16 -0500
From: "Kyle Moffett" <kyle@moffetthome.net>
To: "David Newall" <davidn@davidnewall.com>
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Cc: "Ben Goodger" <goodgerster@gmail.com>, "Robert Hancock" <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org, linasvepstas@gmail.com,
       "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       "Travis Crump" <pretzalz@techhouse.org>, burdell@iruntheinter.net
In-Reply-To: <496076A9.7030907@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>
	 <20090102210430.49649261@diego-desktop> <495E7849.4030706@shaw.ca>
	 <495F0672.6020708@davidnewall.com>
	 <8752a8760901022237r75d408b3i74c703c8ac2d4597@mail.gmail.com>
	 <496076A9.7030907@davidnewall.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 4, 2009 at 3:43 AM, David Newall <davidn@davidnewall.com> wrote:
> Ben Goodger wrote:
>> 2009/1/3 David Newall <davidn@davidnewall.com>:
>> Actually, the change has worked in the real world with the
>> introduction of a new second named 23:59:60
>
> Fine.  However you want to describe that last second is immaterial.  The
> point is that diddling the clock is not a true solution.  Take seconds
> since epoch for January 1 and subtract the seconds since epoch since the
> previous day and if the result isn't 86401 it's wrong.  Is Linux wrong?
> (I gather it is.)

Actually, "diddling the clock" is really the only valid solution to
the leap-second problem.  The leap-second is such a fine adjustment
that it is actually affected by random "noise" introduced into the
solar-system from the chaotic gravitational interactions of the
planets with each other.  It's impossible to reliably calculate which
future years will have leap seconds, and in which direction they will
occur.

Our calendar year is pretty damn close after we have accounted for the
standard leap-year algorithm, but that algorithm cannot be modified
without breaking a great number of existing date-time systems.  The
proper answer (currently implemented in systems all over the world)
coordinates atomic-clock systems across the world with the measured
traversal of the earth (as referenced against the sun and the stars).
If the clocks are slightly "ahead" of where they should be, a leap
second is scheduled to be inserted, and if they're behind, a second is
removed.  The flow-of-time is then adjusted for the last minute so
that it runs either 101.6959% of the normal rate (59-second minute) or
98.3606% of the normal rate (61-second minute).

The effective end result is that time actually flows smoothly but the
assumed date of the epoch is adjusted slightly relative to real time
based on subtle fluctuations of the earth's rotation and orbit.

Cheers,
Kyle Moffett
