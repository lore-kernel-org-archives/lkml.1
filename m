Return-Path: <linux-kernel-owner+w=401wt.eu-S1759440AbXENCh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440AbXENCh7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 22:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757554AbXENChw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 22:37:52 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:59682 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754368AbXENChv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 22:37:51 -0400
Message-ID: <379110250.28666@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Mon, 14 May 2007 10:37:18 +0800
From: Fengguang Wu <fengguang.wu@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] resolve duplicate flag no for PG_lazyfree
Message-ID: <20070514023718.GA14944@mail.ustc.edu.cn>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PG_lazyfree and PG_booked shares the same bit.

Either it is a bug that shall fixed by the following patch, or
the situation should be explicitly documented?

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 include/linux/page-flags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.21-mm2.orig/include/linux/page-flags.h
+++ linux-2.6.21-mm2/include/linux/page-flags.h
@@ -91,7 +91,7 @@
 #define PG_buddy		19	/* Page is free, on buddy lists */
 #define PG_booked		20	/* Has blocks reserved on-disk */
 
-#define PG_lazyfree		20	/* MADV_FREE potential throwaway */
+#define PG_lazyfree		21	/* MADV_FREE potential throwaway */
 
 /* PG_owner_priv_1 users should have descriptive aliases */
 #define PG_checked		PG_owner_priv_1 /* Used by some filesystems */

