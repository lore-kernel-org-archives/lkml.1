Return-Path: <linux-kernel-owner+w=401wt.eu-S1759051AbZDFWPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051AbZDFWPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863AbZDFWPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 18:15:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:4450 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419AbZDFWPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 18:15:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,332,1235980800"; 
   d="scan'208";a="128511674"
Date: Tue, 7 Apr 2009 06:15:09 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Lin, Ming M" <ming.m.lin@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bug #12809] iozone regression with 2.6.29-rc6
Message-ID: <20090406221509.GA17604@localhost>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera> <AsKNxFx2juN.A.41._Gn2JB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AsKNxFx2juN.A.41._Gn2JB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 03:05:38AM +0800, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12809
> Subject		: iozone regression with 2.6.29-rc6
> Submitter	: Lin Ming <ming.m.lin@intel.com>
> Date		: 2009-02-27 9:13 (39 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1cf6e7d83bf334cc5916137862c920a97aabc018
> References	: http://marc.info/?l=linux-kernel&m=123572630504360&w=4
> 		  http://lkml.org/lkml/2009/3/14/265
> Handled-By	: Wu Fengguang <fengguang.wu@intel.com>
> 

This bug could be closed.

The performance regression is triggered by commit 1cf6e7d83bf3(mm:
task dirty accounting fix). Which has been reverted in 2.6.29.

For 2.6.30, commit 1cf6e7d83bf33(mm: task dirty accounting fix) and
1b5e62b42b55(writeback: double the dirty thresholds) were just merged
together. The latter one restores the iozone performance. (However
might deteriorate some writeback slowness bugs..)

Thanks,
Fengguang

