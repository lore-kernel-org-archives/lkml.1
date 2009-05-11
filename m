Return-Path: <linux-kernel-owner+w=401wt.eu-S1760310AbZEKXIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760310AbZEKXIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 19:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756359AbZEKXIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 19:08:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:53111 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845AbZEKXIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 19:08:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] syscalls.h add the missing sys_pipe2 declaration
Date: Mon, 11 May 2009 23:08:20 +0000
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>
References: <20090511222702.352192505@arndb.de> <20090511222702.352192505@arndb.de>> <200905112303.16371.arnd@arndb.de>
In-Reply-To: <200905112303.16371.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905112308.21068.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+DiSL5ZtfkaEjZY8KlnqNNATnHkC/HuEcE7Il
 haEJON6gzFZOzDoUp0X0+GK+imABbg9DRJUl0H22MgLoVRUTep
 R9pNbhtGtOARAoy/UKvhg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to build the generic syscall table, we need a declaration
for every system call. sys_pipe2 was added without a proper declaration,
so add this to syscalls.h now.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
re-sent without the wordwrap...

 include/linux/syscalls.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 40617c1..3052084 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -433,6 +433,7 @@ asmlinkage long sys_fcntl(unsigned int fd, unsigned int cmd, unsigned long arg);
 asmlinkage long sys_fcntl64(unsigned int fd,
 				unsigned int cmd, unsigned long arg);
 #endif
+asmlinkage long sys_pipe2(int __user *fildes, int flags);
 asmlinkage long sys_dup(unsigned int fildes);
 asmlinkage long sys_dup2(unsigned int oldfd, unsigned int newfd);
 asmlinkage long sys_dup3(unsigned int oldfd, unsigned int newfd, int flags);
-- 
1.6.0.4

