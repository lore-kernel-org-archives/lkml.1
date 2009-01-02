Return-Path: <linux-kernel-owner+w=401wt.eu-S1757824AbZABJkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824AbZABJkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 04:40:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757055AbZABJj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 04:39:56 -0500
Received: from smtp.nokia.com ([192.100.105.134]:33188 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbZABJjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 04:39:55 -0500
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Date: Fri, 02 Jan 2009 13:13:58 +0200
Message-Id: <20090102111358.3186.7431.sendpatchset@gollum>
Subject: [GIT PULL] UBIFS changes for 2.6.29
X-OriginalArrivalTime: 02 Jan 2009 09:39:47.0881 (UTC) FILETIME=[0D426190:01C96CBE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull UBIFS updates from

git://git.infradead.org/ubifs-2.6.git linux-next

The following changes since commit f6f7b52e2f6149d2ee365717afff315b05720162:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../wim/linux-2.6-watchdog

are available:

Alexey Dobriyan (1):
      UBIFS: fix section mismatch

Artem Bityutskiy (31):
      UBIFS: slight compression optimization
      UBIFS: use bit-fields to store compression type
      UBIFS: introduce compression mount options
      UBIFS: separate debugging fields out
      UBIFS: add debugfs support
      UBIFS: run debugging checks only if they are enabled
      UBIFS: dump stack in LPT check functions
      UBIFS: introduce LPT dump function
      UBIFS: use PAGE_CACHE_MASK correctly
      UBIFS: fix tnc dumping
      UBIFS: improve budgeting dump
      UBIFS: various comment improvements and fixes
      UBIFS: fix available blocks count
      UBIFS: use nicer 64-bit math
      UBIFS: re-calculate min_idx_size after the commit
      UBIFS: avoid unnecessary calculations
      UBIFS: fix constants initialization
      UBIFS: fix file-system synchronization
      UBIFS: always commit in sync_fs
      UBIFS: use ubi_sync
      UBIFS: always commit on unmount
      UBIFS: restore budg_uncommitted_idx
      UBIFS: do not lie about used blocks
      UBIFS: simplify make_free_space
      UBIFS: fix sparse warnings
      UBIFS: fix checkpatch.pl warnings
      UBIFS: fix writing uncompressed files
      UBIFS: allow mounting when short of space
      UBIFS: fix numerous spelling mistakes
      UBIFS: print debugging messages properly
      UBIFS: add more useful debugging prints

Kukkonen Mika (1):
      UBIFS: avoid unnecessary checks

 Documentation/filesystems/ubifs.txt |    3 +
 fs/ubifs/budget.c                   |  208 +++++++++------------------
 fs/ubifs/commit.c                   |   25 ++--
 fs/ubifs/compress.c                 |   18 ++--
 fs/ubifs/debug.c                    |  265 ++++++++++++++++++++++++++++++----
 fs/ubifs/debug.h                    |  117 ++++++++++++----
 fs/ubifs/file.c                     |    8 +-
 fs/ubifs/ioctl.c                    |    2 +
 fs/ubifs/journal.c                  |    4 +-
 fs/ubifs/key.h                      |   32 +++--
 fs/ubifs/lprops.c                   |   14 +-
 fs/ubifs/lpt.c                      |   45 +++---
 fs/ubifs/lpt_commit.c               |  210 +++++++++++++++++++++++-----
 fs/ubifs/orphan.c                   |    2 +-
 fs/ubifs/replay.c                   |   15 ++-
 fs/ubifs/sb.c                       |   20 ++--
 fs/ubifs/super.c                    |  255 +++++++++++++++++++++++----------
 fs/ubifs/tnc.c                      |   31 ++--
 fs/ubifs/tnc_commit.c               |    9 +-
 fs/ubifs/ubifs-media.h              |    7 +
 fs/ubifs/ubifs.h                    |  111 +++++++--------
 21 files changed, 927 insertions(+), 474 deletions(-)

Thanks,
Artem.
