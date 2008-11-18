Return-Path: <linux-kernel-owner+w=401wt.eu-S1751271AbYKRIWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751271AbYKRIWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 03:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbYKRIWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 03:22:16 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:29131 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbYKRIWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 03:22:14 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62691804"
From: Bryan Wu <cooloney@kernel.org>
To: felipe.balbi@nokia.com, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 2/6] usb: musb: Blackfin provides read/write I/O accessor in header files
Date: Tue, 18 Nov 2008 16:23:36 +0800
Message-Id: <1226996620-11388-3-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226996620-11388-1-git-send-email-cooloney@kernel.org>
References: <1226996620-11388-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't redefine the functions in musb driver

Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/usb/musb/musb_io.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/musb/musb_io.h b/drivers/usb/musb/musb_io.h
index 15f0577..b06e9ef 100644
--- a/drivers/usb/musb/musb_io.h
+++ b/drivers/usb/musb/musb_io.h
@@ -39,7 +39,7 @@
 
 #if !defined(CONFIG_ARM) && !defined(CONFIG_SUPERH) \
 	&& !defined(CONFIG_AVR32) && !defined(CONFIG_PPC32) \
-	&& !defined(CONFIG_PPC64)
+	&& !defined(CONFIG_PPC64) && !defined(CONFIG_BLACKFIN)
 static inline void readsl(const void __iomem *addr, void *buf, int len)
 	{ insl((unsigned long)addr, buf, len); }
 static inline void readsw(const void __iomem *addr, void *buf, int len)
-- 
1.5.6.3
