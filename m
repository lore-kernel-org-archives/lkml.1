Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab0CJN1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:27:46 -0500
Received: from av7-2-sn3.vrr.skanova.net ([81.228.9.182]:34678 "EHLO
	av7-2-sn3.vrr.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab0CJN1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:27:44 -0500
Message-ID: <4B979E4B.70001@pelagicore.com>
Date: Wed, 10 Mar 2010 14:27:39 +0100
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
Organization: Pelagicore AB
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100121 Iceowl/1.0b1 Icedove/3.0.1
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] max730x: Add license macro
Content-Type: multipart/mixed;
 boundary="------------090902090905040902040300"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090902090905040902040300
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Due to mail client issues, the patch is attached.

According to the header in max730x it is licensed GPLv2.

Add a MODULE_LICENSE to avoid tainting the kernel.

--Richard

--------------090902090905040902040300
Content-Type: text/x-patch;
 name="max730x-license.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="max730x-license.patch"

According to the header in max730x it is licensed GPLv2.

Add a MODULE_LICENSE to avoid getting the kernel tainted.

Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
---
diff --git a/drivers/gpio/max730x.c b/drivers/gpio/max730x.c
index c9bced5..6474577 100644
--- a/drivers/gpio/max730x.c
+++ b/drivers/gpio/max730x.c
@@ -242,3 +242,5 @@ int __devexit __max730x_remove(struct device *dev)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(__max730x_remove);
+
+MODULE_LICENSE("GPL v2");

--------------090902090905040902040300--
