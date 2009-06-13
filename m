Return-Path: <linux-kernel-owner+w=401wt.eu-S932452AbZFMQg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452AbZFMQg4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 12:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763518AbZFMQdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 12:33:49 -0400
Received: from mail-fx0-f206.google.com ([209.85.220.206]:52100 "EHLO
	mail-fx0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762597AbZFMQdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 12:33:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=Xx8IzdLt15gcwGWn3PEpZq8BpfSSoVTH3WD3u0UD4yAEWAsQrVK4JVs48QdG3/KIbu
         3TzW5HQiQ2l8Y4Tpjz/RbSNn9k9XEQlgjXzKYP00HTPfCClmJcqvPKsPm7RiFKBQLmkX
         f89egKQJaAjY2aupJkCktW8bsBfhtYJXxfB4Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Greg KH <gregkh@suse.de>
Subject: [PATCH 3/4] Staging: rtl8192su/ieee80211: remove unused _ReasonCode enums
Date: Sat, 13 Jun 2009 18:36:47 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090612-07181-g84f26e4; KDE/4.2.3; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906131836.47404.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8192su/ieee80211/ieee80211.h |   49 ------------------------
 1 file changed, 49 deletions(-)

Index: b/drivers/staging/rtl8192su/ieee80211/ieee80211.h
===================================================================
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211.h
@@ -214,55 +214,6 @@ typedef struct cb_desc {
 #define	MGN_MCS14_SG		0x9e
 #define	MGN_MCS15_SG		0x9f
 
-
-//----------------------------------------------------------------------------
-//		802.11 Management frame Reason Code field
-//----------------------------------------------------------------------------
-enum	_ReasonCode{
-	unspec_reason	= 0x1,
-	auth_not_valid	= 0x2,
-	deauth_lv_ss	= 0x3,
-	inactivity		= 0x4,
-	ap_overload 	= 0x5,
-	class2_err		= 0x6,
-	class3_err		= 0x7,
-	disas_lv_ss 	= 0x8,
-	asoc_not_auth	= 0x9,
-
-	//----MIC_CHECK
-	mic_failure 	= 0xe,
-	//----END MIC_CHECK
-
-	// Reason code defined in 802.11i D10.0 p.28.
-	invalid_IE		= 0x0d,
-	four_way_tmout	= 0x0f,
-	two_way_tmout	= 0x10,
-	IE_dismatch 	= 0x11,
-	invalid_Gcipher = 0x12,
-	invalid_Pcipher = 0x13,
-	invalid_AKMP	= 0x14,
-	unsup_RSNIEver = 0x15,
-	invalid_RSNIE	= 0x16,
-	auth_802_1x_fail= 0x17,
-	ciper_reject		= 0x18,
-
-	// Reason code defined in 7.3.1.7, 802.1e D13.0, p.42. Added by Annie, 2005-11-15.
-	QoS_unspec		= 0x20, // 32
-	QAP_bandwidth	= 0x21, // 33
-	poor_condition	= 0x22, // 34
-	no_facility 	= 0x23, // 35
-							// Where is 36???
-	req_declined	= 0x25, // 37
-	invalid_param	= 0x26, // 38
-	req_not_honored= 0x27,	// 39
-	TS_not_created	= 0x2F, // 47
-	DL_not_allowed	= 0x30, // 48
-	dest_not_exist	= 0x31, // 49
-	dest_not_QSTA	= 0x32, // 50
-};
-
-
-
 #define aSifsTime	 (((priv->ieee80211->current_network.mode == IEEE_A)||(priv->ieee80211->current_network.mode == IEEE_N_24G)||(priv->ieee80211->current_network.mode == IEEE_N_5G))? 16 : 10)
 
 #define MGMT_QUEUE_NUM 5
