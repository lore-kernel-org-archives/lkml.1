Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbZBNVjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbZBNVjo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 16:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbZBNVjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 16:39:31 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:36514 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbZBNVj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 16:39:29 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 25/43] drivers/net/pcmcia: fix warning: format not a string
	literal and no ...
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 14 Feb 2009 22:39:23 +0100
Message-ID: <20090214213849.24377.87932.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Use 'static const char[]' instead of 'static char[]' and while
being at it prefix the message with KERN_INFO.

Fix this warnings:
  drivers/net/pcmcia/axnet_cs.c:1716: warning: format not a string literal and no format arguments

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/net/pcmcia/axnet_cs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/pcmcia/axnet_cs.c b/drivers/net/pcmcia/axnet_cs.c
index 0afa720..871ad29 100644
--- a/drivers/net/pcmcia/axnet_cs.c
+++ b/drivers/net/pcmcia/axnet_cs.c
@@ -861,7 +861,7 @@ module_exit(exit_axnet_cs);
 
   */
 
-static const char *version_8390 =
+static const char version_8390[] = KERN_INFO \
     "8390.c:v1.10cvs 9/23/94 Donald Becker (becker@scyld.com)\n";
 
 #include <linux/bitops.h>

