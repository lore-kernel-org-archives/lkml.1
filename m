Return-Path: <linux-kernel-owner+w=401wt.eu-S1760271AbXGTDfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760271AbXGTDfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 23:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765160AbXGTDdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 23:33:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35677 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765167AbXGTDds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 23:33:48 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 7/8] mac89x0: missing __init
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Message-Id: <E1IBjFU-0004mn-67@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 20 Jul 2007 04:33:48 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/mac89x0.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/mac89x0.c b/drivers/net/mac89x0.c
index 26a3b45..62c1c62 100644
--- a/drivers/net/mac89x0.c
+++ b/drivers/net/mac89x0.c
@@ -608,7 +608,7 @@ module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "CS89[02]0 debug level (0-5)");
 MODULE_LICENSE("GPL");
 
-int
+int __init
 init_module(void)
 {
 	net_debug = debug;
-- 
1.5.3.GIT


