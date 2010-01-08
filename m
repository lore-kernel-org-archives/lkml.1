Return-Path: <linux-kernel-owner+w=401wt.eu-S1753393Ab0AHINa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab0AHINa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 03:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337Ab0AHIN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 03:13:28 -0500
Received: from mail.gmx.net ([213.165.64.20]:41776 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752793Ab0AHIN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 03:13:28 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/s+vgZvefsyjEdjw6K+xfaxtgLeJj4VTAgTZou3K
	Ug+YFWaJZHqspH
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: devel@driverdev.osuosl.org
Subject: [PATCH 1/3 v2] staging/otus: Add select WEXT_PRIV to Kconfig to prevent build failure
Date: Fri, 8 Jan 2010 09:13:19 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27-05415-g69a8594; KDE/4.3.3; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, Simon Horman <horms@verge.net.au>
References: <201001072133.20487.PeterHuewe@gmx.de>
In-Reply-To: <201001072133.20487.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001080913.19300.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>
Date: Fri, 8 Jan 2010 09:09:12 +0100

Without WEXT_PRIV set the driver fails to build due to unknown fields in
the iw_handler_def struct.
Those fields are enclosed in WEXT_PRIV conditionals in the prototype
of iw_handler_def in include/net/iw_handler.h

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
This time without whitespace/indention errors. Sorry about that.

 drivers/staging/otus/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/otus/Kconfig b/drivers/staging/otus/Kconfig
index f6cc262..e918134 100644
--- a/drivers/staging/otus/Kconfig
+++ b/drivers/staging/otus/Kconfig
@@ -1,6 +1,8 @@
 config OTUS
 	tristate "Atheros OTUS 802.11n USB wireless support"
 	depends on USB && WLAN && MAC80211
+	select WIRELESS_EXT
+	select WEXT_PRIV
 	default N
 	---help---
 	  Enable support for Atheros 802.11n USB hardware:
-- 
1.6.4.4


