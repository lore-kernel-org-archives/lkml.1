Return-Path: <linux-kernel-owner+w=401wt.eu-S1754239AbZKBJcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbZKBJcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 04:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbZKBJcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 04:32:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:36263 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406AbZKBJcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 04:32:45 -0500
Date: Mon, 2 Nov 2009 09:30:50 GMT
From: tip-bot for Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       davej@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, davej@redhat.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix printk message typo in mtrr cleanup code
Message-ID: <tip-16121d70fdf9eeb05ead46b241a293156323dbbe@git.kernel.org>
Git-Commit-ID: 16121d70fdf9eeb05ead46b241a293156323dbbe
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  16121d70fdf9eeb05ead46b241a293156323dbbe
Gitweb:     http://git.kernel.org/tip/16121d70fdf9eeb05ead46b241a293156323dbbe
Author:     Dave Jones <davej@redhat.com>
AuthorDate: Sun, 1 Nov 2009 19:27:05 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 2 Nov 2009 08:36:18 +0100

x86: Fix printk message typo in mtrr cleanup code

Trivial typo.

Signed-off-by: Dave Jones <davej@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mtrr/cleanup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index 315738c..73c86db 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -846,7 +846,7 @@ int __init mtrr_cleanup(unsigned address_bits)
 	sort(range, nr_range, sizeof(struct res_range), cmp_range, NULL);
 
 	range_sums = sum_ranges(range, nr_range);
-	printk(KERN_INFO "total RAM coverred: %ldM\n",
+	printk(KERN_INFO "total RAM covered: %ldM\n",
 	       range_sums >> (20 - PAGE_SHIFT));
 
 	if (mtrr_chunk_size && mtrr_gran_size) {
