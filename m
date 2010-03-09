Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab0CIRW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:22:58 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:54735 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362Ab0CIRWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:22:37 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 13/13] serial: bfin_sport_uart: drop redundant cpu depends
Date: Tue,  9 Mar 2010 12:25:40 -0500
Message-Id: <1268155540-8241-14-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1268155540-8241-1-git-send-email-vapier@gentoo.org>
References: <1268155540-8241-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BF54xM procs imply the related BF54x define, so no need to check both.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/serial/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 223a0e8..fc117b6 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -1429,7 +1429,7 @@ config SERIAL_BFIN_SPORT_CONSOLE
 
 config SERIAL_BFIN_SPORT0_UART
 	bool "Enable UART over SPORT0"
-	depends on SERIAL_BFIN_SPORT && !(BF542 || BF542M || BF544 || BF544M)
+	depends on SERIAL_BFIN_SPORT && !(BF542 || BF544)
 	help
 	  Enable UART over SPORT0
 
-- 
1.7.0.2

