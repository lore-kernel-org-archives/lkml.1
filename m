Return-Path: <linux-kernel-owner+w=401wt.eu-S1756538AbZF2EUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbZF2EUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 00:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757698AbZF2ETv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 00:19:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:48416 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757859AbZF2ETu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 00:19:50 -0400
Date: Mon, 29 Jun 2009 04:19:23 GMT
From: "tip-bot for Figo.zhang" <figo1802@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       figo1802@gmail.com, akpm@osdl.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       figo1802@gmail.com, tglx@linutronix.de, akpm@osdl.org, mingo@elte.hu
In-Reply-To: <1246248175.5759.12.camel@myhost>
References: <1246248175.5759.12.camel@myhost>
Subject: [tip:x86/mm] x86, highmem_32.c: Clean up comment
Message-ID: <tip-565b0c1f100408ccbcb04ba458a14da454cb271d@git.kernel.org>
Git-Commit-ID: 565b0c1f100408ccbcb04ba458a14da454cb271d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 29 Jun 2009 04:19:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  565b0c1f100408ccbcb04ba458a14da454cb271d
Gitweb:     http://git.kernel.org/tip/565b0c1f100408ccbcb04ba458a14da454cb271d
Author:     Figo.zhang <figo1802@gmail.com>
AuthorDate: Mon, 29 Jun 2009 12:02:55 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 29 Jun 2009 06:14:43 +0200

x86, highmem_32.c: Clean up comment

Signed-off-by: Figo.zhang <figo1802@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>
LKML-Reference: <1246248175.5759.12.camel@myhost>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/highmem_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index 58f621e..0c6f43c 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -24,7 +24,7 @@ void kunmap(struct page *page)
  * no global lock is needed and because the kmap code must perform a global TLB
  * invalidation when the kmap pool wraps.
  *
- * However when holding an atomic kmap is is not legal to sleep, so atomic
+ * However when holding an atomic kmap it is not legal to sleep, so atomic
  * kmaps are appropriate for short, tight code paths only.
  */
 void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot)
