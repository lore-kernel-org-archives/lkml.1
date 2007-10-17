Return-Path: <linux-kernel-owner+w=401wt.eu-S1762202AbXJQXnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762202AbXJQXnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 19:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758600AbXJQXn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 19:43:29 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:54052 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902AbXJQXn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 19:43:28 -0400
Date: Wed, 17 Oct 2007 16:43:39 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] kbuild: filter out .tmp_* in find_sources
In-reply-to: <200710160028.06468.yinghai.lu@sun.com>
To: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200710171643.40345.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200710160028.06468.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] kbuild: filter out .tmp_* in find_sources

remove .tmp_kallsyms*.S in cscope.files

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/Makefile b/Makefile
index 529b904..a793511 100644
--- a/Makefile
+++ b/Makefile
@@ -1341,7 +1341,7 @@ define find-sources
 	  find $(__srctree)include/asm-generic $(RCS_FIND_IGNORE) \
 	       -name $1 -print; \
 	  find $(__srctree) $(RCS_FIND_IGNORE) \
-	       \( -name include -o -name arch \) -prune -o \
+	       \( -name include -o -name arch -o -name '.tmp_*' \) -prune -o \
 	       -name $1 -print; \
 	  )
 endef
