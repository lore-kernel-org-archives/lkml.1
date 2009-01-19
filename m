Return-Path: <linux-kernel-owner+w=401wt.eu-S1757900AbZASSlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900AbZASSlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 13:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbZASSlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 13:41:07 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:9888 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbZASSlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 13:41:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=XYwBlrdzE4x3dinFNFoY3UNvB/ptCIDFa/58MqwvNd5tVt+HN1X1W3FTp0EDrN1T0q
         f12qry8RXiD6dcPdev9aMcSaVX2XnRxfRlE1fEDu78uMWaoWT76KE+V2M3MOjwJGbm/j
         56JegZpsnfREtCOyU7GTey+lOgMBEIY1zeE7I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/2] frv: remove <asm/ide.h>
Date: Mon, 19 Jan 2009 19:33:11 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-next-20090116; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901191933.11757.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] frv: remove <asm/ide.h>

* Remove superfluous <asm/{setup,io,irq}.h> includes.

* Remove <asm/ide.h>.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/asm-frv/ide.h |   24 ------------------------
 include/linux/ide.h   |    4 ++--
 2 files changed, 2 insertions(+), 26 deletions(-)

Index: b/include/asm-frv/ide.h
===================================================================
--- a/include/asm-frv/ide.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/* ide.h: FRV IDE declarations
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_IDE_H
-#define _ASM_IDE_H
-
-#ifdef __KERNEL__
-
-#include <asm/setup.h>
-#include <asm/io.h>
-#include <asm/irq.h>
-
-#include <asm-generic/ide_iops.h>
-
-#endif /* __KERNEL__ */
-#endif /* _ASM_IDE_H */
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -193,8 +193,8 @@ static inline void ide_std_init_ports(hw
 	hw->io_ports.ctl_addr = ctl_addr;
 }
 
-#if defined(CONFIG_ARM) || defined(CONFIG_FRV) || defined(CONFIG_M68K) || \
-    defined(CONFIG_MIPS) || defined(CONFIG_MN10300) || defined(CONFIG_PARISC) \
+#if defined(CONFIG_ARM) || defined(CONFIG_M68K) || defined(CONFIG_MIPS) || \
+    defined(CONFIG_MN10300) || defined(CONFIG_PARISC) \
     || defined(CONFIG_PPC) || defined(CONFIG_SPARC) || defined(CONFIG_SPARC64)
 #include <asm/ide.h>
 #else
