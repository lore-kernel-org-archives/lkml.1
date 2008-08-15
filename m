Return-Path: <linux-kernel-owner+w=401wt.eu-S1757228AbYHOQpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbYHOQpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 12:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760457AbYHOQpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 12:45:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48649 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756892AbYHOQpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 12:45:24 -0400
Date: Fri, 15 Aug 2008 12:45:22 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ftrace: merge fix up
Message-ID: <alpine.DEB.1.10.0808151244430.2188@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Somehow we got two calls to ftrace_init.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 init/main.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-tip.git/init/main.c
===================================================================
--- linux-tip.git.orig/init/main.c	2008-08-15 11:22:19.000000000 -0400
+++ linux-tip.git/init/main.c	2008-08-15 12:43:41.000000000 -0400
@@ -824,8 +824,6 @@ asmlinkage void __init start_kernel(void
 
 	ftrace_init();
 
-	ftrace_init();
-
 	/* Do the rest non-__init'ed, we're now alive */
 	rest_init();
 }

