Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbZHUMBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbZHUMBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 08:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753814AbZHUMBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 08:01:07 -0400
Received: from mail.df.lth.se ([194.47.250.12]:49618 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750873AbZHUMBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 08:01:06 -0400
From: Linus Walleij <linus.wallei@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] Fix some regulator documentation
Date: Fri, 21 Aug 2009 14:00:57 +0200
Message-Id: <1250856057-10504-1-git-send-email-linus.wallei@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@stericsson.com>

This fixes a spelling error and an API function signature mismatch
in the regulator documentation.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 Documentation/power/regulator/overview.txt  |    2 +-
 Documentation/power/regulator/regulator.txt |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/power/regulator/overview.txt b/Documentation/power/regulator/overview.txt
index 0cded69..50b8fa8 100644
--- a/Documentation/power/regulator/overview.txt
+++ b/Documentation/power/regulator/overview.txt
@@ -29,7 +29,7 @@ Some terms used in this document:-
 
 
   o PMIC         - Power Management IC. An IC that contains numerous regulators
-                   and often contains other susbsystems.
+                   and often contains other subsystems.
 
 
   o Consumer     - Electronic device that is supplied power by a regulator.
diff --git a/Documentation/power/regulator/regulator.txt b/Documentation/power/regulator/regulator.txt
index 4200acc..3f8b528 100644
--- a/Documentation/power/regulator/regulator.txt
+++ b/Documentation/power/regulator/regulator.txt
@@ -10,8 +10,9 @@ Registration
 
 Drivers can register a regulator by calling :-
 
-struct regulator_dev *regulator_register(struct device *dev,
-	struct regulator_desc *regulator_desc);
+struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
+	struct device *dev, struct regulator_init_data *init_data,
+	void *driver_data);
 
 This will register the regulators capabilities and operations to the regulator
 core.
-- 
1.6.2.5

