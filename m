Return-Path: <linux-kernel-owner+w=401wt.eu-S1760981AbZEFUgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760981AbZEFUgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 16:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757282AbZEFUgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 16:36:07 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:49154 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbZEFUgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 16:36:04 -0400
Date: Wed, 6 May 2009 22:35:58 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kalle Valo <kalle.valo@nokia.com>, Bob Copeland <me@bobcopeland.com>,
       "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org
Subject: [PATCH next-20090506] wireless: WL12XX should depend on GENERIC_HARDIRQS
Message-ID: <Pine.LNX.4.64.0905062229370.23257@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m68k allmodconfig:
| drivers/net/wireless/wl12xx/main.c: In function 'wl12xx_probe':
| drivers/net/wireless/wl12xx/main.c:1273: error: implicit declaration of function 'set_irq_type'
| make[1]: *** [drivers/net/wireless/wl12xx/main.o] Error 1

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
http://kisskb.ellerman.id.au/kisskb/buildresult/416697/

diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index 20a9633..a82c4cd 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -1,6 +1,6 @@
 config WL12XX
 	tristate "TI wl1251/wl1271 support"
-	depends on MAC80211 && WLAN_80211 && SPI_MASTER && EXPERIMENTAL
+	depends on MAC80211 && WLAN_80211 && SPI_MASTER && GENERIC_HARDIRQS && EXPERIMENTAL
 	select FW_LOADER
 	select CRC7
 	---help---

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
