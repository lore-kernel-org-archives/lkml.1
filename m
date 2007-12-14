Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329AbXLNS43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbXLNS43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 13:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbXLNSyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 13:54:19 -0500
Received: from smtp.nokia.com ([192.100.122.233]:34707 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392AbXLNSyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 13:54:15 -0500
From: Francisco Alecrim <francisco.alecrim@indt.org.br>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, dbrownell@users.sourceforge.net,
       kyle@parisc-linux.org, dmitry.torokhov@gmail.com, hcegtvedt@atmel.com,
       Francisco Alecrim <francisco.alecrim@indt.org.br>
Subject: [PATCH 2/6] drivers/parisc/ccio-dma.c: clean up remove duplicated headers
Date: Fri, 14 Dec 2007 14:56:46 -0400
Message-Id: <1197658610-4558-3-git-send-email-francisco.alecrim@indt.org.br>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1197658610-4558-2-git-send-email-francisco.alecrim@indt.org.br>
References: "Francisco Alecrim <francisco.alecrim@indt.org.br>"
 <1197658610-4558-1-git-send-email-francisco.alecrim@indt.org.br>
 <1197658610-4558-2-git-send-email-francisco.alecrim@indt.org.br>
X-OriginalArrivalTime: 14 Dec 2007 18:53:24.0784 (UTC) FILETIME=[9B09CB00:01C83E82]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicated headers in drivers/parisc/ccio-dma.c:
drivers/parisc/ccio-dma.c: linux/proc_fs.h is included more than once.

Signed-off-by: Francisco Alecrim <francisco.alecrim@indt.org.br>
---
 drivers/parisc/ccio-dma.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index 7c60cbd..b67b056 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -76,7 +76,6 @@
 #undef CCIO_MAP_STATS
 #endif
 
-#include <linux/proc_fs.h>
 #include <asm/runway.h>		/* for proc_runway_root */
 
 #ifdef DEBUG_CCIO_INIT
-- 
1.5.3.7

