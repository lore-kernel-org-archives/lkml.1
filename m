Return-Path: <linux-kernel-owner+w=401wt.eu-S1759588AbZFLMof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588AbZFLMof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758138AbZFLMoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:44:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:52611 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758771AbZFLMn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:43:59 -0400
Date: Fri, 12 Jun 2009 12:43:26 GMT
From: tip-bot for Shaohua Li <shaohua.li@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       shaohua.li@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, shaohua.li@intel.com, mingo@elte.hu
In-Reply-To: <20090612045752.GA827@sli10-desk.sh.intel.com>
References: <20090612045752.GA827@sli10-desk.sh.intel.com>
Subject: [tip:x86/urgent] x86: change kernel_physical_mapping_init() __init to __meminit
Message-ID: <tip-41d840e224170d2768493e320f290ed060491727@git.kernel.org>
Git-Commit-ID: 41d840e224170d2768493e320f290ed060491727
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 12 Jun 2009 12:43:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  41d840e224170d2768493e320f290ed060491727
Gitweb:     http://git.kernel.org/tip/41d840e224170d2768493e320f290ed060491727
Author:     Shaohua Li <shaohua.li@intel.com>
AuthorDate: Fri, 12 Jun 2009 12:57:52 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 12 Jun 2009 14:39:21 +0200

x86: change kernel_physical_mapping_init() __init to __meminit

kernel_physical_mapping_init() could be called in memory hotplug path.

[ Impact: fix potential crash with memory hotplug ]

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
LKML-Reference: <20090612045752.GA827@sli10-desk.sh.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 52bb951..52e1bff 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -527,7 +527,7 @@ phys_pud_update(pgd_t *pgd, unsigned long addr, unsigned long end,
 	return phys_pud_init(pud, addr, end, page_size_mask);
 }
 
-unsigned long __init
+unsigned long __meminit
 kernel_physical_mapping_init(unsigned long start,
 			     unsigned long end,
 			     unsigned long page_size_mask)
