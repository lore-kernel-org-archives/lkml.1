Return-Path: <linux-kernel-owner+w=401wt.eu-S1755751AbZGGJHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbZGGJHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 05:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbZGGJHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 05:07:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:44260 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700AbZGGJHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 05:07:22 -0400
Date: Tue, 7 Jul 2009 09:06:58 GMT
From: tip-bot for Arnd Bergmann <arnd@arndb.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <200907071023.44008.arnd@arndb.de>
References: <200907071023.44008.arnd@arndb.de>
Subject: [tip:core/urgent] signals: declare sys_rt_tgsigqueueinfo in syscalls.h
Message-ID: <tip-7afdbf23c3acdec3eaf1b94f87132fff3d81ce73@git.kernel.org>
Git-Commit-ID: 7afdbf23c3acdec3eaf1b94f87132fff3d81ce73
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Jul 2009 09:06:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7afdbf23c3acdec3eaf1b94f87132fff3d81ce73
Gitweb:     http://git.kernel.org/tip/7afdbf23c3acdec3eaf1b94f87132fff3d81ce73
Author:     Arnd Bergmann <arnd@arndb.de>
AuthorDate: Tue, 7 Jul 2009 10:23:43 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 7 Jul 2009 10:51:39 +0200

signals: declare sys_rt_tgsigqueueinfo in syscalls.h

sys_rt_tgsigqueueinfo needs to be declared in linux/syscalls.h so that
architectures defining the system call table in C can reference it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
LKML-Reference: <200907071023.44008.arnd@arndb.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>



---
 include/linux/syscalls.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index fa4242c..80de700 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -321,6 +321,8 @@ asmlinkage long sys_rt_sigtimedwait(const sigset_t __user *uthese,
 				siginfo_t __user *uinfo,
 				const struct timespec __user *uts,
 				size_t sigsetsize);
+asmlinkage long sys_rt_tgsigqueueinfo(pid_t tgid, pid_t  pid, int sig,
+		siginfo_t __user *uinfo);
 asmlinkage long sys_kill(int pid, int sig);
 asmlinkage long sys_tgkill(int tgid, int pid, int sig);
 asmlinkage long sys_tkill(int pid, int sig);
