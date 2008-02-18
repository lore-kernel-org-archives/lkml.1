Return-Path: <linux-kernel-owner+w=401wt.eu-S1762401AbYBRVLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762401AbYBRVLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 16:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbYBRVLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 16:11:40 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:13283 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbYBRVLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 16:11:39 -0500
Date: Mon, 18 Feb 2008 13:10:44 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: mingo <mingo@redhat.com>, tglx <tglx@linutronix.de>, hpa <hpa@zytor.com>
Subject: [PATCH] x86/mtrr: fix kernel-doc missing notation
Message-Id: <20080218131044.d0397c84.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
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

--- linux-2.6.25-rc1-git4.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6.25-rc1-git4/arch/x86/kernel/cpu/mtrr/main.c
@@ -649,6 +649,7 @@ static __init int amd_special_default_mt
 
 /**
  * mtrr_trim_uncached_memory - trim RAM not covered by MTRRs
+ * @end_pfn: ending page frame number
  *
  * Some buggy BIOSes don't setup the MTRRs properly for systems with certain
  * memory configurations.  This routine checks that the highest MTRR matches
