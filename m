Return-Path: <linux-kernel-owner+w=401wt.eu-S1762932AbZATAeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762932AbZATAeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbZATAe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 19:34:28 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:6905 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbZATAe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 19:34:28 -0500
Message-ID: <49751C12.1030104@ct.jp.nec.com>
Date: Mon, 19 Jan 2009 16:34:26 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86: uaccess: fix style problems
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

fix some coding style problems in arch/x86/include/asm/uaccess.h.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/include/asm/uaccess.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 4340055..aeb3c1b 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -121,7 +121,7 @@ extern int __get_user_bad(void);
 
 #define __get_user_x(size, ret, x, ptr)		      \
 	asm volatile("call __get_user_" #size	      \
-		     : "=a" (ret),"=d" (x)	      \
+		     : "=a" (ret), "=d" (x)	      \
 		     : "0" (ptr))		      \
 
 /* Careful: we have to cast the result to the type of the pointer
@@ -181,7 +181,7 @@ extern int __get_user_bad(void);
 
 #define __put_user_x(size, x, ptr, __ret_pu)			\
 	asm volatile("call __put_user_" #size : "=a" (__ret_pu)	\
-		     :"0" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
+		     : "0" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
 
 
 
@@ -276,7 +276,7 @@ do {									\
 		__put_user_asm(x, ptr, retval, "w", "w", "ir", errret);	\
 		break;							\
 	case 4:								\
-		__put_user_asm(x, ptr, retval, "l", "k",  "ir", errret);\
+		__put_user_asm(x, ptr, retval, "l", "k", "ir", errret);	\
 		break;							\
 	case 8:								\
 		__put_user_u64((__typeof__(*ptr))(x), ptr, retval);	\
-- 
1.6.0.4

