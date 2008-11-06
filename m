Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbYKFPXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbYKFPXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbYKFPXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:23:41 -0500
Received: from mail.atmel.fr ([81.80.104.162]:34075 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbYKFPXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:23:40 -0500
Message-ID: <49130BE3.1030108@atmel.com>
Date: Thu, 06 Nov 2008 16:23:15 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: "Antonino A. Daplas" <adaplas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net,
       Linux Kernel list <linux-kernel@vger.kernel.org>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <linux@maxim.org.za>
Subject: [PATCH] atmel_lcdfb: Change irq_base definition to allow error reporting
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change irq_base definition to allow error reporting

Changed because old definition : unsigned long cannot be negative.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Reported-by: Roel Kluin <roel.kluin@gmail.com>
---
 include/video/atmel_lcdc.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/video/atmel_lcdc.h b/include/video/atmel_lcdc.h
index 6ad87f4..0c864db 100644
--- a/include/video/atmel_lcdc.h
+++ b/include/video/atmel_lcdc.h
@@ -38,7 +38,7 @@ struct atmel_lcdfb_info {
 	spinlock_t		lock;
 	struct fb_info		*info;
 	void __iomem		*mmio;
-	unsigned long		irq_base;
+	int			irq_base;
 	struct work_struct	task;
 
 	unsigned int		guard_time;
-- 
1.5.3.7



