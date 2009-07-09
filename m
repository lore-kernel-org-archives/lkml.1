Return-Path: <linux-kernel-owner+w=401wt.eu-S1757051AbZGIFVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051AbZGIFVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 01:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbZGIFV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 01:21:26 -0400
Received: from smtp.nokia.com ([192.100.122.230]:22463 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbZGIFV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 01:21:26 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 09 Jul 2009 10:11:17 +0300
Message-Id: <20090709071117.10126.42653.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBI changes for 2.6.31-rc3
X-OriginalArrivalTime: 09 Jul 2009 05:20:49.0051 (UTC) FILETIME=[050E16B0:01CA0055]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are UBI NOR recovery and debugging code fixes. Pease pull
from

git://git.infradead.org/ubi-2.6.git linux-next

The following changes since commit 8e4a718ff38d8539938ec3421935904c27e00c39:
  Linus Torvalds (1):
        Linux 2.6.31-rc2

Adrian Hunter (1):
      UBI: add image sequence number to EC header

Artem Bityutskiy (5):
      UBI: add empty eraseblocks verification
      UBI: remove bogus debugging checks
      UBI: nicify image sequence number handling
      UBI: fix NOR flash recovery
      UBI: fix compilation warnings

 drivers/mtd/ubi/build.c     |    6 ++
 drivers/mtd/ubi/debug.c     |    2 +
 drivers/mtd/ubi/debug.h     |    7 ++
 drivers/mtd/ubi/io.c        |  157 +++++++++++++++++--------------------------
 drivers/mtd/ubi/scan.c      |   14 ++++
 drivers/mtd/ubi/scan.h      |    2 +
 drivers/mtd/ubi/ubi-media.h |   12 +++-
 drivers/mtd/ubi/ubi.h       |    6 ++-
 drivers/mtd/ubi/wl.c        |    8 ++
 9 files changed, 116 insertions(+), 98 deletions(-)

Thanks,
Artem.
