Return-Path: <linux-kernel-owner+w=401wt.eu-S1757793AbXLNSzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793AbXLNSzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 13:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbXLNSyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 13:54:15 -0500
Received: from smtp.nokia.com ([192.100.122.230]:26849 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbXLNSyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 13:54:10 -0500
From: Francisco Alecrim <francisco.alecrim@indt.org.br>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, dbrownell@users.sourceforge.net,
       kyle@parisc-linux.org, dmitry.torokhov@gmail.com, hcegtvedt@atmel.com,
       Francisco Alecrim <francisco.alecrim@indt.org.br>
Subject: [PATCH 6/6] drivers/misc/atmel-ssc.c: clean up remove duplicated headers
Date: Fri, 14 Dec 2007 14:56:50 -0400
Message-Id: <1197658610-4558-7-git-send-email-francisco.alecrim@indt.org.br>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1197658610-4558-6-git-send-email-francisco.alecrim@indt.org.br>
References: "Francisco Alecrim <francisco.alecrim@indt.org.br>"
 <1197658610-4558-1-git-send-email-francisco.alecrim@indt.org.br>
 <1197658610-4558-2-git-send-email-francisco.alecrim@indt.org.br>
 <1197658610-4558-3-git-send-email-francisco.alecrim@indt.org.br>
 <1197658610-4558-4-git-send-email-francisco.alecrim@indt.org.br>
 <1197658610-4558-5-git-send-email-francisco.alecrim@indt.org.br>
 <1197658610-4558-6-git-send-email-francisco.alecrim@indt.org.br>
X-OriginalArrivalTime: 14 Dec 2007 18:53:25.0331 (UTC) FILETIME=[9B5D4230:01C83E82]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicated headers in drivers/misc/atmel-ssc.c:
drivers/misc/atmel-ssc.c: linux/list.h is included more than once.

Signed-off-by: Francisco Alecrim <francisco.alecrim@indt.org.br>
---
 drivers/misc/atmel-ssc.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/atmel-ssc.c b/drivers/misc/atmel-ssc.c
index 058ccac..992d371 100644
--- a/drivers/misc/atmel-ssc.c
+++ b/drivers/misc/atmel-ssc.c
@@ -13,7 +13,6 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/io.h>
-#include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/atmel-ssc.h>
 
-- 
1.5.3.7

