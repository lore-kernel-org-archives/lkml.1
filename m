Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab0BNTib (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 14:38:31 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:33855 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab0BNTi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 14:38:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QPVJ1l8L2HzKZLhLYKhOkOlmcqNA0CSP1CL4HIIy3tYc73ZerGQd8Qzp6AdaQJjdvJ
         RZJV3WzJtDAYyUMTZ8rCwfDb04eBbJW37nK2xQoRZke7LXZaylE1zHbpKBhcA/jQkDq6
         nDuQUElA0JCiwrIbMewpdvDRGismJdu9nGU+E=
From: Alessandro Ghedini <al3xbio@gmail.com>
To: gregkh@suse.de, jmm@debian.org, mithlesh@linsyssoft.com,
       karllinuxtest.relton@ntlworld.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Alessandro Ghedini <al3xbio@gmail.com>
Subject: [PATCH] Staging: wlan-ng: fix most of the style issues in hfa384x.h
Date: Sun, 14 Feb 2010 20:38:16 +0100
Message-Id: <1266176296-20199-1-git-send-email-al3xbio@gmail.com>
X-Mailer: git-send-email 1.6.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes all the errors and the majority of the warnings found with
checkpatch.pl script in hfa384x.h

Signed-off-by: Alessandro Ghedini <al3xbio@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x.h |  173 ++++++++++++++++++++++--------------
 1 files changed, 106 insertions(+), 67 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x.h b/drivers/staging/wlan-ng/hfa384x.h
index 46cce81..8e39f76 100644
--- a/drivers/staging/wlan-ng/hfa384x.h
+++ b/drivers/staging/wlan-ng/hfa384x.h
@@ -63,13 +63,20 @@
 /*--- Mins & Maxs -----------------------------------*/
 #define		HFA384x_PORTID_MAX		((u16)7)
 #define		HFA384x_NUMPORTS_MAX		((u16)(HFA384x_PORTID_MAX+1))
-#define		HFA384x_PDR_LEN_MAX		((u16)512)	/* in bytes, from EK */
+#define		HFA384x_PDR_LEN_MAX		((u16)512) 	/*
+								 * in bytes,
+								 * from EK
+								 */
 #define		HFA384x_PDA_RECS_MAX		((u16)200)	/* a guess */
-#define		HFA384x_PDA_LEN_MAX		((u16)1024)	/* in bytes, from EK */
+#define		HFA384x_PDA_LEN_MAX		((u16)1024)	/*
+								 * in bytes,
+								 * from EK
+								 */
 #define		HFA384x_SCANRESULT_MAX		((u16)31)
 #define		HFA384x_HSCANRESULT_MAX		((u16)31)
 #define		HFA384x_CHINFORESULT_MAX	((u16)16)
-#define		HFA384x_RID_GUESSING_MAXLEN	2048	/* I'm not really sure */
+#define		HFA384x_RID_GUESSING_MAXLEN	2048	/* I'm not
+							 * really sure */
 #define		HFA384x_RIDDATA_MAXLEN		HFA384x_RID_GUESSING_MAXLEN
 #define		HFA384x_USB_RWMEM_MAXLEN	2048
 
@@ -114,9 +121,9 @@
 #define		HFA384x_ADDR_AUX_OFF_MASK	(0x007f)
 
 /* Make a 32-bit flat address from AUX format 16-bit page and offset */
-#define		HFA384x_ADDR_AUX_MKFLAT(p, o)	\
-		(((u32)(((u16)(p))&HFA384x_ADDR_AUX_PAGE_MASK)) << 7) | \
-		((u32)(((u16)(o))&HFA384x_ADDR_AUX_OFF_MASK))
+#define		HFA384x_ADDR_AUX_MKFLAT(p, o) \
+		((((u32)(((u16)(p))&HFA384x_ADDR_AUX_PAGE_MASK)) << 7) | \
+		((u32)(((u16)(o))&HFA384x_ADDR_AUX_OFF_MASK)))
 
 /* Make CMD format offset and page from a 32-bit flat address */
 #define		HFA384x_ADDR_CMD_MKPAGE(f) \
@@ -135,12 +142,21 @@
 #define		HFA384x_DLSTATE_FLASHENABLED		2
 
 /*--- Register Field Masks --------------------------*/
-#define		HFA384x_CMD_AINFO		((u16)(BIT(14) | BIT(13) | BIT(12) | BIT(11) | BIT(10) | BIT(9) | BIT(8)))
-#define		HFA384x_CMD_MACPORT		((u16)(BIT(10) | BIT(9) | BIT(8)))
+#define		HFA384x_CMD_AINFO		((u16)(BIT(14) | BIT(13) \
+							| BIT(12) | BIT(11) \
+							| BIT(10) | BIT(9) \
+							| BIT(8)))
+#define		HFA384x_CMD_MACPORT		((u16)(BIT(10) | BIT(9) | \
+							BIT(8)))
 #define		HFA384x_CMD_PROGMODE		((u16)(BIT(9) | BIT(8)))
-#define		HFA384x_CMD_CMDCODE		((u16)(BIT(5) | BIT(4) | BIT(3) | BIT(2) | BIT(1) | BIT(0)))
+#define		HFA384x_CMD_CMDCODE		((u16)(BIT(5) | BIT(4) | \
+							BIT(3) | BIT(2) | \
+							BIT(1) | BIT(0)))
 
-#define		HFA384x_STATUS_RESULT		((u16)(BIT(14) | BIT(13) | BIT(12) | BIT(11) | BIT(10) | BIT(9) | BIT(8)))
+#define		HFA384x_STATUS_RESULT		((u16)(BIT(14) | BIT(13) \
+							| BIT(12) | BIT(11) \
+							| BIT(10) | BIT(9) \
+							| BIT(8)))
 
 /*--- Command Code Constants --------------------------*/
 /*--- Controller Commands --------------------------*/
@@ -244,8 +260,10 @@ Information RID Lengths:  MAC Information
   This is the length of JUST the DATA part of the RID (does not
   include the len or code fields)
 --------------------------------------------------------------------*/
-#define		HFA384x_RID_DBMCOMMSQUALITY_LEN		((u16)sizeof(hfa384x_dbmcommsquality_t))
-#define		HFA384x_RID_JOINREQUEST_LEN		((u16)sizeof(hfa384x_JoinRequest_data_t))
+#define		HFA384x_RID_DBMCOMMSQUALITY_LEN	 \
+	((u16) sizeof(hfa384x_dbmcommsquality_t))
+#define		HFA384x_RID_JOINREQUEST_LEN \
+	((u16)sizeof(hfa384x_JoinRequest_data_t))
 
 /*--------------------------------------------------------------------
 Information RIDs:  Modem Information
@@ -322,9 +340,11 @@ PD Record codes
 
 /*--- Register Test/Get/Set Field macros ------------------------*/
 
-#define		HFA384x_CMD_AINFO_SET(value)		((u16)((u16)(value) << 8))
-#define		HFA384x_CMD_MACPORT_SET(value)		((u16)HFA384x_CMD_AINFO_SET(value))
-#define		HFA384x_CMD_PROGMODE_SET(value)		((u16)HFA384x_CMD_AINFO_SET((u16)value))
+#define		HFA384x_CMD_AINFO_SET(value)	((u16)((u16)(value) << 8))
+#define		HFA384x_CMD_MACPORT_SET(value)	\
+			((u16)HFA384x_CMD_AINFO_SET(value))
+#define		HFA384x_CMD_PROGMODE_SET(value)	\
+			((u16)HFA384x_CMD_AINFO_SET((u16)value))
 #define		HFA384x_CMD_CMDCODE_SET(value)		((u16)(value))
 
 #define		HFA384x_STATUS_RESULT_SET(value)	(((u16)(value)) << 8)
@@ -402,7 +422,7 @@ typedef struct hfa384x_authenticateStation_data {
 /*-- Configuration Record: WPAData       (data portion only) --*/
 typedef struct hfa384x_WPAData {
 	u16 datalen;
-	u8 data[0];		// max 80
+	u8 data[0];		/* max 80 */
 } __attribute__ ((packed)) hfa384x_WPAData_t;
 
 /*--------------------------------------------------------------------
@@ -479,7 +499,8 @@ Communication Frames: Field Masks for Transmit Frames
 #define		HFA384x_TXSTATUS_AGEDERR		((u16)BIT(1))
 #define		HFA384x_TXSTATUS_RETRYERR		((u16)BIT(0))
 /*-- Transmit Control Field --*/
-#define		HFA384x_TX_MACPORT			((u16)(BIT(10) | BIT(9) | BIT(8)))
+#define		HFA384x_TX_MACPORT			((u16)(BIT(10) | \
+							  BIT(9) | BIT(8)))
 #define		HFA384x_TX_STRUCTYPE			((u16)(BIT(4) | BIT(3)))
 #define		HFA384x_TX_TXEX				((u16)BIT(2))
 #define		HFA384x_TX_TXOK				((u16)BIT(1))
@@ -496,7 +517,8 @@ Communication Frames: Test/Get/Set Field Values for Transmit Frames
 #define	HFA384x_TX_SET(v, m, s)		((((u16)(v))<<((u16)(s)))&((u16)(m)))
 
 #define	HFA384x_TX_MACPORT_SET(v)	HFA384x_TX_SET(v, HFA384x_TX_MACPORT, 8)
-#define	HFA384x_TX_STRUCTYPE_SET(v)	HFA384x_TX_SET(v, HFA384x_TX_STRUCTYPE, 3)
+#define	HFA384x_TX_STRUCTYPE_SET(v)	HFA384x_TX_SET(v, \
+						HFA384x_TX_STRUCTYPE, 3)
 #define	HFA384x_TX_TXEX_SET(v)		HFA384x_TX_SET(v, HFA384x_TX_TXEX, 2)
 #define	HFA384x_TX_TXOK_SET(v)		HFA384x_TX_SET(v, HFA384x_TX_TXOK, 1)
 /*--------------------------------------------------------------------
@@ -534,13 +556,17 @@ Communication Frames: Field Masks for Receive Frames
 --------------------------------------------------------------------*/
 
 /*-- Status Fields --*/
-#define		HFA384x_RXSTATUS_MACPORT		((u16)(BIT(10) | BIT(9) | BIT(8)))
+#define		HFA384x_RXSTATUS_MACPORT		((u16)(BIT(10) | \
+								BIT(9) | \
+								BIT(8)))
 #define		HFA384x_RXSTATUS_FCSERR			((u16)BIT(0))
 /*--------------------------------------------------------------------
 Communication Frames: Test/Get/Set Field Values for Receive Frames
 --------------------------------------------------------------------*/
-#define		HFA384x_RXSTATUS_MACPORT_GET(value)	((u16)((((u16)(value)) & HFA384x_RXSTATUS_MACPORT) >> 8))
-#define		HFA384x_RXSTATUS_ISFCSERR(value)	((u16)(((u16)(value)) & HFA384x_RXSTATUS_FCSERR))
+#define		HFA384x_RXSTATUS_MACPORT_GET(value)	((u16)((((u16)(value)) \
+					    & HFA384x_RXSTATUS_MACPORT) >> 8))
+#define		HFA384x_RXSTATUS_ISFCSERR(value)	((u16)(((u16)(value)) \
+						  & HFA384x_RXSTATUS_FCSERR))
 /*--------------------------------------------------------------------
  FRAME STRUCTURES: Information Types and Information Frame Structures
 ----------------------------------------------------------------------
@@ -1133,7 +1159,7 @@ struct hfa384x;
 
 typedef void (*ctlx_cmdcb_t) (struct hfa384x *, const struct hfa384x_usbctlx *);
 
-typedef void (*ctlx_usercb_t) (struct hfa384x * hw,
+typedef void (*ctlx_usercb_t) (struct hfa384x *hw,
 			       void *ctlxresult, void *usercb_data);
 
 typedef struct hfa384x_usbctlx {
@@ -1174,14 +1200,14 @@ typedef struct hfa484x_metacmd {
 } hfa384x_metacmd_t;
 
 #define	MAX_GRP_ADDR		32
-#define WLAN_COMMENT_MAX	80	/* Max. length of user comment string. */
+#define WLAN_COMMENT_MAX	80  /* Max. length of user comment string. */
 
-#define WLAN_AUTH_MAX           60	/* Max. # of authenticated stations. */
-#define WLAN_ACCESS_MAX		60	/* Max. # of stations in an access list. */
-#define WLAN_ACCESS_NONE	0	/* No stations may be authenticated. */
-#define WLAN_ACCESS_ALL		1	/* All stations may be authenticated. */
-#define WLAN_ACCESS_ALLOW	2	/* Authenticate only "allowed" stations. */
-#define WLAN_ACCESS_DENY	3	/* Do not authenticate "denied" stations. */
+#define WLAN_AUTH_MAX           60  /* Max. # of authenticated stations. */
+#define WLAN_ACCESS_MAX		60  /* Max. # of stations in an access list. */
+#define WLAN_ACCESS_NONE	0   /* No stations may be authenticated. */
+#define WLAN_ACCESS_ALL		1   /* All stations may be authenticated. */
+#define WLAN_ACCESS_ALLOW	2   /* Authenticate only "allowed" stations. */
+#define WLAN_ACCESS_DENY	3   /* Do not authenticate "denied" stations. */
 
 /* XXX These are going away ASAP */
 typedef struct prism2sta_authlist {
@@ -1294,10 +1320,23 @@ typedef struct hfa384x {
 	hfa384x_caplevel_t cap_sup_ap;
 
 	/* Actor compatibility ranges */
-	hfa384x_caplevel_t cap_act_pri_cfi;	/* pri f/w to controller interface */
-	hfa384x_caplevel_t cap_act_sta_cfi;	/* sta f/w to controller interface */
+	hfa384x_caplevel_t cap_act_pri_cfi;	/*
+						 * pri f/w to controller
+						 * interface
+						 */
+
+	hfa384x_caplevel_t cap_act_sta_cfi;	/*
+						 * sta f/w to controller
+						 * interface
+						 */
+
 	hfa384x_caplevel_t cap_act_sta_mfi;	/* sta f/w to modem interface */
-	hfa384x_caplevel_t cap_act_ap_cfi;	/* ap f/w to controller interface */
+
+	hfa384x_caplevel_t cap_act_ap_cfi;	/*
+						 * ap f/w to controller
+						 * interface
+						 */
+
 	hfa384x_caplevel_t cap_act_ap_mfi;	/* ap f/w to modem interface */
 
 	u32 psusercount;	/* Power save user count. */
@@ -1320,25 +1359,25 @@ typedef struct hfa384x {
 
 } hfa384x_t;
 
-void hfa384x_create(hfa384x_t * hw, struct usb_device *usb);
-void hfa384x_destroy(hfa384x_t * hw);
+void hfa384x_create(hfa384x_t *hw, struct usb_device *usb);
+void hfa384x_destroy(hfa384x_t *hw);
 
 int
-hfa384x_corereset(hfa384x_t * hw, int holdtime, int settletime, int genesis);
-int hfa384x_drvr_commtallies(hfa384x_t * hw);
-int hfa384x_drvr_disable(hfa384x_t * hw, u16 macport);
-int hfa384x_drvr_enable(hfa384x_t * hw, u16 macport);
-int hfa384x_drvr_flashdl_enable(hfa384x_t * hw);
-int hfa384x_drvr_flashdl_disable(hfa384x_t * hw);
-int hfa384x_drvr_flashdl_write(hfa384x_t * hw, u32 daddr, void *buf, u32 len);
-int hfa384x_drvr_getconfig(hfa384x_t * hw, u16 rid, void *buf, u16 len);
-int hfa384x_drvr_ramdl_enable(hfa384x_t * hw, u32 exeaddr);
-int hfa384x_drvr_ramdl_disable(hfa384x_t * hw);
-int hfa384x_drvr_ramdl_write(hfa384x_t * hw, u32 daddr, void *buf, u32 len);
-int hfa384x_drvr_readpda(hfa384x_t * hw, void *buf, unsigned int len);
-int hfa384x_drvr_setconfig(hfa384x_t * hw, u16 rid, void *buf, u16 len);
-
-static inline int hfa384x_drvr_getconfig16(hfa384x_t * hw, u16 rid, void *val)
+hfa384x_corereset(hfa384x_t *hw, int holdtime, int settletime, int genesis);
+int hfa384x_drvr_commtallies(hfa384x_t *hw);
+int hfa384x_drvr_disable(hfa384x_t *hw, u16 macport);
+int hfa384x_drvr_enable(hfa384x_t *hw, u16 macport);
+int hfa384x_drvr_flashdl_enable(hfa384x_t *hw);
+int hfa384x_drvr_flashdl_disable(hfa384x_t *hw);
+int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len);
+int hfa384x_drvr_getconfig(hfa384x_t *hw, u16 rid, void *buf, u16 len);
+int hfa384x_drvr_ramdl_enable(hfa384x_t *hw, u32 exeaddr);
+int hfa384x_drvr_ramdl_disable(hfa384x_t *hw);
+int hfa384x_drvr_ramdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len);
+int hfa384x_drvr_readpda(hfa384x_t *hw, void *buf, unsigned int len);
+int hfa384x_drvr_setconfig(hfa384x_t *hw, u16 rid, void *buf, u16 len);
+
+static inline int hfa384x_drvr_getconfig16(hfa384x_t *hw, u16 rid, void *val)
 {
 	int result = 0;
 	result = hfa384x_drvr_getconfig(hw, rid, val, sizeof(u16));
@@ -1347,46 +1386,46 @@ static inline int hfa384x_drvr_getconfig16(hfa384x_t * hw, u16 rid, void *val)
 	return result;
 }
 
-static inline int hfa384x_drvr_setconfig16(hfa384x_t * hw, u16 rid, u16 val)
+static inline int hfa384x_drvr_setconfig16(hfa384x_t *hw, u16 rid, u16 val)
 {
 	u16 value = cpu_to_le16(val);
 	return hfa384x_drvr_setconfig(hw, rid, &value, sizeof(value));
 }
 
 int
-hfa384x_drvr_getconfig_async(hfa384x_t * hw,
+hfa384x_drvr_getconfig_async(hfa384x_t *hw,
 			     u16 rid, ctlx_usercb_t usercb, void *usercb_data);
 
 int
-hfa384x_drvr_setconfig_async(hfa384x_t * hw,
+hfa384x_drvr_setconfig_async(hfa384x_t *hw,
 			     u16 rid,
 			     void *buf,
 			     u16 len, ctlx_usercb_t usercb, void *usercb_data);
 
 static inline int
-hfa384x_drvr_setconfig16_async(hfa384x_t * hw, u16 rid, u16 val)
+hfa384x_drvr_setconfig16_async(hfa384x_t *hw, u16 rid, u16 val)
 {
 	u16 value = cpu_to_le16(val);
 	return hfa384x_drvr_setconfig_async(hw, rid, &value, sizeof(value),
 					    NULL, NULL);
 }
 
-int hfa384x_drvr_start(hfa384x_t * hw);
-int hfa384x_drvr_stop(hfa384x_t * hw);
+int hfa384x_drvr_start(hfa384x_t *hw);
+int hfa384x_drvr_stop(hfa384x_t *hw);
 int
-hfa384x_drvr_txframe(hfa384x_t * hw, struct sk_buff *skb,
-		     p80211_hdr_t * p80211_hdr, p80211_metawep_t * p80211_wep);
-void hfa384x_tx_timeout(wlandevice_t * wlandev);
-
-int hfa384x_cmd_initialize(hfa384x_t * hw);
-int hfa384x_cmd_enable(hfa384x_t * hw, u16 macport);
-int hfa384x_cmd_disable(hfa384x_t * hw, u16 macport);
-int hfa384x_cmd_allocate(hfa384x_t * hw, u16 len);
-int hfa384x_cmd_monitor(hfa384x_t * hw, u16 enable);
+hfa384x_drvr_txframe(hfa384x_t *hw, struct sk_buff *skb,
+		     p80211_hdr_t *p80211_hdr, p80211_metawep_t *p80211_wep);
+void hfa384x_tx_timeout(wlandevice_t *wlandev);
+
+int hfa384x_cmd_initialize(hfa384x_t *hw);
+int hfa384x_cmd_enable(hfa384x_t *hw, u16 macport);
+int hfa384x_cmd_disable(hfa384x_t *hw, u16 macport);
+int hfa384x_cmd_allocate(hfa384x_t *hw, u16 len);
+int hfa384x_cmd_monitor(hfa384x_t *hw, u16 enable);
 int
-hfa384x_cmd_download(hfa384x_t * hw,
+hfa384x_cmd_download(hfa384x_t *hw,
 		     u16 mode, u16 lowaddr, u16 highaddr, u16 codelen);
 
-#endif /* __KERNEL__ */
+#endif /*__KERNEL__ */
 
-#endif /* _HFA384x_H */
+#endif /*_HFA384x_H */
-- 
1.6.6.2

