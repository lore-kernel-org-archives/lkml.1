Return-Path: <linux-kernel-owner+w=401wt.eu-S1755809AbZF1Qco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbZF1Qco (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756190AbZF1Q1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:27:33 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1104 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582AbZF1Q1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:31 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       lm-sensors@lm-sensors.org
Subject: [PATCH 18/62] drivers/hwmon/sht15.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:23 -0700
Message-Id: <b74f45f84ee741d41ab6938ea07fed85ee79b0a2.1246173681.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/hwmon/sht15.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
index 56cd600..6290a25 100644
--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -257,7 +257,7 @@ static inline int sht15_update_single_val(struct sht15_data *data,
 				 (data->flag == SHT15_READING_NOTHING),
 				 msecs_to_jiffies(timeout_msecs));
 	if (ret == 0) {/* timeout occurred */
-		disable_irq_nosync(gpio_to_irq(data->pdata->gpio_data));;
+		disable_irq_nosync(gpio_to_irq(data->pdata->gpio_data));
 		sht15_connection_reset(data);
 		return -ETIME;
 	}
-- 
1.6.3.1.10.g659a0.dirty

