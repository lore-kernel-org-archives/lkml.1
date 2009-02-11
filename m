Return-Path: <linux-kernel-owner+w=401wt.eu-S1758754AbZBKV2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754AbZBKV2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 16:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757998AbZBKV06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 16:26:58 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:22990 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757945AbZBKV05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 16:26:57 -0500
Date: Wed, 11 Feb 2009 13:19:35 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de
Subject: [PATCH 6/9] staging/rtl8187se: fix printk format warnings
Message-Id: <20090211131935.5d9621e4.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4993429B.00A3:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix staging/rtl8187se printk format warnings:

drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c:845: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c:852: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- mmotm-2009-0210-1635.orig/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
+++ mmotm-2009-0210-1635/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
@@ -842,14 +842,14 @@ int ieee80211_wx_set_gen_ie(struct ieee8
 
 	if (len>MAX_WPA_IE_LEN || (len && ie == NULL))
 	{
-		printk("return error out, len:%d\n", len);
+		printk("return error out, len:%zu\n", len);
 	return -EINVAL;
 	}
 
 	if (len)
 	{
 		if (len != ie[1]+2){
-			printk("len:%d, ie:%d\n", len, ie[1]);
+			printk("len:%zu, ie:%d\n", len, ie[1]);
 			return -EINVAL;
 		}
 		buf = kmalloc(len, GFP_KERNEL);
