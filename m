Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbZHJPqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbZHJPqO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 11:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbZHJPqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 11:46:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47108 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122AbZHJPqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 11:46:12 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] MN10300: includecheck fix: mn10300, pci.h
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       David Howells <dhowells@redhat.com>
Date: Mon, 10 Aug 2009 16:45:42 +0100
Message-ID: <20090810154541.18045.60871.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaswinder Singh Rajput <jaswinder@kernel.org>

Fix the following 'make includecheck' warning:

  arch/mn10300/include/asm/pci.h: linux/mm.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/pci.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)


diff --git a/arch/mn10300/include/asm/pci.h b/arch/mn10300/include/asm/pci.h
index 35d2ed6..19aecc9 100644
--- a/arch/mn10300/include/asm/pci.h
+++ b/arch/mn10300/include/asm/pci.h
@@ -59,7 +59,6 @@ void pcibios_penalize_isa_irq(int irq);
 #include <linux/slab.h>
 #include <asm/scatterlist.h>
 #include <linux/string.h>
-#include <linux/mm.h>
 #include <asm/io.h>
 
 struct pci_dev;

