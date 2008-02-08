Return-Path: <linux-kernel-owner+w=401wt.eu-S1758923AbYBHXih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923AbYBHXih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 18:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbYBHXhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 18:37:43 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58159 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753544AbYBHXhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 18:37:39 -0500
Message-Id: <20080208233738.699960000@polaris-admin.engr.sgi.com>
References: <20080208233738.108449000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 08 Feb 2008 15:37:42 -0800
From: Mike Travis <travis@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] x86: minor cleanup of comments in processor.h
Content-Disposition: inline; filename=cleanup-processor.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removal of trivial comments in processor.h

Based on linux-2.6.git + x86.git

Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/asm-x86/processor.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -302,10 +302,6 @@ union i387_union {
 };
 
 #ifdef CONFIG_X86_32
-/*
- * the following now lives in the per cpu area:
- * extern	int cpu_llc_id[NR_CPUS];
- */
 DECLARE_PER_CPU(u8, cpu_llc_id);
 #else
 DECLARE_PER_CPU(struct orig_ist, orig_ist);

-- 
