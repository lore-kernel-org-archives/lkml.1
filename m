Return-Path: <linux-kernel-owner+w=401wt.eu-S1760070AbXLUCmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760070AbXLUCmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 21:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbXLUCmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 21:42:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:12625 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641AbXLUCmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 21:42:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,192,1196668800"; 
   d="scan'208";a="248461553"
Subject: Re: Linux 2.6.24-rc6
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.9999.0712201731010.21557@woody.linux-foundation.org>
References: <alpine.LFD.0.9999.0712201731010.21557@woody.linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Date: Fri, 21 Dec 2007 10:40:45 +0800
Message-Id: <1198204845.6362.152.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-20 at 17:41 -0800, Linus Torvalds wrote:
> The most noticeable part here (both to users and in the diffstat) should 
> be the libata-acpi fixes by Tejun Heo, which should hopefully take care of 
> all of the regressions that were caused by teaching SATA about doing the 
> proper ACPI stuff at bootup/suspend/resume/shutdown.
> 
> Other changes visible in the diffstat are a couple of new watchdog drivers 
> and the removal of the old tipar driver, and some Korean translations of 
> the kernel docs. And some V4L videobuf changes.
> 
> Other than that, it's pretty much a lot of small fixes (maybe not 
> one-liners, but we're talking "a few lines"). Networking, USB, scsi, 
> wireless, infiniband, IDE... With some alpha, ia64 and x86 arch updates.
> 
> The regression list keeps shrinking, so we're still on track for a full 
> 2.6.24 release in early January. Assuming we don't all overeat during the 
> holidays and nobody gets any work done. But we all know that the holidays 
> are really the time when we get away from the boring "real work", and can 
> spend 24/7 on kernel hacking instead, right?
> 
> Here's to a merry christmas, doing the whole druidic festival around the 
> tree thing,
When my automation testing system applied it to 2.6.23, below error stopped
the testing.

***************************
Hunk #3 FAILED at 534.
1 out of 3 hunks FAILED -- saving rejects to file drivers/video/mbx/reg_bits.h.rej
patching file drivers/video/mbx/regs.h

-yanmin


