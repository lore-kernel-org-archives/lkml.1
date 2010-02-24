Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab0BXOMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 09:12:52 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:33314 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755991Ab0BXOMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 09:12:51 -0500
Date: Wed, 24 Feb 2010 15:12:49 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, sbenni@gmx.de
Subject: [GIT PULL] block IO regression fix
Message-ID: <20100224141248.GB1025@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This reverts a single commit that has been identified as slowing down
some SSD devices. I'll investigate why that is so, for now (and this
late in the process), we should revert it.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Jens Axboe (1):
      Revert "block: improve queue_should_plug() by looking at IO depths"

 block/blk-core.c       |   11 ++---------
 include/linux/blkdev.h |    4 +---
 2 files changed, 3 insertions(+), 12 deletions(-)

-- 
Jens Axboe

