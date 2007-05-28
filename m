Return-Path: <linux-kernel-owner+w=401wt.eu-S1760632AbXE1N0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760632AbXE1N0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 09:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487AbXE1N0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 09:26:30 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:42027 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753506AbXE1N03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 09:26:29 -0400
Message-id: <12191294601255228079@wsc.cz>
Subject: [PATCH 1/8] Char: mxser_new, fix sparse warning
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Mon, 28 May 2007 15:26:23 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mxser_new, fix sparse warning

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 29f15033f00e36f622d0bcd5a2dd0f9a49981481
tree 2a332865460a2775256b5087f8da6ff8f1befdf0
parent 1f023432798b6e6fd52ad81af0eab250e1a71449
author Jiri Slaby <jirislaby@gmail.com> Sat, 26 May 2007 18:14:21 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 26 May 2007 18:14:21 +0200

 drivers/char/mxser_new.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/mxser_new.c b/drivers/char/mxser_new.c
index 6cde448..71b9657 100644
--- a/drivers/char/mxser_new.c
+++ b/drivers/char/mxser_new.c
@@ -1560,7 +1560,7 @@ static int mxser_ioctl_special(unsigned int cmd, void __user *argp)
 			return -EFAULT;
 		return 0;
 	case MOXA_ASPP_MON_EXT: {
-		int status, p, shiftbit;
+		int p, shiftbit;
 		unsigned long opmode;
 		unsigned cflag, iflag;
 
