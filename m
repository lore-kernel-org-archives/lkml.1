Return-Path: <linux-kernel-owner+w=401wt.eu-S964810AbXDWOOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810AbXDWOOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 10:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbXDWOOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 10:14:45 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:36338 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964810AbXDWOOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 10:14:11 -0400
Date: Mon, 23 Apr 2007 16:14:27 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: akpm@linux-foundation.org, mb@bu3sch.de, linville@tuxdriver.com,
       arnd@arndb.de, maxextreme@gmail.com, gregkh@suse.de
Subject: [PATCH 9/9] Kconfig: broadcom 4400 dependency.
Message-ID: <20070423141427.GJ21174@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 9/9] Kconfig: broadcom 4400 dependency.

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Add HAS_IOMEM dependency to the B44 "Broadcom 4400 ethernet support"
config option. This hides the option for s390.
Goes on top of git-wireless.patch.

Cc: Michael Buesch <mb@bu3sch.de>
Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/net/Kconfig |    1 +
 1 files changed, 1 insertion(+)

diff -urpN linux-2.6/drivers/net/Kconfig linux-2.6-patched/drivers/net/Kconfig
--- linux-2.6/drivers/net/Kconfig	2007-04-23 15:51:44.000000000 +0200
+++ linux-2.6-patched/drivers/net/Kconfig	2007-04-23 15:53:16.000000000 +0200
@@ -1432,6 +1432,7 @@ config APRICOT
 
 config B44
 	tristate "Broadcom 4400 ethernet support"
+	depends on HAS_IOMEM
 	select SSB
 	select MII
 	help
