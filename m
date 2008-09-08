Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbYIHV5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbYIHV5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 17:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbYIHV5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 17:57:08 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34303 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754120AbYIHV5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 17:57:06 -0400
Subject: [PATCH] x86: add memory hotremove config option
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gary Hade <garyhade@us.ibm.com>, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Mel Gorman <mel@csn.ul.ie>,
       Chris McDermott <lcm@us.ibm.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org
In-Reply-To: <20080905181754.GA14258@elte.hu>
References: <20080905172132.GA11692@us.ibm.com>
	 <20080905174449.GC27395@elte.hu> <1220638478.25932.20.camel@badari-desktop>
	 <20080905181754.GA14258@elte.hu>
Content-Type: text/plain
Date: Mon, 08 Sep 2008 14:56:58 -0700
Message-Id: <1220911018.25932.61.camel@badari-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaned up patch with out remove_memory(). 
Depends on make remove_memory() arch neutral patch.

Thanks,
Badari

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

Index: linux-2.6.27-rc5/arch/x86/Kconfig
===================================================================
--- linux-2.6.27-rc5.orig/arch/x86/Kconfig	2008-09-08 12:36:06.000000000 -0700
+++ linux-2.6.27-rc5/arch/x86/Kconfig	2008-09-08 12:45:30.000000000 -0700
@@ -1384,6 +1384,10 @@ config ARCH_ENABLE_MEMORY_HOTPLUG
 	def_bool y
 	depends on X86_64 || (X86_32 && HIGHMEM)
 
+config ARCH_ENABLE_MEMORY_HOTREMOVE
+	def_bool y
+	depends on MEMORY_HOTPLUG
+
 config HAVE_ARCH_EARLY_PFN_TO_NID
 	def_bool X86_64
 	depends on NUMA


