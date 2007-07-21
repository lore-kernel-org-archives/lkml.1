Return-Path: <linux-kernel-owner+w=401wt.eu-S941047AbXGUPOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941047AbXGUPOa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939491AbXGUPEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:04:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:39272 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939104AbXGUPEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:04:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=IgC89nRJ32Ne1TAxnl1ZWUhkS+CaDRVQBEgbcGJQbQx/h4nWSV3yD9FQYOrEOuUHAhXv8EAxPm/+EFNoCrjQVTJyszHT7uF8PyWJ0Y1+uBfHjzKqbOS9v8AHZqUmUeaz4Cfw7v9gmdVQQ0r/B/ZSQbR4v4gmf+1z/+aBRwX9nSY=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][25/37] Clean up duplicate includes in mm/
Date: Sat, 21 Jul 2007 17:03:32 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       Christoph Rohland <hans-christoph.rohland@sap.com>,
       Christoph Rohland <ch.rohland@gmx.net>, Hugh Dickins <hugh@veritas.com>,
       Andi Kleen <ak@suse.de>, Luke Kenneth Casson Leighton <lkcl@lkcl.net>,
       James Morris <jmorris@redhat.com>, Stephen Tweedie <sct@redhat.com>,
       Rik van Riel <riel@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211703.32870.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	mm/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 71b84b4..888b96d 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -72,7 +72,6 @@
 #include <linux/hugetlb.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
-#include <linux/mm.h>
 #include <linux/nodemask.h>
 #include <linux/cpuset.h>
 #include <linux/gfp.h>
@@ -82,7 +81,6 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/compat.h>
-#include <linux/mempolicy.h>
 #include <linux/swap.h>
 #include <linux/seq_file.h>
 #include <linux/proc_fs.h>
diff --git a/mm/shmem.c b/mm/shmem.c
index fcd19d3..2c39925 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -49,7 +49,6 @@
 #include <linux/ctype.h>
 #include <linux/migrate.h>
 #include <linux/highmem.h>
-#include <linux/backing-dev.h>
 
 #include <asm/uaccess.h>
 #include <asm/div64.h>
diff --git a/mm/swap.c b/mm/swap.c
index d3cb966..d93fa1e 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -24,12 +24,10 @@
 #include <linux/module.h>
 #include <linux/mm_inline.h>
 #include <linux/buffer_head.h>	/* for try_to_release_page() */
-#include <linux/module.h>
 #include <linux/percpu_counter.h>
 #include <linux/percpu.h>
 #include <linux/cpu.h>
 #include <linux/notifier.h>
-#include <linux/init.h>
 
 /* How many pages do we try to swap or page in/out together? */
 int page_cluster;
