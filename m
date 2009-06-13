Return-Path: <linux-kernel-owner+w=401wt.eu-S1764761AbZFMQfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764761AbZFMQfQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 12:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762765AbZFMQdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 12:33:39 -0400
Received: from mail-fx0-f206.google.com ([209.85.220.206]:65246 "EHLO
	mail-fx0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762599AbZFMQdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 12:33:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=cDZ+7Q17DzM4sIZXc1ff4LgCieM2o5QKPRwmxbhmASCAmr1uz+QCo4OYznMING14DN
         QegF57VvqDgnLnOeX2AtkCSG4wCByzFsdw642weexTrh3MMzDAvPHSTOSOU8UEOuqTnS
         mLizY747FW3GHdOg9DXPi9Pz3/907gDABFEtQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Greg KH <gregkh@suse.de>
Subject: [PATCH 4/6] Staging: rtl8187se/ieee80211: remove superfluous ieee80211_* defines
Date: Sat, 13 Jun 2009 18:32:41 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090612-07181-g84f26e4; KDE/4.2.3; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906131832.41713.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8187se/ieee80211/ieee80211.h |   51 ------------------------
 1 file changed, 51 deletions(-)

Index: b/drivers/staging/rtl8187se/ieee80211/ieee80211.h
===================================================================
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211.h
@@ -105,57 +105,6 @@
 
 #define	IEEE_CRYPT_ALG_NAME_LEN			16
 
-#define ieee80211_wx_get_scan ieee80211_wx_get_scan_rtl
-#define ieee80211_wx_set_encode ieee80211_wx_set_encode_rtl
-#define ieee80211_wx_get_encode ieee80211_wx_get_encode_rtl
-////////////////////////////////
-// added for kernel conflict under FC5
-#define ieee80211_wx_get_name   ieee80211_wx_get_name_rtl
-#define free_ieee80211          free_ieee80211_rtl
-#define alloc_ieee80211        alloc_ieee80211_rtl
-///////////////////////////////
-
-//error in ubuntu2.6.22,so add these
-#define ieee80211_wake_queue ieee80211_wake_queue_rtl
-#define ieee80211_stop_queue ieee80211_stop_queue_rtl
-
-#define ieee80211_rx ieee80211_rx_rtl
-
-#define ieee80211_register_crypto_ops	ieee80211_register_crypto_ops_rtl
-#define ieee80211_unregister_crypto_ops	ieee80211_unregister_crypto_ops_rtl
-#define ieee80211_get_crypto_ops	ieee80211_get_crypto_ops_rtl
-#define ieee80211_crypt_deinit_entries	ieee80211_crypt_deinit_entries_rtl
-#define ieee80211_crypt_deinit_handler	ieee80211_crypt_deinit_handler_rtl
-#define ieee80211_crypt_delayed_deinit	ieee80211_crypt_delayed_deinit_rtl
-
-#define ieee80211_txb_free	ieee80211_txb_free_rtl
-#define ieee80211_wx_get_essid	ieee80211_wx_get_essid_rtl
-#define ieee80211_wx_set_essid	ieee80211_wx_set_essid_rtl
-#define ieee80211_wx_set_rate	ieee80211_wx_set_rate_rtl
-#define ieee80211_wx_get_rate	ieee80211_wx_get_rate_rtl
-#define ieee80211_wx_set_wap	ieee80211_wx_set_wap_rtl
-#define ieee80211_wx_get_wap	ieee80211_wx_get_wap_rtl
-#define ieee80211_wx_set_mode	ieee80211_wx_set_mode_rtl
-#define ieee80211_wx_get_mode	ieee80211_wx_get_mode_rtl
-#define ieee80211_wx_set_scan	ieee80211_wx_set_scan_rtl
-#define ieee80211_wx_get_freq	ieee80211_wx_get_freq_rtl
-#define ieee80211_wx_set_freq	ieee80211_wx_set_freq_rtl
-#define ieee80211_wx_set_rawtx	ieee80211_wx_set_rawtx_rtl
-#define ieee80211_wx_set_power	ieee80211_wx_set_power_rtl
-#define ieee80211_wx_get_power	ieee80211_wx_get_power_rtl
-#define ieee80211_wlan_frequencies	ieee80211_wlan_frequencies_rtl
-#define ieee80211_softmac_stop_protocol	ieee80211_softmac_stop_protocol_rtl
-#define ieee80211_softmac_start_protocol ieee80211_softmac_start_protocol_rtl
-#define	ieee80211_start_protocol	ieee80211_start_protocol_rtl
-#define	ieee80211_stop_protocol		ieee80211_stop_protocol_rtl
-#define	ieee80211_rx_mgt		ieee80211_rx_mgt_rtl
-
-#define ieee80211_wx_set_auth ieee80211_wx_set_auth_rtl
-//by amy for ps
-#define notify_wx_assoc_event  notify_wx_assoc_event_rtl
-#define ieee80211_stop_send_beacons ieee80211_stop_send_beacons_rtl
-#define ieee80211_disassociate ieee80211_disassociate_rtl
-#define ieee80211_start_scan ieee80211_start_scan_rtl
 //by amy for ps
 typedef struct ieee_param {
 	u32 cmd;
