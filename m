Return-Path: <linux-kernel-owner+w=401wt.eu-S1761927AbXEOTg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761927AbXEOTg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 15:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756198AbXEOTge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 15:36:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45126 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761300AbXEOTgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 15:36:33 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] missing includes in mlx4
Cc: linux-kernel@vger.kernel.org, jgarzik@pobox.com
Message-Id: <E1Ho2ow-0003TZ-Au@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 15 May 2007 20:36:30 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/mlx4/alloc.c |    1 +
 drivers/net/mlx4/eq.c    |    1 +
 drivers/net/mlx4/icm.c   |    1 +
 drivers/net/mlx4/reset.c |    1 +
 4 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/mlx4/alloc.c b/drivers/net/mlx4/alloc.c
index 9ffdb9d..dfbd580 100644
--- a/drivers/net/mlx4/alloc.c
+++ b/drivers/net/mlx4/alloc.c
@@ -33,6 +33,7 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/bitmap.h>
+#include <linux/dma-mapping.h>
 
 #include "mlx4.h"
 
diff --git a/drivers/net/mlx4/eq.c b/drivers/net/mlx4/eq.c
index af016d0..0f11adb 100644
--- a/drivers/net/mlx4/eq.c
+++ b/drivers/net/mlx4/eq.c
@@ -33,6 +33,7 @@
 
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/dma-mapping.h>
 
 #include <linux/mlx4/cmd.h>
 
diff --git a/drivers/net/mlx4/icm.c b/drivers/net/mlx4/icm.c
index e96feae..b7a4aa8 100644
--- a/drivers/net/mlx4/icm.c
+++ b/drivers/net/mlx4/icm.c
@@ -33,6 +33,7 @@
 
 #include <linux/init.h>
 #include <linux/errno.h>
+#include <linux/mm.h>
 
 #include <linux/mlx4/cmd.h>
 
diff --git a/drivers/net/mlx4/reset.c b/drivers/net/mlx4/reset.c
index 51eef84..e4dfd4b 100644
--- a/drivers/net/mlx4/reset.c
+++ b/drivers/net/mlx4/reset.c
@@ -35,6 +35,7 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/jiffies.h>
 
 #include "mlx4.h"
 
-- 
1.5.0-rc2.GIT


