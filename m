Return-Path: <linux-kernel-owner+w=401wt.eu-S934069AbXG2PSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934069AbXG2PSU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765200AbXG2PDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:03:04 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47929 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765298AbXG2PC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:02:56 -0400
Date: Sun, 29 Jul 2007 17:02:33 +0200
From: Adrian Bunk <bunk@stusta.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Steve Grubb <sgrubb@redhat.com>, linux-audit@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] kernel/audit.c: change the exports to EXPORT_SYMBOL_GPL
Message-ID: <20070729150233.GX16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes some completely unused audit exports from 
EXPORT_SYMBOL to EXPORT_SYMBOL_GPL.

They are still completely unused, but hopefully some of the theoretical 
code that might use it will appear in the kernel in the near future...

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Steve Grubb <sgrubb@redhat.com>

---

This patch has been sent on:
- 11 Dec 2006

--- linux-2.6.19-mm1/kernel/audit.c.old	2006-12-11 20:13:54.000000000 +0100
+++ linux-2.6.19-mm1/kernel/audit.c	2006-12-11 20:14:19.000000000 +0100
@@ -1209,7 +1209,7 @@
 	}
 }
 
-EXPORT_SYMBOL(audit_log_start);
-EXPORT_SYMBOL(audit_log_end);
-EXPORT_SYMBOL(audit_log_format);
-EXPORT_SYMBOL(audit_log);
+EXPORT_SYMBOL_GPL(audit_log_start);
+EXPORT_SYMBOL_GPL(audit_log_end);
+EXPORT_SYMBOL_GPL(audit_log_format);
+EXPORT_SYMBOL_GPL(audit_log);


