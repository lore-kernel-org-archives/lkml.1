Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbZLNACp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbZLNACp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbZLNACk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:02:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35110 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092AbZLMX6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:39 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, benh@kernel.crashing.org,
       paulus@samba.org, torvalds@linux-foundation.org
Subject: [PATCH 09/10] Constify struct platform_suspend_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 01:00:25 +0100
Message-Id: <77db9f2a915f81c13712706c0d5a52a92c217962.1260663003.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260663003.git.re.emese@gmail.com>
References: <cover.1260663003.git.re.emese@gmail.com>
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/macintosh/via-pmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/macintosh/via-pmu.c b/drivers/macintosh/via-pmu.c
index 6f308a4..b5f7ff7 100644
--- a/drivers/macintosh/via-pmu.c
+++ b/drivers/macintosh/via-pmu.c
@@ -2232,7 +2232,7 @@ static int pmu_sleep_valid(suspend_state_t state)
 		&& (pmac_call_feature(PMAC_FTR_SLEEP_STATE, NULL, 0, -1) >= 0);
 }
 
-static struct platform_suspend_ops pmu_pm_ops = {
+static const struct platform_suspend_ops pmu_pm_ops = {
 	.enter = powerbook_sleep,
 	.valid = pmu_sleep_valid,
 };
-- 
1.6.5.3

