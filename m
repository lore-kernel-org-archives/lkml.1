Return-Path: <linux-kernel-owner+w=401wt.eu-S1756927AbYDNSxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbYDNSxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965269AbYDNSs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:48:27 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:43783 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965270AbYDNSsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:48:23 -0400
Date: Mon, 14 Apr 2008 21:40:58 +0300
From: Adrian Bunk <bunk@kernel.org>
To: kkeil@suse.de
Cc: isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org,
       "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [2.6 patch] include/linux/isdn.h: remove dead code
Message-ID: <20080414184058.GJ6695@cs181133002.pp.htv.fi>
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
- 31 Mar 2008
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


