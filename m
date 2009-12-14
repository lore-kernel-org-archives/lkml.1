Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbZLNH7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbZLNH7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 02:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbZLNH7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 02:59:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:58302 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755146AbZLNH7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 02:59:36 -0500
Date: Mon, 14 Dec 2009 07:58:19 GMT
From: tip-bot for Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       joe@perches.com, torvalds@linux-foundation.org, peterz@infradead.org,
       tglx@linutronix.de, sfr@canb.auug.org.au, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joe@perches.com, torvalds@linux-foundation.org, peterz@infradead.org,
       tglx@linutronix.de, sfr@canb.auug.org.au, mingo@elte.hu
In-Reply-To: <1260775443.18538.16.camel@Joe-Laptop.home>
References: <1260775443.18538.16.camel@Joe-Laptop.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix build warning in arch/x86/mm/mmio-mod.c
Message-ID: <tip-eba11d6da7a983cedb0acf32a38e4d0daa8b5d0e@git.kernel.org>
Git-Commit-ID: eba11d6da7a983cedb0acf32a38e4d0daa8b5d0e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eba11d6da7a983cedb0acf32a38e4d0daa8b5d0e
Gitweb:     http://git.kernel.org/tip/eba11d6da7a983cedb0acf32a38e4d0daa8b5d0e
Author:     Joe Perches <joe@perches.com>
AuthorDate: Sun, 13 Dec 2009 23:24:03 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Dec 2009 08:55:43 +0100

x86: Fix build warning in arch/x86/mm/mmio-mod.c

Stephen Rothwell reported these warnings:

 arch/x86/mm/mmio-mod.c: In function 'print_pte':
 arch/x86/mm/mmio-mod.c:100: warning: too many arguments for format
 arch/x86/mm/mmio-mod.c:106: warning: too many arguments for format

The 'fmt' was left out accidentally.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Linus <torvalds@linux-foundation.org>
LKML-Reference: <1260775443.18538.16.camel@Joe-Laptop.home>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/mmio-mod.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index 4c765e9..34a3291 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -20,7 +20,7 @@
  * Derived from the read-mod example from relay-examples by Tom Zanussi.
  */
 
-#define pr_fmt(fmt) "mmiotrace: "
+#define pr_fmt(fmt) "mmiotrace: " fmt
 
 #define DEBUG 1
 
