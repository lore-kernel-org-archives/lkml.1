Return-Path: <linux-kernel-owner+w=401wt.eu-S1758396AbZCWImB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396AbZCWImB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757648AbZCWIlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:41:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60792
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757482AbZCWIlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:41:07 -0400
Date: Mon, 23 Mar 2009 01:40:54 -0700 (PDT)
Message-Id: <20090323.014054.210962886.davem@davemloft.net>
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

The following changes since commit 65c24491b4fef017c64e39ec64384fde5e05e0a0:
  Jeff Moyer (1):
        aio: lookup_ioctx can return the wrong value when looking up a bogus context

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (2):
      sparc64: Reschedule KGDB capture to a software interrupt.
      Merge branch 'master' of /home/davem/src/GIT/linux-2.6/

Mikulas Patocka (1):
      sparc64: Fix crash with /proc/iomem

Scott James Remnant (1):
      sbus: Auto-load openprom module when device opened.

 arch/sparc/include/asm/pil.h   |    1 +
 arch/sparc/kernel/kgdb_64.c    |    2 +-
 arch/sparc/kernel/pci_common.c |    2 +-
 arch/sparc/kernel/ttable.S     |    7 ++++++-
 arch/sparc/mm/ultra.S          |   24 ++----------------------
 drivers/sbus/char/openprom.c   |    1 +
 6 files changed, 12 insertions(+), 25 deletions(-)
