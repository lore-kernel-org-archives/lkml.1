Return-Path: <linux-kernel-owner+w=401wt.eu-S1756382AbZCGVgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382AbZCGVgh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 16:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbZCGVg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 16:36:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60409 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273AbZCGVg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 16:36:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [Bug #12809] iozone regression with 2.6.29-rc6
Date: Sat, 7 Mar 2009 22:35:52 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc7-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Lin, Ming M" <ming.m.lin@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera> <SLCXkuHtxAO.A.9MB.pUarJB@chimera> <20090305010920.GB11575@localhost>
In-Reply-To: <20090305010920.GB11575@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903072235.53642.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 March 2009, Wu Fengguang wrote:
> On Tue, Mar 03, 2009 at 09:25:59PM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12809
> > Subject		: iozone regression with 2.6.29-rc6
> > Submitter	: Lin Ming <ming.m.lin@intel.com>
> > Date		: 2009-02-27 9:13 (5 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1cf6e7d83bf334cc5916137862c920a97aabc018
> > References	: http://marc.info/?l=linux-kernel&m=123572630504360&w=4
> > Handled-By	: Wu Fengguang <fengguang.wu@intel.com>
> 
> Following Peter's idea of relaxing writeback throttling, Lin Ming
> and I tried the idea of totally disabling writeback throttling by
> doing benchmarks with the following parameters:
> 
>         echo 60 > /proc/sys/vm/dirty_ratio
>         echo 50 > /proc/sys/vm/dirty_background_ratio
> 
> The result is encouraging: the iozone performance is restored to the
> level of 2.6.29-rc5!
> 
> We'll continue to evaluate the dirty/throttling numbers with Nick's patch.

Thanks for the update.

Rafael
