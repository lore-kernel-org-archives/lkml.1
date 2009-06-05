Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbZFEIOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbZFEIOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755845AbZFEIGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:19 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37487 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755017AbZFEIFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:35 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 24/62] Blackfin: punt useless GPIO init call
Date: Fri,  5 Jun 2009 04:04:33 -0400
Message-Id: <1244189111-19639-25-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This init code existed only to dump a printk(), and not even a useful one.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/bfin_gpio.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/arch/blackfin/kernel/bfin_gpio.c b/arch/blackfin/kernel/bfin_gpio.c
index 32289b3..beffa00 100644
--- a/arch/blackfin/kernel/bfin_gpio.c
+++ b/arch/blackfin/kernel/bfin_gpio.c
@@ -313,15 +313,6 @@ inline void portmux_setup(unsigned short per)
 # define portmux_setup(...)  do { } while (0)
 #endif
 
-static int __init bfin_gpio_init(void)
-{
-	printk(KERN_INFO "Blackfin GPIO Controller\n");
-
-	return 0;
-}
-arch_initcall(bfin_gpio_init);
-
-
 #ifndef CONFIG_BF54x
 /***********************************************************
 *
-- 
1.6.3.1

