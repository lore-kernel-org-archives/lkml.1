Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbZLNAEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbZLNAEZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755194AbZLNAES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:04:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34578 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755141AbZLMX6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:34 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, vapier@gentoo.org, cooloney@kernel.org,
       torvalds@linux-foundation.org
Subject: [PATCH 04/10] Constify struct platform_suspend_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 01:00:20 +0100
Message-Id: <8b294f2ca92d23c07266f423b35a1cdfc206eeb3.1260663003.git.re.emese@gmail.com>
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
 arch/blackfin/mach-common/pm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/mach-common/pm.c b/arch/blackfin/mach-common/pm.c
index 8837be4..b2fb413 100644
--- a/arch/blackfin/mach-common/pm.c
+++ b/arch/blackfin/mach-common/pm.c
@@ -255,7 +255,7 @@ static int bfin_pm_enter(suspend_state_t state)
 	return 0;
 }
 
-struct platform_suspend_ops bfin_pm_ops = {
+const struct platform_suspend_ops bfin_pm_ops = {
 	.enter = bfin_pm_enter,
 	.valid	= bfin_pm_valid,
 };
-- 
1.6.5.3

