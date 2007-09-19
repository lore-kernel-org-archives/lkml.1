Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbXISVZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbXISVZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 17:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbXISVY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 17:24:59 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:52791 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbXISVY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 17:24:58 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org
Subject: [GIT PULL -mm] 0/6 Unionfs updates/cleanups/fixes
Date: Wed, 19 Sep 2007 17:24:34 -0400
Message-Id: <1190237080683-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The following is a series of patches related to Unionfs.  They represent a
few code cleanups (suggested or inspired by comments on the previous set of
patches), and a few more bug fixes (esp. to cache coherency).  These fixes
were tested on our 2.6.23-rc6 latest code, as well as the backports to
2.6.{22,21,20,19,18,9} on ext2/3/4, xfs, reiserfs, nfs, jffs2, ramfs, tmpfs,
cramfs, and squashfs (where available).  See http://unionfs.filesystems.org/
to download backported unionfs code.

Please pull from the 'master' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/ezk/unionfs.git
                                              ^^^
(Note: the git URL to pull from had changed from "jsipek" to "ezk")

to receive the following:

Erez_Zadok (6):
      Unionfs: use bool type in dentry and file revalidation code
      Unionfs: remove unnecessary comment
      Unionfs: add missing newlines to printks
      Unionfs: check integrity only if validated dentry successfully
      Unionfs: unionfs_lookup locking consistency
      Unionfs: cache coherency after lower objects are removed

 commonfops.c |   12 ++++++------
 dentry.c     |    9 +++++----
 dirfops.c    |    4 ++--
 fanout.h     |    1 -
 file.c       |   12 ++++++------
 inode.c      |    6 +++++-
 lookup.c     |   52 +++++++++++++++++++++++++++++++---------------------
 mmap.c       |    6 +++---
 union.h      |    2 +-
 9 files changed, 59 insertions(+), 45 deletions(-)

Erez Zadok
ezk@cs.sunysb.edu
