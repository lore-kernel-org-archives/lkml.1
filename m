Return-Path: <linux-kernel-owner+w=401wt.eu-S1946566AbXBIQGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946566AbXBIQGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946576AbXBIQFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:05:54 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53632 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946566AbXBIQF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:05:28 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] ps3: missing exports
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Message-Id: <E1HFYFb-0004rm-0y@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:05:27 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/powerpc/platforms/ps3/interrupt.c  |    2 ++
 arch/powerpc/platforms/ps3/system-bus.c |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/platforms/ps3/interrupt.c b/arch/powerpc/platforms/ps3/interrupt.c
index bb17283..631c300 100644
--- a/arch/powerpc/platforms/ps3/interrupt.c
+++ b/arch/powerpc/platforms/ps3/interrupt.c
@@ -194,6 +194,7 @@ int ps3_alloc_io_irq(enum ps3_cpu_binding cpu, unsigned int interrupt_id,
 
 	return result;
 }
+EXPORT_SYMBOL_GPL(ps3_alloc_io_irq);
 
 int ps3_free_io_irq(unsigned int virq)
 {
@@ -209,6 +210,7 @@ int ps3_free_io_irq(unsigned int virq)
 
 	return result;
 }
+EXPORT_SYMBOL_GPL(ps3_free_io_irq);
 
 /**
  * ps3_alloc_event_irq - Allocate a virq for use with a system event.
diff --git a/arch/powerpc/platforms/ps3/system-bus.c b/arch/powerpc/platforms/ps3/system-bus.c
index bce6136..a9f7e4a 100644
--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -57,6 +57,7 @@ int ps3_mmio_region_create(struct ps3_mmio_region *r)
 	dump_mmio_region(r);
 	return result;
 }
+EXPORT_SYMBOL_GPL(ps3_mmio_region_create);
 
 int ps3_free_mmio_region(struct ps3_mmio_region *r)
 {
@@ -72,6 +73,7 @@ int ps3_free_mmio_region(struct ps3_mmio_region *r)
 	r->lpar_addr = 0;
 	return result;
 }
+EXPORT_SYMBOL_GPL(ps3_free_mmio_region);
 
 static int ps3_system_bus_match(struct device *_dev,
 	struct device_driver *_drv)
-- 
1.5.0-rc2.GIT


