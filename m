Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab0CLS4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 13:56:34 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:12495 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab0CLS4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 13:56:33 -0500
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAIYdmkurRN+K/2dsb2JhbACaanOjSJhWhHsEgxc
X-IronPort-AV: E=Sophos;i="4.49,627,1262563200"; 
   d="scan'208";a="308249752"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Fri, 12 Mar 2010 10:56:25 -0800
Message-ID: <adar5np9xnq.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a few small fixes:

Chien Tung (2):
      RDMA/nes: Clear stall bit before destroying NIC QP
      RDMA/nes: Fix CX4 link problem in back-to-back configuration

Eli Cohen (1):
      IPoIB: Fix TX queue lockup with mixed UD/CM traffic

Faisal Latif (1):
      RDMA/nes: Set assume_aligned_header bit

Or Gerlitz (1):
      IPoIB: Include return code in trace message for ib_post_send() failures

Roland Dreier (1):
      Merge branches 'cxgb3', 'ipoib', 'misc' and 'nes' into for-next

Steve Wise (2):
      IB/mad: Ignore iWARP devices on device removal
      RDMA/cxgb3: Wait at least one schedule cycle during device removal

 drivers/infiniband/core/mad.c           |    3 +++
 drivers/infiniband/hw/cxgb3/iwch.c      |    2 ++
 drivers/infiniband/hw/nes/nes_hw.c      |    8 ++++++++
 drivers/infiniband/hw/nes/nes_hw.h      |    1 +
 drivers/infiniband/hw/nes/nes_nic.c     |   30 ++++++++++++++++++++++++++++--
 drivers/infiniband/hw/nes/nes_verbs.c   |    1 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c |   10 +++++++---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c |    9 +++++----
 8 files changed, 55 insertions(+), 9 deletions(-)

-- 
Roland Dreier  <rolandd@cisco.com>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
