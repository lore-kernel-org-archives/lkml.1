Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968750Ab0B1QT7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 11:19:59 -0500
Received: from www.tglx.de ([62.245.132.106]:37682 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964812Ab0B1QT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 11:19:58 -0500
Date: Sun, 28 Feb 2010 17:19:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] genirq for 2.6.34
Message-ID: <alpine.LFD.2.00.1002281719170.4245@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-core-for-linus

Thanks,

	tglx

------------------>
Mark Brown (1):
      genirq: Fix documentation of default chip disable()


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
