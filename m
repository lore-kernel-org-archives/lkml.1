Return-Path: <linux-kernel-owner+w=401wt.eu-S1764172AbYEUKX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764172AbYEUKX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 06:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756086AbYEUKXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 06:23:18 -0400
Received: from mail161.messagelabs.com ([216.82.253.115]:18213 "EHLO
	mail161.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbYEUKXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 06:23:17 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-9.tower-161.messagelabs.com!1211365395!5401016!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: <linux-kernel@vger.kernel.org>
CC: <trivial@kernel.org>
Subject: [PATCH] fix comment for __printk_ratelimit
Date: Wed, 21 May 2008 12:20:51 +0200
Message-ID: <1211365251-7776-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 21 May 2008 10:20:51.0427 (UTC) FILETIME=[584A2B30:01C8BB2C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment assumed ratelimit_burst to be one and used an old name for
ratelimit_jiffies.

I also reintended the comment.

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
---
 kernel/printk.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 8fb01c3..f1c3c1c 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1323,9 +1323,8 @@ void tty_write_message(struct tty_struct *tty, char *msg)
 /*
  * printk rate limiting, lifted from the networking subsystem.
  *
- * This enforces a rate limit: not more than one kernel message
- * every printk_ratelimit_jiffies to make a denial-of-service
- * attack impossible.
+ * This enforces a rate limit: not more than @ratelimit_burst kernel message
+ * every @ratelimit_jiffies to make a denial-of-service attack impossible.
  */
 int __printk_ratelimit(int ratelimit_jiffies, int ratelimit_burst)
 {
-- 
1.5.5.1

