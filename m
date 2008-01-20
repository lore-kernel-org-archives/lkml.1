Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbYATTY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbYATTY4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 14:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbYATTYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 14:24:49 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:43948 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832AbYATTYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 14:24:48 -0500
Date: Sun, 20 Jan 2008 13:24:15 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PROBLEM: Celeron Core
In-reply-to: <1200856457.13649.29.camel@cinder.waste.org>
To: Matt Mackall <mpm@selenic.com>
Cc: David Newall <davidn@davidnewall.com>, Andi Kleen <andi@firstfloor.org>,
       Chodorenko Michail <misha@one.by>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <47939FDF.7070805@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.2Y+LplM9PCtpiAXzv/aJ3Pcnv4Y@ifi.uio.no>
 <fa.OpXJDCw416yeXEvt0cwrupi/qS0@ifi.uio.no>
 <fa.sj34KNXkf9z/ZO3fVJ+CYcgcuCs@ifi.uio.no>
 <fa.qpK4b5H7lkLeIaPtbJKzKV46yFY@ifi.uio.no>
 <fa.WeBRuL3UPPVPESVzfopvVyNcAw4@ifi.uio.no>
 <fa.LZLUxfR64dAZFPtin9JNet7ieiY@ifi.uio.no> <479391C9.9020004@shaw.ca>
 <1200856457.13649.29.camel@cinder.waste.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
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

You are right.. it should be that overall energy usage is higher with 
clock throttling.

> 
>> Real CPU clock throttling schemes like SpeedStep, PowerNow, etc. 
>> actually do increase performance per watt when they kick in.
> 
> That may be true. But the statement "throttling does not reduce power
> usage" remains false. And the statement "throttling reduces heat
> production but not power usage" remains physically impossible.

It reduces the rate of power usage (watts), however it will likely not 
decreate or even increase the energy usage (i.e. watt-hours) of any 
given computational task.

> 
> It might be true that "throttling increases energy usage per unit of
> computation relative to no power saving measures at all", but that is
> not incompatible with "throttling lets you run your laptop on battery
> longer than no power saving measures at all", which is often what people
> care about.
> 
> Voltage/frequency reduction is obviously a much better solution if it's
> available as reducing voltage reduces power usage quadratically rather
> than linearly. But beyond the quadratic/linear thing, the concept is the
> same: use less power and your battery lasts longer.

Clock throttling is not likely to save your battery, unless you have 
tasks that are running at 100% CPU for an unlimited time or something, 
and you force your CPU to throttle. Normally most people have tasks that 
run and then the CPU idles - loading an email, displaying a web page, 
etc. Clock throttling will just make these tasks utilize the CPU for a 
longer time proportional to the amount clock throttling and therefore 
negate any gains in battery usage.
