Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbZIRUpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbZIRUpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758646AbZIRUph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:45:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44615 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979AbZIRUpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:45:12 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Wolfram Sang <w.sang@pengutronix.de>
Date: Fri, 18 Sep 2009 22:44:46 +0200
Message-Id: <1253306686-20616-5-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253306686-20616-1-git-send-email-w.sang@pengutronix.de>
References: <1253306686-20616-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: [PATCH 4/4] regulator/driver: be more specific in nanodoc for is_enabled
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the possibility that is_enabled may also return with negative
errorcodes.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 include/linux/regulator/driver.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 225f733..2b69b47 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -37,7 +37,8 @@ enum regulator_status {
  *
  * @enable: Configure the regulator as enabled.
  * @disable: Configure the regulator as disabled.
- * @is_enabled: Return 1 if the regulator is enabled, 0 otherwise.
+ * @is_enabled: Return 1 if the regulator is enabled, 0 if not.
+ *		May also return negative errno.
  *
  * @set_voltage: Set the voltage for the regulator within the range specified.
  *               The driver should select the voltage closest to min_uV.
-- 
1.6.3.3

