Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbYGAHGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbYGAHGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 03:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbYGAHF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 03:05:59 -0400
Received: from brick.kernel.dk ([87.55.233.238]:28192 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbYGAHF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 03:05:58 -0400
Date: Tue, 1 Jul 2008 09:05:56 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, stable@kernel.org,
       dpshah@google.com, nickpiggin@yahoo.com.au
Subject: [GIT PULL] block stuff for 2.6.26
Message-ID: <20080701070556.GW20826@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Two bits that should go into 2.6.26 final.

  git://git.kernel.dk/linux-2.6-block.git for-2.6.26

Divyesh Shah (1):
      block: Fix the starving writes bug in the anticipatory IO scheduler

Jens Axboe (1):
      Properly notify block layer of sync writes

 block/as-iosched.c |    2 ++
 fs/buffer.c        |   13 ++++++++-----
 include/linux/fs.h |    1 +
 3 files changed, 11 insertions(+), 5 deletions(-)

-- 
Jens Axboe

