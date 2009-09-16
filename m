Return-Path: <linux-kernel-owner+w=401wt.eu-S1759184AbZIPPtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759184AbZIPPtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 11:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759046AbZIPPtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 11:49:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48297 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718AbZIPPtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 11:49:09 -0400
Date: Wed, 16 Sep 2009 17:49:07 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org
Subject: [PULL REQUEST] ext3/jbd fixes for 2.6.32-rc1
Message-ID: <20090916154907.GO26030@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for_linus

  to get:

Andreas Dilger (1):
      JBD: round commit timer up to avoid uncommitted transaction

Chris Mason (1):
      ext3: Add locking to ext3_do_update_inode

Jan Kara (5):
      ext3: Update MAINTAINERS for ext3 and JBD
      jbd: Journal block numbers can ever be only 32-bit use unsigned int for them
      jbd: Annotate transaction start also for journal_restart()
      ext3: Fix possible deadlock between ext3_truncate() and ext3_get_blocks()
      ext3: Flush disk caches on fsync when needed

The diffstat is

 MAINTAINERS          |    3 +--
 fs/ext3/fsync.c      |   12 +++++++++++-
 fs/ext3/inode.c      |   28 ++++++++++++++++++++++++----
 fs/jbd/checkpoint.c  |    6 +++---
 fs/jbd/commit.c      |    2 +-
 fs/jbd/journal.c     |   30 +++++++++++++++---------------
 fs/jbd/recovery.c    |   18 +++++++++---------
 fs/jbd/revoke.c      |   16 ++++++++--------
 fs/jbd/transaction.c |    9 +++++----
 include/linux/jbd.h  |   26 +++++++++++++-------------
 10 files changed, 90 insertions(+), 60 deletions(-)

                                                        Thanks
                                                                Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
