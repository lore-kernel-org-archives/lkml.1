Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbZLNADe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbZLNADe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbZLNACp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:02:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34628 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186AbZLMX6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:36 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, ralf@linux-mips.org,
       torvalds@linux-foundation.org
Subject: [PATCH 06/10] Constify struct platform_suspend_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 01:00:22 +0100
Message-Id: <f0b6e2e77f9e556a5d259afadee629a4e8043f7b.1260663003.git.re.emese@gmail.com>
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
 arch/mips/alchemy/devboards/pm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/alchemy/devboards/pm.c b/arch/mips/alchemy/devboards/pm.c
index 632f986..fd0378d 100644
--- a/arch/mips/alchemy/devboards/pm.c
+++ b/arch/mips/alchemy/devboards/pm.c
@@ -78,7 +78,7 @@ static void db1x_pm_end(void)
 
 }
 
-static struct platform_suspend_ops db1x_pm_ops = {
+static const struct platform_suspend_ops db1x_pm_ops = {
 	.valid		= suspend_valid_only_mem,
 	.begin		= db1x_pm_begin,
 	.enter		= db1x_pm_enter,
-- 
1.6.5.3

