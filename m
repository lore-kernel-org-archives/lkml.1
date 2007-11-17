Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbXKQJ5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbXKQJ5F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 04:57:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbXKQJ4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 04:56:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59573 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbXKQJ4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 04:56:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.24-rc3
Date: Sat, 17 Nov 2007 11:14:15 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Andreas Herrmann" <andreas.herrmann3@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <alpine.LFD.0.9999.0711162123260.4260@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0711162123260.4260@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711171114.16299.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 17 of November 2007, Linus Torvalds wrote:
> 
> Hmmm.. Lots of small fixes, some cleanups, and a few things like the cris 
> updates that aren't really either, but which won't affect any normal user, 
> and will hopefully make it easier to sync up in the future.
> 
> Network driver fixes, some IDE and infiniband updates, some late cpufreq 
> updates, and a hwmon update.
> 
> On the architecture side, in addition to the afore-mentioned cris updates, 
> there are some sh, arm, powerpc and mips updates, and also one final x86 
> unification cleanup (and I really mean it - the rest can wait until after 
> 2.6.24, but with this one the x86 configuration really is fairly merged, 
> and both i386 and x86_64 are really just special cases of the "x86" 
> architecture in the configurator).
> 
> And cifs and ocfs2 filesystem updates to round it all up.
> 
> Nothing really exciting. A few things got reverted due to regressions, and
> in general hopefully the regression counts are starting to shrink.

Yes, they are.

Speaking of which, would you mind merging the patch at:
http://lkml.org/lkml/2007/11/1/246

To my eyes it's a regression fix, but no one has been pushing it upstream.

Greetings,
Rafael
