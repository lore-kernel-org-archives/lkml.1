Return-Path: <linux-kernel-owner+w=401wt.eu-S1030307AbXCGOk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030307AbXCGOk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 09:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030630AbXCGOk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 09:40:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030307AbXCGOkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 09:40:25 -0500
Subject: [GFS2/DLM] Pull request
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1173277501.11001.752.camel@quoit.chygwyn.com>
References: <1173277501.11001.752.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Wed, 07 Mar 2007 14:43:25 +0000
Message-Id: <1173278605.11001.782.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following GFS2 & DLM bug fixes and trivial clean ups. 
They are all relatively small in size,

Steve.

The following changes since commit 08e15e81a40e3241ce93b4a43886f3abda184aa6:
  Linus Torvalds (1):
        Linux 2.6.21-rc3

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git

Adrian Bunk (1):
      [DLM] fs/dlm/user.c should #include "user.h"

akpm@linux-foundation.org (1):
      [GFS2] build fix

Josef Whiter (2):
      [GFS2] fix locking mistake
      [GFS2] fix hangup when multiple processes are trying to write to the same file

Richard Fearn (1):
      [GFS2] add newline to printk message

Steven Whitehouse (5):
      [GFS2] Fix bz 230143, incorrect flushing of rgrps
      [GFS2] Fix bz 229831, lookup returns wrong inode
      [GFS2] Remove unused variable
      [GFS2] go_drop_bh is never used, so remove it
      [GFS2] Fix bz 229873, alternate test: assertion "!ip->i_inode.i_mapping->nrpages" failed

Wendy Cheng (2):
      [GFS2] NFS filehandle check
      [GFS2] pass formal ino in do_filldir_main

 fs/dlm/user.c         |    1 +
 fs/gfs2/glock.c       |    4 +---
 fs/gfs2/glops.c       |    3 ++-
 fs/gfs2/incore.h      |    2 --
 fs/gfs2/inode.c       |    7 ++++---
 fs/gfs2/ops_address.c |    7 +++++--
 fs/gfs2/ops_export.c  |    5 +----
 fs/gfs2/ops_fstype.c  |    2 +-
 fs/gfs2/quota.c       |    2 +-
 fs/gfs2/super.c       |    1 -
 10 files changed, 16 insertions(+), 18 deletions(-)


