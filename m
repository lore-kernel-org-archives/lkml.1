Return-Path: <linux-kernel-owner+w=401wt.eu-S932307AbXGQLtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307AbXGQLtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 07:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758678AbXGQLs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 07:48:57 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:45949 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758086AbXGQLs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 07:48:56 -0400
Date: Tue, 17 Jul 2007 15:47:41 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org, v4l-dvb-maintainer@linuxtv.org
Cc: linux-kernel@vger.kernel.org, hverkuil@xs4all.nl
Subject: [PATCH] ivtv: don't recompile needlessly
Message-ID: <20070717114741.GC25083@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Driver prints 3l33t banner including kernel version.
Could we _please_ never do this in future.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 drivers/media/video/ivtv/ivtv-driver.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/media/video/ivtv/ivtv-driver.c
+++ b/drivers/media/video/ivtv/ivtv-driver.c
@@ -56,7 +56,6 @@
 #include "ivtv-gpio.h"
 #include "ivtv-yuv.h"
 
-#include <linux/vermagic.h>
 #include <media/tveeprom.h>
 #include <media/v4l2-chip-ident.h>
 
@@ -1315,7 +1314,7 @@ static struct pci_driver ivtv_pci_driver = {
 static int module_start(void)
 {
 	printk(KERN_INFO "ivtv:  ==================== START INIT IVTV ====================\n");
-	printk(KERN_INFO "ivtv:  version %s (" VERMAGIC_STRING ") loading\n", IVTV_VERSION);
+	printk(KERN_INFO "ivtv:  version %s loading\n", IVTV_VERSION);
 
 	memset(ivtv_cards, 0, sizeof(ivtv_cards));
 

