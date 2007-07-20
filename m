Return-Path: <linux-kernel-owner+w=401wt.eu-S1760062AbXGTDUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062AbXGTDUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 23:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbXGTDUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 23:20:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54946 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbXGTDUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 23:20:09 -0400
Date: Fri, 20 Jul 2007 13:20:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, samuel@sortiz.org,
       irda-users@lists.sourceforge.net
Subject: [PATCH] TOSHIBA_FIR depends on virt_to_bus
Message-Id: <20070720132014.a58f0073.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/irda/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/drivers/net/irda/Kconfig b/drivers/net/irda/Kconfig
index 829da9a..23b0c33 100644
--- a/drivers/net/irda/Kconfig
+++ b/drivers/net/irda/Kconfig
@@ -355,7 +355,7 @@ config WINBOND_FIR
 
 config TOSHIBA_FIR
 	tristate "Toshiba Type-O IR Port"
-	depends on IRDA && PCI && !64BIT
+	depends on IRDA && PCI && !64BIT && VIRT_TO_BUS
 	help
 	  Say Y here if you want to build support for the Toshiba Type-O IR
 	  and Donau oboe chipsets. These chipsets are used by the Toshiba
-- 
1.5.2.3

