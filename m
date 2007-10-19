Return-Path: <linux-kernel-owner+w=401wt.eu-S966307AbXJSDrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966307AbXJSDrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 23:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934553AbXJSDrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 23:47:20 -0400
Received: from rex.snapgear.com ([203.143.235.140]:37845 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934063AbXJSDrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 23:47:19 -0400
Date: Fri, 19 Oct 2007 13:46:22 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710190346.l9J3kMWg004580@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: improve code formating FEC driver
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe De Muyter <phdm@macqel.be>

Indent all the `else' the same way.
Remove some unecesary white space.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.23/drivers/net/fec.c linux-2.6.23-uc0/drivers/net/fec.c
--- linux-2.6.23/drivers/net/fec.c	2007-10-19 10:25:49.000000000 +1000
+++ linux-2.6.23-uc0/drivers/net/fec.c	2007-10-19 10:34:22.000000000 +1000
@@ -753,13 +753,11 @@ mii_queue(struct net_device *dev, int re
 		if (mii_head) {
 			mii_tail->mii_next = mip;
 			mii_tail = mip;
-		}
-		else {
+		} else {
 			mii_head = mii_tail = mip;
 			fep->hwp->fec_mii_data = regval;
 		}
-	}
-	else {
+	} else {
 		retval = 1;
 	}
 
@@ -794,7 +789,6 @@ static void mii_parse_sr(uint mii_reg, s
 		status |= PHY_STAT_FAULT;
 	if (mii_reg & 0x0020)
 		status |= PHY_STAT_ANC;
-
 	*s = status;
 }
 
@@ -1241,7 +1235,6 @@ mii_link_interrupt(int irq, void * dev_i
 #endif
 
 #if defined(CONFIG_M5272)
-
 /*
  *	Code specific to Coldfire 5272 setup.
  */
@@ -2022,8 +2015,7 @@ static void mii_relink(struct work_struc
 		    & (PHY_STAT_100FDX | PHY_STAT_10FDX))
 			duplex = 1;
 		fec_restart(dev, duplex);
-	}
-	else
+	} else
 		fec_stop(dev);
 
 #if 0
@@ -2121,8 +2113,7 @@ mii_discover_phy(uint mii_reg, struct ne
 			fep->phy_id = phytype << 16;
 			mii_queue(dev, mk_mii_read(MII_REG_PHYIR2),
 							mii_discover_phy3);
-		}
-		else {
+		} else {
 			fep->phy_addr++;
 			mii_queue(dev, mk_mii_read(MII_REG_PHYIR1),
 							mii_discover_phy);
@@ -2584,8 +2575,7 @@ fec_restart(struct net_device *dev, int 
 	if (duplex) {
 		fecp->fec_r_cntrl = OPT_FRAME_SIZE | 0x04;/* MII enable */
 		fecp->fec_x_cntrl = 0x04;		  /* FD enable */
-	}
-	else {
+	} else {
 		/* MII enable|No Rcv on Xmit */
 		fecp->fec_r_cntrl = OPT_FRAME_SIZE | 0x06;
 		fecp->fec_x_cntrl = 0x00;
