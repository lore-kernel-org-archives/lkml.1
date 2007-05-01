Return-Path: <linux-kernel-owner+w=401wt.eu-S1030196AbXEASMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030196AbXEASMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 14:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030181AbXEASMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 14:12:55 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:52191 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030196AbXEASMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 14:12:54 -0400
Message-id: <1001724677817415016@wsc.cz>
In-reply-to: <88401795395522653@wsc.cz>
Subject: [PATCH 2/3] Char: isicom, use pr_debug
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Tue,  1 May 2007 20:12:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

isicom, use pr_debug

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit f4fba1005f8f25f5dc369f6e6e04643f4b6a6822
tree 82ba620999de3010b7aebf2a31998e7625e878aa
parent 429ee8495d50042ae8894b8302887b191f56fe5f
author Jiri Slaby <jirislaby@gmail.com> Tue, 01 May 2007 20:09:53 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 01 May 2007 20:09:53 +0200

 drivers/char/isicom.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 43ab9ed..761f777 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -137,11 +137,10 @@
 #define InterruptTheCard(base) outw(0, (base) + 0xc)
 #define ClearInterrupt(base) inw((base) + 0x0a)
 
+#define pr_dbg(str...) pr_debug("ISICOM: " str)
 #ifdef DEBUG
-#define pr_dbg(str...) printk(KERN_DEBUG "ISICOM: " str)
 #define isicom_paranoia_check(a, b, c) __isicom_paranoia_check((a), (b), (c))
 #else
-#define pr_dbg(str...) do { } while (0)
 #define isicom_paranoia_check(a, b, c) 0
 #endif
 
