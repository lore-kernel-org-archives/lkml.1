Return-Path: <linux-kernel-owner+w=401wt.eu-S1761376AbZDQOty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761376AbZDQOty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761865AbZDQOtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:49:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:43942 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761849AbZDQOtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:49:41 -0400
Date: Fri, 17 Apr 2009 14:48:50 GMT
From: tip-bot for Weidong Han <weidong.han@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       suresh.b.siddha@intel.com, weidong.han@intel.com, tglx@linutronix.de,
       randy.dunlap@oracle.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       weidong.han@intel.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       randy.dunlap@oracle.com, mingo@elte.hu
In-Reply-To: <1239957736-6161-2-git-send-email-weidong.han@intel.com>
References: <1239957736-6161-2-git-send-email-weidong.han@intel.com>
Subject: [tip:x86/apic] docs, x86: add nox2apic back to kernel-parameters.txt
Message-ID: <tip-66a2f36639a85d06e28819e2896efbea38e97ada@git.kernel.org>
Git-Commit-ID: 66a2f36639a85d06e28819e2896efbea38e97ada
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 17 Apr 2009 14:48:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  66a2f36639a85d06e28819e2896efbea38e97ada
Gitweb:     http://git.kernel.org/tip/66a2f36639a85d06e28819e2896efbea38e97ada
Author:     Weidong Han <weidong.han@intel.com>
AuthorDate: Fri, 17 Apr 2009 16:42:12 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 17 Apr 2009 16:23:44 +0200

docs, x86: add nox2apic back to kernel-parameters.txt

"nox2apic" was removed from kernel-parameters.txt by mistake, when
entries were sorted in alpha order (commit 0cb55ad2). But this early
parameter is still there, add it back to kernel-parameters.txt.

[ Impact: add boot parameter description ]

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Weidong Han <weidong.han@intel.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: iommu@lists.linux-foundation.org
Cc: dwmw2@infradead.org
Cc: allen.m.kay@intel.com
Cc: fenghua.yu@intel.com
LKML-Reference: <1239957736-6161-2-git-send-email-weidong.han@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/kernel-parameters.txt |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6172e43..33989d2 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1588,6 +1588,8 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	nowb		[ARM]
 
+	nox2apic	[X86-64,APIC] Do not enable x2APIC mode.
+
 	nptcg=		[IA64] Override max number of concurrent global TLB
 			purges which is reported from either PAL_VM_SUMMARY or
 			SAL PALO.
