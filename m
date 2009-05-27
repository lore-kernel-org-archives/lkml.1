Return-Path: <linux-kernel-owner+w=401wt.eu-S1759662AbZE0Su1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759662AbZE0Su1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756674AbZE0SuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:50:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47622 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756410AbZE0SuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:50:17 -0400
Date: Thu, 28 May 2009 03:50:16 +0900 (JST)
Message-Id: <20090528.035016.930425077028184727.yamato@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove duplicated declarations for sys_pipe2
From: Masatake YAMATO <yamato@redhat.com>
Organization: Red Hat Japan, Inc.
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

sys_pipe2 is declared twice in include/linux/syscalls.h.



Signed-off-by: Masatake YAMATO <yamato@redhat.com>


diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 3052084..66b6203 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -433,6 +433,7 @@ asmlinkage long sys_fcntl(unsigned int fd, unsigned int cmd, unsigned long arg);
 asmlinkage long sys_fcntl64(unsigned int fd,
 				unsigned int cmd, unsigned long arg);
 #endif
+asmlinkage long sys_pipe(int __user *fildes);
 asmlinkage long sys_pipe2(int __user *fildes, int flags);
 asmlinkage long sys_dup(unsigned int fildes);
 asmlinkage long sys_dup2(unsigned int oldfd, unsigned int newfd);
@@ -750,8 +751,6 @@ asmlinkage long sys_pselect6(int, fd_set __user *, fd_set __user *,
 asmlinkage long sys_ppoll(struct pollfd __user *, unsigned int,
 			  struct timespec __user *, const sigset_t __user *,
 			  size_t);
-asmlinkage long sys_pipe2(int __user *, int);
-asmlinkage long sys_pipe(int __user *);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
