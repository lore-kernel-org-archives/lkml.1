Return-Path: <linux-kernel-owner+w=401wt.eu-S1752814AbZGJHN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbZGJHN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 03:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbZGJHNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 03:13:19 -0400
Received: from mga14.intel.com ([143.182.124.37]:60460 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbZGJHNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 03:13:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,377,1243839600"; 
   d="scan'208";a="163513547"
Date: Fri, 10 Jul 2009 14:37:30 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13726] fio sync read 4k block size 35% regression
Message-ID: <20090710063730.GA23814@localhost>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera> <dWkuWjWDsSB.A.lME.S0oUKB@chimera> <1246946802.2560.532.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246946802.2560.532.camel@ymzhang>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 02:06:42PM +0800, Zhang, Yanmin wrote:
> On Tue, 2009-07-07 at 02:01 +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13726
> > Subject		: fio sync read 4k block size 35% regression
> > Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> > Date		: 2009-07-01 11:25 (6 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=51daa88ebd8e0d437289f589af29d4b39379ea76
> > References	: http://lkml.org/lkml/2009/6/30/679
> > Handled-By	: Wu Fengguang <fengguang.wu@intel.com>
> Fengguang,
> 
> I'm still working on it now. The new testing against 2.6.31-rc2 is ongoing.
> fio sync/mmap read has new behavior. I did collect some data. But suddenly
> with new created data, the fio_sync_read_4k regression disappeared, while

Do you mean the fio_sync_read_4k regression disappeared because we are
collecting data with lots of printks?

> fio_mmap_read is still there. Originally, the testing and bisect were stable.
> Let me check what happens firstly.

Thanks! What's your fio_mmap_read job file and the readahead traces?

Thanks,
Fengguang
