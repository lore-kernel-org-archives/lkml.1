Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbZLNAPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbZLNAPq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754947AbZLMX5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:57:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34181 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754906AbZLMX5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:48 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, gregkh@suse.de,
       torvalds@linux-foundation.org
Subject: [PATCH 9/9] Constify struct file_operations for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:37 +0100
Message-Id: <1e45caef76cb73748f0977b18b848323a547c736.1260662997.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662997.git.re.emese@gmail.com>
References: <cover.1260662997.git.re.emese@gmail.com>
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
 drivers/char/pty.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 385c44b..9fa352e 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -676,6 +676,7 @@ static int ptmx_open(struct inode *inode, struct file *filp)
 	return ret;
 }
 
+/* cannot be const, see unix98_pty_init */
 static struct file_operations ptmx_fops;
 
 static void __init unix98_pty_init(void)
-- 
1.6.5.3

