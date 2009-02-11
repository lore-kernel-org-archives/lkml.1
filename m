Return-Path: <linux-kernel-owner+w=401wt.eu-S1757138AbZBKPcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138AbZBKPcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 10:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZBKPcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 10:32:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37970 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751774AbZBKPcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:32:09 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Suggest use of datasheet supply or pin names for consumers
Date: Wed, 11 Feb 2009 15:32:06 +0000
Message-Id: <1234366326-32148-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the documentation to suggest the use of datasheet names for
the supplies requested by regulator consumers. Doing this makes it
easier to tie the design for a given platform up with the requirements
of the driver for a consumer.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index b85e4a9..d55a25a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -925,9 +925,12 @@ overflow_err:
  * @id: Supply name or regulator ID.
  *
  * Returns a struct regulator corresponding to the regulator producer,
- * or IS_ERR() condition containing errno.  Use of supply names
- * configured via regulator_set_device_supply() is strongly
- * encouraged.
+ * or IS_ERR() condition containing errno.
+ *
+ * Use of supply names configured via regulator_set_device_supply() is
+ * strongly encouraged.  It is recommended that the supply name used
+ * should match the name used for the supply and/or the relevant
+ * device pins in the datasheet.
  */
 struct regulator *regulator_get(struct device *dev, const char *id)
 {
-- 
1.5.6.5

