Return-Path: <linux-kernel-owner+w=401wt.eu-S1755632AbYFRVEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632AbYFRVEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 17:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbYFRVEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 17:04:23 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:10443 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbYFRVEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 17:04:23 -0400
Date: Wed, 18 Jun 2008 14:04:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: x86-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] x86/mm/init_64: fix printk format warning
Message-Id: <20080618140403.a988652e.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
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

Fix x86/mm/init_64.c printk format warning:

linux-next-20080618/arch/x86/mm/init_64.c:834: warning: format '%u' expects type 'unsigned int', but argument 3 has type 'long unsigned int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/mm/init_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20080618.orig/arch/x86/mm/init_64.c
+++ linux-next-20080618/arch/x86/mm/init_64.c
@@ -830,7 +830,7 @@ int __init reserve_bootmem_generic(unsig
 		if (pfn < max_pfn_mapped)
 			return -EFAULT;
 
-		printk(KERN_ERR "reserve_bootmem: illegal reserve %lx %u\n",
+		printk(KERN_ERR "reserve_bootmem: illegal reserve %lx %lu\n",
 				phys, len);
 		return -EFAULT;
 	}
