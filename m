Return-Path: <linux-kernel-owner+w=401wt.eu-S1760237AbZEKWia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760237AbZEKWia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759744AbZEKWiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:38:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:58266 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759940AbZEKWiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:38:03 -0400
Message-Id: <200905112237.12648.arnd@arndb.de>
References: <20090511222702.352192505@arndb.de>>
User-Agent: quilt/0.46-1
Date: Mon, 11 May 2009 22:37:12 +0000
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org, Anatolij Gustschin <agust@denx.de>
Subject: [PATCH] mb862xxfb: use CONFIG_OF instead of CONFIG_PPC_OF
Content-Disposition: inline
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/BPDjZ2sWMOjGujhgPwZa/sior6ySVeV5y8Bo
 apw2QrLWENxqYs0L4JFwaXgNdV09K1bnCSK+YSBcq+pRcPbu5K
 OqMKongUYrFLGGZUdPPUg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this change, the driver builds fine on Microblaze, which
helps allyesconfig compile tests.

I did not test sparc, but the change should have the same effect there.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/video/mb862xx/mb862xxfb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/mb862xx/mb862xxfb.c 
b/drivers/video/mb862xx/mb862xxfb.c
index fb64234..a28e3cf 100644
--- a/drivers/video/mb862xx/mb862xxfb.c
+++ b/drivers/video/mb862xx/mb862xxfb.c
@@ -19,7 +19,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
-#if defined(CONFIG_PPC_OF)
+#if defined(CONFIG_OF)
 #include <linux/of_platform.h>
 #endif
 #include "mb862xxfb.h"
-- 
