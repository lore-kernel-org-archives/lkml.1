Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbZBPC4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbZBPC4v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 21:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755578AbZBPC4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 21:56:36 -0500
Received: from thunk.org ([69.25.196.29]:37199 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559AbZBPC4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 21:56:35 -0500
Date: Sun, 15 Feb 2009 21:56:11 -0500
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 fixes
Message-ID: <20090216025611.GB22619@mini-me.lan>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to grab regression and critical bug fixes for ext4.  Thanks!!

                                           - Ted

Aneesh Kumar K.V (3):
      ext4: Fix lockdep warning
      ext4: Initialize preallocation list_head's properly
      ext4: Implement range_cyclic in ext4_da_writepages instead of write_cache_pages

Dan Carpenter (1):
      ext4: Fix NULL dereference in ext4_ext_migrate()'s error handling

Jan Kara (3):
      jbd2: Fix return value of jbd2_journal_start_commit()
      Revert "ext4: wait on all pending commits in ext4_sync_fs()"
      jbd2: Avoid possible NULL dereference in jbd2_journal_begin_ordered_truncate()

Wei Yongjun (1):
      ext4: Fix to read empty directory blocks correctly in 64k

 fs/ext4/ext4.h        |    2 +-
 fs/ext4/inode.c       |   27 +++++++++++++++++++++++----
 fs/ext4/mballoc.c     |   32 +++++++++++++++++++-------------
 fs/ext4/migrate.c     |    8 +++-----
 fs/ext4/super.c       |   11 +++++++----
 fs/jbd2/journal.c     |   17 +++++++++++------
 fs/jbd2/transaction.c |   42 +++++++++++++++++++++++++++++++-----------
 fs/ocfs2/journal.h    |    6 ++++--
 include/linux/jbd2.h  |    3 ++-
 9 files changed, 101 insertions(+), 47 deletions(-)



