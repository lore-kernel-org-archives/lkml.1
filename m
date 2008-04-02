Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbYDBLXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbYDBLXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 07:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbYDBLXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 07:23:40 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:55130 "HELO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752902AbYDBLXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:23:39 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-2.tower-164.messagelabs.com!1207135417!9420870!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
Subject: [PATCH] fix typo "thier" -> "their"
Date: Wed,  2 Apr 2008 13:23:19 +0200
Message-Id: <1207135399-4516-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.4.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Apr 2008 11:23:21.0119 (UTC) FILETIME=[F50A02F0:01C894B3]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15824.006
X-TM-AS-Result: No--8.020000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Cc: trivial@kernel.org
---
 drivers/base/sys.c    |    2 +-
 drivers/pnp/manager.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 8e13fd9..84be616 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -283,7 +283,7 @@ void sysdev_unregister(struct sys_device * sysdev)
  *	and the class driver.
  *
  *	Note: The list is iterated in reverse order, so that we shut down
- *	child devices before we shut down thier parents. The list ordering
+ *	child devices before we shut down their parents. The list ordering
  *	is guaranteed by virtue of the fact that child devices are registered
  *	after their parents.
  */
diff --git a/drivers/pnp/manager.c b/drivers/pnp/manager.c
index c28caf2..745a668 100644
--- a/drivers/pnp/manager.c
+++ b/drivers/pnp/manager.c
@@ -382,7 +382,7 @@ fail:
  * @res: pointer to the new resource config
  * @mode: 0 or PNP_CONFIG_FORCE
  *
- * This function can be used by drivers that want to manually set thier resources.
+ * This function can be used by drivers that want to manually set their resources.
  */
 int pnp_manual_config_dev(struct pnp_dev *dev, struct pnp_resource_table *res,
 			  int mode)
-- 
1.5.4.5

