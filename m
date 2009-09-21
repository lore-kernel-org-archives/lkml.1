Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbZIUJ1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbZIUJ1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 05:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755741AbZIUJ1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 05:27:04 -0400
Received: from smtp.nokia.com ([192.100.122.230]:41305 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730AbZIUJ1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 05:27:00 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 21 Sep 2009 12:26:30 +0300
Message-Id: <20090921092630.25879.85934.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBI changes for 2.6.32
X-OriginalArrivalTime: 21 Sep 2009 09:26:49.0396 (UTC) FILETIME=[A5797F40:01CA3A9D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please, pull UBI changes.

The following changes since commit 64f1607ffbbc772685733ea63e6f7f4183df1b16:
  Linus Torvalds (1):
        Linux 2.6.31-rc6

are available in the git repository at:

  git://git.infradead.org/ubi-2.6.git linux-next

Artem Bityutskiy (5):
      UBI: print a message if ECH is corrupted and VIDH is ok
      UBI: amend NOR flash pre-erase quirk
      UBI: print a warning if too many PEBs are corrupted
      UBI: introduce flash dump helper
      UBI: improve NOR flash erasure quirk

Phil Carmody (1):
      UBI: eliminate possible undefined behaviour

 drivers/mtd/ubi/debug.c |   32 +++++++++++++++++++++++++++++
 drivers/mtd/ubi/debug.h |    2 +
 drivers/mtd/ubi/io.c    |   51 +++++++++++++++++++++++++++++++---------------
 drivers/mtd/ubi/scan.c  |   22 +++++++++++++++++--
 drivers/mtd/ubi/scan.h  |    2 +
 drivers/mtd/ubi/ubi.h   |    3 +-
 6 files changed, 91 insertions(+), 21 deletions(-)


Thanks,
Artem.
