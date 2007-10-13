Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbXJMETL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbXJMETL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 00:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbXJMESv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 00:18:51 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:13756 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbXJMESu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 00:18:50 -0400
Date: Fri, 12 Oct 2007 21:17:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 2/5] docbook/kernel-hacking: fixup x86 path/file names
Message-Id: <20071012211712.2d8f54ff.randy.dunlap@oracle.com>
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

Fix docbook templates for modified x86 path/filenames.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/kernel-hacking.tmpl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.23-git2.orig/Documentation/DocBook/kernel-hacking.tmpl
+++ linux-2.6.23-git2/Documentation/DocBook/kernel-hacking.tmpl
@@ -1239,7 +1239,7 @@ static struct block_device_operations op
   </para>
 
   <para>
-   <filename>include/asm-i386/delay.h:</filename>
+   <filename>include/asm-x86/delay_32.h:</filename>
   </para>
   <programlisting>
 #define ndelay(n) (__builtin_constant_p(n) ? \
@@ -1265,7 +1265,7 @@ static struct block_device_operations op
 </programlisting>
 
   <para>
-   <filename>include/asm-i386/uaccess.h:</filename>
+   <filename>include/asm-x86/uaccess_32.h:</filename>
   </para>
 
   <programlisting>
