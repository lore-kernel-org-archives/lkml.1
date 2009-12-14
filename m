Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbZLNAFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbZLNAFZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbZLNAEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:04:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35070 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979AbZLMX6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:32 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, akpm@linux-foundation.org,
       hskinnemoen@atmel.com, nicolas.ferre@atmel.com,
       torvalds@linux-foundation.org
Subject: [PATCH 03/10] Constify struct platform_suspend_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 01:00:19 +0100
Message-Id: <88df8ccb7c751b010be1ef81c80a02cdc2023265.1260663003.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260663003.git.re.emese@gmail.com>
References: <cover.1260663003.git.re.emese@gmail.com>
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 arch/avr32/mach-at32ap/pm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/avr32/mach-at32ap/pm.c b/arch/avr32/mach-at32ap/pm.c
index f021edf..32d680e 100644
--- a/arch/avr32/mach-at32ap/pm.c
+++ b/arch/avr32/mach-at32ap/pm.c
@@ -176,7 +176,7 @@ out:
 	return 0;
 }
 
-static struct platform_suspend_ops avr32_pm_ops = {
+static const struct platform_suspend_ops avr32_pm_ops = {
 	.valid	= avr32_pm_valid_state,
 	.enter	= avr32_pm_enter,
 };
-- 
1.6.5.3

