Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbZADKL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbZADKL0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 05:11:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbZADKLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 05:11:18 -0500
Received: from mail.lang.hm ([64.81.33.126]:56673 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbZADKLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 05:11:17 -0500
Date: Sun, 4 Jan 2009 03:13:11 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: David Newall <davidn@davidnewall.com>
cc: Kyle Moffett <kyle@moffetthome.net>, Ben Goodger <goodgerster@gmail.com>,
       Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       linasvepstas@gmail.com, "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       Travis Crump <pretzalz@techhouse.org>, burdell@iruntheinter.net
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years
 2008-2009
In-Reply-To: <4960897D.5030603@davidnewall.com>
Message-ID: <alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm>
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>  <20090102210430.49649261@diego-desktop> <495E7849.4030706@shaw.ca>  <495F0672.6020708@davidnewall.com>  <8752a8760901022237r75d408b3i74c703c8ac2d4597@mail.gmail.com> 
 <496076A9.7030907@davidnewall.com> <f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com> <4960897D.5030603@davidnewall.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Jan 2009, David Newall wrote:

> Kyle Moffett wrote:
>> Actually, "diddling the clock" is really the only valid solution to
>> the leap-second problem.  The leap-second is such a fine adjustment
>> that it is actually affected by random "noise" introduced into the
>> solar-system from the chaotic gravitational interactions of the
>> planets with each other.  It's impossible to reliably calculate which
>> future years will have leap seconds, and in which direction they will
>> occur.
>>
>
> You're confusing the system of keeping time with those characteristics
> of the real-world which it represents.  They are, in fact, two different
> things, hence we regularly adjust the system.  Now in the case of UNIX
> and derivatives, the system records the number of seconds since an
> arbitrary point-in-time, and presents a "wall time" (i.e. the time
> displayed by the clock on the wall) using, amongst other things, a set
> of adjustment rules codified by a zoneinfo file.  The number of second
> between 1 minute to- and midnight-ending 31 December is 61.  If Linux
> does not reflect that it is wrong and must be fixed.  If it isn't fixed
> we will increasingly discover a discrepancy between time-data that
> originates on Linux versus other, correct systems.
>
> I don't understand why such a simple thing was unnecessarily
> complicated.  And causing crashes!  Ha ha ha or what?  A simple addition
> to zoneinfo was (and still is) all that is required.

so are you saying that other 'correct' OS's have patches issued every time 
a leap second is declared so that they have an in-kernel table of them to 
use to calculate the correct time?

what about systems that have hit end of life? what about systems that 
users don't want to have to reboot to install a new kernel for a 1 second 
shift (which NTP will take care of as far as they are concerned anyway)

when the daylight savings time definitions change all the vendors had to 
issue patches, I saw those. I didn't see any patches for the leap second, 
so how do these other systems deal with it?

David Lang
