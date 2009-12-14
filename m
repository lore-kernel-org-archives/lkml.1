Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbZLNAEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbZLNAEB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:04:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755155AbZLMX6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:58:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34556 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092AbZLMX6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:32 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, pavel@ucw.cz, len.brown@intel.com,
       jirislaby@gmail.com, torvalds@linux-foundation.org
Subject: [PATCH 3/3] Constify struct platform_hibernation_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 01:00:23 +0100
Message-Id: <2f67f16fbce116acdd69339852dc51eb8578484e.1260663003.git.re.emese@gmail.com>
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
 kernel/power/hibernate.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index bbfe472..2766523 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -49,14 +49,14 @@ enum {
 
 static int hibernation_mode = HIBERNATION_SHUTDOWN;
 
-static struct platform_hibernation_ops *hibernation_ops;
+static const struct platform_hibernation_ops *hibernation_ops;
 
 /**
  * hibernation_set_ops - set the global hibernate operations
  * @ops: the hibernation operations to use in subsequent hibernation transitions
  */
 
-void hibernation_set_ops(struct platform_hibernation_ops *ops)
+void hibernation_set_ops(const struct platform_hibernation_ops *ops)
 {
 	if (ops && !(ops->begin && ops->end &&  ops->pre_snapshot
 	    && ops->prepare && ops->finish && ops->enter && ops->pre_restore
-- 
1.6.5.3

