Return-Path: <linux-kernel-owner+w=401wt.eu-S2992996AbXDTLfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992996AbXDTLfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 07:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993034AbXDTLfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 07:35:12 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:58371 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992993AbXDTLfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 07:35:09 -0400
Date: Fri, 20 Apr 2007 13:35:24 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: akpm@linux-foundation.org, mb@bu3sch.de, linville@tuxdriver.com
Subject: [PATCH 8/8] Kconfig: broadcom 4400 dependency.
Message-ID: <20070420113524.GI3738@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Make the broadcom 4400 driver dependent on SSB. With the select statement
for SSB the config option for the driver is always present even if the
target of selection (SSB) is not available. 
Goes on top of git-wireless.patch.

Cc: Michael Buesch <mb@bu3sch.de>
Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/net/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -urpN linux-2.6/drivers/net/Kconfig linux-2.6-patched/drivers/net/Kconfig
--- linux-2.6/drivers/net/Kconfig	2007-04-19 16:19:36.000000000 +0200
+++ linux-2.6-patched/drivers/net/Kconfig	2007-04-19 16:20:01.000000000 +0200
@@ -1432,7 +1432,7 @@ config APRICOT
 
 config B44
 	tristate "Broadcom 4400 ethernet support"
-	select SSB
+	depends on SSB
 	select MII
 	help
 	  If you have a network (Ethernet) controller of this type, say Y and
