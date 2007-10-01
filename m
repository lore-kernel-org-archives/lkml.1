Return-Path: <linux-kernel-owner+w=401wt.eu-S1752276AbXJAAZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbXJAAZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 20:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751087AbXJAAZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 20:25:19 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:43224 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbXJAAZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 20:25:18 -0400
Date: Mon, 1 Oct 2007 02:24:38 +0200 (MEST)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20071001002440.15772.83520.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] softmac: Fix compiler-warning
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  CC      net/ieee80211/softmac/ieee80211softmac_wx.o
/home/kernel/src/net/ieee80211/softmac/ieee80211softmac_wx.c: In function ‘ieee80211softmac_wx_set_essid’:
/home/kernel/src/net/ieee80211/softmac/ieee80211softmac_wx.c:117: warning: label ‘out’ defined but not used

due to commit: efe870f9f4ad74410a18ecbf0d9ba7c14b50a0fb. Removing the label.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Compile-tested


diff --git a/net/ieee80211/softmac/ieee80211softmac_wx.c b/net/ieee80211/softmac/ieee80211softmac_wx.c
index 442b987..5742dc8 100644
--- a/net/ieee80211/softmac/ieee80211softmac_wx.c
+++ b/net/ieee80211/softmac/ieee80211softmac_wx.c
@@ -114,7 +114,7 @@ check_assoc_again:
 	sm->associnfo.associating = 1;
 	/* queue lower level code to do work (if necessary) */
 	schedule_delayed_work(&sm->associnfo.work, 0);
-out:
+
 	mutex_unlock(&sm->associnfo.mutex);
 
 	return 0;
