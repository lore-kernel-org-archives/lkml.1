Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab0BATgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 14:36:44 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:55329 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755775Ab0BATgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 14:36:43 -0500
Date: Mon, 1 Feb 2010 20:36:41 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block bug fixes for 2.6.33-rc6
Message-ID: <20100201193641.GU13771@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A few critical fixes that should go into 2.6.33 final. Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Chuck Ebbert (1):
      block: fix bugs in bio-integrity mempool usage

Dan Carpenter (1):
      drbd: null dereference bug

Dmitry Monakhov (1):
      block: fix bio_add_page for non trivial merge_bvec_fn case

Gui Jianfeng (1):
      blk-cgroup: Fix potential deadlock in blk-cgroup

Jens Axboe (1):
      Merge branch 'for-jens' of git://git.drbd.org/linux-2.6-drbd into for-linus

Lars Ellenberg (1):
      drbd: fix max_segment_size initialization

 block/blk-cgroup.c                 |    4 ++--
 drivers/block/drbd/drbd_main.c     |    2 +-
 drivers/block/drbd/drbd_receiver.c |    2 +-
 fs/bio-integrity.c                 |    3 ++-
 fs/bio.c                           |    7 ++++++-
 5 files changed, 12 insertions(+), 6 deletions(-)

-- 
Jens Axboe

