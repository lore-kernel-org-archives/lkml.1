Return-Path: <linux-kernel-owner+w=401wt.eu-S1756914AbXE2KpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbXE2KpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 06:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764552AbXE2Ko4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 06:44:56 -0400
Received: from mx0.karneval.cz ([81.27.192.14]:58889 "EHLO av6.karneval.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764550AbXE2Koz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 06:44:55 -0400
Message-id: <581488651385710635@wsc.cz>
In-reply-to: <253477319205412858@wsc.cz>
Subject: [PATCH 2/2] Char: vt, use ARRAY_SIZE
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Tue, 29 May 2007 12:44:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vt, use ARRAY_SIZE

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 4be166037b1ccf8a639aef015a224941de7dcf0a
tree 68cf3d32232a23963fbfd15d0831b89ea7123b92
parent daa738839b831a78b895ad9cec1da0157e4b1be7
author Jiri Slaby <jirislaby@gmail.com> Sun, 27 May 2007 10:13:41 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 29 May 2007 12:41:13 +0200

 drivers/char/vt.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 1cc960a..694f625 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -1990,8 +1990,7 @@ static int is_double_width(uint32_t ucs)
 		{ 0xFE30, 0xFE6F }, { 0xFF00, 0xFF60 }, { 0xFFE0, 0xFFE6 },
 		{ 0x20000, 0x2FFFD }, { 0x30000, 0x3FFFD }
 	};
-	return bisearch(ucs, double_width,
-		sizeof(double_width) / sizeof(*double_width) - 1);
+	return bisearch(ucs, double_width, ARRAY_SIZE(double_width) - 1);
 }
 
 /* acquires console_sem */
