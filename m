Return-Path: <linux-kernel-owner+w=401wt.eu-S1751240AbXCJWNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbXCJWNX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 17:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbXCJWNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 17:13:23 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:50558 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbXCJWNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 17:13:22 -0500
X-Originating-Ip: 74.109.98.130
Date: Sat, 10 Mar 2007 17:10:46 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] LANMEDIA: Delete unused header file.
Message-ID: <Pine.LNX.4.64.0703101709350.28604@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Delete apparently unused header file
drivers/net/wan/lmc/lmc_media.h.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  not sure who maintainer is here.


diff --git a/drivers/net/wan/lmc/lmc_media.h b/drivers/net/wan/lmc/lmc_media.h
deleted file mode 100644
index ddcc004..0000000
--- a/drivers/net/wan/lmc/lmc_media.h
+++ /dev/null
@@ -1,65 +0,0 @@
-#ifndef _LMC_MEDIA_H_
-#define _LMC_MEDIA_H_
-
-lmc_media_t lmc_ds3_media = {
-  lmc_ds3_init,			/* special media init stuff */
-  lmc_ds3_default,		/* reset to default state */
-  lmc_ds3_set_status,		/* reset status to state provided */
-  lmc_dummy_set_1,		/* set clock source */
-  lmc_dummy_set2_1,		/* set line speed */
-  lmc_ds3_set_100ft,		/* set cable length */
-  lmc_ds3_set_scram,		/* set scrambler */
-  lmc_ds3_get_link_status,	/* get link status */
-  lmc_dummy_set_1,		/* set link status */
-  lmc_ds3_set_crc_length,	/* set CRC length */
-  lmc_dummy_set_1,		/* set T1 or E1 circuit type */
-  lmc_ds3_watchdog
-};
-
-lmc_media_t lmc_hssi_media = {
-  lmc_hssi_init,		/* special media init stuff */
-  lmc_hssi_default,		/* reset to default state */
-  lmc_hssi_set_status,		/* reset status to state provided */
-  lmc_hssi_set_clock,		/* set clock source */
-  lmc_dummy_set2_1,		/* set line speed */
-  lmc_dummy_set_1,		/* set cable length */
-  lmc_dummy_set_1,		/* set scrambler */
-  lmc_hssi_get_link_status,	/* get link status */
-  lmc_hssi_set_link_status,	/* set link status */
-  lmc_hssi_set_crc_length,	/* set CRC length */
-  lmc_dummy_set_1,		/* set T1 or E1 circuit type */
-  lmc_hssi_watchdog
-};
-
-lmc_media_t lmc_ssi_media = { lmc_ssi_init,	/* special media init stuff */
-  lmc_ssi_default,		/* reset to default state */
-  lmc_ssi_set_status,		/* reset status to state provided */
-  lmc_ssi_set_clock,		/* set clock source */
-  lmc_ssi_set_speed,		/* set line speed */
-  lmc_dummy_set_1,		/* set cable length */
-  lmc_dummy_set_1,		/* set scrambler */
-  lmc_ssi_get_link_status,	/* get link status */
-  lmc_ssi_set_link_status,	/* set link status */
-  lmc_ssi_set_crc_length,	/* set CRC length */
-  lmc_dummy_set_1,		/* set T1 or E1 circuit type */
-  lmc_ssi_watchdog
-};
-
-lmc_media_t lmc_t1_media = {
-  lmc_t1_init,			/* special media init stuff */
-  lmc_t1_default,		/* reset to default state */
-  lmc_t1_set_status,		/* reset status to state provided */
-  lmc_t1_set_clock,		/* set clock source */
-  lmc_dummy_set2_1,		/* set line speed */
-  lmc_dummy_set_1,		/* set cable length */
-  lmc_dummy_set_1,		/* set scrambler */
-  lmc_t1_get_link_status,	/* get link status */
-  lmc_dummy_set_1,		/* set link status */
-  lmc_t1_set_crc_length,	/* set CRC length */
-  lmc_t1_set_circuit_type,	/* set T1 or E1 circuit type */
-  lmc_t1_watchdog
-};
-
-
-#endif
-
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
