Return-Path: <linux-kernel-owner+w=401wt.eu-S1752380AbYDMSRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbYDMSRQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 14:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbYDMSQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 14:16:32 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:42087 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbYDMSQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 14:16:31 -0400
Date: Sun, 13 Apr 2008 21:15:31 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ben Dooks <ben@simtec.co.uk>, Vincent Sanders <vince@simtec.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] mfd/sm501.c: #if 0 unused functions
Message-ID: <20080413181531.GD2182@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch #if 0's the following unused functions:
- sm501_find_clock()
- sm501_gpio_get()
- sm501_gpio_set()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/mfd/sm501.c   |    5 +++++
 include/linux/sm501.h |   21 ---------------------
 2 files changed, 5 insertions(+), 21 deletions(-)

24190c50efec1862c20bba55a31677879fae1de3 diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index 13bac53..54de0ff 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -275,6 +275,8 @@ unsigned long sm501_modify_reg(struct device *dev,
 
 EXPORT_SYMBOL_GPL(sm501_modify_reg);
 
+#if 0
+
 unsigned long sm501_gpio_get(struct device *dev,
 			     unsigned long gpio)
 {
@@ -326,6 +328,7 @@ void sm501_gpio_set(struct device *dev,
 
 EXPORT_SYMBOL_GPL(sm501_gpio_set);
 
+#endif  /*  0  */
 
 /* sm501_unit_power
  *
@@ -657,6 +660,7 @@ unsigned long sm501_set_clock(struct device *dev,
 
 EXPORT_SYMBOL_GPL(sm501_set_clock);
 
+#if 0
 /* sm501_find_clock
  *
  * finds the closest available frequency for a given clock
@@ -699,6 +703,7 @@ unsigned long sm501_find_clock(struct device *dev,
 }
 
 EXPORT_SYMBOL_GPL(sm501_find_clock);
+#endif  /*  0  */
 
 static struct sm501_device *to_sm_device(struct platform_device *pdev)
 {
diff --git a/include/linux/sm501.h b/include/linux/sm501.h
index bca1345..f416505 100644
--- a/include/linux/sm501.h
+++ b/include/linux/sm501.h
@@ -24,9 +24,6 @@ extern int sm501_unit_power(struct device *dev,
 extern unsigned long sm501_set_clock(struct device *dev,
 				     int clksrc, unsigned long freq);
 
-extern unsigned long sm501_find_clock(struct device *dev,
-				      int clksrc, unsigned long req_freq);
-
 /* sm501_misc_control
  *
  * Modify the SM501's MISC_CONTROL register
@@ -46,24 +43,6 @@ extern unsigned long sm501_modify_reg(struct device *dev,
 				      unsigned long set,
 				      unsigned long clear);
 
-/* sm501_gpio_set
- *
- * set the state of the given GPIO line
-*/
-
-extern void sm501_gpio_set(struct device *dev,
-			   unsigned long gpio,
-			   unsigned int to,
-			   unsigned int dir);
-
-/* sm501_gpio_get
- *
- * get the state of the given GPIO line
-*/
-
-extern unsigned long sm501_gpio_get(struct device *dev,
-				    unsigned long gpio);
-
 
 /* Platform data definitions */
 

