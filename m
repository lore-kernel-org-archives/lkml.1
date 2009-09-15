Return-Path: <linux-kernel-owner+w=401wt.eu-S1758572AbZIOTQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbZIOTQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758551AbZIOTQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:16:49 -0400
Received: from kroah.org ([198.145.64.141]:33079 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758446AbZIOTPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:15:10 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: GeunSik Lim <leemgs1@gmail.com>, GeunSik Lim <geunsik.lim@samsung.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 17/20] debugfs: Change debugfs directory of IWMC3200
Date: Tue, 15 Sep 2009 12:12:53 -0700
Message-Id: <1253041976-1111-17-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090915181247.GA32167@kroah.com>
References: <20090915181247.GA32167@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: GeunSik Lim <leemgs1@gmail.com>

Change default debugfs directory that mount for debugging
IWMC3200(Intel Wireless Multicomm 3200 WiFi driver).

As we all know, We need change default directory for consistency of
debugfs by Greg.K.H

Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
Acked-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/iwmc3200wifi/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/Kconfig b/drivers/net/wireless/iwmc3200wifi/Kconfig
index c62da43..c25a043 100644
--- a/drivers/net/wireless/iwmc3200wifi/Kconfig
+++ b/drivers/net/wireless/iwmc3200wifi/Kconfig
@@ -24,8 +24,8 @@ config IWM_DEBUG
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
1.6.4.2

