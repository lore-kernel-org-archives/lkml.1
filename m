Return-Path: <linux-kernel-owner+w=401wt.eu-S2992704AbXDDG3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992704AbXDDG3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 02:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992699AbXDDG2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 02:28:22 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:10515 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992703AbXDDG2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 02:28:14 -0400
X-IronPort-AV: i="4.14,367,1170651600"; 
   d="scan'208"; a="33682533:sNHT20387857"
Subject: [PATCH] Blackfin arch: add missing __clear_user function to
	uaccess header file
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Wed, 04 Apr 2007 14:28:18 +0800
Message-Id: <1175668099.10608.38.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 include/asm-blackfin/uaccess.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/asm-blackfin/uaccess.h b/include/asm-blackfin/uaccess.h
index ed931bb..bfcb679 100644
--- a/include/asm-blackfin/uaccess.h
+++ b/include/asm-blackfin/uaccess.h
@@ -260,10 +260,12 @@ static inline long strnlen_user(const char *src, long n)
  * Zero Userspace
  */
 
-static inline unsigned long clear_user(void *to, unsigned long n)
+static inline unsigned long __clear_user(void *to, unsigned long n)
 {
 	memset(to, 0, n);
 	return 0;
 }
 
+#define clear_user(to, n) __clear_user(to, n)
+
 #endif				/* _BLACKFIN_UACCESS_H */
-- 
1.5.0.5

