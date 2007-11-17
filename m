Return-Path: <linux-kernel-owner+w=401wt.eu-S1764154AbXKQFdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764154AbXKQFdo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 00:33:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbXKQFd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 00:33:28 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60619 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752066AbXKQFd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 00:33:26 -0500
Date: Fri, 16 Nov 2007 21:33:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.24-rc3
Message-ID: <alpine.LFD.0.9999.0711162123260.4260@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hmmm.. Lots of small fixes, some cleanups, and a few things like the cris 
updates that aren't really either, but which won't affect any normal user, 
and will hopefully make it easier to sync up in the future.

Network driver fixes, some IDE and infiniband updates, some late cpufreq 
updates, and a hwmon update.

On the architecture side, in addition to the afore-mentioned cris updates, 
there are some sh, arm, powerpc and mips updates, and also one final x86 
unification cleanup (and I really mean it - the rest can wait until after 
2.6.24, but with this one the x86 configuration really is fairly merged, 
and both i386 and x86_64 are really just special cases of the "x86" 
architecture in the configurator).

And cifs and ocfs2 filesystem updates to round it all up.

Nothing really exciting. A few things got reverted due to regressions, and
in general hopefully the regression counts are starting to shrink.

Go get it, and test it.

			Linus
