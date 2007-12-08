Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbXLHUqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbXLHUqr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbXLHUqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:46:34 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:34855 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbXLHUqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:46:33 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org
Subject: [GIT PULL -mm] 0/2 Unionfs updates/fixes/cleanups
Date: Sat,  8 Dec 2007 15:46:03 -0500
Message-Id: <1197146765464-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following is a series of patches related to Unionfs: just a couple of
small bug fixes and/or optimizations.

These patches were tested (where appropriate) on Linus's 2.6.24 latest code
(as of v2.6.24-rc4-124-gf194d13), MM, as well as the backports to
2.6.{23,22,21,20,19,18,9} on ext2/3/4, xfs, reiserfs, nfs2/3/4, jffs2,
ramfs, tmpfs, cramfs, and squashfs (where available).  See
http://unionfs.filesystems.org/ to download back-ported unionfs code.

Please pull from the 'master' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/ezk/unionfs.git

to receive the following:

Erez Zadok (2):
      Unionfs: cleanup/consolidate branch-mode parsing code
      Unionfs: reduce the amount of cache-coherency debugging messages

 dentry.c |   38 +++++++++++++++++++++++---------------
 main.c   |   44 ++++++++++++++++++++++----------------------
 super.c  |   12 ++++++++----
 union.h  |    3 +--
 4 files changed, 54 insertions(+), 43 deletions(-)

---
Erez Zadok
ezk@cs.sunysb.edu
