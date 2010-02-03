Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab0BCBFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 20:05:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:51103 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852Ab0BCBE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 20:04:59 -0500
Date: Wed, 3 Feb 2010 01:03:40 GMT
From: tip-bot for Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, ext-andriy.shevchenko@nokia.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, ext-andriy.shevchenko@nokia.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <201002022238.o12McDiF018720@imap1.linux-foundation.org>
References: <201002022238.o12McDiF018720@imap1.linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, doc: Fix minor spelling error in arch/x86/mm/gup.c
Message-ID: <tip-ab09809f2eee1dc2d8f8bea636e77d176ba6c648@git.kernel.org>
Git-Commit-ID: ab09809f2eee1dc2d8f8bea636e77d176ba6c648
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 03 Feb 2010 01:03:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ab09809f2eee1dc2d8f8bea636e77d176ba6c648
Gitweb:     http://git.kernel.org/tip/ab09809f2eee1dc2d8f8bea636e77d176ba6c648
Author:     Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
AuthorDate: Tue, 2 Feb 2010 14:38:12 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 2 Feb 2010 16:00:44 -0800

x86, doc: Fix minor spelling error in arch/x86/mm/gup.c

Fix minor spelling error in comment.  No code change.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
LKML-Reference: <201002022238.o12McDiF018720@imap1.linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/mm/gup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index 71da1bc..738e659 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -18,7 +18,7 @@ static inline pte_t gup_get_pte(pte_t *ptep)
 #else
 	/*
 	 * With get_user_pages_fast, we walk down the pagetables without taking
-	 * any locks.  For this we would like to load the pointers atoimcally,
+	 * any locks.  For this we would like to load the pointers atomically,
 	 * but that is not possible (without expensive cmpxchg8b) on PAE.  What
 	 * we do have is the guarantee that a pte will only either go from not
 	 * present to present, or present to not present or both -- it will not
