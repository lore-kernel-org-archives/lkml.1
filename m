Return-Path: <linux-kernel-owner+w=401wt.eu-S932564AbXC1P41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbXC1P41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 11:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932567AbXC1P41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 11:56:27 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:33243 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932564AbXC1P40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 11:56:26 -0400
Subject: [PATCH 2.6.21-rc5-mm2] add compile.h dependency for
	missing_syscalls.o in init/Makefile
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain
Organization: HP/OSLO
Date: Wed, 28 Mar 2007 11:56:01 -0400
Message-Id: <1175097361.5644.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PATCH 2.6.21-rc5-mm2:  add compile.h dependency for missing_syscalls.o

Add a dependency on include/linux/compile.h to missing_syscalls.o
target in init/Makefile.  Without this, [ia64] build fails with:

init/missing_syscalls.c:5:27: error: linux/compile.h: No such file or directory
In file included from init/missing_syscalls.c:97:

Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>

 init/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: Linux/init/Makefile
===================================================================
--- Linux.orig/init/Makefile	2007-03-28 10:44:14.000000000 -0400
+++ Linux/init/Makefile	2007-03-28 11:02:59.000000000 -0400
@@ -21,7 +21,7 @@ clean-files := ../include/linux/compile.
 # dependencies on generated files need to be listed explicitly
 
 $(obj)/version.o: include/linux/compile.h
-$(obj)/missing_syscalls.o: $(obj)/missing_syscalls.h
+$(obj)/missing_syscalls.o: $(obj)/missing_syscalls.h include/linux/compile.h
 
 # compile.h changes depending on hostname, generation number, etc,
 # so we regenerate it always.


