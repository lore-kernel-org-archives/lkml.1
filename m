Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbZFWRj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbZFWRj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbZFWRjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:39:49 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:27751 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbZFWRjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:39:49 -0400
X-IronPort-AV: E=Sophos;i="4.42,276,1243814400"; 
   d="scan'208";a="82440652"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Tue, 23 Jun 2009 10:39:51 -0700
Message-ID: <adad48uq26w.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Jun 2009 17:39:51.0713 (UTC) FILETIME=[9CBB5910:01C9F429]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This has a few more fixes for 2.6.31-rc1; however everything here
should be a fix appropriate for -rc2 as well, so if this misses the
end of the merge window then I think it should still be OK to pull.

Alexander Schmidt (1):
      IB/ehca: Bump version number

Faisal Latif (2):
      RDMA/nes: Fix max_qp_init_rd_atom returned from query device
      RDMA/nes: Fix FIN state handling under error conditions

Hannes Hering (1):
      IB/ehca: Tolerate dynamic memory operations before driver load

Peter Huewe (1):
      RDMA: Add __init/__exit macros to addr.c and cma.c

Roel Kluin (1):
      IB/ehca: Ensure that guid_entry index is not negative

Roland Dreier (3):
      IB/mthca: Replace dma_sync_single() use with proper functions
      mlx4_core: Fix dma_sync_single_for_cpu() with matching for_device() calls
      Merge branches 'ehca', 'misc', 'mlx4', 'mthca' and 'nes' into for-linus

 drivers/infiniband/core/addr.c         |    4 +-
 drivers/infiniband/core/cma.c          |    4 +-
 drivers/infiniband/hw/ehca/ehca_hca.c  |    2 +-
 drivers/infiniband/hw/ehca/ehca_main.c |   20 +-
 drivers/infiniband/hw/ehca/ehca_mrmw.c |  508 +++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/ehca/ehca_mrmw.h |   13 +-
 drivers/infiniband/hw/mthca/mthca_mr.c |   13 +-
 drivers/infiniband/hw/nes/nes_cm.c     |    8 +-
 drivers/infiniband/hw/nes/nes_verbs.c  |    2 +-
 drivers/net/mlx4/mr.c                  |   14 +-
 10 files changed, 554 insertions(+), 34 deletions(-)
