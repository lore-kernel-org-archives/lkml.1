Return-Path: <linux-kernel-owner+w=401wt.eu-S1752317AbZBCIhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbZBCIhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 03:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbZBCIgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 03:36:52 -0500
Received: from smtp.nokia.com ([192.100.105.134]:61786 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZBCIgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 03:36:52 -0500
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Date: Tue, 03 Feb 2009 12:33:54 +0200
Message-Id: <20090203103354.13185.12343.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBIFS changes for 2.6.29-rc4
X-OriginalArrivalTime: 03 Feb 2009 08:35:23.0886 (UTC) FILETIME=[5B5B88E0:01C985DA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull UBIFS fixes and clean-ups from

git://git.infradead.org/ubifs-2.6.git linux-next

The following changes since commit 1de9e8e70f5acc441550ca75433563d91b269bbe:
  Linus Torvalds (1):
        Linux 2.6.29-rc2

Adrian Hunter (5):
      UBIFS: ensure orphan area head is initialized
      UBIFS: fix LPT out-of-space bug (again)
      UBIFS: sync wbufs after syncing inodes and pages
      UBIFS: spelling fix 'date' -> 'data'
      UBIFS: remount ro fixes

Artem Bityutskiy (12):
      UBIFS: do not commit twice
      UBIFS: constify operations
      UBIFS: do not treat all data as short term
      UBIFS: document dark_wm and dead_wm better
      UBIFS: simplify locking
      UBIFS: fix LEB list freeing
      UBIFS: add re-mount debugging checks
      UBIFS: always clean up GC LEB space
      UBIFS: fix assertions
      UBIFS: fix no_chk_data_crc
      UBIFS: return sensible error codes
      UBIFS: remove fast unmounting

 Documentation/filesystems/ubifs.txt |    7 --
 fs/ubifs/budget.c                   |   35 +++++--
 fs/ubifs/debug.c                    |  122 ++++++++++++++++------
 fs/ubifs/debug.h                    |   36 ++++---
 fs/ubifs/dir.c                      |   96 +++++++----------
 fs/ubifs/file.c                     |    9 +-
 fs/ubifs/gc.c                       |   28 +++++-
 fs/ubifs/io.c                       |   22 +++--
 fs/ubifs/journal.c                  |    2 +-
 fs/ubifs/lprops.c                   |   12 ++-
 fs/ubifs/lpt_commit.c               |   44 ++++++--
 fs/ubifs/master.c                   |    2 +-
 fs/ubifs/orphan.c                   |   38 ++++----
 fs/ubifs/super.c                    |  195 +++++++++++++++++------------------
 fs/ubifs/tnc.c                      |   12 ++-
 fs/ubifs/ubifs.h                    |   26 +++---
 16 files changed, 393 insertions(+), 293 deletions(-)

Thanks,
Artem.
