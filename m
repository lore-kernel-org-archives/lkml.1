Return-Path: <linux-kernel-owner+w=401wt.eu-S1759494AbXH3KpC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494AbXH3KpC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 06:45:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbXH3Koy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 06:44:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57269 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbXH3Kox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 06:44:53 -0400
Date: Thu, 30 Aug 2007 12:40:38 +0200
From: andre@finow14.de
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andre Haupt <andre@finow14.de>,
       rmk@arm.linux.org.uk
Subject: [KJ][patch 3/3] VIDC20: use abs() from kernel.h instead of own definition
Message-ID: <20070830104038.GD14925@ahaupt-debian-vm.localdomain>
References: <20070830102551.131398783@finow14.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="vidc20_use_abs_from_kernel_h.patch"
User-Agent: quilt/0.45-1
X-Provags-ID: V01U2FsdGVkX1/Br2dwWxIUXrqFXN5etmhHLtNOHOEwQs9vHn9
 jNBi6BgCS+3H80nu9OXix3oNU2JMOWxx+H/ykfBGiiQNbv6yz7
 Ywjs9Xt6BkhMJRQ/muMEarl7klWOeX9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Haupt <andre@finow14.de>
Signed-off-by: Andre Haupt <andre@finow14.de>
---
Index: linus/sound/oss/vidc.c
===================================================================
--- linus.orig/sound/oss/vidc.c	2007-08-30 11:57:13.000000000 +0200
+++ linus/sound/oss/vidc.c	2007-08-30 11:57:53.000000000 +0200
@@ -185,8 +185,6 @@ static unsigned int vidc_audio_set_forma
 	return vidc_audio_format;
 }
 
-#define my_abs(i) ((i)<0 ? -(i) : (i))
-
 static int vidc_audio_set_speed(int dev, int rate)
 {
 	if (rate) {
@@ -214,8 +212,8 @@ static int vidc_audio_set_speed(int dev,
 		rate_ext = VIDC_SOUND_CLOCK_EXT / hwrate_ext;
 
 		/* Chose between external and internal clock */
-		diff_int = my_abs(rate_ext-rate);
-		diff_ext = my_abs(rate_int-rate);
+		diff_int = abs(rate_ext-rate);
+		diff_ext = abs(rate_int-rate);
 		if (diff_ext < diff_int) {
 			/*printk("VIDC: external %d %d %d\n", rate, rate_ext, hwrate_ext);*/
 			hwrate=hwrate_ext;

--
