Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbZJEVPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbZJEVPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 17:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbZJEVP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 17:15:28 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:55042 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973AbZJEVP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 17:15:27 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 3/3] mtd/maps: gpio-addr-flash: depend on GPIO arch support
Date: Mon,  5 Oct 2009 17:14:49 -0400
Message-Id: <1254777289-32109-4-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc2
In-Reply-To: <1254777289-32109-1-git-send-email-vapier@gentoo.org>
References: <1254777289-32109-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver requires gpio functionality, so make sure we depend on that in
the Kconfig menu.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/mtd/maps/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index 841e085..14be075 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -486,6 +486,7 @@ config MTD_BFIN_ASYNC
 
 config MTD_GPIO_ADDR
 	tristate "GPIO-assisted Flash Chip Support"
+	depends on GENERIC_GPIO || GPIOLIB
 	depends on MTD_COMPLEX_MAPPINGS
 	select MTD_PARTITIONS
 	help
-- 
1.6.5.rc2

