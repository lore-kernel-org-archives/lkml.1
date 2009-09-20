Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbZITS3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbZITS3d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426AbZITS3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:29:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:56237 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755418AbZITS32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:29:28 -0400
Date: Sun, 20 Sep 2009 18:29:11 GMT
From: tip-bot for Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       sergey.senozhatsky@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sergey.senozhatsky@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090917125401.GU3717@localdomain.by>
References: <20090917125401.GU3717@localdomain.by>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix uaccess_32.h typo
Message-ID: <tip-4fe487828b912ca004b4f4505275ab164ed6ce9f@git.kernel.org>
Git-Commit-ID: 4fe487828b912ca004b4f4505275ab164ed6ce9f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 20 Sep 2009 18:29:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4fe487828b912ca004b4f4505275ab164ed6ce9f
Gitweb:     http://git.kernel.org/tip/4fe487828b912ca004b4f4505275ab164ed6ce9f
Author:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
AuthorDate: Thu, 17 Sep 2009 15:54:01 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 20 Sep 2009 20:19:34 +0200

x86: Fix uaccess_32.h typo

Trivial: correct "that the we don't" typo.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
LKML-Reference: <20090917125401.GU3717@localdomain.by>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/uaccess_32.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/uaccess_32.h b/arch/x86/include/asm/uaccess_32.h
index 5e06259..632fb44 100644
--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -33,7 +33,7 @@ unsigned long __must_check __copy_from_user_ll_nocache_nozero
  * Copy data from kernel space to user space.  Caller must check
  * the specified block with access_ok() before calling this function.
  * The caller should also make sure he pins the user space address
- * so that the we don't result in page fault and sleep.
+ * so that we don't result in page fault and sleep.
  *
  * Here we special-case 1, 2 and 4-byte copy_*_user invocations.  On a fault
  * we return the initial request size (1, 2 or 4), as copy_*_user should do.
