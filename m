Return-Path: <linux-kernel-owner+w=401wt.eu-S932612AbZHDO3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612AbZHDO3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932252AbZHDO3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:29:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:57763 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755407AbZHDO3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:29:12 -0400
Message-Id: <20090804142710.034259694@suse.com>
User-Agent: quilt/0.47-14.9
Date: Tue, 04 Aug 2009 10:26:20 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: Greg KH <gregkh@suse.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 2/5] rtl8192su: fix up printk warnings
References: <20090804142618.455591385@suse.com>
Content-Disposition: inline; filename=patches.rpmify/rtl8192su-printfs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch addresses printk warnings.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---

 drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c   |    2 +-
 drivers/staging/rtl8192su/ieee80211/rtl819x_BAProc.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c
@@ -987,7 +987,7 @@ int ieee80211_wx_set_gen_ie(struct ieee8
 	{
 		if (len != ie[1]+2)
 		{
-			printk("len:%d, ie:%d\n", len, ie[1]);
+			printk("len: %Zd, ie:%d\n", len, ie[1]);
 			return -EINVAL;
 		}
 		buf = kmalloc(len, GFP_KERNEL);
--- a/drivers/staging/rtl8192su/ieee80211/rtl819x_BAProc.c
+++ b/drivers/staging/rtl8192su/ieee80211/rtl819x_BAProc.c
@@ -382,7 +382,7 @@ int ieee80211_rx_ADDBAReq( struct ieee80
 
 	if (skb->len < sizeof( struct ieee80211_hdr_3addr) + 9)
 	{
-		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in BAREQ(%d / %d)\n", skb->len, 	(sizeof( struct ieee80211_hdr_3addr) + 9));
+		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in BAREQ(%d / %ld)\n", skb->len, 	(sizeof( struct ieee80211_hdr_3addr) + 9));
 		return -1;
 	}
 
@@ -483,7 +483,7 @@ int ieee80211_rx_ADDBARsp( struct ieee80
 
 	if (skb->len < sizeof( struct ieee80211_hdr_3addr) + 9)
 	{
-		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in BARSP(%d / %d)\n", skb->len, 	(sizeof( struct ieee80211_hdr_3addr) + 9));
+		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in BARSP(%d / %ld)\n", skb->len, 	(sizeof( struct ieee80211_hdr_3addr) + 9));
 		return -1;
 	}
 	rsp = ( struct ieee80211_hdr_3addr*)skb->data;
@@ -613,7 +613,7 @@ int ieee80211_rx_DELBA(struct ieee80211_
 
 	if (skb->len < sizeof( struct ieee80211_hdr_3addr) + 6)
 	{
-		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in DELBA(%d / %d)\n", skb->len, 	(sizeof( struct ieee80211_hdr_3addr) + 6));
+		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in DELBA(%d / %ld)\n", skb->len, 	(sizeof( struct ieee80211_hdr_3addr) + 6));
 		return -1;
 	}
 


