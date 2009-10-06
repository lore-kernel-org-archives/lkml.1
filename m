Return-Path: <linux-kernel-owner+w=401wt.eu-S933040AbZJFWTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040AbZJFWTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933543AbZJFWTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:19:05 -0400
Received: from gimli.pxnet.com ([195.227.45.7]:41000 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933513AbZJFWTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:19:04 -0400
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH 4/4] isdn: make capidrv module parameter "debugmode" writeable
To: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
CC: Karsten Keil <isdn@linux-pingi.de>, Karsten Keil <keil@b1-systems.de>,
       isdn4linux@listserv.isdn4linux.de, i4ldeveloper@listserv.isdn4linux.de
Message-ID: <20091006-patch-capi-4.tilman@imap.cc>
In-Reply-To: <20091006-patch-capi-0.tilman@imap.cc>
References: <20091006-patch-capi-0.tilman@imap.cc>
Date: Wed,  7 Oct 2009 00:18:15 +0200 (CEST)
X-Spam-Score: -2.152 () AWL,BAYES_00,RDNS_NONE
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

