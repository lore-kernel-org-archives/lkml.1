Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab0CIRWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:22:51 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:54732 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab0CIRWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:22:36 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 12/13] serial: bfin_sport_uart: drop the experimental markings
Date: Tue,  9 Mar 2010 12:25:39 -0500
Message-Id: <1268155540-8241-13-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1268155540-8241-1-git-send-email-vapier@gentoo.org>
References: <1268155540-8241-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should be stable now ...

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/serial/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 0d95b5f..223a0e8 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -1413,8 +1413,8 @@ config SERIAL_SC26XX_CONSOLE
 	  Support for Console on SC2681/SC2692 serial ports.
 
 config SERIAL_BFIN_SPORT
-	tristate "Blackfin SPORT emulate UART (EXPERIMENTAL)"
-	depends on BLACKFIN && EXPERIMENTAL
+	tristate "Blackfin SPORT emulate UART"
+	depends on BLACKFIN
 	select SERIAL_CORE
 	help
 	  Enable SPORT emulate UART on Blackfin series.
-- 
1.7.0.2

