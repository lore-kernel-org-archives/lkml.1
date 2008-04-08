Return-Path: <linux-kernel-owner+w=401wt.eu-S1753746AbYDHDW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbYDHDW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 23:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbYDHDWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 23:22:19 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:58702 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbYDHDWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 23:22:18 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] export hid.h and hidraw.h to userspace
Date: Mon,  7 Apr 2008 23:22:16 -0400
Message-Id: <1207624936-16328-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.5.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have people whining about using these headers in userspace, and they have
__KERNEL__ markings which implies they're supposed to be exported.  I also
added the required linux/types.h include to hidraw.h since it uses the __u##
kernel types.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/linux/Kbuild   |    2 ++
 include/linux/hidraw.h |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 9cdd12a..346801b 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -209,7 +209,9 @@ unifdef-y += hdlcdrv.h
 unifdef-y += hdlc.h
 unifdef-y += hdreg.h
 unifdef-y += hdsmart.h
+unifdef-y += hid.h
 unifdef-y += hiddev.h
+unifdef-y += hidraw.h
 unifdef-y += hpet.h
 unifdef-y += i2c.h
 unifdef-y += i2c-dev.h
diff --git a/include/linux/hidraw.h b/include/linux/hidraw.h
index 0536f29..dbb5c8c 100644
--- a/include/linux/hidraw.h
+++ b/include/linux/hidraw.h
@@ -16,6 +16,7 @@
  */
 
 #include <linux/hid.h>
+#include <linux/types.h>
 
 struct hidraw_report_descriptor {
 	__u32 size;
-- 
1.5.4.4

