Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316Ab0AVX1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab0AVX1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 18:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756261Ab0AVX1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 18:27:21 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:50181 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab0AVX1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 18:27:10 -0500
Message-Id: <9dd553d458def04edc7790f0320ffdf1f8909aa5.1264201408.git.jan.kiszka@web.de>
In-Reply-To: <cover.1264201406.git.jan.kiszka@web.de>
References: <cover.1264201406.git.jan.kiszka@web.de>
From: Jan Kiszka <jan.kiszka@web.de>
To: David Miller <davem@davemloft.net>, Karsten Keil <isdn@linux-pingi.de>
Cc: linux-kernel@vger.kernel.org, i4ldeveloper@listserv.isdn4linux.de,
       isdn4linux@listserv.isdn4linux.de, netdev@vger.kernel.org
Date: Sun, 10 Jan 2010 14:12:41 +0100
Subject: [PATCH 30/31] CAPI: Remove experimental tag from middleware feature
X-Provags-ID: V01U2FsdGVkX1+Czl0GMVJWZ9W19SKnID75RNWZq+PehPuk272W
	dehBIPJTZeprKIeqgiYhkJAG2KuaXY0yskXJmmmA0EuLfuUUqU
	xUpzWIGog=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Despite all its bugs, the middleware support of our CAPI stack was
already in use for many, many moons. And after going through its code,
fixing all issues I found, I feel it deserves to officially become a
non-experimental feature.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
---
 drivers/isdn/capi/Kconfig |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/capi/Kconfig b/drivers/isdn/capi/Kconfig
index b2a0475..66647ed 100644
--- a/drivers/isdn/capi/Kconfig
+++ b/drivers/isdn/capi/Kconfig
@@ -17,8 +17,7 @@ config CAPI_TRACE
 	  If unsure, say Y.
 
 config ISDN_CAPI_MIDDLEWARE
-	bool "CAPI2.0 Middleware support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "CAPI2.0 Middleware support"
 	help
 	  This option will enhance the capabilities of the /dev/capi20
 	  interface.  It will provide a means of moving a data connection,
-- 
1.6.0.2

