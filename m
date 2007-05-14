Return-Path: <linux-kernel-owner+w=401wt.eu-S1756659AbXENVSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbXENVSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 17:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbXENVSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 17:18:04 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:22738 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbXENVSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 17:18:03 -0400
X-IronPort-AV: i="4.14,532,1170662400"; 
   d="scan'208"; a="485723877:sNHT50132260"
To: torvalds@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 14 May 2007 14:18:00 -0700
Message-ID: <ada4pmfumt3.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 May 2007 21:18:00.0915 (UTC) FILETIME=[5A03D230:01C7966D]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get the following post 2.6.22-rc1 fixes:

Arthur Jones (1):
      IB/ipath: Shadow the gpio_mask register

Hoang-Nam Nguyen (1):
      IB/ehca: Fix AQP0/1 QP number

Jack Morgenstein (1):
      IB/mlx4: Fix uninitialized spinlock for 32-bit archs

Joachim Fenkes (4):
      IB/ehca: Correctly set GRH mask bit in ehca_modify_qp()
      IB/ehca: Remove _irqsave, move #ifdef
      IB/ehca: Beautify sysfs attribute code and fix compiler warnings
      IB/ehca: Disable scaling code by default, bump version number

Michael S. Tsirkin (3):
      IB/mthca: Fix posting >255 recv WRs for Tavor
      IB/mthca: Set cleaned CQEs back to HW ownership when cleaning CQ
      IPoIB/cm: Optimize stale connection detection

Paul Mundt (1):
      net: Trivial MLX4_DEBUG dependency fix.

Roland Dreier (1):
      mlx4_core: Remove unused doorbell_lock

Sean Hefty (3):
      RDMA/cma: Simplify device removal handling code
      RDMA/cma: Fix synchronization with device removal in cma_iw_handler
      RDMA/cma: Add check to validate that cm_id is bound to a device

Stefan Roscher (1):
      IB/ehca: Serialize hypervisor calls in ehca_register_mr()

 drivers/infiniband/core/cma.c               |  106 +++++++++++++++------------
 drivers/infiniband/hw/ehca/ehca_classes.h   |    1 +
 drivers/infiniband/hw/ehca/ehca_irq.c       |    7 +-
 drivers/infiniband/hw/ehca/ehca_main.c      |   94 +++++++++++-------------
 drivers/infiniband/hw/ehca/ehca_qp.c        |   17 +++--
 drivers/infiniband/hw/ehca/hcp_if.c         |   13 +++-
 drivers/infiniband/hw/ipath/ipath_iba6120.c |    7 +-
 drivers/infiniband/hw/ipath/ipath_intr.c    |    7 +-
 drivers/infiniband/hw/ipath/ipath_kernel.h  |    2 +
 drivers/infiniband/hw/ipath/ipath_verbs.c   |   12 ++--
 drivers/infiniband/hw/mlx4/main.c           |    1 +
 drivers/infiniband/hw/mthca/mthca_cq.c      |    4 +-
 drivers/infiniband/hw/mthca/mthca_qp.c      |    1 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c     |   11 ++-
 drivers/net/Kconfig                         |    1 +
 drivers/net/mlx4/main.c                     |    2 -
 drivers/net/mlx4/mlx4.h                     |    1 -
 17 files changed, 154 insertions(+), 133 deletions(-)
