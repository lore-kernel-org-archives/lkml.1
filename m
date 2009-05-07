Return-Path: <linux-kernel-owner+w=401wt.eu-S1759187AbZEGAR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187AbZEGAR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 20:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbZEGARu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 20:17:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:57057 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbZEGARu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 20:17:50 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@lists.linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Kevin Hilman <khilman@deeprootsystems.com>
Subject: [PATCH] genirq: update irq_chip struct comment for irq_chip->disable hook
Date: Wed,  6 May 2009 17:17:47 -0700
Message-Id: <1241655468-5750-1-git-send-email-khilman@deeprootsystems.com>
X-Mailer: git-send-email 1.6.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irq_chip disable hook no longer defaults to a irq_chip->unmask.

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
 include/linux/irq.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index b7cbeed..3674046 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -88,7 +88,7 @@ struct msi_desc;
  * @startup:		start up the interrupt (defaults to ->enable if NULL)
  * @shutdown:		shut down the interrupt (defaults to ->disable if NULL)
  * @enable:		enable the interrupt (defaults to chip->unmask if NULL)
- * @disable:		disable the interrupt (defaults to chip->mask if NULL)
+ * @disable:		disable the interrupt
  * @ack:		start of a new interrupt
  * @mask:		mask an interrupt source
  * @mask_ack:		ack and mask an interrupt source
-- 
1.6.2.2

