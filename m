Return-Path: <linux-kernel-owner+w=401wt.eu-S934446AbYEUAuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934446AbYEUAuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934036AbYEUAsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:48:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41623 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934015AbYEUAsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:48:53 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 5/6][uml] missing export of csum_partial() on uml/amd64
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org
Message-Id: <E1JycVg-00067G-KU@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 01:48:52 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Content-Length: 596
Lines: 22

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/sys-x86_64/ksyms.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/um/sys-x86_64/ksyms.c b/arch/um/sys-x86_64/ksyms.c
index 4d7d1a8..6604673 100644
--- a/arch/um/sys-x86_64/ksyms.c
+++ b/arch/um/sys-x86_64/ksyms.c
@@ -1,5 +1,7 @@
-#include "linux/module.h"
-#include "asm/string.h"
+#include <linux/module.h>
+#include <asm/string.h>
+#include <asm/checksum.h>
 
 /*XXX: we need them because they would be exported by x86_64 */
 EXPORT_SYMBOL(__memcpy);
+EXPORT_SYMBOL(csum_partial);
-- 
1.5.3.GIT


