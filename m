Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbZKMUSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbZKMUSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 15:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757306AbZKMUSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 15:18:34 -0500
Received: from smtp101.biz.mail.mud.yahoo.com ([68.142.200.236]:34764 "HELO
	smtp101.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757251AbZKMUSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 15:18:33 -0500
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-YMail-OSG: OGltuk8VM1nycAXUuPtG4Ngbc_xheHJJviNGlXcDK8jhdNoivVTWXZGDnc6h3exilynHgSZ4lGx4klrqAvwMc4g5OpLCbF._TpMwJHMY3mf3H6FJe14UJo0lFY_I.R1puzGSdNLWCeSndEoAN1WfxCFETSlW11v5izeJehX8VWzdNnVVx1NBWAa_HRP9wzP6mTvo2PXsqOB2MEizvus9DcB2wf.kmw4WBapv9e.Oxh.3Oyn4AyveCP5XRJY97ZjCwN3T07V7fkMHjFXsV0Kbz0fKL6P0PbI6N4kQCTXW5.Fmcq2xOA3yxyWR84HQNQEQA9o2YhRPBnqWSyEXz4FxWHIipZie4xA52d8vVhWR8g--
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
Organization: fdwdc.com
To: uclinux-dev@uclinux.org
Subject: [PATCH] m68knommu: export clk_* symbols in clk.c
Date: Fri, 13 Nov 2009 12:18:37 -0800
User-Agent: KMail/1.9.9
Cc: Greg Ungerer <gerg@snapgear.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911131218.37434.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

export the clk_*  stubs defined in arch/m68knommu/platform/coldfire/clk.c so
they can be used by modules.

Signed-off-by: Steven King <sfking@fdwdc.com>
---

 arch/m68knommu/platform/coldfire/clk.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)


diff --git a/arch/m68knommu/platform/coldfire/clk.c b/arch/m68knommu/platform/coldfire/clk.c
index 7cdbf44..9f1260c 100644
--- a/arch/m68knommu/platform/coldfire/clk.c
+++ b/arch/m68knommu/platform/coldfire/clk.c
@@ -9,6 +9,7 @@
 /***************************************************************************/
 
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/clk.h>
 #include <asm/coldfire.h>
 
@@ -18,23 +19,27 @@ struct clk *clk_get(struct device *dev, const char *id)
 {
 	return NULL;
 }
+EXPORT_SYMBOL(clk_get);
 
 int clk_enable(struct clk *clk)
 {
 	return 0;
 }
+EXPORT_SYMBOL(clk_enable);
 
 void clk_disable(struct clk *clk)
 {
 }
+EXPORT_SYMBOL(clk_disable);
 
 void clk_put(struct clk *clk)
 {
 }
+EXPORT_SYMBOL(clk_put);
 
 unsigned long clk_get_rate(struct clk *clk)
 {
 	return MCF_CLK;
 }
-
+EXPORT_SYMBOL(clk_get_rate);
 /***************************************************************************/
