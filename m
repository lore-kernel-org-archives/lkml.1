Return-Path: <linux-kernel-owner+w=401wt.eu-S932810AbXBTGf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810AbXBTGf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 01:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932841AbXBTGf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 01:35:29 -0500
Received: from mx1.suse.de ([195.135.220.2]:56150 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932810AbXBTGf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 01:35:28 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 20 Feb 2007 17:34:41 +1100
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: stable@kernel.org
Subject: [PATCH 000 of 6] md: Assorted fixes and features for md for 2.6.21
Message-ID: <20070220172544.15678.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following 6 patches are against 2.6.20 and are suitable for 2.6.21.
They are not against -mm because the new plugging makes raid5 not work
and so not testable, and there are a few fairly minor intersections between
these patches and those patches.
There is also a very minor conflict with the hardware-xor patches - one line
of context is different.

Patch 1 should probably go in -stable - the bug could cause data
corruption in a fairly uncommon raid10 configuration, so that one and
this intro are Cc:ed to stable@kernel.org.

Thanks,
NeilBrown


 [PATCH 001 of 6] md: Fix raid10 recovery problem.
 [PATCH 002 of 6] md: RAID6: clean up CPUID and FPU enter/exit code
 [PATCH 003 of 6] md: Move warning about creating a raid array on partitions of the one device.
 [PATCH 004 of 6] md: Clean out unplug and other queue function on md shutdown
 [PATCH 005 of 6] md: Restart a (raid5) reshape that has been aborted due to a read/write error.
 [PATCH 006 of 6] md: Add support for reshape of a raid6
