Return-Path: <linux-kernel-owner+w=401wt.eu-S1752248AbZKAL4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbZKAL4f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 06:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbZKAL4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 06:56:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbZKAL42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 06:56:28 -0500
From: Gleb Natapov <gleb@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/11] Export __get_user_pages_fast.
Date: Sun,  1 Nov 2009 13:56:23 +0200
Message-Id: <1257076590-29559-5-git-send-email-gleb@redhat.com>
In-Reply-To: <1257076590-29559-1-git-send-email-gleb@redhat.com>
References: <1257076590-29559-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/mm/gup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index 71da1bc..cea0dfe 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -8,6 +8,7 @@
 #include <linux/mm.h>
 #include <linux/vmstat.h>
 #include <linux/highmem.h>
+#include <linux/module.h>
 
 #include <asm/pgtable.h>
 
@@ -274,6 +275,7 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 
 	return nr;
 }
+EXPORT_SYMBOL_GPL(__get_user_pages_fast);
 
 /**
  * get_user_pages_fast() - pin user pages in memory
-- 
1.6.3.3

