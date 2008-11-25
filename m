Return-Path: <linux-kernel-owner+w=401wt.eu-S1752626AbYKYIUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbYKYIUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 03:20:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbYKYIT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 03:19:58 -0500
Received: from 89.6b.364a.static.theplanet.com ([74.54.107.137]:38988 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbYKYIT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 03:19:57 -0500
From: Mike Rapoport <mike@compulab.co.il>
To: lrg@slimlogic.co.uk
Cc: linux-kernel@vger.kernel.org, Mike Rapoport <mike@compulab.co.il>
Subject: [PATCH] regulator: da903x: make da903x_is_enabled return 0 or 1
Date: Tue, 25 Nov 2008 10:19:52 +0200
Message-Id: <1227601192-23348-1-git-send-email-mike@compulab.co.il>
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
 drivers/regulator/da903x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
index 83101d6..fe77730 100644
--- a/drivers/regulator/da903x.c
+++ b/drivers/regulator/da903x.c
@@ -159,7 +159,7 @@ static int da903x_is_enabled(struct regulator_dev *rdev)
 	if (ret)
 		return ret;
 
-	return reg_val & (1 << info->enable_bit);
+	return !!(reg_val & (1 << info->enable_bit));
 }
 
 /* DA9030 specific operations */
-- 
1.5.6.4

