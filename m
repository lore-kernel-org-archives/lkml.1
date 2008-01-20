Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070AbYATV3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbYATV3f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 16:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755386AbYATV31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 16:29:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48377 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075AbYATV30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 16:29:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PROBLEM: Celeron Core
Date: Sun, 20 Jan 2008 22:31:17 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Matt Mackall <mpm@selenic.com>, David Newall <davidn@davidnewall.com>,
       Andi Kleen <andi@firstfloor.org>, Chodorenko Michail <misha@one.by>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <fa.2Y+LplM9PCtpiAXzv/aJ3Pcnv4Y@ifi.uio.no> <1200856457.13649.29.camel@cinder.waste.org> <47939FDF.7070805@shaw.ca>
In-Reply-To: <47939FDF.7070805@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801202231.18113.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 20 of January 2008, Robert Hancock wrote:
> Matt Mackall wrote:
> > Your usage of "overall power" here is wrong. Power is an instantaneous
> > quantity (1/s) like velocity, and you are comparing it to energy which
> > is not an instaneous quantity, more like distance.
> > 
> > If we throttle the velocity of a car from 100km/h to 50km/h, it'll
> > obviously take longer for it travel a given distance. Now what will it
> > mean when we ask about its "overall velocity" when it reaches its
> > destination? We surely don't mean the distance travelled - that's not a
> > velocity! We can perhaps talk about its average velocity, which will
> > obviously be smaller.
> 
> You are right.. it should be that overall energy usage is higher with 
> clock throttling.

Well, I'm still thinking you mean "the average energy usage per unit of
computations".  IOW, "one will use more energy to carry out the same
computations with throttling than without it".

> >> Real CPU clock throttling schemes like SpeedStep, PowerNow, etc. 
> >> actually do increase performance per watt when they kick in.
> > 
> > That may be true. But the statement "throttling does not reduce power
> > usage" remains false. And the statement "throttling reduces heat
> > production but not power usage" remains physically impossible.
> 
> It reduces the rate of power usage (watts), however it will likely not 
> decreate or even increase the energy usage (i.e. watt-hours) of any 
> given computational task.

In this context "power" means "energy used over a unit of time", so by
decreasing power you cause less energy to be used over a unit of time, by
definition.  Still, the total energy required to complete given computational
task is (on the average) equal to "power" * "total time of computations" and
this really has to be measured on a per task basis.
 
> > It might be true that "throttling increases energy usage per unit of
> > computation relative to no power saving measures at all", but that is
> > not incompatible with "throttling lets you run your laptop on battery
> > longer than no power saving measures at all", which is often what people
> > care about.
> > 
> > Voltage/frequency reduction is obviously a much better solution if it's
> > available as reducing voltage reduces power usage quadratically rather
> > than linearly. But beyond the quadratic/linear thing, the concept is the
> > same: use less power and your battery lasts longer.
> 
> Clock throttling is not likely to save your battery, unless you have 
> tasks that are running at 100% CPU for an unlimited time or something, 
> and you force your CPU to throttle. Normally most people have tasks that 
> run and then the CPU idles - loading an email, displaying a web page, 
> etc. Clock throttling will just make these tasks utilize the CPU for a 
> longer time proportional to the amount clock throttling and therefore 
> negate any gains in battery usage.

IMO clock throttling (as opposed to the reduction of the frequency of an idle
CPU) is only useful for preventing the CPU from overheating.

Greetings,
Rafael
