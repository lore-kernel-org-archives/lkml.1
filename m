Return-Path: <linux-kernel-owner+w=401wt.eu-S1751697AbZIXLVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697AbZIXLVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 07:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbZIXLVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 07:21:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:37008 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbZIXLVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 07:21:14 -0400
Subject: [PATCH] fs: includecheck fix: proc, kcore.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Jiri Slaby <jirislaby@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 16:50:23 +0530
Message-Id: <1253791223.5860.16.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  fs/proc/kcore.c: linux/mm.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/proc/kcore.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 5601337..a44a789 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -23,7 +23,6 @@
 #include <asm/io.h>
 #include <linux/list.h>
 #include <linux/ioport.h>
-#include <linux/mm.h>
 #include <linux/memory.h>
 #include <asm/sections.h>
 
-- 
1.6.0.6


