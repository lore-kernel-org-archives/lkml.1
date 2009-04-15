Return-Path: <linux-kernel-owner+w=401wt.eu-S1759438AbZDOL0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759438AbZDOL0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 07:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758882AbZDOL0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 07:26:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57339 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758343AbZDOL0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 07:26:08 -0400
Subject: GFS2: Pull request
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Wed, 15 Apr 2009 12:26:45 +0100
Message-Id: <1239794805.3377.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following small GFS2 fixes,

Steve.

The following changes since commit 0882e8dd3aad33eca41696d463bb896e6c8817eb:
  Linus Torvalds (1):
        Linux 2.6.30-rc2

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git master

Christoph Hellwig (1):
      GFS2: cleanup file_operations mess

Steven Whitehouse (3):
      GFS2: Make quotad's waiting interruptible
      GFS2: Fix symlink creation race
      GFS2: Move umount flush rwsem

Xu Gang (1):
      GFS2: Use DEFINE_SPINLOCK

 fs/gfs2/glock.c     |   10 +++++-----
 fs/gfs2/inode.c     |    8 ++++----
 fs/gfs2/inode.h     |   14 ++++++++------
 fs/gfs2/ops_file.c  |    8 ++++----
 fs/gfs2/ops_inode.c |    1 +
 fs/gfs2/quota.c     |    4 ++--
 6 files changed, 24 insertions(+), 21 deletions(-)


