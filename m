Return-Path: <linux-kernel-owner+w=401wt.eu-S1760289AbZLOOEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760289AbZLOOEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 09:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760276AbZLOOEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 09:04:39 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:41811 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760248AbZLOOEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 09:04:38 -0500
Date: Tue, 15 Dec 2009 15:04:37 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block fixes for 2.6.33-rc1
Message-ID: <20091215140437.GJ28252@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Basically some further tweaks and fixes for cfq, init failure fix for
the old xd driver, and a fixup for drbd.

Please pull:

  git://git.kernel.dk/linux-2.6-block.git for-2.6.33

Corrado Zoccolo (2):
      cfq-iosched: reduce write depth only if sync was delayed
      cfq-iosched: commenting non-obvious initialization

Gui Jianfeng (3):
      cfq: Optimization for close cooperating queue searching
      cfq: Remove wait_request flag when idle time is being deleted
      cfq: set workload as expired if it doesn't have any slice left

Mel Gorman (1):
      block,xd: Delay allocation of DMA buffers until device is known

Philipp Reisner (1):
      drbd: Following the hmac change to SHASH (see linux commit 8bd1209cfff)

Vivek Goyal (3):
      cfq-iosched: Get rid of cfqq wait_busy_done flag
      cfq-iosched: Take care of corner cases of group losing share due to deletion
      Fix a CFQ crash in "for-2.6.33" branch of block tree

 block/cfq-iosched.c          |   94 +++++++++++++++++++++++++++++++++--------
 drivers/block/drbd/drbd_nl.c |    3 +-
 drivers/block/xd.c           |   30 ++++++++-----
 3 files changed, 95 insertions(+), 32 deletions(-)

-- 
Jens Axboe

