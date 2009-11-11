Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbZKKGbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbZKKGbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 01:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbZKKGb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 01:31:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:56453 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbZKKGb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 01:31:28 -0500
Date: Wed, 11 Nov 2009 06:31:07 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, randy.dunlap@oracle.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, randy.dunlap@oracle.com, mingo@elte.hu
In-Reply-To: <4AF9FB6C.70003@oracle.com>
References: <4AF9FB6C.70003@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86 VSDO: Fix Kconfig help
Message-ID: <tip-e84446de5cccd90de7d7ec46527d3b343b022a09@git.kernel.org>
Git-Commit-ID: e84446de5cccd90de7d7ec46527d3b343b022a09
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e84446de5cccd90de7d7ec46527d3b343b022a09
Gitweb:     http://git.kernel.org/tip/e84446de5cccd90de7d7ec46527d3b343b022a09
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Tue, 10 Nov 2009 15:46:52 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 11 Nov 2009 07:26:41 +0100

x86 VSDO: Fix Kconfig help

COMPAT_VDSO has 2 help text blocks, but kconfig only uses the
last one found, so merge the 2 blocks.

It would be real nice if kconfig would warn about this.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
LKML-Reference: <4AF9FB6C.70003@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 72ace95..618dede 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1602,7 +1602,7 @@ config COMPAT_VDSO
 	depends on X86_32 || IA32_EMULATION
 	---help---
 	  Map the 32-bit VDSO to the predictable old-style address too.
-	---help---
+
 	  Say N here if you are running a sufficiently recent glibc
 	  version (2.3.3 or later), to remove the high-mapped
 	  VDSO mapping and to exclusively use the randomized VDSO.
