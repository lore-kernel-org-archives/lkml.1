Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776AbZLNALt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbZLNALt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbZLNALl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:11:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34913 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755026AbZLMX6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:06 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, ralf@linux-mips.org,
       torvalds@linux-foundation.org
Subject: [PATCH 4/8] Constify struct kgdb_arch for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:52 +0100
Message-Id: <8c7c59a762d6de242c0a1c66b98a46be4e61fd15.1260662999.git.re.emese@gmail.com>
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
 arch/mips/kernel/kgdb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/mips/kernel/kgdb.c b/arch/mips/kernel/kgdb.c
index 50c9bb8..6d160e3 100644
--- a/arch/mips/kernel/kgdb.c
+++ b/arch/mips/kernel/kgdb.c
@@ -245,6 +245,7 @@ int kgdb_arch_handle_exception(int vector, int signo, int err_code,
 	return -1;
 }
 
+/* cannot be const, see kgdb_arch_init */
 struct kgdb_arch arch_kgdb_ops;
 
 /*
-- 
1.6.5.3

