Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbZKCTki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbZKCTki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 14:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbZKCTki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 14:40:38 -0500
Received: from [95.166.99.235] ([95.166.99.235]:47122 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbZKCTkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 14:40:37 -0500
Date: Tue, 3 Nov 2009 20:40:42 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block fixes for 2.6.32-rc
Message-ID: <20091103194042.GH8742@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Two small comment "regressions" from Alberto, which got screwed up
during some of the early .32 block commits. And then a fixup for the
previous sync hang fix, I had modified it slightly after it had been
tested. You should never do that... The last two fixes are for CFQ, both
fixing regressions introduced recently.

Please pull!

  git://git.kernel.dk/linux-2.6-block.git for-linus

Alberto Bertogli (2):
      bio_put(): add bio_clone() to the list of functions in the comment
      Fix bio_alloc() and bio_kmalloc() documentation

Jens Axboe (2):
      backing-dev: bdi sb prune should be in the unregister path, not destroy
      cfq-iosched: fix bad return value cfq_should_preempt()

Shaohua Li (1):
      cfq-iosched: limit coop preemption

 block/cfq-iosched.c |   19 ++++++++++++++++---
 fs/bio.c            |   28 ++++++++++++++--------------
 mm/backing-dev.c    |    3 ++-
 3 files changed, 32 insertions(+), 18 deletions(-)

-- 
Jens Axboe

