Return-Path: <linux-kernel-owner+w=401wt.eu-S1752211AbXBEKP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbXBEKP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 05:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbXBEKP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 05:15:28 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:15889 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbXBEKP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 05:15:27 -0500
X-IronPort-AV: i="4.13,282,1167638400"; 
   d="scan'208"; a="109020327:sNHT49700079"
To: torvalds@linux-foundation.org
Cc: openib-general@openib.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 05 Feb 2007 02:15:25 -0800
Message-ID: <ada1wl4x64i.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 05 Feb 2007 10:15:25.0785 (UTC) FILETIME=[8DA0E490:01C7490E]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This is my first merge for 2.6.21:

Hoang-Nam Nguyen (2):
      IB/ehca: Remove use of do_mmap()
      IB/ehca: Remove obsolete prototypes

Ishai Rabinovitz (1):
      IB/srp: Don't wait for response when QP is in error state.

Jason Gunthorpe (1):
      IB: Make sure struct ib_user_mad.data is aligned

Michael S. Tsirkin (2):
      IB: Include <linux/kref.h> explicitly in <rdma/ib_verbs.h>
      IB: Return qp pointer as part of ib_wc

Steve Wise (1):
      RDMA/addr: Handle ethernet neighbour updates during route resolution

 drivers/infiniband/core/addr.c            |    3 +-
 drivers/infiniband/core/mad.c             |   11 +-
 drivers/infiniband/core/uverbs_cmd.c      |    2 +-
 drivers/infiniband/hw/amso1100/c2_cq.c    |    2 +-
 drivers/infiniband/hw/ehca/ehca_classes.h |   29 +--
 drivers/infiniband/hw/ehca/ehca_cq.c      |   65 ++----
 drivers/infiniband/hw/ehca/ehca_iverbs.h  |    8 -
 drivers/infiniband/hw/ehca/ehca_main.c    |    6 +-
 drivers/infiniband/hw/ehca/ehca_qp.c      |   78 +-----
 drivers/infiniband/hw/ehca/ehca_reqs.c    |    2 +-
 drivers/infiniband/hw/ehca/ehca_uverbs.c  |  395 ++++++++++++-----------------
 drivers/infiniband/hw/ipath/ipath_qp.c    |    2 +-
 drivers/infiniband/hw/ipath/ipath_rc.c    |    8 +-
 drivers/infiniband/hw/ipath/ipath_ruc.c   |    8 +-
 drivers/infiniband/hw/ipath/ipath_uc.c    |    4 +-
 drivers/infiniband/hw/ipath/ipath_ud.c    |    8 +-
 drivers/infiniband/hw/mthca/mthca_cmd.c   |    2 +-
 drivers/infiniband/hw/mthca/mthca_cq.c    |    2 +-
 drivers/infiniband/ulp/srp/ib_srp.c       |    7 +
 drivers/infiniband/ulp/srp/ib_srp.h       |    1 +
 include/rdma/ib_user_mad.h                |    2 +-
 include/rdma/ib_verbs.h                   |    3 +-
 22 files changed, 243 insertions(+), 405 deletions(-)
