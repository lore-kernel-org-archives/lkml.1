Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbZDPLNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbZDPLNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 07:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbZDPLNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 07:13:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41211
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753248AbZDPLNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 07:13:05 -0400
Date: Thu, 16 Apr 2009 04:12:56 -0700 (PDT)
Message-Id: <20090416.041256.120784220.davem@davemloft.net>
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


Please pull to get these Sparc updates.

Thanks!

The following changes since commit 3ee8da87ba6151ec91b2b8bbd27633bb248ea0d5:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../tiwai/sound-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (1):
      sparc64: Fix smp_callin() locking.

Stephen Rothwell (1):
      sparc: asm/atomic.h on 32bit should include asm/system.h for xchg

Stoyan Gaydarov (1):
      sbus: changed ioctls to unlocked

Wei Yongjun (1):
      sparc: remove some pointless conditionals before kfree()

 arch/sparc/include/asm/atomic_32.h |    2 ++
 arch/sparc/kernel/ldc.c            |    6 ++----
 arch/sparc/kernel/smp_64.c         |    4 ++--
 drivers/sbus/char/jsflash.c        |   15 ++++++++++-----
 drivers/sbus/char/uctrl.c          |    7 +++----
 5 files changed, 19 insertions(+), 15 deletions(-)
