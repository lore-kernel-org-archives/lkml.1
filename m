Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbYICJkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbYICJkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 05:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbYICJij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 05:38:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:44252 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859AbYICJii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 05:38:38 -0400
Subject: [PATCH 8/8] S390: Update comments about why we don't use
	<asm-generic/statfs.h>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <1220275314.2982.83.camel@pmac.infradead.org>
References: <1220275314.2982.83.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Wed, 03 Sep 2008 10:38:35 +0100
Message-Id: <1220434715.2985.68.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 arch/s390/include/asm/statfs.h |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/s390/include/asm/statfs.h b/arch/s390/include/asm/statfs.h
index 099a455..06cc703 100644
--- a/arch/s390/include/asm/statfs.h
+++ b/arch/s390/include/asm/statfs.h
@@ -12,19 +12,16 @@
 #ifndef __s390x__
 #include <asm-generic/statfs.h>
 #else
+/*
+ * We can't use <asm-generic/statfs.h> because in 64-bit mode
+ * we mix ints of different sizes in our struct statfs.
+ */
 
 #ifndef __KERNEL_STRICT_NAMES
-
 #include <linux/types.h>
-
 typedef __kernel_fsid_t	fsid_t;
-
 #endif
 
-/*
- * This is ugly -- we're already 64-bit clean, so just duplicate the 
- * definitions.
- */
 struct statfs {
 	int  f_type;
 	int  f_bsize;
-- 
1.5.5.1
-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



