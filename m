Return-Path: <linux-kernel-owner+w=401wt.eu-S1759229AbYGGWBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759229AbYGGWBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 18:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758663AbYGGWAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 18:00:54 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:6550 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758255AbYGGWAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 18:00:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=pcjyfdBNwpwF+klrCFgo58IUpnABtJ9WmGBQpEhsWnIXRzuXWXwaGum8UY0ZlYwL2B
         qUd8n41geXmrwEdquf69yEok6oNggBADAoLVfAdDkvl7NBCUoaZt0xqzSgKkxnmHxX23
         CtbR6m4NveixtYEVlcuc5OtjPrmxoYgFanyT0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/10] ide: fix <asm-xtensa/ide.h>
Date: Mon, 7 Jul 2008 23:52:56 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Chris Zankel <chris@zankel.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807072352.56126.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Add missing <asm-generic/ide_iops.h> include.

While at it:

* Remove needless ide_default_{irq,io_base}() inlines.

Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/asm-xtensa/ide.h |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

Index: b/include/asm-xtensa/ide.h
===================================================================
--- a/include/asm-xtensa/ide.h
+++ b/include/asm-xtensa/ide.h
@@ -19,17 +19,8 @@
 # define MAX_HWIFS	1
 #endif
 
-static __inline__ int ide_default_irq(unsigned long base)
-{
-	/* Unsupported! */
-  	return 0;
-}
-
-static __inline__ unsigned long ide_default_io_base(int index)
-{
-	/* Unsupported! */
-  	return 0;
-}
+#include <asm-generic/ide_iops.h>
 
 #endif	/* __KERNEL__ */
+
 #endif	/* _XTENSA_IDE_H */
