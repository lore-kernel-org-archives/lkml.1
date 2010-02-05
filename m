Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933991Ab0BEXfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 18:35:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:50714 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933355Ab0BEXfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 18:35:30 -0500
Date: Fri, 5 Feb 2010 23:31:38 GMT
From: tip-bot for Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andi@firstfloor.org, ak@linux.intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, ak@linux.intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100123113359.GA29555@one.firstfloor.org>
References: <20100123113359.GA29555@one.firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mce] x86, mce: Make xeon75xx memory driver dependent on PCI
Message-ID: <tip-757fd770c649b0dfa6eeefc2d5e2ea3119b6be9c@git.kernel.org>
Git-Commit-ID: 757fd770c649b0dfa6eeefc2d5e2ea3119b6be9c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Feb 2010 23:31:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  757fd770c649b0dfa6eeefc2d5e2ea3119b6be9c
Gitweb:     http://git.kernel.org/tip/757fd770c649b0dfa6eeefc2d5e2ea3119b6be9c
Author:     Andi Kleen <andi@firstfloor.org>
AuthorDate: Sat, 23 Jan 2010 12:33:59 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 5 Feb 2010 14:51:53 -0800

x86, mce: Make xeon75xx memory driver dependent on PCI

Found by Ingo Molnar's automated tester.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <20100123113359.GA29555@one.firstfloor.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f62db24..ab2d0a8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -834,7 +834,7 @@ config X86_MCE_INTEL
 
 config X86_MCE_XEON75XX
 	tristate "Intel Xeon 7500 series corrected memory error driver"
-	depends on X86_MCE_INTEL
+	depends on X86_MCE_INTEL && PCI
 	---help---
 	   Add support for a Intel Xeon 7500 series specific memory error driver.
 	   This allows to report the DIMM and physical address on a corrected
