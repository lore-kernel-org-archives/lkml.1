Return-Path: <linux-kernel-owner+w=401wt.eu-S933179AbZLFJQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933179AbZLFJQu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 04:16:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932978AbZLFJQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 04:16:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:47412 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932558AbZLFJQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 04:16:42 -0500
Date: Sun, 6 Dec 2009 09:16:10 GMT
From: tip-bot for Shaun Patterson <shaunpatterson@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jkosina@suse.cz, shaunpatterson@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, shaunpatterson@gmail.com, jkosina@suse.cz,
       mingo@elte.hu
In-Reply-To: <1260027694.10074.170.camel@linux-4lgc.site>
References: <1260027694.10074.170.camel@linux-4lgc.site>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix typo in arch/x86/mm/kmmio.c
Message-ID: <tip-8055039c2a2454c7159dcbde3161943b757a6e0e@git.kernel.org>
Git-Commit-ID: 8055039c2a2454c7159dcbde3161943b757a6e0e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8055039c2a2454c7159dcbde3161943b757a6e0e
Gitweb:     http://git.kernel.org/tip/8055039c2a2454c7159dcbde3161943b757a6e0e
Author:     Shaun Patterson <shaunpatterson@gmail.com>
AuthorDate: Sat, 5 Dec 2009 10:41:34 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 6 Dec 2009 09:23:40 +0100

x86: Fix typo in arch/x86/mm/kmmio.c

Signed-off-by: Shaun Patterson <shaunpatterson@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: pq@iki.fi
LKML-Reference: <1260027694.10074.170.camel@linux-4lgc.site>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/kmmio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index 16ccbd7..72f1572 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -490,7 +490,7 @@ static void remove_kmmio_fault_pages(struct rcu_head *head)
  * 2. remove_kmmio_fault_pages()
  *    Remove the pages from kmmio_page_table.
  * 3. rcu_free_kmmio_fault_pages()
- *    Actally free the kmmio_fault_page structs as with RCU.
+ *    Actually free the kmmio_fault_page structs as with RCU.
  */
 void unregister_kmmio_probe(struct kmmio_probe *p)
 {
