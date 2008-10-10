Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbYJJIGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbYJJIGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 04:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112AbYJJIF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 04:05:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58156 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbYJJIFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 04:05:54 -0400
Subject: [GFS2] Pull request
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cluster-devel@redhat.com
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Fri, 10 Oct 2008 09:05:19 +0100
Message-Id: <1223625919.3493.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following changes. There have been no changes since
the patches were posted to lkml on Sept 26th.

Steve.

The following changes since commit 30a2f3c60a84092c8084dfe788b710f8d0768cd4:
  Linus Torvalds (1):
        Linux 2.6.27-rc3

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git master

Abhijith Das (1):
      GFS2: GFS2 will panic if you misspell any mount options

Bob Peterson (2):
      GFS2: rm on multiple nodes causes panic
      GFS2: Direct IO write at end of file error

Julien Brunel (1):
      GFS2: Use an IS_ERR test rather than a NULL test

Steven Whitehouse (8):
      GFS2: Fix debugfs glock file iterator
      GFS2: Fix metafs mounts
      GFS2: Fix & clean up GFS2 rename
      GFS2: Fix race relating to glock min-hold time
      GFS2: The war on bloat
      GFS2: high time to take some time over atime
      GFS2: Add UUID to GFS2 sb
      GFS2: Support for I/O barriers

 fs/gfs2/glock.c             |   15 +-
 fs/gfs2/glock.h             |    1 -
 fs/gfs2/incore.h            |   38 ++--
 fs/gfs2/inode.c             |  159 +-----------
 fs/gfs2/inode.h             |    2 -
 fs/gfs2/log.c               |   21 ++-
 fs/gfs2/mount.c             |    7 +
 fs/gfs2/ops_address.c       |   18 +-
 fs/gfs2/ops_file.c          |   16 +-
 fs/gfs2/ops_fstype.c        |  578 +++++++++++++++++++++++++++++--------------
 fs/gfs2/ops_inode.c         |  127 ++++++++---
 fs/gfs2/ops_super.c         |  108 ++++++--
 fs/gfs2/super.c             |  340 -------------------------
 fs/gfs2/super.h             |    6 -
 fs/gfs2/sys.c               |   11 -
 include/linux/gfs2_ondisk.h |    6 +-
 16 files changed, 654 insertions(+), 799 deletions(-)


