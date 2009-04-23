Return-Path: <linux-kernel-owner+w=401wt.eu-S1760456AbZDWWf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760456AbZDWWf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 18:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755316AbZDWWfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 18:35:09 -0400
Received: from THUNK.ORG ([69.25.196.29]:56528 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805AbZDWWfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 18:35:07 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 fixes
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1Lx7VW-00030k-4z@closure.thunk.org>
Date: Thu, 23 Apr 2009 18:35:02 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to grab the following fixes for ext4 and jbd2 (and one very similar fix
for jbd).

                                                - Ted

Chuck Ebbert (1):
      ext4: really print the find_group_flex fallback warning only once

Theodore Ts'o (4):
      jbd2: use SWRITE_SYNC_PLUG when writing synchronous revoke records
      jbd: use SWRITE_SYNC_PLUG when writing synchronous revoke records
      ext4: Make the extent validity check more paranoid
      ext4: Fix potential inode allocation soft lockup in Orlov allocator

 fs/ext4/extents.c    |   18 ++++++++++++------
 fs/ext4/ialloc.c     |    6 ++++--
 fs/jbd/commit.c      |    2 +-
 fs/jbd/revoke.c      |   20 +++++++++++---------
 fs/jbd2/commit.c     |    3 ++-
 fs/jbd2/revoke.c     |   21 ++++++++++++---------
 include/linux/jbd.h  |    3 ++-
 include/linux/jbd2.h |    3 ++-
 8 files changed, 46 insertions(+), 30 deletions(-)

