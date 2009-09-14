Return-Path: <linux-kernel-owner+w=401wt.eu-S933750AbZINUNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933750AbZINUNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932322AbZINUNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:13:46 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54165 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933648AbZINUJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:09:00 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 57/72] Blackfin: remove useless duplicated assignment in gpio code
Date: Mon, 14 Sep 2009 16:08:01 -0400
Message-Id: <1252958896-25150-58-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/bfin_gpio.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/kernel/bfin_gpio.c b/arch/blackfin/kernel/bfin_gpio.c
index 6b94462..fc4681c 100644
--- a/arch/blackfin/kernel/bfin_gpio.c
+++ b/arch/blackfin/kernel/bfin_gpio.c
@@ -722,7 +722,6 @@ void bfin_gpio_pm_hibernate_suspend(void)
 		gpio_bank_saved[bank].fer = gpio_array[bank]->port_fer;
 		gpio_bank_saved[bank].mux = gpio_array[bank]->port_mux;
 		gpio_bank_saved[bank].data = gpio_array[bank]->data;
-		gpio_bank_saved[bank].data = gpio_array[bank]->data;
 		gpio_bank_saved[bank].inen = gpio_array[bank]->inen;
 		gpio_bank_saved[bank].dir = gpio_array[bank]->dir_set;
 	}
-- 
1.6.4.2

