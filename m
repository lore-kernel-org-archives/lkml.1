Return-Path: <linux-kernel-owner+w=401wt.eu-S1761955AbXFQXnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761955AbXFQXnb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 19:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760369AbXFQXmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 19:42:43 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:37893 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761932AbXFQXml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 19:42:41 -0400
Date: Mon, 18 Jun 2007 01:42:57 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] arch/i386/video/fbdev.c should #include <asm/fb.h>
Message-ID: <20070617234257.GE3588@stusta.de>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the prototypes for
it's global functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc4-mm2/arch/i386/video/fbdev.c.old	2007-06-17 15:48:25.000000000 +0200
+++ linux-2.6.22-rc4-mm2/arch/i386/video/fbdev.c	2007-06-17 15:48:53.000000000 +0200
@@ -11,6 +11,8 @@
 #include <linux/fb.h>
 #include <linux/pci.h>
 
+#include <asm/fb.h>
+
 int fb_is_primary_device(struct fb_info *info)
 {
 	struct device *device = info->device;

