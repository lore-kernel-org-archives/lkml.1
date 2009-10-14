Return-Path: <linux-kernel-owner+w=401wt.eu-S1760293AbZJNVOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760293AbZJNVOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 17:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760230AbZJNVOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 17:14:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56663
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760180AbZJNVOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 17:14:07 -0400
Date: Wed, 14 Oct 2009 14:14:02 -0700 (PDT)
Message-Id: <20091014.141402.203929406.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get these sparc bug fixes, thanks!

The following changes since commit 36a07902c2134649c4af7f07980413ffb1a56085:
  Linus Torvalds (1):
        Merge branch 'upstream-linus' of git://git.kernel.org/.../jgarzik/libata-dev

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (3):
      sparc64: Fix niagara2 perf IRQ bits.
      sparc64: Fix D-cache flushing on swapin from SW devices.
      sparc64: Set IRQF_DISABLED on LDC channel IRQs.

Thomas Gleixner (1):
      watchdog: Fix rio watchdog probe function

 arch/sparc/kernel/ldc.c        |    4 ++--
 arch/sparc/kernel/perf_event.c |    2 +-
 arch/sparc/mm/init_64.c        |    2 +-
 drivers/watchdog/riowd.c       |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)
