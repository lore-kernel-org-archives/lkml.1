Return-Path: <linux-kernel-owner+w=401wt.eu-S1760767AbXGUE4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760767AbXGUE4b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 00:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbXGUE4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 00:56:22 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:25666 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbXGUE4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 00:56:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAI4uoUarR7MV/2dsb2JhbAA
X-IronPort-AV: i="4.16,565,1175497200"; 
   d="scan'208"; a="186023487:sNHT26914230"
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 20 Jul 2007 21:56:20 -0700
Message-ID: <ada4pjy4aob.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Jul 2007 04:56:20.0581 (UTC) FILETIME=[7AC51950:01C7CB53]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get another small batch of changes for 2.6.23:

Arthur Jones (1):
      IB/ipath: Remove ipath_layer dead code

Florin Malita (1):
      IB/mlx4: Fix leaks in __mlx4_ib_modify_qp

Hoang-Nam Nguyen (3):
      IB/ehca: Support large page MRs
      IB/ehca: Generate async event when SRQ limit reached
      IB/ehca: Move ehca2ib_return_code() out of line

Joachim Fenkes (1):
      IB/ehca: Make internal_create/destroy_qp() static

Michael S. Tsirkin (1):
      IB/mthca: Change command token on timeout

Roland Dreier (2):
      mlx4_core: Change command token on timeout
      IB/mlx4: Fix error path in create_qp_common()

Stefan Roscher (1):
      IB/ehca: Support small QP queues

 drivers/infiniband/hw/ehca/ehca_classes.h |   50 +++--
 drivers/infiniband/hw/ehca/ehca_cq.c      |    8 +-
 drivers/infiniband/hw/ehca/ehca_eq.c      |    8 +-
 drivers/infiniband/hw/ehca/ehca_irq.c     |   42 +++-
 drivers/infiniband/hw/ehca/ehca_main.c    |   49 ++++-
 drivers/infiniband/hw/ehca/ehca_mrmw.c    |  371 ++++++++++++++++++++++++-----
 drivers/infiniband/hw/ehca/ehca_mrmw.h    |    2 +-
 drivers/infiniband/hw/ehca/ehca_pd.c      |   25 ++-
 drivers/infiniband/hw/ehca/ehca_qp.c      |  178 ++++++++------
 drivers/infiniband/hw/ehca/ehca_tools.h   |   19 +--
 drivers/infiniband/hw/ehca/ehca_uverbs.c  |    2 +-
 drivers/infiniband/hw/ehca/hcp_if.c       |   50 +++-
 drivers/infiniband/hw/ehca/ipz_pt_fn.c    |  222 +++++++++++++----
 drivers/infiniband/hw/ehca/ipz_pt_fn.h    |   26 ++-
 drivers/infiniband/hw/ipath/Makefile      |    1 -
 drivers/infiniband/hw/ipath/ipath_layer.c |  365 ----------------------------
 drivers/infiniband/hw/ipath/ipath_layer.h |   71 ------
 drivers/infiniband/hw/ipath/ipath_verbs.h |    2 -
 drivers/infiniband/hw/mlx4/qp.c           |   20 +-
 drivers/infiniband/hw/mthca/mthca_cmd.c   |    3 +-
 drivers/net/mlx4/cmd.c                    |    3 +-
 21 files changed, 802 insertions(+), 715 deletions(-)
 delete mode 100644 drivers/infiniband/hw/ipath/ipath_layer.c
 delete mode 100644 drivers/infiniband/hw/ipath/ipath_layer.h
