Return-Path: <linux-kernel-owner+w=401wt.eu-S1757917AbZDKH4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbZDKH4W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 03:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756970AbZDKH4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 03:56:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:49797 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756941AbZDKH4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 03:56:11 -0400
Subject: [PATCH -tip] x86: mm/pat.c pat_disable should be static
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 11 Apr 2009 13:24:53 +0530
Message-Id: <1239436493.3975.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: reduce kernel size a bit, avoid sparse warning

Fixes sparse warning:
  arch/x86/mm/pat.c:34:16: warning: symbol 'pat_disable' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/mm/pat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index cc5e0e2..bc53d8d 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -31,7 +31,7 @@
 #ifdef CONFIG_X86_PAT
 int __read_mostly pat_enabled = 1;
 
-void __cpuinit pat_disable(const char *reason)
+static void __cpuinit pat_disable(const char *reason)
 {
 	pat_enabled = 0;
 	printk(KERN_INFO "%s\n", reason);
-- 
1.6.0.6



