Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbZDHXI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbZDHXI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 19:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755924AbZDHXIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 19:08:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43670
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754775AbZDHXIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 19:08:21 -0400
Date: Wed, 08 Apr 2009 16:08:11 -0700 (PDT)
Message-Id: <20090408.160811.93427992.davem@davemloft.net>
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


Section mismatch fixes, plus hook up the new preadv/pwritev
system calls.

Please pull, thanks a lot!

The following changes since commit 577c9c456f0e1371cbade38eaf91ae8e8a308555:
  Linus Torvalds (1):
        Linux 2.6.30-rc1

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (7):
      sparc64: get_cells() can't be marked __init
      sparc64: Fix section mismatch warnings in power driver.
      sparc64: Fix section mismatch warnings in PCI controller drivers.
      sparc: Fix section mismatch warnings in cs4231 sound driver.
      serial: sunsu: sunsu_kbd_ms_init needs to be __devinit
      sparc64: add_node_ranges() must be __init
      sparc: Hook up sys_preadv and sys_pwritev

 arch/sparc/include/asm/unistd.h  |    4 +++-
 arch/sparc/kernel/of_device_64.c |    3 +--
 arch/sparc/kernel/pci_fire.c     |    4 ++--
 arch/sparc/kernel/pci_psycho.c   |    8 ++++----
 arch/sparc/kernel/pci_sabre.c    |    8 ++++----
 arch/sparc/kernel/pci_sun4v.c    |   14 +++++++-------
 arch/sparc/kernel/power.c        |    2 +-
 arch/sparc/kernel/systbls_32.S   |    2 +-
 arch/sparc/kernel/systbls_64.S   |    4 ++--
 arch/sparc/mm/init_64.c          |    8 ++++----
 drivers/serial/sunsu.c           |    2 +-
 sound/sparc/cs4231.c             |   28 ++++++++++++++--------------
 12 files changed, 44 insertions(+), 43 deletions(-)
