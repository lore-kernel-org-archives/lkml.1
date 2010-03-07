Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab0CGDby (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 22:31:54 -0500
Received: from mail-bw0-f222.google.com ([209.85.218.222]:47839 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab0CGDbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 22:31:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OKK3XqGYRuUHBp+8HzD+LnNItD5nM6IwvMXv5fgoT+rtWy3hIyp+MCPF3i4UgVqNW1
         2zeHxnFmfmUHXKWlwTb60BiPGctSGDi5yz9uaWLkCYVvvqm6Z/k1FaYj2zhR7Y4uwY07
         /0SmtbAhwUCe0G64YF8Ys3ugxMUtrtz0vgFEg=
From: Niadh <neilmunro@gmail.com>
To: gregkh@suse.de, bzolnier@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Niadh <neilmunro@gmail.com>
Subject: [PATCH 3/3] Staging: rt2860: Removes all errors from wpa.h.
Date: Sun,  7 Mar 2010 03:31:34 +0000
Message-Id: <1267932694-3254-1-git-send-email-neilmunro@gmail.com>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up all errors but leaves all but four warnings, these are mostly typedefs and I don't know how to clean those up yet. The final warning is an 80 character limit warning, but I've yet to figure out how to clean that line up.

All were detected by the checkpatch.pl tool.

Signed-off-by: Niadh <neilmunro@gmail.com>
---
 drivers/staging/rt2860/wpa.h |   44 +++++++++++++++++++++---------------------
 1 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/rt2860/wpa.h b/drivers/staging/rt2860/wpa.h
index 6199ae6..697d5a3 100644
--- a/drivers/staging/rt2860/wpa.h
+++ b/drivers/staging/rt2860/wpa.h
@@ -31,7 +31,7 @@

 	Revision History:
 	Who			When			What
-	--------	----------		----------------------------------------------
+	--------	----------		------------------------------
 	Name		Date			Modification logs
 */

@@ -48,7 +48,7 @@

 /* The length is the EAPoL-Key frame except key data field. */
 /* Please refer to 802.11i-2004 ,Figure 43u in p.78 */
-#define LEN_EAPOL_KEY_MSG			(sizeof(struct rt_key_descripter) - MAX_LEN_OF_RSNIE)
+#define LEN_EAPOL_KEY_MSG(sizeof(struct rt_key_descripter) - MAX_LEN_OF_RSNIE)

 /* EAP Code Type. */
 #define EAP_CODE_REQUEST	1
@@ -76,7 +76,7 @@
 /* EAPOL EK, MK */
 #define LEN_EAP_EK					16
 #define LEN_EAP_MICK				16
-#define LEN_EAP_KEY					((LEN_EAP_EK)+(LEN_EAP_MICK))
+#define LEN_EAP_KEY		((LEN_EAP_EK)+(LEN_EAP_MICK))
 /* TKIP key related */
 #define LEN_PMKID					16
 #define LEN_TKIP_EK					16
@@ -84,11 +84,11 @@
 #define LEN_TKIP_TXMICK				8
 #define LEN_AES_EK					16
 #define LEN_AES_KEY					LEN_AES_EK
-#define LEN_TKIP_KEY				((LEN_TKIP_EK)+(LEN_TKIP_RXMICK)+(LEN_TKIP_TXMICK))
+#define LEN_TKIP_KEY	((LEN_TKIP_EK)+(LEN_TKIP_RXMICK)+(LEN_TKIP_TXMICK))
 #define TKIP_AP_TXMICK_OFFSET		((LEN_EAP_KEY)+(LEN_TKIP_EK))
 #define TKIP_AP_RXMICK_OFFSET		(TKIP_AP_TXMICK_OFFSET+LEN_TKIP_TXMICK)
-#define TKIP_GTK_LENGTH				((LEN_TKIP_EK)+(LEN_TKIP_RXMICK)+(LEN_TKIP_TXMICK))
-#define LEN_PTK						((LEN_EAP_KEY)+(LEN_TKIP_KEY))
+#define TKIP_GTK_LENGTH	((LEN_TKIP_EK)+(LEN_TKIP_RXMICK)+(LEN_TKIP_TXMICK))
+#define LEN_PTK					((LEN_EAP_KEY)+(LEN_TKIP_KEY))
 #define MIN_LEN_OF_GTK				5
 #define LEN_PMK						32
 #define LEN_PMK_NAME				16
@@ -162,18 +162,18 @@
 #endif

 #define	SET_u16_TO_ARRARY(_V, _LEN)		\
-{											\
+{									\
 	_V[0] = (_LEN & 0xFF00) >> 8;			\
 	_V[1] = (_LEN & 0xFF);					\
 }

 #define	INC_u16_TO_ARRARY(_V, _LEN)			\
-{												\
-	u16	var_len;							\
-												\
+{									\
+	u16	var_len;						\
+									\
 	var_len = (_V[0]<<8) | (_V[1]);				\
-	var_len += _LEN;							\
-												\
+	var_len += _LEN;						\
+									\
 	_V[0] = (var_len & 0xFF00) >> 8;			\
 	_V[1] = (var_len & 0xFF);					\
 }
@@ -181,15 +181,14 @@
 #define	CONV_ARRARY_TO_u16(_V)	((_V[0]<<8) | (_V[1]))

 #define	ADD_ONE_To_64BIT_VAR(_V)		\
-{										\
+{									\
 	u8	cnt = LEN_KEY_DESC_REPLAY;	\
-	do									\
-	{									\
+	do {						\		\
 		cnt--;							\
 		_V[cnt]++;						\
 		if (cnt == 0)					\
 			break;						\
-	}while (_V[cnt] == 0);				\
+	} while (_V[cnt] == 0);				\
 }

 #define IS_WPA_CAPABILITY(a)       (((a) >= Ndis802_11AuthModeWPA) && ((a) <= Ndis802_11AuthModeWPA1PSKWPA2PSK))
@@ -294,7 +293,8 @@ struct PACKED rt_eap_hdr {
 	u8 Body_Len[2];
 	u8 code;
 	u8 identifier;
-	u8 length[2];	/* including code and identifier, followed by length-2 octets of data */
+	u8 length[2];
+	/*including code and identifier, followed by length-2 octets of data*/
 };

 /* For supplicant state machine states. 802.11i Draft 4.1, p. 97 */
@@ -368,19 +368,19 @@ struct PACKED rt_rsn_capability {
 /*========================================
 	The prototype is defined in cmm_wpa.c
   ========================================*/
-BOOLEAN WpaMsgTypeSubst(u8 EAPType, int * MsgType);
+BOOLEAN WpaMsgTypeSubst(u8 EAPType, int *MsgType);

-void PRF(u8 * key,
+void PRF(u8 *key,
 	 int key_len,
-	 u8 * prefix,
+	 u8 *prefix,
 	 int prefix_len,
-	 u8 * data, int data_len, u8 * output, int len);
+	 u8 *data, int data_len, u8 *output, int len);

 int PasswordHash(char *password,
 		 unsigned char *ssid, int ssidlength, unsigned char *output);

 u8 *GetSuiteFromRSNIE(u8 *rsnie,
-			 u32 rsnie_len, u8 type, u8 * count);
+			 u32 rsnie_len, u8 type, u8 *count);

 void WpaShowAllsuite(u8 *rsnie, u32 rsnie_len);

--
1.7.0.1

