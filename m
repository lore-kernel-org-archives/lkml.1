Return-Path: <linux-kernel-owner+w=401wt.eu-S1755097AbYLSVvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbYLSVvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 16:51:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbYLSVu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:50:28 -0500
Received: from mga01.intel.com ([192.55.52.88]:28552 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011AbYLSVuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:50:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,250,1228118400"; 
   d="scan'208";a="416028222"
Message-Id: <20081219214837.567076000@intel.com>
References: <20081219214725.125171000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 19 Dec 2008 13:47:30 -0800
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, npiggin@suse.de, hugh@veritas.com
Cc: arjan@infradead.org, jbarnes@virtuousgeek.org, rdreier@cisco.com,
       jeremy@goop.org, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 5/5] x86 PAT: pfnmap documentation update changes
Content-Disposition: inline; filename=documentation_updates_comments.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation updates as per Randy Dunlap's comments.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

---
 Documentation/x86/pat.txt |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/Documentation/x86/pat.txt
===================================================================
--- linux-2.6.orig/Documentation/x86/pat.txt	2008-12-19 09:55:04.000000000 -0800
+++ linux-2.6/Documentation/x86/pat.txt	2008-12-19 10:15:46.000000000 -0800
@@ -82,23 +82,23 @@ pci proc               |    --    |    -
 
 Advanced APIs for drivers
 -------------------------
-A. Exporting pages to user with remap_pfn_range, io_remap_pfn_range,
+A. Exporting pages to users with remap_pfn_range, io_remap_pfn_range,
 vm_insert_pfn
 
-Drivers wanting to export some pages to userspace, do it by using mmap
+Drivers wanting to export some pages to userspace do it by using mmap
 interface and a combination of
 1) pgprot_noncached()
 2) io_remap_pfn_range() or remap_pfn_range() or vm_insert_pfn()
 
-With pat support, a new API pgprot_writecombine is being added. So, driver can
+With PAT support, a new API pgprot_writecombine is being added. So, drivers can
 continue to use the above sequence, with either pgprot_noncached() or
 pgprot_writecombine() in step 1, followed by step 2.
 
 In addition, step 2 internally tracks the region as UC or WC in memtype
 list in order to ensure no conflicting mapping.
 
-Note that this set of APIs only work with IO (non RAM) regions. If driver
-wants to export RAM region, it has to do set_memory_uc() or set_memory_wc()
+Note that this set of APIs only works with IO (non RAM) regions. If driver
+wants to export a RAM region, it has to do set_memory_uc() or set_memory_wc()
 as step 0 above and also track the usage of those pages and use set_memory_wb()
 before the page is freed to free pool.
 

-- 

