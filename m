Return-Path: <linux-kernel-owner+w=401wt.eu-S1764367AbYCEV5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764367AbYCEV5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762857AbYCEV4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:56:41 -0500
Received: from c60.cesmail.net ([216.154.195.49]:28684 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764126AbYCEV4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:56:39 -0500
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] sched: make task_nice available to non-GPL modules
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Date: Wed, 05 Mar 2008 16:56:37 -0500
Message-ID: <20080305215637.7767.99635.stgit@dv.roinet.com>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The API is trivial, and so is the implementation.  Linux priorities are
exposed to the userspace, so nobody should claim that software aware of
Linux priorities is a derived work of the kernel.

The complementary function set_user_nice() is available to non-GPL
modules.  If the module can set the priority, it should be able to read
it back.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index dcd553c..6db6e0c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4422,7 +4422,7 @@ int task_nice(const struct task_struct *p)
 {
 	return TASK_NICE(p);
 }
-EXPORT_SYMBOL_GPL(task_nice);
+EXPORT_SYMBOL(task_nice);
 
 /**
  * idle_cpu - is a given cpu idle currently?
