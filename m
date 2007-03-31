Return-Path: <linux-kernel-owner+w=401wt.eu-S1751766AbXCaHX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766AbXCaHX6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 03:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbXCaHXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 03:23:41 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:1423 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbXCaHXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 03:23:32 -0400
From: divy@chelsio.com
Subject: [PATCH 2.6.21 4/4] cxgb3 - Firwmare update
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Date: Sat, 31 Mar 2007 00:23:30 -0700
Message-ID: <20070331072330.4748.57940.stgit@localhost.localdomain>
User-Agent: StGIT/0.12
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

Introduce FW micro version.
Bump up FW version to 3.3.0

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/cxgb3_main.c |    4 ++--
 drivers/net/cxgb3/version.h    |    5 ++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/cxgb3/cxgb3_main.c b/drivers/net/cxgb3/cxgb3_main.c
index 512daf7..26240fd 100644
--- a/drivers/net/cxgb3/cxgb3_main.c
+++ b/drivers/net/cxgb3/cxgb3_main.c
@@ -721,7 +721,7 @@ static void bind_qsets(struct adapter *a
 	}
 }
 
-#define FW_FNAME "t3fw-%d.%d.bin"
+#define FW_FNAME "t3fw-%d.%d.%d.bin"
 
 static int upgrade_fw(struct adapter *adap)
 {
@@ -731,7 +731,7 @@ static int upgrade_fw(struct adapter *ad
 	struct device *dev = &adap->pdev->dev;
 
 	snprintf(buf, sizeof(buf), FW_FNAME, FW_VERSION_MAJOR,
-		 FW_VERSION_MINOR);
+		 FW_VERSION_MINOR, FW_VERSION_MICRO);
 	ret = request_firmware(&fw, buf, dev);
 	if (ret < 0) {
 		dev_err(dev, "could not upgrade firmware: unable to load %s\n",
diff --git a/drivers/net/cxgb3/version.h b/drivers/net/cxgb3/version.h
index 82278f8..042e27e 100644
--- a/drivers/net/cxgb3/version.h
+++ b/drivers/net/cxgb3/version.h
@@ -36,6 +36,9 @@
 #define DRV_NAME "cxgb3"
 /* Driver version */
 #define DRV_VERSION "1.0-ko"
+
+/* Firmware version */
 #define FW_VERSION_MAJOR 3
-#define FW_VERSION_MINOR 2
+#define FW_VERSION_MINOR 3
+#define FW_VERSION_MICRO 0
 #endif				/* __CHELSIO_VERSION_H */
