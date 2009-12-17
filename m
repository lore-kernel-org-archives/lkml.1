Return-Path: <linux-kernel-owner+w=401wt.eu-S932569AbZLQBCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569AbZLQBCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763539AbZLQBCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:02:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:38954 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763566AbZLQBCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:02:16 -0500
Date: Thu, 17 Dec 2009 01:01:44 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de
In-Reply-To: <4B22D754.2020706@kernel.org>
References: <4B22D754.2020706@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Increase MAX_EARLY_RES; insufficient on 32-bit NUMA
Message-ID: <tip-6a1e008a0915f502eb026fb995ea3e49d5b017f7@git.kernel.org>
Git-Commit-ID: 6a1e008a0915f502eb026fb995ea3e49d5b017f7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6a1e008a0915f502eb026fb995ea3e49d5b017f7
Gitweb:     http://git.kernel.org/tip/6a1e008a0915f502eb026fb995ea3e49d5b017f7
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Tue, 15 Dec 2009 17:59:03 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 16 Dec 2009 16:46:23 -0800

x86: Increase MAX_EARLY_RES; insufficient on 32-bit NUMA

Due to recent changes wakeup and mptable, we run out of early
reservations on 32-bit NUMA.  Thus, adjust the available number.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4B22D754.2020706@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/e820.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index f50447d..05ed7ab 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -724,7 +724,7 @@ core_initcall(e820_mark_nvs_memory);
 /*
  * Early reserved memory areas.
  */
-#define MAX_EARLY_RES 20
+#define MAX_EARLY_RES 32
 
 struct early_res {
 	u64 start, end;
