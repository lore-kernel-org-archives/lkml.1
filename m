Return-Path: <linux-kernel-owner+w=401wt.eu-S1758465AbZAMB4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465AbZAMB4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758340AbZAMBzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:55:41 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38405 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758185AbZAMBzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:55:40 -0500
Message-ID: <496BF4AA.5090204@redhat.com>
Date: Mon, 12 Jan 2009 20:55:54 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH -mm 3/6] kprobes: cleanup comment style in kprobes.h
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix comment style in kprobes.h.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 include/linux/kprobes.h |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Index: 2.6.28-mm1/include/linux/kprobes.h
===================================================================
--- 2.6.28-mm1.orig/include/linux/kprobes.h
+++ 2.6.28-mm1/include/linux/kprobes.h
@@ -90,12 +90,16 @@ struct kprobe {
 	/* Called after addr is executed, unless... */
 	kprobe_post_handler_t post_handler;

-	/* ... called if executing addr causes a fault (eg. page fault).
-	 * Return 1 if it handled fault, otherwise kernel will see it. */
+	/*
+	 * ... called if executing addr causes a fault (eg. page fault).
+	 * Return 1 if it handled fault, otherwise kernel will see it.
+	 */
 	kprobe_fault_handler_t fault_handler;

-	/* ... called if breakpoint trap occurs in probe handler.
-	 * Return 1 if it handled break, otherwise kernel will see it. */
+	/*
+	 * ... called if breakpoint trap occurs in probe handler.
+	 * Return 1 if it handled break, otherwise kernel will see it.
+	 */
 	kprobe_break_handler_t break_handler;

 	/* Saved opcode (which has been replaced with breakpoint) */
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com




