Return-Path: <linux-kernel-owner+w=401wt.eu-S1758301AbYC3XIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301AbYC3XIS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 19:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756471AbYC3XGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 19:06:07 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:58510 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756398AbYC3XGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 19:06:05 -0400
Date: Mon, 31 Mar 2008 02:05:52 +0300
From: Adrian Bunk <bunk@kernel.org>
To: kkeil@suse.de
Cc: isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org,
       "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [2.6 patch] include/linux/isdn.h: remove dead code
Message-ID: <20080330230552.GU28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove the usage of a nonexisting kconfig variable.

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 1 Mar 2008

 include/linux/isdn.h |    6 ------
 1 file changed, 6 deletions(-)

68dcdff8287b565d34ba8b3bb1a608a0a0b3a3fd foobar
diff --git a/include/linux/isdn.h b/include/linux/isdn.h
index 9cb2855..44cd663 100644
--- a/include/linux/isdn.h
+++ b/include/linux/isdn.h
@@ -16,14 +16,8 @@
 
 #include <linux/ioctl.h>
 
-#ifdef CONFIG_COBALT_MICRO_SERVER
-/* Save memory */
-#define ISDN_MAX_DRIVERS    2
-#define ISDN_MAX_CHANNELS   8
-#else
 #define ISDN_MAX_DRIVERS    32
 #define ISDN_MAX_CHANNELS   64
-#endif
 
 /* New ioctl-codes */
 #define IIOCNETAIF  _IO('I',1)

