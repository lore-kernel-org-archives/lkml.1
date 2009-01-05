Return-Path: <linux-kernel-owner+w=401wt.eu-S1759851AbZAEAJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759851AbZAEAJT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 19:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbZAEAJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 19:09:04 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:41574 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbZAEAJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 19:09:03 -0500
Message-ID: <49614F90.2020904@davidnewall.com>
Date: Mon, 05 Jan 2009 10:38:48 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Kyle Moffett <kyle@moffetthome.net>, Ben Goodger <goodgerster@gmail.com>,
       Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       linasvepstas@gmail.com, "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       Travis Crump <pretzalz@techhouse.org>, burdell@iruntheinter.net
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years
 2008-2009
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com> <20090102210430.49649261@diego-desktop> <495E7849.4030706@shaw.ca> <495F0672.6020708@davidnewall.com> <8752a8760901022237r75d408b3i74c703c8ac2d4597@mail.gmail.com> <496076A9.7030907@davidnewall.com> <f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com>            <4960897D.5030603@davidnewall.com> <122713.1231068940@turing-police.cc.vt.edu>
In-Reply-To: <122713.1231068940@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Sun, 04 Jan 2009 20:33:41 +1030, David Newall said:
>
>   
>> I don't understand why such a simple thing was unnecessarily
>> complicated.  And causing crashes!  Ha ha ha or what?  A simple addition
>> to zoneinfo was (and still is) all that is required.
>>     
>
> Something to keep in mind is that the Posix standard does *NOT* say anything
> about leap seconds - poke around in a 'struct tm' sometime.
>   

I have poked, decades ago.  There's nothing in struct tm that's a problem.

> That's why /usr/share/zoneinfo has separate 'posix' and 'right' subdirectories.
>
> The fun starts when software using the 'right' rules tries to interact with
> other software using the Posix rules (quite possibly running on a non-Unixy
> system that doesn't even *use* zoneinfo).
>
> Repeat after me: Not all the world is Linux.

But Linux is; and that's what we're discussing.
