Return-Path: <linux-kernel-owner+w=401wt.eu-S1752597AbXA2Uhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbXA2Uhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 15:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbXA2Uhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 15:37:52 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:50399 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbXA2Uht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 15:37:49 -0500
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH 4/4] fs/unionfs/: Don't duplicate the struct nameidata
Date: Mon, 29 Jan 2007 15:37:43 -0500
Message-Id: <11701030642806-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.rc1.g5355
In-Reply-To: <11701030631109-git-send-email-jsipek@cs.sunysb.edu>
References: <11701030631109-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Josef 'Jeff' Sipek (3):
      fs/unionfs/: Remove stale_inode.c
      fs/unionfs/: Andrew Morton's comments
      fs/unionfs/: Don't duplicate the struct nameidata

 fs/unionfs/branchman.c   |    4 +-
 fs/unionfs/commonfops.c  |   54 +++++++++++-----------
 fs/unionfs/copyup.c      |   67 +++++++++++++++------------
 fs/unionfs/dentry.c      |   19 +++-----
 fs/unionfs/fanout.h      |   51 +++++++++++++++++----
 fs/unionfs/file.c        |   17 +++-----
 fs/unionfs/inode.c       |   69 +++++++++++++++-------------
 fs/unionfs/lookup.c      |  113 +++++++++++++++++++++++-----------------------
 fs/unionfs/main.c        |   32 +++++++-------
 fs/unionfs/rdstate.c     |    2 +-
 fs/unionfs/rename.c      |    8 ++--
 fs/unionfs/sioq.c        |   19 ++++----
 fs/unionfs/sioq.h        |    1 -
 fs/unionfs/stale_inode.c |  112 ---------------------------------------------
 fs/unionfs/subr.c        |   65 +++++++++++++++++++++++++-
 fs/unionfs/super.c       |    7 +--
 fs/unionfs/union.h       |   84 +++-------------------------------
 fs/unionfs/unlink.c      |    8 ++--
 fs/unionfs/xattr.c       |   16 +++---
 19 files changed, 330 insertions(+), 418 deletions(-)
