Return-Path: <linux-kernel-owner+w=401wt.eu-S1760885AbXJMETu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760885AbXJMETu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 00:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbXJMESy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 00:18:54 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:30058 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbXJMESu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 00:18:50 -0400
Date: Fri, 12 Oct 2007 21:17:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/5] docbook/deviceiobook: fixup x86 path/file names
Message-Id: <20071012211700.a45ea1e6.randy.dunlap@oracle.com>
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

Fix docbook templates for new x86 path/filenames:

docproc: linux-2.6.23-git2/include/asm-i386/io.h: No such file or directory

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/deviceiobook.tmpl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-git2.orig/Documentation/DocBook/deviceiobook.tmpl
+++ linux-2.6.23-git2/Documentation/DocBook/deviceiobook.tmpl
@@ -316,7 +316,7 @@ CPU B:  spin_unlock_irqrestore(&amp;dev_
 
   <chapter id="pubfunctions">
      <title>Public Functions Provided</title>
-!Iinclude/asm-i386/io.h
+!Iinclude/asm-x86/io_32.h
 !Elib/iomap.c
   </chapter>
 
