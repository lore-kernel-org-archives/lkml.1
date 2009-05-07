Return-Path: <linux-kernel-owner+w=401wt.eu-S1762707AbZEGJcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762707AbZEGJcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762091AbZEGJ0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:26:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:45184 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762081AbZEGJ02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:26:28 -0400
Date: Thu, 7 May 2009 09:25:57 GMT
From: tip-bot for Markus Metzger <markus.t.metzger@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       markus.t.metzger@intel.com, oleg@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, oleg@redhat.com,
       mingo@elte.hu
In-Reply-To: <20090424094448.A30216@sedona.ch.intel.com>
References: <20090424094448.A30216@sedona.ch.intel.com>
Subject: [tip:tracing/core] x86, bts: reenable ptrace branch trace support
Message-ID: <tip-7e0bfad24d85de7cf2202a7b0ce51de11a077b21@git.kernel.org>
Git-Commit-ID: 7e0bfad24d85de7cf2202a7b0ce51de11a077b21
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 07 May 2009 09:25:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7e0bfad24d85de7cf2202a7b0ce51de11a077b21
Gitweb:     http://git.kernel.org/tip/7e0bfad24d85de7cf2202a7b0ce51de11a077b21
Author:     Markus Metzger <markus.t.metzger@intel.com>
AuthorDate: Fri, 24 Apr 2009 09:44:48 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 24 Apr 2009 10:18:51 +0200

x86, bts: reenable ptrace branch trace support

The races found by Oleg Nesterov have been fixed.

Reenable branch trace support.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
LKML-Reference: <20090424094448.A30216@sedona.ch.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/Kconfig.cpu |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 8130334..924e156 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -506,7 +506,6 @@ config X86_PTRACE_BTS
 	bool "Branch Trace Store"
 	default y
 	depends on X86_DEBUGCTLMSR
-	depends on BROKEN
 	---help---
 	  This adds a ptrace interface to the hardware's branch trace store.
 
