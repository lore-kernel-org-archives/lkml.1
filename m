Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbYHMA2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbYHMA2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 20:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbYHMA0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 20:26:45 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:49095 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbYHMA0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 20:26:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Zhfle+mQAtYdKrz8olS5pGgkDe3rVRXfvPNyyddNfoeaj7IhBq+vnuclcRwVqUypX2
         uGv7QIUMICjmjp4ieM26MCfzaM5C+APPO+3yva0NpWlnHZ77uTdH/243VHb9Gup0DIsE
         E9YxLaJZ7D7TRFilIfVEUq4UeVNeXh9KoHVGk=
Subject: [PATCH 07/22] h8300: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 17:26:38 -0700
Message-Id: <1218587198.30194.80.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
The prerequisite patches have landed in Linus' tree now.

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
1.6.0.rc2.233.g3cb9d


