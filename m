Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbYHYDkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbYHYDkp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 23:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbYHYDkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 23:40:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41836
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752895AbYHYDke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 23:40:34 -0400
Date: Sun, 24 Aug 2008 20:40:30 -0700 (PDT)
Message-Id: <20080824.204030.193703137.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get these two sparc changes:

1) NUMA needs to depend upon SMP

2) 32-bit sparc needs a stripped kernel target so that
   the pkg-* targets work, from Martin Habets.

Thanks a lot!

The following changes since commit 83097aca8567a0bd593534853b71fe0fa9a75d69:
  Arjan van de Ven (1):
        Fix oops in acer_wmi driver (acer_wmi_init)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (1):
      sparc64: Make NUMA depend upon SMP.

Martin Habets (1):
      sparc: Add target for a stripped kernel

 arch/sparc/Makefile      |    8 ++++++--
 arch/sparc/boot/Makefile |    6 ++++++
 arch/sparc64/Kconfig     |    1 +
 3 files changed, 13 insertions(+), 2 deletions(-)
