Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbZGLS37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbZGLS37 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 14:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbZGLS3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 14:29:17 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:46937 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922AbZGLS3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 14:29:15 -0400
From: Felipe Balbi <me@felipebalbi.com>
To: dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <me@felipebalbi.com>
Subject: [rfc/patch 11/15] power: bq27200: temperature in tenths of degrees
Date: Sun, 12 Jul 2009 21:09:33 +0300
Message-Id: <1247422177-7329-11-git-send-email-me@felipebalbi.com>
X-Mailer: git-send-email 1.6.4.rc0.17.gd9eb0
In-Reply-To: <1247422177-7329-10-git-send-email-me@felipebalbi.com>
References: <1247422177-7329-1-git-send-email-me@felipebalbi.com>
 <1247422177-7329-2-git-send-email-me@felipebalbi.com>
 <1247422177-7329-3-git-send-email-me@felipebalbi.com>
 <1247422177-7329-4-git-send-email-me@felipebalbi.com>
 <1247422177-7329-5-git-send-email-me@felipebalbi.com>
 <1247422177-7329-6-git-send-email-me@felipebalbi.com>
 <1247422177-7329-7-git-send-email-me@felipebalbi.com>
 <1247422177-7329-8-git-send-email-me@felipebalbi.com>
 <1247422177-7329-9-git-send-email-me@felipebalbi.com>
 <1247422177-7329-10-git-send-email-me@felipebalbi.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

temperature should be reported in tenths of degrees celsius.

Signed-off-by: Felipe Balbi <me@felipebalbi.com>
---
 drivers/power/bq27200_battery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/bq27200_battery.c b/drivers/power/bq27200_battery.c
index a359761..658c2c5 100644
--- a/drivers/power/bq27200_battery.c
+++ b/drivers/power/bq27200_battery.c
@@ -113,7 +113,7 @@ static int bq27200_temperature(struct bq27200 *bq)
 		return ret;
 	}
 
-	return (ret >> 2) - 273;
+	return ((ret >> 2) - 273) * 10;
 }
 
 /*
-- 
1.6.1.3

