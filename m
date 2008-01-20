Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbYATWYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbYATWYY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 17:24:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755807AbYATWYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 17:24:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48548 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755258AbYATWYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 17:24:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: PROBLEM: Celeron Core
Date: Sun, 20 Jan 2008 23:26:36 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>
References: <4793C5CA.5060100@wpkg.org>
In-Reply-To: <4793C5CA.5060100@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801202326.37030.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 20 of January 2008, Tomasz Chmielewski wrote:
> >> Clock throttling is not likely to save your battery, unless you have 
> >> tasks that are running at 100% CPU for an unlimited time or something, 
> >> and you force your CPU to throttle. Normally most people have tasks that 
> >> run and then the CPU idles - loading an email, displaying a web page, 
> >> etc. Clock throttling will just make these tasks utilize the CPU for a 
> >> longer time proportional to the amount clock throttling and therefore 
> >> negate any gains in battery usage.
> 
> Aren't you forgetting about CPUfreq governors? Which mean: use the 
> maximum CPU frequency when the system is busy, throttle down (or lower 
> voltage) when the system is idle.
> 
> So yes, throttling will save the battery.

In the relevant documentation "throttling" usually means "the reduction of the
frequency of a CPU that is not idle" in which case it won't (at least on the
average).
 
> Besides, not all CPUs support power management (voltage control).
> 
> 
> > IMO clock throttling (as opposed to the reduction of the frequency of an idle
> > CPU) is only useful for preventing the CPU from overheating.
> 
> And for reducing power on CPUs that can't do any power management, just 
> throttling.
> 
> For example, a server that doesn't crunch any numbers at night will 
> certainly use less power when throttled.

You can't use less power, you only can use less energy. :-)

Anyway, that's "the reduction of the frequency of an idle CPU" mentioned above
and it makes sense in the majority of cases.

Greetings,
Rafael
