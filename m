Return-Path: <linux-kernel-owner+w=401wt.eu-S2992724AbXDDIGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992724AbXDDIGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 04:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992726AbXDDIGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 04:06:40 -0400
Received: from mfo30.po.2iij.NET ([210.128.50.51]:1814 "EHLO mfo30.po.2iij.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992724AbXDDIGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 04:06:39 -0400
X-Greylist: delayed 2138 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Apr 2007 04:06:38 EDT
Date: Wed, 4 Apr 2007 16:29:34 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: Andrew Morton <akpm@osdl.org>
Cc: yoichi_yuasa@tripeaks.co.jp, "Maciej W. Rozycki" <macro@linux-mips.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mips <linux-mips@linux-mips.org>
Subject: [PATCH] Fixed build error on zs serial driver
Message-Id: <20070404162934.2635ef95.yoichi_yuasa@tripeaks.co.jp>
Organization: TriPeaks Corporation
X-Mailer: Sylpheed version 1.0.4 (GTK+ 1.2.10; i386-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch has fixed build error on zs serial driver.

drivers/tc/zs.c:73:24: error: asm/dec/tc.h: No such file or directory
make[2]: *** [drivers/tc/zs.o] Error 1

Yoichi

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

diff -pruN -X mips/Documentation/dontdiff mips-orig/drivers/tc/zs.c mips/drivers/tc/zs.c
--- mips-orig/drivers/tc/zs.c	2007-04-04 15:01:22.952507000 +0900
+++ mips/drivers/tc/zs.c	2007-04-04 15:15:37.861935500 +0900
@@ -70,7 +70,6 @@
 #include <asm/dec/machtype.h>
 #include <asm/dec/serial.h>
 #include <asm/dec/system.h>
-#include <asm/dec/tc.h>
 
 #ifdef CONFIG_KGDB
 #include <asm/kgdb.h>
