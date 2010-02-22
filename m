Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab0BVPds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 10:33:48 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:39018 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab0BVPdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 10:33:47 -0500
X-Greylist: delayed 474 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Feb 2010 10:33:46 EST
X-Spam-Processed: digidescorp.com, Mon, 22 Feb 2010 09:25:47 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=16695eb497=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: microblaze-uclinux@itee.uq.edu.au
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org,
       "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH][trivial] microblaze: Fix out_le32() macro
Date: Mon, 22 Feb 2010 09:25:42 -0600
Message-Id: <1266852342-9033-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trailing semicolon causes compilation involving out_le32() to fail.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
diff -uprN a/arch/microblaze/include/asm/io.h b/arch/microblaze/include/asm/io.h
--- a/arch/microblaze/include/asm/io.h	2010-02-22 09:21:14.000000000 -0600
+++ b/arch/microblaze/include/asm/io.h	2010-02-22 09:21:44.000000000 -0600
@@ -217,7 +217,7 @@ static inline void __iomem *__ioremap(ph
  * Little endian
  */
 
-#define out_le32(a, v) __raw_writel(__cpu_to_le32(v), (a));
+#define out_le32(a, v) __raw_writel(__cpu_to_le32(v), (a))
 #define out_le16(a, v) __raw_writew(__cpu_to_le16(v), (a))
 
 #define in_le32(a) __le32_to_cpu(__raw_readl(a))

