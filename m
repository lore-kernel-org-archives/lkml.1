Return-Path: <linux-kernel-owner+w=401wt.eu-S1754280AbYKXQnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbYKXQnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 11:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbYKXQnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 11:43:21 -0500
Received: from 89.6b.364a.static.theplanet.com ([74.54.107.137]:47191 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbYKXQnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 11:43:20 -0500
From: Mike Rapoport <mike@compulab.co.il>
To: lrg@slimlogic.co.uk
Cc: eric.miao@marvell.com, linux-kernel@vger.kernel.org,
       Mike Rapoport <mike@compulab.co.il>
Subject: [PATCH] regulator: da903x: add '\n' to error messages
Date: Mon, 24 Nov 2008 18:43:00 +0200
Message-Id: <1227544980-28694-1-git-send-email-mike@compulab.co.il>
X-Mailer: git-send-email 1.5.6.4
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Mike Rapoport <mike@compulab.co.il>
---
 drivers/regulator/da903x.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
index 773b29c..83101d6 100644
--- a/drivers/regulator/da903x.c
+++ b/drivers/regulator/da903x.c
@@ -102,7 +102,7 @@ static int da903x_set_ldo_voltage(struct regulator_dev *rdev,
 	uint8_t val, mask;
 
 	if (check_range(info, min_uV, max_uV)) {
-		pr_err("invalid voltage range (%d, %d) uV", min_uV, max_uV);
+		pr_err("invalid voltage range (%d, %d) uV\n", min_uV, max_uV);
 		return -EINVAL;
 	}
 
@@ -172,7 +172,7 @@ static int da9030_set_ldo1_15_voltage(struct regulator_dev *rdev,
 	int ret;
 
 	if (check_range(info, min_uV, max_uV)) {
-		pr_err("invalid voltage range (%d, %d) uV", min_uV, max_uV);
+		pr_err("invalid voltage range (%d, %d) uV\n", min_uV, max_uV);
 		return -EINVAL;
 	}
 
@@ -199,7 +199,7 @@ static int da9030_set_ldo14_voltage(struct regulator_dev *rdev,
 	int thresh;
 
 	if (check_range(info, min_uV, max_uV)) {
-		pr_err("invalid voltage range (%d, %d) uV", min_uV, max_uV);
+		pr_err("invalid voltage range (%d, %d) uV\n", min_uV, max_uV);
 		return -EINVAL;
 	}
 
@@ -248,7 +248,7 @@ static int da9034_set_dvc_voltage(struct regulator_dev *rdev,
 	int ret;
 
 	if (check_range(info, min_uV, max_uV)) {
-		pr_err("invalid voltage range (%d, %d) uV", min_uV, max_uV);
+		pr_err("invalid voltage range (%d, %d) uV\n", min_uV, max_uV);
 		return -EINVAL;
 	}
 
@@ -273,7 +273,7 @@ static int da9034_set_ldo12_voltage(struct regulator_dev *rdev,
 	uint8_t val, mask;
 
 	if (check_range(info, min_uV, max_uV)) {
-		pr_err("invalid voltage range (%d, %d) uV", min_uV, max_uV);
+		pr_err("invalid voltage range (%d, %d) uV\n", min_uV, max_uV);
 		return -EINVAL;
 	}
 
-- 
1.5.6.4

