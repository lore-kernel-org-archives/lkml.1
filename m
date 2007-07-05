Return-Path: <linux-kernel-owner+w=401wt.eu-S1763170AbXGEXXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763170AbXGEXXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761033AbXGEXWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:22:38 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:52135 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762943AbXGEXWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:22:37 -0400
Date: Fri, 6 Jul 2007 01:23:06 +0200
From: Adrian Bunk <bunk@stusta.de>
To: r.marek@assembler.cz
Cc: lm-sensors@lm-sensors.org, mhoffman@lightlink.com,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] make coretemp_device_remove() static
Message-ID: <20070705232306.GY3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

coretemp_device_remove() can become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/drivers/hwmon/coretemp.c.old	2007-07-04 20:46:05.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/hwmon/coretemp.c	2007-07-04 20:46:20.000000000 +0200
@@ -318,7 +318,7 @@
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-void coretemp_device_remove(unsigned int cpu)
+static void coretemp_device_remove(unsigned int cpu)
 {
 	struct pdev_entry *p, *n;
 	mutex_lock(&pdev_list_mutex);

