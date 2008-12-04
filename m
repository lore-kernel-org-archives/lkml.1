Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbYLDBbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbYLDBbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 20:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbYLDBbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 20:31:06 -0500
Received: from xenotime.net ([72.52.64.118]:57210 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753795AbYLDBbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 20:31:05 -0500
Message-ID: <493732D3.4020902@xenotime.net>
Date: Wed, 03 Dec 2008 17:30:59 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       sameo@openedhand.com, akpm <akpm@linux-foundation.org>,
       a.zummo@towertech.it
Subject: [PATCH -next] rtc twl4030: rename ioctl function when RTC_INTF_DEV=n
References: <20081203183602.c06f8c39.sfr@canb.auug.org.au>
In-Reply-To: <20081203183602.c06f8c39.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build error when RTC_INTF_DEV=n:

drivers/rtc/rtc-twl4030.c:402: error: 'twl4030_rtc_ioctl' undeclared here (not in a function)
make[3]: *** [drivers/rtc/rtc-twl4030.o] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/rtc/rtc-twl4030.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20081203.orig/drivers/rtc/rtc-twl4030.c
+++ linux-next-20081203/drivers/rtc/rtc-twl4030.c
@@ -337,7 +337,7 @@ static int twl4030_rtc_ioctl(struct devi
 }
 
 #else
-#define	omap_rtc_ioctl	NULL
+#define	twl4030_rtc_ioctl	NULL
 #endif
 
 static irqreturn_t twl4030_rtc_interrupt(int irq, void *rtc)
