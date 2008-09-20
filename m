Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbYITAAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbYITAAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 20:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbYITAAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 20:00:06 -0400
Received: from il.qumranet.com ([212.179.150.194]:35593 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020AbYITAAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 20:00:01 -0400
From: Avi Kivity <avi@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] KVM build fix for 2.6.27-rc6
Date: Fri, 19 Sep 2008 17:00:04 -0700
Message-Id: <1221868804-25345-1-git-send-email-avi@redhat.com>
X-Mailer: git-send-email 1.6.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, a recent merge has broken the build for KVM on ia64.  Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git kvm-updates/2.6.27

to fix it.

Shortlog/diffstat/diff below.

Jes Sorensen (1):
      KVM: ia64: 'struct fdesc' build fix

 arch/ia64/kvm/kvm-ia64.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 7a37d06..cd0d1a7 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -38,6 +38,7 @@
 #include <asm/cacheflush.h>
 #include <asm/div64.h>
 #include <asm/tlb.h>
+#include <asm/elf.h>
 
 #include "misc.h"
 #include "vti.h"
@@ -61,12 +62,6 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ NULL }
 };
 
-
-struct fdesc{
-    unsigned long ip;
-    unsigned long gp;
-};
-
 static void kvm_flush_icache(unsigned long start, unsigned long len)
 {
 	int l;
