Return-Path: <linux-kernel-owner+w=401wt.eu-S1760204AbZELJc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204AbZELJc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 05:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758333AbZELJcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 05:32:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:60097 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760069AbZELJch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 05:32:37 -0400
Date: Tue, 12 May 2009 09:32:11 GMT
From: tip-bot for Amerigo Wang <amwang@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu, amwang@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, amwang@redhat.com, mingo@elte.hu
In-Reply-To: <20090512032956.5040.77055.sendpatchset@localhost.localdomain>
References: <20090512032956.5040.77055.sendpatchset@localhost.localdomain>
Subject: [tip:x86/mm] x86: process.c, remove useless headers
Message-ID: <tip-bf78ad69cd351798b9447a269c6bd41ce1f111f4@git.kernel.org>
Git-Commit-ID: bf78ad69cd351798b9447a269c6bd41ce1f111f4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 12 May 2009 09:32:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bf78ad69cd351798b9447a269c6bd41ce1f111f4
Gitweb:     http://git.kernel.org/tip/bf78ad69cd351798b9447a269c6bd41ce1f111f4
Author:     Amerigo Wang <amwang@redhat.com>
AuthorDate: Mon, 11 May 2009 23:29:09 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 12 May 2009 11:26:32 +0200

x86: process.c, remove useless headers

<stdarg.h> is not needed by these files, remove them.

[ Impact: cleanup ]

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: akpm@linux-foundation.org
LKML-Reference: <20090512032956.5040.77055.sendpatchset@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/process_32.c |    2 --
 arch/x86/kernel/process_64.c |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index a3bb049..56d50b7 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -9,8 +9,6 @@
  * This file handles the architecture-dependent parts of process handling..
  */
 
-#include <stdarg.h>
-
 #include <linux/stackprotector.h>
 #include <linux/cpu.h>
 #include <linux/errno.h>
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 34386f7..9d6b20e 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -14,8 +14,6 @@
  * This file handles the architecture-dependent parts of process handling..
  */
 
-#include <stdarg.h>
-
 #include <linux/stackprotector.h>
 #include <linux/cpu.h>
 #include <linux/errno.h>
