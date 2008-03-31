Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbYCaJIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbYCaJIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 05:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbYCaJHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 05:07:51 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:51796 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589AbYCaJHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 05:07:51 -0400
Date: Mon, 31 Mar 2008 12:07:36 +0300
From: Adrian Bunk <bunk@kernel.org>
To: tglx@linutronix.de, adaplas@gmail.com
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [2.6.25 patch] arch/x86/video/fbdev.c: add MODULE_LICENSE
Message-ID: <20080331090736.GD28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the missing MODULE_LICENSE("GPL").

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
745c0b8d5884386442d4765cae6330bfe7d459b2 diff --git a/arch/x86/video/fbdev.c b/arch/x86/video/fbdev.c
index 48fb38d..3cf2e9b 100644
--- a/arch/x86/video/fbdev.c
+++ b/arch/x86/video/fbdev.c
@@ -30,3 +30,5 @@ int fb_is_primary_device(struct fb_info *info)
 	return retval;
 }
 EXPORT_SYMBOL(fb_is_primary_device);
+
+MODULE_LICENSE("GPL");

