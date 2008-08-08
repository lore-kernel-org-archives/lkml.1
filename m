Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbYHHQiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbYHHQiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbYHHQgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:36:21 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36098 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163AbYHHQgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:36:19 -0400
Date: Fri, 8 Aug 2008 19:34:45 +0300
From: Adrian Bunk <bunk@kernel.org>
To: tony.luck@intel.com
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>
Subject: [7/17] ia64: use bcd2bin/bin2bcd
Message-ID: <20080808163445.GN14495@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes ia64 to use the new bcd2bin/bin2bcd functions instead 
of the obsolete BCD2BIN/BIN2BCD macros.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
fb54890949dadb16520ed7d3f9c7eb2b89abb34e 
diff --git a/arch/ia64/include/asm/sal.h b/arch/ia64/include/asm/sal.h
index 89594b4..ea310c0 100644
--- a/arch/ia64/include/asm/sal.h
+++ b/arch/ia64/include/asm/sal.h
@@ -236,7 +236,7 @@ extern struct ia64_sal_desc_ptc *ia64_ptc_domain_info;
 
 extern unsigned short sal_revision;	/* supported SAL spec revision */
 extern unsigned short sal_version;	/* SAL version; OEM dependent */
-#define SAL_VERSION_CODE(major, minor) ((BIN2BCD(major) << 8) | BIN2BCD(minor))
+#define SAL_VERSION_CODE(major, minor) ((bin2bcd(major) << 8) | bin2bcd(minor))
 
 extern const char *ia64_sal_strerror (long status);
 extern void ia64_sal_init (struct ia64_sal_systab *sal_systab);

