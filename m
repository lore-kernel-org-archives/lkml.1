Return-Path: <linux-kernel-owner+w=401wt.eu-S1758285AbZCNVkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285AbZCNVkj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 17:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758041AbZCNVjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 17:39:48 -0400
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:57987 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757728AbZCNVjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 17:39:47 -0400
From: =?utf-8?q?Erik=20Andr=C3=A9n?= <erik.andren@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org,
       =?utf-8?q?Erik=20Andr=C3=A9n?= <erik.andren@gmail.com>
Subject: [PATCH 02/09] Checkpatch.pl: Fixup debug.h
Date: Sat, 14 Mar 2009 22:39:29 +0100
Message-Id: <1237066776-14697-3-git-send-email-erik.andren@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1237066776-14697-2-git-send-email-erik.andren@gmail.com>
References: <1>
 <1237066776-14697-1-git-send-email-erik.andren@gmail.com>
 <1237066776-14697-2-git-send-email-erik.andren@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erik Andrén <erik.andren@gmail.com>
---
 drivers/staging/agnx/debug.h |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/agnx/debug.h b/drivers/staging/agnx/debug.h
index e3e25dd..761d99c 100644
--- a/drivers/staging/agnx/debug.h
+++ b/drivers/staging/agnx/debug.h
@@ -23,7 +23,7 @@ static inline void agnx_bug(char *reason)
 
 static inline void agnx_print_desc(struct agnx_desc *desc)
 {
-        u32 reg = be32_to_cpu(desc->frag);
+	u32 reg = be32_to_cpu(desc->frag);
 
 	PRINTK_BITS(DESC, PACKET_LEN);
 
@@ -291,7 +291,7 @@ static inline void agnx_print_sta(struct agnx_priv *priv, unsigned int sta_idx)
 	PRINTK_LE32(STA, sta->phy_stats_high);
 	PRINTK_LE32(STA, sta->phy_stats_low);
 
-//	for (i = 0; i < 8; i++)
+	/* for (i = 0; i < 8; i++) */
 	agnx_print_sta_traffic(sta->traffic + 0);
 
 	PRINTK_LE16(STA, sta->traffic_class0_frag_success);
@@ -311,10 +311,10 @@ static inline void agnx_print_sta(struct agnx_priv *priv, unsigned int sta_idx)
 static inline void dump_ieee80211_hdr(struct ieee80211_hdr *hdr, char *tag)
 {
 	u16 fctl;
-        int hdrlen;
+	int hdrlen;
 	DECLARE_MAC_BUF(mac);
 
-        fctl = le16_to_cpu(hdr->frame_control);
+	fctl = le16_to_cpu(hdr->frame_control);
 	switch (fctl & IEEE80211_FCTL_FTYPE) {
 	case IEEE80211_FTYPE_DATA:
 		printk(PFX "%s DATA ", tag);
@@ -324,7 +324,7 @@ static inline void dump_ieee80211_hdr(struct ieee80211_hdr *hdr, char *tag)
 		break;
 	case IEEE80211_FTYPE_MGMT:
 		printk(PFX "%s MGMT ", tag);
-		switch(fctl & IEEE80211_FCTL_STYPE) {
+		switch (fctl & IEEE80211_FCTL_STYPE) {
 		case IEEE80211_STYPE_ASSOC_REQ:
 			printk("SubType: ASSOC_REQ ");
 			break;
@@ -369,7 +369,7 @@ static inline void dump_ieee80211_hdr(struct ieee80211_hdr *hdr, char *tag)
 		printk(PFX "%s Packet type: Unknow\n", tag);
 	}
 
-        hdrlen = ieee80211_hdrlen(fctl);
+	hdrlen = ieee80211_hdrlen(fctl);
 
 	if (hdrlen >= 4)
 		printk("FC=0x%04x DUR=0x%04x",
@@ -389,29 +389,28 @@ static inline void dump_txm_registers(struct agnx_priv *priv)
 {
 	void __iomem *ctl = priv->ctl;
 	int i;
-	for (i = 0; i <=0x1e8; i += 4) {
+	for (i = 0; i <= 0x1e8; i += 4)
 		printk(KERN_DEBUG PFX "TXM: %x---> 0x%.8x\n", i, ioread32(ctl + i));
-	}
 }
 static inline void dump_rxm_registers(struct agnx_priv *priv)
 {
 	void __iomem *ctl = priv->ctl;
 	int i;
-	for (i = 0; i <=0x108; i += 4)
+	for (i = 0; i <= 0x108; i += 4)
 		printk(KERN_DEBUG PFX "RXM: %x---> 0x%.8x\n", i, ioread32(ctl + 0x2000 + i));
 }
 static inline void dump_bm_registers(struct agnx_priv *priv)
 {
 	void __iomem *ctl = priv->ctl;
 	int i;
-	for (i = 0; i <=0x90; i += 4)
+	for (i = 0; i <= 0x90; i += 4)
 		printk(KERN_DEBUG PFX "BM: %x---> 0x%.8x\n", i, ioread32(ctl + 0x2c00 + i));
 }
 static inline void dump_cir_registers(struct agnx_priv *priv)
 {
 	void __iomem *ctl = priv->ctl;
 	int i;
-	for (i = 0; i <=0xb8; i += 4)
+	for (i = 0; i <= 0xb8; i += 4)
 		printk(KERN_DEBUG PFX "CIR: %x---> 0x%.8x\n", i, ioread32(ctl + 0x3000 + i));
 }
 
-- 
1.6.0.4

