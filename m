Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab0CBLAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 06:00:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab0CBLAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 06:00:20 -0500
Subject: GFS2: Pull request
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 02 Mar 2010 11:03:14 +0000
Message-ID: <1267527794.3405.21.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following GFS2 changes,

Steve.

------------------------------------------------------------------------------------------
The following changes since commit 30ff056c42c665b9ea535d8515890857ae382540:
  Linus Torvalds (1):
        Merge branch 'x86-uv-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git master

Abhijith Das (1):
      GFS2: Remove old, unused linked list code from quota

Bob Peterson (1):
      GFS2: print glock numbers in hex

Dave Chinner (1):
      GFS2: ordered writes are backwards

Steven Whitehouse (2):
      GFS2: Metadata address space clean up
      GFS2: Remove loopy umount code

 fs/gfs2/aops.c              |    4 +-
 fs/gfs2/glock.c             |   75 ++++++++++++++-----------------------------
 fs/gfs2/glock.h             |    7 ++++
 fs/gfs2/glops.c             |   16 +++++----
 fs/gfs2/incore.h            |    5 +--
 fs/gfs2/inode.c             |    6 +--
 fs/gfs2/lock_dlm.c          |    5 ++-
 fs/gfs2/lops.c              |    4 +-
 fs/gfs2/main.c              |   28 ++++++++++++++++
 fs/gfs2/meta_io.c           |   46 +++-----------------------
 fs/gfs2/meta_io.h           |   12 ++++++-
 fs/gfs2/ops_fstype.c        |    4 +--
 fs/gfs2/super.c             |   27 +++++----------
 fs/gfs2/sys.c               |    2 -
 fs/gfs2/util.c              |    1 +
 fs/gfs2/util.h              |    1 +
 include/linux/gfs2_ondisk.h |   30 +----------------
 17 files changed, 109 insertions(+), 164 deletions(-)


