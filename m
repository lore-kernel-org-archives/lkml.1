Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbYG1MIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbYG1MIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 08:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbYG1MII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 08:08:08 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:21479 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbYG1MIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 08:08:07 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K4PTP7-03-FIA-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] introduce lower_32_bits() macro
Date: Mon, 28 Jul 2008 14:07:56 +0200
Message-ID: <1217246876-670-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <4889FA03.6010708@zytor.com>
References: <4889FA03.6010708@zytor.com>
X-OriginalArrivalTime: 28 Jul 2008 12:07:56.0349 (UTC) FILETIME=[91EE76D0:01C8F0AA]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file kernel.h contains the upper_32_bits macro. This patch adds the other
part, the lower_32_bits macro. Its first use will be in the driver for AMD
IOMMU.

Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/kernel.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index fdbbf72..aaa998f 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -75,6 +75,12 @@ extern const char linux_proc_banner[];
  */
 #define upper_32_bits(n) ((u32)(((n) >> 16) >> 16))
 
+/**
+ * lower_32_bits - return bits 0-31 of a number
+ * @n: the number we're accessing
+ */
+#define lower_32_bits(n) ((u32)(n))
+
 #define	KERN_EMERG	"<0>"	/* system is unusable			*/
 #define	KERN_ALERT	"<1>"	/* action must be taken immediately	*/
 #define	KERN_CRIT	"<2>"	/* critical conditions			*/
-- 
1.5.3.7


