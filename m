Return-Path: <linux-kernel-owner+w=401wt.eu-S1755836AbXIXU7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbXIXU7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 16:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbXIXU65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 16:58:57 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:41131 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbXIXU65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 16:58:57 -0400
Date: Tue, 25 Sep 2007 05:58:33 +0900 (JST)
Message-Id: <20070925.055833.207495508.jet@gyve.org>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, e1000-devel@lists.sourceforge.net
Subject: [patch] fix typo about TBI in e1000 comment
From: Masatake YAMATO <jet@gyve.org>
X-Mailer: Mew version 5.2 on Emacs 22.1.50 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've found a typo in a comment of e1000 driver.

I don't know the Signed-off-by for such a short and trivial patch. Any way
I put it here.

Signed-off-by: Masatake YAMATO <jet@gyve.org>

diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
index 4a22595..50e9c41 100644
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -3594,7 +3594,7 @@ e1000_update_stats(struct e1000_adapter *adapter)
 
 	spin_lock_irqsave(&adapter->stats_lock, flags);
 
-	/* these counters are modified from e1000_adjust_tbi_stats,
+	/* these counters are modified from e1000_tbi_adjust_stats,
 	 * called from the interrupt context, so they must only
 	 * be written while holding adapter->stats_lock
 	 */
