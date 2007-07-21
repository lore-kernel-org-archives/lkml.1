Return-Path: <linux-kernel-owner+w=401wt.eu-S939408AbXGUPDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939408AbXGUPDz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939086AbXGUPCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:02:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:37344 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938490AbXGUPCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:02:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=QGN676a8xdskjAD44SOBpslcYTqfOLVspdr/hjvNsE078IPekHf6vWSkCQACJqpZ/lsFkIOzwVUyQWXoIU2SqStAeM62K4JrgD+U8G6eB7XZ/uLfrESg+6+E0UkwqY3QF7Gm8QpPuqQ5c9YbO+4ZGZ8a+aZNNPQw4yD5eKJYeyk=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][03/37] Clean up duplicate includes in arch/i386/xen/
Date: Sat, 21 Jul 2007 17:01:47 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211701.47855.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	arch/i386/xen/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/arch/i386/xen/enlighten.c b/arch/i386/xen/enlighten.c
index 9a8c118..f65ef89 100644
--- a/arch/i386/xen/enlighten.c
+++ b/arch/i386/xen/enlighten.c
@@ -25,7 +25,6 @@
 #include <linux/mm.h>
 #include <linux/page-flags.h>
 #include <linux/highmem.h>
-#include <linux/smp.h>
 
 #include <xen/interface/xen.h>
 #include <xen/interface/physdev.h>
diff --git a/arch/i386/xen/mmu.c b/arch/i386/xen/mmu.c
index 4ae038a..35691a2 100644
--- a/arch/i386/xen/mmu.c
+++ b/arch/i386/xen/mmu.c
@@ -41,7 +41,6 @@
 #include <linux/sched.h>
 #include <linux/highmem.h>
 #include <linux/bug.h>
-#include <linux/sched.h>
 
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
