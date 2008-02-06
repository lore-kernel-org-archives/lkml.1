Return-Path: <linux-kernel-owner+w=401wt.eu-S1760785AbYBFCw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760785AbYBFCw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 21:52:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbYBFCwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 21:52:49 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:58526 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbYBFCws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 21:52:48 -0500
Date: Tue, 5 Feb 2008 19:52:47 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@osdl.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Pull request: DMA pool updates
Message-ID: <20080206025247.GA7705@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Could I ask you to pull the DMA Pool changes detailed below?

All the patches have been posted to linux-kernel before, and various
comments (and acks) have been taken into account.  (see
http://thread.gmane.org/gmane.linux.kernel/609943)

It's a fairly nice performance improvement, so would be good to get in.
It's survived a few hours of *mumble* high-stress database benchmark,
so I have high confidence in its stability.

The following changes since commit 21511abd0a248a3f225d3b611cfabb93124605a7:
  Linus Torvalds (1):
        Merge branch 'release' of git://git.kernel.org/.../aegl/linux-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/willy/misc.git dmapool

Matthew Wilcox (7):
      Move dmapool.c to mm/ directory
      dmapool: Fix style problems
      Avoid taking waitqueue lock in dmapool
      dmapool: Validate parameters to dma_pool_create
      dmapool: Tidy up includes and add comments
      Change dmapool free block management
      pool: Improve memory usage for devices which can't cross boundaries

 drivers/base/Makefile  |    2 +-
 drivers/base/dmapool.c |  481 ----------------------------------------------
 mm/Makefile            |    1 +
 mm/dmapool.c           |  500 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 502 insertions(+), 482 deletions(-)
 delete mode 100644 drivers/base/dmapool.c
 create mode 100644 mm/dmapool.c

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
