Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149Ab0AGUfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab0AGUfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 15:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964Ab0AGUfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 15:35:18 -0500
Received: from mail.gmx.net ([213.165.64.20]:47220 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752875Ab0AGUfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 15:35:17 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+2l7FGfoG262Yy6R5nF9bOuYwMqhUGSS4cJN9eLD
	3sDmH83KlCocRy
From: Peter Huewe <PeterHuewe@gmx.de>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: [PATCH 2/3] staging/rtl8192u: Add select WEXT_PRIV to Kconfig to prevent build failure
Date: Thu, 7 Jan 2010 21:35:08 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27-05415-g69a8594; KDE/4.3.3; x86_64; ; )
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
References: <201001072133.20487.PeterHuewe@gmx.de>
In-Reply-To: <201001072133.20487.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001072135.08745.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>
Date: Thu, 7 Jan 2010 21:19:11 +0100

Without WEXT_PRIV set the driver fails to build due to unknown fields in
the iw_handler_def struct.
Those fields are enclosed in WEXT_PRIV conditionals in the prototype
of iw_handler_def in include/net/iw_handler.h


Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
Patch against Linux-next of Do 7. Jan 19:59:41 CET 2010

 drivers/staging/rtl8192u/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rtl8192u/Kconfig b/drivers/staging/rtl8192u/Kconfig
index 9913ab8..8e5eb92 100644
--- a/drivers/staging/rtl8192u/Kconfig
+++ b/drivers/staging/rtl8192u/Kconfig
@@ -2,5 +2,6 @@ config RTL8192U
 	tristate "RealTek RTL8192U Wireless LAN NIC driver"
 	depends on PCI && WLAN && USB
 	depends on WIRELESS_EXT
+    select WEXT_PRIV
 	default N
 	---help---
-- 
1.6.4.4


