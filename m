Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbZIGMiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbZIGMiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 08:38:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbZIGMiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 08:38:03 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:61234 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbZIGMiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 08:38:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Q4U+m5Ef11Ku+jQocx89HnD9Bs8Hv6WOCh27mzXuLPVwZdFzf/t2PYQLXnIbTmLWDb
         hBgWBppj3lElX1djHhCwJXJx8+mq4H0otY72h8PMyZ5MArXmIGjeXunwbum6fTuhxLO3
         MUd7bn/kQfmwJ2WfytNTuw1XsJnES5B0gi5e4=
Subject: [PATCH 3/5] debugfs - Change debugfs directory of IWMC3200.
From: GeunSik Lim <leemgs1@gmail.com>
Reply-To: leemgs1@gmail.com
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, yi.zhu@intel.com
Content-Type: text/plain
Organization: Private
Date: Mon, 07 Sep 2009 21:37:53 +0900
Message-Id: <1252327073.2153.98.camel@centos51>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>From 7dcf9fd3b060ced7fa0c19d056e9aedbf74ae1d9 Mon Sep 17 00:00:00 2001
From: GeunSik,Lim <leemgs1@gmail.com>
Date: Mon, 7 Sep 2009 20:46:13 +0900
Subject: [PATCH 3/5] Change debugfs directory of IWMC3200.

Change default debugfs directory that mount for debugging
IWMC3200(Intel Wireless Multicomm 3200 WiFi driver).

As we all know, We need change default directory for consistency of
debugfs by Greg.K.H

Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
---
 drivers/net/wireless/iwmc3200wifi/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/Kconfig b/drivers/net/wireless/iwmc3200wifi/Kconfig
index 030401d..ec5379d 100644
--- a/drivers/net/wireless/iwmc3200wifi/Kconfig
+++ b/drivers/net/wireless/iwmc3200wifi/Kconfig
@@ -25,8 +25,8 @@ config IWM_DEBUG
 	  To see the list of debug modules and levels, see iwm/debug.h
 
 	  For example, if you want the full MLME debug output:
-	  echo 0xff > /debug/iwm/phyN/debug/mlme
+	  echo 0xff > /sys/kernel/debug/iwm/phyN/debug/mlme
 
 	  Or, if you want the full debug, for all modules:
-	  echo 0xff > /debug/iwm/phyN/debug/level
-	  echo 0xff > /debug/iwm/phyN/debug/modules
+	  echo 0xff > /sys/kernel/debug/iwm/phyN/debug/level
+	  echo 0xff > /sys/kernel/debug/iwm/phyN/debug/modules
-- 
1.6.3.1


-----------------------------------------------
To unsubscribe from this list: send the line "unsubscribe linux-***" 
in the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

GeunSik Lim ( Samsung Electronics )
e-Mail  :1) geunsik.lim@samsung.com
         2) leemgs@gmail.com , leemgs1@gmail.com
HomePage: http://blog.naver.com/invain/
-----------------------------------------------

