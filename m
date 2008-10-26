Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbYJZAZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbYJZAZh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 20:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbYJZAZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 20:25:28 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:12360 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbYJZAZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 20:25:28 -0400
Date: Sat, 25 Oct 2008 17:24:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 2.6.28-rc1++ resend] docbooks: fix fatal filename errors
Message-Id: <20081025172436.aaac22d4.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
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

Fix docbook fatal errors (file location changed):

docproc: lin2628-rc1/include/asm-x86/io_32.h: No such file or directory
make[1]: *** [Documentation/DocBook/deviceiobook.xml] Error 1

docproc: lin2628-rc1/include/asm-x86/atomic_32.h: No such file or directory
make[1]: *** [Documentation/DocBook/kernel-api.xml] Error 1

docproc: lin2628-rc1/include/asm-x86/mca_dma.h: No such file or directory
make[1]: *** [Documentation/DocBook/mcabook.xml] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/deviceiobook.tmpl   |    2 +-
 Documentation/DocBook/kernel-api.tmpl     |   10 +++++-----
 Documentation/DocBook/kernel-hacking.tmpl |    4 ++--
 Documentation/DocBook/mcabook.tmpl        |    2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

--- linux-2.6.28-rc1-git1.orig/Documentation/DocBook/deviceiobook.tmpl
+++ linux-2.6.28-rc1-git1/Documentation/DocBook/deviceiobook.tmpl
@@ -316,7 +316,7 @@ CPU B:  spin_unlock_irqrestore(&amp;dev_
 
   <chapter id="pubfunctions">
      <title>Public Functions Provided</title>
-!Iinclude/asm-x86/io_32.h
+!Iarch/x86/include/asm/io_32.h
 !Elib/iomap.c
   </chapter>
 
--- linux-2.6.28-rc1-git1.orig/Documentation/DocBook/kernel-api.tmpl
+++ linux-2.6.28-rc1-git1/Documentation/DocBook/kernel-api.tmpl
@@ -45,8 +45,8 @@
      </sect1>
 
      <sect1><title>Atomic and pointer manipulation</title>
-!Iinclude/asm-x86/atomic_32.h
-!Iinclude/asm-x86/unaligned.h
+!Iarch/x86/include/asm/atomic_32.h
+!Iarch/x86/include/asm/unaligned.h
      </sect1>
 
      <sect1><title>Delaying, scheduling, and timer routines</title>
@@ -119,7 +119,7 @@ X!Ilib/string.c
 !Elib/string.c
      </sect1>
      <sect1><title>Bit Operations</title>
-!Iinclude/asm-x86/bitops.h
+!Iarch/x86/include/asm/bitops.h
      </sect1>
   </chapter>
 
@@ -155,7 +155,7 @@ X!Ilib/string.c
 !Emm/slab.c
      </sect1>
      <sect1><title>User Space Memory Access</title>
-!Iinclude/asm-x86/uaccess_32.h
+!Iarch/x86/include/asm/uaccess_32.h
 !Earch/x86/lib/usercopy_32.c
      </sect1>
      <sect1><title>More Memory Management Functions</title>
@@ -265,7 +265,7 @@ X!Earch/x86/kernel/mca_32.c
 -->
 	</sect2>
 	<sect2><title>MCA Bus DMA</title>
-!Iinclude/asm-x86/mca_dma.h
+!Iarch/x86/include/asm/mca_dma.h
 	</sect2>
      </sect1>
   </chapter>
--- linux-2.6.28-rc1-git1.orig/Documentation/DocBook/mcabook.tmpl
+++ linux-2.6.28-rc1-git1/Documentation/DocBook/mcabook.tmpl
@@ -101,7 +101,7 @@
 
   <chapter id="dmafunctions">
      <title>DMA Functions Provided</title>
-!Iinclude/asm-x86/mca_dma.h
+!Iarch/x86/include/asm/mca_dma.h
   </chapter>
 
 </book>
--- linux-2.6.28-rc1-git1.orig/Documentation/DocBook/kernel-hacking.tmpl
+++ linux-2.6.28-rc1-git1/Documentation/DocBook/kernel-hacking.tmpl
@@ -1239,7 +1239,7 @@ static struct block_device_operations op
   </para>
 
   <para>
-   <filename>include/asm-x86/delay_32.h:</filename>
+   <filename>arch/x86/include/asm/delay.h:</filename>
   </para>
   <programlisting>
 #define ndelay(n) (__builtin_constant_p(n) ? \
@@ -1265,7 +1265,7 @@ static struct block_device_operations op
 </programlisting>
 
   <para>
-   <filename>include/asm-x86/uaccess_32.h:</filename>
+   <filename>arch/x86/include/asm/uaccess_32.h:</filename>
   </para>
 
   <programlisting>
