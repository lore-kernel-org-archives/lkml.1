Return-Path: <linux-kernel-owner+w=401wt.eu-S1756915AbXLNSyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbXLNSyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 13:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbXLNSyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 13:54:08 -0500
Received: from smtp.nokia.com ([192.100.105.134]:19680 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbXLNSyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 13:54:04 -0500
From: Francisco Alecrim <francisco.alecrim@indt.org.br>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, dbrownell@users.sourceforge.net,
       kyle@parisc-linux.org, dmitry.torokhov@gmail.com, hcegtvedt@atmel.com,
       Francisco Alecrim <francisco.alecrim@indt.org.br>
Subject: [PATCH 5/6] drivers/net: clean up remove duplicated headers
Date: Fri, 14 Dec 2007 14:56:49 -0400
Message-Id: <1197658610-4558-6-git-send-email-francisco.alecrim@indt.org.br>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1197658610-4558-5-git-send-email-francisco.alecrim@indt.org.br>
References: "Francisco Alecrim <francisco.alecrim@indt.org.br>"
 <1197658610-4558-1-git-send-email-francisco.alecrim@indt.org.br>
 <1197658610-4558-2-git-send-email-francisco.alecrim@indt.org.br>
 <1197658610-4558-3-git-send-email-francisco.alecrim@indt.org.br>
 <1197658610-4558-4-git-send-email-francisco.alecrim@indt.org.br>
 <1197658610-4558-5-git-send-email-francisco.alecrim@indt.org.br>
X-OriginalArrivalTime: 14 Dec 2007 18:53:25.0144 (UTC) FILETIME=[9B40B980:01C83E82]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicated headers in drivers/net:
drivers/net/ucc_geth_ethtool.c: asm/uaccess.h is included more than once.
drivers/net/irda/ks959-sir.c: linux/module.h is included more than once.
drivers/net/irda/ksdazzle-sir.c: linux/module.h is included more than once.

Signed-off-by: Francisco Alecrim <francisco.alecrim@indt.org.br>
---
 drivers/net/irda/ks959-sir.c    |    1 -
 drivers/net/irda/ksdazzle-sir.c |    1 -
 drivers/net/ucc_geth_ethtool.c  |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/irda/ks959-sir.c b/drivers/net/irda/ks959-sir.c
index 8c257a5..db48998 100644
--- a/drivers/net/irda/ks959-sir.c
+++ b/drivers/net/irda/ks959-sir.c
@@ -118,7 +118,6 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/module.h>
 #include <linux/kref.h>
 #include <linux/usb.h>
 #include <linux/device.h>
diff --git a/drivers/net/irda/ksdazzle-sir.c b/drivers/net/irda/ksdazzle-sir.c
index d01a285..10c25b2 100644
--- a/drivers/net/irda/ksdazzle-sir.c
+++ b/drivers/net/irda/ksdazzle-sir.c
@@ -82,7 +82,6 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/module.h>
 #include <linux/kref.h>
 #include <linux/usb.h>
 #include <linux/device.h>
diff --git a/drivers/net/ucc_geth_ethtool.c b/drivers/net/ucc_geth_ethtool.c
index 9a9622c..68c8700 100644
--- a/drivers/net/ucc_geth_ethtool.c
+++ b/drivers/net/ucc_geth_ethtool.c
@@ -37,7 +37,6 @@
 #include <asm/irq.h>
 #include <asm/uaccess.h>
 #include <asm/types.h>
-#include <asm/uaccess.h>
 
 #include "ucc_geth.h"
 #include "ucc_geth_mii.h"
-- 
1.5.3.7

