Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbYIRVD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbYIRVD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 17:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbYIRVDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 17:03:19 -0400
Received: from www.tglx.de ([62.245.132.106]:55868 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773AbYIRVDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 17:03:19 -0400
Date: Thu, 18 Sep 2008 23:03:07 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <ukleinek@strlen.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] UIO: Resend: Change driver name of uio_pdrv
Message-ID: <20080918210306.GC2991@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below was already discussed and accepted:
http://lkml.org/lkml/2008/7/7/409

It somehow got lost (probably because I forgot it when I sent my queue
to Greg...). So, here it is again:

-------------8<------------------------

The generic UIO platform device driver should be given a unique driver ID and
not just "uio". This is especially important since we now have a similar driver
named uio_pdrv_genirq. Currently, there's no user of this driver in the
mainline kernel.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>
---
 drivers/uio/uio_pdrv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.26-rc/drivers/uio/uio_pdrv.c
===================================================================
--- linux-2.6.26-rc.orig/drivers/uio/uio_pdrv.c	2008-07-07 23:57:44.000000000 +0200
+++ linux-2.6.26-rc/drivers/uio/uio_pdrv.c	2008-07-07 23:58:26.000000000 +0200
@@ -12,7 +12,7 @@
 #include <linux/uio_driver.h>
 #include <linux/stringify.h>
 
-#define DRIVER_NAME "uio"
+#define DRIVER_NAME "uio_pdrv"
 
 struct uio_platdata {
 	struct uio_info *uioinfo;
