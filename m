Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbZCaLZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbZCaLZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 07:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbZCaLZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 07:25:34 -0400
Received: from smtp.nokia.com ([192.100.122.230]:51961 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbZCaLZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 07:25:33 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Date: Tue, 31 Mar 2009 14:24:39 +0300
Message-Id: <20090331112439.5337.67925.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBIFS changes for 2.6.30
X-OriginalArrivalTime: 31 Mar 2009 11:24:40.0174 (UTC) FILETIME=[481C18E0:01C9B1F3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull UBIFS changes.

The following changes since commit d5b562330ec766292a3ac54ae5e0673610bd5b3d:
  Hugh Dickins (1):
        mm: fix error case in mlock downgrade reversion

are available in the git repository at:

  git://git.infradead.org/ubifs-2.6.git linux-next

Adrian Hunter (2):
      UBIFS: fix dbg_chk_lpt_sz()
      UBIFS: fix bug where page is marked uptodate when out of space

Artem Bityutskiy (9):
      UBIFS: improve find function interface
      UBIFS: amend key_hash return value
      UBIFS: fix bogus assertion
      UBIFS: fix lprops committing bug
      UBIFS: use KERN_CONT
      UBIFS: introduce a helpful variable
      UBIFS: fix commentaries
      UBIFS: fully sort GCed nodes
      UBIFS: add R/O compatibility

Eric Sesterhenn (1):
      UBIFS: list usage cleanup

Hunter Adrian (1):
      UBIFS: fix compiler warnings

 fs/ubifs/budget.c      |   37 ++---
 fs/ubifs/debug.c       |    6 +-
 fs/ubifs/file.c        |   16 ++-
 fs/ubifs/find.c        |   12 +-
 fs/ubifs/gc.c          |  428 +++++++++++++++++++++++++++++++++---------------
 fs/ubifs/journal.c     |    7 +-
 fs/ubifs/key.h         |    6 +-
 fs/ubifs/log.c         |    5 +-
 fs/ubifs/lpt_commit.c  |   34 ++--
 fs/ubifs/replay.c      |    2 +-
 fs/ubifs/sb.c          |   36 ++++-
 fs/ubifs/shrinker.c    |    6 +-
 fs/ubifs/super.c       |   37 +++-
 fs/ubifs/tnc.c         |    2 +-
 fs/ubifs/ubifs-media.h |   30 +++-
 fs/ubifs/ubifs.h       |   13 +-
 16 files changed, 459 insertions(+), 218 deletions(-)

Thanks,
Artem.
