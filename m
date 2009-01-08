Return-Path: <linux-kernel-owner+w=401wt.eu-S1757942AbZAHBTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942AbZAHBTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 20:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbZAHBTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 20:19:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47566
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754916AbZAHBTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 20:19:05 -0500
Date: Wed, 07 Jan 2009 17:19:07 -0800 (PST)
Message-Id: <20090107.171907.12026879.davem@davemloft.net>
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


The most noteworthy thing in here is the conversion
of sparc64 to use "unsigned long long" for it's u64
type.

Other than that we have a few cleanups that try to
prevent spurious warnings on sparc64 when the branch
tracer is enabled with gcc-3.4.x

Please pull, thanks!

The following changes since commit 238c6d54830c624f34ac9cf123ac04aebfca5013:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../agk/linux-2.6-dm

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (1):
      sparc64: Work around branch tracer warning.

Sam Ravnborg (5):
      sparc64: refactor code in viohs.c
      sparc64: refactor code in init_64.c
      sparc: refactor code in fault_32.c
      sparc64: Use unsigned long long for u64.
      sparc64: Fix unsigned long long warnings in drivers.

Steven Rostedt (1):
      sparc: make proces_ver_nack a bit more readable

 arch/sparc/include/asm/timer_64.h |    2 +-
 arch/sparc/include/asm/types.h    |    2 +-
 arch/sparc/kernel/ds.c            |   34 +++++++++++++-------------
 arch/sparc/kernel/iommu.c         |    2 +-
 arch/sparc/kernel/ldc.c           |   23 +++++++++--------
 arch/sparc/kernel/mdesc.c         |   14 +++++-----
 arch/sparc/kernel/of_device_64.c  |    2 +-
 arch/sparc/kernel/pci.c           |    2 +-
 arch/sparc/kernel/pci_common.c    |    2 +-
 arch/sparc/kernel/pci_msi.c       |    4 +-
 arch/sparc/kernel/pci_schizo.c    |    2 +-
 arch/sparc/kernel/pci_sun4v.c     |    2 +-
 arch/sparc/kernel/power.c         |    2 +-
 arch/sparc/kernel/prom_irqtrans.c |    2 +-
 arch/sparc/kernel/psycho_common.c |   14 +++++-----
 arch/sparc/kernel/smp_64.c        |    4 +-
 arch/sparc/kernel/time_64.c       |   12 ++++----
 arch/sparc/kernel/traps_64.c      |   20 +++++++-------
 arch/sparc/kernel/unaligned_64.c  |    8 ++++-
 arch/sparc/kernel/vio.c           |    4 +-
 arch/sparc/kernel/viohs.c         |    6 +++-
 arch/sparc/mm/fault_32.c          |    3 +-
 arch/sparc/mm/init_64.c           |   48 ++++++++++++++++++++++--------------
 drivers/block/sunvdc.c            |    8 +++---
 drivers/char/hw_random/n2-drv.c   |    2 +-
 drivers/net/sunvnet.c             |    8 +++---
 drivers/sbus/char/display7seg.c   |    2 +-
 sound/sparc/cs4231.c              |    2 +-
 28 files changed, 127 insertions(+), 109 deletions(-)

