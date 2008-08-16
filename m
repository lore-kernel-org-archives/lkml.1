Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbYHPXv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbYHPXv6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 19:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbYHPXvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 19:51:40 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:14173 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860AbYHPXvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 19:51:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=aOwn1WMfx4duGgevjK4vS7ajYf2WtRv44535PfFKI+ubwZ2Pya7dIgnziVkobJUd1p
         Hf4x39acDRkAsmjqqgHZCLgU9xTFjSfTDBXoKWcX20HIP2In80898csTH/sRJJw6kfVQ
         SPQy9PzxFgXHnKx0B98220Lqxi6Ex2pG2ro8o=
Date: Sun, 17 Aug 2008 07:51:26 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: santiago@crfreenet.org
Subject: [DRIVERS/VIDEO] removed unused #include <version.h>
Cc: linux-kernel@vger.kernel.org
Message-Id: <20080817073553.1636.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver(s) below do not use LINUX_VERSION_CODE nor KERNEL_VERSION.
  drivers/video/arkfb.c
  drivers/video/s3fb.c
  drivers/video/vt8623fb.c

This patch removes the said #include <version.h>.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/drivers/video/arkfb.c b/drivers/video/arkfb.c
index 4bd569e..314d186 100644
--- a/drivers/video/arkfb.c
+++ b/drivers/video/arkfb.c
@@ -11,7 +11,6 @@
  *  Code is based on s3fb
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
diff --git a/drivers/video/s3fb.c b/drivers/video/s3fb.c
index 8361bd0..4dcec48 100644
--- a/drivers/video/s3fb.c
+++ b/drivers/video/s3fb.c
@@ -11,7 +11,6 @@
  * which is based on the code of neofb.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
diff --git a/drivers/video/vt8623fb.c b/drivers/video/vt8623fb.c
index 34aae7a..3df17dc 100644
--- a/drivers/video/vt8623fb.c
+++ b/drivers/video/vt8623fb.c
@@ -12,7 +12,6 @@
  * (http://davesdomain.org.uk/viafb/)
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>


