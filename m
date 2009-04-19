Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbZDSI0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbZDSI0Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 04:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755502AbZDSIZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 04:25:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:55351 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbZDSIZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 04:25:44 -0400
Date: Sun, 19 Apr 2009 08:24:53 GMT
From: tip-bot for Weidong Han <weidong.han@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       weidong.han@intel.com, randy.dunlap@oracle.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu,
       David.Woodhouse@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       weidong.han@intel.com, randy.dunlap@oracle.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu,
       David.Woodhouse@intel.com
In-Reply-To: <1239957736-6161-2-git-send-email-weidong.han@intel.com>
References: <1239957736-6161-2-git-send-email-weidong.han@intel.com>
Subject: [tip:x86/apic] docs, x86: add nox2apic back to kernel-parameters.txt
Message-ID: <tip-2b2fd87a6ef56ba7647a578e81bb8c8efda166b8@git.kernel.org>
Git-Commit-ID: 2b2fd87a6ef56ba7647a578e81bb8c8efda166b8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 19 Apr 2009 08:24:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b2fd87a6ef56ba7647a578e81bb8c8efda166b8
Gitweb:     http://git.kernel.org/tip/2b2fd87a6ef56ba7647a578e81bb8c8efda166b8
Author:     Weidong Han <weidong.han@intel.com>
AuthorDate: Fri, 17 Apr 2009 16:42:12 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 19 Apr 2009 10:21:13 +0200

docs, x86: add nox2apic back to kernel-parameters.txt

"nox2apic" was removed from kernel-parameters.txt by mistake, when
entries were sorted in alpha order (commit 0cb55ad2). But this early
parameter is still there, add it back to kernel-parameters.txt.

[ Impact: add boot parameter description ]

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Weidong Han <weidong.han@intel.com>
Acked-by: David Woodhouse <David.Woodhouse@intel.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: iommu@lists.linux-foundation.org
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
