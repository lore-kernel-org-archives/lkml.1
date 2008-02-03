Return-Path: <linux-kernel-owner+w=401wt.eu-S1753778AbYBCXGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbYBCXGf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 18:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754902AbYBCXGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 18:06:11 -0500
Received: from xenotime.net ([66.160.160.81]:39867 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754893AbYBCXGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 18:06:10 -0500
Date: Sun, 3 Feb 2008 15:06:07 -0800 (PST)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: linux-kernel@vger.kernel.org
cc: tglx@linutronix.de, mingo@redhat.com, akpm@linux-foundation.org,
       hpa@zytor.com
Subject: [PATCH 3/8] kernel-doc: fix mtrr warning
Message-ID: <Pine.LNX.4.64.0802031441270.3021@shark.he.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix mtrr kernel-doc warning:
Warning(linux-2.6.24-git12//arch/x86/kernel/cpu/mtrr/main.c:677): No description found for parameter 'end_pfn'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
  arch/x86/kernel/cpu/mtrr/main.c |    1 +
  1 file changed, 1 insertion(+)

--- linux-2.6.24-git12.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6.24-git12/arch/x86/kernel/cpu/mtrr/main.c
@@ -665,6 +665,7 @@ static __init int amd_special_default_mt

  /**
   * mtrr_trim_uncached_memory - trim RAM not covered by MTRRs
+ * @end_pfn: ending page frame number
   *
   * Some buggy BIOSes don't setup the MTRRs properly for systems with certain
   * memory configurations.  This routine checks that the highest MTRR matches
