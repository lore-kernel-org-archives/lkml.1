Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbYKFLYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbYKFLYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 06:24:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbYKFLX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 06:23:57 -0500
Received: from oceanus.site5.com ([67.43.13.2]:60108 "EHLO oceanus.site5.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbYKFLX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 06:23:57 -0500
From: Mike Rapoport <mike@compulab.co.il>
To: sameo@openedhand.com
Cc: linux-kernel@vger.kernel.org, eric.y.miao@gmail.com,
       Mike Rapoport <mike@compulab.co.il>
Subject: [PATCH] mfd: da903x: fix event masking for da9030
Date: Thu,  6 Nov 2008 13:23:51 +0200
Message-Id: <1225970631-15451-1-git-send-email-mike@compulab.co.il>
X-Mailer: git-send-email 1.5.6.4
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - oceanus.site5.com
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
 drivers/mfd/da903x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/da903x.c b/drivers/mfd/da903x.c
index b57326a..0b5bd85 100644
--- a/drivers/mfd/da903x.c
+++ b/drivers/mfd/da903x.c
@@ -267,7 +267,7 @@ static int da9030_mask_events(struct da903x_chip *chip, unsigned int events)
 {
 	uint8_t v[3];
 
-	chip->events_mask &= ~events;
+	chip->events_mask |= events;
 
 	v[0] = (chip->events_mask & 0xff);
 	v[1] = (chip->events_mask >> 8) & 0xff;
-- 
1.5.6.4

