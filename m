Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbZLNAMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbZLNAMB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:12:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755732AbZLNALl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:11:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34907 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755023AbZLMX6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:06 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, vapier@gentoo.org,
       torvalds@linux-foundation.org
Subject: [PATCH 2/8] Constify struct kgdb_arch for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:50 +0100
Message-Id: <f2d1d095dd0c5433c46022cb34165d98c2bf4884.1260662999.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662999.git.re.emese@gmail.com>
References: <cover.1260662999.git.re.emese@gmail.com>
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
 arch/blackfin/kernel/kgdb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/kernel/kgdb.c b/arch/blackfin/kernel/kgdb.c
index cce79d0..c406c85 100644
--- a/arch/blackfin/kernel/kgdb.c
+++ b/arch/blackfin/kernel/kgdb.c
@@ -428,7 +428,7 @@ int kgdb_arch_handle_exception(int vector, int signo,
 	return -1;		/* this means that we do not want to exit from the handler */
 }
 
-struct kgdb_arch arch_kgdb_ops = {
+const struct kgdb_arch arch_kgdb_ops = {
 	.gdb_bpt_instr = {0xa1},
 #ifdef CONFIG_SMP
 	.flags = KGDB_HW_BREAKPOINT|KGDB_THR_PROC_SWAP,
-- 
1.6.5.3

