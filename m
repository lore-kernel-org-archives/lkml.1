Return-Path: <linux-kernel-owner+w=401wt.eu-S1758336AbYAUHsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336AbYAUHsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 02:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755621AbYAUHsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 02:48:09 -0500
Received: from iabervon.org ([66.92.72.58]:58213 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338AbYAUHsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 02:48:08 -0500
Date: Mon, 21 Jan 2008 02:48:05 -0500 (EST)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Matt Mackall <mpm@selenic.com>
cc: Robert Hancock <hancockr@shaw.ca>, David Newall <davidn@davidnewall.com>,
       Andi Kleen <andi@firstfloor.org>, Chodorenko Michail <misha@one.by>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: Celeron Core
In-Reply-To: <1200856457.13649.29.camel@cinder.waste.org>
Message-ID: <alpine.LNX.1.00.0801210224320.13593@iabervon.org>
References: <fa.2Y+LplM9PCtpiAXzv/aJ3Pcnv4Y@ifi.uio.no>  <fa.OpXJDCw416yeXEvt0cwrupi/qS0@ifi.uio.no>  <fa.sj34KNXkf9z/ZO3fVJ+CYcgcuCs@ifi.uio.no>  <fa.qpK4b5H7lkLeIaPtbJKzKV46yFY@ifi.uio.no>  <fa.WeBRuL3UPPVPESVzfopvVyNcAw4@ifi.uio.no> 
 <fa.LZLUxfR64dAZFPtin9JNet7ieiY@ifi.uio.no>  <479391C9.9020004@shaw.ca> <1200856457.13649.29.camel@cinder.waste.org>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jan 2008, Matt Mackall wrote:

> Your usage of "overall power" here is wrong. Power is an instantaneous
> quantity (1/s) like velocity, and you are comparing it to energy which
> is not an instaneous quantity, more like distance.
> 
> If we throttle the velocity of a car from 100km/h to 50km/h, it'll
> obviously take longer for it travel a given distance. Now what will it
> mean when we ask about its "overall velocity" when it reaches its
> destination? We surely don't mean the distance travelled - that's not a
> velocity! We can perhaps talk about its average velocity, which will
> obviously be smaller.

What's people tend to care about is average power usage over a period, not 
instantaneous power usage. In fact, throttling obviously doesn't decrease 
instantaneous power usage while the machine is doing anything (since it 
runs full speed and full power when running, and does nothing and uses 
some but not as much power when halted). Throttling decreases the average 
power usage over the period of the throttling, but increases the average 
power usage in general over longer periods.

If we throttle a car's velocity by only driving 100km/h for 5 minutes out 
of every 10 instead of all of the time, it doesn't meaningfully have less 
velocity. And it's a particularly meaningless measure if the arrangement 
as a whole is that it will leave point A at some time, drive to point B, 
and sit there until some other time; in this case its average velocity is 
the distance from point A to point B divided by the duration between the 
two times, regardless of how you drive. But the distance travelled is 
longer if you have to pull over and park every 10 minutes, and so the 
average velocity must be higher for the TDMA throttling case.

	-Daniel
*This .sig left intentionally blank*
