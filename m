Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab0BBBBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 20:01:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:58698 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036Ab0BBBBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 20:01:30 -0500
Date: Tue, 2 Feb 2010 01:01:05 GMT
From: tip-bot for Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, fengguang.wu@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, fengguang.wu@intel.com
In-Reply-To: <20100127030639.GD8132@localhost>
References: <20100127030639.GD8132@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] Move page_is_ram() declaration to mm.h
Message-ID: <tip-53df8fdc15fb646b0219e43c989c2cdab1ab100c@git.kernel.org>
Git-Commit-ID: 53df8fdc15fb646b0219e43c989c2cdab1ab100c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 02 Feb 2010 01:01:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  53df8fdc15fb646b0219e43c989c2cdab1ab100c
Gitweb:     http://git.kernel.org/tip/53df8fdc15fb646b0219e43c989c2cdab1ab100c
Author:     Wu Fengguang <fengguang.wu@intel.com>
AuthorDate: Wed, 27 Jan 2010 11:06:39 +0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 1 Feb 2010 16:58:17 -0800

Move page_is_ram() declaration to mm.h

Move page_is_ram() declaration to mm.h, it makes no sense in <linux/ioport.h>.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
LKML-Reference: <20100127030639.GD8132@localhost>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 include/linux/ioport.h |    2 --
 include/linux/mm.h     |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 11ef795..83aa812 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -188,7 +188,5 @@ extern int
 walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
 		void *arg, int (*func)(unsigned long, unsigned long, void *));
 
-extern int page_is_ram(unsigned long pfn);
-
 #endif /* __ASSEMBLY__ */
 #endif	/* _LINUX_IOPORT_H */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 24c3956..bad433f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -265,6 +265,8 @@ static inline int get_page_unless_zero(struct page *page)
 	return atomic_inc_not_zero(&page->_count);
 }
 
+extern int page_is_ram(unsigned long pfn);
+
 /* Support for virtually mapped pages */
 struct page *vmalloc_to_page(const void *addr);
 unsigned long vmalloc_to_pfn(const void *addr);
