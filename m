Return-Path: <linux-kernel-owner+w=401wt.eu-S932787AbZJ3SF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787AbZJ3SF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 14:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932766AbZJ3SF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 14:05:56 -0400
Received: from xenotime.net ([72.52.64.118]:34508 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932765AbZJ3SFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 14:05:55 -0400
Date: Fri, 30 Oct 2009 11:01:43 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] staging: fix wlags49 kconfigs
Message-Id: <20091030110143.2d6d76d1.rdunlap@xenotime.net>
In-Reply-To: <20091030200916.e9331f66.sfr@canb.auug.org.au>
References: <20091030200916.e9331f66.sfr@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix depends/selects in wlags49 drivers.

ERROR: "wireless_spy_update" [drivers/staging/wlags49_h2/wlags49_h2_cs.ko] undefined!
ERROR: "iw_handler_get_spy" [drivers/staging/wlags49_h2/wlags49_h2_cs.ko] undefined!
ERROR: "iw_handler_set_spy" [drivers/staging/wlags49_h2/wlags49_h2_cs.ko] undefined!

ERROR: "pcmcia_dev_present" [drivers/staging/wlags49_h25/wlags49_h25_cs.ko] undefined!
ERROR: "pcmcia_request_irq" [drivers/staging/wlags49_h25/wlags49_h25_cs.ko] undefined!
ERROR: "pcmcia_register_driver" [drivers/staging/wlags49_h25/wlags49_h25_cs.ko] undefined!
ERROR: "pcmcia_request_configuration" [drivers/staging/wlags49_h25/wlags49_h25_cs.ko] undefined!
ERROR: "pcmcia_request_io" [drivers/staging/wlags49_h25/wlags49_h25_cs.ko] undefined!
ERROR: "pcmcia_error_ret" [drivers/staging/wlags49_h25/wlags49_h25_cs.ko] undefined!
ERROR: "pcmcia_error_func" [drivers/staging/wlags49_h25/wlags49_h25_cs.ko] undefined!
ERROR: "pcmcia_unregister_driver" [drivers/staging/wlags49_h25/wlags49_h25_cs.ko] undefined!
ERROR: "pcmcia_disable_device" [drivers/staging/wlags49_h25/wlags49_h25_cs.ko] undefined!
ERROR: "pcmcia_dev_present" [drivers/staging/wlags49_h2/wlags49_h2_cs.ko] undefined!
ERROR: "pcmcia_request_irq" [drivers/staging/wlags49_h2/wlags49_h2_cs.ko] undefined!
ERROR: "pcmcia_register_driver" [drivers/staging/wlags49_h2/wlags49_h2_cs.ko] undefined!
ERROR: "pcmcia_request_configuration" [drivers/staging/wlags49_h2/wlags49_h2_cs.ko] undefined!
ERROR: "pcmcia_request_io" [drivers/staging/wlags49_h2/wlags49_h2_cs.ko] undefined!
ERROR: "pcmcia_error_ret" [drivers/staging/wlags49_h2/wlags49_h2_cs.ko] undefined!
ERROR: "pcmcia_error_func" [drivers/staging/wlags49_h2/wlags49_h2_cs.ko] undefined!
ERROR: "pcmcia_unregister_driver" [drivers/staging/wlags49_h2/wlags49_h2_cs.ko] undefined!
ERROR: "pcmcia_disable_device" [drivers/staging/wlags49_h2/wlags49_h2_cs.ko] undefined!


Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/wlags49_h2/Kconfig  |    3 ++-
 drivers/staging/wlags49_h25/Kconfig |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- linux-next-20091030.orig/drivers/staging/wlags49_h2/Kconfig
+++ linux-next-20091030/drivers/staging/wlags49_h2/Kconfig
@@ -1,6 +1,7 @@
 config WLAGS49_H2
 	tristate "Agere Systems HERMES II Wireless PC Card Model 0110"
-	depends on WLAN_80211 && WIRELESS_EXT
+	depends on WLAN_80211 && WIRELESS_EXT && PCMCIA
+	select WEXT_SPY
 	---help---
 	  Driver for wireless cards using Agere's HERMES II chipset
 	  which are identified with Manufacture ID: 0156,0003
--- linux-next-20091030.orig/drivers/staging/wlags49_h25/Kconfig
+++ linux-next-20091030/drivers/staging/wlags49_h25/Kconfig
@@ -1,6 +1,7 @@
 config WLAGS49_H25
 	tristate "Linksys HERMES II.5 WCF54G_Wireless-G_CompactFlash_Card"
-	depends on WLAN_80211 && WIRELESS_EXT
+	depends on WLAN_80211 && WIRELESS_EXT && PCMCIA
+	select WEXT_SPY
 	---help---
 	  Driver for wireless cards using Agere's HERMES II.5 chipset
 	  which are identified with Manufacture ID: 0156,0004
