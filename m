Return-Path: <linux-kernel-owner+w=401wt.eu-S1759811AbXH1RVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759811AbXH1RVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 13:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbXH1RVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 13:21:13 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:19294 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751351AbXH1RVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 13:21:12 -0400
Date: Tue, 28 Aug 2007 11:21:39 -0600
From: dougthompson@xmission.com
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 1/1] drivers edac fix printk level down to debug from
 emerg
Message-ID: <46d459a3.rQ0VTx5je6vk2pqS%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Doug Thompson <dougthompson@xmission.com>

Patched applied to 2.6.23-rc3

When EDAC is configured for EDAC DEBUGGING, the debug printk output level
was set TOO high (EMERG). This patch brings it down to a DEBUG level

Signed-off-by:	Doug Thompson <dougthompson@xmission.com>
cc:   Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 edac_core.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23-rc3/drivers/edac/edac_core.h
===================================================================
--- linux-2.6.23-rc3.orig/drivers/edac/edac_core.h	2007-08-12 22:25:24.000000000 -0600
+++ linux-2.6.23-rc3/drivers/edac/edac_core.h	2007-08-27 22:22:51.000000000 -0600
@@ -75,7 +75,7 @@
 #define edac_debug_printk(level, fmt, arg...)                            \
 	do {                                                             \
 		if (level <= edac_debug_level)                           \
-			edac_printk(KERN_EMERG, EDAC_DEBUG, fmt, ##arg); \
+			edac_printk(KERN_DEBUG, EDAC_DEBUG, fmt, ##arg); \
 	} while(0)
 
 #define debugf0( ... ) edac_debug_printk(0, __VA_ARGS__ )
