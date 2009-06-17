Return-Path: <linux-kernel-owner+w=401wt.eu-S933247AbZFQMBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247AbZFQMBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 08:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757748AbZFQMBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 08:01:22 -0400
Received: from smtp.nokia.com ([192.100.122.233]:58785 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302AbZFQMBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 08:01:21 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 17 Jun 2009 16:53:40 +0300
Message-Id: <20090617135340.2685.79886.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBI changes for 2.6.31
X-OriginalArrivalTime: 17 Jun 2009 12:01:11.0406 (UTC) FILETIME=[4E6810E0:01C9EF43]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

pease pull UBI changes from

git://git.infradead.org/ubi-2.6.git linux-next

The following changes since commit 1406de8e11eb043681297adf86d6892ff8efc27a:
  Linus Torvalds (1):
        Linux 2.6.30-rc6

are available:

Artem Bityutskiy (17):
      UBI: remove redundant mutex
      UBI: re-name volumes_mutex to device_mutex
      UBI: improve debugging messages
      UBI: small debugging code optimization
      UBI: fix races in I/O debugging checks
      UBI: add dump_stack in checking code
      UBI: do not panic if volume check fails
      UBI: minor serialization fix
      UBI: fix race condition
      UBI: introduce new constants
      UBI: fix and clean-up error paths in WL worker
      UBI: do not switch to R/O mode on read errors
      UBI: improve messages in the WL worker
      UBI: print amount of reserved PEBs
      UBI: fix kmem_cache_free on error patch
      UBI: fix multiple spelling typos
      UBI: handle more error codes

Dmitry Pervushin (3):
      UBI: add notification API
      UBI: remove built-in gluebi
      UBI: make gluebi a separate module

Kevin Cernekee (1):
      UBI: add reboot notifier

 drivers/mtd/ubi/Kconfig  |   13 +-
 drivers/mtd/ubi/Makefile |    2 +-
 drivers/mtd/ubi/build.c  |  161 ++++++++++++++++++--
 drivers/mtd/ubi/cdev.c   |   32 ++--
 drivers/mtd/ubi/eba.c    |   99 ++++++++-----
 drivers/mtd/ubi/gluebi.c |  378 +++++++++++++++++++++++++++++++++++-----------
 drivers/mtd/ubi/io.c     |   82 +++++++++-
 drivers/mtd/ubi/kapi.c   |  117 ++++++++++++---
 drivers/mtd/ubi/ubi.h    |   84 ++++++-----
 drivers/mtd/ubi/upd.c    |    8 +-
 drivers/mtd/ubi/vmt.c    |   65 +++-----
 drivers/mtd/ubi/wl.c     |  179 +++++++++++++---------
 include/linux/mtd/ubi.h  |   37 +++++
 13 files changed, 922 insertions(+), 335 deletions(-)

Thanks,
Artem.
