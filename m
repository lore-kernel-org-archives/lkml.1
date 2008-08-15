Return-Path: <linux-kernel-owner+w=401wt.eu-S1758256AbYHOJ35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbYHOJ35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 05:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753937AbYHOJ3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 05:29:47 -0400
Received: from smtp.nokia.com ([192.100.122.230]:29393 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbYHOJ3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 05:29:46 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Zoltan Sogor <weth@inf.u-szeged.hu>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 15 Aug 2008 14:07:44 +0300
Message-Id: <20080815110744.13628.81644.sendpatchset@gollum>
Subject: [GIT PULL] UBIFS updates for 2.6.27-rc4
X-OriginalArrivalTime: 15 Aug 2008 09:28:55.0226 (UTC) FILETIME=[566A21A0:01C8FEB9]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from

git://git.infradead.org/~dedekind/ubifs-2.6.git linux-next

The following changes since commit 30a2f3c60a84092c8084dfe788b710f8d0768cd4:
  Linus Torvalds (1):
        Linux 2.6.27-rc3

are available:

Adrian Hunter (8):
      UBIFS: fix error return in failure mode
      UBIFS: ensure UBIFS switches to read-only on error
      UBIFS: make ubifs_ro_mode() not inline
      UBIFS: do not union creat_sqnum and del_cmtno
      UBIFS: fix typos in comments
      UBIFS: correct orphan deletion order
      UBIFS: correct spelling of "thrice".
      UBIFS: always set i_generation to 0

Artem Bityutskiy (18):
      UBIFS: print volume name as well
      UBIFS: fix budgeting calculations
      UBIFS: improve debugging
      UBIFS: free budget in delete_inode as well
      UBIFS: do not write orphans back
      UBIFS: remove unneeded function parameter
      UBIFS: remove another unneeded function parameter
      UBIFS: increment commit number earlier
      UBIFS: optimize deletions
      UBIFS: improve budgeting checks
      UBIFS: align inode data to eight
      UBIFS: print pid in dump function
      UBIFS: reserve more space for index
      UBIFS: minor tweaks in commit
      UBIFS: improve arguments checking in debugging messages
      UBIFS: few commentary fixes
      UBIFS: remove unneeded check
      UBIFS: xattr bugfixes

Sebastian Siewior (1):
      Documentation: fix typo in ubifs.txt

Zoltan Sogor (2):
      UBIFS: support splice_write
      UBIFS: fix budgeting request alignment in xattr code

 Documentation/filesystems/ubifs.txt |    2 +-
 fs/ubifs/budget.c                   |   33 +++++++--
 fs/ubifs/commit.c                   |    3 +-
 fs/ubifs/debug.c                    |   27 ++++---
 fs/ubifs/debug.h                    |  143 +++++++++++++++++------------------
 fs/ubifs/dir.c                      |   24 ++----
 fs/ubifs/file.c                     |    8 +-
 fs/ubifs/find.c                     |    9 ++-
 fs/ubifs/io.c                       |   14 ++++
 fs/ubifs/journal.c                  |  110 ++++++++++++++++++++-------
 fs/ubifs/log.c                      |    4 +-
 fs/ubifs/misc.h                     |   16 +----
 fs/ubifs/orphan.c                   |    4 +-
 fs/ubifs/super.c                    |   48 +++++++-----
 fs/ubifs/tnc_commit.c               |   37 +++++-----
 fs/ubifs/ubifs-media.h              |    4 +-
 fs/ubifs/ubifs.h                    |   33 ++++++---
 fs/ubifs/xattr.c                    |   54 ++++++--------
 18 files changed, 329 insertions(+), 244 deletions(-)

Note, some commits are not fixes, but rather improvements. But
2.6.27 is going to be the first kernel release for UBIFS, so I
this is probably OK in this case.
