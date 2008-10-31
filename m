Return-Path: <linux-kernel-owner+w=401wt.eu-S1752487AbYJaRwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbYJaRwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 13:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbYJaRwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 13:52:14 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:49616 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbYJaRwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 13:52:13 -0400
Date: Fri, 31 Oct 2008 10:52:03 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gary Hade <garyhade@us.ibm.com>, linux-mm@kvack.org,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Mel Gorman <mel@csn.ul.ie>,
       Chris McDermott <lcm@us.ibm.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: [PATCH] [RESEND] x86: add memory hotremove config option
Message-ID: <20081031175203.GA7483@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am resending this patch (originally posted by Badari Pulavarty)
since the "mm: cleanup to make remove_memory() arch-neutral" patch
on which it depends is now in Linus' 2.6.git tree (commit
71088785c6bc68fddb450063d57b1bd1c78e0ea1) and 2.6.28-rc2.

Thanks,
Gary

---
Add memory hotremove config option to x86

Memory hotremove functionality can currently be configured into
the ia64, powerpc, and s390 kernels.  This patch makes it possible
to configure the memory hotremove functionality into the x86
kernel as well.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Gary Hade <garyhade@us.ibm.com>

---
 arch/x86/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6.28-rc2/arch/x86/Kconfig
===================================================================
--- linux-2.6.28-rc2.orig/arch/x86/Kconfig	2008-10-31 10:34:14.000000000 -0700
+++ linux-2.6.28-rc2/arch/x86/Kconfig	2008-10-31 10:34:27.000000000 -0700
@@ -1486,6 +1486,10 @@
 	def_bool y
 	depends on X86_64 || (X86_32 && HIGHMEM)
 
+config ARCH_ENABLE_MEMORY_HOTREMOVE
+	def_bool y
+	depends on MEMORY_HOTPLUG
+
 config HAVE_ARCH_EARLY_PFN_TO_NID
 	def_bool X86_64
 	depends on NUMA
