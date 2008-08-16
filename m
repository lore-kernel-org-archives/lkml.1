Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbYHPWjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbYHPWjx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 18:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbYHPWjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 18:39:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:43999 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252AbYHPWje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 18:39:34 -0400
Subject: patch uml-stub-needs-to-tolerate-sigwinch.patch added to 2.6.25-stable tree
To: jdike@addtoit.com, akpm@linux-foundation.org, benedict.verheyen@gmail.com,
       gregkh@suse.de, jdike@linux.intel.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org,
       user-mode-linux-devel@lists.sourceforge.net
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@suse.de>
Date: Sat, 16 Aug 2008 15:32:46 -0700
In-Reply-To: <20080805201409.GA11798@c2.user-mode-linux.org>
Message-Id: <20080816223932.978D51454450@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that we have just queued up the patch titled

    Subject: uml: stub needs to tolerate SIGWINCH

to the 2.6.25-stable tree.  Its filename is

    uml-stub-needs-to-tolerate-sigwinch.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Tue Aug  5 13:15:05 2008
From: Jeff Dike <jdike@addtoit.com>
Date: Tue, 5 Aug 2008 16:14:09 -0400
Subject: uml: stub needs to tolerate SIGWINCH
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Message-ID: <20080805201409.GA11798@c2.user-mode-linux.org>
Content-Disposition: inline

From: Jeff Dike <jdike@addtoit.com>

commit 3d5ede6f776bdb1483bcd086f79c3bf41fed3865 upstream

We lost the marking of SIGWINCH as being OK to receive during stub
execution, causing a panic should that happen.

Cc: Benedict Verheyen <benedict.verheyen@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/os-Linux/skas/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -55,7 +55,7 @@ static int ptrace_dump_regs(int pid)
  * Signals that are OK to receive in the stub - we'll just continue it.
  * SIGWINCH will happen when UML is inside a detached screen.
  */
-#define STUB_SIG_MASK (1 << SIGVTALRM)
+#define STUB_SIG_MASK ((1 << SIGVTALRM) | (1 << SIGWINCH))
 
 /* Signals that the stub will finish with - anything else is an error */
 #define STUB_DONE_MASK (1 << SIGTRAP)


Patches currently in stable-queue which might be from jdike@addtoit.com are

queue-2.6.25/uml-fix-build-when-slob-is-enabled.patch
queue-2.6.25/uml-fix-bad-ntp-interaction-with-clock.patch
queue-2.6.25/uml-physical-memory-shouldn-t-include-initial-stack.patch
queue-2.6.25/uml-track-and-make-up-lost-ticks.patch
queue-2.6.25/uml-missed-kmalloc-in-pcap_user.c.patch
queue-2.6.25/uml-deal-with-host-time-going-backwards.patch
queue-2.6.25/uml-deal-with-inaccessible-address-space-start.patch
queue-2.6.25/uml-missing-export-of-csum_partial-on-uml-amd64.patch
queue-2.6.25/uml-memcpy-export-needs-to-follow-host-declaration.patch
queue-2.6.25/uml-stub-needs-to-tolerate-sigwinch.patch
queue-2.6.25/uml-work-around-broken-host-ptrace_sysemu.patch
queue-2.6.25/uml-fix-gcc-ices-and-unresolved-externs.patch
queue-2.6.25/uml-fix-boot-crash.patch
