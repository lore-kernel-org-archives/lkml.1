Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbXJWTjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbXJWTjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 15:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbXJWTjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 15:39:06 -0400
Received: from mail.gmx.net ([213.165.64.20]:40374 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752115AbXJWTjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 15:39:05 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1+Wrohu4hSWspA3DXOm0WlspS7um7hoh/gPQNHj/M
	CUVe/YEmTOG297
From: Helge Deller <deller@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] usb/core/message.c: scatterlist include fix
Date: Tue, 23 Oct 2007 21:37:55 +0200
User-Agent: KMail/1.9.7
X-Face: &[jmHH-Dw>Aj):"[/t-VasJu+(5eP`/LEckV7V"JV,!nBy[6(/?#8M>x`5xzg/7:FkM.l@
	13<&9'nfV3"OkD~P)@j{P2=(uB7J(){:CcrM2jZeA+IBq?FUTp3c8Y{t+k<95mZf~[v"':
	t"f6wKtHUPFB&/]Z5^?9~IQs=16R;Pg"NS9JD=DK!ft&4b@S~&q/MfI3;qWqlg7Q1==jS4
	9V5OJkm$WQ[dc^_Y']DvibvMjizUZ]+'Jd4UnM><yrT}Rw(
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710232137.55661.deller@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes following bug when building for parisc-linux:

drivers/usb/core/message.c: In function `usb_sg_init':
drivers/usb/core/message.c:440: error: implicit declaration of function `sg_virt'

Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 90d64a8..aae0196 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -13,7 +13,7 @@
 #include <linux/device.h>
 #include <linux/usb/quirks.h>
 #include <asm/byteorder.h>
-#include <asm/scatterlist.h>
+#include <linux/scatterlist.h>
 
 #include "hcd.h"	/* for usbcore internals */
 #include "usb.h"
