Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbZFVIuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbZFVIuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 04:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691AbZFVIu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 04:50:29 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:20435
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753691AbZFVIu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 04:50:28 -0400
Message-ID: <4A3F45D5.4020600@panasas.com>
Date: Mon, 22 Jun 2009 11:50:29 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd mailing-list <osd-dev@open-osd.org>
Subject: [GIT PULL] exofs/osd tree for 2.6.31
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jun 2009 08:50:31.0640 (UTC) FILETIME=[7FD70D80:01C9F316]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus

Please pull the following exofs/OSD changes from the git repository at:

  git://git.open-osd.org/linux-open-osd.git for-linus

These are a few fixes/cleanups and mainly a new block-device driver
from Jeff Garzik, that can export an OSD object to block-based users
like filesystems.

Boaz Harrosh (5):
      exofs: Fix bio leak in error handling path (sync read)
      exofs: Remove IBM copyrights
      exofs: Avoid using file_fsync()
      MAINTAINERS: Add osd maintained files (F:)
      osdblk: Adjust queue limits to lower device's limits

Jeff Garzik (1):
      osdblk: a Linux block device for OSD objects

 MAINTAINERS            |    5 +-
 drivers/block/Kconfig  |   16 ++
 drivers/block/Makefile |    1 +
 drivers/block/osdblk.c |  670 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/exofs/common.h      |    4 +-
 fs/exofs/dir.c         |    4 +-
 fs/exofs/exofs.h       |    7 +-
 fs/exofs/file.c        |   21 +-
 fs/exofs/inode.c       |    7 +-
 fs/exofs/namei.c       |    4 +-
 fs/exofs/osd.c         |    4 +-
 fs/exofs/super.c       |    6 +-
 fs/exofs/symlink.c     |    4 +-
 13 files changed, 719 insertions(+), 34 deletions(-)
 create mode 100644 drivers/block/osdblk.c

[These patches can be viewed on the web here:
 http://git.open-osd.org/gitweb.cgi?p=linux-open-osd.git;a=shortlog;h=refs/heads/for-linus
]

Thanks
Boaz
