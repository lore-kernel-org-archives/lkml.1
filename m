Return-Path: <linux-kernel-owner+w=401wt.eu-S1761049AbZEKXDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761049AbZEKXDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 19:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759827AbZEKXDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 19:03:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51276 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760713AbZEKXDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 19:03:17 -0400
Message-Id: <200905112303.16371.arnd@arndb.de>
References: <20090511222702.352192505@arndb.de>>
User-Agent: quilt/0.46-1
Date: Mon, 11 May 2009 23:03:16 +0000
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] syscalls.h add the missing sys_pipe2 declaration
Content-Disposition: inline
Cc: linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18GstZVoXhGFAfH3STK6G6EgY7ChsGPpuVflG3
 QCDdFO3TE8ZcDz3Gc4qZTcwyTsM0BXpmyelZ/CvCT3yPTeCgKz
 Cu2sRZMLK4Jwe4w+CgKVw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to build the generic syscall table, we need a declaration
for every system call. sys_pipe2 was added without a proper declaration,
so add this to syscalls.h now.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/syscalls.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 40617c1..3052084 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -433,6 +433,7 @@ asmlinkage long sys_fcntl(unsigned int fd, unsigned int 
cmd, unsigned long arg);
 asmlinkage long sys_fcntl64(unsigned int fd,
 				unsigned int cmd, unsigned long arg);
 #endif
+asmlinkage long sys_pipe2(int __user *fildes, int flags);
 asmlinkage long sys_dup(unsigned int fildes);
 asmlinkage long sys_dup2(unsigned int oldfd, unsigned int newfd);
 asmlinkage long sys_dup3(unsigned int oldfd, unsigned int newfd, int flags);
-- 
1.6.0.4

-- 


