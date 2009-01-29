Return-Path: <linux-kernel-owner+w=401wt.eu-S1756997AbZA2OE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997AbZA2OE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 09:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbZA2OEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 09:04:48 -0500
Received: from smtp.nokia.com ([192.100.122.230]:34937 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbZA2OEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 09:04:47 -0500
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 29 Jan 2009 18:02:17 +0200
Message-Id: <20090129160217.24794.31524.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBI changes for 2.6.29-rc3
X-OriginalArrivalTime: 29 Jan 2009 14:03:36.0154 (UTC) FILETIME=[60CC6BA0:01C9821A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from

git://git.infradead.org/ubi-2.6.git linux-next

The changes I kindly ask you to pull are mostly about adding some
UBI ioctls, rather than fixes. We add ioctls for UBI functionality
which has always be accessible via kernel API, so we do not really
change much and I think the changes are harmless. I just want to
make life of our users easier by pushing the patches to 2.6.29,
rather than delaying them until 2.6.30. And there are few fixes
and clean-ups.

The following changes since commit 1de9e8e70f5acc441550ca75433563d91b269bbe:
  Linus Torvalds (1):
        Linux 2.6.29-rc2

are available in the git repository at:

  git://git.infradead.org/ubi-2.6.git ..BRANCH.NOT.VERIFIED..

Artem Bityutskiy (7):
      UBI: improve ioctl commentaries
      UBI: remove unnecessry header inclusion
      UBI: allow all ioctls
      UBI: add ioctl compatibility
      UBI: use nicer 64-bit math
      UBI: remove unused variable
      UBI: fix resource de-allocation

Corentin Chary (3):
      UBI: add ioctl for map operation
      UBI: add ioctl for unmap operation
      UBI: add ioctl for is_mapped operation

Jan Engelhardt (1):
      UBI: constify file operations

Sidney Amani (1):
      UBI: allow direct user-space I/O

 drivers/mtd/ubi/Kconfig.debug |   10 --
 drivers/mtd/ubi/build.c       |   21 +++--
 drivers/mtd/ubi/cdev.c        |  184 +++++++++++++++++++++++++++++-----------
 drivers/mtd/ubi/gluebi.c      |   11 +--
 drivers/mtd/ubi/scan.c        |    8 +-
 drivers/mtd/ubi/ubi.h         |   11 ++-
 drivers/mtd/ubi/upd.c         |   21 ++---
 drivers/mtd/ubi/vmt.c         |   17 ++--
 include/mtd/ubi-user.h        |  132 ++++++++++++++++++++++++-----
 9 files changed, 284 insertions(+), 131 deletions(-)

Thanks,
Artem.
