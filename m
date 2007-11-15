Return-Path: <linux-kernel-owner+w=401wt.eu-S1761592AbXKOKc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761592AbXKOKc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 05:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756340AbXKOKcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 05:32:21 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38528 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbXKOKcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 05:32:20 -0500
Date: Thu, 15 Nov 2007 19:33:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       apw@shadowen.org, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: [PATCH][2.6.24-rc2-mm1] memory hotplug x86_64 fix [1/3]
 memory_add_physaddr_to_nid export for acpi memhotplug.ko
Message-Id: <20071115193325.a1b4dd5a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071115193016.daabe91e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	<20071115132919.f2bf4946.kamezawa.hiroyu@jp.fujitsu.com>
	<20071115005657.99856c28.akpm@linux-foundation.org>
	<20071115181816.1f0cb905.kamezawa.hiroyu@jp.fujitsu.com>
	<20071115193016.daabe91e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fix following reference error (when CONFIG_ACPI_HOTPLUG_MEMORY=m)

==
 ERROR: "memory_add_physaddr_to_nid" [drivers/acpi/acpi_memhotplug.ko]
 undefined!
==

Changelog:
 - EXPORT_SYMBOL to EXPORT_SYMBOL_GPL.


Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

 arch/x86/mm/srat_64.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.24-rc2-mm1/arch/x86/mm/srat_64.c
===================================================================
--- linux-2.6.24-rc2-mm1.orig/arch/x86/mm/srat_64.c
+++ linux-2.6.24-rc2-mm1/arch/x86/mm/srat_64.c
@@ -562,3 +562,4 @@ int memory_add_physaddr_to_nid(u64 start
 	return ret;
 }
 
+EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);


