Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993AbZCUUIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbZCUUIZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 16:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbZCUUIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 16:08:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35201 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbZCUUIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 16:08:07 -0400
Date: Sat, 21 Mar 2009 21:05:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: 2.6.29-rc8-git5: Reported regressions from 2.6.28
Message-ID: <20090321200534.GA30238@elte.hu>
References: <GPBuLTara4J.A.3kH.TZTxJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <GPBuLTara4J.A.3kH.TZTxJB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12809
> Subject		: iozone regression with 2.6.29-rc6
> Submitter	: Lin Ming <ming.m.lin@intel.com>
> Date		: 2009-02-27 9:13 (23 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1cf6e7d83bf334cc5916137862c920a97aabc018
> References	: http://marc.info/?l=linux-kernel&m=123572630504360&w=4
> 		  http://lkml.org/lkml/2009/3/14/265
> Handled-By	: Wu Fengguang <fengguang.wu@intel.com>

I think this was tracked back to the effective halving of 
dirty_ratio by 1cf6e7d83 ("mm: task dirty accounting fix") and 
doubling the ratio fixed the iozone regression.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12800
> Subject		: x86 PAT invalid vm_insert_pfn assumptions
> Submitter	: Thomas Hellstrom <thellstrom@vmware.com>
> Date		: 2009-03-02 01:40 (20 days old)

fix queued up for .30:

 895791d: VM, x86, PAT: add a new vm flag to track full pfnmap at mmap
 4bb9c5c: VM, x86, PAT: Change is_linear_pfn_mapping to not use vm_pgoff

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12763
> Subject		: Different cpu MHz values for processor0 and processor1
> Submitter	: Matthew A. Bockol <mbockol@carleton.edu>
> Date		: 2009-02-21 5:42 (29 days old)
> References	: http://marc.info/?l=linux-kernel&m=123519687807246&w=4

first-bad-commit:

d96f94c: ACPI: Enable bit 11 in _PDC to advertise hw coord

	Ingo
