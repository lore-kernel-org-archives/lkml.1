Return-Path: <linux-kernel-owner+w=401wt.eu-S1759757AbZEFMVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759757AbZEFMVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759160AbZEFMVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:21:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:36045 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756034AbZEFMVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:21:32 -0400
Date: Wed, 6 May 2009 12:20:05 GMT
From: tip-bot for Nikanth Karthikesan <knikanth@suse.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       knikanth@suse.de, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       knikanth@suse.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <200905040908.27299.knikanth@suse.de>
References: <200905040908.27299.knikanth@suse.de>
Subject: [tip:x86/urgent] x86: Fix a typo in a printk message
Message-ID: <tip-e0e5ea3268db428d19e1c5fa00e6f583861cbdbd@git.kernel.org>
Git-Commit-ID: e0e5ea3268db428d19e1c5fa00e6f583861cbdbd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 06 May 2009 12:20:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e0e5ea3268db428d19e1c5fa00e6f583861cbdbd
Gitweb:     http://git.kernel.org/tip/e0e5ea3268db428d19e1c5fa00e6f583861cbdbd
Author:     Nikanth Karthikesan <knikanth@suse.de>
AuthorDate: Mon, 4 May 2009 09:08:26 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 6 May 2009 12:23:12 +0200

x86: Fix a typo in a printk message

[ Impact: printk message cleanup ]

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
LKML-Reference: <200905040908.27299.knikanth@suse.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/srat_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/srat_32.c b/arch/x86/mm/srat_32.c
index 16ae70f..29a0e37 100644
--- a/arch/x86/mm/srat_32.c
+++ b/arch/x86/mm/srat_32.c
@@ -216,7 +216,7 @@ int __init get_memcfg_from_srat(void)
 
 	if (num_memory_chunks == 0) {
 		printk(KERN_WARNING
-			 "could not finy any ACPI SRAT memory areas.\n");
+			 "could not find any ACPI SRAT memory areas.\n");
 		goto out_fail;
 	}
 
