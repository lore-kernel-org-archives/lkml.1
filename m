Return-Path: <linux-kernel-owner+w=401wt.eu-S1751445AbZIFEjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbZIFEjQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 00:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbZIFEjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 00:39:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:42051 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847AbZIFEjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 00:39:13 -0400
Date: Sun, 6 Sep 2009 04:38:27 GMT
From: "tip-bot for Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, rjw@sisk.pl, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, rjw@sisk.pl, mingo@elte.hu
In-Reply-To: <200909050107.45175.rjw@sisk.pl>
References: <200909050107.45175.rjw@sisk.pl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86: Decrease the level of some NUMA messages to KERN_DEBUG
Message-ID: <tip-23b6c52cf558f2a1dc6c7010c601b3624eb4591f@git.kernel.org>
Git-Commit-ID: 23b6c52cf558f2a1dc6c7010c601b3624eb4591f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 06 Sep 2009 04:38:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  23b6c52cf558f2a1dc6c7010c601b3624eb4591f
Gitweb:     http://git.kernel.org/tip/23b6c52cf558f2a1dc6c7010c601b3624eb4591f
Author:     Rafael J. Wysocki <rjw@sisk.pl>
AuthorDate: Sat, 5 Sep 2009 01:07:45 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 6 Sep 2009 06:32:23 +0200

x86: Decrease the level of some NUMA messages to KERN_DEBUG

Some NUMA messages in srat_32.c are confusing to users,
because they seem to indicate errors, while in fact they
reflect normal behaviour.

Decrease the level of these messages to KERN_DEBUG so that
they don't show up unnecessarily.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
LKML-Reference: <200909050107.45175.rjw@sisk.pl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/srat_32.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/srat_32.c b/arch/x86/mm/srat_32.c
index 29a0e37..6f8aa33 100644
--- a/arch/x86/mm/srat_32.c
+++ b/arch/x86/mm/srat_32.c
@@ -215,7 +215,7 @@ int __init get_memcfg_from_srat(void)
 		goto out_fail;
 
 	if (num_memory_chunks == 0) {
-		printk(KERN_WARNING
+		printk(KERN_DEBUG
 			 "could not find any ACPI SRAT memory areas.\n");
 		goto out_fail;
 	}
@@ -277,7 +277,7 @@ int __init get_memcfg_from_srat(void)
 	}
 	return 1;
 out_fail:
-	printk(KERN_ERR "failed to get NUMA memory information from SRAT"
+	printk(KERN_DEBUG "failed to get NUMA memory information from SRAT"
 			" table\n");
 	return 0;
 }
