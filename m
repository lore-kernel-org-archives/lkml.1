Return-Path: <linux-kernel-owner+w=401wt.eu-S1758876AbZCXSYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876AbZCXSYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 14:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbZCXSYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 14:24:12 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:59754 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059AbZCXSYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 14:24:11 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC Aufs2 #4 0/3] convert aufs entires from sysfs to debugfs
Date: Wed, 25 Mar 2009 03:24:04 +0900
Message-Id: <1237919047-8751-1-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow the comments from Greg KH on LKML.
Move 'xib' and 'xi0 ... xiN' entries from sysaufs to debugfs.
They show how many disk blocks are consumed.

J. R. Okajima (3):
  aufs: convert some aufs entries from sysfs to debugfs, new files
  aufs: convert some aufs entries from sysfs to debugfs
  aufs: convert some aufs entries from sysfs to debugfs, documentation

 Documentation/ABI/testing/debugfs-aufs |   40 +++++
 Documentation/ABI/testing/sysfs-aufs   |   37 ----
 Documentation/filesystems/aufs/README  |    3 +-
 Documentation/filesystems/aufs/aufs.5  |   57 ++++---
 fs/aufs/Makefile                       |    1 +
 fs/aufs/aufs.h                         |    1 +
 fs/aufs/branch.c                       |    2 +-
 fs/aufs/branch.h                       |    6 +-
 fs/aufs/dbgaufs.c                      |  292 ++++++++++++++++++++++++++++++++
 fs/aufs/dbgaufs.h                      |   68 ++++++++
 fs/aufs/super.c                        |    5 +
 fs/aufs/super.h                        |   19 ++
 fs/aufs/sysaufs.c                      |   30 +++-
 fs/aufs/sysaufs.h                      |   16 +-
 fs/aufs/sysfs.c                        |  168 ++++---------------
 15 files changed, 527 insertions(+), 218 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-aufs
 create mode 100644 fs/aufs/dbgaufs.c
 create mode 100644 fs/aufs/dbgaufs.h

