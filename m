Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbXJNEwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbXJNEwE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 00:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbXJNEvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 00:51:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41590 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbXJNEvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 00:51:53 -0400
Date: Sun, 14 Oct 2007 05:51:51 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mb@bu3sch.de, linux-kernel@vger.kernel.org
Subject: [PATCH] missing include in ssb
Message-ID: <20071014045151.GT8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Using readw() and friends => needs to pull io.h and not all
targets are doing that via indirect chains.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/ssb/pcmcia.c b/drivers/ssb/pcmcia.c
index 7c77360..b6abee8 100644
--- a/drivers/ssb/pcmcia.c
+++ b/drivers/ssb/pcmcia.c
@@ -10,6 +10,7 @@
 
 #include <linux/ssb/ssb.h>
 #include <linux/delay.h>
+#include <linux/io.h>
 
 #include <pcmcia/cs_types.h>
 #include <pcmcia/cs.h>
