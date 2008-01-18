Return-Path: <linux-kernel-owner+w=401wt.eu-S1760006AbYARLCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006AbYARLCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 06:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754097AbYARLCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 06:02:32 -0500
Received: from mail.suse.de ([195.135.220.2]:44932 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274AbYARLCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 06:02:31 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 18 Jan 2008 22:02:24 +1100
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 000 of 4] md: assorted md patched - please read carefully.
Message-ID: <20080118215531.30136.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Following are 4 patches for md.

The first two replace
   md-allow-devices-to-be-shared-between-md-arrays.patch
which was recently remove.  They should go at the same place in the
series, between
    md-allow-a-maximum-extent-to-be-set-for-resyncing.patch
and
    md-lock-address-when-changing-attributes-of-component-devices.patch

The third is a replacement for
    md-change-iterate_rdev_generic-to-rdev_for_each_list-and-remove-iterate_rdev_pending.patch

which conflicts with the above change.

The last is a fix for
    md-fix-an-occasional-deadlock-in-raid5.patch

which makes me a lot happier about this patch.  It introduced a
performance regression and I now understand why.  I'm now happy for
that patch with this fix to go into 2.6.24 if that is convenient (If
not, 2.6.24.1 will do).

Thanks,
NeilBrown


 [PATCH 001 of 4] md: Set and test the ->persistent flag for md devices more consistently.
 [PATCH 002 of 4] md: Allow devices to be shared between md arrays.
 [PATCH 003 of 4] md: Change ITERATE_RDEV_GENERIC to rdev_for_each_list, and remove ITERATE_RDEV_PENDING.
 [PATCH 004 of 4] md: Fix an occasional deadlock in raid5 - FIX
