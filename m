Return-Path: <linux-kernel-owner+w=401wt.eu-S1030311AbXAaRLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030311AbXAaRLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030309AbXAaRLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:11:19 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:52755 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030307AbXAaRLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:11:19 -0500
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org
Cc: torvalds@osdl.org, ak@suse.de, "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH] x86_64: Fix preprocessor condition
Date: Wed, 31 Jan 2007 12:11:08 -0500
Message-Id: <11702634681921-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.rc1.g5355
In-Reply-To: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 include/asm-x86_64/io.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86_64/io.h b/include/asm-x86_64/io.h
index 6ee9fad..7d0b568 100644
--- a/include/asm-x86_64/io.h
+++ b/include/asm-x86_64/io.h
@@ -100,7 +100,7 @@ __OUTS(l)
 
 #define IO_SPACE_LIMIT 0xffff
 
-#if defined(__KERNEL__) && __x86_64__
+#if defined(__KERNEL__) && defined(__x86_64__)
 
 #include <linux/vmalloc.h>
 
-- 
1.5.0.rc1.g5355

