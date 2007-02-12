Return-Path: <linux-kernel-owner+w=401wt.eu-S964961AbXBLSbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964961AbXBLSbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 13:31:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965276AbXBLSbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 13:31:08 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:34233 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964961AbXBLSbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 13:31:06 -0500
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [GIT PULL -mm] Unionfs updates/cleanups
Date: Mon, 12 Feb 2007 13:30:49 -0500
Message-Id: <11713050521708-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.rc3.g5057
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches (also available though the git tree) fix few
cleanliness issues with Unionfs.

You can pull from 'master' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jsipek/unionfs.git

to receive the following:

Erez Zadok (1):
      Unionfs: Documentation update

Josef 'Jeff' Sipek (2):
      fs/unionfs/: Use __roundup_pow_of_two instead of custom rounding code
      fs/: Move eCryptfs & Unionfs config options into a sub-menu

 Documentation/filesystems/unionfs/00-INDEX   |    8 ++-
 Documentation/filesystems/unionfs/issues.txt |   23 +++++++++
 Documentation/filesystems/unionfs/usage.txt  |   31 ++++--------
 fs/Kconfig                                   |   66 ++++++++++++++------------
 fs/unionfs/main.c                            |    2 +-
 fs/unionfs/rdstate.c                         |   11 +----
 fs/unionfs/union.h                           |    1 +
 7 files changed, 77 insertions(+), 65 deletions(-)

Josef 'Jeff' Sipek.


