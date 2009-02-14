Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbZBNVog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbZBNVog (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 16:44:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbZBNVo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 16:44:26 -0500
Received: from mail-fx0-f25.google.com ([209.85.220.25]:45972 "EHLO
	mail-fx0-f25.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbZBNVoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 16:44:25 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 29/43] drivers/net/tokenring: fix warning: format not a string
	literal and no ...
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 14 Feb 2009 22:44:19 +0100
Message-ID: <20090214214327.24377.33907.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Use 'static const char[]' instead of 'static char[]'.

Fix this warnings:
  drivers/net/tokenring/smctr.c:3644: warning: format not a string literal and no format arguments

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/net/tokenring/smctr.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/tokenring/smctr.c b/drivers/net/tokenring/smctr.c
index 50eb29c..5a3ff20 100644
--- a/drivers/net/tokenring/smctr.c
+++ b/drivers/net/tokenring/smctr.c
@@ -61,7 +61,8 @@
 
 #include "smctr.h"               /* Our Stuff */
 
-static char version[] __initdata = KERN_INFO "smctr.c: v1.4 7/12/00 by jschlst@samba.org\n";
+static const char version[] __initdata =
+	KERN_INFO "smctr.c: v1.4 7/12/00 by jschlst@samba.org\n";
 static const char cardname[] = "smctr";
 
 

