Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbYH3UBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbYH3UBc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 16:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbYH3UBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 16:01:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59214
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754206AbYH3UBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 16:01:06 -0400
Date: Sat, 30 Aug 2008 13:01:01 -0700 (PDT)
Message-Id: <20080830.130101.155904510.davem@davemloft.net>
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


Three Sparc bug fixes:

1) CONFIG_RELAY recently started using smp_call_function_single()
   even though that was not previously referenced from generic
   code.

   Anyways, add an implementation to 32-bit sparc to fix the
   build with RELAY enabled.

2) Resource flag setting fix for PCI sub-devices.

3) Section mismatch fix in sparc64 MM initialization code.

Please pull, thanks a lot!

The following changes since commit 349101da8e1f8e5eb1476b02823da80495224485:
  Martin Habets (1):
        sparc: Add target for a stripped kernel

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (3):
      sparc32: Implement smp_call_function_single().
      sparc: Fix resource flags for PCI children in OF device tree.
      sparc64: setup_valid_addr_bitmap_from_pavail() should be __init

 arch/sparc/include/asm/smp_32.h |   25 +++++++++++++++----------
 arch/sparc/kernel/of_device.c   |   19 ++++++++++++++-----
 arch/sparc/kernel/sun4d_smp.c   |   16 ++++++++++------
 arch/sparc/kernel/sun4m_smp.c   |   12 ++++++++----
 arch/sparc64/kernel/of_device.c |   20 ++++++++++++++------
 arch/sparc64/mm/init.c          |    2 +-
 6 files changed, 62 insertions(+), 32 deletions(-)
