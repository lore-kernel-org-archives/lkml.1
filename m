Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbZLNANY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbZLNANY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754992AbZLMX57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:57:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34821 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853AbZLMX54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:56 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, gregkh@suse.de,
       akpm@linux-foundation.org, alan@linux.intel.com,
       torvalds@linux-foundation.org, apier@gentoo.org,
       benh@kernel.crashing.org
Subject: [PATCH 2/3] Constify struct hv_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:44 +0100
Message-Id: <3b52cb491533869cce143c69373c298c34ef9f77.1260662998.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662998.git.re.emese@gmail.com>
References: <cover.1260662998.git.re.emese@gmail.com>
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
 drivers/char/hvc_iseries.c |    2 +-
 drivers/char/hvc_vio.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hvc_iseries.c b/drivers/char/hvc_iseries.c
index 936d05b..fd02426 100644
--- a/drivers/char/hvc_iseries.c
+++ b/drivers/char/hvc_iseries.c
@@ -197,7 +197,7 @@ done:
 	return sent;
 }
 
-static struct hv_ops hvc_get_put_ops = {
+static const struct hv_ops hvc_get_put_ops = {
 	.get_chars = get_chars,
 	.put_chars = put_chars,
 	.notifier_add = notifier_add_irq,
diff --git a/drivers/char/hvc_vio.c b/drivers/char/hvc_vio.c
index 10be343..27370e9 100644
--- a/drivers/char/hvc_vio.c
+++ b/drivers/char/hvc_vio.c
@@ -77,7 +77,7 @@ static int filtered_get_chars(uint32_t vtermno, char *buf, int count)
 	return got;
 }
 
-static struct hv_ops hvc_get_put_ops = {
+static const struct hv_ops hvc_get_put_ops = {
 	.get_chars = filtered_get_chars,
 	.put_chars = hvc_put_chars,
 	.notifier_add = notifier_add_irq,
-- 
1.6.5.3

