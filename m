Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbZLNACV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbZLNACV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbZLNACQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:02:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34668 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190AbZLMX6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:39 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, benh@kernel.crashing.org,
       galak@kernel.crashing.org, paulus@samba.org,
       torvalds@linux-foundation.org
Subject: [PATCH 10/10] Constify struct platform_suspend_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 01:00:26 +0100
Message-Id: <f777accdab58304927b1aa5939bf166fa352c070.1260663003.git.re.emese@gmail.com>
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
 arch/powerpc/platforms/52xx/lite5200_pm.c |    2 +-
 arch/powerpc/platforms/52xx/mpc52xx_pm.c  |    2 +-
 arch/powerpc/platforms/83xx/suspend.c     |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/52xx/lite5200_pm.c b/arch/powerpc/platforms/52xx/lite5200_pm.c
index b5c753d..8f01abe 100644
--- a/arch/powerpc/platforms/52xx/lite5200_pm.c
+++ b/arch/powerpc/platforms/52xx/lite5200_pm.c
@@ -235,7 +235,7 @@ static void lite5200_pm_end(void)
 	lite5200_pm_target_state = PM_SUSPEND_ON;
 }
 
-static struct platform_suspend_ops lite5200_pm_ops = {
+static const struct platform_suspend_ops lite5200_pm_ops = {
 	.valid		= lite5200_pm_valid,
 	.begin		= lite5200_pm_begin,
 	.prepare	= lite5200_pm_prepare,
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_pm.c b/arch/powerpc/platforms/52xx/mpc52xx_pm.c
index a55b0b6..478c18e 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_pm.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_pm.c
@@ -180,7 +180,7 @@ void mpc52xx_pm_finish(void)
 	iounmap(mbar);
 }
 
-static struct platform_suspend_ops mpc52xx_pm_ops = {
+static const struct platform_suspend_ops mpc52xx_pm_ops = {
 	.valid		= mpc52xx_pm_valid,
 	.prepare	= mpc52xx_pm_prepare,
 	.enter		= mpc52xx_pm_enter,
diff --git a/arch/powerpc/platforms/83xx/suspend.c b/arch/powerpc/platforms/83xx/suspend.c
index 08e65fc..643d3ac 100644
--- a/arch/powerpc/platforms/83xx/suspend.c
+++ b/arch/powerpc/platforms/83xx/suspend.c
@@ -273,7 +273,7 @@ static int mpc83xx_is_pci_agent(void)
 	return ret;
 }
 
-static struct platform_suspend_ops mpc83xx_suspend_ops = {
+static const struct platform_suspend_ops mpc83xx_suspend_ops = {
 	.valid = mpc83xx_suspend_valid,
 	.begin = mpc83xx_suspend_begin,
 	.enter = mpc83xx_suspend_enter,
-- 
1.6.5.3

