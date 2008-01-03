Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352AbYACF6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbYACF6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 00:58:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbYACF6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 00:58:08 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:50694 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbYACF6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 00:58:06 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org
Subject: [GIT PULL -mm] 0/3 Unionfs updates/fixes/cleanups
Date: Thu,  3 Jan 2008 00:57:37 -0500
Message-Id: <11993398601-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following is a series of patchsets related to Unionfs.  This is the
third set of patchsets resulting from an lkml review of the entire unionfs
code base.  The most significant change here is a locking/race bugfix during
dentry revalidation.

These patches were tested (where appropriate) on Linus's 2.6.24 latest code
(as of v2.6.24-rc6-179-gb8c9a18), MM, as well as the backports to
2.6.{23,22,21,20,19,18,9} on ext2/3/4, xfs, reiserfs, nfs2/3/4, jffs2,
ramfs, tmpfs, cramfs, and squashfs (where available).  Also tested with
LTP-full.  See http://unionfs.filesystems.org/ to download back-ported
unionfs code.

Please pull from the 'master' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/ezk/unionfs.git

to receive the following:

Erez Zadok (3):
      Unionfs: use printk KERN_CONT for debugging messages
      Unionfs: locking fixes
      Unionfs: use VFS helpers to manipulate i_nlink

 debug.c  |   50 ++++++++++++++++++++++++++------------------------
 dentry.c |   13 ++++++++++++-
 fanout.h |    3 ++-
 unlink.c |    2 +-
 4 files changed, 41 insertions(+), 27 deletions(-)

---
Erez Zadok
ezk@cs.sunysb.edu
