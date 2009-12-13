Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbZLNAMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbZLNAMo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:12:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755008AbZLNAMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:12:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34864 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754933AbZLMX6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:00 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, jason.wessel@windriver.com,
       torvalds@linux-foundation.org, mingo@elte.hu, akpm@linux-foundation.org
Subject: [PATCH 3/8] Constify struct kgdb_arch for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:51 +0100
Message-Id: <d523e0b250e41076888ce6fc8d3da97d1eddbfec.1260662999.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662999.git.re.emese@gmail.com>
References: <cover.1260662999.git.re.emese@gmail.com>
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
 include/linux/kgdb.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 6adcc29..360613c 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -259,7 +259,7 @@ struct kgdb_io {
 	void			(*post_exception) (void);
 };
 
-extern struct kgdb_arch		arch_kgdb_ops;
+extern const struct kgdb_arch arch_kgdb_ops;
 
 extern unsigned long __weak kgdb_arch_pc(int exception, struct pt_regs *regs);
 
-- 
1.6.5.3

