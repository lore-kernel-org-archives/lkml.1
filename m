Return-Path: <linux-kernel-owner+w=401wt.eu-S1762708AbXLNPtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762708AbXLNPtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 10:49:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbXLNPsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 10:48:54 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:55684 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbXLNPsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 10:48:52 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org
Subject: [GIT PULL -mm] 0/2 Unionfs updates/fixes/cleanups
Date: Fri, 14 Dec 2007 10:47:59 -0500
Message-Id: <11976472813872-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following is a series of patches related to Unionfs.

These patches were tested (where appropriate) on Linus's 2.6.24 latest code
(as of v2.6.24-rc5-43-gda8cadb), MM (MMOTM stamp-2007-12-13-15-37), as well
as the backports to 2.6.{23,22,21,20,19,18,9} on ext2/3/4, xfs, reiserfs,
nfs2/3/4, jffs2, ramfs, tmpfs, cramfs, and squashfs (where available).  Also
tested with LTP-full.  See http://unionfs.filesystems.org/ to download
back-ported unionfs code.

Please pull from the 'master' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/ezk/unionfs.git

to receive the following:

Erez Zadok (2):
      Unionfs: avoid using drop_pagecache_sb in remount
      Unionfs: clarify usage.txt mount options

 Documentation/filesystems/unionfs/usage.txt |   38 +++++++++++++++++++---------
 fs/drop_caches.c                            |    4 --
 fs/unionfs/dentry.c                         |   11 ++++++++
 fs/unionfs/super.c                          |   34 ++++++++-----------------
 fs/unionfs/union.h                          |    1 
 include/linux/mm.h                          |    2 -
 6 files changed, 52 insertions(+), 38 deletions(-)

---
Erez Zadok
ezk@cs.sunysb.edu
