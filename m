Return-Path: <linux-kernel-owner+w=401wt.eu-S933327AbZHDS6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327AbZHDS6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 14:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933287AbZHDS6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 14:58:51 -0400
Received: from mga07.intel.com ([143.182.124.22]:28642 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933285AbZHDS6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 14:58:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,323,1246863600"; 
   d="scan'208";a="172247267"
Date: Tue, 4 Aug 2009 21:01:02 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       Tony Lindgren <tony@atomide.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT] mfd: bug fix
Message-ID: <20090804190100.GK8601@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I have a twl4030 related bug fix, which can lead to a spinlock lock-up.
It's already on my for-next branch, in case you dont think this is rc6
material.

Here is the pull request, thanks in advance:

The following changes since commit a33a052f19a21d727847391c8c1aff3fb221c472:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://neil.brown.name/md

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-linus

Russell King (1):
      mfd: twl4030 irq fixes

 drivers/mfd/twl4030-irq.c |   55 +++++++++++++++++++-------------------------
 1 files changed, 24 insertions(+), 31 deletions(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
