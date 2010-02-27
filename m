Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968597Ab0B0Qo1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:44:27 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:58825 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968575Ab0B0Qo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:44:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=GfvO9Cuh5qY1/B7rJBhvmxAZlVhRm6UW1RdwlLaU7VYDUHyTFIq+GP2diBztvNUF6h
         6X6AMv8u7Tu59+rJgvgx1FEm8AFX8vWreGNITC4C6jbIrfQMrb/F5InDlSU8wPCQVM0O
         oAykZlxdOZA+i8Z5lfKFkPiJTWwZKwwK7TsKg=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: gregkh@suse.de
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, Jim Lieb <lieb@canonical.com>,
       Forest Bond <forest@alittletooquiet.net>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: vt6655: 80211hdr.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:43:22 +0100
Message-Id: <1267289010-23161-1-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: do not use C99 // comments
+// bit type

ERROR: do not use C99 // comments
+// 802.11 frame related, defined as 802.11 spec

ERROR: do not use C99 // comments
+//#define WLAN_RATES_MAXLEN           255

ERROR: do not use C99 // comments
+//#define WLAN_WEPMAX_KEYLEN          29

ERROR: do not use C99 // comments
+// Frame Type

ERROR: do not use C99 // comments
+// Frame Subtypes

ERROR: do not use C99 // comments
+// Control

ERROR: do not use C99 // comments
+// Data

ERROR: do not use C99 // comments
+// GET & SET Frame Control bit

ERROR: do not use C99 // comments
+// Sequence Field bit

ERROR: do not use C99 // comments
+// Capability Field bit

ERROR: do not use C99 // comments
+// GET & SET Frame Control bit

ERROR: do not use C99 // comments
+// Sequence Field bit

ERROR: do not use C99 // comments
+// Capability Field bit

ERROR: do not use C99 // comments
+#endif //#ifdef __BIG_ENDIAN

ERROR: do not use C99 // comments
+// ERP Field bit

ERROR: do not use C99 // comments
+// Support & Basic Rates field

ERROR: do not use C99 // comments
+// TIM field

ERROR: do not use C99 // comments
+// 3-Addr & 4-Addr

ERROR: do not use C99 // comments
+// IEEE ADDR

ERROR: do not use C99 // comments
+// 802.11 Header Format

ERROR: space required after that close brace '}'
+}__attribute__ ((__packed__))

ERROR: space required after that close brace '}'
+}__attribute__ ((__packed__))

ERROR: space required after that close brace '}'
+}__attribute__ ((__packed__))

ERROR: do not use C99 // comments
+#endif // __80211HDR_H__

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net
---
 drivers/staging/vt6655/80211hdr.h |   46 ++++++++++++++++++------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/vt6655/80211hdr.h b/drivers/staging/vt6655/80211hdr.h
index e5cee6f..b7b170e 100644
--- a/drivers/staging/vt6655/80211hdr.h
+++ b/drivers/staging/vt6655/80211hdr.h
@@ -34,7 +34,7 @@
 #include "ttype.h"
 
 /*---------------------  Export Definitions -------------------------*/
-// bit type
+/* bit type */
 #define BIT0	0x00000001
 #define BIT1	0x00000002
 #define BIT2	0x00000004
@@ -80,7 +80,7 @@
 #define WLAN_HDR_ADDR4_LEN          30
 #define WLAN_IEHDR_LEN              2
 #define WLAN_SSID_MAXLEN            32
-//#define WLAN_RATES_MAXLEN           255
+/*#define WLAN_RATES_MAXLEN           255*/
 #define WLAN_RATES_MAXLEN           16
 #define WLAN_RATES_MAXLEN_11B       4
 #define WLAN_RSN_MAXLEN             32
@@ -106,7 +106,7 @@
 #define WLAN_WEP40_KEYLEN           5
 #define WLAN_WEP104_KEYLEN          13
 #define WLAN_WEP232_KEYLEN          29
-//#define WLAN_WEPMAX_KEYLEN          29
+/*#define WLAN_WEPMAX_KEYLEN          29*/
 #define WLAN_WEPMAX_KEYLEN          32
 #define WLAN_CHALLENGE_IE_MAXLEN    255
 #define WLAN_CHALLENGE_IE_LEN       130
@@ -115,7 +115,7 @@
 #define WLAN_WEP_ICV_LEN            4
 #define WLAN_FRAGS_MAX              16
 
-// Frame Type
+/* Frame Type */
 #define WLAN_TYPE_MGR 0x00
 #define WLAN_TYPE_CTL  0x01
 #define WLAN_TYPE_DATA 0x02
@@ -125,7 +125,7 @@
 #define WLAN_FTYPE_DATA 0x02
 
 
-// Frame Subtypes
+/* Frame Subtypes */
 #define WLAN_FSTYPE_ASSOCREQ        0x00
 #define WLAN_FSTYPE_ASSOCRESP       0x01
 #define WLAN_FSTYPE_REASSOCREQ      0x02
@@ -139,7 +139,7 @@
 #define WLAN_FSTYPE_DEAUTHEN        0x0c
 #define WLAN_FSTYPE_ACTION          0x0d
 
-// Control
+/* Control */
 #define WLAN_FSTYPE_PSPOLL          0x0a
 #define WLAN_FSTYPE_RTS             0x0b
 #define WLAN_FSTYPE_CTS             0x0c
@@ -147,7 +147,7 @@
 #define WLAN_FSTYPE_CFEND           0x0e
 #define WLAN_FSTYPE_CFENDCFACK      0x0f
 
-// Data
+/* Data */
 #define WLAN_FSTYPE_DATAONLY        0x00
 #define WLAN_FSTYPE_DATA_CFACK      0x01
 #define WLAN_FSTYPE_DATA_CFPOLL     0x02
@@ -160,7 +160,7 @@
 
 #ifdef __BIG_ENDIAN
 
-// GET & SET Frame Control bit
+/* GET & SET Frame Control bit */
 #define WLAN_GET_FC_PRVER(n)    ((((WORD)(n) >> 8) & (BIT0 | BIT1))
 #define WLAN_GET_FC_FTYPE(n)    ((((WORD)(n) >> 8) & (BIT2 | BIT3)) >> 2)
 #define WLAN_GET_FC_FSTYPE(n)   ((((WORD)(n) >> 8) & (BIT4|BIT5|BIT6|BIT7)) >> 4)
@@ -173,12 +173,12 @@
 #define WLAN_GET_FC_ISWEP(n)    ((((WORD)(n) << 8) & (BIT14)) >> 14)
 #define WLAN_GET_FC_ORDER(n)    ((((WORD)(n) << 8) & (BIT15)) >> 15)
 
-// Sequence Field bit
+/* Sequence Field bit */
 #define WLAN_GET_SEQ_FRGNUM(n) (((WORD)(n) >> 8) & (BIT0|BIT1|BIT2|BIT3))
 #define WLAN_GET_SEQ_SEQNUM(n) ((((WORD)(n) >> 8) & (~(BIT0|BIT1|BIT2|BIT3))) >> 4)
 
 
-// Capability Field bit
+/* Capability Field bit */
 #define WLAN_GET_CAP_INFO_ESS(n)           (((n) >> 8) & BIT0)
 #define WLAN_GET_CAP_INFO_IBSS(n)          ((((n) >> 8) & BIT1) >> 1)
 #define WLAN_GET_CAP_INFO_CFPOLLABLE(n)    ((((n) >> 8) & BIT2) >> 2)
@@ -195,7 +195,7 @@
 
 #else
 
-// GET & SET Frame Control bit
+/* GET & SET Frame Control bit */
 #define WLAN_GET_FC_PRVER(n)    (((WORD)(n)) & (BIT0 | BIT1))
 #define WLAN_GET_FC_FTYPE(n)    ((((WORD)(n)) & (BIT2 | BIT3)) >> 2)
 #define WLAN_GET_FC_FSTYPE(n)   ((((WORD)(n)) & (BIT4|BIT5|BIT6|BIT7)) >> 4)
@@ -209,12 +209,12 @@
 #define WLAN_GET_FC_ORDER(n)    ((((WORD)(n)) & (BIT15)) >> 15)
 
 
-// Sequence Field bit
+/* Sequence Field bit */
 #define WLAN_GET_SEQ_FRGNUM(n) (((WORD)(n)) & (BIT0|BIT1|BIT2|BIT3))
 #define WLAN_GET_SEQ_SEQNUM(n) ((((WORD)(n)) & (~(BIT0|BIT1|BIT2|BIT3))) >> 4)
 
 
-// Capability Field bit
+/* Capability Field bit */
 #define WLAN_GET_CAP_INFO_ESS(n)           ((n) & BIT0)
 #define WLAN_GET_CAP_INFO_IBSS(n)          (((n) & BIT1) >> 1)
 #define WLAN_GET_CAP_INFO_CFPOLLABLE(n)    (((n) & BIT2) >> 2)
@@ -229,7 +229,7 @@
 #define WLAN_GET_CAP_INFO_GRPACK(n)        (((n) & BIT14) >> 14)
 
 
-#endif //#ifdef __BIG_ENDIAN
+#endif /*#ifdef __BIG_ENDIAN */
 
 
 #define WLAN_SET_CAP_INFO_ESS(n)           (n)
@@ -261,7 +261,7 @@
 #define WLAN_SET_SEQ_FRGNUM(n) ((WORD)(n))
 #define WLAN_SET_SEQ_SEQNUM(n) (((WORD)(n)) << 4)
 
-// ERP Field bit
+/* ERP Field bit */
 
 #define WLAN_GET_ERP_NONERP_PRESENT(n)     ((n) & BIT0)
 #define WLAN_GET_ERP_USE_PROTECTION(n)     (((n) & BIT1) >> 1)
@@ -273,19 +273,19 @@
 
 
 
-// Support & Basic Rates field
+/* Support & Basic Rates field */
 #define WLAN_MGMT_IS_BASICRATE(b)    ((b) & BIT7)
 #define WLAN_MGMT_GET_RATE(b)        ((b) & ~BIT7)
 
-// TIM field
+/* TIM field */
 #define WLAN_MGMT_IS_MULTICAST_TIM(b)   ((b) & BIT0)
 #define WLAN_MGMT_GET_TIM_OFFSET(b)     (((b) & ~BIT0) >> 1)
 
-// 3-Addr & 4-Addr
+/* 3-Addr & 4-Addr */
 #define WLAN_HDR_A3_DATA_PTR(p) (((PBYTE)(p)) + WLAN_HDR_ADDR3_LEN)
 #define WLAN_HDR_A4_DATA_PTR(p) (((PBYTE)(p)) + WLAN_HDR_ADDR4_LEN)
 
-// IEEE ADDR
+/* IEEE ADDR */
 #define IEEE_ADDR_UNIVERSAL         0x02
 #define IEEE_ADDR_GROUP             0x01
 
@@ -293,7 +293,7 @@ typedef struct {
     BYTE            abyAddr[6];
 } IEEE_ADDR, *PIEEE_ADDR;
 
-// 802.11 Header Format
+/* 802.11 Header Format */
 
 typedef struct tagWLAN_80211HDR_A2 {
 
@@ -302,7 +302,7 @@ typedef struct tagWLAN_80211HDR_A2 {
     BYTE    abyAddr1[WLAN_ADDR_LEN];
     BYTE    abyAddr2[WLAN_ADDR_LEN];
 
-}__attribute__ ((__packed__))
+} __attribute__ ((__packed__))
 WLAN_80211HDR_A2, *PWLAN_80211HDR_A2;
 
 typedef struct tagWLAN_80211HDR_A3 {
@@ -327,7 +327,7 @@ typedef struct tagWLAN_80211HDR_A4 {
     WORD    wSeqCtl;
     BYTE    abyAddr4[WLAN_ADDR_LEN];
 
-}__attribute__ ((__packed__))
+} __attribute__ ((__packed__))
 WLAN_80211HDR_A4, *PWLAN_80211HDR_A4;
 
 
@@ -348,6 +348,6 @@ typedef union tagUWLAN_80211HDR {
 
 
 
-#endif // __80211HDR_H__
+#endif /* __80211HDR_H__ */
 
 
-- 
1.7.0.90.g251a4

