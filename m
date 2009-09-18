Return-Path: <linux-kernel-owner+w=401wt.eu-S1752562AbZIRX6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbZIRX6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 19:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbZIRX6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 19:58:16 -0400
Received: from gimli.pxnet.com ([195.227.45.7]:35034 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbZIRX6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 19:58:16 -0400
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH 4/4] isdn: make capidrv module parameter "debugmode" writeable
To: Karsten Keil <isdn@linux-pingi.de>, Karsten Keil <keil@b1-systems.de>
CC: davem@davemloft.net, i4ldeveloper@listserv.isdn4linux.de,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20090919-patch-capi-4.tilman@imap.cc>
In-Reply-To: <20090919-patch-capi-0.tilman@imap.cc>
References: <20090919-patch-capi-0.tilman@imap.cc>
Date: Sat, 19 Sep 2009 01:57:43 +0200 (CEST)
X-Spam-Score: -2.212 () BAYES_00,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Being able to change the debugmode module parameter of capidrv on the
fly is quite useful for debugging and doesn't do any harm.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---
 drivers/isdn/capi/capidrv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/capi/capidrv.c b/drivers/isdn/capi/capidrv.c
index 4921eae..3e6d17f 100644
--- a/drivers/isdn/capi/capidrv.c
+++ b/drivers/isdn/capi/capidrv.c
@@ -40,7 +40,7 @@ static int debugmode = 0;
 MODULE_DESCRIPTION("CAPI4Linux: Interface to ISDN4Linux");
 MODULE_AUTHOR("Carsten Paeth");
 MODULE_LICENSE("GPL");
-module_param(debugmode, uint, 0);
+module_param(debugmode, uint, S_IRUGO|S_IWUSR);
 
 /* -------- type definitions ----------------------------------------- */
 
-- 
1.6.2.1.214.ge986c

