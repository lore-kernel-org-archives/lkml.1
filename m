Return-Path: <linux-kernel-owner+w=401wt.eu-S1757552AbZFZH3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbZFZH3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 03:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbZFZH3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 03:29:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43435
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751839AbZFZH3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 03:29:02 -0400
Date: Fri, 26 Jun 2009 00:29:06 -0700 (PDT)
Message-Id: <20090626.002906.170515979.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc fixes
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) Moving kmalloc initialization earlier created some bootup
   warnings on sparc64, fix.

2) The sparc port merge caused various regressions in the less
   used boot Makefile targets, only noticed recently.  Fixed by
   Sam Ravnborg, Robert Reif, and Julian Calaby who pulled all of
   these fixed together.

Please pull, thanks a lot!

The following changes since commit 28d0325ce6e0a52f53d8af687e6427fee59004d3:
  Linus Torvalds (1):
        Linux 2.6.31-rc1

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (1):
      sparc64: Don't use alloc_bootmem() in init_IRQ() code paths.

Julian Calaby (3):
      sparc64: Fix build warnings in piggyback_64.c
      sparc32: Fix tftpboot.img Makefile
      sparc32: Fix makefile not generating required files

Robert Reif (1):
      sparc32: Fix obvious build issues for tftpboot.img build.

Sam Ravnborg (1):
      sparc: fix tftpboot.img build

 arch/sparc/boot/Makefile       |    6 ++--
 arch/sparc/boot/piggyback_32.c |    4 +-
 arch/sparc/boot/piggyback_64.c |    1 +
 arch/sparc/kernel/irq_64.c     |   45 ++++++++++++++++-----------------------
 4 files changed, 25 insertions(+), 31 deletions(-)
