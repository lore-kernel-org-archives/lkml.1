Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbZKKO2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbZKKO2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 09:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbZKKO2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 09:28:21 -0500
Received: from cantor.suse.de ([195.135.220.2]:35330 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398AbZKKO2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 09:28:20 -0500
Date: Wed, 11 Nov 2009 15:28:24 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PULL] Ext3 and JBD fixes
Message-ID: <20091111142824.GD21511@duck.suse.cz>
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

Eric Sandeen (1):
      ext3: retry failed direct IO allocations

Jan Kara (1):
      ext3: Wait for proper transaction commit on fsync

Tao Ma (1):
      JBD/JBD2: free j_wbuf if journal init fails.

The diffstat is

 fs/ext3/fsync.c           |   36 ++++++++++++++++--------------------
 fs/ext3/inode.c           |   36 +++++++++++++++++++++++++++++++++++-
 fs/ext3/super.c           |    2 ++
 fs/jbd/journal.c          |    2 ++
 fs/jbd2/journal.c         |    2 ++
 include/linux/ext3_fs_i.h |    8 ++++++++
 6 files changed, 65 insertions(+), 21 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
