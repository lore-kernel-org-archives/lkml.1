Return-Path: <linux-kernel-owner+w=401wt.eu-S1752442AbZLUEJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbZLUEJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 23:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbZLUEJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 23:09:55 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:46410 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbZLUEJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 23:09:55 -0500
Date: Mon, 21 Dec 2009 15:09:53 +1100
From: Simon Horman <horms@verge.net.au>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Moritz Muehlenhoff <jmm@debian.org>,
       Solomon Peachy <pizza@shaftnet.org>, Julia Lawall <julia@diku.dk>,
       Mithlesh Thukral <mithlesh@linsyssoft.com>
Subject: [patch] wlan-ng: initialise mibitem
Message-ID: <20091221040953.GD22636@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$ gcc --version

gcc (Debian 4.4.2-5) 4.4.2
Copyright (C) 2009 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

$ make
...
drivers/staging/wlan-ng/p80211wext.c: In function ‘p80211wext_dorequest’:
drivers/staging/wlan-ng/p80211wext.c:139: warning: ‘mibitem.len’ is used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c:139: warning: ‘mibitem.status’ is used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c: In function ‘p80211wext_giwretry’:
drivers/staging/wlan-ng/p80211wext.c:967: warning: ‘mibitem.len’ is used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c:967: warning: ‘mibitem.status’ is used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c:967: warning: ‘mibitem.data’ is used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c: In function ‘p80211wext_siwretry’:
drivers/staging/wlan-ng/p80211wext.c:1057: warning: ‘mibitem.len’ may be used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c:1057: warning: ‘mibitem.status’ may be used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c: In function ‘p80211wext_giwtxpow’:
drivers/staging/wlan-ng/p80211wext.c:1149: warning: ‘mibitem.len’ is used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c:1149: warning: ‘mibitem.status’ is used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c:1149: warning: ‘mibitem.data’ is used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c: In function ‘p80211wext_siwtxpow’:
drivers/staging/wlan-ng/p80211wext.c:1123: warning: ‘mibitem.len’ may be used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c:1123: warning: ‘mibitem.status’ may be used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c: In function ‘p80211wext_giwfrag’:
drivers/staging/wlan-ng/p80211wext.c:891: warning: ‘mibitem.len’ is used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c:891: warning: ‘mibitem.status’ is used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c:891: warning: ‘mibitem.data’ is used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c: In function ‘p80211wext_siwfrag’:
drivers/staging/wlan-ng/p80211wext.c:933: warning: ‘mibitem.len’ may be used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c:933: warning: ‘mibitem.status’ may be used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c: In function ‘p80211wext_giwrts’:
drivers/staging/wlan-ng/p80211wext.c:826: warning: ‘mibitem.len’ is used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c:826: warning: ‘mibitem.status’ is used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c:826: warning: ‘mibitem.data’ is used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c: In function ‘p80211wext_siwrts’:
drivers/staging/wlan-ng/p80211wext.c:866: warning: ‘mibitem.len’ may be used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c:866: warning: ‘mibitem.status’ may be used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c: In function ‘p80211wext_giwrate’:
drivers/staging/wlan-ng/p80211wext.c:775: warning: ‘mibitem.len’ is used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c:775: warning: ‘mibitem.status’ is used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c:775: warning: ‘mibitem.data’ is used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c: In function ‘p80211wext_giwfreq’:
drivers/staging/wlan-ng/p80211wext.c:273: warning: ‘mibitem.len’ is used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c:273: warning: ‘mibitem.status’ is used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c:273: warning: ‘mibitem.data’ is used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c: In function ‘p80211wext_siwfreq’:
drivers/staging/wlan-ng/p80211wext.c:320: warning: ‘mibitem.len’ may be used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c: In function ‘p80211wext_siwmode’:
drivers/staging/wlan-ng/p80211wext.c:401: warning: ‘mibitem.len’ may be used uninitialized in this function
drivers/staging/wlan-ng/p80211wext.c:401: warning: ‘mibitem.status’ may be used uninitialized in this function
...

Signed-off-by: Simon Horman <horms@verge.net.au>

Index: net-next-2.6/drivers/staging/wlan-ng/p80211wext.c
===================================================================
--- net-next-2.6.orig/drivers/staging/wlan-ng/p80211wext.c	2009-12-21 13:26:39.000000000 +1100
+++ net-next-2.6/drivers/staging/wlan-ng/p80211wext.c	2009-12-21 13:26:42.000000000 +1100
@@ -134,6 +134,7 @@ static int p80211wext_dorequest(wlandevi
 	int result;
 
 	msg.msgcode = DIDmsg_dot11req_mibset;
+	memset(&mibitem, 0, sizeof(mibitem));
 	mibitem.did = did;
 	mibitem.data = data;
 	memcpy(&msg.mibattribute.data, &mibitem, sizeof(mibitem));
@@ -269,6 +270,7 @@ static int p80211wext_giwfreq(netdevice_
 	int err = 0;
 
 	msg.msgcode = DIDmsg_dot11req_mibget;
+	memset(&mibitem, 0, sizeof(mibitem));
 	mibitem.did = DIDmib_dot11phy_dot11PhyDSSSTable_dot11CurrentChannel;
 	memcpy(&msg.mibattribute.data, &mibitem, sizeof(mibitem));
 	result = p80211req_dorequest(wlandev, (u8 *) & msg);
@@ -309,6 +311,7 @@ static int p80211wext_siwfreq(netdevice_
 	}
 
 	msg.msgcode = DIDmsg_dot11req_mibset;
+	memset(&mibitem, 0, sizeof(mibitem));
 	mibitem.did = DIDmib_dot11phy_dot11PhyDSSSTable_dot11CurrentChannel;
 	mibitem.status = P80211ENUM_msgitem_status_data_ok;
 
@@ -396,6 +399,7 @@ static int p80211wext_siwmode(netdevice_
 
 	/* Set Operation mode to the PORT TYPE RID */
 	msg.msgcode = DIDmsg_dot11req_mibset;
+	memset(&mibitem, 0, sizeof(mibitem));
 	mibitem.did = DIDmib_p2_p2Static_p2CnfPortType;
 	mibitem.data = (*mode == IW_MODE_ADHOC) ? 0 : 1;
 	memcpy(&msg.mibattribute.data, &mibitem, sizeof(mibitem));
@@ -771,6 +775,7 @@ static int p80211wext_giwrate(netdevice_
 	int err = 0;
 
 	msg.msgcode = DIDmsg_dot11req_mibget;
+	memset(&mibitem, 0, sizeof(mibitem));
 	mibitem.did = DIDmib_p2_p2MAC_p2CurrentTxRate;
 	memcpy(&msg.mibattribute.data, &mibitem, sizeof(mibitem));
 	result = p80211req_dorequest(wlandev, (u8 *) & msg);
@@ -822,6 +827,7 @@ static int p80211wext_giwrts(netdevice_t
 	int err = 0;
 
 	msg.msgcode = DIDmsg_dot11req_mibget;
+	memset(&mibitem, 0, sizeof(mibitem));
 	mibitem.did = DIDmib_dot11mac_dot11OperationTable_dot11RTSThreshold;
 	memcpy(&msg.mibattribute.data, &mibitem, sizeof(mibitem));
 	result = p80211req_dorequest(wlandev, (u8 *) & msg);
@@ -857,6 +863,7 @@ static int p80211wext_siwrts(netdevice_t
 	}
 
 	msg.msgcode = DIDmsg_dot11req_mibget;
+	memset(&mibitem, 0, sizeof(mibitem));
 	mibitem.did = DIDmib_dot11mac_dot11OperationTable_dot11RTSThreshold;
 	if (rts->disabled)
 		mibitem.data = 2347;
@@ -886,6 +893,7 @@ static int p80211wext_giwfrag(netdevice_
 	int err = 0;
 
 	msg.msgcode = DIDmsg_dot11req_mibget;
+	memset(&mibitem, 0, sizeof(mibitem));
 	mibitem.did =
 	    DIDmib_dot11mac_dot11OperationTable_dot11FragmentationThreshold;
 	memcpy(&msg.mibattribute.data, &mibitem, sizeof(mibitem));
@@ -922,6 +930,7 @@ static int p80211wext_siwfrag(netdevice_
 	}
 
 	msg.msgcode = DIDmsg_dot11req_mibset;
+	memset(&mibitem, 0, sizeof(mibitem));
 	mibitem.did =
 	    DIDmib_dot11mac_dot11OperationTable_dot11FragmentationThreshold;
 
@@ -962,6 +971,7 @@ static int p80211wext_giwretry(netdevice
 	u16 shortretry, longretry, lifetime;
 
 	msg.msgcode = DIDmsg_dot11req_mibget;
+	memset(&mibitem, 0, sizeof(mibitem));
 	mibitem.did = DIDmib_dot11mac_dot11OperationTable_dot11ShortRetryLimit;
 
 	memcpy(&msg.mibattribute.data, &mibitem, sizeof(mibitem));
@@ -1037,6 +1047,8 @@ static int p80211wext_siwretry(netdevice
 	int result;
 	int err = 0;
 
+	memset(&mibitem, 0, sizeof(mibitem));
+
 	if (!wlan_wext_write) {
 		err = (-EOPNOTSUPP);
 		goto exit;
@@ -1114,6 +1126,7 @@ static int p80211wext_siwtxpow(netdevice
 	}
 
 	msg.msgcode = DIDmsg_dot11req_mibset;
+	memset(&mibitem, 0, sizeof(mibitem));
 	mibitem.did =
 	    DIDmib_dot11phy_dot11PhyTxPowerTable_dot11CurrentTxPowerLevel;
 	if (rrq->fixed == 0)
@@ -1143,6 +1156,8 @@ static int p80211wext_giwtxpow(netdevice
 	int err = 0;
 
 	msg.msgcode = DIDmsg_dot11req_mibget;
+
+	memset(&mibitem, 0, sizeof(mibitem));
 	mibitem.did =
 	    DIDmib_dot11phy_dot11PhyTxPowerTable_dot11CurrentTxPowerLevel;
 
