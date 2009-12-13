Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbZLNARd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbZLNARd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbZLNARZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:17:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34203 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754911AbZLMX5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:50 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, gregkh@suse.de,
       torvalds@linux-foundation.org
Subject: [PATCH 8/9] Constify struct file_operations for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:36 +0100
Message-Id: <54a22453f07059b35168d455e879f7ebf707b798.1260662997.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662997.git.re.emese@gmail.com>
References: <cover.1260662997.git.re.emese@gmail.com>
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
 drivers/char/tty_io.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 684f0e0..e685ecc 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -3067,6 +3067,7 @@ struct tty_struct *get_current_tty(void)
 }
 EXPORT_SYMBOL_GPL(get_current_tty);
 
+/* cannot be const, see this function */
 void tty_default_fops(struct file_operations *fops)
 {
 	*fops = tty_fops;
-- 
1.6.5.3

