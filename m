Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbZCZEVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbZCZEVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 00:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbZCZEVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 00:21:06 -0400
Received: from THUNK.ORG ([69.25.196.29]:49782 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbZCZEVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 00:21:05 -0400
To: linux-ext4@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Subject: Ext4 tree stable patches backports for 2.6.27 and 2.6.28
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1Lmh5L-0004oH-Mp@closure.thunk.org>
Date: Thu, 26 Mar 2009 00:20:55 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've updated the for-stable and for-stable-2.6.27 branches in the ext4
git tree that were merged into mainline right before 2.6.29.  In
addition, there is a build fix for ocfs2 if CONFIG_OFS2_COMPAT_JBD is
enabled.

The ext4 git tree can be found here:

   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
   http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git

The new patches in the for-stable and for-stable-2.6.27 branches can be
found below.

If folks can test out the for-stable and/or the for-stable-2.6.27
branches, I would appreciate it before I send these patches to
stable@kernel.org.

						- Ted

mainline 2.6.28 2.6.27
    commit-description
--------------------------------------------------------------------
8f64b32e f609c44f -------
    ext4: don't call jbd2_journal_force_commit_nested without journal
7ce9d5d1 c6af7e10 8657e625
    ext4: fix ext4_free_inode() vs. ext4_claim_inode() race
395a87bf fa39f633 b3239aab
    ext4: fix header check in ext4_ext_search_right() for deep extent trees.
2842c3b5 8ef147bd e9b9a503
    ext4: Print the find_group_flex() warning only once
8d03c7a0 1d5f2059 ce54e9c7
    ext4: fix bogus BUG_ONs in in mballoc code
d33a1976 40087f88 e0ee7aa0
    ext4: fix bb_prealloc_list corruption due to wrong group locking
fb68407b 6dd72926 --------
    jbd2: Call journal commit callback without holding j_list_lock
-------- 221a645b --------
    ocfs2: Fix build failure when CONFIG_OFS2_COMPAT_JBD is enabled
