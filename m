Return-Path: <linux-kernel-owner+w=401wt.eu-S1756428AbYJPRka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbYJPRka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYJPRkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:40:18 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:21421 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbYJPRkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:40:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=aZIafE8vjk5Lz5xHpzEhvQ+mX0xhMdS5g3nfSJSIVupx4MArJOWrh5HUMgtSjaNADL
         ylqyWHDEc+3ZbP4B2tsm1/cTalGWpqAs4N/yT8UHR/FNMHmUcugKoc2PJCPYqi3w/U/V
         PA0dfCAYOPXVBvtqfoozs9Ye/IBK2MzrshwyA=
From: Bryan Wu <cooloney@kernel.org>
To: ben@simtec.co.uk, davem@davemloft.net, vapier.adi@gmail.com,
       shemminger@vyatta.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] netdev: DM9000: remove BLACKFIN hacking in DM9000 netdev driver
Date: Fri, 17 Oct 2008 01:40:44 +0800
Message-Id: <1224178844-12496-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove integer casting in the read/write IO accessors,
because Blackfin now provides those functions

Tested-by: Javier Herrero <jherrero@hvsistemas.es>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/net/dm9000.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dm9000.c b/drivers/net/dm9000.c
index f42c23f..5a9083e 100644
--- a/drivers/net/dm9000.c
+++ b/drivers/net/dm9000.c
@@ -47,15 +47,6 @@
 #define CARDNAME	"dm9000"
 #define DRV_VERSION	"1.31"
 
-#ifdef CONFIG_BLACKFIN
-#define readsb	insb
-#define readsw	insw
-#define readsl	insl
-#define writesb	outsb
-#define writesw	outsw
-#define writesl	outsl
-#endif
-
 /*
  * Transmit timeout, default 5 seconds.
  */
-- 
1.5.6

