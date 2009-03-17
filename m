Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbZCQUj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbZCQUj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 16:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbZCQUjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 16:39:48 -0400
Received: from THUNK.ORG ([69.25.196.29]:41591 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbZCQUjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 16:39:48 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 fixes
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1Ljg4b-0000us-NG@closure.thunk.org>
Date: Tue, 17 Mar 2009 16:39:41 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to grab final 2.6.29 fixes for ext4.  Thanks!!

						- Ted
	
Eric Sandeen (3):
      ext4: fix header check in ext4_ext_search_right() for deep extent trees.
      ext4: fix bogus BUG_ONs in in mballoc code
      ext4: fix bb_prealloc_list corruption due to wrong group locking

Theodore Ts'o (1):
      ext4: Print the find_group_flex() warning only once

 fs/ext4/extents.c |    6 ++++--
 fs/ext4/ialloc.c  |    4 +++-
 fs/ext4/mballoc.c |   13 +++++++++----
 3 files changed, 16 insertions(+), 7 deletions(-)
