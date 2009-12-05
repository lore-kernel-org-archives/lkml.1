Return-Path: <linux-kernel-owner+w=401wt.eu-S932907AbZLETBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932907AbZLETBh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 14:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932886AbZLETBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 14:01:32 -0500
Received: from gimli.pxnet.com ([195.227.45.7]:54732 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932874AbZLETBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 14:01:31 -0500
From: Tilman Schmidt <tilman@imap.cc>
To: David Miller <davem@davemloft.net>, Karsten Keil <isdn@linux-pingi.de>
CC: Hansjoerg Lipp <hjlipp@web.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
       i4ldeveloper@listserv.isdn4linux.de
Subject: [PATCH] gigaset: don't enable any debugging output by default
Message-Id: <20091205180416.B3629400DE@xenon.ts.pxnet.com>
Date: Sat,  5 Dec 2009 19:04:16 +0100 (CET)
X-Spam-Score: -2.179 () AWL,BAYES_00,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When built with debugging support, the Gigaset driver enabled some
debugging messages by default. Change the default to "all off".

Impact: cosmetic
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---

Please merge for 2.6.33 so I can in good conscience encourage people to
build the driver with CONFIG_GIGASET_DEBUG=y. ;-)

Thanks, Tilman

 drivers/isdn/gigaset/common.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/gigaset/common.c b/drivers/isdn/gigaset/common.c
index c438cfc..a0b85d1 100644
--- a/drivers/isdn/gigaset/common.c
+++ b/drivers/isdn/gigaset/common.c
@@ -29,7 +29,7 @@
 #endif
 
 /* Module parameters */
-int gigaset_debuglevel = DEBUG_DEFAULT;
+int gigaset_debuglevel;
 EXPORT_SYMBOL_GPL(gigaset_debuglevel);
 module_param_named(debug, gigaset_debuglevel, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(debug, "debug level");
-- 
1.6.5.3.298.g39add

