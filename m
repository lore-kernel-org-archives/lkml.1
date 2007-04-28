Return-Path: <linux-kernel-owner+w=401wt.eu-S1031192AbXD1TVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031192AbXD1TVE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161209AbXD1TUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:20:46 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37516 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030766AbXD1TUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:20:17 -0400
Date: Sat, 28 Apr 2007 21:20:28 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Alessandro Zummo <a.zummo@towertech.it>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Subject: [-mm patch] drivers/rtc/rtc-dev.c should #include "rtc-core.h"
Message-ID: <20070428192028.GV3468@stusta.de>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the prototypes for
it's global functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc7-mm2/drivers/rtc/rtc-dev.c.old	2007-04-28 15:16:24.000000000 +0200
+++ linux-2.6.21-rc7-mm2/drivers/rtc/rtc-dev.c	2007-04-28 15:16:36.000000000 +0200
@@ -13,6 +13,7 @@
 
 #include <linux/module.h>
 #include <linux/rtc.h>
+#include "rtc-core.h"
 
 static dev_t rtc_devt;
 

