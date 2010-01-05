Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022Ab0AENaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab0AENaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 08:30:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186Ab0AENaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 08:30:06 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52781 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752581Ab0AENaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 08:30:05 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] genirq: Fix documentation of default chip disable()
Date: Tue,  5 Jan 2010 13:29:58 +0000
Message-Id: <1262698198-30392-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.5.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation says that by default disable() will be chip->mask
but in fact default_disable() is a noop.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

 include/linux/irq.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 451481c..d13492d 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -90,7 +90,7 @@ struct msi_desc;
  * @startup:		start up the interrupt (defaults to ->enable if NULL)
  * @shutdown:		shut down the interrupt (defaults to ->disable if NULL)
  * @enable:		enable the interrupt (defaults to chip->unmask if NULL)
- * @disable:		disable the interrupt (defaults to chip->mask if NULL)
+ * @disable:		disable the interrupt
  * @ack:		start of a new interrupt
  * @mask:		mask an interrupt source
  * @mask_ack:		ack and mask an interrupt source
-- 
1.6.5.7

