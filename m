Return-Path: <linux-kernel-owner+w=401wt.eu-S1760353AbZEMNx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760353AbZEMNx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 09:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756045AbZEMNxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 09:53:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:60300 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307AbZEMNxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 09:53:45 -0400
Date: Wed, 13 May 2009 13:52:00 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       randy.dunlap@oracle.com, jeremy.fitzhardinge@citrix.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, jeremy.fitzhardinge@citrix.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:x86/urgent] xen: use header for EXPORT_SYMBOL_GPL
Message-ID: <tip-44408ad7368906c84000e87a99c14a16dbb867fd@git.kernel.org>
Git-Commit-ID: 44408ad7368906c84000e87a99c14a16dbb867fd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 13 May 2009 13:52:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  44408ad7368906c84000e87a99c14a16dbb867fd
Gitweb:     http://git.kernel.org/tip/44408ad7368906c84000e87a99c14a16dbb867fd
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Tue, 12 May 2009 13:31:40 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 May 2009 15:43:55 +0200

xen: use header for EXPORT_SYMBOL_GPL

mmu.c needs to #include module.h to prevent these warnings:

 arch/x86/xen/mmu.c:239: warning: data definition has no type or storage class
 arch/x86/xen/mmu.c:239: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
 arch/x86/xen/mmu.c:239: warning: parameter names (without types) in function declaration

[ Impact: cleanup ]

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/xen/mmu.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index e25a78e..fba55b1 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -42,6 +42,7 @@
 #include <linux/highmem.h>
 #include <linux/debugfs.h>
 #include <linux/bug.h>
+#include <linux/module.h>
 
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
