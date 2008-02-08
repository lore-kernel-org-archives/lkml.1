Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbYBHXRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbYBHXRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 18:17:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbYBHXQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 18:16:56 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:12894 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbYBHXQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 18:16:55 -0500
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 08 Feb 2008 15:16:53 -0800
Message-ID: <adafxw36ntm.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Feb 2008 23:16:53.0910 (UTC) FILETIME=[B124FB60:01C86AA8]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get the last batch of InfiniBand/RDMA merges for 2.6.25,
mostly preparation for enabling stateless offloads for IP-over-InfiniBand.

Eli Cohen (3):
      IPoIB: Add high DMA feature flag
      IPoIB: Add send gather support
      IB/core: Add IP checksum offload support

Jack Morgenstein (2):
      mlx4_core: For 64-bit systems, vmap() kernel queue buffers
      IB/mlx4: Use multiple WQ blocks to post smaller send WQEs

Roland Dreier (3):
      IB/mlx4: Consolidate code to get an entry from a struct mlx4_buf
      mlx4_core: Clean up struct mlx4_buf
      IB/core: Remove unused struct ib_device.flags member

 drivers/infiniband/hw/mlx4/cq.c            |   20 ++--
 drivers/infiniband/hw/mlx4/mlx4_ib.h       |    2 +
 drivers/infiniband/hw/mlx4/qp.c            |  216 +++++++++++++++++++++++-----
 drivers/infiniband/hw/mlx4/srq.c           |    8 +-
 drivers/infiniband/ulp/ipoib/ipoib.h       |    4 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c    |   10 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c    |   89 +++++++++---
 drivers/infiniband/ulp/ipoib/ipoib_main.c  |    4 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c |   10 +-
 drivers/net/mlx4/alloc.c                   |   48 ++++--
 drivers/net/mlx4/mr.c                      |    4 +-
 include/linux/mlx4/device.h                |   19 ++-
 include/linux/mlx4/qp.h                    |    4 +
 include/rdma/ib_verbs.h                    |   16 ++-
 14 files changed, 342 insertions(+), 112 deletions(-)
