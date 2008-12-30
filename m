Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbYL3OmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbYL3OmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 09:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbYL3OmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 09:42:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36005 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbYL3OmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 09:42:12 -0500
Subject: [PATCH -tip] fix compilation error
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, fweisbec@gmail.com
Content-Type: text/plain
Date: Tue, 30 Dec 2008 20:10:07 +0530
Message-Id: <1230648007.10677.1.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, avoid compilation error

fixes this compilation error:
  CC      mm/slab.o
mm/slab.c:105:29: error: linux/kmemtrace.h: No such file or directory
make[1]: *** [mm/slab.o] Error 1
make: *** [mm] Error 2

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 mm/slab.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 90e0cac..ce072de 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -102,7 +102,7 @@
 #include	<linux/cpu.h>
 #include	<linux/sysctl.h>
 #include	<linux/module.h>
-#include	<linux/kmemtrace.h>
+#include	<trace/kmemtrace.h>
 #include	<linux/rcupdate.h>
 #include	<linux/string.h>
 #include	<linux/uaccess.h>
-- 
1.5.5.1



