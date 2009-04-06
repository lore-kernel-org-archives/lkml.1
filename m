Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbZDFXgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbZDFXgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 19:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbZDFXgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 19:36:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:53592 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbZDFXgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 19:36:03 -0400
Date: Mon, 6 Apr 2009 23:34:20 +0000
From: Chris Wright <chrisw@sous-sol.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Lin, Ming M" <ming.m.lin@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org
Subject: Re: [stable] [Bug #12809] iozone regression with 2.6.29-rc6
Message-ID: <20090406233420.GA17070@hera.kernel.org>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera> <20090406221509.GA17604@localhost> <20090406222037.GA18714@localhost> <200904070030.26367.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904070030.26367.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 06 Apr 2009 23:34:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki (rjw@sisk.pl) wrote:
> On Tuesday 07 April 2009, Wu Fengguang wrote:
> > On Tue, Apr 07, 2009 at 06:15:09AM +0800, Wu Fengguang wrote:
> > > On Tue, Apr 07, 2009 at 03:05:38AM +0800, Rafael J. Wysocki wrote:
> > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12809
> > > > Subject		: iozone regression with 2.6.29-rc6
> > > > Submitter	: Lin Ming <ming.m.lin@intel.com>
> > > > Date		: 2009-02-27 9:13 (39 days old)
> > > > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1cf6e7d83bf334cc5916137862c920a97aabc018
> > > > References	: http://marc.info/?l=linux-kernel&m=123572630504360&w=4
> > > > 		  http://lkml.org/lkml/2009/3/14/265
> > > > Handled-By	: Wu Fengguang <fengguang.wu@intel.com>
> > > 
> > > This bug could be closed.
> > > 
> > > The performance regression is triggered by commit 1cf6e7d83bf3(mm:
> > > task dirty accounting fix). Which has been reverted in 2.6.29.
> > 
> > Sorry for the mistake, commit 1cf6e7d83bf3 was _not_ reverted.
> > So 2.6.29 is expected to have this regression.. 
> 
> Added -stable to the CC list.  I'm not sure if that was included into .29.1.

1cf6e7d83bf3 is part of 2.6.29.1 (came in 2.6.29-rc6)

> > > For 2.6.30, commit 1cf6e7d83bf33(mm: task dirty accounting fix) and
> > > 1b5e62b42b55(writeback: double the dirty thresholds) were just merged
> > > together. The latter one restores the iozone performance. (However
> > > might deteriorate some writeback slowness bugs..)

1b5e62b42b55 is not in -stable.

thanks,
-chris
