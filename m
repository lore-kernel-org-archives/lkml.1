Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbYISRjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbYISRjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 13:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbYISRjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 13:39:33 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:45764 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754741AbYISRjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 13:39:32 -0400
Subject: [PATCH 2/6] regulator: Fix typo
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Fri, 19 Sep 2008 18:39:32 +0100
Message-Id: <1221845972.6892.136.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes a small typo.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Liam Girdwood <lrg@slimlogic.co.uk>
---
 include/linux/regulator/driver.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index e7cbeda..2a37528 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -51,7 +51,7 @@ struct regulator_ops {
 					  int output_uV, int load_uA);
 
 	/* the operations below are for configuration of regulator state when
-	 * it's parent PMIC enters a global STANBY/HIBERNATE state */
+	 * it's parent PMIC enters a global STANDBY/HIBERNATE state */
 
 	/* set regulator suspend voltage */
 	int (*set_suspend_voltage) (struct regulator_dev *, int uV);
-- 
1.5.4.3


