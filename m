Return-Path: <linux-kernel-owner+w=401wt.eu-S1761540AbYBZOyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761540AbYBZOyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 09:54:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbYBZOyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 09:54:00 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:38463 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbYBZOx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 09:53:59 -0500
X-Greylist: delayed 1424 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Feb 2008 09:53:59 EST
From: jan sonnek <xsonnek@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jan sonnek <xsonnek@gmail.com>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] Misc: phantom, consistent whitespace
Date: Tue, 26 Feb 2008 15:30:09 +0100
Message-Id: <1204036209-9959-1-git-send-email-xsonnek@gmail.com>
X-Mailer: git-send-email 1.5.4.1
X-Muni-Spam-TestIP: 147.251.51.179
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 26 Feb 2008 15:30:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it consistent with the rest of the header.

Signed-off-by: jan sonnek <xsonnek@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
---
 include/linux/phantom.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/phantom.h b/include/linux/phantom.h
index a341e21..02268c5 100644
--- a/include/linux/phantom.h
+++ b/include/linux/phantom.h
@@ -27,13 +27,13 @@ struct phm_regs {
 
 #define PH_IOC_MAGIC		'p'
 #define PHN_GET_REG		_IOWR(PH_IOC_MAGIC, 0, struct phm_reg *)
-#define PHN_SET_REG		_IOW (PH_IOC_MAGIC, 1, struct phm_reg *)
+#define PHN_SET_REG		_IOW(PH_IOC_MAGIC, 1, struct phm_reg *)
 #define PHN_GET_REGS		_IOWR(PH_IOC_MAGIC, 2, struct phm_regs *)
-#define PHN_SET_REGS		_IOW (PH_IOC_MAGIC, 3, struct phm_regs *)
+#define PHN_SET_REGS		_IOW(PH_IOC_MAGIC, 3, struct phm_regs *)
 /* this ioctl tells the driver, that the caller is not OpenHaptics and might
  * use improved registers update (no more phantom switchoffs when using
  * libphantom) */
-#define PHN_NOT_OH		_IO  (PH_IOC_MAGIC, 4)
+#define PHN_NOT_OH		_IO(PH_IOC_MAGIC, 4)
 #define PHN_GETREG		_IOWR(PH_IOC_MAGIC, 5, struct phm_reg)
 #define PHN_SETREG		_IOW(PH_IOC_MAGIC, 6, struct phm_reg)
 #define PHN_GETREGS		_IOWR(PH_IOC_MAGIC, 7, struct phm_regs)
-- 
1.5.4.1

