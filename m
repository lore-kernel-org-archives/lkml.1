Return-Path: <linux-kernel-owner+w=401wt.eu-S1751747AbXCEBuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbXCEBuM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:50:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbXCEBtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:49:52 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:49934 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751861AbXCEBtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:49:23 -0500
Date: Mon, 5 Mar 2007 02:49:25 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Sivakumar Subramani <sivakumar.subramani@neterion.com>
Cc: Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] make drivers/net/s2io.c:vlan_strip_flag static
Message-ID: <20070305014925.GX3441@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global vlan_strip_flag static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc2-mm1/drivers/net/s2io.c.old	2007-03-04 21:37:59.000000000 +0100
+++ linux-2.6.21-rc2-mm1/drivers/net/s2io.c	2007-03-04 21:38:14.000000000 +0100
@@ -316,7 +316,7 @@
 }
 
 /* A flag indicating whether 'RX_PA_CFG_STRIP_VLAN_TAG' bit is set or not */
-int vlan_strip_flag;
+static int vlan_strip_flag;
 
 /* Unregister the vlan */
 static void s2io_vlan_rx_kill_vid(struct net_device *dev, unsigned long vid)

