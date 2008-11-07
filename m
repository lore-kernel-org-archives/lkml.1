Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbYKGXpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbYKGXpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbYKGXpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:45:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41063 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbYKGXpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:45:41 -0500
Message-ID: <4914D2DE.9030603@redhat.com>
Date: Fri, 07 Nov 2008 18:44:30 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>, maneesh@in.ibm.com,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [PATCH] kprobe: increase kprobe_hash_table size
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increase the size of kprobe hash table to 512. It's useful when hundreds
of kprobes were used in the kernel because current size is just 64.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 kernel/kprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6.28-rc3/kernel/kprobes.c
===================================================================
--- 2.6.28-rc3.orig/kernel/kprobes.c
+++ 2.6.28-rc3/kernel/kprobes.c
@@ -49,7 +49,7 @@
 #include <asm/errno.h>
 #include <asm/uaccess.h>

-#define KPROBE_HASH_BITS 6
+#define KPROBE_HASH_BITS 9
 #define KPROBE_TABLE_SIZE (1 << KPROBE_HASH_BITS)


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

