Return-Path: <linux-kernel-owner+w=401wt.eu-S1758418AbZD0OrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418AbZD0OrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 10:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756941AbZD0OmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 10:42:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61010 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757133AbZD0OmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 10:42:16 -0400
Message-Id: <20090427143739.584082891@arndb.de>
From: <arnd@arndb.de>
To: unlisted-recipients:; (no To-header on input)
Date: Mon, 27 Apr 2009 10:42:16 -0400
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From arnd@arndb.de Mon Apr 27 16:28:40 2009
References: <20090427142010.587518220@arndb.de>
User-Agent: quilt/0.46-1
Date: Mon, 27 Apr 2009 16:20:24 +0200
From: arnd@arndb.de
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com,
 monstr@monstr.eu,
 linux-api@vger.kernel.org,
 linux-arch@vger.kernel.org,
 liqin.chen@sunplusct.com,
 Sam Ravnborg <sam@ravnborg.org>
Subject: [RFC 14/17] syscalls.h add the missing sys_pipe2 declaration
Content-Disposition: inline; filename=0034-Add-the-missing-sys_pipe2-declaration.patch
X-Provags-ID: V01U2FsdGVkX18BNhYLkO16wJIO7fZdR0d6C1KKxWKU4X9yTw1
 kHYWFxFh/i+KLpzMQTnyQq6hXXodV+gYI/28GueZLh1YDCU7wt
 Ve65kcnRHOC2kZYsfpLWg==

In order to build the generic syscall table, we need a declaration
for every system call. sys_pipe2 was added without a proper declaration,
so add this to syscalls.h now.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/syscalls.h |    1 	1 +	0 -	0 !
 1 file changed, 1 insertion(+)

Index: linux-2.6/include/linux/syscalls.h
===================================================================
--- linux-2.6.orig/include/linux/syscalls.h
+++ linux-2.6/include/linux/syscalls.h
@@ -433,6 +433,7 @@ asmlinkage long sys_fcntl(unsigned int f
 asmlinkage long sys_fcntl64(unsigned int fd,
 				unsigned int cmd, unsigned long arg);
 #endif
+asmlinkage long sys_pipe2(int __user *fildes, int flags);
 asmlinkage long sys_dup(unsigned int fildes);
 asmlinkage long sys_dup2(unsigned int oldfd, unsigned int newfd);
 asmlinkage long sys_dup3(unsigned int oldfd, unsigned int newfd, int flags);

-- 

