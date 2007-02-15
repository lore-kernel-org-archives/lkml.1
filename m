Return-Path: <linux-kernel-owner+w=401wt.eu-S964826AbXBOCMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964826AbXBOCMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 21:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964838AbXBOCMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 21:12:20 -0500
Received: from imf16aec.mail.bellsouth.net ([205.152.59.64]:59499 "EHLO
	imf16aec.mail.bellsouth.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964826AbXBOCMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 21:12:18 -0500
Date: Wed, 14 Feb 2007 20:12:13 -0600
From: Jay Cliburn <jacliburn@bellsouth.net>
To: jeff@garzik.org
Cc: csnook@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net, crsprouse@gmail.com
Subject: [PATCH 1/6] atl1: drop NET_PCI from Kconfig
Message-ID: <20070215021213.GB9753@osprey.hogchain.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2007-01-26)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Cliburn <jacliburn@bellsouth.net>

The atl1 driver doesn't need NET_PCI.  Remove it from Kconfig.
Noticed by Chad Sprouse.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Signed-off-by: Chris Snook <csnook@redhat.com>
---

 drivers/net/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 0bb3c1e..1b624b4 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2350,7 +2350,7 @@ config QLA3XXX
 
 config ATL1
 	tristate "Attansic L1 Gigabit Ethernet support (EXPERIMENTAL)"
-	depends on NET_PCI && PCI && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL
 	select CRC32
 	select MII
 	help
