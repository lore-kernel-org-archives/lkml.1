Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbZLNAFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbZLNAFu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755468AbZLNAFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:05:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34528 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133AbZLMX6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:30 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, lenb@kernel.org,
       jbarnes@virtuousgeek.org, torvalds@linux-foundation.org
Subject: [PATCH 01/10] Constify struct platform_suspend_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 01:00:17 +0100
Message-Id: <34b92a4164480c91baf8e5b2667dc8d078c8a608.1260663003.git.re.emese@gmail.com>
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
 drivers/acpi/sleep.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 5f2c379..1851ae2 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -297,7 +297,7 @@ static int acpi_suspend_state_valid(suspend_state_t pm_state)
 	}
 }
 
-static struct platform_suspend_ops acpi_suspend_ops = {
+static const struct platform_suspend_ops acpi_suspend_ops = {
 	.valid = acpi_suspend_state_valid,
 	.begin = acpi_suspend_begin,
 	.prepare_late = acpi_pm_prepare,
@@ -325,7 +325,7 @@ static int acpi_suspend_begin_old(suspend_state_t pm_state)
  * The following callbacks are used if the pre-ACPI 2.0 suspend ordering has
  * been requested.
  */
-static struct platform_suspend_ops acpi_suspend_ops_old = {
+static const struct platform_suspend_ops acpi_suspend_ops_old = {
 	.valid = acpi_suspend_state_valid,
 	.begin = acpi_suspend_begin_old,
 	.prepare_late = acpi_pm_disable_gpes,
-- 
1.6.5.3

