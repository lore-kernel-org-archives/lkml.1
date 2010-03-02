Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab0CBTez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 14:34:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:50354 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449Ab0CBTex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 14:34:53 -0500
Date: Tue, 2 Mar 2010 19:33:37 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, tglx@linutronix.de,
       fengguang.wu@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, tglx@linutronix.de,
       fengguang.wu@intel.com
In-Reply-To: <20100301135551.GA9998@localhost>
References: <20100301135551.GA9998@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] resource: Fix broken indentation
Message-ID: <tip-f41496607e03ab99f263b8e26689ad0fc853007f@git.kernel.org>
Git-Commit-ID: f41496607e03ab99f263b8e26689ad0fc853007f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 02 Mar 2010 19:33:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f41496607e03ab99f263b8e26689ad0fc853007f
Gitweb:     http://git.kernel.org/tip/f41496607e03ab99f263b8e26689ad0fc853007f
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Tue, 2 Mar 2010 11:21:09 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 2 Mar 2010 11:21:09 -0800

resource: Fix broken indentation

Fix broken indentation in patch
37b99dd5372cff42f83210c280f314f10f99138e.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
LKML-Reference: <20100301135551.GA9998@localhost>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 kernel/resource.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 8f0e3d0..91f430f 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -287,7 +287,7 @@ int walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
 		pfn = (res.start + PAGE_SIZE - 1) >> PAGE_SHIFT;
 		end_pfn = (res.end + 1) >> PAGE_SHIFT;
 		if (end_pfn > pfn)
-		    ret = (*func)(pfn, end_pfn - pfn, arg);
+			ret = (*func)(pfn, end_pfn - pfn, arg);
 		if (ret)
 			break;
 		res.start = res.end + 1;
