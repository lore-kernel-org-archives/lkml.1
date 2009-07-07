Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbZGGGGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbZGGGGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 02:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbZGGGGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 02:06:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:22958 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbZGGGGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 02:06:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,361,1243839600"; 
   d="scan'208";a="530678724"
Subject: Re: [Bug #13726] fio sync read 4k block size 35% regression
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <dWkuWjWDsSB.A.lME.S0oUKB@chimera>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
	 <dWkuWjWDsSB.A.lME.S0oUKB@chimera>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 07 Jul 2009 14:06:42 +0800
Message-Id: <1246946802.2560.532.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-07 at 02:01 +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13726
> Subject		: fio sync read 4k block size 35% regression
> Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> Date		: 2009-07-01 11:25 (6 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=51daa88ebd8e0d437289f589af29d4b39379ea76
> References	: http://lkml.org/lkml/2009/6/30/679
> Handled-By	: Wu Fengguang <fengguang.wu@intel.com>
Fengguang,

I'm still working on it now. The new testing against 2.6.31-rc2 is ongoing.
fio sync/mmap read has new behavior. I did collect some data. But suddenly
with new created data, the fio_sync_read_4k regression disappeared, while
fio_mmap_read is still there. Originally, the testing and bisect were stable.
Let me check what happens firstly.

Just update.
﻿
How did you test your new readahead patches before sending to LKML?

Yanmin


