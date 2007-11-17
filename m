Return-Path: <linux-kernel-owner+w=401wt.eu-S1760081AbXKQKTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081AbXKQKTb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 05:19:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbXKQKTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 05:19:25 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59906 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750963AbXKQKTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 05:19:24 -0500
Date: Sat, 17 Nov 2007 02:19:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Andreas Herrmann" <andreas.herrmann3@amd.com>
Subject: Re: Linux 2.6.24-rc3
Message-Id: <20071117021917.eed2f34c.akpm@linux-foundation.org>
In-Reply-To: <200711171114.16299.rjw@sisk.pl>
References: <alpine.LFD.0.9999.0711162123260.4260@woody.linux-foundation.org>
	<200711171114.16299.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Nov 2007 11:14:15 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Saturday, 17 of November 2007, Linus Torvalds wrote:
> > 
> > Hmmm.. Lots of small fixes, some cleanups, and a few things like the cris 
> > updates that aren't really either, but which won't affect any normal user, 
> > and will hopefully make it easier to sync up in the future.
> > 
> > Network driver fixes, some IDE and infiniband updates, some late cpufreq 
> > updates, and a hwmon update.
> > 
> > On the architecture side, in addition to the afore-mentioned cris updates, 
> > there are some sh, arm, powerpc and mips updates, and also one final x86 
> > unification cleanup (and I really mean it - the rest can wait until after 
> > 2.6.24, but with this one the x86 configuration really is fairly merged, 
> > and both i386 and x86_64 are really just special cases of the "x86" 
> > architecture in the configurator).
> > 
> > And cifs and ocfs2 filesystem updates to round it all up.
> > 
> > Nothing really exciting. A few things got reverted due to regressions, and
> > in general hopefully the regression counts are starting to shrink.
> 
> Yes, they are.
> 
> Speaking of which, would you mind merging the patch at:
> http://lkml.org/lkml/2007/11/1/246
> 
> To my eyes it's a regression fix, but no one has been pushing it upstream.

There are three patches which affect that kernel function.  One is in
git-x86 and the other two are in -mm.  I sent #2 and #3 to Thomas today
and he's getting it all sorted out.
