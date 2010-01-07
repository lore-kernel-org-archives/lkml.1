Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206Ab0AGUgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab0AGUgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 15:36:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031Ab0AGUgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 15:36:42 -0500
Received: from mail.gmx.net ([213.165.64.20]:32853 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753025Ab0AGUgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 15:36:42 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX192iTE0lyl2ldURzFhw7R36WkcR8++4VhoIla9WHK
	oa77/9gZvpolCF
From: Peter Huewe <PeterHuewe@gmx.de>
To: "Greg Kroah-Hartman" <gregkh@suse.de>, Simon Horman <horms@verge.net.au>
Subject: [PATCH 3/3] staging/wlan-ng: Add select WEXT_PRIV to Kconfig to prevent build failure
Date: Thu, 7 Jan 2010 21:36:38 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27-05415-g69a8594; KDE/4.3.3; x86_64; ; )
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <201001072133.20487.PeterHuewe@gmx.de> <201001072135.08745.PeterHuewe@gmx.de>
In-Reply-To: <201001072135.08745.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001072136.38318.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>
Date: Thu, 7 Jan 2010 21:21:35 +0100

Without WEXT_PRIV set the p80211wext.c fails to build due to unknown fields in
the iw_handler_def struct.
Those fields are enclosed in WEXT_PRIV conditionals in the prototype
of iw_handler_def in include/net/iw_handler.h

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
Patch against Linux-next of Do 7. Jan 19:59:41 CET 2010
 drivers/staging/wlan-ng/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/wlan-ng/Kconfig b/drivers/staging/wlan-ng/Kconfig
index 704ebd2..82fcc16 100644
--- a/drivers/staging/wlan-ng/Kconfig
+++ b/drivers/staging/wlan-ng/Kconfig
@@ -2,6 +2,7 @@ config PRISM2_USB
 	tristate "Prism2.5/3 USB driver"
 	depends on WLAN && USB
 	select WIRELESS_EXT
+	select WEXT_PRIV
 	default n
 	---help---
 	  This is the wlan-ng prism 2.5/3 USB driver for a wide range of
-- 
1.6.4.4



