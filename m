Return-Path: <linux-kernel-owner+w=401wt.eu-S1757242AbZLJI20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbZLJI20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 03:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbZLJI2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 03:28:20 -0500
Received: from smtp.nokia.com ([192.100.105.134]:59001 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbZLJI2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 03:28:20 -0500
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 10 Dec 2009 10:27:40 +0200
Message-Id: <20091210082740.6403.22787.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBIFS changes for 2.6.33
X-OriginalArrivalTime: 10 Dec 2009 08:28:11.0590 (UTC) FILETIME=[B5BEE660:01CA7972]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please, pull from UBIFS tree. Since there are dependencies between few
UBI and UBIFS patches, I combined all the UBI and UBIFS stuff, so you
will effectively pull all UBI and UBIFS updates for this merge window.

The following changes since commit 648f4e3e50c4793d9dbf9a09afa193631f76fa26:
  Linus Torvalds (1):
        Linux 2.6.32-rc8

are available in the git repository at:

  git://git.infradead.org/ubifs-2.6.git master

Artem Bityutskiy (1):
      MAINTAINERS: change e-mail of Artem Bityutskiy

Christoph Hellwig (1):
      UBIFS: remove manual O_SYNC handling

Corentin Chary (2):
      UBI: Add ubi_open_volume_path
      UBIFS: support mounting of UBI volume character devices

Roel Kluin (1):
      UBIFS: fix return code in check_leaf

Sebastian Andrzej Siewior (1):
      UBI: flush wl before clearing update marker

 MAINTAINERS             |    4 ++--
 drivers/mtd/ubi/kapi.c  |   40 ++++++++++++++++++++++++++++++++++++++++
 drivers/mtd/ubi/upd.c   |   20 +++++++++++---------
 fs/ubifs/debug.c        |    2 +-
 fs/ubifs/file.c         |   13 +------------
 fs/ubifs/super.c        |   20 +++++++++++++++-----
 include/linux/mtd/ubi.h |    2 ++
 7 files changed, 72 insertions(+), 29 deletions(-)

Thanks,
Artem.
