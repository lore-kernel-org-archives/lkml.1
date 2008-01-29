Return-Path: <linux-kernel-owner+w=401wt.eu-S932701AbYA2NaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701AbYA2NaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 08:30:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932485AbYA2N3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 08:29:07 -0500
Received: from brick.kernel.dk ([87.55.233.238]:9581 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932476AbYA2N3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:29:06 -0500
Date: Tue, 29 Jan 2008 14:29:02 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] block updates
Message-ID: <20080129132900.GT15220@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This patchset restructures block/ll_rw_blk.c from it's current 4500 line
monster into several smaller files. It has basically become impossible
to navigate ll_rw_blk.c, this will make it easier in the future. In
addition, the patchset saves about ~400 bytes of kernel image here.

Updated right now and pushing right away to avoid in-flight conflicts
with people touching ll_rw_blk.c!

  git://git.kernel.dk/linux-2.6-block.git for-linus

Jens Axboe (7):
      xsysace: end request handling fix
      block: initial part of splitting ll_rw_blk
      block: continue ll_rw_blk.c splitup
      block: get rid of unnecessary forward declarations in blk-core.c
      block: remove dated (and wrong) comment in blk-core.c
      block: ll_rw_blk.c split, add blk-merge.c
      block: fix warning on compile with CONFIG_BLOCK

 block/Makefile          |    4 +-
 block/blk-barrier.c     |  319 ++++
 block/blk-core.c        | 2034 +++++++++++++++++++++
 block/blk-exec.c        |  105 ++
 block/blk-ioc.c         |  192 ++
 block/blk-map.c         |  264 +++
 block/blk-merge.c       |  485 +++++
 block/blk-settings.c    |  400 +++++
 block/blk-sysfs.c       |  298 ++++
 block/blk-tag.c         |  396 +++++
 block/blk.h             |   53 +
 block/ll_rw_blk.c       | 4457 -----------------------------------------------
 drivers/block/xsysace.c |    5 +-
 include/linux/blkdev.h  |    1 +
 14 files changed, 4552 insertions(+), 4461 deletions(-)
 create mode 100644 block/blk-barrier.c
 create mode 100644 block/blk-core.c
 create mode 100644 block/blk-exec.c
 create mode 100644 block/blk-ioc.c
 create mode 100644 block/blk-map.c
 create mode 100644 block/blk-merge.c
 create mode 100644 block/blk-settings.c
 create mode 100644 block/blk-sysfs.c
 create mode 100644 block/blk-tag.c
 create mode 100644 block/blk.h
 delete mode 100644 block/ll_rw_blk.c

-- 
Jens Axboe

