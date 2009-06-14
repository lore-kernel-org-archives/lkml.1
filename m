Return-Path: <linux-kernel-owner+w=401wt.eu-S1759215AbZFNMCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215AbZFNMCK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758557AbZFNMB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:01:29 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52645 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757592AbZFNMB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:01:28 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 02/17] Blackfin: pull in asm/io.h in ksyms for prototypes
Date: Sun, 14 Jun 2009 08:01:03 -0400
Message-Id: <1244980878-2124-3-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
References: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure we pull in asm/io.h when exporting symbols for the I/O functions
so we don't end up with a build failure due to missing prototypes.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/bfin_ksyms.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/kernel/bfin_ksyms.c b/arch/blackfin/kernel/bfin_ksyms.c
index aa05e63..ed8392c 100644
--- a/arch/blackfin/kernel/bfin_ksyms.c
+++ b/arch/blackfin/kernel/bfin_ksyms.c
@@ -10,6 +10,7 @@
 #include <linux/uaccess.h>
 
 #include <asm/cacheflush.h>
+#include <asm/io.h>
 
 /* Allow people to have their own Blackfin exception handler in a module */
 EXPORT_SYMBOL(bfin_return_from_exception);
-- 
1.6.3.1

