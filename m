Return-Path: <linux-kernel-owner+w=401wt.eu-S1752328AbZIQASQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbZIQASQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 20:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbZIQASO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 20:18:14 -0400
Received: from 30.mail-out.ovh.net ([213.186.62.213]:42209 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751394AbZIQASN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 20:18:13 -0400
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: linux-kernel@vger.kernel.org
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] staging/rtl8192e: add missing vmalloc.h include
Date: Thu, 17 Sep 2009 02:16:48 +0200
Message-Id: <1253146608-5147-1-git-send-email-plagnioj@jcrosoft.com>
X-Mailer: git-send-email 1.6.4
X-Ovh-Tracer-Id: 9243919712210037528
X-Ovh-Remote: 91.121.24.14 (ns24789.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/rtl8192e/r8192E_core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rtl8192e/r8192E_core.c b/drivers/staging/rtl8192e/r8192E_core.c
index d4fa654..e9e05ec 100644
--- a/drivers/staging/rtl8192e/r8192E_core.c
+++ b/drivers/staging/rtl8192e/r8192E_core.c
@@ -47,6 +47,7 @@
 
 //#define CONFIG_RTL8192_IO_MAP
 #include <asm/uaccess.h>
+#include <linux/vmalloc.h>
 #include "r8192E_hw.h"
 #include "r8192E.h"
 #include "r8190_rtl8256.h" /* RTL8225 Radio frontend */
-- 
1.6.4

