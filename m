Return-Path: <linux-kernel-owner+w=401wt.eu-S1761642AbXGXDVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761642AbXGXDVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 23:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755959AbXGXDVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 23:21:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314AbXGXDVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 23:21:08 -0400
Date: Mon, 23 Jul 2007 23:21:04 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200707240321.l6O3L4Kk015702@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] tiny signalfd cleanup
Cc: akpm@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is probably a leftover from a time when the return wasn't there yet.
Now the extra assignment is just irritating.

Signed-off-by: Ulrich Drepper <drepper@redhat.com>

--- fs/signalfd.c	2007-06-29 10:24:04.000000000 -0700
+++ fs/signalfd.c-new	2007-07-23 20:17:34.000000000 -0700
@@ -320,7 +320,7 @@
 
 	if (sizemask != sizeof(sigset_t) ||
 	    copy_from_user(&sigmask, user_mask, sizeof(sigmask)))
-		return error = -EINVAL;
+		return -EINVAL;
 	sigdelsetmask(&sigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
 	signotset(&sigmask);
 
