Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbZDOSgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbZDOSgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 14:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbZDOSgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 14:36:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60226 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbZDOSgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 14:36:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/5] MN10300: Discard duplicate PFN_xxx() macros
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Wed, 15 Apr 2009 19:34:41 +0100
Message-ID: <20090415183441.11029.30619.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Discard duplicate PFN_xxx() macros from arch code as they're now in the
general headers.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/kernel/setup.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)


diff --git a/arch/mn10300/kernel/setup.c b/arch/mn10300/kernel/setup.c
index 71414e1..79890ed 100644
--- a/arch/mn10300/kernel/setup.c
+++ b/arch/mn10300/kernel/setup.c
@@ -136,10 +136,6 @@ void __init setup_arch(char **cmdline_p)
 	data_resource.start = virt_to_bus(&_etext);
 	data_resource.end = virt_to_bus(&_edata)-1;
 
-#define PFN_UP(x)	(((x) + PAGE_SIZE-1) >> PAGE_SHIFT)
-#define PFN_DOWN(x)	((x) >> PAGE_SHIFT)
-#define PFN_PHYS(x)	((x) << PAGE_SHIFT)
-
 	start_pfn = (CONFIG_KERNEL_RAM_BASE_ADDRESS >> PAGE_SHIFT);
 	kstart_pfn = PFN_UP(__pa(&_text));
 	free_pfn = PFN_UP(__pa(&_end));

