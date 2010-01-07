Return-Path: <linux-kernel-owner+w=401wt.eu-S1753784Ab0AGTa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab0AGTa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 14:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628Ab0AGTa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 14:30:28 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:41050 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab0AGTa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 14:30:27 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAMrERUurR7Hu/2dsb2JhbADAf5QOhDAE
X-IronPort-AV: E=Sophos;i="4.49,236,1262563200"; 
   d="scan'208";a="463223834"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Thu, 07 Jan 2010 11:30:25 -0800
Message-ID: <adafx6hr9v2.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 Jan 2010 19:30:25.0979 (UTC) FILETIME=[DCDA80B0:01CA8FCF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a few very small fixes that have trickled in over the
holidays.

Eli Cohen (1):
      mlx4_core: Fix cleanup in __mlx4_init_one() error path

Jack Morgenstein (1):
      IB/mlx4: Initialize SRQ scatter entries when creating an SRQ

Or Gerlitz (1):
      IB/mlx4: Fix queue overflow check in post_recv

Robert P. J. Day (1):
      IB/addr: Correct CONFIG_IPv6 to CONFIG_IPV6

Roland Dreier (1):
      Merge branches 'misc' and 'mlx4' into for-next

 drivers/infiniband/core/cma.c    |    2 +-
 drivers/infiniband/hw/mlx4/qp.c  |    2 +-
 drivers/infiniband/hw/mlx4/srq.c |    6 ++++++
 drivers/net/mlx4/main.c          |    2 +-
 4 files changed, 9 insertions(+), 3 deletions(-)
