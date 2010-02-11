Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab0BKTbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 14:31:31 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:54078 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756843Ab0BKTba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 14:31:30 -0500
Date: Thu, 11 Feb 2010 20:31:28 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] final two block patches for 2.6.33
Message-ID: <20100211193128.GV1025@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Two things:

- Fix an oops in cciss
- Fix for a CFQ performance regression. This is a little larger than I
  would have liked, but it's well tested and also well reviewed by
  several people involved.

So please pull.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Shaohua Li (1):
      cfq-iosched: split seeky coop queues after one slice

Stephen M. Cameron (1):
      cciss: Make cciss_seq_show handle holes in the h->drv[] array

 block/cfq-iosched.c   |   49 ++++++++++++++++---------------------------------
 drivers/block/cciss.c |    3 +++
 2 files changed, 19 insertions(+), 33 deletions(-)

-- 
Jens Axboe

