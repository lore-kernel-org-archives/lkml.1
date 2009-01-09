Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbZAIQEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbZAIQEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 11:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbZAIQEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 11:04:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:51498 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbZAIQED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 11:04:03 -0500
Date: Fri, 9 Jan 2009 16:03:40 +0000
From: Kyle McMartin <kyle@hera.kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [git patches] parisc patches for v2.6.29
Message-ID: <20090109160340.GA12065@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 09 Jan 2009 16:03:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit fe0bdec68b77020281dc814805edfe594ae89e0f:
  Linus Torvalds (1):
        Merge branch 'audit.b61' of git://git.kernel.org/.../viro/audit-current

are available in the git repository at:

  /pub/scm/linux/kernel/git/kyle/parisc-2.6.git master

Adrian Bunk (2):
      parisc: lib/: make code static
      parisc: drivers/parisc/: make code static

FUJITA Tomonori (1):
      parisc: remove dead BIO_VMERGE_BOUNDARY and BIO_VMERGE_MAX_SIZE definitions

Harvey Harrison (1):
      parisc: use the new byteorder headers

Helge Deller (4):
      parisc: fix GFP_KERNEL use while atomic in unwinder
      parisc: trivial fixes
      parisc: Replace NR_CPUS in parisc code
      parisc: add uevent helper for parisc bus

Julia Lawall (1):
      parisc: Use DEFINE_SPINLOCK

Kyle McMartin (7):
      parisc: use leX_to_cpu in place of __fswabX
      parisc: factor out sid to protid conversion
      parisc: fix braino in commit adding __space_to_prot
      parisc: quiet palo not-found message from "which"
      parisc: fix ipv6 checksum
      parisc: fix kernel crash (protection id trap) when compiling ruby1.9
      parisc: export length of os_hpmc vector

Roel Kluin (1):
      parisc: set_time() catch errors

 arch/parisc/Makefile                  |    2 +-
 arch/parisc/include/asm/byteorder.h   |   37 ++++++------------
 arch/parisc/include/asm/checksum.h    |    2 +-
 arch/parisc/include/asm/io.h          |   12 +----
 arch/parisc/include/asm/mmu_context.h |   13 ++++--
 arch/parisc/include/asm/processor.h   |    4 +-
 arch/parisc/include/asm/uaccess.h     |    2 +
 arch/parisc/kernel/drivers.c          |   40 ++++++++++++++++---
 arch/parisc/kernel/hpmc.S             |    8 +++-
 arch/parisc/kernel/irq.c              |   11 +++--
 arch/parisc/kernel/pdc_cons.c         |    2 +-
 arch/parisc/kernel/perf.c             |    4 +-
 arch/parisc/kernel/processor.c        |   68 +++++++++++++++++----------------
 arch/parisc/kernel/setup.c            |   11 +----
 arch/parisc/kernel/smp.c              |   32 +++++++--------
 arch/parisc/kernel/time.c             |    4 +-
 arch/parisc/kernel/topology.c         |    4 +-
 arch/parisc/kernel/traps.c            |    9 +++-
 arch/parisc/kernel/unwind.c           |    2 +-
 arch/parisc/lib/iomap.c               |    2 +-
 arch/parisc/lib/memcpy.c              |    2 +-
 arch/parisc/mm/fault.c                |   58 +++++++++++++++-------------
 drivers/parisc/asp.c                  |    3 +-
 drivers/parisc/ccio-dma.c             |    4 +-
 drivers/parisc/dino.c                 |    4 +-
 drivers/parisc/hppb.c                 |    2 +-
 drivers/parisc/lasi.c                 |    5 +-
 drivers/parisc/lba_pci.c              |    2 +-
 drivers/parisc/sba_iommu.c            |    9 +---
 drivers/parisc/wax.c                  |    3 +-
 drivers/rtc/rtc-parisc.c              |    3 +-
 31 files changed, 191 insertions(+), 173 deletions(-)
