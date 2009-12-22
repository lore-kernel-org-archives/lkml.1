Return-Path: <linux-kernel-owner+w=401wt.eu-S1751289AbZLVI32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbZLVI32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 03:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbZLVI31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 03:29:27 -0500
Received: from mail.gmx.net ([213.165.64.20]:50855 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750859AbZLVI31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 03:29:27 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+iUIxwk32imIDYw9O4SKaHYlhGmq8Suh+REsQI//
	ykRvx5vZMoMKe2
From: peterhuewe@gmx.de
To: Jiri Kosina <trivial@kernel.org>
Cc: kernel-janitors@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>,
       Jon Masters <jcm@jonmasters.org>,
       =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] misc: add __init/__exit macros to drivers/misc/hwlat_detector.c
Date: Tue, 22 Dec 2009 09:29:23 +0100
Message-Id: <1261470564-23754-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.6.4.4
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

Trivial patch which adds the __init/__exit macros to the module_init/
module_exit functions of

drivers/misc/hwlat_detector.c

Please have a look at the small patch and either pull it through
your tree, or please ack' it so Jiri can pull it through the trivial
tree.

Patch against linux-next-tree, 22. Dez 08:38:18 CET 2009
but also present in linus tree.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/misc/hwlat_detector.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/hwlat_detector.c b/drivers/misc/hwlat_detector.c
index e02d8e1..fd6fa6f 100644
--- a/drivers/misc/hwlat_detector.c
+++ b/drivers/misc/hwlat_detector.c
@@ -1163,7 +1163,7 @@ static void free_debugfs(void)
 /**
  * detector_init - Standard module initialization code
  */
-static int detector_init(void)
+static int __init detector_init(void)
 {
 	int ret = -ENOMEM;
 
@@ -1192,7 +1192,7 @@ out:
 /**
  * detector_exit - Standard module cleanup code
  */
-static void detector_exit(void)
+static void __exit detector_exit(void)
 {
 	if (enabled) {
 		enabled = 0;
-- 
1.6.4.4

