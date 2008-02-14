Return-Path: <linux-kernel-owner+w=401wt.eu-S1765402AbYBNHZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765402AbYBNHZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 02:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756897AbYBNHZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 02:25:35 -0500
Received: from pip12.gyao.ne.jp ([61.122.117.250]:40916 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756873AbYBNHZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 02:25:35 -0500
Date: Thu, 14 Feb 2008 16:24:22 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] media: tuner-xc2028 depends on FW_LOADER.
Message-ID: <20080214072422.GE12436@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: "release_firmware" [drivers/media/video/tuner-xc2028.ko] undefined!
ERROR: "request_firmware" [drivers/media/video/tuner-xc2028.ko] undefined!

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 drivers/media/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 8f4a453..cb0b3fb 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -93,7 +93,7 @@ if VIDEO_TUNER_CUSTOMIZE
 
 config TUNER_XC2028
 	tristate "XCeive xc2028/xc3028 tuners"
-	depends on I2C
+	depends on I2C && FW_LOADER
 	default m if VIDEO_TUNER_CUSTOMIZE
 	help
 	  Say Y here to include support for the xc2028/xc3028 tuners.
