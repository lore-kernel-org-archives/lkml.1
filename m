Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab0CBGIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 01:08:17 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:29102 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab0CBGIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 01:08:14 -0500
Date: Mon, 1 Mar 2010 22:06:25 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] docbook: fix errors from x86 headers merger
Message-Id: <20100301220625.bad46c19.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B8CAB43.0031:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix docbook errors for x86 headers that were recently merged:

docproc: arch/x86/include/asm/atomic_32.h: No such file or directory
docproc: arch/x86/include/asm/io_32.h: No such file or directory

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Brian Gerst <brgerst@gmail.com>
---
 Documentation/DocBook/device-drivers.tmpl |    2 +-
 Documentation/DocBook/deviceiobook.tmpl   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.33-git7.orig/Documentation/DocBook/device-drivers.tmpl
+++ linux-2.6.33-git7/Documentation/DocBook/device-drivers.tmpl
@@ -45,7 +45,7 @@
      </sect1>
 
      <sect1><title>Atomic and pointer manipulation</title>
-!Iarch/x86/include/asm/atomic_32.h
+!Iarch/x86/include/asm/atomic.h
 !Iarch/x86/include/asm/unaligned.h
      </sect1>
 
--- linux-2.6.33-git7.orig/Documentation/DocBook/deviceiobook.tmpl
+++ linux-2.6.33-git7/Documentation/DocBook/deviceiobook.tmpl
@@ -316,7 +316,7 @@ CPU B:  spin_unlock_irqrestore(&amp;dev_
 
   <chapter id="pubfunctions">
      <title>Public Functions Provided</title>
-!Iarch/x86/include/asm/io_32.h
+!Iarch/x86/include/asm/io.h
 !Elib/iomap.c
   </chapter>
 
