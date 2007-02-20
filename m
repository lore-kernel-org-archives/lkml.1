Return-Path: <linux-kernel-owner+w=401wt.eu-S965614AbXBTASf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965614AbXBTASf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965589AbXBTASZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:18:25 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36092 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965595AbXBTAHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:07:33 -0500
Date: Tue, 20 Feb 2007 01:07:29 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, v4l-dvb-maintainer@linuxtv.org
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] make dvb_usb_gl861_debug static
Message-ID: <20070220000729.GV13958@stusta.de>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 05:14:08AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-rc6-mm3:
>...
>  git-dvb.patch
>...
>  git trees.
>...

This patch makes the needlessly global dvb_usb_gl861_debug static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.20-mm1/drivers/media/dvb/dvb-usb/gl861.c.old	2007-02-17 17:49:03.000000000 +0100
+++ linux-2.6.20-mm1/drivers/media/dvb/dvb-usb/gl861.c	2007-02-17 17:49:20.000000000 +0100
@@ -12,7 +12,7 @@
 #include "qt1010.h"
 
 /* debug */
-int dvb_usb_gl861_debug;
+static int dvb_usb_gl861_debug;
 module_param_named(debug,dvb_usb_gl861_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=rc (or-able))." DVB_USB_DEBUG_STATUS);
 

