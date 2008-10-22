Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbYJVRg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbYJVRg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757500AbYJVRdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:33:15 -0400
Received: from kroah.org ([198.145.64.141]:53027 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752642AbYJVRdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:33:08 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Huang Weiyi <weiyi.huang@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/42] Staging: SLICOSS: remove duplicated #include's
Date: Wed, 22 Oct 2008 10:28:50 -0700
Message-Id: <1224696563-5170-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081022172203.GA4000@kroah.com>
References: <20081022172203.GA4000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Weiyi <weiyi.huang@gmail.com>

Removed duplicated #include's in drivers/staging/slicoss/slicoss.c.
  linux/delay.h
  linux/etherdevice.h
  linux/init.h
  linux/netdevice.h
  linux/pci.h
  linux/skbuff.h
  linux/slab.h
  linux/string.h

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/slicoss/slicoss.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 47b0ae1..69f3ea2 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -96,17 +96,9 @@
 #include <linux/moduleparam.h>
 
 #include <linux/types.h>
-#include <linux/slab.h>
-#include <linux/delay.h>
-#include <linux/init.h>
-#include <linux/pci.h>
 #include <linux/dma-mapping.h>
-#include <linux/netdevice.h>
-#include <linux/etherdevice.h>
 #include <linux/mii.h>
 #include <linux/if_vlan.h>
-#include <linux/skbuff.h>
-#include <linux/string.h>
 #include <asm/unaligned.h>
 
 #include <linux/ethtool.h>
-- 
1.6.0.2

