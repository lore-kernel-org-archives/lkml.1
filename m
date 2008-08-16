Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbYHPWji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbYHPWji (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 18:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbYHPWjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 18:39:14 -0400
Received: from mail.suse.de ([195.135.220.2]:43961 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486AbYHPWjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 18:39:11 -0400
Subject: patch uml-path_max-needs-limits.h.patch added to 2.6.25-stable tree
To: mingo@elte.hu, akpm@linux-foundation.org, gregkh@suse.de,
       jdike@linux.intel.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org,
       user-mode-linux-devel@lists.sourceforge.net
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@suse.de>
Date: Sat, 16 Aug 2008 15:32:45 -0700
In-Reply-To: <20080805201411.GA11802@c2.user-mode-linux.org>
Message-Id: <20080816223908.F2DAB1454450@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that we have just queued up the patch titled

    Subject: uml: PATH_MAX needs limits.h

to the 2.6.25-stable tree.  Its filename is

    uml-path_max-needs-limits.h.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Tue Aug  5 13:15:02 2008
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 5 Aug 2008 16:14:11 -0400
Subject: uml: PATH_MAX needs limits.h
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Message-ID: <20080805201411.GA11802@c2.user-mode-linux.org>
Content-Disposition: inline

From: Ingo Molnar <mingo@elte.hu>

commit b6d8adf477439e7086224bc9674c6b6638780783 upstream.

Include limits.h to get a definition of PATH_MAX.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/os-Linux/helper.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/um/os-Linux/helper.c
+++ b/arch/um/os-Linux/helper.c
@@ -7,6 +7,7 @@
 #include <unistd.h>
 #include <errno.h>
 #include <sched.h>
+#include <linux/limits.h>
 #include <sys/socket.h>
 #include <sys/wait.h>
 #include "kern_constants.h"


Patches currently in stable-queue which might be from mingo@elte.hu are

queue-2.6.25/uml-fix-gcc-ices-and-unresolved-externs.patch
queue-2.6.25/uml-path_max-needs-limits.h.patch
