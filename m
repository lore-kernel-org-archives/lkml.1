Return-Path: <linux-kernel-owner+w=401wt.eu-S1758512AbYG3A5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512AbYG3A5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 20:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757282AbYG3Azh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:55:37 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:51866 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757140AbYG3Azg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:55:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=DMME9O/3qBCavsDoLcDpuLRDLpPMOETIK+gxzNFKp5k2imQ1d4obvilnCywL8xQJzX
         CG/C/E4TKHclqC6xYFctdfpZ39RBHFf4PdVZNhiPLJzxtR+CTYJkmbvRKHIPYUipUGEi
         dWXFVHVUeFv+oHWucpwVvxf/ZBgV7XQChv9Mg=
Subject: [PATCH 08/24] h8300: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 17:55:21 -0700
Message-Id: <1217379321.23389.119.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-h8300/byteorder.h |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/include/asm-h8300/byteorder.h b/include/asm-h8300/byteorder.h
index 36e597d..465b7af 100644
--- a/include/asm-h8300/byteorder.h
+++ b/include/asm-h8300/byteorder.h
@@ -1,13 +1,9 @@
 #ifndef _H8300_BYTEORDER_H
 #define _H8300_BYTEORDER_H
 
-#include <asm/types.h>
+#define __BIG_ENDIAN
+#define __SWAB_64_THRU_32__
 
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
-#include <linux/byteorder/big_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _H8300_BYTEORDER_H */
-- 
1.6.0.rc1.154.ge3fc


