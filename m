Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbYAACOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbYAACOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 21:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbYAACIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 21:08:22 -0500
Received: from fmailhost04.isp.att.net ([207.115.11.54]:61951 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427AbYAACIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 21:08:17 -0500
X-Originating-IP: [68.222.90.230]
From: jacliburn@bellsouth.net
To: jeff@garzik.org
Cc: csnook@redhat.com, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net, Jay Cliburn <jacliburn@bellsouth.net>
Subject: [PATCH 26/26] atl1: remove experimental tag and clean up comments
Date: Mon, 31 Dec 2007 20:00:04 -0600
Message-Id: <1199152804-3889-27-git-send-email-jacliburn@bellsouth.net>
X-Mailer: git-send-email 1.5.3.3
In-Reply-To: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
References: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Cliburn <jacliburn@bellsouth.net>

All major netdevice functionality is now present in the atl1 driver.  As
a result, remove the EXPERIMENTAL Kconfig tag in the main driver, but leave
it in the NAPI driver.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
---
 drivers/net/Kconfig     |    4 ++--
 drivers/net/atlx/atl1.c |    8 ++------
 drivers/net/atlx/atl1.h |    2 +-
 drivers/net/atlx/atlx.c |    5 ++---
 drivers/net/atlx/atlx.h |    5 ++---
 5 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 095629f..638b90d 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2361,8 +2361,8 @@ config QLA3XXX
 	  will be called qla3xxx.
 
 config ATL1
-	tristate "Attansic L1 Gigabit Ethernet support (EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL
+	tristate "Attansic L1 Gigabit Ethernet support"
+	depends on PCI
 	select CRC32
 	select MII
 	help
diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index 10bccf6..411cd82 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -1,7 +1,7 @@
 /*
  * Copyright(c) 2005 - 2006 Attansic Corporation. All rights reserved.
  * Copyright(c) 2006 - 2007 Chris Snook <csnook@redhat.com>
- * Copyright(c) 2006 Jay Cliburn <jcliburn@gmail.com>
+ * Copyright(c) 2006 - 2007 Jay Cliburn <jcliburn@gmail.com>
  *
  * Derived from Intel e1000 driver
  * Copyright(c) 1999 - 2005 Intel Corporation. All rights reserved.
@@ -31,13 +31,9 @@
  * Chris Snook <csnook@redhat.com>
  * Jay Cliburn <jcliburn@gmail.com>
  *
- * This version is adapted from the Attansic reference driver for
- * inclusion in the Linux kernel.  It is currently under heavy development.
- * A very incomplete list of things that need to be dealt with:
+ * This version is adapted from the Attansic reference driver.
  *
  * TODO:
- * Wake on LAN.
- * Add more ethtool functions.
  * Fix abstruse irq enable/disable condition described here:
  *	http://marc.theaimsgroup.com/?l=linux-netdev&m=116398508500553&w=2
  *
diff --git a/drivers/net/atlx/atl1.h b/drivers/net/atlx/atl1.h
index a1757a9..82129be 100644
--- a/drivers/net/atlx/atl1.h
+++ b/drivers/net/atlx/atl1.h
@@ -1,7 +1,7 @@
 /*
  * Copyright(c) 2005 - 2006 Attansic Corporation. All rights reserved.
  * Copyright(c) 2006 - 2007 Chris Snook <csnook@redhat.com>
- * Copyright(c) 2006 Jay Cliburn <jcliburn@gmail.com>
+ * Copyright(c) 2006 - 2007 Jay Cliburn <jcliburn@gmail.com>
  *
  * Derived from Intel e1000 driver
  * Copyright(c) 1999 - 2005 Intel Corporation. All rights reserved.
diff --git a/drivers/net/atlx/atlx.c b/drivers/net/atlx/atlx.c
index 9cc9441..fb3dd7a 100644
--- a/drivers/net/atlx/atlx.c
+++ b/drivers/net/atlx/atlx.c
@@ -1,8 +1,7 @@
-/* atlx.c -- common functions for Attansic network drivers
- *
+/*
  * Copyright(c) 2005 - 2006 Attansic Corporation. All rights reserved.
  * Copyright(c) 2006 - 2007 Chris Snook <csnook@redhat.com>
- * Copyright(c) 2006 Jay Cliburn <jcliburn@gmail.com>
+ * Copyright(c) 2006 - 2007 Jay Cliburn <jcliburn@gmail.com>
  * Copyright(c) 2007 Atheros Corporation. All rights reserved.
  *
  * Derived from Intel e1000 driver
diff --git a/drivers/net/atlx/atlx.h b/drivers/net/atlx/atlx.h
index 18021d9..3c39b27 100644
--- a/drivers/net/atlx/atlx.h
+++ b/drivers/net/atlx/atlx.h
@@ -1,8 +1,7 @@
-/* atlx_hw.h -- common hardware definitions for Attansic network drivers
- *
+/*
  * Copyright(c) 2005 - 2006 Attansic Corporation. All rights reserved.
  * Copyright(c) 2006 - 2007 Chris Snook <csnook@redhat.com>
- * Copyright(c) 2006 Jay Cliburn <jcliburn@gmail.com>
+ * Copyright(c) 2006 - 2007 Jay Cliburn <jcliburn@gmail.com>
  * Copyright(c) 2007 Atheros Corporation. All rights reserved.
  *
  * Derived from Intel e1000 driver
-- 
1.5.3.3

