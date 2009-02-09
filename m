Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbZBIQsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbZBIQsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 11:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbZBIQsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 11:48:14 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60455 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116AbZBIQsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 11:48:13 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: in_interrupt() requires #inclusion of linux/hardirq.h
	not asm/hardirq.h now
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Mon, 09 Feb 2009 16:47:36 +0000
Message-ID: <20090209164736.9147.9132.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in_interrupt() requires #inclusion of linux/hardirq.h not asm/hardirq.h now.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/mm/dma-alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/arch/frv/mm/dma-alloc.c b/arch/frv/mm/dma-alloc.c
index dc6522c..44840e7 100644
--- a/arch/frv/mm/dma-alloc.c
+++ b/arch/frv/mm/dma-alloc.c
@@ -36,10 +36,10 @@
 #include <linux/vmalloc.h>
 #include <linux/init.h>
 #include <linux/pci.h>
+#include <linux/hardirq.h>
 
 #include <asm/pgalloc.h>
 #include <asm/io.h>
-#include <asm/hardirq.h>
 #include <asm/mmu_context.h>
 #include <asm/pgtable.h>
 #include <asm/mmu.h>

