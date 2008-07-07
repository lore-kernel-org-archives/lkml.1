Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbYGGWXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbYGGWXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 18:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYGGWXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 18:23:10 -0400
Received: from www.tglx.de ([62.245.132.106]:54482 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbYGGWXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 18:23:09 -0400
Date: Tue, 8 Jul 2008 00:23:00 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: Uwe Kleine-Koenig <Uwe.Kleine-Koenig@digi.com>,
       Magnus Damm <magnus.damm@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] UIO: Change driver name of uio_pdrv
Message-ID: <20080707222300.GA5149@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,
I'm just about to use the generic UIO platform device driver in a
project. I noticed the driver registers itself simply as "uio". We
should choose a more unique name here. The oneliner below goes on top of
the other UIO patches you've got in your queue right now. This is not in
mainline yet.

Thanks,
Hans

-------------------------

The generic UIO platform device driver should be given a unique driver ID and
not just "uio". This is especially important since Magnus Damm announced a
similar driver named uio_pdrv_genirq. We should get the names right before
this hits mainline.

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
