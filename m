Return-Path: <linux-kernel-owner+w=401wt.eu-S964915AbXBTOTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964915AbXBTOTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 09:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964924AbXBTOTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 09:19:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:32850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964915AbXBTOTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 09:19:20 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] FRV: Missing error defs
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Tue, 20 Feb 2007 14:18:43 +0000
Message-ID: <20070220141843.1405.56344.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

linux/irq.h uses EINVAL but does not #include linux/errno.h.  This results in
the compiler spitting out errors on some files.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 include/linux/irq.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index aa5b3e6..a0818be 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -18,6 +18,7 @@
 #include <linux/spinlock.h>
 #include <linux/cpumask.h>
 #include <linux/irqreturn.h>
+#include <linux/errno.h>
 
 #include <asm/irq.h>
 #include <asm/ptrace.h>
