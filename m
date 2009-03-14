Return-Path: <linux-kernel-owner+w=401wt.eu-S1758544AbZCNVlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544AbZCNVlP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 17:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758037AbZCNVjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 17:39:52 -0400
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:57987 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758068AbZCNVju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 17:39:50 -0400
From: =?utf-8?q?Erik=20Andr=C3=A9n?= <erik.andren@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org,
       =?utf-8?q?Erik=20Andr=C3=A9n?= <erik.andren@gmail.com>
Subject: [PATCH 04/09] Checkpatch.pl: Fixup phy.c
Date: Sat, 14 Mar 2009 22:39:31 +0100
Message-Id: <1237066776-14697-5-git-send-email-erik.andren@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1237066776-14697-4-git-send-email-erik.andren@gmail.com>
References: <1>
 <1237066776-14697-1-git-send-email-erik.andren@gmail.com>
 <1237066776-14697-2-git-send-email-erik.andren@gmail.com>
 <1237066776-14697-3-git-send-email-erik.andren@gmail.com>
 <1237066776-14697-4-git-send-email-erik.andren@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erik Andrén <erik.andren@gmail.com>
---
 drivers/staging/agnx/phy.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/agnx/phy.c b/drivers/staging/agnx/phy.c
index da8f10c..2be6331 100644
--- a/drivers/staging/agnx/phy.c
+++ b/drivers/staging/agnx/phy.c
@@ -114,7 +114,7 @@ static void mac_address_set(struct agnx_priv *priv)
 	/* FIXME */
 	reg = (mac_addr[0] << 24) | (mac_addr[1] << 16) | mac_addr[2] << 8 | mac_addr[3];
 	iowrite32(reg, ctl + AGNX_RXM_MACHI);
- 	reg = (mac_addr[4] << 8) | mac_addr[5];
+	reg = (mac_addr[4] << 8) | mac_addr[5];
 	iowrite32(reg, ctl + AGNX_RXM_MACLO);
 }
 
@@ -127,7 +127,7 @@ static void receiver_bssid_set(struct agnx_priv *priv, u8 *bssid)
 	/* FIXME */
 	reg = bssid[0] << 24 | (bssid[1] << 16) | (bssid[2] << 8) | bssid[3];
 	iowrite32(reg, ctl + AGNX_RXM_BSSIDHI);
- 	reg = (bssid[4] << 8) | bssid[5];
+	reg = (bssid[4] << 8) | bssid[5];
 	iowrite32(reg, ctl + AGNX_RXM_BSSIDLO);
 
 	/* Enable the receiver */
@@ -401,9 +401,9 @@ static void rx_management_init(struct agnx_priv *priv)
 		agnx_write32(ctl, 0x2074, 0x1f171710);
 		agnx_write32(ctl, 0x2078, 0x10100d0d);
 		agnx_write32(ctl, 0x207c, 0x11111010);
-	}
-	else
+	} else {
 		agnx_write32(ctl, AGNX_RXM_DELAY11, 0x0);
+	}
 	agnx_write32(ctl, AGNX_RXM_REQRATE, 0x8195e00);
 }
 
@@ -476,7 +476,7 @@ static void gain_ctlcnt_init(struct agnx_priv *priv)
 	/* It seemed if we set other bit to 1 the bit 0 will
 	   be auto change to 0 */
 	agnx_write32(ctl, AGNX_BM_TXTOPEER, 0x2 | 0x1);
-//	agnx_write32(ctl, AGNX_BM_TXTOPEER, 0x1);
+/*	agnx_write32(ctl, AGNX_BM_TXTOPEER, 0x1); */
 } /* gain_ctlcnt_init */
 
 
@@ -490,7 +490,7 @@ static void phy_init(struct agnx_priv *priv)
 	/* Load InitialGainTable */
 	gain_table_init(priv);
 
-  	agnx_write32(ctl, AGNX_CIR_ADDRWIN, 0x2000000);
+	agnx_write32(ctl, AGNX_CIR_ADDRWIN, 0x2000000);
 
 	/* Clear the following offsets in Memory Range #2: */
 	memset_io(data + 0x5040, 0, 0xa * 4);
@@ -586,7 +586,7 @@ static void phy_init(struct agnx_priv *priv)
 		agnx_write32(ctl, AGNX_GCR_SIFST11B, 0x28);
 		agnx_write32(ctl, AGNX_GCR_CWDETEC, 0x0);
 		agnx_write32(ctl, AGNX_GCR_0X38, 0x1e);
-//		agnx_write32(ctl, AGNX_GCR_BOACT, 0x26);
+/*		agnx_write32(ctl, AGNX_GCR_BOACT, 0x26);*/
 		agnx_write32(ctl, AGNX_GCR_DISCOVMOD, 0x3);
 
 		agnx_write32(ctl, AGNX_GCR_THCAP11A, 0x32);
@@ -810,10 +810,10 @@ static void card_interface_init(struct agnx_priv *priv)
 		}
 		print_hex_dump_bytes(PFX "EEPROM: ", DUMP_PREFIX_NONE, eeprom,
 				     ARRAY_SIZE(eeprom));
-	} while(0);
+	} while (0);
 
 	spi_rc_write(ctl, RF_CHIP0, 0x26);
-        reg = agnx_read32(ctl, AGNX_SPI_RLSW);
+	reg = agnx_read32(ctl, AGNX_SPI_RLSW);
 
 	/* Initialize the system interface */
 	system_itf_init(priv);
@@ -874,19 +874,19 @@ static void card_interface_init(struct agnx_priv *priv)
 	/* FIXME Enable the request */
 	/* Check packet length */
 	/* Set maximum packet length */
-/* 	agnx_write32(ctl, AGNX_RXM_REQRATE, 0x88195e00); */
-/* 	enable_receiver(priv); */
+/*	agnx_write32(ctl, AGNX_RXM_REQRATE, 0x88195e00); */
+/*	enable_receiver(priv); */
 
 	/* Set the Receiver BSSID */
 	receiver_bssid_set(priv, bssid);
 
 	/* FIXME Set to managed mode */
 	set_managed_mode(priv);
-//	set_promiscuous_mode(priv);
-/* 	set_scan_mode(priv); */
-/* 	set_learn_mode(priv); */
-// 	set_promis_and_managed(priv);
-// 	set_adhoc_mode(priv);
+/*	set_promiscuous_mode(priv); */
+/*	set_scan_mode(priv); */
+/*	set_learn_mode(priv); */
+/*	set_promis_and_managed(priv); */
+/*	set_adhoc_mode(priv); */
 
 	/* Set the recieve request rate */
 	/* Check packet length */
-- 
1.6.0.4

