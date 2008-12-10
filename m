Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbYLJWfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbYLJWfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 17:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbYLJWfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 17:35:43 -0500
Received: from phunq.net ([64.81.85.152]:50999 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751054AbYLJWfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 17:35:42 -0500
From: Daniel Phillips <phillips@phunq.net>
To: linux-kernel@vger.kernel.org
Subject: Tux3 report: Tux3 by Christmas?
Date: Wed, 10 Dec 2008 14:35:39 -0800
User-Agent: KMail/1.9.5
Cc: linux-fsdevel@vger.kernel.org, tux3@tux3.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812101435.40393.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wag's rejoinder would naturally be, which Christmas?   Well, if we 
set our expectations reasonably then it is this Christmas, the one that 
is 15 days away.

The latest Tux3 kernel patch is here:

   http://tux3.org/patches/tux3-2.6.26.5-2

This includes many bug fixes, cleanups and additional functionality.  
File and directory operations are nearly all there now.  Rename support 
was checked in yesterday by a developer (Michael Pattrick) as his very 
first kernel patch.  It functioned, and everybody pitched right away to 
make it solid.  This kind of thing is getting to be a regular event in 
Tux3 land, and I must say, it is gratifying to be able to encourage new 
Linux contributers this way, while providing pretty good sport for 
experienced hacks too.

   http://tux3.org/
   irc.oftc.net #tux3

The big goals for Christmas (this Christmas!) are:

   - SMP locking
   - Atomic commit
   - Posixly complete
   - Rudimentary fsck

With atomic commit, we will progress from "buggy Ext2 equivalent with 
missing features" to "buggy Ext3 equivalent with missing features".  
Not a bad place to arrive at in five months, starting from scratch.  
Does anybody out there still doubt that the community process works, 
and is the best way to develop really complex software?  Believe it.

Non-goals for Christmas include:

   - Versioning
   - Directory indexing (PHTree)
   - fsck repair

These major features will all get underway early in the new year.  As 
usual, the invitation remains open for all interested parties to come 
lend a hand.  The atomic commit effort and some work we are doing with 
deferred namespace operations offers interesting engagement for 
developers at all skill levels.

The list of Tux3 contributors continues to grow, with first-time patches 
from Benjamin Stuhl, Pranith Kumar, Jonas Fietz and Michael Pattrick.  
Most Posix operations are supported now, with the exception of extended 
attribute support, which is waiting for a fairly minor fix to the way 
we handle file size in directory operations.  I will not swear that 
this code is bug-free, far from it.  I will go as far as claiming that 
this code is fun and convenient to work on.  We are still able to do a 
large part of the development in user space, and even the kernel code 
is developed mostly in the comfortable environment of uml or kvm.

We supply 32 bit and 64 bit root filesystems for UML development:

   http://tux3.org/downloads/tuxroot32.tar.bz2

Jonas Fietz prepared the 64 bit root filesystem, thankyou very much.  
These are just 23 MB downloads that started life as Jeff Dike's 
debian-small Potato filesystem (small potatoes, get it?) and were 
upgraded over time with a modern libc and a few amenties such as the 
Nano text editor.  A brief guide to Tux3 development under UML is here:

   http://lwn.net/Articles/308950/

We should be able to produce a guide for KVM development pretty soon as 
well.

Thanks to Shapor Naghibzadeh for a spiffy new tabbed look to the tux3 
home page, and for hosting it on a more capable machine than my home 
server, which also happens to be my desktop and main Tux3 development 
machine.  It's true, I was often building UML kernels and browsing 
Slashdot while serving up html to all the search bots and interested 
people who were dropping in with increasing frequency.  For the first 
time, we have a fighting chance of withstanding a Slashdotting, whereas 
last week the result would certainly have been a smoking black hole in 
the internet.

Special thanks to Jon Corbet for explaining to us what we're actually 
building in his own inimitable way:

   http://lwn.net/SubscriberLink/309094/96a4d6980342ab7e/

and to show that these words of wisdom do not just vanish into thin air, 
we have the "Jon Corbet" patch:

   http://hg.tux3.org/tux3?cs=05354dc10bec

It is worth noting that the Tux3 project so far consists entirely of 
volunteers contributing on their own time (yes, me too).  Support from 
interested people is always welcome, whether that be beer:

   http://tux3.org/contribute.html

or something even more substantial.  For example, a three way Phenom 
machine or equivalent for SMP development would be welcome if somebody 
happens to have one they can send.

Regards,

Daniel
