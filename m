Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbXISFHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbXISFHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 01:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbXISFHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 01:07:32 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:42215 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbXISFHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 01:07:31 -0400
Date: Tue, 18 Sep 2007 22:05:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: wim@iguana.be, akpm <akpm@linux-foundation.org>
Subject: [PATCH -mm] watchdog: fix help text
Message-Id: <20070918220529.20d57884.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix typos in uniform watchdog driver help text.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/watchdog/core/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.23-rc6-mm1.orig/drivers/watchdog/core/Kconfig
+++ linux-2.6.23-rc6-mm1/drivers/watchdog/core/Kconfig
@@ -9,12 +9,12 @@ config WATCHDOG_CORE
 	depends on EXPERIMENTAL
 	default m
 	---help---
-	  Say Y here is you want to use the new uniform watchdog device
+	  Say Y here if you want to use the new uniform watchdog device
 	  driver. This driver provides a framework for all watchdog
 	  device drivers and gives them the /dev/watchdog interface (and
-	  later also the sysfs interface)
+	  later also the sysfs interface).
 
-	  At this moment only the iTCO_wdt driver uses this new frame-work.
+	  At this moment only the iTCO_wdt driver uses this new framework.
 
 	  To compile this driver as a module, choose M here: the module will
 	  be called watchdog_core.
