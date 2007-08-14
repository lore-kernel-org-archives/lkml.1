Return-Path: <linux-kernel-owner+w=401wt.eu-S932066AbXHNQvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066AbXHNQvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 12:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765643AbXHNQug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 12:50:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765634AbXHNQue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 12:50:34 -0400
Subject: [GFS2/DLM] Pull request
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1187086122.8765.838.camel@quoit>
References: <11870848365-git-send-email-swhiteho@redhat.com>
	 <1187086122.8765.838.camel@quoit>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 14 Aug 2007 17:44:49 +0100
Message-Id: <1187109889.8765.854.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following bug fixes from the GFS2/DLM -fixes git tree,

Steve.

The following changes since commit 39d3520c92cf7a28c07229ca00cc35a1e8026c77:
  Linus Torvalds (1):
        Linux 2.6.23-rc3

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git

Bob Peterson (2):
      [GFS2] soft lockup detected in databuf_lo_before_commit
      [GFS2] soft lockup in rgblk_search

David Teigland (2):
      [DLM] fix NULL ls usage
      [DLM] fix basts for granted PR waiting CW

Jesper Juhl (1):
      [DLM] Fix memory leak in dlm_add_member() when dlm_node_weight() returns less than zero

Patrick Caulfield (3):
      [DLM] Clear othercon pointers when a connection is closed
      [DLM] zero unused parts of sockaddr_storage
      [DLM] More othercon fixes

Steven Whitehouse (4):
      [GFS2] Fix incorrect return code in rgrp.c
      [GFS2] Fix incorrect error path in prepare_write()
      [GFS2] Fix setting of inherit jdata attr
      [GFS2] Revert remounting w/o acl option leaves acls enabled

 fs/dlm/lock.c         |   69 +++++++++++++++++++++++++++++++++++++++----------
 fs/dlm/lowcomms.c     |   24 +++++++++++-----
 fs/dlm/member.c       |    4 ++-
 fs/dlm/rcom.c         |    7 ++---
 fs/gfs2/lops.c        |    6 +++-
 fs/gfs2/mount.c       |   25 +++++++++--------
 fs/gfs2/ops_address.c |    3 +-
 fs/gfs2/ops_file.c    |   29 ++++++++++++--------
 fs/gfs2/rgrp.c        |   16 ++++++++---
 9 files changed, 124 insertions(+), 59 deletions(-)


