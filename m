Return-Path: <linux-kernel-owner+w=401wt.eu-S1760370AbXGRHhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760370AbXGRHhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 03:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbXGRHha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 03:37:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38818 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbXGRHh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 03:37:29 -0400
Date: Wed, 18 Jul 2007 17:37:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: chas@cmf.nrl.navy.mil
Cc: linux-atm-general@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] nicstar needs virt_to_bus
Message-Id: <20070718173726.6d3b5a51.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/atm/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/drivers/atm/Kconfig b/drivers/atm/Kconfig
index bb4ae62..bed9f58 100644
--- a/drivers/atm/Kconfig
+++ b/drivers/atm/Kconfig
@@ -172,7 +172,7 @@ config ATM_ZATM_DEBUG
 
 config ATM_NICSTAR
 	tristate "IDT 77201 (NICStAR) (ForeRunnerLE)"
-	depends on PCI && !64BIT
+	depends on PCI && !64BIT && VIRT_TO_BUS
 	help
 	  The NICStAR chipset family is used in a large number of ATM NICs for
 	  25 and for 155 Mbps, including IDT cards and the Fore ForeRunnerLE
-- 
1.5.2.3

