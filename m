Return-Path: <linux-kernel-owner+w=401wt.eu-S1759661AbXKAK21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759661AbXKAK21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 06:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbXKAK2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 06:28:19 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:35643 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbXKAK2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 06:28:18 -0400
Date: Thu, 1 Nov 2007 14:05:27 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: rusty@rustcorp.com.au, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, apw@shadowen.org, linuxppc-dev@ozlabs.org
Subject: [PATCH] 2.6.24-rc1-git9 - Missing include file in kallsyms.h
Message-ID: <20071101083527.GB8350@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Build with randconfig fails with following error with the
2.6.24-rc4-git9

include/linux/kallsyms.h:56: error: ‘NULL’ undeclared (first use in this
function)
include/linux/kallsyms.h:56: error: (Each undeclared identifier is
reported only once
include/linux/kallsyms.h:56: error: for each function it appears in.)
make[2]: *** [arch/powerpc/platforms/cell/spu_callbacks.o] Error 1
make[1]: *** [arch/powerpc/platforms/cell] Error 2
make: *** [arch/powerpc/platforms] Error 2

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index f73de6f..82de2fb 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -6,6 +6,7 @@
 #define _LINUX_KALLSYMS_H
 
 #include <linux/errno.h>
+#include <linux/stddef.h>
 
 #define KSYM_NAME_LEN 128
 #define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + (KSYM_NAME_LEN - 1) + \

--
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
