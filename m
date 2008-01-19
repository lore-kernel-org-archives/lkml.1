Return-Path: <linux-kernel-owner+w=401wt.eu-S1763914AbYASEYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763914AbYASEYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 23:24:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758400AbYASEYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 23:24:31 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44528 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890AbYASEYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 23:24:30 -0500
Date: Sat, 19 Jan 2008 05:27:50 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Andi Kleen <andi@firstfloor.org>, Chodorenko Michail <misha@one.by>,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Celeron Core
Message-ID: <20080119042750.GA24481@one.firstfloor.org>
References: <3ed23423adebae08e8f75b6a6a7ce7ff@one.by> <p73prvyalfl.fsf@bingen.suse.de> <1200702477.25782.41.camel@cinder.waste.org> <20080119011506.GA23798@one.firstfloor.org> <1200715842.25782.95.camel@cinder.waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200715842.25782.95.camel@cinder.waste.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So while throttling may be less efficient in terms of watt seconds used
> to compile something than running at full speed, it is incorrect to say
> it uses less power. One machine running for an hour throttled to 50%
> uses less power (and therefore less battery and cooling) than another
> running at full speed for that same hour.

Not for the same unit of work. If you just run endless loops you 
might be true, but most systems don't do that. 

In terms of laptops (or rather in most other systems too) you usually care 
about battery life time while the system is mostly idling (waiting
for your key strokes etc.). In this case enabling throttling
as a cpufreq driver will not make your battery last longer.

Also skipping the clocks does not actually safe all very much power
compared to the other measures C-states or speedstep do (like dropping voltage) 

This means enabling it will likely make your laptop battery last shorter.

-Andi
