Return-Path: <linux-kernel-owner+w=401wt.eu-S1751501AbZG3NEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbZG3NEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 09:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbZG3NEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 09:04:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48963 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbZG3NEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 09:04:35 -0400
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
In-Reply-To: <1248961524-30913-1-git-send-email-swhiteho@redhat.com>
References: <1248961524-30913-1-git-send-email-swhiteho@redhat.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Thu, 30 Jul 2009 14:02:22 +0100
Message-Id: <1248958942.3298.151.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following changes,

Steve.

----------------------------------------------------------------------------
The following changes since commit 4be3bd7849165e7efa6b0b35a23d6a3598d97465:
  Linus Torvalds (1):
        Linux 2.6.31-rc4

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git master

Benjamin Marzinski (5):
      GFS2: keep statfs info in sync on grows
      GFS2: Fix panic in glock memory shrinker
      GFS2: Don't put unlikely reclaim candidates on the reclaim list.
      GFS2: Fix incorrent statfs consistency check
      GFS2: remove dcache entries for remote deleted inodes

Steven Whitehouse (2):
      GFS2: Shrink the shrinker
      GFS2: Don't try and dealloc own inode

 fs/gfs2/aops.c   |   39 +++++++++++++++
 fs/gfs2/glock.c  |  138 +++++++++++++++++++++++++++++++++++------------------
 fs/gfs2/glock.h  |    3 +
 fs/gfs2/glops.c  |   21 ++++++++
 fs/gfs2/incore.h |    2 +
 fs/gfs2/rgrp.c   |   23 ++++------
 fs/gfs2/super.c  |   40 ++++++++++------
 fs/gfs2/super.h  |    4 ++
 8 files changed, 195 insertions(+), 75 deletions(-)


