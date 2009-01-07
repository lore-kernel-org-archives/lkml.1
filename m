Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbZAGEtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbZAGEtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 23:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754803AbZAGEte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 23:49:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36451 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZAGEtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 23:49:33 -0500
Date: Tue, 6 Jan 2009 23:49:17 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH] powerpc: enable dynamic ftrace
Message-ID: <alpine.DEB.1.10.0901062346360.16964@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The PowerPC changes are now in mainline, you can now enable
dynamic ftrace on PowerPC.

The following patch is in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: ppc/ftrace-enable


Steven Rostedt (1):
      powerpc: enable dynamic ftrace

----
 arch/powerpc/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)
---------------------------
commit 6a3c90c30ff47ca69e6315ca8968470a628585f5
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Thu Nov 20 07:55:57 2008 -0800

    powerpc: enable dynamic ftrace
    
    Impact: let PowerPC compile with dynamic ftrace
    
    This patch enables dynamic ftrace. The PowerPC port was dependent on
    other code not yet in mainline. Now that the code is, we can now
    let PowerPC compile with dynamic ftrace.
    
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 79f25ce..6d4ae3f 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -108,6 +108,8 @@ config ARCH_NO_VIRT_TO_BUS
 config PPC
 	bool
 	default y
+	select HAVE_FTRACE_MCOUNT_RECORD
+	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_TRACER
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_IDE

