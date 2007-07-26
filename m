Return-Path: <linux-kernel-owner+w=401wt.eu-S934583AbXGZQfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934583AbXGZQfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934345AbXGZQeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:34:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35279 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934178AbXGZQeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:34:00 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] initramfs: missing __init
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1IE6Hn-0005F3-Il@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 26 Jul 2007 17:33:59 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 init/initramfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index 00eff7a..1db02a0 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -133,7 +133,7 @@ static __initdata loff_t this_header, next_header;
 
 static __initdata int dry_run;
 
-static inline void eat(unsigned n)
+static inline void __init eat(unsigned n)
 {
 	victim += n;
 	this_header += n;
-- 
1.5.3.GIT


