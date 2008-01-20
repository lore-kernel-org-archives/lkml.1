Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbYATTOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbYATTOt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 14:14:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbYATTOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 14:14:42 -0500
Received: from waste.org ([66.93.16.53]:54775 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754848AbYATTOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 14:14:41 -0500
Subject: Re: PROBLEM: Celeron Core
From: Matt Mackall <mpm@selenic.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: David Newall <davidn@davidnewall.com>, Andi Kleen <andi@firstfloor.org>,
       Chodorenko Michail <misha@one.by>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <479391C9.9020004@shaw.ca>
References: <fa.2Y+LplM9PCtpiAXzv/aJ3Pcnv4Y@ifi.uio.no>
	 <fa.OpXJDCw416yeXEvt0cwrupi/qS0@ifi.uio.no>
	 <fa.sj34KNXkf9z/ZO3fVJ+CYcgcuCs@ifi.uio.no>
	 <fa.qpK4b5H7lkLeIaPtbJKzKV46yFY@ifi.uio.no>
	 <fa.WeBRuL3UPPVPESVzfopvVyNcAw4@ifi.uio.no>
	 <fa.LZLUxfR64dAZFPtin9JNet7ieiY@ifi.uio.no>  <479391C9.9020004@shaw.ca>
Content-Type: text/plain
Date: Sun, 20 Jan 2008 13:14:17 -0600
Message-Id: <1200856457.13649.29.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-01-20 at 12:24 -0600, Robert Hancock wrote:
> David Newall wrote:
> > Andi Kleen wrote:
> >>> Isn't it the case that an idle machine will use
> >>> less power when throttled than when not?
> >>>     
> >> No that is not the case (not even on old CPUs) 
> >>   
> > Then why would it run cooler?  What generates the heat when not
> > throttled?  What stops generating heat when throttled?  And you say this
> > happens without reducing power consumption?  I'm not convinced.  I'm a
> > long way from that.
> 
> I believe that all throttling does is forcibly halt the CPU on a 
> particular duty cycle. This will reduce the rate of power consumption, 
> but reduces the CPU performance by a greater amount (since even at 100% 
> halted the CPU still consumes power) and so actually reduces performance 
> per watt. It will spread the heat and power usage produced from a given 
> workload task out in time (thus its usefulness in limiting CPU 
> temperature) but will consume more power overall.

Your usage of "overall power" here is wrong. Power is an instantaneous
quantity (1/s) like velocity, and you are comparing it to energy which
is not an instaneous quantity, more like distance.

If we throttle the velocity of a car from 100km/h to 50km/h, it'll
obviously take longer for it travel a given distance. Now what will it
mean when we ask about its "overall velocity" when it reaches its
destination? We surely don't mean the distance travelled - that's not a
velocity! We can perhaps talk about its average velocity, which will
obviously be smaller.

> Real CPU clock throttling schemes like SpeedStep, PowerNow, etc. 
> actually do increase performance per watt when they kick in.

That may be true. But the statement "throttling does not reduce power
usage" remains false. And the statement "throttling reduces heat
production but not power usage" remains physically impossible.

It might be true that "throttling increases energy usage per unit of
computation relative to no power saving measures at all", but that is
not incompatible with "throttling lets you run your laptop on battery
longer than no power saving measures at all", which is often what people
care about.

Voltage/frequency reduction is obviously a much better solution if it's
available as reducing voltage reduces power usage quadratically rather
than linearly. But beyond the quadratic/linear thing, the concept is the
same: use less power and your battery lasts longer.

-- 
Mathematics is the supreme nostalgia of our time.

