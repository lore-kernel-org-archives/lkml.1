Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbYGUTdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbYGUTdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbYGUTdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:33:44 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:34158 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbYGUTdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:33:43 -0400
Date: Mon, 21 Jul 2008 22:33:36 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Greg KH <greg@kroah.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make struct platform_pm_ops static
Message-ID: <20080721193336.GB14846@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global struct platform_pm_ops static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
71ccd993d723c7ce560975622801153de6ca8f59 
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 3f94039..e621dad 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -862,7 +862,7 @@ static int platform_pm_restore_noirq(struct device *dev)
 
 #endif /* !CONFIG_HIBERNATION */
 
-struct pm_ext_ops platform_pm_ops = {
+static struct pm_ext_ops platform_pm_ops = {
 	.base = {
 		.prepare = platform_pm_prepare,
 		.complete = platform_pm_complete,

