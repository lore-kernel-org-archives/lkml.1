Return-Path: <linux-kernel-owner+w=401wt.eu-S933909AbZJIRJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933909AbZJIRJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 13:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756622AbZJIRJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 13:09:25 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:4665 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009AbZJIRJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 13:09:24 -0400
Authentication-Results: sj-iport-2.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAEcLz0qrR7Hu/2dsb2JhbADDD5hIhCwEgVho
X-IronPort-AV: E=Sophos;i="4.44,533,1249257600"; 
   d="scan'208";a="213084968"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Fri, 09 Oct 2009 10:08:46 -0700
Message-ID: <adaskdsjy01.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Oct 2009 17:08:47.0612 (UTC) FILETIME=[2A411BC0:01CA4903]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get another small batch of small RDMA/InfiniBand fixes, and
one device ID addition:

Bart Van Assche (1):
      IB: Fix typo in udev rule documentation

David J. Wilder (1):
      RDMA/addr: Fix resolution of local IPv6 addresses

Roland Dreier (1):
      Merge branches 'cxgb3', 'misc' and 'mlx4' into for-next

Steve Wise (2):
      RDMA/iwcm: Don't call provider reject func with irqs disabled
      RDMA/cxgb3: Handle NULL inetdev pointer in iwch_query_port()

Yevgeny Petrilin (1):
      mlx4_core: Add 40GigE device ID

 Documentation/infiniband/user_mad.txt       |    4 ++--
 Documentation/infiniband/user_verbs.txt     |    2 +-
 drivers/infiniband/core/addr.c              |    2 +-
 drivers/infiniband/core/iwcm.c              |    2 ++
 drivers/infiniband/hw/cxgb3/iwch_provider.c |   11 +++++++----
 drivers/net/mlx4/main.c                     |    1 +
 6 files changed, 14 insertions(+), 8 deletions(-)
