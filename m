Return-Path: <linux-kernel-owner+w=401wt.eu-S1757276AbYKESgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbYKESgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 13:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755515AbYKESfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 13:35:38 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:48774 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbYKESfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 13:35:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ecCxjFoEWolWXsZIuM7b628U4JAQE0QUyKNJO2jNTjXCnANcDPNW0fvOQbAmGLdFyL
         IgoaR1rrQSHGJxmP7eHuzX373EeUXtwKEJj6KTzvsJ9JHH/U7kpHmVYb4m29aaP/Fi9T
         uJtQccczwpiht6D4TMZhm4F2JX1jwncU8raLk=
Subject: [PATCH 05/10] h8300: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 05 Nov 2008 10:35:28 -0800
Message-Id: <1225910128.5991.225.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/h8300/include/asm/byteorder.h |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/h8300/include/asm/byteorder.h b/arch/h8300/include/asm/byteorder.h
index 36e597d..465b7af 100644
--- a/arch/h8300/include/asm/byteorder.h
+++ b/arch/h8300/include/asm/byteorder.h
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
1.6.0.3.756.gb776d


