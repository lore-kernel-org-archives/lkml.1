Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbYANBpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbYANBpi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 20:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbYANBp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 20:45:28 -0500
Received: from ns2.suse.de ([195.135.220.15]:59173 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbYANBp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 20:45:27 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 14 Jan 2008 12:45:18 +1100
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Dan Williams" <dan.j.williams@gmail.com>
Subject: [PATCH 000 of 6] md: various fixes for md
Message-ID: <20080114123726.19968.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following are 6 patches for md which are suitable for 2.6.25-rc1.

The first fixes a bug which could make it a candidate for 24-final.
However it is a deadlock that seems to occur very rarely, and has been
in mainline since 2.6.22.  So letting it into one more release
shouldn't be a big problem.  While the fix is fairly simple, it could
have some unexpected consequences, so I'd rather go for the next cycle.

The second patch fixes a bug which only affect -mm at the moment but
will probably affect 2.6.25 unless fixed.

The rest are cleanups with no functional change (I hope).

Thanks,
NeilBrown


 [PATCH 001 of 6] md: Fix an occasional deadlock in raid5
 [PATCH 002 of 6] md: Fix use-after-free bug when dropping an rdev from an md array.
 [PATCH 003 of 6] md: Change a few 'int' to 'size_t' in md
 [PATCH 004 of 6] md: Change INTERATE_MDDEV to for_each_mddev
 [PATCH 005 of 6] md: Change ITERATE_RDEV to rdev_for_each
 [PATCH 006 of 6] md: Change ITERATE_RDEV_GENERIC to rdev_for_each_list, and remove ITERATE_RDEV_PENDING.
