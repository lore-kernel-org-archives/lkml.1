Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbZLNABS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbZLNABS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755053AbZLNABN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:01:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34708 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755211AbZLMX6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:43 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, shemminger@vyatta.com,
       torvalds@linux-foundation.org
Subject: [PATCH 03/25] Constify struct sysfs_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 01:00:10 +0100
Message-Id: <679788055a75d9624dd277d30128929c83cbaab7.1260663004.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260663004.git.re.emese@gmail.com>
References: <cover.1260663004.git.re.emese@gmail.com>
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
Acked-by: Stephen Hemminger <shemminger@vyatta.com>
---
 drivers/cpufreq/cpufreq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index f20668c..5b58ccd 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -766,7 +766,7 @@ static void cpufreq_sysfs_release(struct kobject *kobj)
 	complete(&policy->kobj_unregister);
 }
 
-static struct sysfs_ops sysfs_ops = {
+static const struct sysfs_ops sysfs_ops = {
 	.show	= show,
 	.store	= store,
 };
-- 
1.6.5.3

