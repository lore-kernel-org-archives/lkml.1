Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbZFSHkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbZFSHkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 03:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbZFSHkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 03:40:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53765 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbZFSHka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 03:40:30 -0400
Date: Fri, 19 Jun 2009 03:40:26 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, sam@ravnborg.org,
       Amerigo Wang <amwang@redhat.com>
Message-Id: <20090619074241.6646.42298.sendpatchset@localhost.localdomain>
Subject: [Patch] kbuild: finally remove the obsolete variable $TOPDIR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


TOPDIR is obsolete, it can be finally removed now.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Sam <sam@ravnborg.org>

---
diff --git a/Makefile b/Makefile
index 46e1c9d..6e41628 100644
--- a/Makefile
+++ b/Makefile
@@ -140,15 +140,13 @@ _all: modules
 endif
 
 srctree		:= $(if $(KBUILD_SRC),$(KBUILD_SRC),$(CURDIR))
-TOPDIR		:= $(srctree)
-# FIXME - TOPDIR is obsolete, use srctree/objtree
 objtree		:= $(CURDIR)
 src		:= $(srctree)
 obj		:= $(objtree)
 
 VPATH		:= $(srctree)$(if $(KBUILD_EXTMOD),:$(KBUILD_EXTMOD))
 
-export srctree objtree VPATH TOPDIR
+export srctree objtree VPATH
 
 
 # SUBARCH tells the usermode build what the underlying arch is.  That is set
diff --git a/drivers/scsi/cxgb3i/Kbuild b/drivers/scsi/cxgb3i/Kbuild
index 25a2032..70d060b 100644
--- a/drivers/scsi/cxgb3i/Kbuild
+++ b/drivers/scsi/cxgb3i/Kbuild
@@ -1,4 +1,4 @@
-EXTRA_CFLAGS += -I$(TOPDIR)/drivers/net/cxgb3
+EXTRA_CFLAGS += -I$(srctree)/drivers/net/cxgb3
 
 cxgb3i-y := cxgb3i_init.o cxgb3i_iscsi.o cxgb3i_pdu.o cxgb3i_offload.o cxgb3i_ddp.o
 obj-$(CONFIG_SCSI_CXGB3_ISCSI) += cxgb3i.o
