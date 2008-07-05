Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbYGEUQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbYGEUQ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 16:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbYGEUQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 16:16:51 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:31044 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbYGEUQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 16:16:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ls9YxmGJbBOYEBEi0rxY9zEZ/fHjHGyuytwYjW0W76Wn5N+obUpjySmxyHXU52FJlP
         id+89wdlrqOpZAV6439f8MZSyvvZHKth9BYtrK8x/6N7mJnf5RPAB9rAcS0CxRkXMfWt
         /POlyijsuhjUHrkSHMXJjsq4RZGtIOGCYRKR8=
Subject: [PATCH] mfd: remove DS1WM register definitions from asic3.h
From: Philipp Zabel <philipp.zabel@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@openedhand.com>
Content-Type: text/plain
Date: Sat, 05 Jul 2008 22:16:45 +0200
Message-Id: <1215289005.23398.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a dedicated ds1wm driver, no need to duplicate this
information here.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 include/linux/mfd/asic3.h |   38 +++-----------------------------------
 1 files changed, 3 insertions(+), 35 deletions(-)

diff --git a/include/linux/mfd/asic3.h b/include/linux/mfd/asic3.h
index 0eae308..8f8c46c 100644
--- a/include/linux/mfd/asic3.h
+++ b/include/linux/mfd/asic3.h
@@ -265,44 +265,12 @@ struct asic3_platform_data {
 #define ASIC3_EXTCF_CF_SLEEP             (1 << 15) /* CF sleep mode control */
 
 /*********************************************
- *  The Onewire interface registers
- *
- *  OWM_CMD
- *  OWM_DAT
- *  OWM_INTR
- *  OWM_INTEN
- *  OWM_CLKDIV
+ *  The Onewire interface (DS1WM) is handled
+ *  by the ds1wm driver.
  *
  *********************************************/
 
-#define ASIC3_OWM_Base		0xC00
-
-#define ASIC3_OWM_CMD         0x00
-#define ASIC3_OWM_DAT         0x04
-#define ASIC3_OWM_INTR        0x08
-#define ASIC3_OWM_INTEN       0x0C
-#define ASIC3_OWM_CLKDIV      0x10
-
-#define ASIC3_OWM_CMD_ONEWR         (1 << 0)
-#define ASIC3_OWM_CMD_SRA           (1 << 1)
-#define ASIC3_OWM_CMD_DQO           (1 << 2)
-#define ASIC3_OWM_CMD_DQI           (1 << 3)
-
-#define ASIC3_OWM_INTR_PD          (1 << 0)
-#define ASIC3_OWM_INTR_PDR         (1 << 1)
-#define ASIC3_OWM_INTR_TBE         (1 << 2)
-#define ASIC3_OWM_INTR_TEMP        (1 << 3)
-#define ASIC3_OWM_INTR_RBF         (1 << 4)
-
-#define ASIC3_OWM_INTEN_EPD        (1 << 0)
-#define ASIC3_OWM_INTEN_IAS        (1 << 1)
-#define ASIC3_OWM_INTEN_ETBE       (1 << 2)
-#define ASIC3_OWM_INTEN_ETMT       (1 << 3)
-#define ASIC3_OWM_INTEN_ERBF       (1 << 4)
-
-#define ASIC3_OWM_CLKDIV_PRE       (3 << 0) /* two bits wide at bit 0 */
-#define ASIC3_OWM_CLKDIV_DIV       (7 << 2) /* 3 bits wide at bit 2 */
-
+#define ASIC3_OWM_BASE		0xC00
 
 /*****************************************************************************
  *  The SD configuration registers are at a completely different location
-- 
1.5.6


