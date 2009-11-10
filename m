Return-Path: <linux-kernel-owner+w=401wt.eu-S1753684AbZKJVMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbZKJVMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 16:12:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbZKJVML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 16:12:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:56928 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbZKJVMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:12:10 -0500
Date: Tue, 10 Nov 2009 21:09:44 GMT
From: tip-bot for Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, travis@sgi.com, tglx@linutronix.de,
       sivanich@sgi.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, travis@sgi.com, tglx@linutronix.de,
       sivanich@sgi.com, mingo@elte.hu
In-Reply-To: <20091110195835.GA4393@sgi.com>
References: <20091110195835.GA4393@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: Remove asm/apicnum.h
Message-ID: <tip-200a9ae2801bc725f2c41ab13f6e0fb1610d2fb6@git.kernel.org>
Git-Commit-ID: 200a9ae2801bc725f2c41ab13f6e0fb1610d2fb6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  200a9ae2801bc725f2c41ab13f6e0fb1610d2fb6
Gitweb:     http://git.kernel.org/tip/200a9ae2801bc725f2c41ab13f6e0fb1610d2fb6
Author:     Dimitri Sivanich <sivanich@sgi.com>
AuthorDate: Tue, 10 Nov 2009 13:58:35 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 22:07:35 +0100

x86: Remove asm/apicnum.h

arch/x86/include/asm/apicnum.h is not referenced anywhere
anymore. Its definitions appear in apicdef.h. Remove it.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Mike Travis <travis@sgi.com>
LKML-Reference: <20091110195835.GA4393@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/apicnum.h |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/apicnum.h b/arch/x86/include/asm/apicnum.h
deleted file mode 100644
index 82f613c..0000000
--- a/arch/x86/include/asm/apicnum.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef _ASM_X86_APICNUM_H
-#define _ASM_X86_APICNUM_H
-
-/* define MAX_IO_APICS */
-#ifdef CONFIG_X86_32
-# define MAX_IO_APICS 64
-#else
-# define MAX_IO_APICS 128
-# define MAX_LOCAL_APIC 32768
-#endif
-
-#endif /* _ASM_X86_APICNUM_H */
