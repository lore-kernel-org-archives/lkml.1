Return-Path: <linux-kernel-owner+w=401wt.eu-S1751995AbZDLQh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbZDLQh0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 12:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbZDLQhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 12:37:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:45847 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbZDLQhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 12:37:10 -0400
Date: Sun, 12 Apr 2009 16:36:32 GMT
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jaswinder@kernel.org, tglx@linutronix.de, mingo@elte.hu,
       jaswinderrajput@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, tglx@linutronix.de, jaswinderrajput@gmail.com,
       mingo@elte.hu
In-Reply-To: <1239548845.4170.2.camel@localhost.localdomain>
References: <1239548845.4170.2.camel@localhost.localdomain>
Subject: [tip:x86/cleanups] x86: vdso/vma.c declare vdso_enabled and arch_setup_additional_pages before they get used
Message-ID: <tip-3fa89ca7ba5ba50b3924a11f6604b4bdce5f7842@git.kernel.org>
Git-Commit-ID: 3fa89ca7ba5ba50b3924a11f6604b4bdce5f7842
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 12 Apr 2009 16:36:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3fa89ca7ba5ba50b3924a11f6604b4bdce5f7842
Gitweb:     http://git.kernel.org/tip/3fa89ca7ba5ba50b3924a11f6604b4bdce5f7842
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Sun, 12 Apr 2009 20:37:25 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 12 Apr 2009 18:35:02 +0200

x86: vdso/vma.c declare vdso_enabled and arch_setup_additional_pages before they get used

Impact: cleanup, address sparse warnings

Addresses the problem pointed out by these sparse warning:
  arch/x86/vdso/vma.c:19:28: warning: symbol 'vdso_enabled' was not declared. Should it be static?
  arch/x86/vdso/vma.c:101:5: warning: symbol 'arch_setup_additional_pages' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
LKML-Reference: <1239548845.4170.2.camel@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/vdso/vma.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 7133cdf..cac0833 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -8,6 +8,7 @@
 #include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/random.h>
+#include <linux/elf.h>
 #include <asm/vsyscall.h>
 #include <asm/vgtod.h>
 #include <asm/proto.h>
