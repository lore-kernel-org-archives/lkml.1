Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600AbYIDVNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbYIDVNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 17:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbYIDVNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 17:13:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54858 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541AbYIDVNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 17:13:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: wenji.huang@oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH] tracehook: comment pasto fixes
X-Fcc: ~/Mail/linus
Emacs: the answer to the world surplus of CPU cycles.
Message-Id: <20080904211138.1CD9A154248@magilla.localdomain>
Date: Thu,  4 Sep 2008 14:11:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit b380b0d4f7dffcc235c0facefa537d4655619101:
  Al Viro (1):
        forgotten refcount on sysctl root table

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-utrace.git tracehook

Roland McGrath (1):
      tracehook: comment pasto fixes

 include/asm-generic/syscall.h |    2 +-
 include/linux/tracehook.h     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


Thanks,
Roland
---
[PATCH] tracehook: comment pasto fixes

Fix some pasto's in comments in the new
linux/tracehook.h and asm-generic/syscall.h files.

Reported-by: Wenji Huang <wenji.huang@oracle.com>
Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/asm-generic/syscall.h |    2 +-
 include/linux/tracehook.h     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/syscall.h b/include/asm-generic/syscall.h
index abcf34c..ea8087b 100644
--- a/include/asm-generic/syscall.h
+++ b/include/asm-generic/syscall.h
@@ -126,7 +126,7 @@ void syscall_get_arguments(struct task_struct *task, struct pt_regs *regs,
  * @args:	array of argument values to store
  *
  * Changes @n arguments to the system call starting with the @i'th argument.
- * @n'th argument to @val.  Argument @i gets value @args[0], and so on.
+ * Argument @i gets value @args[0], and so on.
  * An arch inline version is probably optimal when @i and @n are constants.
  *
  * It's only valid to call this when @task is stopped for tracing on
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index b48d819..6186a78 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -272,7 +272,7 @@ static inline void tracehook_finish_clone(struct task_struct *child,
  * tracehook_report_clone_complete().  This must prevent the child from
  * self-reaping if tracehook_report_clone_complete() uses the @child
  * pointer; otherwise it might have died and been released by the time
- * tracehook_report_report_clone_complete() is called.
+ * tracehook_report_clone_complete() is called.
  *
  * Called with no locks held, but the child cannot run until this returns.
  */
