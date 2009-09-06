Return-Path: <linux-kernel-owner+w=401wt.eu-S1758197AbZIFS70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197AbZIFS70 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 14:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758186AbZIFS7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 14:59:23 -0400
Received: from gimli.pxnet.com ([195.227.45.7]:42861 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758179AbZIFS7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 14:59:20 -0400
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH 4/4] isdn: make capidrv module parameter "debugmode" writeable
To: davem@davemloft.net, Karsten Keil <keil@b1-systems.de>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       i4ldeveloper@listserv.isdn4linux.de
CC: Carsten Paeth <calle@calle.de>
Message-ID: <20090906-patch-capi-4.tilman@imap.cc>
In-Reply-To: <20090906-patch-capi-0.tilman@imap.cc>
References: <20090906-patch-capi-0.tilman@imap.cc>
Date: Sun,  6 Sep 2009 20:58:52 +0200 (CEST)
X-Spam-Score: -1.545 () AWL,BAYES_00,RDNS_NONE
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
index c3f5472..75c691c 100644
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

