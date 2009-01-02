Return-Path: <linux-kernel-owner+w=401wt.eu-S1757735AbZABJjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735AbZABJjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 04:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZABJjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 04:39:13 -0500
Received: from smtp.nokia.com ([192.100.122.233]:19206 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbZABJjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 04:39:12 -0500
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 02 Jan 2009 13:13:00 +0200
Message-Id: <20090102111300.3183.45651.sendpatchset@gollum>
Subject: [GIT PULL] UBI changes for 2.6.29
X-OriginalArrivalTime: 02 Jan 2009 09:38:49.0929 (UTC) FILETIME=[EAB79B90:01C96CBD]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from

git://git.infradead.org/~dedekind/ubi-2.6.git linux-next

The following changes since commit f6f7b52e2f6149d2ee365717afff315b05720162:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../wim/linux-2.6-watchdog

are available:

Artem Bityutskiy (7):
      UBI: fix warnings when debugging is enabled
      UBI: fix deadlock
      UBI: some code re-structuring
      UBI: fix error path
      UBI: handle write errors in WL worker
      UBI: document UBI ioctls
      UBI: fix checkpatch.pl warnings

Stefan Roese (1):
      UBI: return -ENOMEM upon failing vmalloc

Xiaochuan-Xu (2):
      UBI: prepare for protection tree improvements
      UBI: simplify PEB protection code

 Documentation/ioctl/ioctl-number.txt |    4 +
 drivers/mtd/ubi/build.c              |    5 +-
 drivers/mtd/ubi/cdev.c               |    3 +-
 drivers/mtd/ubi/debug.h              |   10 +-
 drivers/mtd/ubi/eba.c                |   51 +++--
 drivers/mtd/ubi/io.c                 |   28 ++-
 drivers/mtd/ubi/ubi.h                |   45 ++--
 drivers/mtd/ubi/wl.c                 |  489 +++++++++++++++-------------------
 8 files changed, 305 insertions(+), 330 deletions(-)

Thanks,
Artem.
