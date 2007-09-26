Return-Path: <linux-kernel-owner+w=401wt.eu-S1759077AbXIZNcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077AbXIZNcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 09:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755146AbXIZNcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 09:32:39 -0400
Received: from thunk.org ([69.25.196.29]:46325 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299AbXIZNch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 09:32:37 -0400
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: 2.6.23-rc7-ext4-1 patchset released
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1IaX0C-0005ph-1e@tinytim.thunk.org>
Date: Wed, 26 Sep 2007 09:32:32 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I've just released the 2.6.23-rc7-ext4-1; it's largely identical to
2.6.23-rc6-ext4-1 except that I've synchronized patches and patch names
with patches that Andrew had pulled into 2.6.23-rc7-mm1.

It's available in the standard place:

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git 2.6.23-rc8-ext4-1
http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=summary

and

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.23-rc8-ext4-1

                                                        - Ted

- sparse-fix.patch
+ # n.b. in rc7-mm1 as ext4-fix-sparse-warnings.patch
+ fix-sparse-warnings.patch

+ # pulled in from rc7-mm1
+ remove-obsolete-fragments.patch

- ext4_uninit_blockgroup.
+ #  n.b., this is in the rc7-mm1 patchset as 
+ #    next4-uninitialized-block-groups.patch 
+ #    and ext4-uninitialized-block-groups-fix.patch
+ uninitialized-block-groups.patch

- flex_bg_kernel.patch
+ # n.b. in rc7-mm1 as ext4-flex_bg_kernel.patch
+ flex_bg-kernel-support-v2.patch

+ fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc.patch

+ # n.b. in the rc7-mm1 tree as introduce-ext4_find_next_bit.patch
  generic-find-next-le-bit
