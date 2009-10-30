Return-Path: <linux-kernel-owner+w=401wt.eu-S932936AbZJ3V2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936AbZJ3V2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 17:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932918AbZJ3V2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 17:28:18 -0400
Received: from 139.254.232.72.static.reverse.ltdomains.com ([72.232.254.139]:45416
	"EHLO liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932900AbZJ3V2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 17:28:18 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: trivial@kernel.org
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Randy Dunlap <rdunlap@xenotime.net>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org
Subject: [PATCH] trivial: some fixes in spi documentation
Date: Fri, 30 Oct 2009 19:28:14 -0200
Message-Id: <1256938094-8137-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 Documentation/spi/spi-summary |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/spi/spi-summary b/Documentation/spi/spi-summary
index deab51d..607aa97 100644
--- a/Documentation/spi/spi-summary
+++ b/Documentation/spi/spi-summary
@@ -121,7 +121,7 @@ active.  So the master must set the clock to inactive before selecting
 a slave, and the slave can tell the chosen polarity by sampling the
 clock level when its select line goes active.  That's why many devices
 support for example both modes 0 and 3:  they don't care about polarity,
-and alway clock data in/out on rising clock edges.
+and always clock data in/out on rising clock edges.
 
 
 How do these driver programming interfaces work?
@@ -236,7 +236,7 @@ And SOC-specific utility code might look something like:
 		struct mysoc_spi_data *pdata2;
 
 		pdata2 = kmalloc(sizeof *pdata2, GFP_KERNEL);
-		*pdata2 = pdata;
+		*pdata2 = *pdata;
 		...
 		if (n == 2) {
 			spi2->dev.platform_data = pdata2;
@@ -427,8 +427,8 @@ any more such messages.
     it, should only be used with small amounts of data where the
     cost of an extra copy may be ignored.  It's designed to support
     common RPC-style requests, such as writing an eight bit command
-    and reading a sixteen bit response -- spi_w8r16() being one its
-    wrappers, doing exactly that.
+    and reading a sixteen bit response -- spi_w8r16() being one of
+    its wrappers, doing exactly that.
 
 Some drivers may need to modify spi_device characteristics like the
 transfer mode, wordsize, or clock rate.  This is done with spi_setup(),
-- 
1.6.3.3

