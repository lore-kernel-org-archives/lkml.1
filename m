Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbXEUBdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbXEUBdb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 21:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754243AbXEUBdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 21:33:17 -0400
Received: from ns1.suse.de ([195.135.220.2]:56599 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082AbXEUBdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 21:33:16 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 21 May 2007 11:32:57 +1000
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "Jeff Zheng" <Jeff.Zheng@endace.com>
Cc: Neil Brown <neilb@suse.de>
Cc: stable@kernel.org
Subject: [PATCH 000 of 7] md: Introduction EXPLAIN PATCH SET HERE
Message-ID: <20070521111837.20906.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following are 7 patches for md in current main-line.

The first two fix bugs that can cause data corruption, and so are suitable for -stable. 

The next fixes some problems with hot-adding a device to a linear array.  As has not
been tested by my test-suite until now, it hasn't worked properly until now :-(

The remainder are mainly cleaning up code and comments.  They could
wait for 2.6.23, but are probably safe to go into 2.6.22 (maybe sit a week in -mm??)

Thanks,
NeilBrown


 [PATCH 001 of 7] md: Avoid overflow in raid0 calculation with large components.
 [PATCH 002 of 7] md: Don't write more than is required of the last page of a bitmap
 [PATCH 003 of 7] md: Fix bug with linear hot-add and elsewhere.
 [PATCH 004 of 7] md: Improve message about invalid superblock during autodetect.
 [PATCH 005 of 7] md: Improve the is_mddev_idle test fix
 [PATCH 006 of 7] md: Check that internal bitmap does not overlap other data.
 [PATCH 007 of 7] md: Change bitmap_unplug and others to void functions.
