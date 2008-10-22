Return-Path: <linux-kernel-owner+w=401wt.eu-S1757912AbYJVRgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbYJVRgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757456AbYJVRdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:33:16 -0400
Received: from kroah.org ([198.145.64.141]:53029 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757105AbYJVRdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:33:09 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Huang Weiyi <weiyi.huang@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/42] Staging: et131x: remove duplicated #include's
Date: Wed, 22 Oct 2008 10:28:51 -0700
Message-Id: <1224696563-5170-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081022172203.GA4000@kroah.com>
References: <20081022172203.GA4000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Weiyi <weiyi.huang@gmail.com>

Removed duplicated #include's in file(s) below,
 - drivers/staging/et131x/et1310_phy.c
      et1310_jagcore.h
      linux/delay.h
 - drivers/staging/et131x/et131x_debug.c
      et1310_jagcore.h
 - drivers/staging/et131x/et131x_initpci.c
      et1310_jagcore.h

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/et131x/et1310_phy.c     |    2 --
 drivers/staging/et131x/et131x_debug.c   |    1 -
 drivers/staging/et131x/et131x_initpci.c |    1 -
 3 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index 6c4fa54..9dd6dfd 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -84,7 +84,6 @@
 #include <linux/if_arp.h>
 #include <linux/ioport.h>
 #include <linux/random.h>
-#include <linux/delay.h>
 
 #include "et1310_phy.h"
 #include "et1310_pm.h"
@@ -95,7 +94,6 @@
 #include "et131x_initpci.h"
 
 #include "et1310_address_map.h"
-#include "et1310_jagcore.h"
 #include "et1310_tx.h"
 #include "et1310_rx.h"
 #include "et1310_mac.h"
diff --git a/drivers/staging/et131x/et131x_debug.c b/drivers/staging/et131x/et131x_debug.c
index 9ee5bce..d1dd46e 100644
--- a/drivers/staging/et131x/et131x_debug.c
+++ b/drivers/staging/et131x/et131x_debug.c
@@ -97,7 +97,6 @@
 #include "et131x_isr.h"
 
 #include "et1310_address_map.h"
-#include "et1310_jagcore.h"
 #include "et1310_tx.h"
 #include "et1310_rx.h"
 #include "et1310_mac.h"
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 4c6f171..a18c499 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -97,7 +97,6 @@
 #include "et131x_isr.h"
 
 #include "et1310_address_map.h"
-#include "et1310_jagcore.h"
 #include "et1310_tx.h"
 #include "et1310_rx.h"
 #include "et1310_mac.h"
-- 
1.6.0.2

