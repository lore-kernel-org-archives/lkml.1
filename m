Return-Path: <linux-kernel-owner+w=401wt.eu-S1762706AbXJMVRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762706AbXJMVRU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 17:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbXJMVRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 17:17:12 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:24128 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbXJMVRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 17:17:11 -0400
X-IronPort-AV: E=Sophos;i="4.21,271,1188802800"; 
   d="scan'208";a="180822811"
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: [GIT PULL] please pull infiniband.git for-linus
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Sat, 13 Oct 2007 14:17:10 -0700
Message-ID: <adaejfyn295.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Oct 2007 21:17:10.0626 (UTC) FILETIME=[6AD45420:01C80DDE]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get one bug fix for a problem that completely kills the mlx4 driver:

Roland Dreier (1):
      mlx4_core: Fix infinite loop on device initialization

 drivers/net/mlx4/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index e029b8a..89b3f0b 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -884,7 +884,7 @@ static int __devinit mlx4_init_one(struct pci_dev *pdev,
 		++mlx4_version_printed;
 	}
 
-	return mlx4_init_one(pdev, id);
+	return __mlx4_init_one(pdev, id);
 }
 
 static void mlx4_remove_one(struct pci_dev *pdev)
