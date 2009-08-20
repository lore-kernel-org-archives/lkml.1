Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbZHTXNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbZHTXNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 19:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbZHTXNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 19:13:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:49947 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755428AbZHTXNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 19:13:21 -0400
Date: Thu, 20 Aug 2009 23:13:00 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de
In-Reply-To: <4A8D84670200007800010D31@vpn.id2.novell.com>
References: <4A8D84670200007800010D31@vpn.id2.novell.com>
Subject: [tip:x86/urgent] x86: add vmlinux.lds to targets in arch/x86/boot/compressed/Makefile
Message-ID: <tip-fc0ce23506d943b9eaa731a051769d0e0605eb03@git.kernel.org>
Git-Commit-ID: fc0ce23506d943b9eaa731a051769d0e0605eb03
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 20 Aug 2009 23:13:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc0ce23506d943b9eaa731a051769d0e0605eb03
Gitweb:     http://git.kernel.org/tip/fc0ce23506d943b9eaa731a051769d0e0605eb03
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Thu, 20 Aug 2009 16:14:15 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 20 Aug 2009 16:08:58 -0700

x86: add vmlinux.lds to targets in arch/x86/boot/compressed/Makefile

The absence of vmlinux.lds here keeps .vmlinux.lds.cmd from being
included, which in turn leads to it and all its dependents always
getting rebuilt independent of whether they are already up-to-date.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <4A8D84670200007800010D31@vpn.id2.novell.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


---
 arch/x86/boot/compressed/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index e2ff504..f8ed065 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -4,7 +4,7 @@
 # create a compressed vmlinux image from the original vmlinux
 #
 
-targets := vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma head_$(BITS).o misc.o piggy.o
+targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma head_$(BITS).o misc.o piggy.o
 
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
 KBUILD_CFLAGS += -fno-strict-aliasing -fPIC
