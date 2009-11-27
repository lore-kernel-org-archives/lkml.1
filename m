Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbZK0O5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbZK0O5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 09:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbZK0O5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 09:57:31 -0500
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:33126 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbZK0O5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 09:57:31 -0500
X-RZG-AUTH: :IW0NeWC7b/q2i6W/qstXb1SBUuFnrGohavlCkce+Ub5QXMSOpHp3JjHzw46gmg==
X-RZG-CLASS-ID: mo05
From: Stefan Roese <sr@denx.de>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: core.c: Small coding style cleanup (indentation fixup)
Date: Fri, 27 Nov 2009 15:56:34 +0100
Message-Id: <1259333794-30480-1-git-send-email-sr@denx.de>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Roese <sr@denx.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index efe568d..65f819a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -388,7 +388,7 @@ static ssize_t regulator_total_uA_show(struct device *dev,
 
 	mutex_lock(&rdev->mutex);
 	list_for_each_entry(regulator, &rdev->consumer_list, list)
-	    uA += regulator->uA_load;
+		uA += regulator->uA_load;
 	mutex_unlock(&rdev->mutex);
 	return sprintf(buf, "%d\n", uA);
 }
@@ -563,7 +563,7 @@ static void drms_uA_update(struct regulator_dev *rdev)
 
 	/* calc total requested load */
 	list_for_each_entry(sibling, &rdev->consumer_list, list)
-	    current_uA += sibling->uA_load;
+		current_uA += sibling->uA_load;
 
 	/* now get the optimum mode for our new total regulator load */
 	mode = rdev->desc->ops->get_optimum_mode(rdev, input_uV,
@@ -1783,7 +1783,7 @@ int regulator_set_optimum_mode(struct regulator *regulator, int uA_load)
 
 	/* calc total requested load for this regulator */
 	list_for_each_entry(consumer, &rdev->consumer_list, list)
-	    total_uA_load += consumer->uA_load;
+		total_uA_load += consumer->uA_load;
 
 	mode = rdev->desc->ops->get_optimum_mode(rdev,
 						 input_uV, output_uV,
@@ -1852,9 +1852,9 @@ static void _notifier_call_chain(struct regulator_dev *rdev,
 
 	/* now notify regulator we supply */
 	list_for_each_entry(_rdev, &rdev->supply_list, slist) {
-	  mutex_lock(&_rdev->mutex);
-	  _notifier_call_chain(_rdev, event, data);
-	  mutex_unlock(&_rdev->mutex);
+		mutex_lock(&_rdev->mutex);
+		_notifier_call_chain(_rdev, event, data);
+		mutex_unlock(&_rdev->mutex);
 	}
 }
 
-- 
1.6.5.2

