Return-Path: <linux-kernel-owner+w=401wt.eu-S1760205AbXJMETc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205AbXJMETc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 00:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbXJMESw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 00:18:52 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:30059 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbXJMESu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 00:18:50 -0400
Date: Fri, 12 Oct 2007 21:17:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 3/5] docbook/kernel-api: fixup x86 path/file names
Message-Id: <20071012211723.98a2d5e6.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix docbook templates for new x86 path/filenames.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/kernel-api.tmpl |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- linux-2.6.23-git2.orig/Documentation/DocBook/kernel-api.tmpl
+++ linux-2.6.23-git2/Documentation/DocBook/kernel-api.tmpl
@@ -45,8 +45,8 @@
      </sect1>
 
      <sect1><title>Atomic and pointer manipulation</title>
-!Iinclude/asm-i386/atomic.h
-!Iinclude/asm-i386/unaligned.h
+!Iinclude/asm-x86/atomic_32.h
+!Iinclude/asm-x86/unaligned_32.h
      </sect1>
 
      <sect1><title>Delaying, scheduling, and timer routines</title>
@@ -119,7 +119,7 @@ X!Ilib/string.c
 !Elib/string.c
      </sect1>
      <sect1><title>Bit Operations</title>
-!Iinclude/asm-i386/bitops.h
+!Iinclude/asm-x86/bitops_32.h
      </sect1>
   </chapter>
 
@@ -155,8 +155,8 @@ X!Ilib/string.c
 !Emm/slab.c
      </sect1>
      <sect1><title>User Space Memory Access</title>
-!Iinclude/asm-i386/uaccess.h
-!Earch/i386/lib/usercopy.c
+!Iinclude/asm-x86/uaccess_32.h
+!Earch/x86/lib/usercopy_32.c
      </sect1>
      <sect1><title>More Memory Management Functions</title>
 !Emm/readahead.c
@@ -293,7 +293,7 @@ X!Ekernel/module.c
      </sect1>
 
      <sect1><title>MTRR Handling</title>
-!Earch/i386/kernel/cpu/mtrr/main.c
+!Earch/x86/kernel/cpu/mtrr/main.c
      </sect1>
 
      <sect1><title>PCI Support Library</title>
@@ -316,14 +316,14 @@ X!Edrivers/pci/hotplug.c
      <sect1><title>MCA Architecture</title>
 	<sect2><title>MCA Device Functions</title>
            <para>
-              Refer to the file arch/i386/kernel/mca.c for more information.
+              Refer to the file arch/x86/kernel/mca_32.c for more information.
            </para>
 <!-- FIXME: Removed for now since no structured comments in source
-X!Earch/i386/kernel/mca.c
+X!Earch/x86/kernel/mca_32.c
 -->
 	</sect2>
 	<sect2><title>MCA Bus DMA</title>
-!Iinclude/asm-i386/mca_dma.h
+!Iinclude/asm-x86/mca_dma.h
 	</sect2>
      </sect1>
   </chapter>
