Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbYCOXiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbYCOXiY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 19:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbYCOXiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 19:38:15 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:55148 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbYCOXiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 19:38:15 -0400
Date: Sat, 15 Mar 2008 16:37:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: mporter@kernel.crashing.org, akpm <akpm@linux-foundation.org>
Subject: [PATCH -mm] rapidio: fix docbook references
Message-Id: <20080315163747.62366079.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix rapidio docbook (file was removed) and fix header file kernel-doc.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/rapidio.tmpl |    1 -
 include/linux/rio.h                |    4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

--- mmotm-2008-0314-1449.orig/Documentation/DocBook/rapidio.tmpl
+++ mmotm-2008-0314-1449/Documentation/DocBook/rapidio.tmpl
@@ -133,7 +133,6 @@
 !Idrivers/rapidio/rio-sysfs.c
      </sect1>
      <sect1 id="PPC32_support"><title>PPC32 support</title>
-!Iarch/powerpc/kernel/rio.c
 !Earch/powerpc/sysdev/fsl_rio.c
 !Iarch/powerpc/sysdev/fsl_rio.c
      </sect1>
--- mmotm-2008-0314-1449.orig/include/linux/rio.h
+++ mmotm-2008-0314-1449/include/linux/rio.h
@@ -327,7 +327,7 @@ struct rio_route_ops {
 };
 
 /**
- * Struct for RIO memory definition.
+ * struct rio_mem - struct for RIO memory definition.
  * @node: Node in list of memories
  * @virt: The virtual address for mapped memory accessing.
  * @owner: The owner id of this memory.
@@ -346,7 +346,7 @@ struct rio_mem {
 };
 
 /**
- * Struct for RIO memory definition.
+ * struct rio_mem_ops - Struct for RIO memory operations definition.
  * @map_inb: The function for mapping inbound memory window.
  * @map_outb: The function for mapping outbound memory window.
  * @unmap_inb: The function for unmapping inbound memory window.
