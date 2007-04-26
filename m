Return-Path: <linux-kernel-owner+w=401wt.eu-S1031430AbXDZShU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031430AbXDZShU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031429AbXDZShU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:37:20 -0400
Received: from khc.piap.pl ([195.187.100.11]:45741 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031423AbXDZShR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:37:17 -0400
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
	<20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de>
	<alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org>
	<20070426165950.GO3468@stusta.de>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 26 Apr 2007 20:37:14 +0200
In-Reply-To: <20070426165950.GO3468@stusta.de> (Adrian Bunk's message of "Thu, 26 Apr 2007 18:59:50 +0200")
Message-ID: <m3d51rhtid.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@stusta.de> writes:

> Look at the facts:
> 8 out of 14 regressions in my current list were reported in March or earlier.
> And for many regressions fixed it took several weeks until debugging 
> by a kernel developer was started.
>
> We do not lack testers for getting bug reports quickly.
> We lack developer manpower for debugging the many regression reports.

Quite possible, given the (very) limited range of the bugs. Most people
just can't debug them.

This isn't IMHO fundamentally wrong, and releasing a ".0" kernel with
known problems isn't fundamentally wrong either.

What is missing is easily accessible KNOWN_PROBLEMS information for
released kernels. While I think your work documenting etc. known
regressions is a very good thing, publishing it with the released
kernels (certainly .0 and next stable releases, perhaps "quite stable"
rc versions as well) would be ideal.

A pressure for fixing the bugs is, obviously, the other very good thing.

>> 2.6.20 was actually really good. Yes, it had some regressions, but I do 
>> believe that it was one of the least buggy releases we've had. The process 
>> _worked_.

I the process worked with 2.6.21 as well. Obviously no two releases
are equal, one has to be better than the other.

>> > I'm not satisfied with the result, and the world won't stop turning when 
>> > I'm not tracking 2.6.22-rc regressions.

Anyway, I and many others are satisfied with the result. I think it's
one of the few "quite recent" things which are a great improvements.
Other such things are using that weird git thing :-) and perhaps the
most important - the length of devel cycle under control (I mean the
lack of "2.5 series" thing).

> But I am not happy with the current state of released kernels.

We've got stable series.
With KNOWN_PROBLEMS information, sysadmins can decide if they can
safely upgrade to .0 or if they have to wait for .123. Pressing
the responsible people to fix the problems in .123 (would) help
it greatly.
-- 
Krzysztof Halasa
