Return-Path: <linux-kernel-owner+w=401wt.eu-S1755716AbZIUJ04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbZIUJ04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 05:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbZIUJ0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 05:26:55 -0400
Received: from smtp.nokia.com ([192.100.105.134]:41020 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346AbZIUJ0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 05:26:55 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 21 Sep 2009 12:26:16 +0300
Message-Id: <20090921092616.25878.84772.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBIFS changes for 2.6.32
X-OriginalArrivalTime: 21 Sep 2009 09:26:34.0912 (UTC) FILETIME=[9CD76A00:01CA3A9D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please, pull UBIFS tree. Below goes the 'git request-pull' info,
which mentions one merge commit. I had to create it in order to
resolve conflicts with the per-bdi writeback changes, which went
in this merge window from the 'linux-2.6-block' tree.

The following changes since commit ebc79c4f8da0f92efa968e0328f32334a2ce80cf:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../jaswinder/linux-2.6

are available in the git repository at:

  git://git.infradead.org/ubifs-2.6.git linux-next

Artem Bityutskiy (13):
      UBIFS: kill BKL
      UBIFS: remove unneeded call from ubifs_sync_fs
      UBIFS: constify file and inode operations
      UBIFS: add inode size debugging check
      UBIFS: do not print scary error messages needlessly
      UBIFS: check ubifs_scan error codes better
      UBIFS: amend commentaries
      UBIFS: define journal head numbers in ubifs-media.h
      UBIFS: improve journal head debugging prints
      UBIFS: various minor commentary fixes
      UBIFS: improve lprops dump
      UBIFS: fix debugging dump
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6 into linux-next

Subrata Modak (2):
      UBIFS: suppress compilation warning
      UBIFS: remove unused functions

 fs/ubifs/budget.c      |    2 +-
 fs/ubifs/commit.c      |    2 +-
 fs/ubifs/debug.c       |  112 +++++++++++++++++++++++++++++++++++++++++++++---
 fs/ubifs/debug.h       |    5 ++
 fs/ubifs/file.c        |   62 +++++++++++++--------------
 fs/ubifs/gc.c          |    2 +-
 fs/ubifs/io.c          |   29 ++++++------
 fs/ubifs/journal.c     |   13 +++--
 fs/ubifs/key.h         |   35 +++------------
 fs/ubifs/log.c         |   17 ++++---
 fs/ubifs/lprops.c      |   43 +++++++++----------
 fs/ubifs/master.c      |   20 ++++++---
 fs/ubifs/orphan.c      |    7 ++-
 fs/ubifs/recovery.c    |    4 +-
 fs/ubifs/replay.c      |    6 +-
 fs/ubifs/scan.c        |   32 +++++++++----
 fs/ubifs/super.c       |   33 ++++----------
 fs/ubifs/tnc.c         |   76 +++++++++++++++++++++++++++++++-
 fs/ubifs/tnc_commit.c  |    2 +-
 fs/ubifs/ubifs-media.h |    7 +++
 fs/ubifs/ubifs.h       |   13 +++---
 fs/ubifs/xattr.c       |    4 +-
 22 files changed, 345 insertions(+), 181 deletions(-)


Thanks,
Artem.
