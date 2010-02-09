Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab0BIL3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 06:29:11 -0500
Received: from cantor.suse.de ([195.135.220.2]:43403 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab0BIL3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 06:29:09 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Remove unused macro, VM_MIN_READAHEAD.
Date: Tue, 9 Feb 2010 16:59:19 +0530
User-Agent: KMail/1.12.2 (Linux/2.6.31.8-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Jens Axboe <jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002091659.19988.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused macro, VM_MIN_READAHEAD.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h
+++ linux-2.6/include/linux/mm.h
@@ -1189,7 +1189,6 @@ void task_dirty_inc(struct task_struct *
 
 /* readahead.c */
 #define VM_MAX_READAHEAD	128	/* kbytes */
-#define VM_MIN_READAHEAD	16	/* kbytes (includes current page) */
 
 int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
 			pgoff_t offset, unsigned long nr_to_read);
