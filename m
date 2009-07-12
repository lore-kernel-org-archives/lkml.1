Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbZGLSbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbZGLSbX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 14:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbZGLS37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 14:29:59 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:47038 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443AbZGLS36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 14:29:58 -0400
From: Felipe Balbi <me@felipebalbi.com>
To: dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <me@felipebalbi.com>
Subject: [rfc/patch 10/15] power: bq27200: voltage should be expressed in uV
Date: Sun, 12 Jul 2009 21:09:32 +0300
Message-Id: <1247422177-7329-10-git-send-email-me@felipebalbi.com>
X-Mailer: git-send-email 1.6.4.rc0.17.gd9eb0
In-Reply-To: <1247422177-7329-9-git-send-email-me@felipebalbi.com>
References: <1247422177-7329-1-git-send-email-me@felipebalbi.com>
 <1247422177-7329-2-git-send-email-me@felipebalbi.com>
 <1247422177-7329-3-git-send-email-me@felipebalbi.com>
 <1247422177-7329-4-git-send-email-me@felipebalbi.com>
 <1247422177-7329-5-git-send-email-me@felipebalbi.com>
 <1247422177-7329-6-git-send-email-me@felipebalbi.com>
 <1247422177-7329-7-git-send-email-me@felipebalbi.com>
 <1247422177-7329-8-git-send-email-me@felipebalbi.com>
 <1247422177-7329-9-git-send-email-me@felipebalbi.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... and not mV as the chip reports.

Signed-off-by: Felipe Balbi <me@felipebalbi.com>
---
 drivers/power/bq27200_battery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/bq27200_battery.c b/drivers/power/bq27200_battery.c
index 869761e..a359761 100644
--- a/drivers/power/bq27200_battery.c
+++ b/drivers/power/bq27200_battery.c
@@ -128,7 +128,7 @@ static int bq27200_voltage(struct bq27200 *bq)
 	if (ret < 0)
 		dev_err(&bq->client->dev, "error reading voltage\n");
 
-	return ret;
+	return ret * 1000;
 }
 
 /*
-- 
1.6.1.3

