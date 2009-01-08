Return-Path: <linux-kernel-owner+w=401wt.eu-S1762658AbZAHT5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762658AbZAHT5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 14:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762174AbZAHT52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 14:57:28 -0500
Received: from lennon.multicasttech.com ([63.105.122.7]:2721 "EHLO
	multicasttech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760499AbZAHT51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 14:57:27 -0500
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jan 2009 14:57:27 EST
Cc: alan@lxorguk.ukuu.org.uk, david@lang.hm, hancockr@shaw.ca,
       kyle@moffetthome.net, slashdot@jameshallam.info, goodgerster@gmail.com,
       mayer@ntp.isc.org, davidn@davidnewall.com, linux-kernel@vger.kernel.org,
       ntpwg@lists.ntp.isc.org, pretzalz@techhouse.org,
       burdell@iruntheinter.net, linasvepstas@gmail.com, nick@nick-andrew.net,
       jeff@kosowsky.org
Message-Id: <9981A902-73ED-44B9-87B5-803621BF307B@multicasttech.com>
From: Marshall Eubanks <tme@multicasttech.com>
To: "M. Warner Losh" <imp@bsdimp.com>
In-Reply-To: <20090108.080229.1159156694.imp@bsdimp.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [ntpwg] Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Date: Thu, 8 Jan 2009 13:57:24 -0500
References: <496579C2.5050800@ntp.isc.org> <20090107.214220.-233694826.imp@bsdimp.com> <20090108104854.2dbc41b1@lxorguk.ukuu.org.uk> <20090108.080229.1159156694.imp@bsdimp.com>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 8, 2009, at 10:02 AM, M. Warner Losh wrote:

> In message: <20090108104854.2dbc41b1@lxorguk.ukuu.org.uk>
>            Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> : > On FreeBSD, Solaris and Digital Unix, I'll point out, that jumping
> : > backwards is used, and has been used since at least 1994.  So  
> saying
> : > it isn't used in the world today is flat out wrong.
> :
> : I stand by my comment - when was the last time the IERS used a leap
> : second removal ? The code may exist but it doesn't happen.
>
> Jumping backwards is used for every leap second that IERS has ever
> done, which was your original comment.  There's has never been a case
> where there was a leap second for jump forward though.  The proper
> technical term here is 'negative leap second'.  All leap seconds up
> until now have been positive leap seconds, and it is unlikely there
> ever will be a negative one.

I disagree. In the 1970's, the excess LOD was as much as 3 msec.
After going down some, the mid 1990's it rose to around 2 msec.
Now, it is around 1 msec.

Here is a plot

http://www.iers.org/MainDisp.csl?pid=95-100

Only the long period variations count for leap seconds - the seasonal  
and other high frequency
oscillations tend to average out.

In the early part of the last century (~1905), it decreased by ~ 5  
msec in a year or so.
If that happened right now, it would go to ~ -4 msec negative, and we  
would be seeing
2 negative leap seconds or more per year. Even if the decrease from  
1975 to 1985 happened again, it
would be at -1 msec, and we would have a negative leap second every  
two years or so.

What is a reasonable assumption is that we would likely have a year or  
more warning of the
likelihood of a negative leap second.

Regards
Marshall Eubanks

>
>
> Warner
> _______________________________________________
> ntpwg mailing list
> ntpwg@lists.ntp.org
> https://lists.ntp.org/mailman/listinfo/ntpwg

