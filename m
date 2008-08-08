Return-Path: <linux-kernel-owner+w=401wt.eu-S1759598AbYHHQlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759598AbYHHQlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbYHHQgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:36:38 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:48042 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758116AbYHHQgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:36:36 -0400
Date: Fri, 8 Aug 2008 19:35:01 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>
Subject: [16/17] remove the obsolete BCD*BIN/BIN*BCD macros
Message-ID: <20080808163501.GW14495@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the following obsolete macros:
- BCD2BIN
- BIN2BCD
- BCD_TO_BIN
- BIN_TO_BCD

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch depends on patches 1-15.

8ac374c88cce55a8aa9dec3e6595d5032a1ace03 
diff --git a/include/linux/bcd.h b/include/linux/bcd.h
index 7ac518e..75f6d6e 100644
--- a/include/linux/bcd.h
+++ b/include/linux/bcd.h
@@ -15,11 +15,4 @@
 unsigned bcd2bin(unsigned char val) __attribute_const__;
 unsigned char bin2bcd(unsigned val) __attribute_const__;
 
-#define BCD2BIN(val)	bcd2bin(val)
-#define BIN2BCD(val)	bin2bcd(val)
-
-/* backwards compat */
-#define BCD_TO_BIN(val) ((val)=BCD2BIN(val))
-#define BIN_TO_BCD(val) ((val)=BIN2BCD(val))
-
 #endif /* _BCD_H */

