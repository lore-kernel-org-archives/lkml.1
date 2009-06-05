Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbZFEI0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbZFEI0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755842AbZFEIHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:07:16 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37516 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785AbZFEIGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:06:13 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 61/62] Blackfin: fix unused warnings after nommu update
Date: Fri,  5 Jun 2009 04:05:10 -0400
Message-Id: <1244189111-19639-62-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The massive nommu update (8feae131) left the local variable "vml" unused,
so punt it.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/traps.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 5547795..bde3e40 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -85,7 +85,6 @@ void __init trap_init(void)
 static void decode_address(char *buf, unsigned long address)
 {
 #ifdef CONFIG_DEBUG_VERBOSE
-	struct vm_list_struct *vml;
 	struct task_struct *p;
 	struct mm_struct *mm;
 	unsigned long flags, offset;
-- 
1.6.3.1

