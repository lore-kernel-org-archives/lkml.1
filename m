Return-Path: <linux-kernel-owner+w=401wt.eu-S933852AbZINUXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933852AbZINUXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932733AbZINUXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:23:48 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54001 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757027AbZINUIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:19 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Philippe Gerum <rpm@xenomai.org>
Subject: [PATCH 07/72] Blackfin: export show_stack() to modules
Date: Mon, 14 Sep 2009 16:07:11 -0400
Message-Id: <1252958896-25150-8-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Gerum <rpm@xenomai.org>

Signed-off-by: Philippe Gerum <rpm@xenomai.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/traps.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index fccf741..5994597 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -944,6 +944,7 @@ void show_stack(struct task_struct *task, unsigned long *stack)
 	}
 #endif
 }
+EXPORT_SYMBOL(show_stack);
 
 void dump_stack(void)
 {
-- 
1.6.4.2

