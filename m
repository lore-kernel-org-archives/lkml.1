Return-Path: <linux-kernel-owner+w=401wt.eu-S1757764AbYGZVCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764AbYGZVCW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 17:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757240AbYGZVCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 17:02:15 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:28016 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189AbYGZVCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 17:02:14 -0400
X-IronPort-AV: E=Sophos;i="4.31,257,1215388800"; 
   d="scan'208";a="69406118"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Sat, 26 Jul 2008 14:02:11 -0700
Message-ID: <ada7ib87418.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Jul 2008 21:02:11.0471 (UTC) FILETIME=[DF7269F0:01C8EF62]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get the some last RDMA/InfiniBand changes for 2.6.27.  The
only major thing is changes to the iw_nes connection setup handling,
which fix problems with lots of connections:

Faisal Latif (1):
      RDMA/nes: CM connection setup/teardown rework

Jack Morgenstein (1):
      mlx4: Update/add Mellanox Technologies copyright lines to mlx4 driver files

Roland Dreier (5):
      RDMA/ucma: BKL is not needed for ucma_open()
      RDMA/ucm: BKL is not needed for ib_ucm_open()
      IPoIB/cm: Connected mode is no longer EXPERIMENTAL
      IPoIB: Correct help text for INFINIBAND_IPOIB_DEBUG
      Merge branches 'bkl-removal', 'ipoib', 'mlx4' and 'nes' into for-linus

Yevgeny Petrilin (1):
      mlx4_core: Add VLAN tag field to WQE control segment struct

 drivers/infiniband/core/ucm.c         |   10 +-
 drivers/infiniband/core/ucma.c        |   11 +-
 drivers/infiniband/hw/mlx4/cq.c       |    1 +
 drivers/infiniband/hw/mlx4/main.c     |    1 +
 drivers/infiniband/hw/mlx4/mlx4_ib.h  |    1 +
 drivers/infiniband/hw/mlx4/mr.c       |    1 +
 drivers/infiniband/hw/mlx4/qp.c       |    1 +
 drivers/infiniband/hw/mlx4/srq.c      |    1 +
 drivers/infiniband/hw/mlx4/user.h     |    1 +
 drivers/infiniband/hw/nes/nes.c       |    4 +-
 drivers/infiniband/hw/nes/nes_cm.c    | 2034 ++++++++++++++++++---------------
 drivers/infiniband/hw/nes/nes_cm.h    |   23 +-
 drivers/infiniband/hw/nes/nes_hw.c    |    9 -
 drivers/infiniband/hw/nes/nes_verbs.c |   15 -
 drivers/infiniband/ulp/ipoib/Kconfig  |   22 +-
 drivers/net/mlx4/alloc.c              |    1 +
 drivers/net/mlx4/catas.c              |    1 +
 drivers/net/mlx4/cmd.c                |    2 +-
 drivers/net/mlx4/cq.c                 |    2 +-
 drivers/net/mlx4/eq.c                 |    2 +-
 drivers/net/mlx4/fw.c                 |    2 +-
 drivers/net/mlx4/fw.h                 |    2 +-
 drivers/net/mlx4/icm.c                |    2 +-
 drivers/net/mlx4/icm.h                |    2 +-
 drivers/net/mlx4/intf.c               |    1 +
 drivers/net/mlx4/main.c               |    2 +-
 drivers/net/mlx4/mcg.c                |    1 +
 drivers/net/mlx4/mlx4.h               |    2 +-
 drivers/net/mlx4/mr.c                 |    2 +-
 drivers/net/mlx4/qp.c                 |    2 +-
 drivers/net/mlx4/reset.c              |    1 +
 drivers/net/mlx4/srq.c                |    1 +
 include/linux/mlx4/qp.h               |    4 +-
 33 files changed, 1211 insertions(+), 956 deletions(-)
