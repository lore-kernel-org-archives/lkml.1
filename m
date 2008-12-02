Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbYLBLxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbYLBLxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 06:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbYLBLxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 06:53:05 -0500
Received: from smtp.nokia.com ([192.100.122.230]:35269 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbYLBLxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 06:53:04 -0500
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Date: Tue, 02 Dec 2008 15:27:57 +0200
Message-Id: <20081202132757.6240.12229.sendpatchset@gollum>
Subject: [GIT PULL] UBIFS updates for 2.6.28-rc7
X-OriginalArrivalTime: 02 Dec 2008 11:52:24.0630 (UTC) FILETIME=[710BAD60:01C95474]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull UBIFS updates from

git://git.infradead.org/ubifs-2.6.git linux-next

The following changes since commit 45beca08dd8b6d6a65c5ffd730af2eac7a2c7a03:
  Linus Torvalds (1):
        Linux v2.6.28-rc3

Adrian Hunter (1):
      UBIFS: allow for gaps when dirtying the LPT

Artem Bityutskiy (6):
      UBIFS: remove printk
      MAINTAINERS: change UBI/UBIFS git tree URLs
      UBIFS: fix compilation warnings
      UBIFS: do not print scary memory allocation warnings
      UBIFS: do not allocate too much
      UBIFS: pre-allocate bulk-read buffer

Harvey Harrison (1):
      UBIFS: endian handling fixes and annotations

 MAINTAINERS           |    4 +-
 fs/ubifs/commit.c     |    4 +-
 fs/ubifs/debug.c      |   66 +++++++++++++++++++++--------------
 fs/ubifs/dir.c        |    5 ++-
 fs/ubifs/file.c       |   91 ++++++++++++++++++++++++++++++++++---------------
 fs/ubifs/journal.c    |    8 +++--
 fs/ubifs/key.h        |    4 +-
 fs/ubifs/lpt_commit.c |    2 -
 fs/ubifs/orphan.c     |   28 +++++++++------
 fs/ubifs/recovery.c   |   17 +++++----
 fs/ubifs/replay.c     |    2 +-
 fs/ubifs/sb.c         |    9 +++--
 fs/ubifs/super.c      |   70 +++++++++++++++++++++++++++++++------
 fs/ubifs/tnc.c        |   12 +++++--
 fs/ubifs/ubifs.h      |   12 +++++--
 15 files changed, 223 insertions(+), 111 deletions(-)

-

The "UBIFS: allow for gaps when dirtying the LPT" patch solves
the problem reported by Deepak Saxena when UBIFS switches to R/O
mode out of the blue and says that LPT is out of space.

The "UBIFS: remove printk" fixes a little bit annoying message
from UBIFS which comes every time we re-mount the FS.

The "UBIFS: do not print scary memory allocation warnings",
    "UBIFS: do not allocate too much", and
    "UBIFS: pre-allocate bulk-read buffer"
patches fix UBIFS memory allocation problems when bulk-read is
enabled.

Thanks,
Artem.
