Return-Path: <linux-kernel-owner+w=401wt.eu-S1756765AbZCLP7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbZCLP7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 11:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbZCLP7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 11:59:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49295
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752866AbZCLP7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 11:59:08 -0400
Date: Thu, 12 Mar 2009 08:58:54 -0700 (PDT)
Message-Id: <20090312.085854.191829621.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get these sparc bug fixes.

Thanks!

The following changes since commit ebdcc81c71937b30e09110c02a1e8a21fa770b6f:
  Linus Torvalds (1):
        Merge branch 'drm-fixes' of git://git.kernel.org/.../airlied/drm-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

Christoph Hellwig (1):
      jsflash: stop defining MAJOR_NR

David S. Miller (1):
      sparc64: Fix lost interrupts on sun4u.

Friedrich Oslage (1):
      sunhme: Fix qfe parent detection.

Roel Kluin (1):
      sparc64: wait_event_interruptible_timeout may return -ERESTARTSYS

 arch/sparc/kernel/irq_64.c  |   29 +++++++++++++++++++----------
 drivers/net/sunhme.c        |    2 --
 drivers/sbus/char/bbc_i2c.c |    2 +-
 drivers/sbus/char/jsflash.c |    3 ---
 4 files changed, 20 insertions(+), 16 deletions(-)
