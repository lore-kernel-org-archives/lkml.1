Return-Path: <linux-kernel-owner+w=401wt.eu-S1756515AbYELPyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbYELPyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 11:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbYELPy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 11:54:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44209 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbYELPy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 11:54:28 -0400
Date: Mon, 12 May 2008 08:53:27 -0700
Message-Id: <200805121553.m4CFrRlj001730@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [GIT PULL] s390 types.h fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, please pull:

    git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-inttypes.git

H. Peter Anvin (1):
      types: s390: fix #ifdef reversal in <asm-s390/types.h>


diff --git a/include/asm-s390/types.h b/include/asm-s390/types.h
index 78dda03..0e959e2 100644
--- a/include/asm-s390/types.h
+++ b/include/asm-s390/types.h
@@ -10,9 +10,9 @@
 #define _S390_TYPES_H
 
 #ifndef __s390x__
-# include <asm-generic/int-l64.h>
-#else
 # include <asm-generic/int-ll64.h>
+#else
+# include <asm-generic/int-l64.h>
 #endif
 
 #ifndef __ASSEMBLY__
