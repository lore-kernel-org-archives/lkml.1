Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbZIXTpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbZIXTpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 15:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbZIXTpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 15:45:11 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:52361 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbZIXTpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 15:45:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAN9ou0qrR7O6/2dsb2JhbAC/EohTAZALBYQcgV0
X-IronPort-AV: E=Sophos;i="4.44,446,1249257600"; 
   d="scan'208";a="395487484"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
       general@lists.openfabrics.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Thu, 24 Sep 2009 12:45:12 -0700
Message-ID: <ada7hvo160n.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Sep 2009 19:45:12.0838 (UTC) FILETIME=[8816B260:01CA3D4F]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get the batch of RDMA/InfiniBand changes for the 2.6.32
merge window:

The following changes since commit 86d710146fb9975f04c505ec78caa43d227c1018:
  Linus Torvalds (1):
        Merge git://git.linux-nfs.org/projects/trondmy/nfs-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

Eli Cohen (1):
      mlx4_core: Pass cache line size to device FW

Jack Morgenstein (1):
      IB/mthca: Fix access to freed memory in catastrophic event handling

Julia Lawall (1):
      RDMA/nes: Remove duplicate .ndo_set_mac_address field initialization

Moni Shoua (1):
      IPoIB: Don't turn on carrier for a non-active port

Roland Dreier (2):
      IB/mad: Fix lock-lock-timer deadlock in RMPP code
      Merge branches 'ipoib', 'mad', 'mlx4', 'mthca' and 'nes' into for-linus

 drivers/infiniband/core/mad_rmpp.c             |   17 +++++++++++++----
 drivers/infiniband/hw/mthca/mthca_catas.c      |   11 ++++++++---
 drivers/infiniband/hw/nes/nes_nic.c            |    1 -
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    7 +++++++
 drivers/net/mlx4/fw.c                          |    5 +++++
 5 files changed, 33 insertions(+), 8 deletions(-)
