Return-Path: <linux-kernel-owner+w=401wt.eu-S1755744AbXKNCFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744AbXKNCFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 21:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760884AbXKNCEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 21:04:45 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:4739 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758438AbXKNCEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 21:04:45 -0500
Subject: [PATCH] - [1/15] - remove defconfig ptr comparisons to 0 - arch/x86
From: Joe Perches <joe@perches.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain
Date: Tue, 13 Nov 2007 18:04:45 -0800
Message-Id: <1195005885.5163.86.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove defconfig ptr comparison to 0

Remove sparse warning: Using plain integer as NULL pointer

Signed-off-by: Joe Perches <joe@perches.com>

---

diff --git a/arch/x86/boot/printf.c b/arch/x86/boot/printf.c
index 1a09f93..953224e 100644
--- a/arch/x86/boot/printf.c
+++ b/arch/x86/boot/printf.c
@@ -54,7 +54,7 @@ static char *number(char *str, long num, int base, int size, int precision,
 	if (type & LEFT)
 		type &= ~ZEROPAD;
 	if (base < 2 || base > 36)
-		return 0;
+		return NULL;
 	c = (type & ZEROPAD) ? '0' : ' ';
 	sign = 0;
 	if (type & SIGN) {


