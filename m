Return-Path: <linux-kernel-owner+w=401wt.eu-S1758967AbZDFWaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967AbZDFWaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbZDFWaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 18:30:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50184 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840AbZDFWaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 18:30:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [Bug #12809] iozone regression with 2.6.29-rc6
Date: Tue, 7 Apr 2009 00:30:25 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Lin, Ming M" <ming.m.lin@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       stable@kernel.org
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera> <20090406221509.GA17604@localhost> <20090406222037.GA18714@localhost>
In-Reply-To: <20090406222037.GA18714@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904070030.26367.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 April 2009, Wu Fengguang wrote:
> On Tue, Apr 07, 2009 at 06:15:09AM +0800, Wu Fengguang wrote:
> > On Tue, Apr 07, 2009 at 03:05:38AM +0800, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.28.  Please verify if it still should be listed and let me know
> > > (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12809
> > > Subject		: iozone regression with 2.6.29-rc6
> > > Submitter	: Lin Ming <ming.m.lin@intel.com>
> > > Date		: 2009-02-27 9:13 (39 days old)
> > > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1cf6e7d83bf334cc5916137862c920a97aabc018
> > > References	: http://marc.info/?l=linux-kernel&m=123572630504360&w=4
> > > 		  http://lkml.org/lkml/2009/3/14/265
> > > Handled-By	: Wu Fengguang <fengguang.wu@intel.com>
> > > 
> > 
> > This bug could be closed.
> > 
> > The performance regression is triggered by commit 1cf6e7d83bf3(mm:
> > task dirty accounting fix). Which has been reverted in 2.6.29.
> 
> Sorry for the mistake, commit 1cf6e7d83bf3 was _not_ reverted.
> So 2.6.29 is expected to have this regression.. 

Added -stable to the CC list.  I'm not sure if that was included into .29.1.

> > For 2.6.30, commit 1cf6e7d83bf33(mm: task dirty accounting fix) and
> > 1b5e62b42b55(writeback: double the dirty thresholds) were just merged
> > together. The latter one restores the iozone performance. (However
> > might deteriorate some writeback slowness bugs..)

Thanks, I've closed the bug.

Rafael
