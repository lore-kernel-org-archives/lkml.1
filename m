Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbYD2Deh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbYD2Deh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 23:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbYD2De0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 23:34:26 -0400
Received: from ns1.suse.de ([195.135.220.2]:57575 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbYD2DeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 23:34:25 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 29 Apr 2008 13:34:38 +1000
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bernd Schubert <bernd-schubert@gmx.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: stable@kernel.org
Subject: [PATCH 000 of 9] md: Assorted patches for the 2.5.26 merge window
Message-ID: <20080429133104.20146.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Following 9 patches for md are suitable for 2.5.26.  
Yes, I really should have submitted them to -mm earlier, but I've been
on leave, sorry.

First patch is a bug fix that should go in 2.6.25.stable. 
It has been copied to stable@kernel.org. 

Others are mostly related to "external" metadata support.  i.e. a userspace
program does all the management of metadata, and needs to communicate
with the kernel to do its job properly.

NeilBrown


 [PATCH 001 of 9] md: Fix use after free when removing rdev via sysfs
 [PATCH 002 of 9] md: Skip all metadata update processing when using external metadata.
 [PATCH 003 of 9] md: Reinitialise more mddev fields in do_md_stop.
 [PATCH 004 of 9] md: Fix 'safemode' handling for external metadata.
 [PATCH 005 of 9] md: Fix up switching md arrays between read-only and read-write
 [PATCH 006 of 9] md: Remove a stray command from a copy and paste error in resync_start_store
 [PATCH 007 of 9] md: prevent duplicates in bind_rdev_to_array
 [PATCH 008 of 9] md: md: raid5 rate limit error printk
 [PATCH 009 of 9] md: md: support blocking writes to an array on device failure
