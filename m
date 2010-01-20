Return-Path: <linux-kernel-owner+w=401wt.eu-S1751967Ab0ATJ0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab0ATJ0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 04:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734Ab0ATJ0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 04:26:17 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:46812 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663Ab0ATJ0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 04:26:15 -0500
Date: Wed, 20 Jan 2010 10:26:13 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block bits for 2.6.34-rc4
Message-ID: <20100120092613.GY13771@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Nothing major in here. A CFQ bug fix, two rounds of drbd fixups, some
fixes to the IO stacking calculations, and a few other bug fixes.
Please pull!


  git://git.kernel.dk/linux-2.6-block.git for-linus

Divyesh Shah (1):
      cfq-iosched: Respect ioprio_class when preempting

Jens Axboe (2):
      Merge branch 'for-jens' of git://git.drbd.org/linux-2.6-drbd into for-linus
      Merge branch 'for-jens' of http://git.drbd.org/linux-2.6-drbd into for-linus

Johannes Thoma (2):
      drbd: Kconfig fix
      drbd: Don't go into StandAlone mode when authentification failes because of network error

Julia Lawall (2):
      drivers/block/drbd: Correct NULL test
      drivers/block/drbd/drbd_receiver.c: correct NULL test

Kirill Afonshin (1):
      block: removed unused as_io_context

Lars Ellenberg (1):
      drbd: check on CONFIG_LBDAF, not LBD

Martin K. Petersen (4):
      block: Correct handling of bottom device misaligment
      block: Fix discard alignment calculation and printing
      block: bdev_stack_limits wrapper
      DM: Fix device mapper topology stacking

Philipp Reisner (5):
      drbd: Use drbd_crypto_is_hash() instead of an open coded check
      drbd: Fix for a race between IO and a detach operation [Bugz 262]
      drbd: Silenced an assert that could triggered after changing write ordering method
      drbd: Allow online resizing of DRBD devices while peer not reachable (needs to be explicitly forced)
      drbd: The kernel code is now equivalent to out of tree release 8.3.7

Stephen Hemminger (1):
      genhd: overlapping variable definition

Thiago Farina (1):
      fs/bio.c: fix shadows sparse warning

 block/blk-ioc.c                    |    5 ----
 block/blk-settings.c               |   39 +++++++++++++++++++++++++++---
 block/cfq-iosched.c                |    6 ++++
 block/genhd.c                      |    2 +-
 drivers/block/drbd/Kconfig         |    2 +-
 drivers/block/drbd/drbd_int.h      |    7 ++---
 drivers/block/drbd/drbd_main.c     |    1 +
 drivers/block/drbd/drbd_nl.c       |   19 +++++++++-----
 drivers/block/drbd/drbd_receiver.c |   46 +++++++++++++++++++++++------------
 drivers/md/dm-table.c              |   20 ++++-----------
 fs/bio.c                           |    2 +-
 include/linux/blkdev.h             |    9 +++++-
 include/linux/drbd.h               |    2 +-
 include/linux/drbd_nl.h            |    1 +
 include/linux/genhd.h              |    6 ++--
 include/linux/iocontext.h          |   27 ---------------------
 16 files changed, 107 insertions(+), 87 deletions(-)

-- 
Jens Axboe

