Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbXKYO6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbXKYO6W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 09:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbXKYO6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 09:58:13 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:37200 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbXKYO6M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 09:58:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=RVGOGKM6R0DkpATCi5+g2L2z0nfMGA7e/lnXn0raDhif+nywFlmApa5CcYGnNvnOcgcQPG1sVaBFQHfqqYgX1CJ9GnZaDys1WgCZkdyUaY/tZG37hOhB24Z3rbDg4ncwmQWNqPj2xqe14X9yNbrM/VNMowzD6/m0RKkWgU7fjP0=
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] iwlwifi: remove redundant declaration of 'iwl3945_priv' and 'iwl4965_priv' structs
Date: Sun, 25 Nov 2007 15:58:07 +0100
User-Agent: KMail/1.9.7
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com, yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711251558.07511.mboton@gmail.com>
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a redundant declaration of 'iwl3945_priv' and 'iwl4965_priv' structs.

Signed-off-by: Miguel Boton <mboton@gmail.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 49556e6..70f3fc0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -31,8 +31,6 @@
 #include <linux/kernel.h>
 #include <net/ieee80211_radiotap.h>
 
-struct iwl3945_priv;
-
 /* Hardware specific file defines the PCI IDs table for that hardware module */
 extern struct pci_device_id iwl3945_hw_card_ids[];
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 5944b4b..949630c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -30,8 +30,6 @@
 #include <linux/kernel.h>
 #include <net/ieee80211_radiotap.h>
 
-struct iwl4965_priv;
-
 /* Hardware specific file defines the PCI IDs table for that hardware module */
 extern struct pci_device_id iwl4965_hw_card_ids[];
 

-- 
	Miguel Botón
