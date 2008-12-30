Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbYL3Xiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbYL3Xiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 18:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbYL3Xip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 18:38:45 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:20254 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbYL3Xio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 18:38:44 -0500
X-IronPort-AV: E=Sophos;i="4.36,304,1228089600"; 
   d="scan'208";a="221681526"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Tue, 30 Dec 2008 15:38:43 -0800
Message-ID: <adavdt1qlmk.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Dec 2008 23:38:43.0863 (UTC) FILETIME=[C09A7270:01C96AD7]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

A build fix and an endianness bug fix before the new year:

Roland Dreier (3):
      RDMA/addr: Fix build breakage when IPv6 is disabled
      IB/mlx4: Fix reading SL field out of cqe->sl_vid
      Merge branches 'cma' and 'mlx4' into for-linus

 drivers/infiniband/Kconfig      |    1 +
 drivers/infiniband/core/addr.c  |   47 +++++++++++++++++++++++++++++++++-----
 drivers/infiniband/hw/mlx4/cq.c |    2 +-
 3 files changed, 42 insertions(+), 8 deletions(-)
